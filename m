Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E058465A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiG1S6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiG1S6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:44 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E676451
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwGxkWljATcYGC88HD7t4O9IdoDFSxSQeISxGn2BWGyNn/625+lsP1xHgaANKHsW3/IgtC5kvhXYHJvMm1ocaZ0HIUPb5IF4bojuy0YjH86FyWeN/Aqnl1fgQ76rgdHnIQ2E00l+cdUAqxbOJN1aMjWaGwU+ejkJCAmw2mM8IFi25BWy1RAU4qEizidgS91GdOb0gscn5GGxpfL0C1U9RsiaIja0p3/aSyJM+AJVC1joHVWT+olsX1A4mSUm9cjMvrYIJpS/gZ0Zv9bujZImNhpTCgCoOG/1K3/eSIhx/6c7ea6Uh4cftfyp0sJkxFOciadH4oD0v95otDwCev/zOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nf49AhWBjnE/r+5jl7yktB0YkFTItVCPHNLkkT+ld/k=;
 b=TontmA1tDXG0rBndgFjS54Z/aZh6bviGJOh4TW4bR8Oo9UY0KbZKT5J2zSL4Wawr4upeXYDUp68JUZqL5vww1OVEfTYUb6P/XWWwH9LPA2ej5+pZ5VTHsrYeixr2fRIf587yI+gnFzfrIwdjg/ZxXcufNNKbnzlWUGwASKVjmv8cNKYILcACZw6sX79RIlOfpc+C5sgz2bqugOLB3kf4NHhUM9NZ6VWo4OpuWDX5VdIhEttSfGkiikwbhTOqrl0/K3vSF+D7ZRkdyZKbEIzSoCygM+fIBujEW3i5pwh8jVHSC4fh9BYCnLRPLZ4XokN5iZDJQokWG1eiNPyFcwmgcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nf49AhWBjnE/r+5jl7yktB0YkFTItVCPHNLkkT+ld/k=;
 b=H5ZolXYh10shbklU1MyNVYjSMRKsV0eiJNW2kkldEp4j5Wx+qOrE7DY9aZj7K0qHa62pwqayaWKUBQHRRYRj/K0Pqod7XMXMb4HseOoaw+5E8MxbLI+3Wx5yYkjdQt0IhZFy1RRzc/gwTxJjwY/zZsUCa0mxdaFrqJQH8y+2mEfM+k33Zg4x7SP4WeYkk8nO6DprbvFEBqj6YIt1HGkqaUFT1smgBZ6QC2JPFl1yG6heTowrY+FJxSghbvvRobp2IMhtbJ3cXFrLWhk0oEY8t+AMihwHdDuqZmP8kkTEjxiRTzaXompf1gi+W4Vr3cDKvC2MUqoCTW1gdsBHVr/FHg==
Received: from BN9P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::24)
 by MN0PR12MB6270.namprd12.prod.outlook.com (2603:10b6:208:3c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Thu, 28 Jul
 2022 18:58:40 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::c) by BN9P223CA0019.outlook.office365.com
 (2603:10b6:408:10b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:39 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:38 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:38 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:37 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 01/10] sfc: plumb ef100 representor stats
Date:   Thu, 28 Jul 2022 19:57:43 +0100
Message-ID: <a0f67ee14d1a05855fba6168d3af06edb0824840.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74f0c718-0946-457d-6fa5-08da70cb2ed7
X-MS-TrafficTypeDiagnostic: MN0PR12MB6270:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DuTzsEwP3x9pv+LSNAHHSkMmHnquomJahJ1cplk3iWouFvfVN1QYoxFfcj7fsILopnoc8MoNJD1p2mS6KNxFo3H/S1eryR/h0lgfVUhImpaIJ8Lej08ZRhBeTMcA2UqGM5DzI9L9ROuihalnpdWhowkrz1zupZlZLYXRGNMilJnn+70kp9b7KD81aPAbvITIfZt/UMbD3Wq7W5ckjEHrJJ3urzihGG7JcrmxYOr/5DEh5GHWT0MafrXvFcgGtwPfTkoKpST6FuNBIK9Kj2tPrnhichlI0qGjunhuJ/43SPW87udXxRkwbc8AGkzpCajGNfc7/jMCh6PLr+3z9BbIJHk20JsXFyESVOee3CD/EEXN1iKIfiYd3+9g24xK2GOyWaPrJN2KgSIRU+oI+X1o9DcI2O/EzlSlqV2FuQ5g5ukD/dPtjcJmRZ2Kl6X3qFUBQZWbpk1Lygh1av+7+0w8u7gnmS/NaVC1Fx0MJ431f59Nyoha97g5dCmXBqGAiwwoTqpSL7QASPZ52Qg9pQmFWY5sJsGpkQS4az3OJfFMREQg9pV//+vfuIYi+OQvV5i4SEbK35y5B4OGPpo2eZ3JAUM4iluasKts8FojOXxqLrKNYOc33hbJPwnD9B4JxHFmw1QBiC626Sn7tAYohb/ZdAnSL1KmuRRdGEXPIGqaDcq462L/iHea1vV5vlCXizMvvr85l7rajfibNL78Mvt3v6janO5QcW5YqJEeboeVwHE6Lsc6x4Wz0aaGBA38Hyq35EjCACi9fu92g8in9ESNnBHFrY+mSs6T01qOUf7s4dHqh39UVhK0IUYr66Rx2oxVhqi0ceqZwKjdPUJlkG2RBw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(40470700004)(46966006)(36756003)(55446002)(356005)(8936002)(81166007)(82740400003)(42882007)(40480700001)(186003)(47076005)(36860700001)(83170400001)(9686003)(336012)(82310400005)(316002)(70206006)(26005)(478600001)(110136005)(6666004)(8676002)(4326008)(5660300002)(54906003)(40460700003)(2876002)(70586007)(41300700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:39.2264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f0c718-0946-457d-6fa5-08da70cb2ed7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6270
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Implement .ndo_get_stats64() method to read values out of struct
 efx_rep_sw_stats.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index d07539f091b8..102071ed051b 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -79,10 +79,24 @@ static int efx_ef100_rep_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static void efx_ef100_rep_get_stats64(struct net_device *dev,
+				      struct rtnl_link_stats64 *stats)
+{
+	struct efx_rep *efv = netdev_priv(dev);
+
+	stats->rx_packets = atomic64_read(&efv->stats.rx_packets);
+	stats->tx_packets = atomic64_read(&efv->stats.tx_packets);
+	stats->rx_bytes = atomic64_read(&efv->stats.rx_bytes);
+	stats->tx_bytes = atomic64_read(&efv->stats.tx_bytes);
+	stats->rx_dropped = atomic64_read(&efv->stats.rx_dropped);
+	stats->tx_errors = atomic64_read(&efv->stats.tx_errors);
+}
+
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
+	.ndo_get_stats64	= efx_ef100_rep_get_stats64,
 };
 
 static void efx_ef100_rep_get_drvinfo(struct net_device *dev,
