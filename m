Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B5486877
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241807AbiAFR3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:29:33 -0500
Received: from mail-dm6nam08on2079.outbound.protection.outlook.com ([40.107.102.79]:27461
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241817AbiAFR31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 12:29:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYxHrOEg5hjLQiUZk/QvpYTZjEPEVAnDyULjIlhWGliiEqhql8QJTaeANGWpEiIMMjRrfcY+j+DkZF3Q+/eZ89SoPfov4FnuL1meyxPMkNaJkV8mAqQ6pNkZBGocWov5Dxs11b21+aeK1fcprNqQ0G09mh9BmI/zLgqKPX6kGZ6o+bqZgLSBxVPUffJJAgnhQsv0XNkQye/uCOQvD0qPMnf1mjbZoWzxftMh4q4t05o1JcDgytn0DZZHUw/gKxDCUCVEXWmBuksWlSNKeYOy+UwT0+9Q+C2nqhi34EOW5Bju1sg6EIbQLBWW+Va6mZqjqMIs4yT97E1dEUM+OFkstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPWNjKmm99leCMJUBv2rDkecipxAy1NVk+HjotCvuKA=;
 b=lW0zEPLyJBEj6LZ5B5T6WS/Da7GzmlIoCHNpg3IfxK5WyWfHA6TWhK36LwT9je2qDuT2wA2HmyNTgLF1ekr4RhZGbs/bfwTi2/Cnc7vvCJZiRrUXs6NAYKrf3PGkz+rgPaQckgLs7d2iRZXS/J36pwmstgdFzMkWIG9/wGWsNjjanam5J7Gcjee2cX73h5pyPl8eZTutqy+ahroWg0BnOR2T5TVZ0sCUMavTp5OztyX1+YVRWaiv2WfmBoYCzqpp0KtyE5iHHr9g8Q74dY1HXrFn9XihLnOnRM1M0wxkm0RdyBskmBtUTPhv7JbHAc6/GajceAxMtv2T4zUuJKf5PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPWNjKmm99leCMJUBv2rDkecipxAy1NVk+HjotCvuKA=;
 b=s81lGG2mRvnxqoxWIkKBuEalVLPbYW5bjMHcyjOSqHQizsw48PeVpMCE7tNKOHUkEAiwgCn7mw8SN4YloyD7OyZtFs1ujOxCy3DNSakReXt5sbTc+AGQiSIWJadMZ9uexr4oQVBv8FC+3JrAmvdejfqu3VcrHtcnqfZdD4MR8xU3Qa8U5jm1utIfNJhlgcVqpThn+WZKvvdU5HQeavv7MnAe7bif87v9tvt8BE1+4Y8LosvrTWRIkImOw0FG/QmTf1y9VeQaQv+CAICvbVkLq7z0NOHEI7eW0AyMv8ufmdlDC68+vsfC1QhHRLIxmqATPvJqy27AnmcjC0To0Nss0w==
Received: from BN9PR03CA0102.namprd03.prod.outlook.com (2603:10b6:408:fd::17)
 by CH0PR12MB5187.namprd12.prod.outlook.com (2603:10b6:610:ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 17:29:25 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::90) by BN9PR03CA0102.outlook.office365.com
 (2603:10b6:408:fd::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Thu, 6 Jan 2022 17:29:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.7 via Frontend Transport; Thu, 6 Jan 2022 17:29:24 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 6 Jan
 2022 17:29:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 6 Jan
 2022 17:29:23 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 6 Jan 2022 17:29:22 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <chenhao288@hisilicon.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v1] mlxbf_gige: add interrupt counts to "ethtool -S"
Date:   Thu, 6 Jan 2022 12:29:10 -0500
Message-ID: <20220106172910.26431-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eb88c53-6e9d-4af3-ca4a-08d9d13a1577
X-MS-TrafficTypeDiagnostic: CH0PR12MB5187:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB518741E7243E6ECE69921422C74C9@CH0PR12MB5187.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BpyDsWjIF8lGSuvspHl1lYFEr/U6yTynuJiV2OWYk2bWlPeIVyzMR3J2vhXhQgnAgkNBmkfGNqjLrGn4tEo7aCHNhWYSiOUNM4oofx5UKmAB0Gsd67irvj+MvIkO+V08pfp93WlZ2azPVRqChFZ4kRE66YfVhfSS96hUAmnqTfvRU6rIC+dxPDnMKbRDd+et1D1MVeOUkqkR2mL+0RnbQyYbRs/UDFTEq1tCoYuBzFZkrQ1VSMu7W5yW8npsdxv7bJZQB0mCg6UPzg4TTETSRXDqzTwtZkJ7l40eocMcDDxJj/S9FwLrMZ0pwN76oCiQaepSbKzHkr94arP9/tdvE3HBH6kKYO3tjAqs07xm4SmAAVJb/1tdE8QejOFZgTw5yXbtsxDyHL+RA86ohZzJ6zi21MGEq76a+LJVg3735UNp9jIBqi23gpfFgmcBXpblzsVrk+xtIMe9FuGYgg9Goptuz8k0Gz1r1Zv5tzkV8IVdthOUup4f+EqZnYWpd66kVh7RnLmtZqVJZ6giBj4iRK7zCiLf9rqxEmfuQZcAFedOp+MzskOCuPPCi3HjeVagFlql216NgFNVhNp/rn1748Ta0v8t4P5dEQlux6SHeC3ghJ2njKfc3VJ2BEY16x08rP0foMxn3QZ/mQZmzb2X8+r2QRYCgel8cLP2g6okDk45FDSoZkN/iPpIRkBiQuwfstIMKEzD2qL78ubINWS4bZOfQI3WGktBgk5Dh2syMDuL6leWeWBnQtnWMYLv1eOZenKNn/ru4X2iv7b6yEU6WyJxkOPEZAZ56klWJRfC2Zw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(8936002)(47076005)(8676002)(316002)(86362001)(4326008)(1076003)(36756003)(110136005)(508600001)(6666004)(36860700001)(5660300002)(7696005)(2906002)(81166007)(70586007)(40460700001)(54906003)(186003)(70206006)(83380400001)(26005)(107886003)(82310400004)(336012)(426003)(356005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 17:29:24.6397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb88c53-6e9d-4af3-ca4a-08d9d13a1577
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the output of "ethtool -S", adding
interrupt counts for the three mlxbf_gige interrupt types.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c       | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index ceeb7f4c3f6c..e421e7fa9d7a 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -24,11 +24,9 @@ static void mlxbf_gige_get_regs(struct net_device *netdev,
 	regs->version = MLXBF_GIGE_REGS_VERSION;
 
 	/* Read entire MMIO register space and store results
-	 * into the provided buffer. Each 64-bit word is converted
-	 * to big-endian to make the output more readable.
-	 *
-	 * NOTE: by design, a read to an offset without an existing
-	 *       register will be acknowledged and return zero.
+	 * into the provided buffer. By design, a read to an
+	 * offset without an existing register will be
+	 * acknowledged and return zero.
 	 */
 	memcpy_fromio(p, priv->base, MLXBF_GIGE_MMIO_REG_SZ);
 }
@@ -62,6 +60,9 @@ static const struct {
 	{ "tx_fifo_full" },
 	{ "rx_filter_passed_pkts" },
 	{ "rx_filter_discard_pkts" },
+	{ "mac_intr_count" },
+	{ "rx_intr_count" },
+	{ "llu_plu_intr_count" },
 };
 
 static int mlxbf_gige_get_sset_count(struct net_device *netdev, int stringset)
@@ -116,6 +117,9 @@ static void mlxbf_gige_get_ethtool_stats(struct net_device *netdev,
 		   readq(priv->base + MLXBF_GIGE_RX_PASS_COUNTER_ALL));
 	*data++ = (priv->stats.rx_filter_discard_pkts +
 		   readq(priv->base + MLXBF_GIGE_RX_DISC_COUNTER_ALL));
+	*data++ = priv->error_intr_count;
+	*data++ = priv->rx_intr_count;
+	*data++ = priv->llu_plu_intr_count;
 }
 
 static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
-- 
2.30.1

