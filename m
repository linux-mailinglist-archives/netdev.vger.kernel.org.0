Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5204C68C506
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjBFRod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBFRo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:44:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1092279B8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:44:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRVtYANPlOUQyAm2fpkDbOV4IOHdVn3/yWxN5b7BFrW3E7a+kYtfbhOhZg6VME7DM72jZ/doARMnBjJJLl+9C1Xs8Ay27pJTDE6sDNKzDMD6idP8fD74r0OOFfFuhc2mp4FSm2vUrL1jRcrbctZAPDYr/LVc37VwBNJSv5lNZxL+5JcOJhWIyjQx0w1UZ0ubn2hHXSlMw+zWTdEfTY6K0B0DeDwDHQ0xSHgEIpH7dN7YC/OO6CZXOcKbrM/30swwN9KZrtOlCVeHiErPKIegJPISrvaB/VsL+7Kq6wcVEfKR9VryasB4X78T/GPosUa2Qx4Ijc/kHtU691dJkxnH9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=av0KxosAm71iOlxcoI1uZJ2FvUuHrj6C4W82o9BunjOpP43TVyu20tSzZ9PdyNAesiBukImbO2dKmpMOgNEkc/dZg/UQtmkeLGW9EGbKufQR5I78GrQvjsuXVfW8X1gZWEQF55PgnkdWLxlXPk6ciNc2Du1JzP7jUcUOO5K/MOrJT1C0JZVoBNVDbarKC84u8Rayo9RDJp/khLSKAYLM00poJwQnbKE9xIQngtPPprFaAF8AWi5WCSHoLF7NA7sj6WQi8AD1e/x04NCTLtx8td5Ph4Kn93gP2M5HzjqhJTfleymQkGYMZII3YWMeOCnzjMvHxu5vvx7w5kjcSvH5OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=ZXzx8aTTreJG9giUQxQ6Ta1TICkyRPDs3O7IbJcx9B/f3NAU002MTyVQj5ad/59yELPqWcEzUr3AZdacQbNecqk0Vc82cm25pdNxCBwm8Ls6O5HdQeWScOZMQuk6EcnzgtKl/0aUnnPuxDIIpnhCj8aIKTwuuxOOYz6sLsxxr3sIW/+166Y3oSEJpfNm6bNWeyR5oGGhPbjqfRcRMLSZITcFwRj7WjBvizLsUs3c3NEBmfjjw4ruwgIPou6/P4+6l5a3x7rxmUezz+wwlkP0/CBBA2aBllf4RnP5TKmH7Y388K/x30kwz5x1MOg/G6byfCaxgPIQe22XRKNm6paHHQ==
Received: from DM6PR06CA0018.namprd06.prod.outlook.com (2603:10b6:5:120::31)
 by PH0PR12MB7958.namprd12.prod.outlook.com (2603:10b6:510:285::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:44:23 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::93) by DM6PR06CA0018.outlook.office365.com
 (2603:10b6:5:120::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 17:44:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Mon, 6 Feb 2023 17:44:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:44:20 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 09:44:19 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 09:44:16 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v9 3/7] net/sched: flower: Support hardware miss to tc action
Date:   Mon, 6 Feb 2023 19:43:59 +0200
Message-ID: <20230206174403.32733-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206174403.32733-1-paulb@nvidia.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|PH0PR12MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be701ff-6db8-42fc-71f0-08db0869c896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XGt32e1RCsm3RXKEZSSoTOHHNVHJgFwVrfWrWYQRtQykU48+NoYR6ZKzwNdcgA/sSg6D/LWh/vvf/96j6yo8izAwdbm4vdBt2pVM5nbveIw4pVAfQXn0cwS0MFConluXw08YZT7mR8Tm8s1navjY6nQoE4HuwJQafakMhlK+jnG7zcmMPdH4vI3l1qSHy+1+H1q4HiKdPv3+se8QZ9bRT/ltvLw/fTmuuLLZRy+zx6ztUPUWkL5mwRhAkibaV1gQxkxFtFpp0o76w36e5evp9916+6Hkv39cdmSjAG+pEQM3jI5W4GYgNITQ2gmR9lzOzp4uVsDhj346YsDpxvF8c2BDqIOpu8m92lFI0flG+E9nJUG1IVRvFLryJD9NhlZW5R9IwYLIJ2mbyvpZuNN+hsjPLcPu2AGS56Lp1MRcKKY+1/OfO8VShUrpqekrfCvM7K8LOxx7g3P9PVjK+323HejMBNSdiSQIs/vhzyOqINlWznCMgwePP8WvMvWxHCdGsUurcF2hY5k56ylqhFN/L1xdmiDYrt/74n9Qal4eW6xfzr105wgJxbFTF3mS8NAiX5t+GdhZovVVb6uTYFp5HNf7lZQdIvatV4qHRcUiR081oCKL3p53Amiw9087HQlX66DJmbcLOA9GPX8zlfPiQ0DBMcLKjmyqgmVd7gSdSron9RUkrop5qD0Vdt7bHtGhBfxtUoQ0wLhLEof/goxHw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(110136005)(5660300002)(316002)(41300700001)(8936002)(8676002)(4326008)(54906003)(86362001)(356005)(82740400003)(36756003)(36860700001)(40460700003)(7636003)(70206006)(186003)(26005)(1076003)(6666004)(70586007)(82310400005)(426003)(47076005)(40480700001)(2906002)(478600001)(83380400001)(2616005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:44:23.1542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be701ff-6db8-42fc-71f0-08db0869c896
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7958
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support hardware miss to tc action in actions on the flower
classifier, implement the required getting of filter actions,
and setup filter exts (actions) miss by giving it the filter's
handle and actions.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_flower.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 564b862870c7..5da7f6d02e5d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -534,6 +534,15 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
 	return f;
 }
 
+static struct tcf_exts *fl_get_exts(const struct tcf_proto *tp, u32 handle)
+{
+	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
+	struct cls_fl_filter *f;
+
+	f = idr_find(&head->handle_idr, handle);
+	return f ? &f->exts : NULL;
+}
+
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       bool *last, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
@@ -2227,7 +2236,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3449,6 +3459,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

