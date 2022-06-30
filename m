Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C81E5614F1
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiF3IZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiF3IYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C02F140F8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWc7KBJZ9UynXX1CXPi/KVgGtI/Fyn8itgvtc0pGtJzbGIhtcq6gvzKxr9IwEuRriiwqMInxbCa4F1p+HPbHYc/BIxBP8U9E+lvQfGmlGAdIgDhRE5yeMGyi9Ow8MLSPfbv8FTi/lGfW25j1+zIawaajnERjnOJYN+z3Ud63LClNQZIlraL5YgFnRt2akY4IBvqplVxhaBlxpfw2C/ydMpQIfOPtTxwnvNZ9Y9r085W8K40PkevRNvdv97gZibWQkCDsPSUP+Tx4eVWTQbQmPxfLGWDk7deqdK+kk38Ii6fZFKINCCDdUdG9F1zErY0fASSQ+8kfo1HRSuMLSzu+zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDyfYEEFF/NinBjQas9Zomuur2bsLwUMaF3KQ+DVk8I=;
 b=XJa39ICYrYkXO9OHfmpKutYXtGr7b0Yi9+NmwmLxVfs2ZeI7OaJnF/BJZqBb2FmndHfyqNkK4+LjrW+xtUCsnmD+9nQoxJQIDsjVZLyb/26iDKUFsPp6CQWOrx/VJuNVtcbIH+pJGmQ75fOEOFWVBXX14PZW/lu10Uo83fa1UBG/VMLJHvHIfz4a6TzNWPuLyrlBGQJh9haGnUHXRQN0FZvqNDoSj5tENkEfK3N+b6NBQt7ml8peXvWgMVES0VOoSp4Tfyi7LYOwv97I6sORYgAEq52foeYVoBIrAFBtYh5kiCmCrd5rh9vIh7ERoBXQ1a46VweBquH52b+uBQGMpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDyfYEEFF/NinBjQas9Zomuur2bsLwUMaF3KQ+DVk8I=;
 b=c1AI49xBRjZBBa32cglfBWCo8ArnUaa2kAqkvSzmrTMPyTWx4RLWCSU0Bh8Hu/q8v/JOV5lL5ez7RbUDml7NrFo79lSNM7jFfogw37LRoHEIM2lsExPcLzWDMC+NoQ0Ck0Gz/5YahdTi+4QfGvX3Wxw9zLvB/18CGwrJsYbvfdvnOxrcxNmq2ZuJRvAMVfplRAqN18JMNnWkZP04/fX2FQs0LBZtvtpocTtmJurpnP2054WoyjKo2doefrF1hPn2YcQjIE/yZTLwlaL+nDyF8qeCE779TjPDn1okDX/1EpCG46tuDDsT5/LMBQKGthjiIiqJ+dNXqnJpNCeS8LvGMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:24:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:24:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/13] mlxsw: spectrum_fid: Remove flood_index() from FID operation structure
Date:   Thu, 30 Jun 2022 11:22:56 +0300
Message-Id: <20220630082257.903759-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0288.eurprd07.prod.outlook.com
 (2603:10a6:800:130::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 143bb3fc-8cfe-48f4-2ed9-08da5a71f6c0
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: puJzznw6Q1qpkGIanlqMZG00ZOitFFyloaLFBmhQ4hux4nQR8nyBzLU7xfKPwtXs2o/UII+JtMw0JatbhYsAO8iHt4bgdtQhG/kufTOR22KPCm/QVNZm9m65HAM3DZ/zMb0QtRnHdl4wbvpILuMPqIgSFu5bKpOccnyQ+vMHLc+4SlVToEXjwvm1gZ+RAzFFCacLxKJbV2jBWxkOHdJM3qu/cqHuUIfSwTepb1yvHHJyBdrmv3ky9NB44HGb9BhJAzgmbZKGGjqticBQijRum2agADM8GZ5/CLFCIoSLMbttDqB45n2oIza2Mkeh3yJgc4c1F07Yh73CBy+EEVuezCB6yYnT1MPDU6XDvh4lNkQon9c7mOaHYFQqLgHg0Mu32thpM7O61rXGV8NHhR5cHO0P/zak+PKleniXN3ZW6XdEw1/6dFmjbSwhHEQggotOEuRE56X2uWlTtauLU1R84SDk4ToTJexnj9bdLrRrA2HjZAWfI5YX9btiHSRwSAdOsCw9wKbwosSaNlmQJziYXkloNw7QccrsaAJeUuzlyrKjZOcst8GK6eiOJnVD8xcFWwf/sHcktLnpLk7WeXkrn354z4durtuOuEOep0gLS2NAPwbyHkR7a99h8DsravsRLVM84OtLN668Lba0ytuQZ/JDkiFRMFXlIn/tDtndSgTHeeUZsnIV+rYwIA6wlThPQRNMoByPq+Pz/E6R2OtO83xqf9WQmt90f5PJZfYNuO2ZoEAhCa1yCT9BHE/lpgMqB5lx0zKM6FN/7SPxAsmTig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RvBvsNUR+g5QZbwYqgzo0zWdJQYtUeF6ui2n1CJP9EHbXOcw+NGTOqDc/Kf0?=
 =?us-ascii?Q?CPPcyjZx0LXa6tkecBz119f4yQrnwQuU8bBtxBj3dflyrFdyTEkV9cAFVQ4J?=
 =?us-ascii?Q?uSLGedzvDRf8jKE8eqLNIDQViciymRby5PcCH7MmRM0BLUGWyAstdS8ppyHu?=
 =?us-ascii?Q?VDidOkP0us1Pz1FUJaE/PSronNjPtz+22f5lOc1XD1cG4w755PEbUpEbQ4zM?=
 =?us-ascii?Q?ZVA62QsEyBinU3ESdvJkVfJuSia3+Q+AARGgyQnNNfOQE7e1GNXlgOKL6bbM?=
 =?us-ascii?Q?mnyY8DHE3LK5+tcFEPZLyTYhR8Um0h49NQIN0uJLECCRLa/MO+v6e10QTQvq?=
 =?us-ascii?Q?DPAPD+y6mJdaX/ZE7E+UNxuQqC7srU+XnEDk1s4WBzl1p/6MRojMEQIIz15Y?=
 =?us-ascii?Q?cG9fKuHuO/mKvmuS9YWvnihLHas6InYT1H9WSZNLpmgTA3pX3LFFewdwFlOY?=
 =?us-ascii?Q?Seo0JXL6siVrFxVY2pDHA+lDP6y9Q+G1UWzOZK98mwQ5YZ9A3hN1dCkx56gM?=
 =?us-ascii?Q?xoaEtfNVs+KqpJIcwb5MHeeEmu1iTN76I/vt5lrrcHArUsShOqsq/X7xeKWh?=
 =?us-ascii?Q?XgF0EI8yJpG82xMoPcc4fvGAZumwbofEJTi1BtccbWb1G1FBbfIqcXoD5Xtn?=
 =?us-ascii?Q?0QcK+LqEQoqHcof2wUQwYquLQfmSxMjRU4ZV8oEfAbsd6KpqamFHIteIS+nF?=
 =?us-ascii?Q?JSAs/b9ac5dAQ0KlG6YdOESNHy9cWSuciIoy5qzmzuMrUc0ygLcErDtMItGL?=
 =?us-ascii?Q?Ki/16sNxuAnKuOI90RykydQHzNEztMgUfb8reFqGPWE7igz+ydU6GiwSYIQL?=
 =?us-ascii?Q?C5oNbs4iVbzar+K1ZhpHJu16pt67yc8mZklxO5FAkM/M+fW+b1kofomwQh32?=
 =?us-ascii?Q?9oiQy7+tZ6Fi+ibu3JzG1TjdfcbDJHdlrN6Dv4ZFWhMgorm5b3VL1JA8pKUM?=
 =?us-ascii?Q?Efm13hZBabdWzDiMgsMA9upqUfsamvJl1TbyR2hI2aGwwYQJyjJ1x9N6Cqev?=
 =?us-ascii?Q?TIt5bP2BpBRjOkMpeq4sRwv7bj0/C5avK5jtfjZL9XVwj1OmFMAnNMje1x94?=
 =?us-ascii?Q?qJOB84Ttrl2TQ9dKV2sRFRa8rgsJmrpqy30jIN7X2klbDntEan0C6x2JyuGG?=
 =?us-ascii?Q?xcJAiMgIx/I2vmb2WWZGFkk0z7ZTU3Tj7gSUbqswtu2ATICODLPguU4f4VfL?=
 =?us-ascii?Q?/gixy3Gn+AL9Zps3XRu0/gtuev55XvNwzAMJEFWl1kn4nV5r3IFGeCrf1VBv?=
 =?us-ascii?Q?lNrY1Gy7DMjFS+1bdOnYDWEzMxlbtKUKatud/Do3f/1359PqBL7NfZhA4XWf?=
 =?us-ascii?Q?99J+SnJ1It3LjCQXhf/Y8MfmWdDbVrANfpdXjRDI67WIB27v1jngrAsPki6c?=
 =?us-ascii?Q?Jw6CgZoBeOUInbTdSiqb1BPW1oILMD4wlDHS7ExAQwVzmxm3nI/saFGTaQc9?=
 =?us-ascii?Q?y3/agpy5uRaikN/V98hLOYRCKi+5ialM7du9uOu8FN+ESoV04vf9i90j1eD6?=
 =?us-ascii?Q?PwnxfMurYfxt54TZb1fvvCG7bxr6Gf8/0dQoJy1+GBwVDgacKlwlCbUZw1Ec?=
 =?us-ascii?Q?4GKK88JgX5JJkwIFkM9s1AvedT0SChDuLGHOaa73?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143bb3fc-8cfe-48f4-2ed9-08da5a71f6c0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:24:34.4721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxXoEus6Ua4wVnZdE9Uo5VXX3KFCpVdaTGjVFxSzhEQIsJUu0F2+Hyini0lah7cSsYbMnHqpRlyRgrqjT9JpdQ==
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

The flood_index() function is not needed anymore, as in the unified
bridge model the flood index is calculated using 'mid_base' and
'fid_offset'.

Remove this function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 818e458eb3ad..da581a792009 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -83,7 +83,6 @@ struct mlxsw_sp_fid_ops {
 			   u16 *p_fid_index);
 	bool (*compare)(const struct mlxsw_sp_fid *fid,
 			const void *arg);
-	u16 (*flood_index)(const struct mlxsw_sp_fid *fid);
 	int (*port_vid_map)(struct mlxsw_sp_fid *fid,
 			    struct mlxsw_sp_port *port, u16 vid);
 	void (*port_vid_unmap)(struct mlxsw_sp_fid *fid,
@@ -348,11 +347,10 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 			   bool member)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	const struct mlxsw_sp_flood_table *flood_table;
 	u16 mid_index;
 
-	if (WARN_ON(!fid_family->flood_tables || !ops->flood_index))
+	if (WARN_ON(!fid_family->flood_tables))
 		return -EINVAL;
 
 	flood_table = mlxsw_sp_fid_flood_table_lookup(fid, packet_type);
@@ -815,11 +813,6 @@ mlxsw_sp_fid_8021d_compare(const struct mlxsw_sp_fid *fid, const void *arg)
 	return mlxsw_sp_fid_8021d_fid(fid)->br_ifindex == br_ifindex;
 }
 
-static u16 mlxsw_sp_fid_8021d_flood_index(const struct mlxsw_sp_fid *fid)
-{
-	return fid->fid_index - VLAN_N_VID;
-}
-
 static int mlxsw_sp_port_vp_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
@@ -1073,7 +1066,6 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.deconfigure		= mlxsw_sp_fid_8021d_deconfigure,
 	.index_alloc		= mlxsw_sp_fid_8021d_index_alloc,
 	.compare		= mlxsw_sp_fid_8021d_compare,
-	.flood_index		= mlxsw_sp_fid_8021d_flood_index,
 	.port_vid_map		= mlxsw_sp_fid_8021d_port_vid_map,
 	.port_vid_unmap		= mlxsw_sp_fid_8021d_port_vid_unmap,
 	.vni_set		= mlxsw_sp_fid_8021d_vni_set,
-- 
2.36.1

