Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863EE67FE1B
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjA2KQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbjA2KQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:16:31 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC87422DD6
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VT6NPMnRR7xpjBv/Hq/pkohfthOMRiFag8riNNcpcXRvzNFkWzO+Ksb2qpHRzmxxl0bSA9gnvdXiH5orKKZ+z0b0TzfAcEJjo/QfjI4H2yAKCGxQ59E4AI6rGaaMkeWmDywSkIIOC16OywKkY5JI6XDqYN3SeB+ko9cxSk344LswJfJnk+VkDejiIy1odhmJ5OJQrOtLai3nH+Q4ABVt+r5y+H8IVWvHZ7jxAbhRWGp1ptv7oTu+JbH4uCmSEiw8CFCOyiemAoHBPlP9OMzOKHFWnD7Erf4Jf5C6aVg8stX+ffw6mF8l3veAW/quEYnIX7CusoXy6xNHxaCpFv7GOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=YvgfVEsE8Wl5k/cC/ZxHGIGx3AhbsxS3PqElqePDGTqvhQcJudNbkALHj487Rt0z7MyJODlDudSKGt65MGnynCJ0gKR9bAMKks4E6ckeGmrPz+J0YTVBbwjA7jJZ1EE9mbJjsLomTt5Sz45ZuySb46fmwJiXi8/g68Y18JhoZ+4744/gRJsr30s6msjtPfdphWz1hEUjw/JUvyjPM4d2UgfoDoyqIGVFWXMP81gB4rnVBCsNfWZ7kwpI8rGxxRH+zFu+kpCCFVUTiO5GPvNLvTa8MMk5lRhx8FjFj8EemdiCCCMKCSFezC7EHY+AQ72yW5oulTYtgjjhC8ssf5vEbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=QRXPCIPCt2cdmu/JaHKKEZfmWJ+E3U/OhH7giARySgdAYawYH23pLRf+WlyirpVK8NAdo3mR7m/ClU48+rCftog0LUGFpstoRHpgwizXQ39MV4g9Q0LHGeAI9Vj9uHMXzZhB2AijnOC1gdImV7ncGwWKFldYyx/n+n6XsEuv0RUD/afWs5z4C619qfrEMcP1QckQkUD7fHl+Rn2SwIiPKbcUqiF9eOrqkCuLHUlio58QKbILuoSRDa3epTioIsAWXayVytgEGgataPL+xiK0weI+VqcgDV2h6DbcFFFCeyhJprzSZeoA72T9NTDH4jBeIRFkAu9fICMdxAdEH+pFng==
Received: from DS7PR06CA0012.namprd06.prod.outlook.com (2603:10b6:8:2a::22) by
 DM8PR12MB5478.namprd12.prod.outlook.com (2603:10b6:8:29::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.33; Sun, 29 Jan 2023 10:16:28 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::94) by DS7PR06CA0012.outlook.office365.com
 (2603:10b6:8:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33 via Frontend
 Transport; Sun, 29 Jan 2023 10:16:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Sun, 29 Jan 2023 10:16:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 29 Jan
 2023 02:16:26 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 29 Jan 2023 02:16:25 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 29 Jan 2023 02:16:22 -0800
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
Subject: [PATCH net-next v6 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Sun, 29 Jan 2023 12:16:09 +0200
Message-ID: <20230129101613.17201-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230129101613.17201-1-paulb@nvidia.com>
References: <20230129101613.17201-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|DM8PR12MB5478:EE_
X-MS-Office365-Filtering-Correlation-Id: a1f4617a-aad8-4f29-4d05-08db01e1e279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QHrkx4VGhxG7H35itOO7p1+gKX8pLpGAEg5gCmhaHkrB/IDl0H1U0LN9/NJ9ziLQrxiP10YS0YIk+uaLECobOrgZO2q5Ee5x3Uxa2MVKfVTSxAM2X0+iAvs7oOJ1HnbngeXJUflZAXfiZVsykQQTPnig4RUVCjvBSPLEeLEDmrGO3KkAWQ9QvB5BI4RMzo5n+ZEl7DPuq2Z3wp8r4uxqklY3liSda6xwAxBQ+mJ93u2olP/+ZYjvBpK38g0RJI6n3NssqHi1m+hjp/zomB+HemNWbSF5G+h7c7xSyuWTvx51bRgVZgl10+Gc3ot4v3qsSEFVP+68F0yN47KoAZKxWGV/56zpIzi/A9GVP7LXq96aUvyhHqhwISIGvRc6ePAfKU8lyjoPbs4nPZjWhRImfBsKu7Hjo4f9kkobvMZ0mWnWZlWpgKbYfPFDZBi0tl9Dhj6iHZITEiySryfgHeLYOLY3lHbYvejLKLry8q8nySKP4se7RYK5KmqqRdPYOuzfmZECmQPIEJUZhvy9hAeX0ZaNg/iHMjyczrHqI0SD9a1mf3//MJPocQNpecMoVydzt3xjuIo1uukPC47pECjVp9hvoYGs8UpJy0do+PzTPa1/31/ZbzYMauWjnulgrhHQKSBU3IkQ33tOJJMX1G9uyqTXrB/DZf9c7xG+AJUVT1ixpqwlZhkiCQpfizy2+rrwGnZ4rZHivDzWm2Al/wNZFg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(70206006)(4326008)(70586007)(5660300002)(316002)(110136005)(54906003)(8936002)(2906002)(8676002)(41300700001)(1076003)(478600001)(6666004)(186003)(26005)(2616005)(40460700003)(36756003)(336012)(47076005)(426003)(356005)(83380400001)(36860700001)(82740400003)(82310400005)(86362001)(7636003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 10:16:28.0520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f4617a-aad8-4f29-4d05-08db01e1e279
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5478
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 net/sched/cls_flower.c | 62 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0b15698b3531..564b862870c7 100644
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
 
@@ -2205,15 +2201,45 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
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
@@ -2279,29 +2305,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
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
@@ -2324,6 +2330,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
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

