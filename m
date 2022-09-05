Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A505AD0F5
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbiIEK7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237965AbiIEK7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:59:25 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E9A5A3F7;
        Mon,  5 Sep 2022 03:59:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EejxwzFszqmIaEcfU/qLMD6W4PTahQUVLGVq4dPJNMfej2iOySRfrqh28tCMdCEsfIXaFqiHw7u1SJPxCa6gTI0N+U1ne6nox4PW9fr37M9SUkWejbOuA/rJAW6R8paw56iua1Uq0NA0yasj6XFUCzCGh0BM03nG1qhpmxZnuL9fS0WlkXKpaPDH+Ww/96AwYleZXUWWvB4eZTtoaB3NOUJ0OZYZ/Mn1ZOu4kv64mad02J6WwwIIgdGzB+owBrkx5Q6fWKTyMebT5Ec31PynEZ76e3G939KWye3rizNhGAipKxFkpUJPt81SIB93+3dNIATbkhVBetXIlflFJU4UgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDhh+suTXT29RvTKUieh+grfbTBa5Z0nPJlgGEJ2ZB4=;
 b=Zg+rAHHYgUJ+Zo0OCCSyKMilQyhAKeHfPTGQefJ/Tl1wmfLOXGTMzctXr/oHnGfazjJzi1mQFFIOtS+IiMlpZFnEhPGix9IBBkYRh3XUjodjPQDZJ77MO+K3rxM4/iRCcA3sUOaRbQM50jTSG5Rl9oBIx1t6bH79lBd9VtMquvzQEKsuqaVjO8+IQnu+hOWpVLvX6hs3oLgtT5CdGG6Ox0PNgV6L56EqHqJ03WhyGuiL7iUB87oOtiVZWA8K9EVaRC082o4TAw3wyyh6HcPUeKONoHEPJVXNGNwjGEL3G9yz3cp/6bAP/D35I65/tFRg342i38kRoEG/DB6+MpRsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDhh+suTXT29RvTKUieh+grfbTBa5Z0nPJlgGEJ2ZB4=;
 b=aEWoZxaZRG4M6HM2SMe0o7eaAWlt3qiC3xhowK7299OTNT+A/UhbGvDyH94+esJXeeCE/V19aYjM1RFq7Rb36kTPAjU40RMnjkDUQ9sPDQY30K4vj0PuEMW97DJ8RjgwTH5t3uLqWAWBM+Y5sfLnL4xA6Aupe4yfHChZpSru0lJ00V1e5O7//kgWsrCiZQMvEhVq+Xp4blzP/m7UkrdEylHIQgx8WmzlFUy3kFDA4Uj+ftWBGSYyjhQVuzlEfnjli9D2mW18JayMP1d/YL0y4aiiOl2Jd16ViQVcR4FtatkP3MaNJXcswrPtHoa+GJQ68dzCUmUuh/qnjWcE2MYysQ==
Received: from MW4PR04CA0079.namprd04.prod.outlook.com (2603:10b6:303:6b::24)
 by BN9PR12MB5323.namprd12.prod.outlook.com (2603:10b6:408:104::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 10:59:19 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::d5) by MW4PR04CA0079.outlook.office365.com
 (2603:10b6:303:6b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16 via Frontend
 Transport; Mon, 5 Sep 2022 10:59:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 10:59:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 5 Sep 2022 10:59:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 5 Sep 2022 03:59:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 5 Sep 2022 03:59:15 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V6 vfio 01/10] net/mlx5: Introduce ifc bits for page tracker
Date:   Mon, 5 Sep 2022 13:58:43 +0300
Message-ID: <20220905105852.26398-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220905105852.26398-1-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d84c98d1-57aa-4e57-96b0-08da8f2dae5a
X-MS-TrafficTypeDiagnostic: BN9PR12MB5323:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1HEoRrlW0A6+qch9h2mmFWB3LGqk6YkGaJE/StIeeWnm9Ukx8Ne1HhH+v+B0VevGwEG3JHf1gFdDA68QJC23AA0pGewDI/wk2GckTBAHvBwYJoamjCvya2PCEsg0j9GDX84/wzYFm5ADrA1e0Bt0FiY8bF4jkBfGzWa0BkydVXcLygMLpYh8lkrQ3lBVktbHLZPDmFaLQfS5fJJ6fKKXDKkNNjQ6Gtj5ePWpUHgD55oKOSl/0IJSys6OtR7NuV0rkLh0B3P5DfCJUzGmjn+7fHbpSKJPEA1ugVSlKqHev8x6SpmPxo9UENGHkyeJpGtKla/oDkxV77zWwUjwJNNVl5zoKUJv2XTKoTtRECohQCRStj46RBpVwZG+oa3KbWtU3iMSwka9U2+bwC4AeyGKG7O97Xevtn2reFxrw9NxCaRLh09mo6/7vhLnJUo/3jH3B6yMy4LgfQtLspnAks5zZqnt0f10UUEUQxzBkJyzpDOP3zQiOQlOEQTopiayaSe6RFP5pzmjWsXSkMlmJTTRXRWzZN5qm8q9Fhe6bhe51XET1sVT3v4+2Buh+DK1stOiou+srQHA1HKIU8KUNGg8mGSBOY6/8TU2cdB/E+H9ayDEx5nb9bA5i28iEsnhfqY96EicrnWtoQKu9sHqiTXR4GEXuTMTxZ4j9fyISxKxp3C4USwzxGcdPKtgi8HNsnDSWy3Cn9b9dZ4PzKXvPPypzl8YkeWsedjVyHDX7MVmjLS7FSk/GN3nMJ4qA2hy/I8Zd6behfKveJmy4pvSMDvMNuOa06YiNlGL4U+3QyHhhv25m7Ef/xDJwEi+4mqR3Wf
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(40470700004)(46966006)(36840700001)(82740400003)(86362001)(70206006)(70586007)(36756003)(8676002)(4326008)(316002)(36860700001)(356005)(81166007)(47076005)(426003)(83380400001)(6666004)(7696005)(26005)(41300700001)(478600001)(82310400005)(6636002)(110136005)(54906003)(186003)(40460700003)(2906002)(2616005)(1076003)(336012)(5660300002)(8936002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 10:59:18.6725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d84c98d1-57aa-4e57-96b0-08da8f2dae5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 include/linux/mlx5/mlx5_ifc.h | 83 ++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..06eab92b9fb3 100644
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
@@ -1733,7 +1734,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_options[0x8];
 	u8         reserved_at_568[0x3];
 	u8         max_geneve_tlv_option_data_len[0x5];
-	u8         reserved_at_570[0x10];
+	u8         reserved_at_570[0x9];
+	u8         adv_virtualization[0x1];
+	u8         reserved_at_57a[0x6];
 
 	u8	   reserved_at_580[0xb];
 	u8	   log_max_dci_stream_channels[0x5];
@@ -11818,4 +11821,82 @@ struct mlx5_ifc_load_vhca_state_out_bits {
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
+	u8         reserved_at_28[0x3];
+	u8         pg_track_log_max_msg_size[0x5];
+	u8         reserved_at_30[0x3];
+	u8         pg_track_log_min_page_size[0x5];
+	u8         reserved_at_38[0x3];
+	u8         pg_track_log_max_page_size[0x5];
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
+
 #endif /* MLX5_IFC_H */
-- 
2.18.1

