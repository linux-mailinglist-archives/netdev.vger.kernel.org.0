Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFFD57E40F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiGVQFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiGVQFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:05:53 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5EBF599
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCm6GHcPZD4hZNiTOhodlQOO4TU2dnoAkO9giHf1Ogb+uGpZoZCW0E4Pf/eAx2l4RvR+S7wTI0pCmD982EUpP/KBWAD4Dhb+bhvP4h0Q3r1Z2w2OGxpAOtFcPBYyAX8mkW5722DNSXum213tSkjDZjdiBB4zkAu26CcwbVsRPLcwMz23ToEEiZ+uwrcCWpKqWVkCmkNUSagxjsnC8/S/pOmSK9j8QsM/+Y61CSyR3i7Wh2n3a6P4ma0EDT13sxOyPMxtJRhuLGML4jctmN9G1H7CrGw9W2RDniG3zzGTj+t3qawYYQmwKrt8IORWQcrIfBPdk6C3M9hEcr8BJDHYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nf49AhWBjnE/r+5jl7yktB0YkFTItVCPHNLkkT+ld/k=;
 b=BuTzP9mPfIP9teKW3f8Hv+FdV8pkIFsvQriCN5wZ+cCepRwYZ8qbewCmQ/69jerzpAnIwjrQm8tAQsSnKq6awdTyuVRH0iJnQ88LJQ9hA7GHRW2yOOl0YRWAxFc9vEPya3Kc4ODosQ8jTk3JK0JraqNBF3uC/SIPFAQRu3A8dQCotxihXkC5a6thQqRH+zU8QNaINR0K3MkaFlF4cNN5UBYv8JqTRD13zss5mNGV7eOA9x6OstUYI+d6MXHod0XcHeXH24QGogB1xoFJtRiyPXNReoO5irNJiDi1zD4PT5pvASoEBocly8XP534Pd5qW+pa3iqOEPbJfBERVcHoVGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nf49AhWBjnE/r+5jl7yktB0YkFTItVCPHNLkkT+ld/k=;
 b=xWNR6Rve8LdMdci5+59mE9mWhsNSgMxk3UAdDxu5AskfskdiTX0ueySJWCLE3Nj/rUoeHjRL/F1w1ms3MtM/j6E6PaY2+UdG6miznlj/q+qaw2z4LYb1fIE9DP7rdG52lK5xnRDy9rYWsGiWao6gvizjpRGjG4vmCIulrohdI8jA7Q8NUAL8ic3vbPHhwoB7S4yOBAISZ93hH42K8DW7zT00nZAyrESi0cFHgXm4lJ6LXQvJJd9dmJfo79wisY2Bh/XPTCjTjVVBq9AASYp38XgvPUOc+X7Uv1rAv75BGCcXSVgjv7qMaROnfisK/3qcCxZHqhMn1TGbQB8/eAy+RQ==
Received: from DM6PR05CA0065.namprd05.prod.outlook.com (2603:10b6:5:335::34)
 by BL1PR12MB5030.namprd12.prod.outlook.com (2603:10b6:208:313::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:05:49 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::57) by DM6PR05CA0065.outlook.office365.com
 (2603:10b6:5:335::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.11 via Frontend
 Transport; Fri, 22 Jul 2022 16:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:05:48 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:05:41 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 09:05:40 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:05:39 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 01/14] sfc: plumb ef100 representor stats
Date:   Fri, 22 Jul 2022 17:04:10 +0100
Message-ID: <645cf063ba64dfce0ac903a0ee561b40865e32f5.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88ea8011-ce48-4a58-c7be-08da6bfc0b0c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5030:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aOuCwyoUDmYEJWbCDp4kQlrIqWdu046n85uhcStrN2W/1MnzChackCrg6E1hHsCnaa4XKJ1okoid4ZFU0Tscsr0YQlEA8/2QSpEyJV5qNXOicm4y/V8eqm6zzIChR2eWFy/wBbtP+3e7jTFNnuSUytq6K1iyFKvICaOcfk96DLe9t2Gd+bXwPXUqbWegh/rsejD9Uk8j9UVTEZj6eIVwDKd8LV5gH2R6JrnST7rf1PRlrvPTtouS3QNqHm6mermvCPixaYhImCmzv1reNPGL6QnY8DzMlMoQk/rltKRbmPLv8wbeVbL9fk/soWcVRW4FQv0wrgfVkOdnMOA09CokWcglWbLONHImdPbCXW6tkqs33Tuka0ulYERtt2lZA5MBHbd6zfmkM+0BgH60F0wvjl2RPDVThH72c8DvbXQ9gGEZBOgBBOrGVfJ/ESsAIM0bAMsihLXP8cy0NJdoXZNotGHPs6RKh7pU/sKon/B/eDdr6S2ToslP2k0uaD/qYgknjDC9vJ6JJ1Hw63dUCcEHvYO0SxDjKZMvpvdpFjobwc0SuvlH1MWUylBQrDBhl23VKA6H3WyZfhUj8CdPWQ4zk4Zjt+d3egcSgqsym9rqw1UFjtD2ErKjaQs4PRy/NqwpdkeXUgJU3K8io4+sb9r5Wu7U+ayws0A3ItFMjlghhWmW3qpbZ8JXGC71Qp20i9RFx69TLyNMb8+2wVmboj3ihYyDgg/CJ+NE4TgoSbIaQ0sFj4FzgMz0pKBn7GRbkjbtxAWIdom6nNnN/R1X8tUju7jqnmg5O7Bjl5qlfhkhdLEJ2kSu+GKdpZDNtSO1xEJzOm5eJyN4bEfL7xSl1EIjHQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(82310400005)(42882007)(36756003)(186003)(54906003)(82740400003)(8676002)(81166007)(36860700001)(83170400001)(316002)(4326008)(110136005)(70586007)(70206006)(356005)(8936002)(55446002)(5660300002)(478600001)(9686003)(40480700001)(40460700003)(26005)(6666004)(47076005)(336012)(41300700001)(2906002)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:05:48.6726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ea8011-ce48-4a58-c7be-08da6bfc0b0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5030
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
