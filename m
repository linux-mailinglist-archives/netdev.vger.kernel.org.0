Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DCA55FC50
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiF2Jkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiF2Jkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:40:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51AB35DDF
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:40:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM/WeonZbVOLFmTaNc4sw1l9hmrTx4CA9tMeZ+R+o77+p8FlQuuuHBHb0YnQdROAZR0S/KwIVOVSCcPzhSyQhAhB7rfoTwZbn1mlTkF4Bc55wK78U3SC9SzX51DJoRlyd50arZaPLQJfId/SFsFJUasaY/6xv0/u38unxq/85HXRH082bs/dtq011/Vs9Bl/wI8d5tHCjRPCDOq8fYteaNIz8olrrZ7FfM4lajuuEyQEi+Fhoi6Slq5e1WbdYLrPl7IuqZZPnU9pRV/59sjrKSy0+6S5QE9Tj/uhh0yv/w5sr4GAMjVP4L4NtHlN+c3YHDAYb/VklngxykD9JdDCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMgG9lz7pAUlW0mfypHOf0z0ye5p5mgvOcEP1DMbbsY=;
 b=kbXp6UIyb2LiDj4DVM1pUxBv1nC41sMsxao0II/3/FUJdznvmVO6OOxRMoe6BxkoPbUQWVn4VJ+sEREOuS+0uGm5RjQ6DNx45TuekJ7btFw35XM00W1lDifvxVmgRoCT2IIRcP7yM72oDLRs8Bulv9YXNPDUJ6JZEZFXeSXrSVm3nFMaKLGMAzS/6ad5qhrUqefTeHT/xDQZu7dNbwhl0cfJ0zivaMxCrvYZUB+A7QGEGOovWUhAjkZbMpGrGX0x25rgbWmO8YUHEF3GqlQstQ/dkexgpcN1HOi6PAB71OZR3Z0wU5Bty3iHVT1ewISD16IFIpEmhROGAUxSl2bmLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMgG9lz7pAUlW0mfypHOf0z0ye5p5mgvOcEP1DMbbsY=;
 b=r88mVJzVWNHxYH4463ooKDHaduP5TF5isvquje9FMkWHNq6G/Tos717yDgEs5VDL/XPwGKNTVT8tjGm7Qfp/QeP2NG/s0gLZ/PfinOrpfeDNRsH6Bkm1rWu8bfVeGhuwAME3l6iuPnDJnqsJw8d1r9EWEvamnjVrrgx2ObI8Et8GWyGqgCBdrhQhbjDtFiEQARa85pNKtu/ybpNMcgKT43mnwqWCq1ljuBbFK+Y2IlDgcjNwlaj4CsDCUc1DQrc9pdbfoPSDnW9DgBeFvf03agzKo6Tem/hO+5ir3FMILR2utitivDjFxZYzv0rhYfhysTCm3vX6Z/um7YEUl9/E9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:40:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:40:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_switchdev: Rename MID structure
Date:   Wed, 29 Jun 2022 12:39:59 +0300
Message-Id: <20220629094007.827621-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0029.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4f80e83-2f3d-49c9-8793-08da59b36ddd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSYPLk1Jg90QJg+78ymwpKugJBK5J2CApbG4jl1PjQsqwImLKFKU9jTJhgmQwVX5IbtfjCEF5aGVt3EUqOxImz9dKtKDBTkHURnDCBTbghQOXZ7nX8KUJYEYdLjEPu7+MNWQe/dzcn1AtlLr7xxQaxVTsBTs6p+4YjCvmNsEDfKY/CQQWFSGjWxr/siNpH7Y1/FHR8gg16dqAzO7cKE+tuNbyxfoi5VD7RHU4DC8HtliOC8Bw50VcvukYA9AeePdhSRnnyU3YaTA0dJTPBGrsGEzRu0riPRS2NQBipzxcu/rRCkQxDoQrTCrYOirdXYTQ5ynmoWzGZxjhYATruBJQeml1l41uY7Zqvp95IkMN3YBwu8KIk80gOloMnspOte7BDUi4xJNXFcxWZsOvKw4+s2fBr1xMk8DUC4BJnjxqeik0HGB8agwdVpqfYB1UTXBBSgjy9HB458l2GG849B4snuYDsUQ3Jtc+o1kmu8T5A8HeEFstCC+BSg2BmCgSUaC3w9UnAnaHCslMIudNfZUKyT1Q39rAivhty495PXz/TlEzgfdNw5IDbJbq47z0Tq9yky7/eFd9wplMfcRd5aZasZteP+xaAFJ+IWT55nS7VbuNDrTK5kJFgX3ThvdjgLXuH1cfBDGEZE5u+RrkpOkL8IFvvjkI8//3Hd4/tj+9XGonocaZRjN5XQ6e590lx75RI6blVRUbMdME1c6qAqoqPdb2d8j0XpIZykqHGGyE0bsOw2jYoqcKCu4HCeQ3sGF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(66574015)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(30864003)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M7TRX7fwMEqEkpiNK334SaO451FTLjEbId+tNOz4dBOhD241KeR1vptW48AR?=
 =?us-ascii?Q?F/8D61dwMz2hE+gF6EJl9v+26MdBRoZHrTBI/PB1hibKgmAq3CysbTK5Ou6Q?=
 =?us-ascii?Q?8hmGYTY58Tm2pGc+h7hR0RdbLdpuf0qbfPQl56/RRzjUvX59A3yG97b/Rqrh?=
 =?us-ascii?Q?7W+Q37xE1N0zEiIWdLaa/+PGnwbFvMzznpjQfDxasT8trgIayegPGzR1/SIO?=
 =?us-ascii?Q?tkRQF2/LhRF3FtAhu9W5W7EGyD3IvrRyBNrT5iwmbdhTR/HcEVqOknofrawU?=
 =?us-ascii?Q?DC8QcUIK3inX42PxrAHAwJ/NJzvVDdWsiJTzQERgGZPc6JCovRi2yy+Ixb6x?=
 =?us-ascii?Q?npfoyCgbyzMgFhoMMr6nKVRbSotBAhVaiw1L82GbkQ1bn/vL2H/UKagd3XJl?=
 =?us-ascii?Q?knHdzOVJXbyFU3M6+SvoIErjqHfrLnb42Ue1pwg7XZLpzVZEe5RQl2/fNy1c?=
 =?us-ascii?Q?LmfpiRIRe/fqfx7hFb9rSaH0KUREv9UtQCIFNb3wqVyg1StWXMGLZJWTOF+g?=
 =?us-ascii?Q?7J/FeyN/3xaDodwB+0vZb4/BJsTEzcxCOMbQqYYwrr7BkSn5Ei7n/wkEj2uR?=
 =?us-ascii?Q?2ab+A5cUlwMyw3vPAceH/XeSQIOuECzbgERefwrcZSpPoBXOhNKX/TmowA6J?=
 =?us-ascii?Q?CB3etGrSL/l1uxMLXqWNXOkYWGxGrVUIkFgiut6l/wB/g1K18sRAIhTuy0Du?=
 =?us-ascii?Q?oHdh7W5JzMDWiTYkMS6P/8rEfkn/w/sReczXp8STIJRsFqyqCTFvYehf0n7f?=
 =?us-ascii?Q?xD9xRtPoaWa0iMKutAorj+oEK5yEoWU6chYod3asX328L2Yc0VbDJFBX97P1?=
 =?us-ascii?Q?db4HXIz49G2JwdN4qQ/o/NIJ6YtkKd/1/6g2bdbaqNyBx580d284DVwM3I9w?=
 =?us-ascii?Q?jCFYwWX9/gYVv43L2VI1Ws7gokGYrHwI5MnsLfYMu+XK87F/BBC+7jfHJrx6?=
 =?us-ascii?Q?4NlK8wPhTxHLLMFaQPt968Z4Kt/mrCa33iFRisEZ0MIbglBmvg/tGjS/pp/w?=
 =?us-ascii?Q?mLqzHcRfju/omnHPmHEoWQiYrIcEJcSq+KTDA0l/UowmdIz4gJnzjvXTeobb?=
 =?us-ascii?Q?ue2JKL4FZxVxKM7+EIq7FhobuX2MC81BWZiAm+1YfdICZGGXTzNkPwbvAmDU?=
 =?us-ascii?Q?3SPQgdkU0zvAHiQZeEMPA7PrAuf1YAgxH+oNGec4lo4Suhyyo720H1rzb8Sb?=
 =?us-ascii?Q?C7RFr2OIw8uWDI459o0gvafe5EwY4Pzo2fZaDpmgIciIFU1GYmc4fTicpq6E?=
 =?us-ascii?Q?hYzRcw+cu+8O897D4RgoL/G+xnnnZabz7iKCPo5Y95GATbHkvaDUAE+Hqse/?=
 =?us-ascii?Q?boPhcKazSpnHVdPVca4Kb6/THG/UetL1RPCZ6bZdFpOolpZ+muS4uT4/Hqu0?=
 =?us-ascii?Q?eATnqtAhK/GXZhQAauKOhAz0ruyS8g+PQ3J6av37Q6X+AnjRYRj+jBYM3Y6Q?=
 =?us-ascii?Q?0mMpHmi4I560NnLgvh2/o25aewrKSVnyBROFkC86W1hcW1mU13mkZU+Vvcw1?=
 =?us-ascii?Q?cAc+7GNzbRYm9dVTlfEFZFKUBM20aTimERmR5dkLVBIjIvVHzpGxSRo1CyIX?=
 =?us-ascii?Q?0uLkm+d+8Jt80rI+Vw/SqDe9X0R20pRv2Y3CadYO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f80e83-2f3d-49c9-8793-08da59b36ddd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:40:40.5618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgo4WkYiNPlQAsnYgFlq0empFFwGpCXaO0GUGHOxZmpELhRRynE1sCUWFraCbED8xysXdC3lI60TiYippS/0/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3850
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

Currently the structure which represents MDB entry is called
'struct mlxsw_sp_mid'. This name is not accurate as a MID entry stores a
bitmap of ports to which a packet needs to be replicated and a MDB entry
stores the mapping from {MAC, FID} to PGT index (MID).

Rename the structure to 'struct mlxsw_sp_mdb_entry'. The structure
'mlxsw_sp_mid' is defined as part of spectrum.h. The only file which
uses it is spectrum_switchdev.c, so there is no reason to expose it to
other files. Move the definition to spectrum_switchdev.c.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   9 -
 .../mellanox/mlxsw/spectrum_switchdev.c       | 179 ++++++++++--------
 2 files changed, 97 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b7709e759080..8de3bdcdf143 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -112,15 +112,6 @@ enum mlxsw_sp_nve_type {
 	MLXSW_SP_NVE_TYPE_VXLAN,
 };
 
-struct mlxsw_sp_mid {
-	struct list_head list;
-	unsigned char addr[ETH_ALEN];
-	u16 fid;
-	u16 mid;
-	bool in_hw;
-	unsigned long *ports_in_mid; /* bits array */
-};
-
 struct mlxsw_sp_sb;
 struct mlxsw_sp_bridge;
 struct mlxsw_sp_router;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index e153b6f2783a..70b48b922520 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -102,6 +102,15 @@ struct mlxsw_sp_switchdev_ops {
 	void (*init)(struct mlxsw_sp *mlxsw_sp);
 };
 
+struct mlxsw_sp_mdb_entry {
+	struct list_head list;
+	unsigned char addr[ETH_ALEN];
+	u16 fid;
+	u16 mid;
+	bool in_hw;
+	unsigned long *ports_in_mid; /* bits array */
+};
+
 static int
 mlxsw_sp_bridge_port_fdb_flush(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_bridge_port *bridge_port,
@@ -971,10 +980,10 @@ mlxsw_sp_bridge_mrouter_update_mdb(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_bridge_device *bridge_device,
 				   bool add)
 {
-	struct mlxsw_sp_mid *mid;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 
-	list_for_each_entry(mid, &bridge_device->mids_list, list)
-		mlxsw_sp_smid_router_port_set(mlxsw_sp, mid->mid, add);
+	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list)
+		mlxsw_sp_smid_router_port_set(mlxsw_sp, mdb_entry->mid, add);
 }
 
 static int
@@ -1696,16 +1705,16 @@ static int mlxsw_sp_port_smid_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
-static struct
-mlxsw_sp_mid *__mlxsw_sp_mc_get(struct mlxsw_sp_bridge_device *bridge_device,
-				const unsigned char *addr,
-				u16 fid)
+static struct mlxsw_sp_mdb_entry *
+__mlxsw_sp_mc_get(struct mlxsw_sp_bridge_device *bridge_device,
+		  const unsigned char *addr, u16 fid)
 {
-	struct mlxsw_sp_mid *mid;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 
-	list_for_each_entry(mid, &bridge_device->mids_list, list) {
-		if (ether_addr_equal(mid->addr, addr) && mid->fid == fid)
-			return mid;
+	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list) {
+		if (ether_addr_equal(mdb_entry->addr, addr) &&
+		    mdb_entry->fid == fid)
+			return mdb_entry;
 	}
 	return NULL;
 }
@@ -1753,7 +1762,7 @@ mlxsw_sp_mc_get_mrouters_bitmap(struct mlxsw_sp_ports_bitmap *flood_bm,
 
 static int
 mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_mid *mid,
+			    struct mlxsw_sp_mdb_entry *mdb_entry,
 			    struct mlxsw_sp_bridge_device *bridge_device)
 {
 	struct mlxsw_sp_ports_bitmap flood_bitmap;
@@ -1769,91 +1778,91 @@ mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	bitmap_copy(flood_bitmap.bitmap, mid->ports_in_mid, flood_bitmap.nbits);
+	bitmap_copy(flood_bitmap.bitmap, mdb_entry->ports_in_mid,
+		    flood_bitmap.nbits);
 	mlxsw_sp_mc_get_mrouters_bitmap(&flood_bitmap, bridge_device, mlxsw_sp);
 
-	mid->mid = mid_idx;
+	mdb_entry->mid = mid_idx;
 	err = mlxsw_sp_port_smid_full_entry(mlxsw_sp, mid_idx, &flood_bitmap,
 					    bridge_device->mrouter);
 	mlxsw_sp_port_bitmap_fini(&flood_bitmap);
 	if (err)
 		return err;
 
-	err = mlxsw_sp_port_mdb_op(mlxsw_sp, mid->addr, mid->fid, mid_idx,
-				   true);
+	err = mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->addr, mdb_entry->fid,
+				   mid_idx, true);
 	if (err)
 		return err;
 
 	set_bit(mid_idx, mlxsw_sp->bridge->mids_bitmap);
-	mid->in_hw = true;
+	mdb_entry->in_hw = true;
 	return 0;
 }
 
 static int mlxsw_sp_mc_remove_mdb_entry(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_mid *mid)
+					struct mlxsw_sp_mdb_entry *mdb_entry)
 {
-	if (!mid->in_hw)
+	if (!mdb_entry->in_hw)
 		return 0;
 
-	clear_bit(mid->mid, mlxsw_sp->bridge->mids_bitmap);
-	mid->in_hw = false;
-	return mlxsw_sp_port_mdb_op(mlxsw_sp, mid->addr, mid->fid, mid->mid,
-				    false);
+	clear_bit(mdb_entry->mid, mlxsw_sp->bridge->mids_bitmap);
+	mdb_entry->in_hw = false;
+	return mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->addr, mdb_entry->fid,
+				    mdb_entry->mid, false);
 }
 
-static struct
-mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
-				  struct mlxsw_sp_bridge_device *bridge_device,
-				  const unsigned char *addr,
-				  u16 fid)
+static struct mlxsw_sp_mdb_entry *
+__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
+		    struct mlxsw_sp_bridge_device *bridge_device,
+		    const unsigned char *addr, u16 fid)
 {
-	struct mlxsw_sp_mid *mid;
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 	int err;
 
-	mid = kzalloc(sizeof(*mid), GFP_KERNEL);
-	if (!mid)
+	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
+	if (!mdb_entry)
 		return NULL;
 
-	mid->ports_in_mid = bitmap_zalloc(mlxsw_core_max_ports(mlxsw_sp->core),
-					  GFP_KERNEL);
-	if (!mid->ports_in_mid)
+	mdb_entry->ports_in_mid = bitmap_zalloc(max_ports, GFP_KERNEL);
+	if (!mdb_entry->ports_in_mid)
 		goto err_ports_in_mid_alloc;
 
-	ether_addr_copy(mid->addr, addr);
-	mid->fid = fid;
-	mid->in_hw = false;
+	ether_addr_copy(mdb_entry->addr, addr);
+	mdb_entry->fid = fid;
+	mdb_entry->in_hw = false;
 
 	if (!bridge_device->multicast_enabled)
 		goto out;
 
-	err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid, bridge_device);
+	err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry, bridge_device);
 	if (err)
 		goto err_write_mdb_entry;
 
 out:
-	list_add_tail(&mid->list, &bridge_device->mids_list);
-	return mid;
+	list_add_tail(&mdb_entry->list, &bridge_device->mids_list);
+	return mdb_entry;
 
 err_write_mdb_entry:
-	bitmap_free(mid->ports_in_mid);
+	bitmap_free(mdb_entry->ports_in_mid);
 err_ports_in_mid_alloc:
-	kfree(mid);
+	kfree(mdb_entry);
 	return NULL;
 }
 
 static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
-					 struct mlxsw_sp_mid *mid)
+					 struct mlxsw_sp_mdb_entry *mdb_entry)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	int err = 0;
 
-	clear_bit(mlxsw_sp_port->local_port, mid->ports_in_mid);
-	if (bitmap_empty(mid->ports_in_mid,
+	clear_bit(mlxsw_sp_port->local_port, mdb_entry->ports_in_mid);
+	if (bitmap_empty(mdb_entry->ports_in_mid,
 			 mlxsw_core_max_ports(mlxsw_sp->core))) {
-		err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
-		list_del(&mid->list);
-		bitmap_free(mid->ports_in_mid);
-		kfree(mid);
+		err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
+		list_del(&mdb_entry->list);
+		bitmap_free(mdb_entry->ports_in_mid);
+		kfree(mdb_entry);
 	}
 	return err;
 }
@@ -1867,7 +1876,7 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct net_device *dev = mlxsw_sp_port->dev;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
-	struct mlxsw_sp_mid *mid;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 	u16 fid_index;
 	int err = 0;
 
@@ -1884,16 +1893,16 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	fid_index = mlxsw_sp_fid_index(mlxsw_sp_port_vlan->fid);
 
-	mid = __mlxsw_sp_mc_get(bridge_device, mdb->addr, fid_index);
-	if (!mid) {
-		mid = __mlxsw_sp_mc_alloc(mlxsw_sp, bridge_device, mdb->addr,
-					  fid_index);
-		if (!mid) {
+	mdb_entry = __mlxsw_sp_mc_get(bridge_device, mdb->addr, fid_index);
+	if (!mdb_entry) {
+		mdb_entry = __mlxsw_sp_mc_alloc(mlxsw_sp, bridge_device,
+						mdb->addr, fid_index);
+		if (!mdb_entry) {
 			netdev_err(dev, "Unable to allocate MC group\n");
 			return -ENOMEM;
 		}
 	}
-	set_bit(mlxsw_sp_port->local_port, mid->ports_in_mid);
+	set_bit(mlxsw_sp_port->local_port, mdb_entry->ports_in_mid);
 
 	if (!bridge_device->multicast_enabled)
 		return 0;
@@ -1901,7 +1910,7 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (bridge_port->mrouter)
 		return 0;
 
-	err = mlxsw_sp_port_smid_set(mlxsw_sp_port, mid->mid, true);
+	err = mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid, true);
 	if (err) {
 		netdev_err(dev, "Unable to set SMID\n");
 		goto err_out;
@@ -1910,7 +1919,7 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 
 err_out:
-	mlxsw_sp_port_remove_from_mid(mlxsw_sp_port, mid);
+	mlxsw_sp_port_remove_from_mid(mlxsw_sp_port, mdb_entry);
 	return err;
 }
 
@@ -1919,15 +1928,15 @@ mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_bridge_device *bridge_device,
 				   bool mc_enabled)
 {
-	struct mlxsw_sp_mid *mid;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 	int err;
 
-	list_for_each_entry(mid, &bridge_device->mids_list, list) {
+	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list) {
 		if (mc_enabled)
-			err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid,
+			err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry,
 							  bridge_device);
 		else
-			err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
+			err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
 
 		if (err)
 			goto err_mdb_entry_update;
@@ -1936,12 +1945,12 @@ mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_mdb_entry_update:
-	list_for_each_entry_continue_reverse(mid, &bridge_device->mids_list,
-					     list) {
+	list_for_each_entry_continue_reverse(mdb_entry,
+					     &bridge_device->mids_list, list) {
 		if (mc_enabled)
-			mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
+			mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
 		else
-			mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid,
+			mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry,
 						    bridge_device);
 	}
 	return err;
@@ -1953,13 +1962,15 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 				 bool add)
 {
 	struct mlxsw_sp_bridge_device *bridge_device;
-	struct mlxsw_sp_mid *mid;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 
 	bridge_device = bridge_port->bridge_device;
 
-	list_for_each_entry(mid, &bridge_device->mids_list, list) {
-		if (!test_bit(mlxsw_sp_port->local_port, mid->ports_in_mid))
-			mlxsw_sp_port_smid_set(mlxsw_sp_port, mid->mid, add);
+	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list) {
+		if (!test_bit(mlxsw_sp_port->local_port,
+			      mdb_entry->ports_in_mid))
+			mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
+					       add);
 	}
 }
 
@@ -2040,19 +2051,20 @@ static int mlxsw_sp_port_vlans_del(struct mlxsw_sp_port *mlxsw_sp_port,
 static int
 __mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 			struct mlxsw_sp_bridge_port *bridge_port,
-			struct mlxsw_sp_mid *mid)
+			struct mlxsw_sp_mdb_entry *mdb_entry)
 {
 	struct net_device *dev = mlxsw_sp_port->dev;
 	int err;
 
 	if (bridge_port->bridge_device->multicast_enabled &&
 	    !bridge_port->mrouter) {
-		err = mlxsw_sp_port_smid_set(mlxsw_sp_port, mid->mid, false);
+		err = mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
+					     false);
 		if (err)
 			netdev_err(dev, "Unable to remove port from SMID\n");
 	}
 
-	err = mlxsw_sp_port_remove_from_mid(mlxsw_sp_port, mid);
+	err = mlxsw_sp_port_remove_from_mid(mlxsw_sp_port, mdb_entry);
 	if (err)
 		netdev_err(dev, "Unable to remove MC SFD\n");
 
@@ -2068,7 +2080,7 @@ static int mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct net_device *dev = mlxsw_sp_port->dev;
 	struct mlxsw_sp_bridge_port *bridge_port;
-	struct mlxsw_sp_mid *mid;
+	struct mlxsw_sp_mdb_entry *mdb_entry;
 	u16 fid_index;
 
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp->bridge, orig_dev);
@@ -2084,13 +2096,13 @@ static int mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	fid_index = mlxsw_sp_fid_index(mlxsw_sp_port_vlan->fid);
 
-	mid = __mlxsw_sp_mc_get(bridge_device, mdb->addr, fid_index);
-	if (!mid) {
+	mdb_entry = __mlxsw_sp_mc_get(bridge_device, mdb->addr, fid_index);
+	if (!mdb_entry) {
 		netdev_err(dev, "Unable to remove port from MC DB\n");
 		return -EINVAL;
 	}
 
-	return __mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port, mid);
+	return __mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port, mdb_entry);
 }
 
 static void
@@ -2098,17 +2110,20 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_bridge_port *bridge_port)
 {
 	struct mlxsw_sp_bridge_device *bridge_device;
-	struct mlxsw_sp_mid *mid, *tmp;
+	struct mlxsw_sp_mdb_entry *mdb_entry, *tmp;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	bridge_device = bridge_port->bridge_device;
 
-	list_for_each_entry_safe(mid, tmp, &bridge_device->mids_list, list) {
-		if (test_bit(mlxsw_sp_port->local_port, mid->ports_in_mid)) {
+	list_for_each_entry_safe(mdb_entry, tmp, &bridge_device->mids_list,
+				 list) {
+		if (test_bit(local_port, mdb_entry->ports_in_mid)) {
 			__mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port,
-						mid);
+						mdb_entry);
 		} else if (bridge_device->multicast_enabled &&
 			   bridge_port->mrouter) {
-			mlxsw_sp_port_smid_set(mlxsw_sp_port, mid->mid, false);
+			mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
+					       false);
 		}
 	}
 }
-- 
2.36.1

