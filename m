Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084C121BAFA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgGJQbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:31:51 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:20800
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbgGJQbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaLWMUHq+wzu6BtzwhhX4CRKN3hZ+xC8/+QqA+yq1/KLyxupEJD1MkgKFxfx59n9CDWmKpKsHiv7T3HvlnLTrqYdtpukQy9fW7b3nQBzCWsQMRz/1Xu9eKX8tiDd/ZkqDkvc1RVy6vgV8oVQSRo8HCNhrQmWvYmWILdW3HMZW8ftbCRZogj2+8b4J2wpfhUlcrJR/rsFiMe53Hj8rKWey9u6auQL1TGRqmWT+yBBQ2pBX9v/6tVngBGEARwtvI3pc1p70M19E3pEPZSZrU34nJXqIVN7ElKlUZtARjIDl6l/e8CHhcd8Rg4861PNCsP8Hkwew0Ip6LInnB5opzBjBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2isuM1FwbYz4YVC4JpjisebF6RP2POmmiDIZVVd2xTU=;
 b=RToOltSYaOvWeB5+J9XT+v8VH6ViGqHOzRbj8UKcIiF64k6SCsW9hqnYS1z5Cemmmvcbb2APMnhXFMfrVXTdmhIM5BLHYqiqNuTGf3+6/qroGH9bPIjEOEVLpCgYX9AGfJcq8LRdKFawiXdN95OdjFaddOtSvpeO2gCW2/sl4HXmwmyP7ruR7NaQ7an+0WwlGxwFeF3jmGn5rJMYGqW2AfR/TAuzz46DIkgyErvotRuveRgWtei8I0NBhQuxQEkl1aWBNH67XeT4h8+8cpBWRCyht7LLg9rJMlguc/dBUlv2FOd7rOpAgCduB7bU+RFaLuBe062xlTN6k1henW0maA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2isuM1FwbYz4YVC4JpjisebF6RP2POmmiDIZVVd2xTU=;
 b=LwN77xK6/OXhpWZSA2cGEWR6vDaIOMGpuPTdXfl5tMfaci+JRKbWMaROnDJ81Os1xwslG5k7TVkQAEv9LrC2htkGjAZIQpf0EDPGFctfOKcmXl5CuA6BE61LyuZc3Kdn8vlYrwFnOkGfqjQIqeSWT5xw9La4b/x8CCH9CZZlPFY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:31:44 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:31:44 +0000
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
Subject: [net-next PATCH v5 0/6]  ACPI support for dpaa2 MAC driver.
Date:   Fri, 10 Jul 2020 22:01:09 +0530
Message-Id: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:31:40 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 82478577-b51d-4593-f412-08d824eebb70
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB39081E59533A26CA9CB47778D2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Bu0ePlfq7HK0k0mRioEUj9ACmozrRh41QcRZ5ZhR49xMnJ5f1BKG5PsuHwXtByboZH9ge25n+CymL2yV+C3A7nulnkviYmWmqLFE4yXF+1Qagwv4qyQz0y5mGvZzdqIVH/rQxR5SyFZxrZowbmjQH4dlETxJtyY6OA2l/UUWr0Yp7o2fibFy5Nk5WoMIPkuTStGiVHGpqJ0ydg3BScP3M1SFzbojFLeVict6hYqMOyIp2cSH4sqIZ0OZPbx/Zqxdu21pTlwhPEeajXMF6B00bG4/a8n/caahi3gsG8CUJH4EqTUYIYmlBv2rnlK/z3L8DXZHqoYi4fZXkRwMaDkGVNII2OeE/y0md8Ct5xyLipqyEaF7DINf1LB3ClCqck1XJ6vT/JpuhYtBggV40MWYJQ6qj2UoIkoBwDrAVKQTRsetAvYl5wR71Is4BTuj3QeOmG89lE6aqO9ap5iWmk+LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(83380400001)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(966005)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P/n8UEdP5cg03i0xg8H2ddCjde5v9nv+YKolFaa0whI+N9i8Rr4T6fLRm1wwDuuWFSQaI6CmpoqxVFTaKYOePGTtS3nTCzZ9YnOVJ+hFPpltjWasCBtPrzDNBP0n1nkE5n0+jG2eA2mECr5Ow8zsdtbcy5zhWSzWguplpTWo67INTxC8SE/f4bYKg0J+eEsxlghOc5PGYDxbuxsIdGkrvlcP3pxoz/Cr/vvvBSJbGeRR5c5uTBhNl77V6Dqy8xcS2+SsswiRX3ESSGIS0piKhPndes6uT5cTDftUc8PZ6zufn6KzkMfMmD5g3OJN5J4dxAgGYyKlIadNt6C+cvrwqolmc8RubwKbbDZxigfayMIVL9HGY3IwktnT9/FDMivLmxRMpfCjn1c0GBR/pgeldgYrMj+gacsnMGku5RVkmf8LgLm3cfM+XGgUP24Bg/00CLq/ekzDAaVV2y8aQz5IbXn5hM+6kr8TyhjW0xYQS1fmgAVy+SO2d2/w+whvERV/
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82478577-b51d-4593-f412-08d824eebb70
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:31:44.0512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BqzuAC+AdzTkgJN0WD9jVIBqqV8xK6RlbjwLt9XoW39cTMHLPjDIXIzVKJZ7fqvjeBNmP1lcwb1hsAElh7hbDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
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
 drivers/net/phy/mdio_bus.c                    | 52 +++++++++++
 drivers/net/phy/phy_device.c                  | 40 +++++++++
 drivers/net/phy/phylink.c                     | 35 ++++++++
 include/linux/mdio.h                          |  1 +
 include/linux/phy.h                           |  2 +
 include/linux/phylink.h                       |  3 +
 9 files changed, 264 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

