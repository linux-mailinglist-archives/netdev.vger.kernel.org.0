Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD29552D23
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348226AbiFUIgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347890AbiFUIgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:36:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCE725E9F
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLojL7zR6gG66qhmFsl1O7tWFSzQCsK421PDgemaXIv/QFCT/LeAVaczewO/MxiixGI8gVzmi+rWClULv1jfg5hz/sf9UM23RtjqAf9wfaLQqHrkIxWQfPF1y3FDlhZFcUqsL4EE1I9ZXg+p4xZvyIqTFgtX/+kKCk8nLAwfy6hghc7/q2/e3qQvKqqM3kMQei6WTvaqSYzi0hUQlyAP/1+0gZCTx4fZNKeZyJQBFaCk2CQh/zsnOL+grz/6BB/MWIwFwZumIhaJRlCJdZgXpolyymjXCqrXFbvfKsKB05gks+Me+etuGA0xcy0CxpRZn6JWWMhv76TxOhJ75wAKzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8L1E5OPAEzLianH2LSXibDPG9Ua/rSimFF8SrP1FG8=;
 b=QmWrsELf/SUhptyJcMX9rX+73Mrf9NYtnKIQgqsqmIJWbjTUNvAxe1LKXUdlFMqoIGXM8ddxzoyznEwkioj6IiSUQQZPLeRzsD8EjJM+CDCJVG+m/Kx0pxWvG4GOeDL0RoPgHmZa07z1M/Czdi9TTNVPEQP5N7WeA71bC8avNEmVXg6YrWXtjAzMfKfoPkUCN6yB/YgxFwI0Mdoy8CuuU+TqzMycnkXFgrgtpRJir5pCtBAAjQBjNSE90rkxy8JZvrj7TNmmOmnD7Oir/uMna7eIyKRRG8nUP1XB5Vb1mWegcE+7sCL9YMhgRrh2a6inFmvQJmZ+ZjnyOwiU+Qk9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8L1E5OPAEzLianH2LSXibDPG9Ua/rSimFF8SrP1FG8=;
 b=n0CCIHdIrfuxHikhhwZPWOQ82QTcaWIfcqHI5BIqtzuHNLLNDsjSDDiAL4OUojRhWrptZWH4nPyJYARU6Zx+Fhckn61T7K+5m7IBSmoQAPuzEJ2SnsyZwu3dCgH6RxY4kZ6RRrQ7V0zPrfZpG/KLPW/WYz8KpzcvAg/8zUpRDB7UYiuzwl/krGSBP/LBxpTsJK92p6Vj8qPN7ijEgeD4iv9lgDFeJfv+v1HHU2mAkxQs8m+i5RlKUUqJt1JCjuUraRoLv24THPSOLZb51oB49/Mz6dezy47WjkoWsgleQ+oKeHxvn0cAhv/0Ixb7rfsmVkqRLAHW/ucywSwFVvXAcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:36:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:36:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/13] mlxsw: spectrum_fid: Implement missing operations for rFID and dummy FID
Date:   Tue, 21 Jun 2022 11:33:45 +0300
Message-Id: <20220621083345.157664-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0056.eurprd09.prod.outlook.com
 (2603:10a6:802:28::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 744fef4f-55e8-4749-a8f3-08da536112ce
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38325C253D6336573023CCC5B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WVMK5TawQ88hgwOBh9Yd3dZtz3o31US17Hc1PXPK/P2wjRRBFGonVmwLRMGZqwvdJZpG4W4Eijse9WWAKuSTyVD134PlOU3Yd4OhMq+i2NMIqTq+jjhWKIvjJSKTTdrnk7XOvkZf9tyKMI2k32+Hv5NEFZ/pew391uxOe1fQb4lz59AoAzc/N9VUk+9JtSI1mqSSs9kSAS5VowWTwXfKu/ebVaUNNRzf9D6IuVYy0f/LMGL4lEKKrWPWQXo0iVuctN4n+nzIiGbyNsDXefdFe2TVg2Q4bst5lE7OaU+9dddwTCC/qltAwpurVCJxy+e3VhrWdTdCIEPObP8dmL0VF3tcWvVFQtcaTFLgQVfkNaNjhvWC2a37LgTjaQak18daVxruJ+3nAtv6pWxIEd/G9gNlEd7BY7Kp20ncml88bqlelqGBAGng2C693akRj+RvEIylHMI72s/Rgeh5XCbXlaRGx3iVcVsLiRkeSXKEY6GVqlQE0YF0VJvrC/ntMT4gBGjbS+TpCsFHMqioLqbQ0ULoa7dOX9b81wcuYkCrMDu1+V4ENMjP9JoFYGVxKBIKrauKlLCp6nFKZ1M3UArSA+V4C7BVhlFNk/nr3Y4XdrXit6uvUHtQFyX9AAjKWVNYlknxpe4bk4Fc15zSTXvRGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IHBTBxNv7lPS/mH0qOS0c8E5TYPxr+2XGp6o4z5OdMQwaO9wIdVOFXxxGTWt?=
 =?us-ascii?Q?vUNNCbFBE+4e4Rl22NK2IM9QvOUe0/NriiZLpzqfUKFEFd/uqx02tpRwIPhT?=
 =?us-ascii?Q?8/pAY4c5VwQEzatF5A/LJrADm/4qRcag6FLRoydshweVU6nZU0dhUys4kp6E?=
 =?us-ascii?Q?CVpaiW9EAo3OjY4Ti03Hbsg439VT2DkR1sRmdtUrdt00ng/0KRqSyJDiDxS0?=
 =?us-ascii?Q?bVMPW5Mcvyu2+/ut4tNePLPg8Wk8y+Ks9Hzt3dlCrUzI9fbkTPlHCXuStst0?=
 =?us-ascii?Q?Hc6VXAPdEmfuMOkurVgMoePgONkcdhtNHQwu8U69zoarxjlgIctDqfXMVJBO?=
 =?us-ascii?Q?XcOClUF2XLf1e5bmJ3clT1U8axZ63mPbvlHqQFCrMaSauBGFByqQmdrhAaDn?=
 =?us-ascii?Q?QnaRGlQWWEZpEtOeA7GEzCj7NJcfdHzUBl6V/b7eAhxdX/3Mw9j14Zk2qvWe?=
 =?us-ascii?Q?pGLjFr5WpTJ+O0FDLWOJqJxHp4yYBmk02UUPNppKn/Hh/d1KaNcdrCy/9Z6a?=
 =?us-ascii?Q?kdRjqDecYSWOxpOXU9A+lEQMYLBUT5DIc+hnAUp6wv3SIbK0g5DbKDoGDzzx?=
 =?us-ascii?Q?ohltsDJneQiMKOaZ7RNjjYb0YAdy4Qe/H3NWHf5/J0TRWtYkkGEiaOeqKUSF?=
 =?us-ascii?Q?cKaPI62daxV1jtLrgjqltXGTWlwHahPYLLLIgRSKItQHDaHUj9Wfb5OrcZLJ?=
 =?us-ascii?Q?fDYlryE3DaKVoMKrKj2gwciVxLoJntWQUrjZENjhGFhgNxfa1QJ1M3DIN0eC?=
 =?us-ascii?Q?SZjWZLjpAhHtzb5jT1td2iXrbJOrOnqfu49DMcfdyR2Zrx0FkldJt/XQHnyM?=
 =?us-ascii?Q?+/QAX8Hno6TnQ6zrMKUHwFeaCATakv0NkZUhnFmnVWjGgoElw7wWvFnDWdnG?=
 =?us-ascii?Q?zn7Uk+zeLDyTb7RSmosOtOmZ5yx7/GoqgyVzsNH5yzCCLs/qLOdqdjBLeBnE?=
 =?us-ascii?Q?bzwWFLGx2k2tIvPZB0vMpWyTbVKMKwTy3PuKSIhXuoaD9OJkD8aTGWu0ylm1?=
 =?us-ascii?Q?pkMpb9k2/3G25a418cibYdLy8RpcPnPjdApRbdUbGq1Spfh6f+3reUpePP8N?=
 =?us-ascii?Q?Mn7VcUP3LDcMXDgos4Ke+tiHq7npVLjhGjxYo1wpxWNfe2IJvw0Cw6EUpL6j?=
 =?us-ascii?Q?0GumXH+G+ACcMzqLkzS/3zugdMEn/m9XLWp9RNe+S+XAhOusPSbgil9grS4B?=
 =?us-ascii?Q?6I5suOA04yswYWo9EZOVy/idE/FF+E4RT/jrW1Lfcrj30xBR1DwCvAd0Po5l?=
 =?us-ascii?Q?am7VuSIEeoQ6tGjrDslZjWcFvAeSOt+wTxbnYCuArNvj0ksK8KYKRoUbWCzL?=
 =?us-ascii?Q?4X2SYrESTvrQuGp8Fu9OJD5dMahdPoPa0dH9InqAKjGwXGYXO38LNBnqbB+J?=
 =?us-ascii?Q?mk7L40UHJVgpYpO+fV1BtJwxcKSEMjninHHR6Ttdy0S5uxNJycWZR6X+9sv1?=
 =?us-ascii?Q?H47eQXH1jXsbpZ0sU6oFklHVCb6PA5F3rgrgu811nmJQ1aL1ShEpQqGETxPQ?=
 =?us-ascii?Q?1lx5omaqPjcdmjsl03K3LN7dzkYtwrzENr/7eqVE9NxnhHp1lJCLDemGp+49?=
 =?us-ascii?Q?py0Xw1T8FO3GVTarqIY7PIFJN3x8wDowxFbPweWnsnmKhljYgevu0heQ0MQc?=
 =?us-ascii?Q?ytiaxIs7aHe2n/BssW9x0nkb/iDtMkCQRfka6g7gvsuZ1tBgWM0mTgeB5Ew7?=
 =?us-ascii?Q?zrXw//GjKQYC8Xf3NJlWhtG09XqoU6FILkkSPmII/dUBHJWbwz52+mKxU3Wq?=
 =?us-ascii?Q?6GJpkYPG7A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744fef4f-55e8-4749-a8f3-08da536112ce
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:36:02.0062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJkhUPCDwXA2WQLxGd9le20yrJOz19r5f5AjSVjpBEtzf95nN8h85Z8FQilqzMq36tHDSKakzovCZWePT1gbFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
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

rFID and dummy FID do not support FID->VNI mapping. Currently, these
families do not implement the vni_{set, clear}() operations. Instead, there
is a check if these functions are implemented.

Similarly, 'SFMR.nve_tunnel_flood_ptr' is not relevant for rFID and dummy
FID, therefore, these families do not implement
nve_flood_index_{set, clear}().

Align the behavior to other unsupported operations, implement the functions
and just return an error or warn. Then, checks like '!ops->vni_set' can be
removed.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 58 +++++++++++++++++--
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index fe5a60bfbf59..69c6576931b5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -201,7 +201,7 @@ int mlxsw_sp_fid_nve_flood_index_set(struct mlxsw_sp_fid *fid,
 	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	int err;
 
-	if (WARN_ON(!ops->nve_flood_index_set || fid->nve_flood_index_valid))
+	if (WARN_ON(fid->nve_flood_index_valid))
 		return -EINVAL;
 
 	err = ops->nve_flood_index_set(fid, nve_flood_index);
@@ -219,7 +219,7 @@ void mlxsw_sp_fid_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 
-	if (WARN_ON(!ops->nve_flood_index_clear || !fid->nve_flood_index_valid))
+	if (WARN_ON(!fid->nve_flood_index_valid))
 		return;
 
 	fid->nve_flood_index_valid = false;
@@ -239,7 +239,7 @@ int mlxsw_sp_fid_vni_set(struct mlxsw_sp_fid *fid, enum mlxsw_sp_nve_type type,
 	struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
 	int err;
 
-	if (WARN_ON(!ops->vni_set || fid->vni_valid))
+	if (WARN_ON(fid->vni_valid))
 		return -EINVAL;
 
 	fid->nve_type = type;
@@ -271,7 +271,7 @@ void mlxsw_sp_fid_vni_clear(struct mlxsw_sp_fid *fid)
 	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
 
-	if (WARN_ON(!ops->vni_clear || !fid->vni_valid))
+	if (WARN_ON(!fid->vni_valid))
 		return;
 
 	fid->vni_valid = false;
@@ -820,6 +820,27 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 }
 
+static int mlxsw_sp_fid_rfid_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
+{
+	return -EOPNOTSUPP;
+}
+
+static void mlxsw_sp_fid_rfid_vni_clear(struct mlxsw_sp_fid *fid)
+{
+	WARN_ON_ONCE(1);
+}
+
+static int mlxsw_sp_fid_rfid_nve_flood_index_set(struct mlxsw_sp_fid *fid,
+						 u32 nve_flood_index)
+{
+	return -EOPNOTSUPP;
+}
+
+static void mlxsw_sp_fid_rfid_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
+{
+	WARN_ON_ONCE(1);
+}
+
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.setup			= mlxsw_sp_fid_rfid_setup,
 	.configure		= mlxsw_sp_fid_rfid_configure,
@@ -828,6 +849,10 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.compare		= mlxsw_sp_fid_rfid_compare,
 	.port_vid_map		= mlxsw_sp_fid_rfid_port_vid_map,
 	.port_vid_unmap		= mlxsw_sp_fid_rfid_port_vid_unmap,
+	.vni_set                = mlxsw_sp_fid_rfid_vni_set,
+	.vni_clear		= mlxsw_sp_fid_rfid_vni_clear,
+	.nve_flood_index_set	= mlxsw_sp_fid_rfid_nve_flood_index_set,
+	.nve_flood_index_clear	= mlxsw_sp_fid_rfid_nve_flood_index_clear,
 };
 
 #define MLXSW_SP_RFID_BASE	(15 * 1024)
@@ -874,12 +899,37 @@ static bool mlxsw_sp_fid_dummy_compare(const struct mlxsw_sp_fid *fid,
 	return true;
 }
 
+static int mlxsw_sp_fid_dummy_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
+{
+	return -EOPNOTSUPP;
+}
+
+static void mlxsw_sp_fid_dummy_vni_clear(struct mlxsw_sp_fid *fid)
+{
+	WARN_ON_ONCE(1);
+}
+
+static int mlxsw_sp_fid_dummy_nve_flood_index_set(struct mlxsw_sp_fid *fid,
+						  u32 nve_flood_index)
+{
+	return -EOPNOTSUPP;
+}
+
+static void mlxsw_sp_fid_dummy_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
+{
+	WARN_ON_ONCE(1);
+}
+
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_dummy_ops = {
 	.setup			= mlxsw_sp_fid_dummy_setup,
 	.configure		= mlxsw_sp_fid_dummy_configure,
 	.deconfigure		= mlxsw_sp_fid_dummy_deconfigure,
 	.index_alloc		= mlxsw_sp_fid_dummy_index_alloc,
 	.compare		= mlxsw_sp_fid_dummy_compare,
+	.vni_set                = mlxsw_sp_fid_dummy_vni_set,
+	.vni_clear		= mlxsw_sp_fid_dummy_vni_clear,
+	.nve_flood_index_set	= mlxsw_sp_fid_dummy_nve_flood_index_set,
+	.nve_flood_index_clear	= mlxsw_sp_fid_dummy_nve_flood_index_clear,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
-- 
2.36.1

