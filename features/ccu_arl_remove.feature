Feature: akamai_api ccu arl remove
  In order to remove ARLs
  As a CLI user

  @vcr
  Scenario: invalid credentials
    When I run `akamai_api ccu arl remove http://www.foo.com/bar.txt -u foo -p bar`
    Then the output should contain:
      """
      Your login credentials are invalid.
      """

  @vcr
  Scenario: invalid item
    When I run `akamai_api ccu arl remove http://www.foo.com/bar.txt`
    Then the output should contain:
      """
      There was an error processing your request:
      """
    And the output should contain:
      """
      * Result: 403 - unauthorized arl (http://www.foo.com/bar.txt)
      """
    And the output should contain:
      """
      * Described by: https://api.ccu.akamai.com/ccu/v2/errors/unauthorized-arl
      """

  @vcr
  Scenario: single item
    When I run `akamai_api ccu arl remove http://www.foo.com/bar.txt`
    Then the output should contain:
      """
      Purge request successfully submitted:
      """
    And the output should contain:
      """
      * Result: 201 - Request accepted.
      """
    And the output should contain:
      """
      * Purge ID: 12345678-1234-1234-1234-123456789012 | Support ID: 12345678901234567890-123456789
      """
    And the output should contain:
      """
      * Estimated time: 420 secs.
      """
    And the output should contain:
      """
      * Progress URI: /ccu/v2/purges/12345678-1234-5678-1234-123456789012
      """
    And the output should contain:
      """
      * Time to wait before check: 420 secs.
      """

  @vcr
  Scenario: multiple items
    When I run `akamai_api ccu arl remove http://www.foo.com/bar.txt http://www.foo.com/baz.txt`
    Then the output should contain:
      """
      Purge request successfully submitted:
      """
    And the output should contain:
      """
      * Result: 201 - Request accepted.
      """
    And the output should contain:
      """
      * Purge ID: 12345678-1234-1234-1234-123456789012 | Support ID: 12345678901234567890-123456789
      """
    And the output should contain:
      """
      * Estimated time: 420 secs.
      """
    And the output should contain:
      """
      * Progress URI: /ccu/v2/purges/12345678-1234-5678-1234-123456789012
      """
    And the output should contain:
      """
      * Time to wait before check: 420 secs.
      """

  @vcr
  Scenario: not found request
    When I run `akamai_api ccu status foobarbaz`
    Then the output should contain:
      """
      No purge request found using /ccu/v2/purges/foobarbaz:
      """
    And the output should contain:
      """
      Result: 200 - Please note that it can take up to a minute for the status of a recently submitted request to become visible.
      """
    And the output should contain:
      """
      * Purge ID: foobarbaz | Support ID: 12345678901234567890-123456789
      """
    And the output should contain:
      """
      * Time to wait before next check: 60 secs.
      """