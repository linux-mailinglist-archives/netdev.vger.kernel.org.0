Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69903A30DB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFJQmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhFJQmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12BAC061574;
        Thu, 10 Jun 2021 09:40:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g8so236949ejx.1;
        Thu, 10 Jun 2021 09:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1spaCYEdWsz0jXcj/Z9akX/CNrY5KzD9Kw6ELk4qYrE=;
        b=GHC3muY+dGFx/HgVurshrMRcOdkYZ+30CuoFRM0YQ4n5IXOsDnB9m0+W0xZavKf2VL
         ZUeAfjNcYQbHyF4XeUukzYFeQMtdJSethwcEIu7q/QpbBKgvjKjfXgamARjwdrX0n455
         P7cAB5/kh1pTzT2tXPOqifpORsBB9I161CQbuwYEjEKHWGRaAw8ZERUTN7NndILoAlfD
         3u/GPgVQPLBCZLBk5PKb700PRCFzW4qRdhVsTJjEfyQ9Y9zFxDyEEyXEQ9PZzxTtWNAC
         XRfHaBLJgJKj5yYa07Ge8jahK35otBcOTPEb7O10idtZVdvjmbr5tOFQj9uwTT2i/ltO
         rgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1spaCYEdWsz0jXcj/Z9akX/CNrY5KzD9Kw6ELk4qYrE=;
        b=frz//Y0Y/mfgeZAdLxch0iRP7kyCoZm+yDMUbXUIpUm/49YqggXB19hkz54zdlbt6j
         eAtVnrGHy9YlJTWHp83oIgYDU4iIhTaVSMRbueHji2z5uFLlI1wolMBozLhwqPAyTTX3
         qzhpIjvs7kjTrtCGeguLYfBSK2fYbFtddBWNjob8f42qME+zA3MepCIaY+SghIhRNJAV
         ZdRZA0vkPpgfe2EwDKVeJRnMFW5VDMzIcuiPFzDkgrfIdMMc6e7iq2EkG2x9bxf35t09
         kJj0A2Xl1JLBHeAi5JXBsZK5NNaMcL3iL9vVFU9PLX5x3eOF7op3sQmXlohObh7eppOF
         8sQg==
X-Gm-Message-State: AOAM53014Btk9XN3B+HGzHBmrZb2KDtLV+ZZcMhkG1bJtX+XhRLql6Oi
        iqI5/S7yl1wJFQSnaLd6bPQ=
X-Google-Smtp-Source: ABdhPJzKtZZuFukgR/1NmJ01rXWwdrTzycp9y9oVS58ImWKRpFKOT3MGOyvGy9znNJM1y9nqZHVhoA==
X-Received: by 2002:a17:906:35db:: with SMTP id p27mr444679ejb.391.1623343216300;
        Thu, 10 Jun 2021 09:40:16 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:15 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
Date:   Thu, 10 Jun 2021 19:39:02 +0300
Message-Id: <20210610163917.4138412-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set provides ACPI support to DPAA2 network drivers.

It also introduces new fwnode based APIs to support phylink and phy
layers
    Following functions are defined:
      phylink_fwnode_phy_connect()
      fwnode_mdiobus_register_phy()
      fwnode_get_phy_id()
      fwnode_phy_find_device()
      device_phy_find_device()
      fwnode_get_phy_node()
      fwnode_mdio_find_device()
      acpi_get_local_address()

    First one helps in connecting phy to phylink instance.
    Next three helps in getting phy_id and registering phy to mdiobus
    Next two help in finding a phy on a mdiobus.
    Next one helps in getting phy_node from a fwnode.
    Last one is used to get local address from _ADR object.

    Corresponding OF functions are refactored.

Tested-on: LX2160ARDB

Changes in v8:
 - fixed some checkpatch warnings/checks
 - included linux/fwnode_mdio.h in fwnode_mdio.c (fixed the build warnings)
 - added fwnode_find_mii_timestamper() and
   fwnode_mdiobus_phy_device_register() in order to get rid of the cycle
   dependency.
 - change to 'depends on (ACPI || OF) || COMPILE_TEST (for FWNODE_MDIO)
 - remove the fwnode_mdiobus_register from fwnode_mdio.c since it
   introduces a cycle of dependencies.

Changes in v7:
- correct fwnode_mdio_find_device() description
- check NULL in unregister_mii_timestamper()
- Call unregister_mii_timestamper() without NULL check
- Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()
- include fwnode_mdio.h
- Include headers directly used in acpi_mdio.c
- Move fwnode_mdiobus_register() to fwnode_mdio.c
- Include fwnode_mdio.h
- Alphabetically sort header inclusions
- remove unnecassary checks

Changes in v6:
- Minor cleanup
- fix warning for function parameter of fwnode_mdio_find_device()
- Initialize mii_ts to NULL
- use GENMASK() and ACPI_COMPANION_SET()
- some cleanup
- remove unwanted header inclusion
- remove OF check for fixed-link
- use dev_fwnode()
- remove useless else
- replace of_device_is_available() to fwnode_device_is_available()

Changes in v5:
- More cleanup
- Replace fwnode_get_id() with acpi_get_local_address()
- add missing MODULE_LICENSE()
- replace fwnode_get_id() with OF and ACPI function calls
- replace fwnode_get_id() with OF and ACPI function calls

Changes in v4:
- More cleanup
- Improve code structure to handle all cases
- Remove redundant else from fwnode_mdiobus_register()
- Cleanup xgmac_mdio_probe()
- call phy_device_free() before returning

Changes in v3:
- Add more info on legacy DT properties "phy" and "phy-device"
- Redefine fwnode_phy_find_device() to follow of_phy_find_device()
- Use traditional comparison pattern
- Use GENMASK
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation
- Use acpi_mdiobus_register()
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2:
- Updated with more description in document
- use reverse christmas tree ordering for local variables
- Refactor OF functions to use fwnode functions

Calvin Johnson (15):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: Introduce fwnode_mdio_find_device()
  net: phy: Introduce phy related fwnode functions
  of: mdio: Refactor of_phy_find_device()
  net: phy: Introduce fwnode_get_phy_id()
  of: mdio: Refactor of_get_phy_id()
  net: mii_timestamper: check NULL in unregister_mii_timestamper()
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()
  of: mdio: Refactor of_mdiobus_register_phy()
  ACPI: utils: Introduce acpi_get_local_address()
  net: mdio: Add ACPI support code for mdio
  net/fsl: Use [acpi|of]_mdiobus_register
  net: phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++
 MAINTAINERS                                   |   2 +
 drivers/acpi/utils.c                          |  14 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  88 ++++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   2 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  30 ++--
 drivers/net/mdio/Kconfig                      |  14 ++
 drivers/net/mdio/Makefile                     |   4 +-
 drivers/net/mdio/acpi_mdio.c                  |  56 +++++++
 drivers/net/mdio/fwnode_mdio.c                | 144 ++++++++++++++++++
 drivers/net/mdio/of_mdio.c                    | 138 ++---------------
 drivers/net/phy/mii_timestamper.c             |   3 +
 drivers/net/phy/phy_device.c                  | 109 ++++++++++++-
 drivers/net/phy/phylink.c                     |  41 +++--
 include/linux/acpi.h                          |   7 +
 include/linux/acpi_mdio.h                     |  26 ++++
 include/linux/fwnode_mdio.h                   |  35 +++++
 include/linux/phy.h                           |  32 ++++
 include/linux/phylink.h                       |   3 +
 19 files changed, 691 insertions(+), 190 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 drivers/net/mdio/fwnode_mdio.c
 create mode 100644 include/linux/acpi_mdio.h
 create mode 100644 include/linux/fwnode_mdio.h

-- 
2.31.1

