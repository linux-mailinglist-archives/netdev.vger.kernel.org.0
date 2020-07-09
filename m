Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD221A661
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgGIR5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:57:48 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbgGIR5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:57:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQjJ43D3JvSO/kF4Rkgni3OdE19iwhUGoYlOlFlWaAdIGVt2cODM+UoAAjka23aLcab4b0Zpx4ykYnmHjqs65P27SVkGfQkD2sEcIFaU176vWI0qmjbPrrc5ooeaC3emylzxJ6uhT/BCLIxOZESZCzhQFhvRDBkYTy3yuhAvIBoWloUXS3pDbIMy7KO6zrfsZlpyapbhlYMthyTR0TxUDD01OXbw4/DN7/TYRtcSWBodgIP+fdqANUIJWXlsGrJQk9JmMCxv6RFtyKfXCuP/ipxaS6yHvTahnKPoZX9IGUA0c/J08LpGLgHzRFpWiSxjQ6+/TNnnozCuLEk5e8dT4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUwxSjxBq/06pyuvRS/5DMt25T+vR8XAtPfPUpykfAc=;
 b=le319PwTTr9UfwZpmrg3lixhir0gh096ftu1UDwdOloz6SSLpaupSmsPsF4ZgyuigP/uII99F5+sMJCQzbi8gYyfXprNxDCzNwaRbltX2WLSy3UnmK/4epUkeVLyAt6ehgzsDJj7tLPNLmLpiVEageylMScQmwn6I9IZ3XJwQxXb4/hnFIZ6LtZMY80DymYlhf6xZ2iGMOQdwQElpcyC4mqnJdjj4/k4+wZrR+h0l71qPVIozgau0NEeBG8mZoY3+9+ZOs+MFhqaEXT/mpldGYTKcv9sOR9b6CW2OslqZyH/QqSit/bP9mrY+gFb6rV6njFfSUdzi7S2L/k26vWkww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUwxSjxBq/06pyuvRS/5DMt25T+vR8XAtPfPUpykfAc=;
 b=fL/lySnAsOJkDsNNUzVsMNm3/z9Jlk6kaMLfHi5BhlCl33dpwUoqjepTFLtC7fa6y2rwaxc/GlF79/iBoZV8sPv7wXP/McoASJydoXUi2AhvuYXyL6rtd82uvsqMotds7zKMDxpS0mBGDnp6iLmKGt+41/H51edl3a9LVqixFa8=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 17:57:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 17:57:43 +0000
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
Cc:     linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v4 0/6]  ACPI support for dpaa2 MAC driver.
Date:   Thu,  9 Jul 2020 23:27:16 +0530
Message-Id: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 17:57:40 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5acfdb2-fc8a-4f80-2527-08d824319447
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6898AE496AAFBEEB255D2ADBD2640@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sAtdqzmZQjswfftvADMUkYZZ42jSGC4xuTXdJ4xallIz9adkmiLXNwlsG2T+c7THUZiGe/oA6IdGa5QcemT35uFM0XWgIKV+SlhY5Ytvzic6Q2P5G4mk8rVKgvCSxzg0gMdrgNGreag+e2tzg031feFd7bD6BamxN3s1lQ0LNnUK4KA+JweVrM4GLiXJiRx1jxo2FArvhFLOQmdWyShlvp6um/D7K2UbJFXbnnu65/A5CvIWYs8Aetds+ujo2cXs8GWvv1D6OL2wOou2XI+N9xICAKA+l5amj3gidA58Fi+izqNdQTQ2hPBbp2YSLVKP2Xran79RGQaEqBEtNbSLGMFBFgZyR4VftqqiCxdYzxYHZ6+xKVh7et/aXYPVkS++TdafrE1xc9dsIAuz4bNEx8CpqchNOyZkHzZfGBVpSWh2gn0e/hmsSxt6lqERjVHueGRPH2KY+0uwvrrabNL6eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(83380400001)(6666004)(44832011)(1006002)(8936002)(2906002)(52116002)(2616005)(956004)(110136005)(4326008)(316002)(6512007)(66476007)(8676002)(66946007)(86362001)(66556008)(6636002)(16526019)(26005)(5660300002)(966005)(478600001)(55236004)(6506007)(6486002)(186003)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nnlXw9sAtaQxuhaaipSqjoK+qM6CNk5V6o1LCtSD1jMpmTAatgS5BjefT2ZuoextwTSC80d92O8islJilT8JD8Wlhi9hFS+eLrmfmicEt8jZf9tyfyZbZzpfLZGfeLhZ3DTwvbZ6BNu3DLHnxdGWAdygVZplAMhQUesMT72+VtMSu+jewYK5nuUuuDjKqPDBFw4kULl/RcfanrTft3nbUFvDDYqVaJsHtj2DA4W91dDrOQpJWpVxfMkQJvbAJkxsW0XBwOF11/3dl/H3Ikcf/SxdrSOe16sSjAOmEdnvC0iAHJiLbA99SF7eQpjW57bBwsrOMtVEi6PXMehDPdM4JAgVhqy4+In+l6lHFf7oyxehvq1OPj3va3M50+5LeEQC4/ZmzOBD20/1U42PXcACdd0LW55b7FgO33CHONfmNlmyEQiAoPRBQRZo0RzeHUonLXRZ3PiZlqge5oC8euf2NrPchbHexI/Fdo5AliXLbCY=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5acfdb2-fc8a-4f80-2527-08d824319447
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:57:43.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Vt7Hilu3f7e54PwikFADRIfDJeGx9Kpe0sNIe1qeejsFt8cYUyr/cLYRlziYUSBwI/H/jD0MRrbkc97/BSAmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 This patch series provides ACPI support for dpaa2 MAC driver.
 This also introduces ACPI mechanism to get PHYs registered on a
 MDIO bus and provide them to be connected to MAC.

 This patchset is dependent on the review patches available on:
https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/log/?h=for-review/acpi-iort-id-rework

 Device Tree can be tested with the below change which is also available in
the above referenced review patches:

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -931,6 +931,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
        if (error < 0)
                goto error_cleanup_mc_io;

+       mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
        mc->root_mc_bus_dev = mc_bus_dev;
        return 0;


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
  net: phy: introduce phy_find_by_fwnode()
  phylink: introduce phylink_fwnode_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 70 ++++++++-------
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  3 +-
 drivers/net/phy/mdio_bus.c                    | 47 ++++++++++
 drivers/net/phy/phy_device.c                  | 22 +++++
 drivers/net/phy/phylink.c                     | 33 +++++++
 include/linux/mdio.h                          |  1 +
 include/linux/phy.h                           |  2 +
 include/linux/phylink.h                       |  3 +
 9 files changed, 239 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

