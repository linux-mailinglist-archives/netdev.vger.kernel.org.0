Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E236E5573C6
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiFWHTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiFWHTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7112B45AFB
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWIai2yiT4hd3iN2FiTe6UXQa7s7mWvq9uOlOfSW/mMOD/2Ua53Q1g1cWv4wl65+R1szvB0aZIZER8X642ClJN6zWlhP3ZbCKb3gdmsKFyMxFPIOQM+Cv1mMRKTG7r3oHepTesM3aKDtuyfXyF6MQI55QURuQupPjHK2X0aeg6p7B+Wwx/Z57vtRd6AuFF4eTbxUPytHDbr2kAJvRqIxxhU9fL/wtZ4j7kGlvKqPBHf+WK2oIGa701+cYyVGjh7cArf/y9J1L+oMSjwgbB3uw04Mcw0ToVKsCedSuAYX7fbd5ASICsAgj38+BE2OJwIo8LaFWTTrvA03Se4uQpB5Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+lo3ddwuz2SBOeSNC+uhuXxA4I22wLK3CgphV/NCRo=;
 b=EDXQXI6VEA4r2MRNmG9+sEu88X0R+rOnpBMwhSAXcKkf4qYGYlLMmkJejIYC6uwfePrJOREqpnAxQ2h1APmJbOhux534FcPPhBoJlxkanPlJj9O0J3OVPsWDS7Djl01oNtLlhL0pYUiOXQs/UINoxR/h1A+x8hNJ58ok6tGnJrvPRKobHtiIGusKt4VdVpYczCLLLnhAH4YVxBXCTvV2I6mhyPfYx8k0kMwufEt3TMPl5hg2now8t0j7jp4tuX+YuAmfWfyMy7RuA/8z54eS3HfNevASc8/vZDUWAS4oPNjl73LzjHB+ChyQ6e3/fPx5s/LvWXp47bJrYi5fmZBXDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+lo3ddwuz2SBOeSNC+uhuXxA4I22wLK3CgphV/NCRo=;
 b=M5W3RsTF/l9IdVtVjLnwUf3CPeQiuvnE9msIaafZJExjKcda5YITvVyXmqazZWxoqzvMaHUWIXleLc+D31E2BqfYxVMqaSlM7+EJ+t0zVcLjcFjEcrCuz5bXqk9p0WmcmIl00wWTgOQB4/F+a+3ndAi+nba2GhUycCf6NmEHWbL1HXRzL/pfPRV8gRontFqCCVuVvCLC/j37NmG57Rb/VOtR0JIi4KE0iWLSQ8iGsHuue6NP/GR+vh82jvtGn8DVQ8pzDgFLzCdNTpum0QbMkC4fJERiCOVBoXElR7K+oLuznQTCHpCmV/DUlrKyhI3Uhgu1Y5qUToAwI63FF4xmCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:19:33 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum_fid: Rename mlxsw_sp_fid_vni_op()
Date:   Thu, 23 Jun 2022 10:17:32 +0300
Message-Id: <20220623071737.318238-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 410be806-b8ce-41e3-c8fd-08da54e8b8c0
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB25185BA418C4F136FF01E93AB2B59@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NqC8wn1OBrBUc2NC8UMB4nXvfXCHxnw+NHbGYvsLY/5p5o0Js8dRzT7sldV5iEVDOpxScIYaK5E3s4EHTZVPXA7qcKGM+2e3rFmgcP0ol6FnYsGfOPADPf25eM/LfAvXtMKVAzNe1FCkqbLoyTLzjyk95qS3mOiOzwrM9amub02qLkzF+pu/tMnRJPykSi/1qIIG1vUkZB2ITvx5gofeyeol8q8J914+n0OoRpLDN9V+O5Q/UPCObhYdZNuf7R6zf6ltHPAmMxQJ+4jDnHTJWz0HzCjj0QndxgB7XSr8dsuvWZbgbylRO8RNu+n81cJ6emBYFkgAZ8RODHJNd5F6+NuN4NDLwX1KKSkCWwB8uHSmZymMlbg1sRmZHhC4hDSow8vKR+iUZgPtXMKy3QF3jwPcwCzl2k4cviRFOLEQZNRonO7DAMcnNcI3yhQxsFStuNvfKmdARrFFWt7G9oQ7q/yEfJDp5B/W/+iHHxlKA+sk+mprHKRrMRV1J0VG4HQY/Uj277Q2UyzQsz37+BR9QYEoQxaKYABK02mkj3JlHUEL8OjeER0elWqh6k4zaUPIvPFlDeO3MzbiRWQV6BptvIK1YTk1I7d/tIqohRrmxTwLfESn0boV9o92zVVhPf5dq1cbYLZTbnttvjNhoaLkLew4wX+JoS7dCW+qzVrhOVfyIsXUS6Qb8KVob9WXRsmH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(4326008)(8936002)(66476007)(8676002)(86362001)(1076003)(6506007)(66556008)(6512007)(66946007)(107886003)(186003)(6916009)(83380400001)(2616005)(5660300002)(36756003)(41300700001)(38100700002)(26005)(316002)(6486002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kaSUkGGxydeYA2Nbc+ShhXnIDJTC/r6p7gvm5z0n2DhGZ+5KAOF1eeh6LoVL?=
 =?us-ascii?Q?tpsqak3nKKCJHbmGDazqeNmTs+4IDdmI4uclq2Qbh4nu86jVZIZYeFf7yneA?=
 =?us-ascii?Q?2CB23creHuhQLO2iaBzPu4D62Iw5w3KXaSnRGsSIdLxBPb18KB1nCQdKgNBU?=
 =?us-ascii?Q?fjyqtbegbN3qTYbl+c+QuOiolhC7X3ngJKFtQFkCJkcWNtL4lzvgpKdPnlNj?=
 =?us-ascii?Q?rerxkiQZDZXAHbZ60KIJ2IiL5UcsO53h43pR+nrxOhFkR0aGKzaS2GUxjo+4?=
 =?us-ascii?Q?Cw7XgfQagZDJqpRtUcZl1chMVJ7mj0gWMSVx1JlUkrogO04Li+2678wpPg40?=
 =?us-ascii?Q?e1k2QDZUoOcz4HuYb2k6RQVTkyCYmtkBMkMtelSlhAVaCIsd3pvGhqjA3UG8?=
 =?us-ascii?Q?vM3bAK2HajFk2lnAGdqrO7aiLGT39pPeYO7uYrWYHx/F9wjPN14fIF2IGREA?=
 =?us-ascii?Q?lWndgXJ3H2i1iYbvG9px3WT5dFUFoY37+tG067mWYEdnZImpLRNrSAofepxt?=
 =?us-ascii?Q?tAbUVuQcUYD4STPJyU5ypMApwxrsU6HMBM44qjZ0gOozxlDASFodtUzt1tt2?=
 =?us-ascii?Q?nU79JGYMNB5JVo4r8UhnXVOkBvb8P23QtE8YcfC5VOBRByQH7E08aPYenfMe?=
 =?us-ascii?Q?DQ6RY+yLQhLkpcSWrYCRZ8fIO1ks9p71i0CuMa0fy6u1GOvAZkOqpUxNqpGL?=
 =?us-ascii?Q?BP/khXEauHhVLOLYgInpcfCCI5bRTvvFkbBOuwjyf3kMaXEWEYBEBGTzGhjF?=
 =?us-ascii?Q?Xwa/UeZ2/gJMWnIGlVIWXSgQ7S1xizD3QZ/h4MMYrwFRdBy+1mOTapeYxajz?=
 =?us-ascii?Q?C5xrAjOd8/lzyO/9OjeWg3DeINjbB/xPtI8PSxZ4CELdjlXZ6DsR/g52/Kw6?=
 =?us-ascii?Q?uxNSxDcu0Hq679HFv5T82sJTHI6i/a1kVZrvxKaincOKxsVIQnAXEF2AWMPl?=
 =?us-ascii?Q?fVPP8GPBuzBXl1OtF8FpyDQ55xR/kix9UUlJrSf5SkLqTqkDCCh8T04XP7Iv?=
 =?us-ascii?Q?JkMV1eNaqpyI5r/aAlRaTKtlxb6EYsegiqjbztvfxsrHxvYgb6Ho36BmK2PL?=
 =?us-ascii?Q?HNxcaPNkeBTiiwZ7aT33XVdod2UbqKb+ujb3Yywl7zDJwYoEQWWBY3a8Hpf1?=
 =?us-ascii?Q?Ot73n31qksVCjpInfj8YJX1uogJ0zneQT5uZzYflPyHR3KMzsLrydFIw8J1U?=
 =?us-ascii?Q?/0y9yTevBhXxjZikGTzvynP9qb/tLJAcq3DhY2tzAv9qYU3hJw//uZodmqmT?=
 =?us-ascii?Q?L31mAIol5AvW6qXorB+Q58z1SDem06hFKbPRgAw9MV2KL/RNEYGEsnW7nJFo?=
 =?us-ascii?Q?t7H9NBA4u8mQoZ1e0Szk+DPepOzHRGQmR5GLW3idaiYCz1AW6GeFt5MgpuBf?=
 =?us-ascii?Q?hqtEcx0oX044SNU8QM32tNbeLOcwgcAqsvGTkw81fMGg9xyZnjbeJN32DbRJ?=
 =?us-ascii?Q?iCNCAxCYqVM2siWK48WqibqGB7If2yMWAIA3SJp+afv1lHvrZpS7Adxb3/G0?=
 =?us-ascii?Q?wak6ZObhKM9rIlb/saPAq7WT0UQmML56Uf5dwquvaJpopKjieCmD+xq70a/L?=
 =?us-ascii?Q?llMTw76lWhg0/WACssDUu7PEKikxvSXEJT1gfQw4id6Z6u4uSOrz5Kf14xPT?=
 =?us-ascii?Q?wJmXb/xz2SHFRp8nXZJKbln3YaRVksWV5CF1dBQLMJMs5ATun+TtwEA1XmKU?=
 =?us-ascii?Q?uozJ7+8IyXlbbi/XHOvCqXiTYbQhfAzTOBgpruWGHVfAYaak/clDaTWT5hY7?=
 =?us-ascii?Q?vy8GkbAAyg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410be806-b8ce-41e3-c8fd-08da54e8b8c0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:33.6071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLaMjwbWb7sSpB64Hl74g43tUYWipD+ft+SbVembH2rROTIMI1n0a3mXB3hzgw27bNJAkqc7d8YYq3ECgzHvHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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

After the previous patch, all the callers of the function pass arguments
extracted from the FID structure itself. Reduce the arguments list by
simply passing the FID structure itself.

This makes the function more generic as it can be easily extended to
edit any FID attributes. Rename it to mlxsw_sp_fid_edit_op() to reflect
that.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 43 ++++++-------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index ac39be25d57f..f642c25a0219 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -428,18 +428,17 @@ static int mlxsw_sp_fid_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
-static int mlxsw_sp_fid_vni_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
-			       u16 fid_offset, __be32 vni, bool vni_valid,
-			       u32 nve_flood_index, bool nve_flood_index_valid)
+static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
 
-	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID, fid_index,
-			    fid_offset);
-	mlxsw_reg_sfmr_vv_set(sfmr_pl, vni_valid);
-	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(vni));
-	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, nve_flood_index_valid);
-	mlxsw_reg_sfmr_nve_tunnel_flood_ptr_set(sfmr_pl, nve_flood_index);
+	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID,
+			    fid->fid_index, fid->fid_offset);
+	mlxsw_reg_sfmr_vv_set(sfmr_pl, fid->vni_valid);
+	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
+	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
+	mlxsw_reg_sfmr_nve_tunnel_flood_ptr_set(sfmr_pl, fid->nve_flood_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
@@ -666,40 +665,22 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 
 static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-
-	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-				   fid->fid_offset, fid->vni, fid->vni_valid,
-				   fid->nve_flood_index,
-				   fid->nve_flood_index_valid);
+	return mlxsw_sp_fid_edit_op(fid);
 }
 
 static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-
-	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-			    fid->fid_offset, 0, fid->vni_valid,
-			    fid->nve_flood_index, fid->nve_flood_index_valid);
+	mlxsw_sp_fid_edit_op(fid);
 }
 
 static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-
-	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-				   fid->fid_offset, fid->vni, fid->vni_valid,
-				   fid->nve_flood_index,
-				   fid->nve_flood_index_valid);
+	return mlxsw_sp_fid_edit_op(fid);
 }
 
 static void mlxsw_sp_fid_8021d_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-
-	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-			    fid->fid_offset, fid->vni, fid->vni_valid, 0,
-			    fid->nve_flood_index_valid);
+	mlxsw_sp_fid_edit_op(fid);
 }
 
 static void
-- 
2.36.1

