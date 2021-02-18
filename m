Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FA931E587
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhBRF23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:28:29 -0500
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:48096
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhBRF2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:28:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRDoKNWiM4anNPyBrCnyYfxvOzXyrq2OPkZsSvnCmaBvCxSQyH6LHSKz1im8elQbSxSfajyfXB5SBrrAOlckuQ4gtNbX6VFSjAXqF4Tgzb6gpdbZHCFIRvFwS6zyTq4J9UK7IVoI+vUvLadC6NUz3Nm1Y3tyWEHsJi7yzJvNxasV8J7S15Nqlf2MP1Ai8hEGvdTTTwIxHCrJdpeixOjXohYVsTCW3/Mx3mW9HBH7cJ5dMDY98PIarK18VvBJrDxESz0MLf8gymrWq6fj2FhNp4cTN8YXEr8K0mOo/ZIrGD5SgnCOzOp6COER4CmZ0KM17OA/9GnBcu0Sdr7M3efVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vnml+DT01xH8hxzVZ2tLyoyDoxVFzIJfBOfmkhQMlqE=;
 b=Guzx7bQwU6GXq4qC+z1/A0jT1y9DbyDHmtIuyTQjvsyTMuJ4bd1wNQBcKFGaDe2RSx5WyZrEBP5fh1fQtEetYimww8tugid93CJC72kQdi8H2Aagav8pFKesVGg9DBkT8vBdx4af1lTAqgZ7wPyR381/2mLBuavK8I9dTRgderYW+vWX3dSQQGlZ+f8zU6x77B+5zWpl0cO65lr0swb96sQYUyLtsgGyyOXQ8EGK7ToAS+5DsxPibauzdeXk56Bd7vA8K+omYp3B21BNDWA1uV39M1P+9Dyl1UI0cSV7dkS8lhlshwJGjhROT0ktldE6Vt6Oqm9AzybyBkuy9N4vQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vnml+DT01xH8hxzVZ2tLyoyDoxVFzIJfBOfmkhQMlqE=;
 b=ByGNWTd1qRpw9bfXpxxd4FLi9bcxsycLUcR3gnSXYc4bYP8qm8Fh8uWOvwdo8InoIT2YjANYe+gQKnl8JDbe5LweRY3ZVNwqaVTEvne+/d0uGymwnoZnQXfmNDouG2No50p2R2BwBSg4G4rNxvX+TxVvBfvbjcr4otSW+NazWFY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Thu, 18 Feb
 2021 05:27:25 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:27:25 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v6 00/15] ACPI support for dpaa2 driver
Date:   Thu, 18 Feb 2021 10:56:39 +0530
Message-Id: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:27:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3aa7adf4-1d9d-4b29-561e-08d8d3cde014
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB344223D5FC93BC38642A12C0D2859@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:313;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lizLrFpS8ke0vNynpFmgN5m+U+ytOtobnQTiEez8L5u4tcULLkDkv4wo54Zi60OsJbjzkIToij1S0XTUNatF1s77XT5+T/ly3GrWjYL1ZfWSFZGv1ZAsyMhVmQ8R4/+U/M5vnPE1OQCwXfDB4BGXw1rGcElJqQNuhbJ03MNzaSUwEe6zpTHlbaoRu1MMNFPZj0dvL4RJgqk32aey4Uk6YaME30uWke7kbDnSQo8rH7KSH42VpJHVJlm74Z86b21Bxjnz652AbqMkngcZrsqfVZUuGbge3dawBoVl7zctdl6uK+Z5H2MKQ/yFah+W1jhpeXB+MjGQLAh5iuN062jI5MZBJTWVTTVA3JjF3JaukGqOn7G6E09129Dy0xwU/iMsEobWcAIuos+tqTcWhRm/5b7XpAAQB+hgGZtMYyddlKHcOEFZ11EcaiECtk2Lf4A3h6Bl3fUgSK4B+jkGjIy+hbEaO1S3dqteQXOgUWBd64So5N+Yw9J5wAAi9l3x7ft/AfHWdpSjOsityTLCMJwq/70xbkoSDPzd58lC5FVs3bMG7//+3MhY9o7dsEZ/WCrcU7d7WGOQ/X3NT1A9YkjQMLYuSkf0ywaJi9n4QkD9ivg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(44832011)(6486002)(26005)(7416002)(16526019)(110136005)(956004)(2616005)(186003)(55236004)(83380400001)(1076003)(6666004)(4326008)(316002)(1006002)(54906003)(8936002)(5660300002)(921005)(2906002)(52116002)(478600001)(86362001)(8676002)(6512007)(66946007)(6506007)(66476007)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Em8UVYzhcQ5E5e3mVe7ZyECTZCOLb2aT3+XDHHNySzvLrZ7kQigCSbsWhO1i?=
 =?us-ascii?Q?wZGcPm5gt0I5BAkr7MHds67wL8URTBr7Z9biz4Y4MUA2isW8Jvm3zL4s7S/Y?=
 =?us-ascii?Q?6jsi67qDe1cM53/y4Nscvgp9YpvBeoc/SlYfhTSWELZgBu6UxrDEFiAcOe/M?=
 =?us-ascii?Q?1Hm1/1SpqOpNCa1uPQpffSWNgyTNtfCHOSIY5qgPypVRuIA4iAEyAE81N5Vy?=
 =?us-ascii?Q?FougmAnKOj5UyWVrMpyAyVAnpniziInwJgeHIcSoZiYn61Ble8uK7/+tRmGT?=
 =?us-ascii?Q?LUJ0B3t6tghKDnY1B7JFjz5q5puNry7MB8p4Rbk8CNLyNTuKxyVAGMIIyjKz?=
 =?us-ascii?Q?xua+eN8qwt/sFc6pAPxLhQMO3IU+K9pLD6qE+IVPuvbmxB2d1qnu8axIBGEs?=
 =?us-ascii?Q?41xununTqB7UNIM6RE0ocnYDUeI+BuBHPJwSi4yYDkPrS7ROifo10X4iDIFh?=
 =?us-ascii?Q?7vFbxLmwHfsJITTbvMPVnhOVoJy8yzE5NcXgm89uX1UMBiSX8O+h9CL1aRi7?=
 =?us-ascii?Q?yjdtop9FCTUBaUvF2e33xUIA9acBnyn4LJHdvzGQEQiIDb5uSQ/Hxx6UOafr?=
 =?us-ascii?Q?srNcrirjUOYvcOaUHdFCO+CYBlWUewL6Sqb9DAzU1bVCVyglgU21Y715+4aU?=
 =?us-ascii?Q?JEEY0MUl1Jcwj9yQXDXBSwcV1uCRzTXjL2ZjkJED1kse9uu/d4G3W0mxdxAk?=
 =?us-ascii?Q?YQ//W7st73Xd+ype2f1ZwDivKSCcICJxSKCUy1FgNLBwva/ZU3mc8v9YBCTi?=
 =?us-ascii?Q?Nb8D7RymJLlTOvx8Xav6fIJreV/E1Fc4R7+zPJ2S2ndm2CuNa890LXGYSwBo?=
 =?us-ascii?Q?wl/d1mR4Fyy6zU/6Nw1Cu0JV+9owSZc5CtI6hcxzAVCqsHe9iEe85Qm3ddqq?=
 =?us-ascii?Q?nordIFGDI+lFvQXGj8h9EB+rrosM9l6/cJcRf/ltgtikJ5CYkhfGfWJCPnRW?=
 =?us-ascii?Q?5ONwo+IX7WxvMYsfxBMMl78BDocCB81ECrI0CaR6fDERuNiD5og24GDKdbc1?=
 =?us-ascii?Q?HFu7JHxFpwIgZyMZyrdli/CrDakK/oRi3q5ELMB4kd4MVZ8nDJMjVD21cPf5?=
 =?us-ascii?Q?QZSb9UfVe6sdVxRDkd0Ynfrt7d1VLX3z3hrJPIAqAudyGQNHzG3heDr4cF7u?=
 =?us-ascii?Q?Z7+I5v3iKLQJzccLXwGkZeOnP90fPOIKlKGCPPzuWczPCt/xwOF7WKf/3ldL?=
 =?us-ascii?Q?s/koTcMG3SzQHd0gXuLCeR8wg4qUVySekNq58RF7MPFUvB5M7G18gc32YTL2?=
 =?us-ascii?Q?x82Sd30cwdmfjrLvxOJAZvasR2fSchvAvPLhUZ2Vo0befzmJa9aiCSb1drJY?=
 =?us-ascii?Q?VtqrPvVM2ADBabTe/RBsY5m5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa7adf4-1d9d-4b29-561e-08d8d3cde014
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:27:25.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpW7cW+ei8dmuzUy/dVkAy4LgCEDU0vjvBexODquA/wasqarGsA/4ktYxwpuezFDgjlqsle7erksXv1q4mjBYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch set provides ACPI support to DPAA2 network drivers.

It also introduces new fwnode based APIs to support phylink and phy
layers
    Following functions are defined:
      phylink_fwnode_phy_connect()
      fwnode_mdiobus_register_phy()
      fwnode_mdiobus_register()
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

Tested-on: T2080RDB, LS1046ARDB, LS2088ARDB and LX2160ARDB


Changes in v6:
- Minor cleanup
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
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()
  of: mdio: Refactor of_mdiobus_register_phy()
  ACPI: utils: Introduce acpi_get_local_address()
  net: mdio: Add ACPI support code for mdio
  net: mdiobus: Introduce fwnode_mdiobus_register()
  net/fsl: Use fwnode_mdiobus_register()
  net: phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 drivers/acpi/utils.c                          |  14 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  91 +++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  11 +-
 drivers/net/mdio/Kconfig                      |   7 +
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/acpi_mdio.c                  |  51 +++++++
 drivers/net/mdio/of_mdio.c                    |  79 +----------
 drivers/net/phy/mdio_bus.c                    |  86 +++++++++++
 drivers/net/phy/phy_device.c                  | 106 ++++++++++++++
 drivers/net/phy/phylink.c                     |  41 ++++--
 include/linux/acpi.h                          |   7 +
 include/linux/acpi_mdio.h                     |  25 ++++
 include/linux/mdio.h                          |   2 +
 include/linux/of_mdio.h                       |   6 +-
 include/linux/phy.h                           |  32 +++++
 include/linux/phylink.h                       |   3 +
 18 files changed, 570 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

-- 
2.17.1

