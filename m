Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9119D2DB1B5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgLOQox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:44:53 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:56934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728878AbgLOQol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:44:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtVdrqS09qCpdjYHejQhsq73H24CBZvNS/WGKDUcN726VaNs++XfWhqKYrJ8yNUv1a2Z9L3u8aOfDneRCybzXZTz/v4ZjmdJg5sK00mkyCZ0i4HyReE/YpJs5+jPqcYJSiCk+g64uGYQQOpKMyYMUhfBlu9BHBwuZ5P3eAndZQ1ds1ga/Km/0Zpabd6+yyLh02EKnY4Ir9ifM/3vpd9299aKYDsSw6RZ+R4Hs36F2Av65erei0QXAkMV1MFQMuHPlNkjRunFpPmEI1ucNYANHBzNVwJ11KuNAE9PWkIBkqAtTFX9z1DMGeu8mkZDP36H7yxh9q4ifj4vNfJNrYje0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWRCq6M3KrxmufWmMapLvc1GitfMNkJNHmmDTh/89ec=;
 b=U0k19UiaEiHnfr7/hx+1wOiIBDZRCfcNXwVEE4O1COGyhbtNST1es7G58pfSg6LktIL+aRyJFfZpyCJrzyo2uqvXwXlR5QK+TYg1Cpzq5zPpxXOsfC9iigx0MAVaqQYSdkaWlGPpG7f3i6//TRxRDDThg/JQhh66w61ETyP1aa+kAMkNcR53Kkk2dWqvNtVp9OaMLDhG2n6aP4ZI2jjkvtGUgcbe/acA4qCLR5+4e4bufhp0LocA52KmXOnya0Zm+RFGUlsLwhcRL86mQ3UHR8dYfgmLIsL+lGb8WC6OwA38XwGF7bS4l2qFgvGWz3wtDk7K00jxXc7o+chUg9/OVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWRCq6M3KrxmufWmMapLvc1GitfMNkJNHmmDTh/89ec=;
 b=grYlUFgjuNJNucsylAucktQYqmy1zOTE5CZ+iJ/unaOl6rxA4orAwHOatvU0jFTX96cMEj+K0W4gwNMonnoo6xzwMRB8b1nDE5v1AVGPfG4GQyE7tHXYCSjUwyQ+G0aHpoFIZRN/4v5iLQ3X83JX7QZon7naHHTCRC4Hr1SMWPY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:43:50 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:43:50 +0000
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
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
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
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v2 00/14] ACPI support for dpaa2 driver
Date:   Tue, 15 Dec 2020 22:13:01 +0530
Message-Id: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:43:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e6f179e-f10d-4b53-3a94-08d8a11899be
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963226AC9DE46A59C572935D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1cuzTDbAd6qFwsDXBx/BexAEJ+3x/K35+9O3oWXhjN1ZlM0qAi4MhSn4a/UX/AUbpoVzuinYEDDwfKVdac/JUvQjn4SqZsDy/NpYPQPvvECZ+PkOVFwz4ojtwuK5E4chrMOlgIuTk12X+0UscweAKyE9LWjkJVIIGlogSpblDvkDYEIZ55TVnVfdq/P6y4Tmk0TuDaSNLC8/7flYFkRiodFAgxJy1PqhOWWsm/cKBNdkkjHlJ67awZQfPWWL0FPXnOztuHBYZgUpDYxpttQBNf/NEtj2G/pVtdEJ52sNzTK1U8P+BeM9B3xu/UNDcS4Z8+ljFPDxifapDsxrTEhb7XeTrlYy/VFYUPy/S0EwdbeWrI7E/yU0aEODF9CWR7yKsmzJNfNNoJnrU0bjngvug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(7406005)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?//PO7ZPa7go/X3KYFRlRYOUnAUBXQJPqB84Fm3+qlG0GXNExhX9bnjbVv17M?=
 =?us-ascii?Q?opqj1EUwnHdt1wX3aVoBxuFyIrMBymFxZtOsmbWq6yWHJYPCyE1+IcqTqGrF?=
 =?us-ascii?Q?OuXDMoUdCBpnyRtPex93KvHaLnIa5hMbZhsLXPyupszw+Foycwc+lJSYp4dp?=
 =?us-ascii?Q?lC5cNON773DfQh8srCw0CGlaHHLhhjBQnk+n4CT5e/kk4gG1LSsOmYNeBRZV?=
 =?us-ascii?Q?AM1SjFpZ++klYTNBz10oo2COw5DuO4C8JWQYpdx1J6Ye1ScFHfPgCzHuxHAP?=
 =?us-ascii?Q?4PRGkddRx0cGJef6asqZKlp5uw3AY0JJtzYbRx/HJ+JXIOWUC5wL2sucmu/6?=
 =?us-ascii?Q?yXPtnc2uQAju71GQJQHHoxLYHhn3K1OqCm+Z2dSGKL/mT3d5567VxFb96+nM?=
 =?us-ascii?Q?pHl9fw4iNPc67kX52F4sq5a+59xtp80VAv+fKdZdQIbpaseRkVpB9hUB/ljP?=
 =?us-ascii?Q?z5Clb6GytuMBpEz4O6zHEnRzukHSVNqAR9oUEJ830Au+hdfsUGTJ/ib969TQ?=
 =?us-ascii?Q?+97fERRhXjegATqbw0pBrz+5QCzKMenU9euYJtonuL0ZNKlMfhQcIMIs3wFk?=
 =?us-ascii?Q?0XsJAfKzu9S6+xk7fZb+4+5jjLk/buToaFccTQo3eypwyb+KdNyOZEEUFpk7?=
 =?us-ascii?Q?5TmsaF3r4qW+b8NoNmMn+h6LqD2It58a6NuItr4Ea3pYox16IcNIRjNICG3X?=
 =?us-ascii?Q?99LKiBxdrnO3pGstjonKq/zoRJyJgHj21sMIeNAwafar/Dn47fe5R9hDKR5t?=
 =?us-ascii?Q?QKOorTEJCtcTUleGbvL4iHKpKAg/UvrdbuxOPysubN+usbjfK+ZFWEh008OQ?=
 =?us-ascii?Q?tXe/cvl7LECZEISR58vj36dvdC3l1DawcbdzhDc6hwFaTVUA/JeQSi32BmcA?=
 =?us-ascii?Q?UdXDHm6ytnplhxhIiTe+PmXu4IZJCnc19+RrCNqqsxZITVV3W3bO6u5EABsc?=
 =?us-ascii?Q?w2Hhta3hMYZlzw36swEM2k1VIATijRtQWCkAuU5DjtAnWJCYrQ29JyFaF/Rb?=
 =?us-ascii?Q?BP2u?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:43:50.2183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6f179e-f10d-4b53-3a94-08d8a11899be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67vdqMLt+qzeiXtS1zHnT0vsMC3aHWRHoTHUEnWnghIvKp9Jb6YlpBnad0wECgt+YG9rDApYUVz2mZXImNrYog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
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


Changes in v2:
- Updated with more description in document
- use reverse christmas tree ordering for local variables
- Refactor OF functions to use fwnode functions

Calvin Johnson (14):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: Introduce phy related fwnode functions
  of: mdio: Refactor of_phy_find_device()
  net: phy: Introduce fwnode_get_phy_id()
  of: mdio: Refactor of_get_phy_id()
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()
  of: mdio: Refactor of_mdiobus_register_phy()
  net: mdiobus: Introduce fwnode_mdiobus_register()
  net/fsl: Use fwnode_mdiobus_register()
  device property: Introduce fwnode_get_id()
  phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: phy: Introduce fwnode_mdio_find_device()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
 drivers/base/property.c                       |  26 ++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  86 +++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  14 +-
 drivers/net/mdio/of_mdio.c                    |  79 +----------
 drivers/net/phy/mdio_bus.c                    | 116 ++++++++++++++++
 drivers/net/phy/phy_device.c                  | 108 +++++++++++++++
 drivers/net/phy/phylink.c                     |  49 ++++---
 include/linux/mdio.h                          |   2 +
 include/linux/of_mdio.h                       |   6 +-
 include/linux/phy.h                           |  32 +++++
 include/linux/phylink.h                       |   3 +
 include/linux/property.h                      |   1 +
 13 files changed, 519 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

