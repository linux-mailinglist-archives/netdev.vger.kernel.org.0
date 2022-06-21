Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C84552D15
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346190AbiFUIep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348240AbiFUIem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:34:42 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2072.outbound.protection.outlook.com [40.107.96.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02DE22536
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:34:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUNsBUTzWwFt2jqqpcnHlvZnjg100zcE61CD4ztTawn4xYWEOwmNneXsBsefrm3jGyX6uid4NBiCI09NtuOCmIsjGks9Gc9Box8/0hQAOy1laVp6Ldy5bFTLbOnkbDJHKjOEF023NOjVI5a+6bVP8/klFqv1fvAh9k+yGuYCeUdilEBn9EVkO8IJwm1ePnGzONMdij+iQ+EUAWzPnmtzEtxB7I8Fmi386k3Mk+4jW4onpMDAX/TAR6Ds5CL4uZc6vWmWyNRlV/65Pmuzljq/UsiRUNL477X3mt8S+Pkh+lwFv2i+UCZtr66d+9u1o7TpSB2ztkaFAo2a8RuoJhZh1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzOwpGKQEI/iUqRBdqMS6oKYOtIfBA3bObUbWKbNFlA=;
 b=dGmNMRbEi7A6eTQiF8mfJcHCvkJqTdTTHa296IhxbCT8sTKl3gNv8SSUaJGx8ZnDjWjhnlSW1ny831g1DNnkNgWT0+739Fg5utdrWgLw0d2ZDmxAUmXhHzcH92yxg8bDRVl6zSknnuuX+rAGokenL5ajSqFS7XCPz3mK1WHMwavDCf3yyYNy+tlUHqEkg3r8UBJQoXbOmt3ncO5oQDZkiakGG1xOiwTIpBJBUavpROvKfXfAlclbuMNk2fjDp8E8f3SASflnig8dJG7LlOkXUX5RewPFFhLv0UEJF10Xy1TQG94bebIkAzD6KBs+0simiG9f9i4oAI4+LJJssjF32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzOwpGKQEI/iUqRBdqMS6oKYOtIfBA3bObUbWKbNFlA=;
 b=QdfWQMDRnTOXwpxJ8FVI5oG8x0kVAqanE4nIeOTKRe3xFg2qJEdLTFPaW44mWn5vXmx2/skQSReUJq3RUw7zZTBhMjY73yj82g3A7+8ZX1i2Zt7+t2onUbh2IFLXfz3SNamhAc7mdhLaeBFOZL2akQpgedwSgVPdnzTxkJYefQ2nCPLiFeREsS3NNM68tWZza19m1CUWxQ8lFB6tNgMd6fUhg459XhINvx8LuM+uU91ego7AE6V43ozpGiPgbjGlqZCiCaQzZrxK3Kx90A81Rjc+4LVk+6XF3jRIjPTAJghx0PNc6aouvpYmPZNyDR2QLW2zMjNT63x3sDzwcJWZpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 08:34:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:34:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/13] mlxsw: Remove lag_vid_valid indication
Date:   Tue, 21 Jun 2022 11:33:33 +0300
Message-Id: <20220621083345.157664-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0095.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 038de61b-ea82-4f26-4d4c-08da5360e21a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52138528287CDEE04C063414B2B39@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eaeFUpY/wk606mPCVwU4uPlTGtr7wgsCxNIX4l9oka/MBlQWwacbOkRvGEGiQYyGtpMBWeGVtBvaWfb5Ikx8mGilb8q1nKwH1BU8UYzygZjOh/+i9/DKxuDTgp6m9ug6ks/SGWwM44+6sqFIXG/+bwSbOKDaMkk2FoouQ0LFG9/rj6a/fs1YpTE64G3cfiBh2iHyno9ideBNKMYF3upPid/n78Y99M73KzJkYbH57JWFguB+FcoH1TQbdVhSp5zP+UZzVPNTIfgnP6KBhTkCWfdZDW44/l5JETIET3PhUDQ9Zu/kOZvTtXuI454j/HxrotHOuapUcS6f8dHk+sH0QahxTR9nhTXmkS8vBQ4yPotyNHShQstrREGukVbAkiFo9JIQ58DxyVCdv0lffs5EHDlOzz71zf3OCTOnDc63aRX3X/aQdd6oEgwze6bFQVKvFf6COvTDsxxp8RKt/hqj7pxr4+QrXne0gKrQ6fNSrew4BUKZbnwuDxOCQ9yY2hUB4KbLMq4vz4gcG72yKvmtik3nCcuBOVkszEThNeoC8jS0fYrGyQxJJjxCKIqGr4wmWHyiVVhj++0j5+M0qFQjpMBi9coEoifNFn92p4hAhlHs/pNXtnaJVyvn310WIGWDqXTpqwQKINzaYQHDJQTzzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(5660300002)(1076003)(66946007)(83380400001)(186003)(6666004)(38100700002)(6506007)(6916009)(2906002)(36756003)(26005)(86362001)(66556008)(4326008)(478600001)(316002)(6486002)(2616005)(41300700001)(8676002)(66476007)(6512007)(107886003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RYoC0936VDOr9VGBCgM9uPbbCfAL2w2+zRsnFeI6BBMSVy71TYHGQJH1nrVZ?=
 =?us-ascii?Q?wsthECKiYFgElyucTwdFq1ZztSeI5e+GAb5Rt9RMYGu91ywV1zpNVpH1C792?=
 =?us-ascii?Q?5FoNmHVi45PweYQwdyLI2NjxfPH/zuxvzouqlsYxEbNv4pro9KhgzH/smP8/?=
 =?us-ascii?Q?aD5tgw6Gy2lASZjMG0x7O5yhXX5tIOPvGcKPqRxA0FiuVMwY5rW3tAvF5pb4?=
 =?us-ascii?Q?HtrLB5YcrWNio8gTSHKKuYIawfnHmUntLB2XtgvTNK5MiOeTOfnMX921FqxZ?=
 =?us-ascii?Q?R0JqaL3DjNmqPNSZh4WwgRbJxfxY8Vx3SkdQ2eWuIVEmBEVEeHDtOiptB1g0?=
 =?us-ascii?Q?8N04sS2T8v4IUA+U6+tGHw4/ajA0N87aAjAXHOOufeIFuKU69NF7Es4/GzFV?=
 =?us-ascii?Q?7t0Fly2ttNX3LPIKQFjvy2kRVeis7nq8iOzmUXAtmslaIn072lZjSaDfA5Dy?=
 =?us-ascii?Q?DOscrpGgN/EzbzQu+95h1DYB1GpYowhu+x2eHDG/VdI5IMPsSKnrGPLkSW9z?=
 =?us-ascii?Q?MSPwKbap0kvcdIv6Xf7bFBdTPO7jqtlXOYayhEYp9A2cgoA1wZ5reKDDeoyM?=
 =?us-ascii?Q?VGBEwWXM8ovzbSZbitEEXYkvKmKP9K7WCl7zU2K9bcqTpJIpUCC6tDWQDFxy?=
 =?us-ascii?Q?C+J5N+vsa3Uyw/8AZtmJ8hlW/zgivNmyGtaNZP/tdCgXPlA6oPSJtO8a5wtC?=
 =?us-ascii?Q?6IS+IuX5tsPSOhZxgOMSPR1vWvLFjUYuYqUgYEdq9kvgoRw02fmPWzCH5ZMp?=
 =?us-ascii?Q?yd/DO5GWm8+R2E+P2XbCG9QoJpRLHz4bNZF500By2sQN8xCj3/zCd1b0QWvs?=
 =?us-ascii?Q?I0FOZ8hReqv9xj2f6iyYgTBwwwH9l3F80ZjNki+pUwByMciTEhYxZOfNpEU2?=
 =?us-ascii?Q?j6lJ0E5fHRhR/Xb3vIzFizB0b0ZJOg3Zv8qkceP1y9+2kaFcbnpyoavungIe?=
 =?us-ascii?Q?lTw/sHw7Q2N9dPgBSQ7BHbGo49pyrwDTq9BM5yXW9ysqvMfS9JC7bh+9EiDl?=
 =?us-ascii?Q?YFmIitDeRGgdFNVCfWQ6jl4b1wmE9iNCElxo2CxZqYMdCFwrbYnWDsWVw4mU?=
 =?us-ascii?Q?KUpvlPfzulhWXfQCZS7Fe0ttU/Jf+It2SuwTDXmVkKxb+n+aY2LKXxWlflF4?=
 =?us-ascii?Q?Mq30TCi0/ug4gaQM5W6tzsXqes7G8WpXJAaHXd+ve6OAZgVvH8ldCmOkqhF+?=
 =?us-ascii?Q?ENQ4BV3ykue6HX0Df2MzXeFiJKhKfg5xLjxKbPMcWUth2iLFRI/g+NF6bNVK?=
 =?us-ascii?Q?HXerUwBy672b5M3BuCiA2ESGqe3Jhytbt5fRGXjIkI9mb1qMXyRtBhkTEbIm?=
 =?us-ascii?Q?Yh5NACTQV7TlmqkPsMLn2fEH4yYKbp3pc1FwZyZJ9fr46uJXUYdrlSdr82d/?=
 =?us-ascii?Q?aJhNKHvAtS3I0fcaqCWH0BLB/gSscLg5ecc92EI4/yTISTrWJAIhSgvXoVs+?=
 =?us-ascii?Q?DXsXrDFUW62WdUZc6EkdWP/HzkqgB03fiXtIpxVrdaFrmV9Xph+U0mVLN8aw?=
 =?us-ascii?Q?IfGqabV3MvNEZ9ucXzTQg3co1XI3dfOrHXaUejj/v4Ozs6yWlnXUB5WsBYEy?=
 =?us-ascii?Q?XXDn1/+jSWgCMzP/9tdCfQ7vtk5Lt0GYVsHcWWaq8F59z3UDVdHXrdeEqJAP?=
 =?us-ascii?Q?EnGf+oJMzJjuPSDiTSwch0OQFGZq5eCi7AABmfwq7bV8qf7RXW2RVMl7XQII?=
 =?us-ascii?Q?8Xca7DrJepTnc+OrqWTMtUgBfFAK7B75ryPjZbwqnsgeEpDlXVWmn3wbaTJP?=
 =?us-ascii?Q?J6EDn6UOwA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038de61b-ea82-4f26-4d4c-08da5360e21a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:34:40.4982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oo1IL+5zOV2gwln/cqpLjchvvrbF9HdFrLsVwee1bQ9hCWyHxV+HrWkdc6QcSN/WIf5z6IoGPMSWvMFIPt8BcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently 'struct mlxsw_sp_fid_family' has a field which indicates if
'lag_vid' is valid for use in SFD register.

This is a leftover from using .1Q FIDs instead of emulating them using
.1D FIDs.

Currently when .1Q FIDs are emulated using .1D FIDs, this field is true
for both families, so there is no reason to maintain it.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h           | 1 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c       | 8 --------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 3 +--
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 36c6f5b89c71..8c647ab0b218 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1237,7 +1237,6 @@ int mlxsw_sp_setup_tc_block_qevent_mark(struct mlxsw_sp_port *mlxsw_sp_port,
 
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
-bool mlxsw_sp_fid_lag_vid_valid(const struct mlxsw_sp_fid *fid);
 struct mlxsw_sp_fid *mlxsw_sp_fid_lookup_by_index(struct mlxsw_sp *mlxsw_sp,
 						  u16 fid_index);
 int mlxsw_sp_fid_nve_ifindex(const struct mlxsw_sp_fid *fid, int *nve_ifindex);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 86b88e686fd3..118dee89f18f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -102,7 +102,6 @@ struct mlxsw_sp_fid_family {
 	enum mlxsw_sp_rif_type rif_type;
 	const struct mlxsw_sp_fid_ops *ops;
 	struct mlxsw_sp *mlxsw_sp;
-	u8 lag_vid_valid:1;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -137,11 +136,6 @@ bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index)
 	return fid_family->start_index == fid_index;
 }
 
-bool mlxsw_sp_fid_lag_vid_valid(const struct mlxsw_sp_fid *fid)
-{
-	return fid->fid_family->lag_vid_valid;
-}
-
 struct mlxsw_sp_fid *mlxsw_sp_fid_lookup_by_index(struct mlxsw_sp *mlxsw_sp,
 						  u16 fid_index)
 {
@@ -699,7 +693,6 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
 	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
-	.lag_vid_valid		= 1,
 };
 
 static bool
@@ -748,7 +741,6 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
 	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
 	.ops			= &mlxsw_sp_fid_8021q_emu_ops,
-	.lag_vid_valid		= 1,
 };
 
 static int mlxsw_sp_fid_rfid_configure(struct mlxsw_sp_fid *fid)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index a738d0264e53..bc84bf08c807 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2730,8 +2730,7 @@ static void mlxsw_sp_fdb_notify_mac_lag_process(struct mlxsw_sp *mlxsw_sp,
 
 	bridge_device = bridge_port->bridge_device;
 	vid = bridge_device->vlan_enabled ? mlxsw_sp_port_vlan->vid : 0;
-	lag_vid = mlxsw_sp_fid_lag_vid_valid(mlxsw_sp_port_vlan->fid) ?
-		  mlxsw_sp_port_vlan->vid : 0;
+	lag_vid = mlxsw_sp_port_vlan->vid;
 
 do_fdb_op:
 	err = mlxsw_sp_port_fdb_uc_lag_op(mlxsw_sp, lag_id, mac, fid, lag_vid,
-- 
2.36.1

