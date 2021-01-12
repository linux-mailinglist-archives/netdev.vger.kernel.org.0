Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0888B2F31E2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbhALNmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:42:19 -0500
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:1476
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbhALNmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:42:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUMTXPgvxFso/Rk4JpIG2eku9RMmcgsdEn7HZhKrox+t2hRVBbyZAnTEOhdVur9P4ssNbGoggBMtTroYJuRQUMCsNo/I58w4x6jG214ccgYcHhMs8jExaz7Bs7EuAGOqskvDws02xM4jx8X0GyUII9dgMs2ECGZtnWVeeIUd0vVZzsXDISHEnJ6U7+AfiKPxjdNxT49K+9J33RwLMSTPFQQ9wdqhR7L2qRKJ+0jOJ5ind/0znEDdrzQiVvQvGvnbPTQKytaNspm2+Qgh2uL3h3Mvx664jJUM86TEiOSfcCZvDgF1umBv8eAUCo43HnDtr5whcsnScHWu/yZtmTb4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGkeKAeKlUyXo1rlk2m3pbs0N7Y0Af+lLeR7+GVBUVE=;
 b=P2++mvFEk2BD4qKq7dHAi+oZvDPDXfY+JwFLmSiK1YKewWq3q4puNtt6xSLyJBk8u7WodOsuGDcjzaUHNWitbBG8vtS1mM8S7703/SYg/C35dysIatxMcM0f1cIPzwUBTtoTVVcGRfpftb/5XDFzpkrYgGwyFgr8RsG9Dr2QWCiCOsElHhK9O3HAmhTh/DUG64eQrqTE7oObXA+bDSWpo/SvJe4L005OxOC8SzxwR9xH7C5c0qIQdErrAejeAQSyh/SQfmAnsbED63k9ZC/vWKfQ2iuARIxFWgfqCOwKKWvj7aG7DaQ9qGdtsW6H0jc3ZMtoru5BGhi0SSWuqgWygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGkeKAeKlUyXo1rlk2m3pbs0N7Y0Af+lLeR7+GVBUVE=;
 b=S5CZs5bYBI54Ondz79XzM0wy6WHSCICYudz/W0z6nDKw9zBF07dSqf5pDRLQRU7aAvVOrPqU6xFMgMpYAyMVbJWRDllJUbnzUI7Xp5oRWyLx4t08c7TyxeQpD7doQWaRr9RcwVTe7xnebWDRXaILh65APOPbVfhRhT4fFaU6uqc=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6964.eurprd04.prod.outlook.com (2603:10a6:208:18a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:41:27 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:41:27 +0000
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
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: [net-next PATCH v3 00/15] ACPI support for dpaa2 driver
Date:   Tue, 12 Jan 2021 19:10:39 +0530
Message-Id: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:41:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92278690-892f-4609-9d5b-08d8b6ffc2d2
X-MS-TrafficTypeDiagnostic: AM0PR04MB6964:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6964911A9A8E36533B950D5DD2AA0@AM0PR04MB6964.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIemhFfQUpvfyWsCz+IqzDT6kk2Jyoq6lLZ5e9t3gkPa39k6gbAiKnS4HgK/rFnQv8BJ1Gx3rSN9NQUR5giEJHb1tkbGhdfsbQISTyVDzbggQBRMf3TCl+nxdLeoa5Jl0B3nT29nj896UiQkpsyetXAOtriidPKW6UemBNnpUCR8U2GFaL3aQwny6WKC58Z0Fl6w+QHDsQ3ch3SYea+YGwuA7rE1mJdQ2wQ0hdr6lH9+bakUFGSJ2TA4ALXwammucXziLYR26/TdoRbRhUYpbfHmxoDmTpmVUtM8J71kGTYMz1IQWuUb1yGcZ1kCinOBVOtnn5aGezlfN8gRTrTjrf1eZl9Ii0imSzxGOqto3dPQi8vwp1BllrLTuMxqHcUkvHYdemQ+3aScZF/5M+RZmu7ai813Y+ypydyh2+a3x49HD/iqPy6RHlsE1H8dGXaYWTWZqwIx91G5yv2sCLuzqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(136003)(396003)(366004)(1076003)(6512007)(7416002)(1006002)(5660300002)(52116002)(6666004)(8936002)(6506007)(16526019)(186003)(26005)(55236004)(66476007)(83380400001)(921005)(478600001)(7406005)(66946007)(66556008)(6486002)(8676002)(86362001)(44832011)(2906002)(110136005)(2616005)(4326008)(956004)(54906003)(316002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6YgmmtZrWm9yDAlXBB5t+5FUIovxTNgj29arC4en7ORfoTCgg/h60zD02Djc?=
 =?us-ascii?Q?O1Gh3EYspz0l6QyzkjcAoCjoJlB/UmtZFmEPYQu0DTEwjNBCHpjqRlnVlYDB?=
 =?us-ascii?Q?57Kujg9hDRmCv306dCYg9S1uSEUiFahoNWkfT0p2iYve0b0EuvsHFjr5KYnP?=
 =?us-ascii?Q?Wku09mfWDuDsDlROkzlvPdxHhmTvR8x3Wwoupi13JtAiPumg1foIjWnTLp7X?=
 =?us-ascii?Q?9i6oxQyQUxdNWVLAhJVkeLrGaKIm4f6QKwmXh5x4BIbawmgTcdq2a2xA+snL?=
 =?us-ascii?Q?cLOfzKtf5EWy6m2s0uVrd75vpaU4qVMIl50dzfYp91hOGlO/rUAMLF8ZFYrb?=
 =?us-ascii?Q?Qr17lVVRt28iEbiK2k1m2Niqt+8rKoTWwNRAKAZY9t5Ijg4y6NwY8VcXq03h?=
 =?us-ascii?Q?ZrZx8cX4riaYcWYl1pOHY2ioG67W7bn5f+LHY2aOe0n6B5uizANCuFzoV6Ms?=
 =?us-ascii?Q?ZANLj6imPTCgIYX3hw6xz8Te7cbkPlKO8NX3ZJ5GKX3pdBGerspsJnALpnV8?=
 =?us-ascii?Q?O2LANiOIb676NmJJZihVsWXxr09YcK6SvkhTbHf/YWEybDYdnP7vAsYtBwq4?=
 =?us-ascii?Q?HMLM3IoJ0RN+tr4MOA3HOuVSudqDnprmAKT0Ta13zBLGlTfOkDGShxZVYR4j?=
 =?us-ascii?Q?521aApkYVbM9CimZrq76GmuHwH6WHV9Ec6+A8zaoU0UFfGPc0UUyVInfCuKI?=
 =?us-ascii?Q?a9rng0wkfrfYD9THDdjTrq7kFV/OASsZ59AJcXJDMV9CRx95aPzvdZll7+6M?=
 =?us-ascii?Q?syd6rgad33afm0rLHxw+YkIEeq4fxOhTU9nBbAhgaCayoR2loj1Cc0eeMvei?=
 =?us-ascii?Q?pYkJIJ10wimS8VaMp9/91dkGLqlBdojD/xn2KfQqV7TgPV0FluDAKKpSkm5b?=
 =?us-ascii?Q?c/kbROG89wMGwMV2czedsr63meVXaTyE07NClQkRVE5yt3JMAfRQN8zCyIb8?=
 =?us-ascii?Q?+rHuvp3lNxNP07+zzphpmu9Daah0cwxKGPQyP2AakFuKLGrGRB28O2NR6OWg?=
 =?us-ascii?Q?gMlZ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:41:27.3354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 92278690-892f-4609-9d5b-08d8b6ffc2d2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pU8mWQO8JALzL1SM6UIEG4oQMlDI0SvJmc+Ue7VOW9MGGU+wfj6kiucXSZVaa8C/riLCZrE/Dg4mLNLdUuZ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6964
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
      fwnode_get_id()

    First one helps in connecting phy to phylink instance.
    Next three helps in getting phy_id and registering phy to mdiobus
    Next two help in finding a phy on a mdiobus.
    Next one helps in getting phy_node from a fwnode.
    Last one is used to get fwnode ID.

    Corresponding OF functions are refactored.
    END


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
  device property: Introduce fwnode_get_id()
  net: mdio: Add ACPI support code for mdio
  net: mdiobus: Introduce fwnode_mdiobus_register()
  net/fsl: Use fwnode_mdiobus_register()
  phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 drivers/base/property.c                       |  33 +++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  87 +++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  12 +-
 drivers/net/mdio/Kconfig                      |   7 +
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/acpi_mdio.c                  |  49 +++++++
 drivers/net/mdio/of_mdio.c                    |  79 +----------
 drivers/net/phy/mdio_bus.c                    |  87 ++++++++++++
 drivers/net/phy/phy_device.c                  | 106 ++++++++++++++
 drivers/net/phy/phylink.c                     |  49 ++++---
 include/linux/acpi_mdio.h                     |  27 ++++
 include/linux/mdio.h                          |   2 +
 include/linux/of_mdio.h                       |   6 +-
 include/linux/phy.h                           |  32 +++++
 include/linux/phylink.h                       |   3 +
 include/linux/property.h                      |   1 +
 18 files changed, 579 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

-- 
2.17.1

