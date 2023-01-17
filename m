Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A891566D848
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbjAQIeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbjAQIef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:34:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC5629E3C
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:34:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXAFrF+k44zgzDPjXda/h7aOmzbm2cvHPkqrJDQXWvRg97W+xLCDk3rX6ZQjwkB2NlZq6kwOJlGwVvStfJGyoyPByVas3sv4MDrJkB1aYkMqDcZ9Y26DiOjpBHsemaQeo2uBS24hAprTodK0mtwKKMWiVNwebHV1sxJh2rhmNoqCIqJWFqldm3aebR+yxHmld9wMh+eA4hMfA4sVEcFYJWoEV4IjC60Mbxl01ryp/FFZ/wQ4Q4COIBK9/MWniWnhsgTkmse+C/FRgBsx73cMKUHwPscBJNrqOG5ztchYrT3TBYR1Ls4wn+NtRBoh0mswlXeRX5pPowpW/oT4f0yF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8OYOOEsC8xGwgh2M9ur2WnW0MvOJQtmg1NeINxI8RI=;
 b=O0+crMIJbsTYL6ur30fQQv5cbpEz1Vmm4XuKSbitTlxPT+4+4MYoI3NgBoM8rZRWSM/s6oQ/U3FjF7cH4HcMs/pZQHRgt+AzwgnteEMOjJiWvWDP4Hx0enWiTUHOhelGs9+0fU359EKjhH468ZY35I9VEkK1PzxPdQcorbg4C86RNUi5iDlla3oo87wdI5ArO6TtV2B1Y5o12GGAfVtkcLk/yZXg7I6LocKugR1Dvfqz/pFYAnNxvj8ctY88Y1xZlAgKAqYNTOCSMFNcX9FOucrOCjeyWaaFKwDAF0+p1pDJ61iHijwVb5o3+ZdVn78A7zEvzZhI669Lj9jG9xeoeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8OYOOEsC8xGwgh2M9ur2WnW0MvOJQtmg1NeINxI8RI=;
 b=bly+IgUlE3X1gF+ot0JhoHr0kXNOkzu3DTAcojbnTxB3R1K3LzeAXyhQ7ZSO07W+omvWd+UEDmuXV/mXoX3buQ8wboquj/YsBqADyN38VFaPsXtU0WrO9VuLqwcOwA7OPugtBioEoPOXAiyirUSyAsN2edWiDGgIoUxrQSV26spn3xsJZwQxZVgQ++jt19DG+gLUyxAdePwEEnTx/jC8Z8LX0sK2hoUO/gEPRwd2xp4Y/BnHpDvxN3ahrdnf/Hg3YOs4OcpXpo4wT8GDdx0Y72yNTUtzSvE4XNZ6nilVD/r04fAjtUUri3wMAOZt/bwwUBGV5eZRTEkKzbbrGfRYbA==
Received: from MW4PR04CA0049.namprd04.prod.outlook.com (2603:10b6:303:6a::24)
 by SJ0PR12MB5470.namprd12.prod.outlook.com (2603:10b6:a03:3bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 08:34:10 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::dc) by MW4PR04CA0049.outlook.office365.com
 (2603:10b6:303:6a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 08:34:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 08:34:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 00:33:57 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 17 Jan 2023 00:33:57 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Tue, 17 Jan 2023 00:33:54 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Tue, 17 Jan 2023 10:33:40 +0200
Message-ID: <20230117083344.4056-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230117083344.4056-1-paulb@nvidia.com>
References: <20230117083344.4056-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT019:EE_|SJ0PR12MB5470:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c7a09ba-93a7-4eef-fb4d-08daf8659b2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y44G9u0cCHSo6AYuaJ0ODWihcE2kR/UqSAHUn5k8lzl69exAGfB2iUviEDl6yN0c99S/A7hya0SmVnlnsvaqp5Jvn+ZiT6rik0GZumR4dqEZ8/iAJZVDCKBztkuCO1ee2hg8fgdtQB3C7qVbU3839EikW+H/IaaEehxFB9BMGxJCb733wP2H7826ygpDEoMn62DomtqB988nMD/6uImjIbjmmhonwrOaQySQajWm1tNamFXhsXuR4wbTKl/rOJmOiHq3sl2Xm+pRG3wTDyxp+ACxjVUkEtT42lNl4eETvKRw0zfu9l7nUyzz2Xi/9L8toGaTh5cI3zCDjnLFcTVvgIzCyPbd/dsDFh6VF5i0Y/WenfJVKwWLQvvbX2H+WdiQ8fO7rQOcE/W2s8i8uVCSDrS0dDozun10pemdFRHsc5j7xTG2HeGD+GVNm0nbT/tRph6iyjzr2YX35/dOaIMIFMpb32yxD/8m1Dxei3MUW+JJnUNRtKsyT3pLj6G1YavPkBBfJb1/50tMp2Wr3b857uxnFObtcVjnp3bc/PajLMsGAIUfSjhJ92lEojWFo8Td1A9Ie8ZFVHGnnNm4OSmSoO/oq+EO3TCHsFEjdlwpCuIvXsfyu59grZpVYf5NJExKjSB6MTHYEugzrGfez29LNflUXUavuxSWApdG5CaaE+3MeD4+axhreEtmat+X0j/i35j/7uQnafWNHnAUAz6VYw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(426003)(36860700001)(83380400001)(47076005)(7636003)(86362001)(40480700001)(2906002)(41300700001)(5660300002)(8936002)(40460700003)(82310400005)(82740400003)(6666004)(478600001)(8676002)(4326008)(2616005)(336012)(26005)(186003)(70206006)(1076003)(107886003)(316002)(70586007)(54906003)(110136005)(356005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 08:34:10.4251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7a09ba-93a7-4eef-fb4d-08daf8659b2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5470
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
---
 net/sched/cls_flower.c | 64 ++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0b15698b3531d..99af1819bf546 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2192,10 +2192,6 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	INIT_LIST_HEAD(&fnew->hw_list);
 	refcount_set(&fnew->refcnt, 1);
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
-	if (err < 0)
-		goto errout;
-
 	if (tb[TCA_FLOWER_FLAGS]) {
 		fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
 
@@ -2205,15 +2201,47 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
+	if (!fold) {
+		spin_lock(&tp->lock);
+		if (!handle) {
+			handle = 1;
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    INT_MAX, GFP_ATOMIC);
+			if (err)
+				goto errout;
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
@@ -2279,29 +2307,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
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
@@ -2324,6 +2332,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
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

