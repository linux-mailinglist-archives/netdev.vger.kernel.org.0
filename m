Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DAF220815
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgGOJEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:34 -0400
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:40864
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbgGOJEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktPOBHJzqDIe7oeMQKxVeqvRQqdCZQxgJ+F8QdXLssXmktpwfL+e+/C2RpFmdlKOEGAm7ryy/5f8b5qlIa11jcU0rwd+YaDF0y4T2lZQFr1U60m410b59oWjjkv+x0Nk92yLXn1+DiFAh6NbZk5X9t7HwGd1w3B9nfwkS6DwwstVavh7c9OuomTz5ni64zwpCyJAlO0Njr0JTMFGaEURoEu/o5by8YTTDmMET1SSRb2/LdWpG5wCtE9cEKV30AfJfrylU5pEPeUEo2cUeCz45EWIhLLI0O9R42jjcTqFfflu+ztZ7s4afMFqMCexm4GiDRWRzvXEccL8ZIHNHW7Z+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqarbZiKWziH0/X6Q0Om+pjWNOrUWFPQQcLyH9KUNiY=;
 b=SppFe82VkzUrX5uGAVnJTN/0qpXBGQ04QYv1KyGwLbhdlEHIbH8kp+3CgeHEPvEkE4Sm767/I9wzb6MbTTngJcDHy+YLe6N0rT+QAQsSqQLxvUHsuIoCKQwE99pQeZyGfKXuMfon2h1nJmw8kA6jnh9ekA4Bf3K/WyPV+BIpq7ywJvIx8jfhQ1s80k+regGY50Iu/cjO6PLDaHMPkJRB718o3OLTiAdAOlCh/MH+/ttApo1OzF+Om3TrCOzXjOSTG6ZqBqqvQBUKzfSGPXzizTZbn7E1kZoKnrzXtmU61g2uMSfrAcrIsGc8+K10uV3CbftXKmTGc1/Zm3gkJibxDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqarbZiKWziH0/X6Q0Om+pjWNOrUWFPQQcLyH9KUNiY=;
 b=dDFkhp2K6ZhUCHYT6Mh01CR5D1UU7q/qmI/hW/wd1yWSqFTsg9HgBz6oP/p/IasE18sCJrGmPiY3V0oztNBjLZSuNFWT326a7CX78QFxyisrOcByIrQjDosJAsv2mYWwwMhQWko4TnTkDSG+N0xi/m/qcBAqyBgd5LI6tU1lzhg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3763.eurprd04.prod.outlook.com (2603:10a6:208:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 09:04:29 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:29 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 0/6]  ACPI support for dpaa2 MAC driver.
Date:   Wed, 15 Jul 2020 14:33:54 +0530
Message-Id: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:26 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3091f171-b54a-409d-6d40-08d8289e14eb
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3763:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3763DB7D98DE5A73FF0C2A8FD27E0@AM0PR0402MB3763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ym6sPzQg6iSKqqwyhlruVd6GtV1pPa7gBRPg6nUXUp/0YGABx83oOwXD1BmxPL8T1DoT+pjzSV0XcNWHg63LJewyxUe2DelZEy3U23gZ1W2vmsAfG85aPKykfD1DvHu10SgI7vn5UacseEr97NKj5HBkRqu4my0RuX/kQO2Z/sBSbJ2aFeqo2HDfivYAHOzxcJb3RX8mfovqANtec0s5IU2S3aUNlSqf328OGaqhrWFt+VqtHBFXRlbta9gsvL3WN6AmoiZ4RYJZUUfJOhFdHUaDKwMWRXdqLsBgTAM8QZyGKFb7nYN95TACRaYzPvCaIUXrRv3nESM2QiNETqGV1v6p9iUTmIKesxmp933VRx320I91MToQgcsmwuZXJfO+Jw8O1ijnStUntBgI6MBxByBeaoWb+9CWkCT1cH/lOOp2LcMcJpdoUarvYueKF+lTJejd8BEPejXAa/7KxfoJMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(5660300002)(110136005)(2906002)(6512007)(66946007)(6666004)(66476007)(86362001)(1006002)(4326008)(66556008)(52116002)(44832011)(316002)(956004)(83380400001)(26005)(6486002)(2616005)(6636002)(6506007)(55236004)(1076003)(186003)(16526019)(8676002)(966005)(8936002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PaxxiDRMuhkzpZIvPylVON4nxjys5AqC2KbNH5OGgHJrCbhdDeIqLacIKaywGgFJs6BTKNUyzaNaTxvVNFPUoh56UE8ygM+26PWf51p96TdzkeB6gFOY2Cd5h5Id+jcZtvbC2H7xYFYjyimvtDvyTVGvh+vBe70EfUHEVf48ocdHHue0wc4nLJYd1zydM2dFxeVlonWD+EuzDVKiQCG1x5cmd2AsObxIltrDMgnKD+eU2XhzcP1sZCTtTVjJQAeESj/ccm5pGr5mjm5SilcczyoV/VrPs7oFFhPKjLjAH7ayKIwZqMzbn+cXUCLy9ypm4AOCZvY5HW7TAW54pZ/rSk2m3khYtbxpCM08ncfWSkewkqYDEKP1OIJFn6RNgwA6ILOp+1djDav1TXQEm/ACGsn83BKE13O/TuYZr4HvanJM8tHvnerP7xuJYchLY8FHlIx+ZZtO8FiMfSOXPlq/Xm6xA4BeApvp6NoiD/kvuoo=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3091f171-b54a-409d-6d40-08d8289e14eb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:29.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lArODox/k82iwDlMNZMKhBROd3a47PPhAhZlv+4twHKGy6JYjTmv1xpE7rfCfD7mdI7ua3jI+zrM3oVW9+Gpyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3763
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 This patch series provides ACPI support for dpaa2 MAC driver.
 This also introduces ACPI mechanism to get PHYs registered on a
 MDIO bus and provide them to be connected to MAC.

 Patch "net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver" depends on
 https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/commit/?h=acpi/for-next&id=c279c4cf5bcd3c55b4fb9709d9036cd1bfe3beb8
 Remaining patches are independent of the above patch and can be applied without
 any issues.

 Device Tree can be tested on LX2160A-RDB with the below change which is also
available in the above referenced patches:

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -931,6 +931,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
        if (error < 0)
                goto error_cleanup_mc_io;

+       mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
        mc->root_mc_bus_dev = mc_bus_dev;
        return 0;


Changes in v7:
- remove unnecessary -ve check for u32 var
- assign flags to phy_dev

Changes in v6:
- change device_mdiobus_register() parameter position
- improve documentation
- change device_mdiobus_register() parameter position
- clean up phylink_fwnode_phy_connect()

Changes in v5:
- add description
- clean up if else
- rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
- add docment for phy_find_by_mdio_handle()
- error out DT in phy_find_by_mdio_handle()
- clean up err return
- return -EINVAL for invalid fwnode

Changes in v4:
- release fwnode_mdio after use
- return ERR_PTR instead of NULL
- introduce device_mdiobus_register()

Changes in v3:
- cleanup based on v2 comments
- Added description for more properties
- Added MDIO node DSDT entry
- introduce fwnode_mdio_find_bus()
- renamed and improved phy_find_by_fwnode()
- cleanup based on v2 comments
- move code into phylink_fwnode_phy_connect()

Changes in v2:
- clean up dpaa2_mac_get_node()
- introduce find_phy_device()
- use acpi_find_child_device()

Calvin Johnson (6):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: introduce device_mdiobus_register()
  net/fsl: use device_mdiobus_register()
  net: phy: introduce phy_find_by_mdio_handle()
  phylink: introduce phylink_fwnode_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 70 ++++++++-------
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  3 +-
 drivers/net/phy/mdio_bus.c                    | 51 +++++++++++
 drivers/net/phy/phy_device.c                  | 40 +++++++++
 drivers/net/phy/phylink.c                     | 32 +++++++
 include/linux/mdio.h                          |  1 +
 include/linux/phy.h                           |  2 +
 include/linux/phylink.h                       |  3 +
 9 files changed, 260 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

