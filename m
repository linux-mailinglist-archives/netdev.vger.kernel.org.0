Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCDB27EE3F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgI3QFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:05:34 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:40544
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgI3QFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:05:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/7smms0sQtVS1Wo3ozYcYoE1XYuF9zcCT7txo9nfogmLOzwjhFxvIkxRqY7s93PRJR31A5ADc5YQewr2qnQwhqYjIvrW3GnVsW+MIzHIbEg0PW0TKzcdd9t4ep/guysW11fxsN+F6KYxj2h5+W/EvtGTkVgwv4nEw/GjQotkJTPWHBT5KZ1oX1iZMy5ciaMhF6GXIdrba1sNBtos0jpKB9g7rgGvsVfI2D/GPtHi0YsZTKzmCHnCXEvfes3XTwFHuFqxWLAB2CGaEgXLj+LZMVTmPEmGdmKls7xg6eNLiLFLYLaCHxW/BInFy/UmffivaBjxAZ92EIeST4I3KGKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdUY6ypKBM+uPWgn/FdgTu1+zSc8SiKtX13Gx1uuIBs=;
 b=odvFxtCY77xK1sGHocwN+nIYqqxdO0GXseS8j239+VVqpYyG1qM63fqnc8iAxnKZXH5QBzeSFgIYVpBWnMcGkX6DodRwMKpqSEBg3zVX0y/7mNyGM0OlcnQpEt6ECBR58mJ+2UQusb6IQWJSGB9KFCYckV3ZD3gXHXuOIp+WQXe28mJvrPVrpXdfYNQ7bUPlXAoKZ1s29Ua7WgrhYDxkx5CazW4c0ms0RgsTg3eVlR5y26NtQ6CJf16AIYu63NmOARfHubq1zj4dATTRmXyc28oLLoRKv3UeTItwfnoOm2RzcxcALJKf+UoEPRCud7LCcZkOhLd5KxfbKjSIMCnPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdUY6ypKBM+uPWgn/FdgTu1+zSc8SiKtX13Gx1uuIBs=;
 b=jPclxXE1GnLXiH9ZG80xmq726HqxFs12eNhgP02Me6PTRATTgFXm0ZD6+s+MJZz6O/0V9ddzvAqvb10dKkJ/1BJE2Kgx1Xx7p6riFzAaOVBDWrKoFdL3w/OMWRuFgdcR2nM5mAkBRm+rwAokGbjAKbj5VIc+92SDUudU/uwPYAw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 16:05:29 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:05:29 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v1 0/7] ACPI support for dpaa2 driver
Date:   Wed, 30 Sep 2020 21:34:23 +0530
Message-Id: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0168.apcprd03.prod.outlook.com
 (2603:1096:4:c9::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 38e8447b-0868-460f-d979-08d8655aa699
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB43853D7C3E67DF413EEAA48ED2330@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZP2xu+nbMq6bMAqzeIQgKtNcFkO5fXHk6jvSc5oAlpMn1nbnoyyKRyUxyABHcjOroneXDFiK/88879tioRYyfv8f+OSzC3ujALiPwLu4U+/OQVGRhXCFtjHyF53rb13vwGOE1xPvAR3qtoD7yGMHPo6bI9Dh4Nyp5/D5a6/T1uE2C1tUnu2c+2+3V3htjNrWjjGguf7Q5npoW/UmAeZ14mJW698y8reURHKuQ4eImc2243ri3k3HfZq7U1JZDtAnNNcB9/aA+PPCuaB/Z9HBSAuWdG4oMf+CDdOjJcEB7SECc0PcRrrTbnQVM2o+15M8KoFJJbzthcLcNThNBeFpA506zE0Av1B/lvgJchknRtFVmn7S6cuPGMjz2wlmWIZDorRMzA2nCTTKex1mkrYTTEVbwM2zGWh9XxTu2YuXC6CPqKTasqNIbqb25CZp3Bv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(4326008)(2906002)(16526019)(186003)(956004)(2616005)(86362001)(8936002)(55236004)(44832011)(7416002)(66556008)(66476007)(1076003)(26005)(66946007)(8676002)(1006002)(478600001)(52116002)(6486002)(6512007)(5660300002)(83380400001)(54906003)(110136005)(316002)(6506007)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vk3SZn7xJaVfePJU954DgNaC17X8czr7ThqItsFlGo8leQyPs7cdDPIVNbvlMggr8vCnTMKymov+Z3R71FBCLLcA+wvoFoKF79JZkyYYGt5Bl2RQ/GZNSR3sPzZkg3kMBWlLMGGsgCMB4uu92Wbv95P64ugKkn0+SGNV/UGY/mG83U5HLzon0h6MtUIwPI3If35Yue9zofICEM/lZkrawlhGTM984IL1qb0a6sHDw3bDz7rH21QL2JMJeXtE/54dEns812/dteKdGwu0B32QCNmeZqBx97y6D1nInlmxoadKLQfHxRu8F5t8djthQpABvY+21SbhjQPxuS3hq1ot8Xw0Ci3YeROIxH7P72NUtoOncGG5UMfIFnn+xOSYWee+dUMl3z4fllQFaac84HoWr67DnkQFYnhz0ev3ojC9kJmQNpc/Vp3TUDXMGF46iq1cJQZ6D5ksK7ay3SFFb5baSUIHL+03xwMTrEvJtmtbdZJuvRf1KUTMEXih6WpWpiOgpjoenA3MCwnwZkfu5CRn0Ym1j7bFh2zQyfjVNnhzjmEWsr9Pmgk/NrWxhsGb/kM/T6RTcaVuILRGuBegKintBTn6Q94AOmzFPs2fAL6lqXCjSqaJOhbZVWkpWNESsjOs4lx8SQDyFfS6DWPAzXh/OA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e8447b-0868-460f-d979-08d8655aa699
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:05:29.1656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1r2V3hmrPC5tCQv3Fe55xszoUJnFmtokix2JTMonFBEWFhA+LaPUvlmH8DeY6gm3r2Wqr1lgDIlJUsDVfpvAZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch set provides ACPI support to DPAA2 network drivers.

It also introduces new fwnode based APIs to support phylink and phy layers
Following functions are defined:
  phylink_fwnode_phy_connect()
  fwnode_mdiobus_register_phy()
  fwnode_get_phy_id()
  fwnode_phy_find_device()
  device_phy_find_device()
  fwnode_get_phy_node()

First one helps in connecting phy to phylink instance.
Next two helps in getting phy_id and registering phy to mdiobus
Next two help in finding a phy on a mdiobus.
Next one helps in getting phy_node from a fwnode.


Calvin Johnson (7):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: Introduce phy related fwnode functions
  net: phy: Introduce fwnode_get_phy_id()
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()
  phylink: introduce phylink_fwnode_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
  net/fsl: Use _ADR ACPI object to register PHYs

 Documentation/firmware-guide/acpi/dsd/phy.rst | 78 ++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 +++++++++++-------
 drivers/net/ethernet/freescale/xgmac_mdio.c   | 48 ++++++++++-
 drivers/net/phy/mdio_bus.c                    | 40 +++++++++
 drivers/net/phy/phy_device.c                  | 82 +++++++++++++++++++
 drivers/net/phy/phylink.c                     | 51 ++++++++++++
 include/linux/mdio.h                          |  2 +
 include/linux/phy.h                           | 25 ++++++
 include/linux/phylink.h                       |  3 +
 9 files changed, 375 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

