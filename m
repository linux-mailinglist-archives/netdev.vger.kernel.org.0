Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE3A5529E0
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 06:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiFUDky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 23:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiFUDkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 23:40:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D6B631E
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 20:40:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0JN80C2/hnUi9/BK1JI8wVnb8barSxxPYsxIBQZ4fxhloLP2pnVc4I9yB65hDknLBnpbHKR5wLg9DLuNcS2YpeUd4LGlKBnOzVG5c7gbWzAOzD+7Ahd0DV63bDgtR0hpWCAC9K/HmZB6gTcwBp7gp9NHrmDHExBRxvJ/bzKhJJYiR4zQgeZzBk7G7NxN63BTFf8I4SVQFzAOyj0GihYq/PvRNK+coJX8hJsLr8UQeRSeILBRslg3hjNc0g5A8WzKCDR64hovwnHiNmHTBPQGN/6V/qFEr89up3DjcSceqHU0ZHIPhBZJanYDJ2VctVMJx9UnsuWjssmK9ZYXCjD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98j9CmtNhBu+XJWeuns8uQiu1RUBoeQMrGgPEN6faeI=;
 b=jXQnYmeRupNoQ2mJ2pSuDcLi/bJTuC+XCgJ4Tgyi2HeiBNMjJS3v7g3gP7BdbojQ584wtXN7T1vq9IcGz0BvoIROcvU3Lt5DfaCAyPcvQGbFzngekrOhL31b8lqM42gWFnMO4GEtEyt8Ca5o23CMJQKMoDckCwBaurorRB/iWN3wDp9W0cstw58R20jkUchcq/TXNK+tbspUJJxmfAbr3azA+BwD01QnqKz6eb2mpipEt/XuE0xMfZ+jRfClkMycuddbrGFPkd6DWYTj4w6H4Muvgu7PvCsEopFX6Fw7Fn+bcsBl4i9hHlhd1lPD4G484eBwYrT61IVMdbALm707zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=armlinux.org.uk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98j9CmtNhBu+XJWeuns8uQiu1RUBoeQMrGgPEN6faeI=;
 b=FAl/Z4cPv64HmRMkTcpJ78FzfQbG6QbMo5W0ZJCfK8npR9n0TpoTPUnTPveX/pHBNseK9GPSr+pZzrZZIsmzb71h4CUSFAj/p0kFhfVlMpTRHmsxoiJOhCHRoOlk/3CsBhNfvQtLs2WAw+X/muq4ZifGUnwVWtNyGw9tFkOfGPncPGxyICEhmyyLOrvvRj++9zzZcvF5b9ohK3BCkuY/GnM3fraC0ZeFeROmChGhVTJ2O3mgFlcgqkjx6oU8wsMp3SLcsQ4d6oX57HWLG6mDXJ0TMB96Vc3bfXKRcNxN7CwiZ8XDR/L7290Uo77Genf4JO8nP0O0pDnWCMMCs6zyRQ==
Received: from DS7PR06CA0017.namprd06.prod.outlook.com (2603:10b6:8:2a::24) by
 BN6PR1201MB0195.namprd12.prod.outlook.com (2603:10b6:405:53::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Tue, 21 Jun
 2022 03:40:51 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::b8) by DS7PR06CA0017.outlook.office365.com
 (2603:10b6:8:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Tue, 21 Jun 2022 03:40:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Tue, 21 Jun 2022 03:40:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 21 Jun
 2022 03:40:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 20 Jun
 2022 20:40:48 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via
 Frontend Transport; Mon, 20 Jun 2022 20:40:47 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>
CC:     Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1] net: phy: Add support for AQR113C EPHY
Date:   Tue, 21 Jun 2022 09:10:27 +0530
Message-ID: <20220621034027.56508-1-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cea396f-a781-4004-ef91-08da5337d5e9
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0195:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01954F6F204F7D0BADEF26A5AFB39@BN6PR1201MB0195.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oENQFw7eZP/CRTXTo9pvdwqnWErq439p744e+SWGekR5BDlQYvXJM4lEOtFEnNv+iFVShoMdlhvMik4nhmmLTKA+2fwwxqupf4e8yqHKOZt8c8hBHgF+++4DVYO/8D/t4VL/TZMuGbjutxLKrY2IMZHDmbxtQXKZ63WDIC1RknHDV4+kLDybL3XBrmPS3wHHxmfpr/1pRagzNz3qE6WZa9eekj9xV92pBh5m3mWzT8oEy8Jm+1wRx/KoO0tMNAe/Uuhm+GtFYgQPsRkqlktx4sdF6SmY5F21ybWI9OLrDxAGSVG4UDvGOxMFlDX7bKYutiiWg8piM768hcd9M8928iTOd9hiSUCP8fWvgCkmYbPq9V7ERhOD/QxfmG4EhlZAEa3Omr0lEkUgyBrqid3snZAyEE+/GpzjQTfZHIr3O0HsPGZ9QwD+F2rA5is+YRQeyGNJK3zGnFKTWt+zCDxyV1QNOcuCvhNdI4hyGpFCcHuqSEYWfPWoFFx3zxoMndWhPv2se2ZDJ13oXddFo2kuLirtev++n6SLF0rlvhui7t9YoCROjDxVeQIr9n+/yhCIBBgeVZDpzywPqZL5epGKYQZjzNXhLQ7OkkaW2WuCmzEXI8NmhdpLMDabVgO8dmVtXBpWHpbHqSTsP4bzWse38fBeNvSmbdjwbRX+9u2upt0VwLtzSiWfq47vGGf13ZfLPbbfIDJlbC9OTVTG/UNvU82GZvY1Sow6eqD1JCH+5iN1TkbM/X39SjftJ2Kzrczt
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(376002)(136003)(46966006)(40470700004)(36840700001)(2906002)(186003)(26005)(83380400001)(70206006)(70586007)(1076003)(47076005)(336012)(426003)(8676002)(40460700003)(4326008)(41300700001)(86362001)(6666004)(107886003)(478600001)(2616005)(5660300002)(8936002)(7696005)(82740400003)(36756003)(82310400005)(40480700001)(316002)(110136005)(356005)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 03:40:50.2281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cea396f-a781-4004-ef91-08da5337d5e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0195
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support multi-gigabit and single-port Ethernet
PHY transceiver (AQR113C).

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 drivers/net/phy/aquantia_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index a8db1a19011b..5de0aed28aa1 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -22,6 +22,7 @@
 #define PHY_ID_AQR107	0x03a1b4e0
 #define PHY_ID_AQCS109	0x03a1b5c2
 #define PHY_ID_AQR405	0x03a1b4b0
+#define PHY_ID_AQR113C	0x31c31c12
 
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
@@ -684,6 +685,24 @@ static struct phy_driver aqr_driver[] = {
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
+{
+	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
+	.name           = "Aquantia AQR113C",
+	.probe          = aqr107_probe,
+	.config_init    = aqr107_config_init,
+	.config_aneg    = aqr_config_aneg,
+	.config_intr    = aqr_config_intr,
+	.handle_interrupt       = aqr_handle_interrupt,
+	.read_status    = aqr107_read_status,
+	.get_tunable    = aqr107_get_tunable,
+	.set_tunable    = aqr107_set_tunable,
+	.suspend        = aqr107_suspend,
+	.resume         = aqr107_resume,
+	.get_sset_count = aqr107_get_sset_count,
+	.get_strings    = aqr107_get_strings,
+	.get_stats      = aqr107_get_stats,
+	.link_change_notify = aqr107_link_change_notify,
+},
 };
 
 module_phy_driver(aqr_driver);
@@ -696,6 +715,7 @@ static struct mdio_device_id __maybe_unused aqr_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR107) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQCS109) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR405) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR113C) },
 	{ }
 };
 
-- 
2.17.1

