Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8268564D8D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiGDGNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiGDGNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A5F64C3
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7ofwScEbuxoinEjoBcZdi0dU7bIDvK4zPVumcOsMER3ODEmwjPNkAI9TP3xJhxk1dWQqGLE4Y4LMVKUo4/G7g9GzWuZKJw8sDfnqzuRxzSbnZOr9GIUC2iz+zkQJ2EZV0lw6s1bGfDYhQy1QsVc38nHVXE0Uf0jMeY0W2ZXhOufJOneYizn6svuRWSImqcWZFdu7pf5xN+dlHM40Xph165/uF3snoPBpeS/iMroUU86KZY/SkX9EIqSXYZHd9mMBDTlA/7STX4zh/Vw7VXUViFwxdv+YApRhDGrJMUJyvV1ncVuibPjsubAbIy2DEVcOO7OZHLWagftV5pJBOla5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sW174L0DRsQS2zZ6ecQO0O+KkV05i6m6XnpdrIIDWKM=;
 b=h6dt2Xpoi+E80HLZar/wc73gwuI4+pxNGM+aVa3k0NzG9sgxeCd/rrhO3wxGWnPp0bkyvRzu3qe9QmPNiuESa2DIPTyWwTzrv6cQW+U+4kA/DpUvdqWO2u4EWqhX2nt3I5FSFykabaKgPhao4TTKU6kFHk/lNbrpPk24rnsd/RJBl5cFs2jbCNOfqFzXYk6+ipcHlUudtGzmGbcN7GcODKo66MWWJfXaAbiUEb2YmBJemmaNqGt7D16TBgfB2qAYRBw2vahM893c+aMMBzFs12q/q9Bja7jlbBqX2gmDwCPMV/z4T7j4tOl/2OI6SNBzoiApz7gmA29iTrUjiagxkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW174L0DRsQS2zZ6ecQO0O+KkV05i6m6XnpdrIIDWKM=;
 b=qx2RxrO3Mv6K57GP+q45JFf3iC9R6y15qPFgBxweDq39UM96RmwGouByVFxO6eWxt3fyxs8gdZNZDrxDflDMFIt0bXOps4y/lSX00PGfffkHdc6n4BjrnTZbUCDhMnU+AY50obYczLSZWkPDPd+uTSnYEPYRmw0W0Uiz3ahf3qQc5F0T15Or++fQ+TPHSE+m8FOFTtmggrKT35licxoFr66WsAAx4hmc2fAmRiUhU/haUS9gHEtf41aSDfWlbvC1fwfxxWX0Jp1krC7vxxKliuqcctk5EQFzQ5cCgFneRx3zgWDAiii9NdiM/xYfS2zC/oIbTHvynFRK6V2+UfUQGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:13:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 03/13] mlxsw: Configure ingress RIF classification
Date:   Mon,  4 Jul 2022 09:11:29 +0300
Message-Id: <20220704061139.1208770-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50ba37bc-f469-4ce0-a1e7-08da5d8440dd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4WSUDhNA/NJ3R2bvc78UhDxREPkGx/GTYOZZwv8qjdigjy9QXypY0vzl3fyWuYb/acRk7o9KQM6uTfElFlZYZayKGz0yzr/nOHrAGT6uWYccwpcdTf6WEDHOut9ANSJl8Jbmm5Mz1CGSLQNMH0MPJXmsgg4Rcb+lNKjzi5pyXOPpt0tzLscMk9qvgKdHqWBXXbzJrxq2H64hhjb2r9Un83BMcRey7tzVnfIze+1FGJBefkwnmPuWgMhqOXd3JSNlMpubeaHPBvxq16QtXJJbxm8Xuxio7nRYZSXx1yWhNbfhgiyO7I42Gj/MMsZd6eNujSkic2D5Q1yF0y9nOPAcMl0LFT5onH1GKPpbQ+Nj3ypnjMm4AXrZ3xcPcn4d8Y5AOaa4OSxJq8rHecz+jsIcMYNAbk9bm8eeghMid3TJ3rhNXinGWhBUo3NVCgzp6bhnOLqOMkldf04t7+6igwMd6rfa4Wxce4BujBYrLefeTjC4SeCI7IgvNMj6+mSlzPcBgrysocd6KQ970BfCwv6Ch41ZK4/qUDN09k/UCYtz3ed12hvrTMQVzn+PFfth7WV+QUAjfcx9m8eu5R0HuWPt5jeRd9Ocq2H1f/X6tQI0zYlaMCLoE17+TQddbAcUgfxtdX98YgQgGo5z1IFR8G9JGIAjmKkxC5tQH2sPJXFmMRSiTZ/fkKxwtXaS5AQ1eGPaTmuaJH/zoDu0xUtj2Fm4JnlBmwR2PgvbY5kMnXctURI/24XtYG9s9z+P0dimR4W62Ua9KRGBwLWo3Xdn5hxJphoSivowAHRjbHIYJxsr/r5P2Uc3FOMC8N2W2V08gSc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(66574015)(83380400001)(478600001)(2906002)(8936002)(30864003)(5660300002)(36756003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OkdIPzDUNRHtyX+IrxnlQonFQNrofDINZb52/ifJEpHJzU1BnPvtBag9iMeP?=
 =?us-ascii?Q?teXxEryHrmFHGp2u/qaf56PDv3FbeDfd0BV48RYa4TM8GcA+Tob2X+98ro0h?=
 =?us-ascii?Q?KVZsuEn4VoiOpKcED5UlEE17eSO5IQOFpfe8J8+yr1A8HfAWj9ayhOZNsI4l?=
 =?us-ascii?Q?yhbBoDarYcx4UGcHthaEM3K+aEMhALLbL5B3yMstDNVqyry3i3kaAlF1q+XN?=
 =?us-ascii?Q?tAYHbAh8nnBITK/24cKtuvdJsNOJsV4oUWvDIjtIv9RE/J9ZgjhOvlwQCVq7?=
 =?us-ascii?Q?/BDitO1bZ5lODTppOJ9HZ08SgHy9utKanFf1kalZRfPN8X9i+lP1P6sEyifL?=
 =?us-ascii?Q?uBRmIIs0+o0+ZLUHkNwdKsHxRqMvMso2l0oB1UZmfHvncx8hduOv6BiL2hDH?=
 =?us-ascii?Q?Xy4d7E09wyeja4WdkbGzOwJSg2aJf7bgXUsXWAYYQY0feRNlrOSTyMzHp4CX?=
 =?us-ascii?Q?tRKkGuCtPchHdn898L6FFcXEEiFAKRe+OHBOSAEq31FR6Uc20GbExaoM88Mc?=
 =?us-ascii?Q?/NVJ08RbtaRDqzuG2C0aJY9mtNhWEzd52VyLX1uGjQVpQfG6wF7mRVPcZ7rF?=
 =?us-ascii?Q?Z+LoCOfNE18Gba0FSd6t1H7z+azyGeKHTUU/F2OakNQbE5YV7SXQk5StGLza?=
 =?us-ascii?Q?28/7sTZtKBykYb+JCCz0XR2VdgGZMprCy88+cEFnG8JBawZ+dJyTSd2J3Qgy?=
 =?us-ascii?Q?ffJeK3ejEwom0I1bdfc1Zm8qH1Y5fPiX7QFF7yNoM8IyoKyUagDRNMO+0Ahv?=
 =?us-ascii?Q?cyNTEh3dICtQY13LuO/4VwNCFa68CdWEWZsg7vNRgv4k+a+9l6Uo1bCXSKvV?=
 =?us-ascii?Q?Vksjic9XTN3l2vKWUz8i5LzmwaqhGF0lUK8LVNBGCWCifU5ZSEzSW4Gioe5G?=
 =?us-ascii?Q?5HhZbpVwh5LreI35KT5RM46wE7EHvw7WAW3tESDP4T02+Qb259u4cn6O1jeL?=
 =?us-ascii?Q?BS/F5zTMOjk/Fz8hWnsdiH5v8oQ9Sqgj+TXq7ft691bDh3Vv/7QemTchkq+H?=
 =?us-ascii?Q?Qe8ArC4bsKUtqJ1gh1VtEZ+dJKE4Uw9LTxnEuNSRBGfcGQiIWWdGoVvJSCjg?=
 =?us-ascii?Q?9G+93bLR+xwQyxOW8AsghkJ+1r51rh6WL/GIM5Bp4fhTmlKcUtYm63mkc7Ow?=
 =?us-ascii?Q?BLCx+4Sgfgsxi8X0m9Nm3dXccy7x3Vf9tYuGIRyDRfMFMq7QvVVaKD2yDIra?=
 =?us-ascii?Q?EToZZe9qvv+y1tHhLAFA8jbcQb8yrmVZ4tTwTsByv7bdbnB/c5GVmgLtZGyS?=
 =?us-ascii?Q?jZUX7q5C/ax2MWtm/vJb3sU8nHlT5jlHFakEokFxbqcQMndmm87P60jbGXeR?=
 =?us-ascii?Q?ZhCfqPon5xLK3gRqOSTbuLyJNiqtlBz2Wg/GK+KlPru+5LsJg3PmHg34uRF6?=
 =?us-ascii?Q?NCiUvX1Py5sEoJQL6c6E7NlFfiulEygpp/RWlXbjNTPCiRjbhEt2iNMIS18h?=
 =?us-ascii?Q?YER6DVUvotnbOqR7H2WB8euRXbCWN3phJQTesRf4JCHnKPBAqJSWvNQypQrQ?=
 =?us-ascii?Q?W7aFNvGDNuKeij4O3FYoMI5UR2yf6AM13Bdn9/Pa8UX9v4zmwpKxCicsHAjq?=
 =?us-ascii?Q?5D7XvwPqJnvG67nBpsEFhAN232KNnVTuAyjCEpMG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ba37bc-f469-4ce0-a1e7-08da5d8440dd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:03.4023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoDbo06so1W0MiZLqYc1Z9GaC2ciznDDKc8WwZeX2NAAmmCzCuqetvkWEaxfLkTTfV3/bYc4pZaq3GdK09DOQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Before layer 2 forwarding, the device classifies an incoming packet to
a FID. The classification is done based on one of the following keys:

1. FID
2. VNI (after decapsulation)
3. VID / {Port, VID}

After classification, the FID is known, but also all the attributes of
the FID, such as the router interface (RIF) via which a packet that
needs to be routed will ingress the router block.

In the legacy model, when a RIF was created / destroyed, it was
firmware's responsibility to update it in the previously mentioned FID
classification records. In the unified bridge model, this responsibility
moved to software.

The third classification requires to iterate over the FID's {Port, VID}
list and issue SVFA write with the correct mapping table according to the
port's mode (virtual or not). We never map multiple VLANs to the same FID
using VID->FID mapping, so such a mapping needs to be performed once.

When a new FID classification entry is configured and the FID already has
a RIF, set the RIF as part of SVFA configuration.

The reverse needs to be done when clearing a RIF from a FID. Currently,
clearing is done by issuing mlxsw_sp_fid_rif_set() with a NULL RIF pointer.
Instead, introduce mlxsw_sp_fid_rif_unset().

Note that mlxsw_sp_fid_rif_set() is called after the RIF is fully
operational, so it conforms to the internal requirement regarding
SVFA.irif_v: "Must not be set for a non-enabled RIF".

Do not set the ingress RIF for rFIDs, as the {Port, VID}->rFID entry is
configured by firmware when legacy model is used, a next patch will
handle this configuration for rFIDs and unified bridge model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  17 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 173 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  20 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 -
 5 files changed, 189 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b0b5806a22ed..46ed2c1810be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1658,40 +1658,43 @@ MLXSW_ITEM32(reg, svfa, irif, 0x14, 0, 16);
 
 static inline void __mlxsw_reg_svfa_pack(char *payload,
 					 enum mlxsw_reg_svfa_mt mt, bool valid,
-					 u16 fid)
+					 u16 fid, bool irif_v, u16 irif)
 {
 	MLXSW_REG_ZERO(svfa, payload);
 	mlxsw_reg_svfa_swid_set(payload, 0);
 	mlxsw_reg_svfa_mapping_table_set(payload, mt);
 	mlxsw_reg_svfa_v_set(payload, valid);
 	mlxsw_reg_svfa_fid_set(payload, fid);
+	mlxsw_reg_svfa_irif_v_set(payload, irif_v);
+	mlxsw_reg_svfa_irif_set(payload, irif_v ? irif : 0);
 }
 
 static inline void mlxsw_reg_svfa_port_vid_pack(char *payload, u16 local_port,
-						bool valid, u16 fid, u16 vid)
+						bool valid, u16 fid, u16 vid,
+						bool irif_v, u16 irif)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_PORT_VID_TO_FID;
 
-	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid, irif_v, irif);
 	mlxsw_reg_svfa_local_port_set(payload, local_port);
 	mlxsw_reg_svfa_vid_set(payload, vid);
 }
 
 static inline void mlxsw_reg_svfa_vid_pack(char *payload, bool valid, u16 fid,
-					   u16 vid)
+					   u16 vid, bool irif_v, u16 irif)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VID_TO_FID;
 
-	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid, irif_v, irif);
 	mlxsw_reg_svfa_vid_set(payload, vid);
 }
 
 static inline void mlxsw_reg_svfa_vni_pack(char *payload, bool valid, u16 fid,
-					   u32 vni)
+					   u32 vni, bool irif_v, u16 irif)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VNI_TO_FID;
 
-	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid, irif_v, irif);
 	mlxsw_reg_svfa_vni_set(payload, vni);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8de3bdcdf143..b1810a22a1a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -737,6 +737,7 @@ union mlxsw_sp_l3addr {
 	struct in6_addr addr6;
 };
 
+u16 mlxsw_sp_rif_index(const struct mlxsw_sp_rif *rif);
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack);
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp);
@@ -1285,7 +1286,8 @@ void mlxsw_sp_fid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				 struct mlxsw_sp_port *mlxsw_sp_port, u16 vid);
 u16 mlxsw_sp_fid_index(const struct mlxsw_sp_fid *fid);
 enum mlxsw_sp_fid_type mlxsw_sp_fid_type(const struct mlxsw_sp_fid *fid);
-void mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif);
+int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif);
+void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid);
 struct mlxsw_sp_rif *mlxsw_sp_fid_rif(const struct mlxsw_sp_fid *fid);
 enum mlxsw_sp_rif_type
 mlxsw_sp_fid_type_rif_type(const struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index ffe8c583865d..a8fecf47eaf5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -404,11 +404,6 @@ enum mlxsw_sp_fid_type mlxsw_sp_fid_type(const struct mlxsw_sp_fid *fid)
 	return fid->fid_family->type;
 }
 
-void mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
-{
-	fid->rif = rif;
-}
-
 struct mlxsw_sp_rif *mlxsw_sp_fid_rif(const struct mlxsw_sp_fid *fid)
 {
 	return fid->rif;
@@ -465,7 +460,8 @@ static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
-static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
+static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid,
+				const struct mlxsw_sp_rif *rif)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	enum mlxsw_reg_bridge_type bridge_type = 0;
@@ -484,32 +480,176 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
 	mlxsw_reg_sfmr_nve_tunnel_flood_ptr_set(sfmr_pl, fid->nve_flood_index);
+
+	if (mlxsw_sp->ubridge && rif) {
+		mlxsw_reg_sfmr_irif_v_set(sfmr_pl, true);
+		mlxsw_reg_sfmr_irif_set(sfmr_pl, mlxsw_sp_rif_index(rif));
+	}
+
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
 static int mlxsw_sp_fid_vni_to_fid_map(const struct mlxsw_sp_fid *fid,
+				       const struct mlxsw_sp_rif *rif,
 				       bool valid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
+	bool irif_valid;
+	u16 irif_index;
+
+	irif_valid = !!rif;
+	irif_index = rif ? mlxsw_sp_rif_index(rif) : 0;
 
 	mlxsw_reg_svfa_vni_pack(svfa_pl, valid, fid->fid_index,
-				be32_to_cpu(fid->vni));
+				be32_to_cpu(fid->vni), irif_valid, irif_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
+}
+
+static int mlxsw_sp_fid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					  const struct mlxsw_sp_rif *rif)
+{
+	return mlxsw_sp_fid_edit_op(fid, rif);
+}
+
+static int mlxsw_sp_fid_vni_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					      const struct mlxsw_sp_rif *rif)
+{
+	if (!fid->vni_valid)
+		return 0;
+
+	return mlxsw_sp_fid_vni_to_fid_map(fid, rif, fid->vni_valid);
+}
+
+static int
+mlxsw_sp_fid_port_vid_to_fid_rif_update_one(const struct mlxsw_sp_fid *fid,
+					    struct mlxsw_sp_fid_port_vid *pv,
+					    bool irif_valid, u16 irif_index)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char svfa_pl[MLXSW_REG_SVFA_LEN];
+
+	mlxsw_reg_svfa_port_vid_pack(svfa_pl, pv->local_port, true,
+				     fid->fid_index, pv->vid, irif_valid,
+				     irif_index);
+
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
 
+static int mlxsw_sp_fid_vid_to_fid_rif_set(const struct mlxsw_sp_fid *fid,
+					   const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	struct mlxsw_sp_fid_port_vid *pv;
+	u16 irif_index;
+	int err;
+
+	irif_index = mlxsw_sp_rif_index(rif);
+
+	list_for_each_entry(pv, &fid->port_vid_list, list) {
+		/* If port is not in virtual mode, then it does not have any
+		 * {Port, VID}->FID mappings that need to be updated with the
+		 * ingress RIF.
+		 */
+		if (!mlxsw_sp->fid_core->port_fid_mappings[pv->local_port])
+			continue;
+
+		err = mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv,
+								  true,
+								  irif_index);
+		if (err)
+			goto err_port_vid_to_fid_rif_update_one;
+	}
+
+	return 0;
+
+err_port_vid_to_fid_rif_update_one:
+	list_for_each_entry_continue_reverse(pv, &fid->port_vid_list, list) {
+		if (!mlxsw_sp->fid_core->port_fid_mappings[pv->local_port])
+			continue;
+
+		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
+	}
+
+	return err;
+}
+
+static void mlxsw_sp_fid_vid_to_fid_rif_unset(const struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	struct mlxsw_sp_fid_port_vid *pv;
+
+	list_for_each_entry(pv, &fid->port_vid_list, list) {
+		/* If port is not in virtual mode, then it does not have any
+		 * {Port, VID}->FID mappings that need to be updated.
+		 */
+		if (!mlxsw_sp->fid_core->port_fid_mappings[pv->local_port])
+			continue;
+
+		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
+	}
+}
+
+int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
+{
+	int err;
+
+	if (!fid->fid_family->mlxsw_sp->ubridge) {
+		fid->rif = rif;
+		return 0;
+	}
+
+	err = mlxsw_sp_fid_to_fid_rif_update(fid, rif);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_fid_vni_to_fid_rif_update(fid, rif);
+	if (err)
+		goto err_vni_to_fid_rif_update;
+
+	err = mlxsw_sp_fid_vid_to_fid_rif_set(fid, rif);
+	if (err)
+		goto err_vid_to_fid_rif_set;
+
+	fid->rif = rif;
+	return 0;
+
+err_vid_to_fid_rif_set:
+	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
+err_vni_to_fid_rif_update:
+	mlxsw_sp_fid_to_fid_rif_update(fid, NULL);
+	return err;
+}
+
+void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
+{
+	if (!fid->fid_family->mlxsw_sp->ubridge) {
+		fid->rif = NULL;
+		return;
+	}
+
+	if (!fid->rif)
+		return;
+
+	fid->rif = NULL;
+	mlxsw_sp_fid_vid_to_fid_rif_unset(fid);
+	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
+	mlxsw_sp_fid_to_fid_rif_update(fid, NULL);
+}
+
 static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	int err;
 
 	if (mlxsw_sp->ubridge) {
-		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->vni_valid);
+		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif,
+						  fid->vni_valid);
 		if (err)
 			return err;
 	}
 
-	err = mlxsw_sp_fid_edit_op(fid);
+	err = mlxsw_sp_fid_edit_op(fid, fid->rif);
 	if (err)
 		goto err_fid_edit_op;
 
@@ -517,7 +657,7 @@ static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
 
 err_fid_edit_op:
 	if (mlxsw_sp->ubridge)
-		mlxsw_sp_fid_vni_to_fid_map(fid, !fid->vni_valid);
+		mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif, !fid->vni_valid);
 	return err;
 }
 
@@ -526,9 +666,16 @@ static int __mlxsw_sp_fid_port_vid_map(const struct mlxsw_sp_fid *fid,
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
+	bool irif_valid = false;
+	u16 irif_index = 0;
+
+	if (mlxsw_sp->ubridge && fid->rif) {
+		irif_valid = true;
+		irif_index = mlxsw_sp_rif_index(fid->rif);
+	}
 
 	mlxsw_reg_svfa_port_vid_pack(svfa_pl, local_port, valid, fid->fid_index,
-				     vid);
+				     vid, irif_valid, irif_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
 
@@ -768,12 +915,12 @@ static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 
 static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid)
 {
-	return mlxsw_sp_fid_edit_op(fid);
+	return mlxsw_sp_fid_edit_op(fid, fid->rif);
 }
 
 static void mlxsw_sp_fid_8021d_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 {
-	mlxsw_sp_fid_edit_op(fid);
+	mlxsw_sp_fid_edit_op(fid, fid->rif);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 63652460c40d..4a34138985bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9351,9 +9351,15 @@ static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 	if (err)
 		goto err_rif_fdb_op;
 
-	mlxsw_sp_fid_rif_set(rif->fid, rif);
+	err = mlxsw_sp_fid_rif_set(rif->fid, rif);
+	if (err)
+		goto err_fid_rif_set;
+
 	return 0;
 
+err_fid_rif_set:
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_rif_subport_op(rif, false);
 err_rif_subport_op:
@@ -9365,7 +9371,7 @@ static void mlxsw_sp_rif_subport_deconfigure(struct mlxsw_sp_rif *rif)
 {
 	struct mlxsw_sp_fid *fid = rif->fid;
 
-	mlxsw_sp_fid_rif_set(fid, NULL);
+	mlxsw_sp_fid_rif_unset(fid);
 	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
@@ -9442,9 +9448,15 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 	if (err)
 		goto err_rif_fdb_op;
 
-	mlxsw_sp_fid_rif_set(rif->fid, rif);
+	err = mlxsw_sp_fid_rif_set(rif->fid, rif);
+	if (err)
+		goto err_fid_rif_set;
+
 	return 0;
 
+err_fid_rif_set:
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
@@ -9464,7 +9476,7 @@ static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
 
-	mlxsw_sp_fid_rif_set(fid, NULL);
+	mlxsw_sp_fid_rif_unset(fid);
 	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index b5c83ec7a87f..c5dfb972b433 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -82,7 +82,6 @@ struct mlxsw_sp_ipip_entry;
 
 struct mlxsw_sp_rif *mlxsw_sp_rif_by_index(const struct mlxsw_sp *mlxsw_sp,
 					   u16 rif_index);
-u16 mlxsw_sp_rif_index(const struct mlxsw_sp_rif *rif);
 u16 mlxsw_sp_ipip_lb_rif_index(const struct mlxsw_sp_rif_ipip_lb *rif);
 u16 mlxsw_sp_ipip_lb_ul_vr_id(const struct mlxsw_sp_rif_ipip_lb *rif);
 u16 mlxsw_sp_ipip_lb_ul_rif_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif);
-- 
2.36.1

