Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D46E4777
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjDQMUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjDQMUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:20:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1087900B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1zDBFPMRRO6YIu5WnLxZ8Nw8+oSW/50k845XxOqSCzIIOS8i3PUzmoURnsaNCB1k9jUY44tcsAab9o1Ba0yOg6eWmd4mAdmKn1/fLsrKjHjOHn6tusI5yGjOPeiXVc+2clDRz0d2NuxgZAJmYV+A9QVxVFqBfm8+gmL09reRMg16l8Kk09n0q4lZSLg2L4z3f2dSADKP1s3iHbnJlhibkf2Qu6wI7VYDK63gZaFLlC6tZncsDUDQQg1n+e9vCkkcHvk8rlHDmrFy0QozFXl41l/OKMh0GVxtI3ek1WHhptEAobaS/L6oCuTYZrHl4Yfm01dOqaz04FhYNOvkQxrwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kZgaD6zRW3K43l68OmIO9ko0MvhPLwzvdhta2rwvcY=;
 b=NeTEu9SyNVNnbhyub5O8cBy0HSZQrlvqOxSpYha9/5iGAuqhfh6ktbMCgI2Qt33U1XdOnGKm0xBqiTn8a6zz6KOmjyxSC7N6KRQfxYE4VHgJixQhwE2KAn/RYyjjs+wuCRBVeM3MHpveYCS7h7ml+gqfuhuEjOJXwEzW1Vzgb+VGaHEuP20uAZSw5Um5gcgJAxfn134oKA+1HRXJOt5NuHd42TAKy6kds5T1yHP5FO8TylwnLjtrYdoaxFEMZixzkX9SF3tCnN8PLI9i+I7KPFGjon/nwW0G5DcavGDYdtCjt27zqcrEBwUp/kepuQAK2i/UetciymfmibaD1K5i4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kZgaD6zRW3K43l68OmIO9ko0MvhPLwzvdhta2rwvcY=;
 b=dxOVGmG/ilgP49/eYAEB5niSl3+UynjVsl2rQxZrNC5v/bw1k5BzGSQUqgqwxrbJeWXy8JYkrhyaG37NrXwRT4rlAm/fz5bBCYnYwiFlY0U+yfp4snorBpUtYwK3GKW8ybfQrHdkMdjEE6rEuqi7hQQd8jctLmAMKtASTasvX5yIvFiGY4iMpb1Q7TGxGAM4EUbnzymRKsCcxCTet5kWgOb5LMAEKluVR7xGmdTTz36p5G7c2mF3cupG+GOChmHsKMGE8w26IcLru2CFsiaupnGsLakj85jnbP3lvWTgfJg1Ed/vXF8yqTQMsmpmhZMn4VldfS33mkaLzk3JhLv9og==
Received: from BN1PR13CA0013.namprd13.prod.outlook.com (2603:10b6:408:e2::18)
 by SA1PR12MB6751.namprd12.prod.outlook.com (2603:10b6:806:258::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:08 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::9b) by BN1PR13CA0013.outlook.office365.com
 (2603:10b6:408:e2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:19:55 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:19:54 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:19:51 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 02/15] net/mlx5e: Move struct mlx5e_xmit_data to datapath header
Date:   Mon, 17 Apr 2023 15:18:50 +0300
Message-ID: <20230417121903.46218-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT041:EE_|SA1PR12MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: f6064c55-4e2f-46ab-08d6-08db3f3e1524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxHjv+cffmZg5SGicJoBmw5bWcTUkY2EE41jzyMFW7yUxrKfQDcEFBCUiKt+Tv9JKqA/M1nR3fh4mXRBpazNkR9yseVCH19DMlm0R+UDShyRSQNjRw0BCiVFNmfd0Jp4AaOe1r+aZWsHMVfr/Mb46y19ueRRJrkiz/bKuIj98lM8pObAFczMWWQA0Hou39soIic4VpEm0amrIX9yNHZ+whUd34VtDur9pa9pXosZ7JAnwwZrFGF04RdikamauAIryYh+z0HqUV+5/M8ky5AZ8jCjxJlQcPqQeIT4+Zqp3XczJod9m9Qv8nBTnGFj1jdn47PDDuWx0X8mtySyPyaHs7Hn3/ugb9Rf5CXrJavXY+baGmXVm6G90xyKuAUvV1AoUk5floMuZhP8EATenZngbTJ6a9k/7Gxp6RDEf/fndLlh9XjbKn8KN/OgbtvWRqxYP+NVnbb+kVIQV8PXIkB6/Xc8w+pCvOqBSUC3Pl7zb/M2OTme3C3JdSXhhHwC62CHn65GQkEeZPBWyyq55K4im+wfqVrRFI7NffcYSgGr50rwKjFt39P/1MUqImwCOvJUYXIHWQ7HMToWU6fC2SqMu99x12vGzMA9P5U01mgbP4G0PT0hI1wlV7gJcF7TN6ddxf9IyhVT9qVPcWmha+OAaXCyayLKbeLPmb2cPFChjm3iswCamCt0tOTZ4mGXwBZh6oFbdLebNqdtUDCMicoxPzO8iUJpjnv2pPvcA2U2p4Hb/Vjo7EqQqPCFYWu5Nenp5MthZ1eCRD/04GdRGjlY/BHRH72+kUvSQlZQv+E78iA=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(478600001)(34020700004)(8936002)(8676002)(316002)(41300700001)(82740400003)(4326008)(70586007)(40480700001)(70206006)(54906003)(7636003)(110136005)(356005)(40460700003)(186003)(107886003)(2906002)(36756003)(1076003)(26005)(426003)(336012)(86362001)(83380400001)(47076005)(82310400005)(2616005)(36860700001)(5660300002)(7696005)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:07.6231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6064c55-4e2f-46ab-08d6-08db3f3e1524
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6751
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move TX datapath struct from the generic en.h to the datapath txrx.h
header, where it belongs.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 7 +------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 6 ++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3f5463d42a1e..479979318c50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -475,12 +475,6 @@ struct mlx5e_txqsq {
 	cqe_ts_to_ns               ptp_cyc2time;
 } ____cacheline_aligned_in_smp;
 
-struct mlx5e_xmit_data {
-	dma_addr_t  dma_addr;
-	void       *data;
-	u32         len;
-};
-
 struct mlx5e_xdp_info_fifo {
 	struct mlx5e_xdp_info *xi;
 	u32 *cc;
@@ -489,6 +483,7 @@ struct mlx5e_xdp_info_fifo {
 };
 
 struct mlx5e_xdpsq;
+struct mlx5e_xmit_data;
 typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xmit_data *,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 651be7aaf7d5..6f7ebedda279 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -77,6 +77,12 @@ static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 }
 
 /* TX */
+struct mlx5e_xmit_data {
+	dma_addr_t  dma_addr;
+	void       *data;
+	u32         len;
+};
+
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
-- 
2.34.1

