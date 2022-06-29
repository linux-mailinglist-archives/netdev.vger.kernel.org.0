Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB04255FC54
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiF2Jln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiF2Jlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:41:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379A83BA5A
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6NzqMTwkpNDtdnCvOxITZXkoEjcwSZ556vuHVYpyKr6/MyErtTjki9FHFlR4dBt5HH2HbIpcgGJ4e4azygJsZxmzCs4/N/g6Nniq4mD7fH40HsQ/l3VqI9jaX/48z/k5lNqGfDZhuSNAT3S9Mo+mdF7HBe0urJkpUSNjv+IaXNGRM3Y/E4KT6c4KTV9oVGcWbHS9WK8Ck1OL4TdVuHoBGN35ZcOvOKXrZpagHxCd7sBz4hGKmTcevd/TPcx5FDYbmC+3GrfQxKFlQSKLYnElx6ScChgGHNG6pgWj7oM6FxaS90ffIOadGFjo2WiQ1WgkucPgE+wmMA/ReVQwRJAYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QrxJdiDa9fh/pkKxRtVwImfnBisfnwt5FFY/6VU50Y=;
 b=JdGo+LCvDDuDLlKhjUhmRk7gAbqq0kHyRp+yYiiJaxY5jERDPADJKR9EBQNS92leex2rs3CGp3FXzt/y1/ruHwiGP72bQRg5MWcc32/b4Rrg5j8xpZ5zIXT67pcHbOHyTQvN3CMXZ2MDMMd6EGNNZX3NA94Ud6qYNcR9pY+VOhNHva4EsvC57DzWMwoF4+A0Uo8QnexJmtt4lBegbuqFC2jUdG68Q89FB/6WI1BHZSMvj+2KD7bR7/8vVa4KMPkFF49IfsqtOpwW/e6F6fNjrYFqyKcFNpXUOB88sRLtbJ1yVCRuefh0xsWpPp0GW/HcZhbAksbjBFSQdAriUhrchQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QrxJdiDa9fh/pkKxRtVwImfnBisfnwt5FFY/6VU50Y=;
 b=kCIifcfgK2EVUspAOSh6lfkj3RHnVuRmrmDtt2LPMvZotU6NT4jl6xxNY8aO/vq1P1IvtukEqVZmLQ7e/N5TBxFKwFdBF31lCF3LwbmayOO0l1/cS6WQiZ4hyXF0iIix2sVhJqQX6cWEYBQqAqJhf+aQ18C5xlPi/Dh1sH2plbTxAESg69+vGmL983VI/e+J2QPw3UhliBdgKDX7ygieaMXxLItt90eIPrZYa/DXy2Q1+wK7XjoR/uta1gYqU3XrnncSJyoWynmJgPV/wkJKxkGQ80PYQ7Anv9OoSXYgdTUk4Tl/eWZcqE+OROuKoSx4cDNY+QiXoP3BtuO1OOGNVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:41:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:41:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] mlxsw: spectrum_switchdev: Convert MDB code to use PGT APIs
Date:   Wed, 29 Jun 2022 12:40:07 +0300
Message-Id: <20220629094007.827621-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0048.eurprd09.prod.outlook.com
 (2603:10a6:802:28::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08933a22-cde1-4c5b-9c98-08da59b38fb9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZgxtH7L+HQvkg3Bha3MVX2ay2rNK7etNGjWGNcqwGbxqD6MaqjttnAIKFq98vOTHF+7B7T6VqV0rYBJAKQC82idMcmd3J5KgHyebYT+/G5A3q3geFxKcOgJ9mftL8lyOqZOsbOy6JJ1Bt6ZjKRuKLzo3GisRCDaPcCGNaC+rXZ5+b1oYlt/D+6AAkHOf4RrYIAOIJMHTyqF7cJLaj5/281idUmqEBT1ele2p/7uUjGL7pVjZlYEEAPKrX4JU5w7Kovy3hdiDwXsCm7iMgVoroAilBWItFvIJHsnZ0XZuqtJXQoXcDgjCW3+jihB2Db9FntIVU185PiXOz9hjAc7WR5QpAEDet3an4LMzpJ6ikbIEJhX3NJiqGuAtQdWXUFidT8O+bTY6BKAUSAyrLG1Wxzd3XZ3tZK5/YHEJ38qfjOS/DfyvRAXoVF/st3ZHojGvrwu/Zr810pc0itSpgw6xUo5KHUDNdmawqsFTwtjTXWPDmiaHr3jP4PXWnkleoCmHIs1sdwgRO+6bMGFmX9QT2qjKX0PWJ7F28rXeKa7xBTrqMEKgHhg3Pl9/PDGxkFlwcPkGpdXyLw74pmSQjBYJZflxNo0uddOENA/5eAfzQ99AiyjrhDR9BCN/khmT4Yn9WM7uFHWRqrKoUqaO3ty19Ul7p8jJ8B8AvpfxXJ+epnK1Y+mFil/cH13qF8HShm9n3YcqHSCuMWmQo2S3EK001TItzQ8Vo/TdedLfPcLPSFnbtdKI3uMLlGXMXaQrCSL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(66574015)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(30864003)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJ3ye0SmzQZZ6oX4Vkv/DSAV6sc2Djmi69af2rjVj9UTc5jOKSKNQREkDFuM?=
 =?us-ascii?Q?mCTce9LfNi/Tf+Fo4aUj6XtZ4yQRsS9oPOjb7pA1Zz66I32N8hSvhOIJs1BH?=
 =?us-ascii?Q?mRiKLvjJk/C8fDLfmt1BqPudCI2rxDuB/lte2t+FVNmO8kKbMkUBKoXlVqNb?=
 =?us-ascii?Q?ztTBgtCu01hv1wJE/tBeU1iZa6sgiJQFZztrMBwB1/uFSnwUYrnaENiXskqY?=
 =?us-ascii?Q?NBAsrmeKq11J+YcOLzwN54583MkSzmRpQsyi50EbyqEoGyJA1MFPh9doinhV?=
 =?us-ascii?Q?eudVEisoN75rszVG9+Lyq6KnkLJ3Q3BdSKWk+yp0WJ06pFkl3sQSebMK7Hdb?=
 =?us-ascii?Q?0MWUmoLneT+vEz15RrWnP8rJnXJWN/PCCKxEoVpnF1dmhD4FcSbXfY9FvKkk?=
 =?us-ascii?Q?wVnBoyaMkvjGGdRXFkd3Sktx5cNnb88bnLweAC9qcxTAVnlpbvt8Vwqcuk+t?=
 =?us-ascii?Q?3awGH0ckL6pc+aRcxKD5xS/qKGlAJTOClwXdTn6gYCrlS0RGQ5A32aklHxEj?=
 =?us-ascii?Q?pdzo6e04hKS5DdOcVFrFayJghLDEu+CMxvIe8GzUqLW4DX43JbkPvIFMGz9e?=
 =?us-ascii?Q?fsVctvSE/pLTqWjeqdANVPsWLJ9o8mHgU1lh83rKpsxzl9LFF9Yyzaik9IYj?=
 =?us-ascii?Q?D6qVSH0xkn5kMCPK2/R2NSXdXaWH04AR6Cic2Hbw9TSaJZPB8Bw8mTsOiffL?=
 =?us-ascii?Q?8JQOOaPFTR9dmkAgHslhP0HPAze3aA4P8w4qW7RMwdm0EKsFJqfu5ugsJa7k?=
 =?us-ascii?Q?BQbJLdBjXKQP9e5dNtARGt6uju+mEf5rzZ0TpSZ27P/3GvO2fd12641i4Ewz?=
 =?us-ascii?Q?+63C225vN9HbwKyfutwXqFDQGd3QdRdaH9MwwhHGRuVXftqI0eQN9wYNMzTp?=
 =?us-ascii?Q?hSfkVEXg6xSegwme38UtAofuRJzL7C2a28AvEluApLypXygCKbsTD1dQetLV?=
 =?us-ascii?Q?niJY5tXYxf/jJLl7vzWlUKAnisklJUPsJy+X3hCrXD2C0Cnm1hDt8mLxcKL8?=
 =?us-ascii?Q?D49xwUycWlrIObleyCic17f7090zimY9Qw6rOebQf3mHPIrPpboX+iRXHHx1?=
 =?us-ascii?Q?EFSPKSP7RSpu2qPR0wPdYo14/lPr0h4nF+mcQXFZn5+xA47nPCm60QGMtEcP?=
 =?us-ascii?Q?496A3aoVu1XA//xkXT/jFu51ZDN6wmLy+OOxnJeQLcZ994Uup1A5enmMoBh7?=
 =?us-ascii?Q?16khvcanfNp8Y+O8SpJBS8Cb6ztWshpmrtAUfRJwIphJ942IQe+Xet++Dsw/?=
 =?us-ascii?Q?Lb9Axxw8tH0V8cM/rvPxZh3t6nrKI51yHSeAkiYDGFJ4zqlBwkMroPfNdLwx?=
 =?us-ascii?Q?eKsYJ1tjqcw61IT3dT3LMlgvT6A9LNfILxdn0tHrD5q0lsyWizEhOnSu7Naz?=
 =?us-ascii?Q?8UUhoelpj7npMkDkyR5Oh3z2+txLOKDzfUwlM6yYa+2sS95p7ujy7qxok3qy?=
 =?us-ascii?Q?CK39mLYAEbWQjof5WDKktayPHrzodO71BNWpmUEN4p478GCpXv7zxPzy2rzy?=
 =?us-ascii?Q?RfLpkjkOozpCVJ3IU3XoSlLVgnF3dK9d3M0m4v1WJSZwY/gUdTnB7ahv2H5d?=
 =?us-ascii?Q?yQ7zqMKE6yeJBwvnfl9Xj6jrELzv5WZQMPtQSA4i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08933a22-cde1-4c5b-9c98-08da59b38fb9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:41:37.3857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qW1YLBwhzfxAeNfOIt0UHqe0Wpvcg8J4j3PjPGCDbRWdPjuP7Uot7v8vYFOHdcrg8VJFQj9ngSG1fgsA14AjPA==
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

The previous patches added common APIs for maintaining PGT (Port Group
Table) table. In the legacy model, software did not interact with this
table directly. Instead, it was accessed by firmware in response to
registers such as SFTR and SMID. In the new model, software has full
control over the PGT table using the SMID register.

The configuration of MDB entries is already done via SMID, so the new
PGT APIs can be used also using the legacy model, the only difference is
that MID index should be aligned to bridge model. See a previous patch
which added API for that.

The main changes are:
- MDB code does not maintain bitmap of ports in MDB entry anymore, instead,
  it stores a list of ports with additional information.
- MDB code does not configure SMID register directly anymore, it will be
  done via PGT API when port is first added or removed.
- Today MDB code does not update SMID when port is added/removed while
  multicast is disabled. Instead, it maintains bitmap of ports and once
  multicast is enabled, it rewrite the entry to hardware. Using PGT APIs,
  the entry will be updated also when multicast is disabled, but the
  mapping between {MAC, FID}->{MID} will not appear in SFD register. It
  means that SMID will be updated all the time and disable/enable multicast
  will impact only SFD configuration.
- For multicast router, today only SMID is updated and the bitmap is not
  updated. Using the new list of ports, there is a reference count for each
  port, so it can be saved in software also. For such port,
  'struct mlxsw_sp_mdb_entry.ports_count' will not be updated and the
  port in the list will be marked as 'mrouter'.
- Finally, `struct mlxsw_sp_mid.in_hw` is not needed anymore.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 352 +++---------------
 1 file changed, 48 insertions(+), 304 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 0cf442e0dce0..7cabe6e8edeb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -115,8 +115,6 @@ struct mlxsw_sp_mdb_entry {
 	u16 mid;
 	struct list_head ports_list;
 	u16 ports_count;
-	bool in_hw;
-	unsigned long *ports_in_mid; /* bits array */
 };
 
 struct mlxsw_sp_mdb_entry_port {
@@ -910,6 +908,9 @@ static int mlxsw_sp_port_attr_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_port)
 		return 0;
 
+	mlxsw_sp_port_mrouter_update_mdb(mlxsw_sp_port, bridge_port,
+					 is_port_mrouter);
+
 	if (!bridge_port->bridge_device->multicast_enabled)
 		goto out;
 
@@ -919,8 +920,6 @@ static int mlxsw_sp_port_attr_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		return err;
 
-	mlxsw_sp_port_mrouter_update_mdb(mlxsw_sp_port, bridge_port,
-					 is_port_mrouter);
 out:
 	bridge_port->mrouter = is_port_mrouter;
 	return 0;
@@ -988,23 +987,6 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
-static int mlxsw_sp_smid_router_port_set(struct mlxsw_sp *mlxsw_sp,
-					 u16 mid_idx, bool add)
-{
-	char *smid2_pl;
-	int err;
-
-	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
-	if (!smid2_pl)
-		return -ENOMEM;
-
-	mlxsw_reg_smid2_pack(smid2_pl, mid_idx,
-			     mlxsw_sp_router_port(mlxsw_sp), add, false, 0);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
-	kfree(smid2_pl);
-	return err;
-}
-
 static struct mlxsw_sp_mdb_entry_port *
 mlxsw_sp_mdb_entry_port_lookup(struct mlxsw_sp_mdb_entry *mdb_entry,
 			       u16 local_port)
@@ -1154,10 +1136,17 @@ mlxsw_sp_bridge_mrouter_update_mdb(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_bridge_device *bridge_device,
 				   bool add)
 {
+	u16 local_port = mlxsw_sp_router_port(mlxsw_sp);
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 
-	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list)
-		mlxsw_sp_smid_router_port_set(mlxsw_sp, mdb_entry->mid, add);
+	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
+		if (add)
+			mlxsw_sp_mdb_entry_mrouter_port_get(mlxsw_sp, mdb_entry,
+							    local_port);
+		else
+			mlxsw_sp_mdb_entry_mrouter_port_put(mlxsw_sp, mdb_entry,
+							    local_port);
+	}
 }
 
 static int
@@ -1833,97 +1822,6 @@ static int mlxsw_sp_mdb_entry_write(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int mlxsw_sp_port_mdb_op(struct mlxsw_sp *mlxsw_sp, const char *addr,
-				u16 fid, u16 mid_idx, bool adding)
-{
-	char *sfd_pl;
-	u8 num_rec;
-	int err;
-
-	sfd_pl = kmalloc(MLXSW_REG_SFD_LEN, GFP_KERNEL);
-	if (!sfd_pl)
-		return -ENOMEM;
-
-	mlxsw_reg_sfd_pack(sfd_pl, mlxsw_sp_sfd_op(adding), 0);
-	mlxsw_reg_sfd_mc_pack(sfd_pl, 0, addr, fid,
-			      MLXSW_REG_SFD_REC_ACTION_NOP, mid_idx);
-	num_rec = mlxsw_reg_sfd_num_rec_get(sfd_pl);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfd), sfd_pl);
-	if (err)
-		goto out;
-
-	if (num_rec != mlxsw_reg_sfd_num_rec_get(sfd_pl))
-		err = -EBUSY;
-
-out:
-	kfree(sfd_pl);
-	return err;
-}
-
-static int
-mlxsw_sp_port_smid_full_entry(struct mlxsw_sp *mlxsw_sp, u16 mid_idx,
-			      const struct mlxsw_sp_ports_bitmap *ports_bm,
-			      bool set_router_port)
-{
-	char *smid2_pl;
-	int err, i;
-
-	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
-	if (!smid2_pl)
-		return -ENOMEM;
-
-	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, 0, false, false, 0);
-	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
-		if (mlxsw_sp->ports[i])
-			mlxsw_reg_smid2_port_mask_set(smid2_pl, i, 1);
-	}
-
-	mlxsw_reg_smid2_port_mask_set(smid2_pl,
-				      mlxsw_sp_router_port(mlxsw_sp), 1);
-
-	for_each_set_bit(i, ports_bm->bitmap, ports_bm->nbits)
-		mlxsw_reg_smid2_port_set(smid2_pl, i, 1);
-
-	mlxsw_reg_smid2_port_set(smid2_pl, mlxsw_sp_router_port(mlxsw_sp),
-				 set_router_port);
-
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
-	kfree(smid2_pl);
-	return err;
-}
-
-static int mlxsw_sp_port_smid_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				  u16 mid_idx, bool add)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char *smid2_pl;
-	int err;
-
-	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
-	if (!smid2_pl)
-		return -ENOMEM;
-
-	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, mlxsw_sp_port->local_port, add,
-			     false, 0);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
-	kfree(smid2_pl);
-	return err;
-}
-
-static struct mlxsw_sp_mdb_entry *
-__mlxsw_sp_mc_get(struct mlxsw_sp_bridge_device *bridge_device,
-		  const unsigned char *addr, u16 fid)
-{
-	struct mlxsw_sp_mdb_entry *mdb_entry;
-
-	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
-		if (ether_addr_equal(mdb_entry->key.addr, addr) &&
-		    mdb_entry->key.fid == fid)
-			return mdb_entry;
-	}
-	return NULL;
-}
-
 static void
 mlxsw_sp_bridge_port_get_ports_bitmap(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_bridge_port *bridge_port,
@@ -1965,113 +1863,6 @@ mlxsw_sp_mc_get_mrouters_bitmap(struct mlxsw_sp_ports_bitmap *flood_bm,
 	}
 }
 
-static int
-mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_mdb_entry *mdb_entry,
-			    struct mlxsw_sp_bridge_device *bridge_device)
-{
-	struct mlxsw_sp_ports_bitmap flood_bitmap;
-	u16 mid_idx;
-	int err;
-
-	mid_idx = find_first_zero_bit(mlxsw_sp->bridge->mids_bitmap,
-				      MLXSW_SP_MID_MAX);
-	if (mid_idx == MLXSW_SP_MID_MAX)
-		return -ENOBUFS;
-
-	err = mlxsw_sp_port_bitmap_init(mlxsw_sp, &flood_bitmap);
-	if (err)
-		return err;
-
-	bitmap_copy(flood_bitmap.bitmap, mdb_entry->ports_in_mid,
-		    flood_bitmap.nbits);
-	mlxsw_sp_mc_get_mrouters_bitmap(&flood_bitmap, bridge_device, mlxsw_sp);
-
-	mdb_entry->mid = mid_idx;
-	err = mlxsw_sp_port_smid_full_entry(mlxsw_sp, mid_idx, &flood_bitmap,
-					    bridge_device->mrouter);
-	mlxsw_sp_port_bitmap_fini(&flood_bitmap);
-	if (err)
-		return err;
-
-	err = mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->key.addr,
-				   mdb_entry->key.fid, mid_idx, true);
-	if (err)
-		return err;
-
-	set_bit(mid_idx, mlxsw_sp->bridge->mids_bitmap);
-	mdb_entry->in_hw = true;
-	return 0;
-}
-
-static int mlxsw_sp_mc_remove_mdb_entry(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_mdb_entry *mdb_entry)
-{
-	if (!mdb_entry->in_hw)
-		return 0;
-
-	clear_bit(mdb_entry->mid, mlxsw_sp->bridge->mids_bitmap);
-	mdb_entry->in_hw = false;
-	return mlxsw_sp_port_mdb_op(mlxsw_sp, mdb_entry->key.addr,
-				    mdb_entry->key.fid, mdb_entry->mid, false);
-}
-
-static struct mlxsw_sp_mdb_entry *
-__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
-		    struct mlxsw_sp_bridge_device *bridge_device,
-		    const unsigned char *addr, u16 fid)
-{
-	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
-	struct mlxsw_sp_mdb_entry *mdb_entry;
-	int err;
-
-	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
-	if (!mdb_entry)
-		return NULL;
-
-	mdb_entry->ports_in_mid = bitmap_zalloc(max_ports, GFP_KERNEL);
-	if (!mdb_entry->ports_in_mid)
-		goto err_ports_in_mid_alloc;
-
-	ether_addr_copy(mdb_entry->key.addr, addr);
-	mdb_entry->key.fid = fid;
-	mdb_entry->in_hw = false;
-
-	if (!bridge_device->multicast_enabled)
-		goto out;
-
-	err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry, bridge_device);
-	if (err)
-		goto err_write_mdb_entry;
-
-out:
-	list_add_tail(&mdb_entry->list, &bridge_device->mdb_list);
-	return mdb_entry;
-
-err_write_mdb_entry:
-	bitmap_free(mdb_entry->ports_in_mid);
-err_ports_in_mid_alloc:
-	kfree(mdb_entry);
-	return NULL;
-}
-
-static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
-					 struct mlxsw_sp_mdb_entry *mdb_entry)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	int err = 0;
-
-	clear_bit(mlxsw_sp_port->local_port, mdb_entry->ports_in_mid);
-	if (bitmap_empty(mdb_entry->ports_in_mid,
-			 mlxsw_core_max_ports(mlxsw_sp->core))) {
-		err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
-		list_del(&mdb_entry->list);
-		bitmap_free(mdb_entry->ports_in_mid);
-		kfree(mdb_entry);
-	}
-	return err;
-}
-
 static int mlxsw_sp_mc_mdb_mrouters_add(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_ports_bitmap *ports_bm,
 					struct mlxsw_sp_mdb_entry *mdb_entry)
@@ -2213,7 +2004,7 @@ mlxsw_sp_mc_mdb_entry_fini(struct mlxsw_sp *mlxsw_sp,
 	kfree(mdb_entry);
 }
 
-static __always_unused struct mlxsw_sp_mdb_entry *
+static struct mlxsw_sp_mdb_entry *
 mlxsw_sp_mc_mdb_entry_get(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_bridge_device *bridge_device,
 			  const unsigned char *addr, u16 fid, u16 local_port)
@@ -2263,7 +2054,7 @@ mlxsw_sp_mc_mdb_entry_remove(struct mlxsw_sp_mdb_entry *mdb_entry,
 	return true;
 }
 
-static __always_unused void
+static void
 mlxsw_sp_mc_mdb_entry_put(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_bridge_device *bridge_device,
 			  struct mlxsw_sp_mdb_entry *mdb_entry, u16 local_port,
@@ -2295,12 +2086,10 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct net_device *orig_dev = mdb->obj.orig_dev;
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
-	struct net_device *dev = mlxsw_sp_port->dev;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 	u16 fid_index;
-	int err = 0;
 
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp->bridge, orig_dev);
 	if (!bridge_port)
@@ -2315,34 +2104,13 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	fid_index = mlxsw_sp_fid_index(mlxsw_sp_port_vlan->fid);
 
-	mdb_entry = __mlxsw_sp_mc_get(bridge_device, mdb->addr, fid_index);
-	if (!mdb_entry) {
-		mdb_entry = __mlxsw_sp_mc_alloc(mlxsw_sp, bridge_device,
-						mdb->addr, fid_index);
-		if (!mdb_entry) {
-			netdev_err(dev, "Unable to allocate MC group\n");
-			return -ENOMEM;
-		}
-	}
-	set_bit(mlxsw_sp_port->local_port, mdb_entry->ports_in_mid);
-
-	if (!bridge_device->multicast_enabled)
-		return 0;
-
-	if (bridge_port->mrouter)
-		return 0;
-
-	err = mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid, true);
-	if (err) {
-		netdev_err(dev, "Unable to set SMID\n");
-		goto err_out;
-	}
+	mdb_entry = mlxsw_sp_mc_mdb_entry_get(mlxsw_sp, bridge_device,
+					      mdb->addr, fid_index,
+					      mlxsw_sp_port->local_port);
+	if (IS_ERR(mdb_entry))
+		return PTR_ERR(mdb_entry);
 
 	return 0;
-
-err_out:
-	mlxsw_sp_port_remove_from_mid(mlxsw_sp_port, mdb_entry);
-	return err;
 }
 
 static int
@@ -2354,27 +2122,16 @@ mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
-		if (mc_enabled)
-			err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry,
-							  bridge_device);
-		else
-			err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
-
+		err = mlxsw_sp_mdb_entry_write(mlxsw_sp, mdb_entry, mc_enabled);
 		if (err)
-			goto err_mdb_entry_update;
+			goto err_mdb_entry_write;
 	}
-
 	return 0;
 
-err_mdb_entry_update:
+err_mdb_entry_write:
 	list_for_each_entry_continue_reverse(mdb_entry,
-					     &bridge_device->mdb_list, list) {
-		if (mc_enabled)
-			mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
-		else
-			mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry,
-						    bridge_device);
-	}
+					     &bridge_device->mdb_list, list)
+		mlxsw_sp_mdb_entry_write(mlxsw_sp, mdb_entry, !mc_enabled);
 	return err;
 }
 
@@ -2383,16 +2140,20 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_bridge_port *bridge_port,
 				 bool add)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_bridge_device *bridge_device;
+	u16 local_port = mlxsw_sp_port->local_port;
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 
 	bridge_device = bridge_port->bridge_device;
 
 	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
-		if (!test_bit(mlxsw_sp_port->local_port,
-			      mdb_entry->ports_in_mid))
-			mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
-					       add);
+		if (add)
+			mlxsw_sp_mdb_entry_mrouter_port_get(mlxsw_sp, mdb_entry,
+							    local_port);
+		else
+			mlxsw_sp_mdb_entry_mrouter_port_put(mlxsw_sp, mdb_entry,
+							    local_port);
 	}
 }
 
@@ -2470,29 +2231,6 @@ static int mlxsw_sp_port_vlans_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
-static int
-__mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
-			struct mlxsw_sp_bridge_port *bridge_port,
-			struct mlxsw_sp_mdb_entry *mdb_entry)
-{
-	struct net_device *dev = mlxsw_sp_port->dev;
-	int err;
-
-	if (bridge_port->bridge_device->multicast_enabled &&
-	    !bridge_port->mrouter) {
-		err = mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
-					     false);
-		if (err)
-			netdev_err(dev, "Unable to remove port from SMID\n");
-	}
-
-	err = mlxsw_sp_port_remove_from_mid(mlxsw_sp_port, mdb_entry);
-	if (err)
-		netdev_err(dev, "Unable to remove MC SFD\n");
-
-	return err;
-}
-
 static int mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
@@ -2502,6 +2240,7 @@ static int mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct net_device *dev = mlxsw_sp_port->dev;
 	struct mlxsw_sp_bridge_port *bridge_port;
+	struct mlxsw_sp_mdb_entry_key key = {};
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 	u16 fid_index;
 
@@ -2518,13 +2257,18 @@ static int mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	fid_index = mlxsw_sp_fid_index(mlxsw_sp_port_vlan->fid);
 
-	mdb_entry = __mlxsw_sp_mc_get(bridge_device, mdb->addr, fid_index);
+	ether_addr_copy(key.addr, mdb->addr);
+	key.fid = fid_index;
+	mdb_entry = rhashtable_lookup_fast(&bridge_device->mdb_ht, &key,
+					   mlxsw_sp_mdb_ht_params);
 	if (!mdb_entry) {
 		netdev_err(dev, "Unable to remove port from MC DB\n");
 		return -EINVAL;
 	}
 
-	return __mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port, mdb_entry);
+	mlxsw_sp_mc_mdb_entry_put(mlxsw_sp, bridge_device, mdb_entry,
+				  mlxsw_sp_port->local_port, false);
+	return 0;
 }
 
 static void
@@ -2532,6 +2276,7 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_bridge_port *bridge_port,
 			       u16 fid_index)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_mdb_entry *mdb_entry, *tmp;
 	u16 local_port = mlxsw_sp_port->local_port;
@@ -2543,14 +2288,13 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 		if (mdb_entry->key.fid != fid_index)
 			continue;
 
-		if (test_bit(local_port, mdb_entry->ports_in_mid)) {
-			__mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port,
-						mdb_entry);
-		} else if (bridge_device->multicast_enabled &&
-			   bridge_port->mrouter) {
-			mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
-					       false);
-		}
+		if (bridge_port->mrouter)
+			mlxsw_sp_mdb_entry_mrouter_port_put(mlxsw_sp,
+							    mdb_entry,
+							    local_port);
+
+		mlxsw_sp_mc_mdb_entry_put(mlxsw_sp, bridge_device, mdb_entry,
+					  local_port, true);
 	}
 }
 
-- 
2.36.1

