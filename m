Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F25D5667E8
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiGEK2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiGEK2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:28:30 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EBCD79;
        Tue,  5 Jul 2022 03:28:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiOmq6vEWlYD8QIR5m5bj2SFZ/dBLc3pCjFBs+PgxNQqMxPWf4qot5sgIRKazPQTmg0sPhmdBUbM+a7cZ/CkDDeLXQPPGfwYXOCOZP6VXe1UJdWpgQ5ZRTBi/9tsogOrKX/E4IM/5b9bgLKLlv1oa7JUhIGhd+H+c0pNUuiQw+yshoLPx33J7O4fz81efiJgI9UlQFTRHq/9DMwtwjJ4BQ1mjI85MFiC2pAm/o+5anE8B7BDk4rC0Fr8W+wv/MwWX9ny5Abgc474ZBYtMiWQ52H70eqnjga5XREVhoQaZYxhEDULNjL3WeVjRgTDGSBk9HSBcpbOZwz0HMATqdbsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IF1CK6d5+J7F2DHDnfClHruppP4hP5qBD/+lM40s54=;
 b=hLyJB8j4DxPNmIDhyXKlj/m4Sp+d62HeNe8Y5x0Uvtf+OUeAfHzx9p2oxjnPK/G5/EE8PSH8Aco7Rcolyb68KVeC/TlYnDh1srmDAdzESIhZVyO8PvwV4oYN+f7BAxqIURsRdi1JUsRDw1p1JIepH2lRn6Top942GeG+RZ+07j9SRBI+Fyfh9zGqGne0te5PChl/7KxRnM8E2jJpfHaBR8H1xmCHBTW17S+r3Rb4V+tiTx02+S1TLAPoj0dHhAAYw0N7pJYoFa5m0cHuYeL0THSkt62spIhhfWd/Zrdd77a2n0pxMX0nkHi+8MkZ3KRHTkaz961d/Ifm39LvomJeYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IF1CK6d5+J7F2DHDnfClHruppP4hP5qBD/+lM40s54=;
 b=ZkY1BIk40caffax3c1SGJzwliqn4KGR1NTL9L6Mx+I6h90vrvVKWYIzJ4WZ+8apjiKu3YHEa1wQjDek4dN9lFdCXLtQ7xucLaub1g40VNkbKgjOYkLJjBzSe7xAW/20mCNa5e3sSeG0jNzR9mDX7vwTBVkQzS715uuKLL6/hQ+vSU5xS+co/F9RC10cWRivUVq2pvC1v5c8lcKApFCIZcrynoNgS5BTrbpwqD6CNV24pbTMJmyaC6lTVPjU3DSPohvSaeVMNGmf7EIxfJlI2xx7G+4Sjmww5JECypf3tpy/lDyQPHBGLcgbZ2HA91r70ZTFaJFgsz3YXgQncYUQqAw==
Received: from CO2PR04CA0106.namprd04.prod.outlook.com (2603:10b6:104:6::32)
 by CH2PR12MB3863.namprd12.prod.outlook.com (2603:10b6:610:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 10:28:23 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::c) by CO2PR04CA0106.outlook.office365.com
 (2603:10b6:104:6::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:21 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:18 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 01/11] net/mlx5: Introduce ifc bits for page tracker
Date:   Tue, 5 Jul 2022 13:27:30 +0300
Message-ID: <20220705102740.29337-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efaa4ec4-f11f-4770-7d2f-08da5e7116d7
X-MS-TrafficTypeDiagnostic: CH2PR12MB3863:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +bP8TVq9ShTcBujQnUarfOrib70FrJPZwyPGnFY0kq67VbfZ+Ai0hEmNR/KwevENHpG2cEs9AUDsvHQAo71XSbN27lFX7UsIiEIuh2lHqx/WEKYxwux7jmXli2J3WUmZRN8JWKWYKqU24iAhf1uRhKlqTvPAcM01Xq9cXLG/Cs5E3XUjR1a+IAp0nLugMKoGGyLtXHnCROM+N9ppE/U2sbSk/qdPqsYlFQYqJgeQXCNqStcFaG/vwo119IEl9VDOAQK/VTPM0VHAxaHCveUSL0ycfzLDnGmKXgFKX3ffgKsoGDjS4GWLQorr0O6MgL/zyC/7WToJovZMcoCoiaOtihu5zt5ck+IL/lI2ELD0n5Go3fdureqomgS4i45XcYVAM4QF/dUywPOR0zXjnXlvo03FCFIAapYzWUQi65SP9pY+jjRsEWbSS3/egcr4kn4AnzJUSS7Z6BaS0Y4hXWUDXVqxa9SdspVuLM5oxd5i4oW8sxcUcad/0TXQjwUDkYgcDlChaROvFuS+PfQCjitdkHn3iAl5C7yZOA62AfFNXBG58WvnkKki2sWmkJN1jV2XHnIfomsv4I3THpgS/lKgVCG41S5pGaNJP9OmdgVPVIfOWQLSEy+iG3AWNwK2hekmnFzv3BIkrWOSPRjMmrflTMOBiYGYjbCa8FbS6CThepa0MaIvG5L3+v2YXk+hO8syZDM815R9kMDx5bUV0VXzOI3BEpMK84gXphgwgtoXKT62QaWdBcfmq4u6SbYwcvslDE7Tqb9xmuv9DSyhzcxPmPit5G1UccZEfL123G5QvrrWQASwXyCt0iKyvAm3OCCJDb1tvkh7w2B6ccmm4+YAKzbb1lmqyF0lqiOv6gywX5Y=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(39860400002)(346002)(46966006)(36840700001)(40470700004)(1076003)(8936002)(86362001)(478600001)(82310400005)(356005)(70206006)(70586007)(4326008)(8676002)(36860700001)(82740400003)(5660300002)(40480700001)(2616005)(40460700003)(26005)(81166007)(186003)(316002)(36756003)(47076005)(7696005)(6636002)(54906003)(2906002)(336012)(426003)(41300700001)(83380400001)(6666004)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:23.2789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efaa4ec4-f11f-4770-7d2f-08da5e7116d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3863
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

