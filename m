Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87E75614EF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiF3IZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiF3IYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D462E62E1
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:24:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRw+GaRQY2yPm7Lx1gUVgCqkJ9/C6khYEYaH3QZHURe5pjoybs7cfT4vxgXnDYXZrTEf19dbQiunHffb8BO+oRIBcVt8Iahq04kSSySvfBw7cJKjinSMfynVL9jJnm6yKo6+E7osHshLo8vPmKYFTa5C7/2JUQITFtnaP51kPApDhuBqI60kxxXT8Jma1AUWNFeDLXsUKxMrpPVJiHJAheodQfdJtu6N0t4ZGMDhvGWVZBe1k5nBRzcAJMTALKzRybwvg4Y+iqv12B2YnxY5NAM9qPqGwMgXgw44mi1CblZT9i8NpIGjI7Rkrk/GGJ7uyJ8Y9svtgChygs2EZYOijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyRskEfZK0YuJy7KV/OaxIbV00lTh2jHHThWtumQbDQ=;
 b=dExWcDF02/QtKH0emfbCQbrM9NCycX8SA3eZ93hqp+U6jLQoRW/3GXz70S6vb9eZaawStZmhqBhyZkhhbt3PcwUmvHXH/gNRwppYpmAOzYVLz1nMIez/P3B9YpFExc9A4fjrDWFU6PzY9RJvK0xOXb/MM7x3yRWRLJrl6JK3SaQ6CrzKhsbKaoOXhZlwhScbH+Ilby9dROZIRiH8NK9ReC9hUKTP3IIDryHvH9Tshz+FGYXslY68IXAORO1UtoR6sz7PhVg/T55W4lRf8SS6XlzLrOtIZMCZTpqTrIJnDPj92W9r2ygFoGTuDKSVX+Roh4UmSu9RnZGN0VimCp0TrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyRskEfZK0YuJy7KV/OaxIbV00lTh2jHHThWtumQbDQ=;
 b=oKmc9saoesFV+fUt627t1ciFLNP5MqN5j8T+4eq5bt2vIBo67XUn2fQNLMAlah1udB/fB9BX2OA5INocaiHm1Z68LFZKJXDm+sLK8yEzSvQ3djRcwMx2J98Rb89ogTzpAKl2VWQmJZXA/WCsqjoE/bNgT4RVSH8ytWwN0BZUW+TPRvmv4HnlxevYw7X6tFF3Lrvyimj3mATWMcZ+M1FejSUzLwSI0TCZ2Bmjsu4JU1KvWT61PlpbSYTKNjQZ2pP6WE4c4GCFuoCNG8ho6j/rxdD3V3PBVU+nO+HdX3RfKrTg9df4i3APodaOxZQYn3Mu35Y0r8IeSGs8A7T6vtINbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:24:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:24:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/13] mlxsw: Add support for 802.1Q FID family
Date:   Thu, 30 Jun 2022 11:22:53 +0300
Message-Id: <20220630082257.903759-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0030.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb6cb27f-ee1d-4d97-25ef-08da5a71ea31
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JOBdSq5/HDUqLokoqLDhNzuF+w1wfdgViuLvu43bhZtUgH+0W/3JvOycr6tutypJn6WxR7p3pi6obqvhjx7BstewIAlNCaWqQeXgr0xW1WtULjyFO8AT8veYTLEKLfGbTm5b1Gcdf3ocQ2QHn/KC1zsVeHGJzW7pEmhe3ahPkrj5mGX8dPAbKAbW2t/OomSpiML0Q6UHr6ZogzMFQKoCRyPjWguhmyojFPxqWUMIhEErY5i1Bal/EUY8wKd9Xct0m/r0jTlUPW3hN+0OTR7puZ3CIOvFv/2VLkzICex5ktZQ6SHpCWiYgEuAxqvqRodDJwgFB6dcYFln4KszHU4at5unToQmJHGPnKcoh4aXM3r3CJaFOnkuhApPk054/S4Lc+3bK0Pxi2EQAx/CiCpRpkb0b8Kf2sNJ+qBXlo8jtD1UqtwZZXZNtX6GaeSkazehKXMPmWKJUY3/A466BWFLtS+q8Kg9NgAikG1Y156Op0rNUzpHbyKeUWArUl9NQaPWUTfSVHNyxUFJzy6iy7H9Kpvz1haDGHvJYiVzRfLNaJpnoFB6bAWVqgp65aJTVlJJ/FgbapnxrPbwdYjfr9fkNIVyyctd5PyczqyZs7tGO0uR+gsE4DVjX3bgR8dO8PwuL1E0pHgKrARDB8WuXE5aXxejJy9Re06AIz9g8RiB0KeprtOYckR3qDSuvbRTv9+PH1GEv8J+Ryf6fgpWuNBrUk3IlyuMb6Df2Go3VlHNkwDW9CfTlXEhKZZsAVcwtbz1ocMVEEA/c38UUhyUFPiu5hGtqKO7cVUowMr9AbXGw0e9o8R5YpXbxTAd/7PXgH4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(30864003)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003)(66574015)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uVczJyPrkz9pDdwFqx41bmwuUvIHZRwFSqJowFp/nk486Fg+12XAGGwqWErR?=
 =?us-ascii?Q?n0MdMkAgyqsQ4Kc3C02wFZ+q3hiaZX6Yx2GIUAK2IMgKf8UCx1ebPCT1BkjL?=
 =?us-ascii?Q?XCVnRulUS7iJwbkMh+IQksxPDhI25EDQT+J1lKa9wdjjlDYt/mSY7iBtK8c3?=
 =?us-ascii?Q?S1FXTa9nHmohvuQ8K7bjFRCVdUn+L2Bg5dq8hljR08xTQ72yc6PLhPbiaDXF?=
 =?us-ascii?Q?W3xT2zCWiIfDWuzco2/HjaoY6bbtsDfG3sJmUeVqPLWOqjdUgE0R4voG6ufA?=
 =?us-ascii?Q?PX9JzNfXyoUBABg5aCd/KZQo8FCljpMbtg9wM4KxI9ofKM7KEkFlEIix84VC?=
 =?us-ascii?Q?mBEcMcorn3pAQYGRqameP12jxjTzvB3dfnyw7l5WNE4IfUxwNWB0GqDYODYy?=
 =?us-ascii?Q?opD3Q2RF6MZNctRKtHQca9ZUG8jU9jkkAvzJD+o30z4NaPhhhD1fodQVGVy7?=
 =?us-ascii?Q?NGr66Xf762g4gfSQghoBpqlHeR88e9J5emMv5zYJNdXzWkEY3rCyNj/kiXBv?=
 =?us-ascii?Q?ei28v2UgRcvWVANs2NDMxW+i69lpkFMYjb26vfvr9INOYG0zVHPgN4uVF6O1?=
 =?us-ascii?Q?AcqBdJCmvNKlovnCEDZZsqzvbrNQaLrx9DIGlfQ2PnIMuKgetjPimLPEZAU5?=
 =?us-ascii?Q?JftdOv8Koe53PwvJebZz0EIb2WYVYccY9fYwz+90CKr1sHQobtuBjiP+O9X4?=
 =?us-ascii?Q?G96EQzWUtLDru/CBFN5dBzLAPTRt2Qgflgn6ytBJge8pungixEHD304WLVNA?=
 =?us-ascii?Q?Mxl6qJQ2UWvT/xIvxTV5gZF8TESsw/fF3UfdAXdFFKx9kvvSMvF7MGA1QHP9?=
 =?us-ascii?Q?KY//eCVlr6ZoKbR7esx4kYzTqcMvdusyBEK3OsAiOdjBUU9TchEJMKngtFdb?=
 =?us-ascii?Q?v6Wh8/GiDJcgh+bC3iBFEgnMk3OZ6Nj2aBXbvv/z00SjLSgjOu9suLjXQfwX?=
 =?us-ascii?Q?gCtuia0ouYs3tRADDNfAInNDDgTi6aQFDjuiDaUNOCnPQ2U3N6uA2vcIpqg9?=
 =?us-ascii?Q?6/xxwng85Ksh47XzP0lkAPb5h9BysrbFMt8MNQVyt9IEprCWG+H8aHPWfZ+o?=
 =?us-ascii?Q?uhPPjrfu9UjSoF5z6cG5nCErWhmV69UmH8osdWi4REJbl4ZuJBsL/NK28Jaj?=
 =?us-ascii?Q?IvB7ssYABOMX143HtRMRqpv+QXnMcDiwPUQ0ilL5VM0vhFwgx23LZIc2qDvl?=
 =?us-ascii?Q?FxElWxSiYtYeQmUJVMB2rtoj4Qh6f2u/qTx/51qZC6cZphNo2Yll+mmLEbM9?=
 =?us-ascii?Q?z12wXRMypTk3msuVoH/e6vzT5gSusGGUstmtpbutEbAxy43clWmwRxPp5/4s?=
 =?us-ascii?Q?phNFszvNRh1tYVSlyZoeWKjXYFnbnhnaLzCVVZW/ZDpII/c78/mDF+4BPAla?=
 =?us-ascii?Q?A/DoYzla1cEfkZi7PXvlM2LL5kb4kHUg3QhNiYmg3SfgEfAfAhCGm2IT/qkg?=
 =?us-ascii?Q?O0BgI7OD01lkyx8FCQhQaeMo9l+l5EsN2GqT4t5YjF5ilVqdmcBXf+20nP81?=
 =?us-ascii?Q?dz17HXamj5M/ZJeCpO0QEee1DjjPvigYQjl7t20R6WnwU91WcvmJn1pwkwrL?=
 =?us-ascii?Q?mvRpZe+PjYUSNoNpOP88+JeuFQClYUOvZr9bO+mZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6cb27f-ee1d-4d97-25ef-08da5a71ea31
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:24:13.5739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6SpeJ9PNSum01/vC8rzJwkMmCGTWhNThd/rK+HK2oZOevzEd3P/I3+KTtdO4nWj8vWfper1+l7ZdVPTRduIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Using the legacy bridge model, there is no VID classification at egress
for 802.1Q FIDs, which means that the VID is maintained.

This behavior cause the limitation that 802.1Q FIDs cannot work with VXLAN.
This limitation stems from the fact that a decapsulated VXLAN packet should
not contain a VLAN tag. If such a packet was to egress from a local port
using a 802.1Q FID, it would "maintain" its VLAN on egress, which is no
VLAN at all.

Currently 802.1Q FIDs are emulated in mlxsw driver using 802.1D FIDs. Using
unified bridge model, there is a FID->VID mapping, so it is possible to
stop emulating 802.1Q FIDs.

The main changes are:
1. Use 'SFGC.bridge_type' = 0, to separate between 802.1Q FIDs and
   802.1D FIDs.
2. Use VLAN RIF instead of the emulated one (VLAN_EMU which is emulated
   using FID RIF).
3. Create VID->FID mapping when the FID is created. Then when a new port
   is mapped to the FID, if it not in virtual mode, no new mapping is
   needed. Save the new port in 'port_vid_list', to be able to update a
   RIF in all {Port, VID}->FID mappings in case that the port will be in
   virtual mode later.
4. Add a dedicated operation function per FID family to update RIF for
   VID->FID mappings. For 802.1d and rFID families, just return. For
   802.1q family, handle the global mapping which is created for new 802.1q
   FID.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 192 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   3 +-
 2 files changed, 193 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 9dca74bbabb4..385deef75eed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -94,6 +94,8 @@ struct mlxsw_sp_fid_ops {
 	void (*nve_flood_index_clear)(struct mlxsw_sp_fid *fid);
 	void (*fdb_clear_offload)(const struct mlxsw_sp_fid *fid,
 				  const struct net_device *nve_dev);
+	int (*vid_to_fid_rif_update)(const struct mlxsw_sp_fid *fid,
+				     const struct mlxsw_sp_rif *rif);
 };
 
 struct mlxsw_sp_fid_family {
@@ -433,10 +435,15 @@ u16 mlxsw_sp_fid_8021q_vid(const struct mlxsw_sp_fid *fid)
 
 static void mlxsw_sp_fid_8021q_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	u16 vid = *(u16 *) arg;
 
 	mlxsw_sp_fid_8021q_fid(fid)->vid = vid;
-	fid->fid_offset = 0;
+
+	if (mlxsw_sp->ubridge)
+		fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
+	else
+		fid->fid_offset = 0;
 }
 
 static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
@@ -532,6 +539,35 @@ static int mlxsw_sp_fid_vni_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
 	return mlxsw_sp_fid_vni_to_fid_map(fid, rif, fid->vni_valid);
 }
 
+static int
+mlxsw_sp_fid_vid_to_fid_map(const struct mlxsw_sp_fid *fid, u16 vid, bool valid,
+			    const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char svfa_pl[MLXSW_REG_SVFA_LEN];
+	bool irif_valid;
+	u16 irif_index;
+
+	irif_valid = !!rif;
+	irif_index = rif ? mlxsw_sp_rif_index(rif) : 0;
+
+	mlxsw_reg_svfa_vid_pack(svfa_pl, valid, fid->fid_index, vid, irif_valid,
+				irif_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
+}
+
+static int
+mlxsw_sp_fid_8021q_vid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					 const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
+
+	/* Update the global VID => FID mapping we created when the FID was
+	 * configured.
+	 */
+	return mlxsw_sp_fid_vid_to_fid_map(fid, fid_8021q->vid, true, rif);
+}
+
 static int
 mlxsw_sp_fid_port_vid_to_fid_rif_update_one(const struct mlxsw_sp_fid *fid,
 					    struct mlxsw_sp_fid_port_vid *pv,
@@ -555,6 +591,10 @@ static int mlxsw_sp_fid_vid_to_fid_rif_set(const struct mlxsw_sp_fid *fid,
 	u16 irif_index;
 	int err;
 
+	err = fid->fid_family->ops->vid_to_fid_rif_update(fid, rif);
+	if (err)
+		return err;
+
 	irif_index = mlxsw_sp_rif_index(rif);
 
 	list_for_each_entry(pv, &fid->port_vid_list, list) {
@@ -582,6 +622,7 @@ static int mlxsw_sp_fid_vid_to_fid_rif_set(const struct mlxsw_sp_fid *fid,
 		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
 	}
 
+	fid->fid_family->ops->vid_to_fid_rif_update(fid, NULL);
 	return err;
 }
 
@@ -599,6 +640,8 @@ static void mlxsw_sp_fid_vid_to_fid_rif_unset(const struct mlxsw_sp_fid *fid)
 
 		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
 	}
+
+	fid->fid_family->ops->vid_to_fid_rif_update(fid, NULL);
 }
 
 static int mlxsw_sp_fid_reiv_handle(struct mlxsw_sp_fid *fid, u16 rif_index,
@@ -1078,6 +1121,13 @@ mlxsw_sp_fid_8021d_fdb_clear_offload(const struct mlxsw_sp_fid *fid,
 	br_fdb_clear_offload(nve_dev, 0);
 }
 
+static int
+mlxsw_sp_fid_8021d_vid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					 const struct mlxsw_sp_rif *rif)
+{
+	return 0;
+}
+
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.setup			= mlxsw_sp_fid_8021d_setup,
 	.configure		= mlxsw_sp_fid_8021d_configure,
@@ -1092,6 +1142,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.nve_flood_index_set	= mlxsw_sp_fid_8021d_nve_flood_index_set,
 	.nve_flood_index_clear	= mlxsw_sp_fid_8021d_nve_flood_index_clear,
 	.fdb_clear_offload	= mlxsw_sp_fid_8021d_fdb_clear_offload,
+	.vid_to_fid_rif_update  = mlxsw_sp_fid_8021d_vid_to_fid_rif_update,
 };
 
 #define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
@@ -1341,6 +1392,13 @@ static void mlxsw_sp_fid_rfid_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 	WARN_ON_ONCE(1);
 }
 
+static int
+mlxsw_sp_fid_rfid_vid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					const struct mlxsw_sp_rif *rif)
+{
+	return 0;
+}
+
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.setup			= mlxsw_sp_fid_rfid_setup,
 	.configure		= mlxsw_sp_fid_rfid_configure,
@@ -1353,6 +1411,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.vni_clear		= mlxsw_sp_fid_rfid_vni_clear,
 	.nve_flood_index_set	= mlxsw_sp_fid_rfid_nve_flood_index_set,
 	.nve_flood_index_clear	= mlxsw_sp_fid_rfid_nve_flood_index_clear,
+	.vid_to_fid_rif_update  = mlxsw_sp_fid_rfid_vid_to_fid_rif_update,
 };
 
 #define MLXSW_SP_RFID_BASE	(15 * 1024)
@@ -1437,6 +1496,103 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 };
 
+static int mlxsw_sp_fid_8021q_configure(struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
+	int err;
+
+	err = mlxsw_sp_fid_op(fid, true);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_fid_vid_to_fid_map(fid, fid_8021q->vid, true, fid->rif);
+	if (err)
+		goto err_vid_to_fid_map;
+
+	return 0;
+
+err_vid_to_fid_map:
+	mlxsw_sp_fid_op(fid, false);
+	return err;
+}
+
+static void mlxsw_sp_fid_8021q_deconfigure(struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
+
+	if (fid->vni_valid)
+		mlxsw_sp_nve_fid_disable(fid->fid_family->mlxsw_sp, fid);
+
+	mlxsw_sp_fid_vid_to_fid_map(fid, fid_8021q->vid, false, NULL);
+	mlxsw_sp_fid_op(fid, false);
+}
+
+static int mlxsw_sp_fid_8021q_port_vid_map(struct mlxsw_sp_fid *fid,
+					   struct mlxsw_sp_port *mlxsw_sp_port,
+					   u16 vid)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 local_port = mlxsw_sp_port->local_port;
+	int err;
+
+	/* In case there are no {Port, VID} => FID mappings on the port,
+	 * we can use the global VID => FID mapping we created when the
+	 * FID was configured, otherwise, configure new mapping.
+	 */
+	if (mlxsw_sp->fid_core->port_fid_mappings[local_port]) {
+		err =  __mlxsw_sp_fid_port_vid_map(fid, local_port, vid, true);
+		if (err)
+			return err;
+	}
+
+	err = mlxsw_sp_fid_evid_map(fid, local_port, vid, true);
+	if (err)
+		goto err_fid_evid_map;
+
+	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
+					     vid);
+	if (err)
+		goto err_port_vid_list_add;
+
+	return 0;
+
+err_port_vid_list_add:
+	 mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+err_fid_evid_map:
+	if (mlxsw_sp->fid_core->port_fid_mappings[local_port])
+		__mlxsw_sp_fid_port_vid_map(fid, local_port, vid, false);
+	return err;
+}
+
+static void
+mlxsw_sp_fid_8021q_port_vid_unmap(struct mlxsw_sp_fid *fid,
+				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 local_port = mlxsw_sp_port->local_port;
+
+	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
+	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+	if (mlxsw_sp->fid_core->port_fid_mappings[local_port])
+		__mlxsw_sp_fid_port_vid_map(fid, local_port, vid, false);
+}
+
+static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_ops = {
+	.setup			= mlxsw_sp_fid_8021q_setup,
+	.configure		= mlxsw_sp_fid_8021q_configure,
+	.deconfigure		= mlxsw_sp_fid_8021q_deconfigure,
+	.index_alloc		= mlxsw_sp_fid_8021d_index_alloc,
+	.compare		= mlxsw_sp_fid_8021q_compare,
+	.port_vid_map		= mlxsw_sp_fid_8021q_port_vid_map,
+	.port_vid_unmap		= mlxsw_sp_fid_8021q_port_vid_unmap,
+	.vni_set		= mlxsw_sp_fid_8021d_vni_set,
+	.vni_clear		= mlxsw_sp_fid_8021d_vni_clear,
+	.nve_flood_index_set	= mlxsw_sp_fid_8021d_nve_flood_index_set,
+	.nve_flood_index_clear	= mlxsw_sp_fid_8021d_nve_flood_index_clear,
+	.fdb_clear_offload	= mlxsw_sp_fid_8021q_fdb_clear_offload,
+	.vid_to_fid_rif_update  = mlxsw_sp_fid_8021q_vid_to_fid_rif_update,
+};
+
 /* There are 4K-2 802.1Q FIDs */
 #define MLXSW_SP_FID_8021Q_UB_START	1 /* FID 0 is reserved. */
 #define MLXSW_SP_FID_8021Q_UB_END	(MLXSW_SP_FID_8021Q_UB_START + \
@@ -1455,6 +1611,22 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 #define MLXSW_SP_RFID_UB_END		(MLXSW_SP_RFID_UB_START + \
 					 MLXSW_SP_FID_RFID_UB_MAX - 1)
 
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021Q_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
+	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
+	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
+	.ops			= &mlxsw_sp_fid_8021q_ops,
+	.flood_rsp              = false,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_0,
+	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
+	.smpe_index_valid	= false,
+	.ubridge                = true,
+};
+
 static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
@@ -1498,11 +1670,28 @@ const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
 
+	[MLXSW_SP_FID_TYPE_8021Q_UB]	= &mlxsw_sp1_fid_8021q_ub_family,
 	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp1_fid_8021d_ub_family,
 	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp1_fid_dummy_ub_family,
 	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
 };
 
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021Q_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
+	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
+	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
+	.ops			= &mlxsw_sp_fid_8021q_ops,
+	.flood_rsp              = false,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_0,
+	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
+	.smpe_index_valid	= true,
+	.ubridge                = true,
+};
+
 static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
@@ -1534,6 +1723,7 @@ const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
 
+	[MLXSW_SP_FID_TYPE_8021Q_UB]	= &mlxsw_sp2_fid_8021q_ub_family,
 	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp2_fid_8021d_ub_family,
 	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp2_fid_dummy_ub_family,
 	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7186f6a33685..aeaba07c17b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7730,7 +7730,8 @@ u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 	/* We only return the VID for VLAN RIFs. Otherwise we return an
 	 * invalid value (0).
 	 */
-	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN_EMU)
+	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN_EMU &&
+	    rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN)
 		goto out;
 
 	vid = mlxsw_sp_fid_8021q_vid(rif->fid);
-- 
2.36.1

