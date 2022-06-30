Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BF55617D5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiF3K1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiF3K0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87215647A;
        Thu, 30 Jun 2022 03:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gF4HY/Gvty08xLqOPxt3Ify2new5ECBjfX5po1yKXM/uTKTNHcsR8C0ZxyHGYFKT3eGW8RGpwNAUMdHcFJuCp14jKQNmxPbwRQR5BO8eOEMkYwL1MNX86uLdx7YMYLN/Bw7JsBz2H6NtpUH1f3LqMj7WaiSIzTX/M+RGRuPOft9pGPfD+ETQeC5WdMrU55Y3oFatz+/lcMXetKW2Y12KAoen/8s3ZmVl4Sm+7weYYNKfPO0LIKuwPSJ9ruCeFcdHIM8+HGkCyfYJtVP0RH8FvPd1knPkTjSV3FbIQnkMm+ILtshA6XhsjaqjVY0P3/7ht/yuF7qMdZqlJqVgwb2inA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IF1CK6d5+J7F2DHDnfClHruppP4hP5qBD/+lM40s54=;
 b=X3hJkYHuSLYUGsi0ELmVXjGdkk+YBuXOHqpMWIOCyJWYETWGKxhC+QnOy15khZZRtPsZdhtZgOxMb+vHW9Qk2fsdP6GxeM8zefhC6ZmeX7pY1vaG5s1wUKD7z4JJUixFLCDyTuufysMZ8JgrSUWaKKrlVW0EdTp7cBbP8MfoL63d03V8W3tEirP2KOjSohaDlTVWpneuJBiQi+Ac0czEBfpIjyjcKeIvr9J9IlAHc1yvMWGO8Df4zVnyBW5Dq53uVmkg0amKMlsY19xqnsVQmd5U4j5V6E6Q2l5Lu2SbXvzmK10mR98gz24QDrLA0e5SK8dYXGE8TcNJNXQ7gB3Ipg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IF1CK6d5+J7F2DHDnfClHruppP4hP5qBD/+lM40s54=;
 b=Dk5nb/nHchUndvZwlEqUsFVXJgRK3arMMc5/n6qtEBmXyeLdf9kEx7cQNrRwqo4uhuRmO0cRnc4YR90ltL8qdiAzkgvgWO6OGpXwpu2T40D0FYfQ9MGvsvHIaP8gdF+FB3hCvB4uYDCqSLNNQR21lfTo3C1covd8ga/F2UTreWKN5CyGJXVQ5Z7La1XBSBc0GXUUvwwIBcv286tn6r0sHp00KDxq1GLv1kCa0aVjmgROOO4Z7BiB6aI1Dve1y3seAuDBlZcqNFNPESwGCeCMN9WIA1UGTT/BaQ9EbQOnfDw1Pbr1mhcOhze8zwmFdQAch6quqEyU5Yy2dsKbPnXgYw==
Received: from DS7PR06CA0012.namprd06.prod.outlook.com (2603:10b6:8:2a::22) by
 DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Thu, 30 Jun 2022 10:26:42 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e4) by DS7PR06CA0012.outlook.office365.com
 (2603:10b6:8:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:33 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 03/13] net/mlx5: Introduce ifc bits for page tracker
Date:   Thu, 30 Jun 2022 13:25:35 +0300
Message-ID: <20220630102545.18005-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e499f6c-f275-4ed6-8f34-08da5a8306dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: orhKQhERkY3H3jj/XrzMa1X8T41jk/dj3kidfz1AHkqt+0ojypVsKxL66kd5kixwRyq3Cix/3siSZAE2sjZFak0duH+C9LDxHQ8QC1KXpzEps+mYwwUhf4L2ngvbMbo6Uj4qNG0SDGG+Bj/jcz4vZ8yFQ4S04ZylvORJDEGW0DBWd49ooFZFRStF5dWo6++Pw2k1YIvizXm0PPd3NC7RIfkU8ib+7vM/imOKky7IlcmL4FEM3hRK6Pf7jY2dMo3sk9c2uTDJjj/d5CKKPcRT7LC9BQ9kDa7LpyalQWL6mS+X134Ms/7iqxyDuw2qJuADC8ycv/w62AhUhuKS17lmcsFsZw/FpcR55Ngn8ub4hllpvZSuTGSnsoojSpw7P8erW1p5l19bu47UmRP7BWmNiLBBdsTwxYEx//28zLObkTvMYH4fTO57ZRoe0A/2VkflbXEY3vOpXu/2JwqkmVkboDdUKIIbMnPKYmS09v/OAzO5GAnGAUu8+G/unY/H8+nnG8rqGB7WUWRbF4jRPNh9JmO1W1NbJeO8p5KZ1Ex5wQEMYlZGTDAjlQkCf62uCDJbQmsv0JCLlhfGGsQuZx5TqLkSDbPe3aAaQVsHr9KnFnUlyG57T3gzfdE3N1UjryBCYl0VEEZ8CZNQKJjX8gMoBDxdQ7TeoX61rTaK4c6Pdbt3CPn/8IQow2WjkyawXTRrOcOEGMWNeEptuMZ/s6OwFpTtVjFSsmya509i4sdkReUE0p37eM5OXNluqRFJvkNq5yyLATsznjvafcv6L1J6NikEhoGttccCfNAiC6JPAJ0nwU7tG1rjCkkiSYG8HNXJyOguvyESpYxioLb+exvnbM0Ijj//z2tR7zMrYucPTuw=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(40470700004)(36840700001)(46966006)(356005)(316002)(70206006)(82310400005)(36860700001)(54906003)(4326008)(6636002)(8676002)(70586007)(82740400003)(81166007)(36756003)(110136005)(40480700001)(47076005)(41300700001)(186003)(26005)(478600001)(336012)(426003)(5660300002)(86362001)(2906002)(8936002)(1076003)(40460700003)(83380400001)(2616005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:42.7273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e499f6c-f275-4ed6-8f34-08da5a8306dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ifc related stuff to enable using page tracker.

A page tracker is a dirty page tracking object used by the device to
report the tracking log.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 79 ++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fd7d083a34d3..b2d56fea6a09 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -89,6 +89,7 @@ enum {
 	MLX5_OBJ_TYPE_VIRTIO_NET_Q = 0x000d,
 	MLX5_OBJ_TYPE_VIRTIO_Q_COUNTERS = 0x001c,
 	MLX5_OBJ_TYPE_MATCH_DEFINER = 0x0018,
+	MLX5_OBJ_TYPE_PAGE_TRACK = 0x46,
 	MLX5_OBJ_TYPE_MKEY = 0xff01,
 	MLX5_OBJ_TYPE_QP = 0xff02,
 	MLX5_OBJ_TYPE_PSV = 0xff03,
@@ -1711,7 +1712,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_options[0x8];
 	u8         reserved_at_568[0x3];
 	u8         max_geneve_tlv_option_data_len[0x5];
-	u8         reserved_at_570[0x10];
+	u8         reserved_at_570[0x9];
+	u8         adv_virtualization[0x1];
+	u8         reserved_at_57a[0x6];
 
 	u8	   reserved_at_580[0xb];
 	u8	   log_max_dci_stream_channels[0x5];
@@ -11668,4 +11671,78 @@ struct mlx5_ifc_load_vhca_state_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_adv_virtualization_cap_bits {
+	u8         reserved_at_0[0x3];
+	u8         pg_track_log_max_num[0x5];
+	u8         pg_track_max_num_range[0x8];
+	u8         pg_track_log_min_addr_space[0x8];
+	u8         pg_track_log_max_addr_space[0x8];
+
+	u8         reserved_at_20[0x3];
+	u8         pg_track_log_min_msg_size[0x5];
+	u8         pg_track_log_max_msg_size[0x8];
+	u8         pg_track_log_min_page_size[0x8];
+	u8         pg_track_log_max_page_size[0x8];
+
+	u8         reserved_at_40[0x7c0];
+};
+
+struct mlx5_ifc_page_track_report_entry_bits {
+	u8         dirty_address_high[0x20];
+
+	u8         dirty_address_low[0x20];
+};
+
+enum {
+	MLX5_PAGE_TRACK_STATE_TRACKING,
+	MLX5_PAGE_TRACK_STATE_REPORTING,
+	MLX5_PAGE_TRACK_STATE_ERROR,
+};
+
+struct mlx5_ifc_page_track_range_bits {
+	u8         start_address[0x40];
+
+	u8         length[0x40];
+};
+
+struct mlx5_ifc_page_track_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+
+	u8         state[0x4];
+	u8         track_type[0x4];
+	u8         log_addr_space_size[0x8];
+	u8         reserved_at_90[0x3];
+	u8         log_page_size[0x5];
+	u8         reserved_at_98[0x3];
+	u8         log_msg_size[0x5];
+
+	u8         reserved_at_a0[0x8];
+	u8         reporting_qpn[0x18];
+
+	u8         reserved_at_c0[0x18];
+	u8         num_ranges[0x8];
+
+	u8         reserved_at_e0[0x20];
+
+	u8         range_start_address[0x40];
+
+	u8         length[0x40];
+
+	struct     mlx5_ifc_page_track_range_bits track_range[0];
+};
+
+struct mlx5_ifc_create_page_track_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
+struct mlx5_ifc_modify_page_track_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
 #endif /* MLX5_IFC_H */
-- 
2.18.1

