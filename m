Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D9769B598
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBQWg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBQWgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:36:54 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CF130FB
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:36:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzVHYj8Ai86NG0LfFDa/Wb5YBTm922HwY0F9bKStWc0dcqs38/Isj34R/WXhiM+lebij4aZZe/rg8IvbZ3AtOaMbG715ZnFB7QoBZFtBzSEerp1RZhJenl2Vj7TU6T/CV1pyGCuw0AcZnaAQV/me+M48E/C6nulanUrESaB6ZZKWeJII8/7hidTFFVcKzAOh3OKEOZYLMmVjj3mh4NTyepO2FdA5/BI6TMJ1LMs6TSiHCKvlczr8ptn8GUhjjLGVgWZzsbzeGEmwNcNxEiZYYwaYkGaxdegDVPBxMXEyfwL2W//YG6DQfSURBJ/96cBkKElb1iffnJXxpRDBxDrXPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9aFjUP/bSCQ2TBDTZHhJtSEIN0bbD71MOdATZx4n+E=;
 b=QYV0jsRsfXLTvY8qw2oQ70XjZfVw0IspbKVkqLDvVGUKrcXB8ZZmPWtFdMwHm5ZNUowEY3MHkG1Lqv/FO0+b83/QzhZ6lwJdR4pp2FJLkS/DQ6EUwdCZDjkL91eaG4p4qNm1PCNBX6nhAlAQmLTpJyyHeMk3t5mRFMNezbAEM+HYSLYPgr+yBJT0jsPYsOo5O3k2RchBXjhFmrDWjtzbphlwSMBJ+tfgxJwyH3oljAKJjmm/3vvca+G6bBSsF8Cm1A5mYtp+9Ig/nGiVXkQXwTIOZV2WTYqXxwDECu+diDFeWFzCQhMnKP/qr83WrEl3qk598+Bbd5hWj6aWII+zVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9aFjUP/bSCQ2TBDTZHhJtSEIN0bbD71MOdATZx4n+E=;
 b=jWyZFxthaF+7mbeg4QDX5P3SooKFsJCpmhDMdWT3BB0q49gSsuzDTJvU4WXScjkO0zS3ZnVYKfrDZ9eneUodxDmLHLJweXpOfTGD1KdkxppKIvsJ4meU+kjKyzsC5Ryr/LWefRvrBzuCcU0mOVFE9P4m4NG5JyPSNidsPJ1mVTtE7mGPXR8reCSkWxu93L4lOnLViiFLLPJa6nx41B+whMcuAEVJWMcfclhg4vX+PvuTDEpi/BLEhwH4ANTCAS4sGw/4S0LcTqEbz760t3LYh5SdTnqBT9YCODLKwSTyznRXv/yCFYCLLSt4TJ9GlPEabOEThE00yJ+MQsFS6/VdFw==
Received: from DS7PR05CA0078.namprd05.prod.outlook.com (2603:10b6:8:57::24) by
 CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.15; Fri, 17 Feb 2023 22:36:48 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::9) by DS7PR05CA0078.outlook.office365.com
 (2603:10b6:8:57::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.12 via Frontend
 Transport; Fri, 17 Feb 2023 22:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.17 via Frontend Transport; Fri, 17 Feb 2023 22:36:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:41 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:41 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Fri, 17 Feb 2023 14:36:37 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v13 3/8] net/sched: flower: Move filter handle initialization earlier
Date:   Sat, 18 Feb 2023 00:36:15 +0200
Message-ID: <20230217223620.28508-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217223620.28508-1-paulb@nvidia.com>
References: <20230217223620.28508-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|CH0PR12MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: d001d18c-404a-41b5-47c2-08db113774ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mByzIJffNCvRzBx6qJGI1xB93plICwPAQfPmy5+GXp62KucuR0i3TmehUIhEq5gLyHXsTTVtg9ft/5af4OxNqfIJ8lcvUYgBgWY9Ruzp/gtdj2eGQGIjHn+hsHk1cDUw5U5c7avyK1UUmOD7xstUFzDOM6VJLaGJ8qQzcUO6/IobZUnvruEV6j+yQNCim3KgCQENIWbwV86Wjvel5ORbsLbinaTA+I7A42S6KVu2GQS/7RozacW4EzRLq628+9PkHbQncwRPqRb1AAAhpvnPw1xUMbjG88SQAZ+Vs63prc4c8vfxW0jcTbwiy3Y4scVdl3susAKz5oEVxZ1eK+17M3QV2/Hyhg4xm6hZC7y1wZUEu+ue4SObisJInmbI+mxxaigRVvJ/bw2Ut/lzjX6oSNpUVbDD/VSmes0bowDl1VTMhkT6Yv8Z7ze75hgo0W+gkxStRopjUhYplNM5CjigeNvCjN2x4GlEbN1aprhi89pzdB57fprWxCxlJ2vifQWkv8SSzUTmlv7c+LdsRkW0yrSy+lchpL3SiFH/VFJQt6VotCcxbyTT2NS70QTYDn8mD1qbvZpW666X0cowKmZ0av2bGUtVzL666x1vyxpXmpUoJS8M+qDMNUGm8TyORqsBxob8sH9Xbjsk6YjwlGKXhAl2Se7hvzzeKtr2NmYGg7IldCIGFEhl/g2oAhxHvrUqAKxud/FHWT9xIZCuWAj7oclXOnJ4HRftSjH2yMLdKmw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(41300700001)(36756003)(4326008)(2906002)(8936002)(40480700001)(8676002)(70586007)(70206006)(356005)(86362001)(921005)(7636003)(82740400003)(36860700001)(6666004)(478600001)(1076003)(110136005)(54906003)(316002)(5660300002)(82310400005)(47076005)(83380400001)(336012)(426003)(2616005)(26005)(186003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:36:48.4075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d001d18c-404a-41b5-47c2-08db113774ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support miss to action during hardware offload the filter's
handle is needed when setting up the actions (tcf_exts_init()),
and before offloading.

Move filter handle initialization earlier.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sched/cls_flower.c | 62 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 885c95191ccf..be01d39dd7b9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2187,10 +2187,6 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	INIT_LIST_HEAD(&fnew->hw_list);
 	refcount_set(&fnew->refcnt, 1);
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
-	if (err < 0)
-		goto errout;
-
 	if (tb[TCA_FLOWER_FLAGS]) {
 		fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
 
@@ -2200,15 +2196,45 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
+	if (!fold) {
+		spin_lock(&tp->lock);
+		if (!handle) {
+			handle = 1;
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    INT_MAX, GFP_ATOMIC);
+		} else {
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    handle, GFP_ATOMIC);
+
+			/* Filter with specified handle was concurrently
+			 * inserted after initial check in cls_api. This is not
+			 * necessarily an error if NLM_F_EXCL is not set in
+			 * message flags. Returning EAGAIN will cause cls_api to
+			 * try to update concurrently inserted rule.
+			 */
+			if (err == -ENOSPC)
+				err = -EAGAIN;
+		}
+		spin_unlock(&tp->lock);
+
+		if (err)
+			goto errout;
+	}
+	fnew->handle = handle;
+
+	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	if (err < 0)
+		goto errout_idr;
+
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
 			   tp->chain->tmplt_priv, flags, fnew->flags,
 			   extack);
 	if (err)
-		goto errout;
+		goto errout_idr;
 
 	err = fl_check_assign_mask(head, fnew, fold, mask);
 	if (err)
-		goto errout;
+		goto errout_idr;
 
 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
 	if (err)
@@ -2274,29 +2300,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		refcount_dec(&fold->refcnt);
 		__fl_put(fold);
 	} else {
-		if (handle) {
-			/* user specifies a handle and it doesn't exist */
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-					    handle, GFP_ATOMIC);
-
-			/* Filter with specified handle was concurrently
-			 * inserted after initial check in cls_api. This is not
-			 * necessarily an error if NLM_F_EXCL is not set in
-			 * message flags. Returning EAGAIN will cause cls_api to
-			 * try to update concurrently inserted rule.
-			 */
-			if (err == -ENOSPC)
-				err = -EAGAIN;
-		} else {
-			handle = 1;
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-					    INT_MAX, GFP_ATOMIC);
-		}
-		if (err)
-			goto errout_hw;
+		idr_replace(&head->handle_idr, fnew, fnew->handle);
 
 		refcount_inc(&fnew->refcnt);
-		fnew->handle = handle;
 		list_add_tail_rcu(&fnew->list, &fnew->mask->filters);
 		spin_unlock(&tp->lock);
 	}
@@ -2319,6 +2325,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 				       fnew->mask->filter_ht_params);
 errout_mask:
 	fl_mask_put(head, fnew->mask);
+errout_idr:
+	idr_remove(&head->handle_idr, fnew->handle);
 errout:
 	__fl_put(fnew);
 errout_tb:
-- 
2.30.1

