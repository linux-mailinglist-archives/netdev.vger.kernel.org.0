Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD66585EFA
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiGaM4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiGaM4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:07 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044FB637A;
        Sun, 31 Jul 2022 05:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7x/8o8z0EAmjXhIxQ31xW0Q4l5EUxCbohgs41Pi1Fjk5l3WSNbUj/OBf1I01eahRcvb7p4is5CenJO3wKkiFUxvAMYt9Ga3jJCBv6cLOph9A7zzdPesyJBTRSzI8Wjc5K2+0h/ANUnEwdJGxrdaFAXyp4DYAPCfL8pCF/o2Cq9q6H865FD53vuEyYI69WSuZLmPOnI7457fBPjWloU5IyiianKTz9fIJ2FDN1NsiMKY78u2hskNhZTVD4OPWOfFrNMnQkI5ioueWaGThdFslzSy6h3TLDAs/tjFjScU6NoutShpfywtLc/1TaypAETcl1iZ811gy8s2quUuklMQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cB28xuUH5J18xQ6msDjr/d9XsXhDD06dB8yY90pXNXA=;
 b=NV/uwo44ymbDMJkE5Rcd96azvdz5MSOUz84jbuzK4kVemfvgY08PkSP/7L148e8bUUOvDbBpXq+VEqtduGtljAdm9N1rl5liAw4ERlC4XNlkbgkcMgdk2iBeb+A8m1TWofbyfMVHyJcY46bCZEIQH+4t/I0qK5v3TqH2uAjeB13ZqFRYG+xv14kVj+45d575mMYneHCU/CuZwgMKcqE8LUcOtkNL9MmCBlu0eTp/w5C0IiZdJSqont7gbkqcKPz99yrSt839cmS1g/AcJzs/dkVLcKRxANOEzjsgzqnvIAU/FnrREFnpY9UAkXrWjvMbOlTZDyl9Ss+YFyj1t+6ntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cB28xuUH5J18xQ6msDjr/d9XsXhDD06dB8yY90pXNXA=;
 b=hxbry+YcPR0QlMM/+OmrKN6vdy9Y6RilmkPdQSu9jknFvEyIjXg512VPPa9AX+jXTO711e6O+f5dwJDd2LImro6XSosolyKZDJXrh5vHwh1O6DGC2CFC7CMdglBg9cld1TwnvyQ2cYkKuZ/jDNHDnhCu6TNgDfk2dRYfA9zJhJs8Rx5h1dDXbyydXO7D0p/9xE5K9mgWwglYVBrs1gvU3HK3od4zDmabHd+MK6V4/nNmJLY43Zv/S0BbDIfiawLrrOML07quN1WJaTgXcDnLofE/Nmzn3usvzp8re3E/HGfEsjL+4bhJocjlyjNFFtocch0KOG+MBrCdD2dU+6UmHA==
Received: from BN9PR03CA0463.namprd03.prod.outlook.com (2603:10b6:408:139::18)
 by CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Sun, 31 Jul
 2022 12:56:00 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::b6) by BN9PR03CA0463.outlook.office365.com
 (2603:10b6:408:139::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:55:59 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:55:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:55:55 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 01/11] net/mlx5: Introduce ifc bits for page tracker
Date:   Sun, 31 Jul 2022 15:54:53 +0300
Message-ID: <20220731125503.142683-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4403fcfd-f084-4652-a4b8-08da72f404b4
X-MS-TrafficTypeDiagnostic: CH2PR12MB4905:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAJJ62SN6oLq8oHzOnr9SKhhcUL25bPJKcsQYt0MLH79r2MkInSRZg3HsvariTBg+oxyBTF3JFHy/o4iOzl7iRMb9BMhUepbTZVYcHbtw7xXTUX7WMUyS+TN0u/n5ShDlAAIY2VaUB3t4B3JYC+mMufo1Us0MIPjcGYARS7mPnR3/TKqKq2coUB9TQizwC5wlE/dQ42cgeHua02sDki/nNChl6BzJlYOhBo62wF9PlxxP0jKV6m5yKU8OVAhGk3g6CrQPsgkqLwvOIsWcCZRWqPqWYOLQJFYMtG8TB4pMCAQGP6bsdxUd8e+PSbRdizoo4KGOy/eFnBDLCALAT4TCzbCnLGaOEbvoh/f0Mkrc+NrtgDK/p36mKRp9THXSEmp4gW+jrv+kW+nJ7IcIav+4Rj0RL1soUFJn2dJQrjd6wv/7T7Jf3YXuRshBF02gOY2HbiX223OjazdvgorZ1etgEShY+Q5Aqh0q8MfgE4P6oEIGBD7VE/Qu5GB62I2d5tFMh/3dQEpk/yQt2qeeneMZEGr2pupX2pVdIBHBAteS8xoBY6LgPQMeC2k/Mu6nJ6YqD0sBes4YcWvgWtL+XGaBM3M2GrhnWUGJxY2YUFY+xnhxRUefgE7NPndYh+WX3RDl/n3of4xH6ezDr/Zk1S7AEi4oNMm/8wHUHZleZqzJs4FtaTPhkdO6vfjFCQncq3aBPXLQfbnqJ9pCeM4b/h1qroiMLbMGC8yJmoiFvhwf8mHKRlgv3ewgfql6q3WhSrDiHwnnIRMb/PbjplsW1bsl1aKHz6oB6vohzNbwc7P5Lyr0daLUYm/+Kh8t9dN4t7YultUFGjNw/MJe45T3YeZmA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(36840700001)(40470700004)(46966006)(70586007)(70206006)(8676002)(4326008)(2906002)(356005)(5660300002)(81166007)(8936002)(82740400003)(186003)(1076003)(478600001)(2616005)(40460700003)(47076005)(426003)(336012)(7696005)(41300700001)(36860700001)(6636002)(54906003)(316002)(26005)(83380400001)(110136005)(86362001)(40480700001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:00.1005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4403fcfd-f084-4652-a4b8-08da72f404b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/mlx5/mlx5_ifc.h | 82 ++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fd7d083a34d3..ff6445cb27ba 100644
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
@@ -11668,4 +11671,81 @@ struct mlx5_ifc_load_vhca_state_out_bits {
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
 #endif /* MLX5_IFC_H */
-- 
2.18.1

