Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407E1667082
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjALLIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjALLHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:07:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429FB48CD3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:59:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWLfP7yxFSCybTyOdglxz/Qg64YqJuDlH8oxQcWDdS/kHdlUdN6fZlzEuQynDvJw/xbIB7H4j5MYQVzwtVwaSa6/oRZrcd4AywKy1NyLlzViG0HSDMVK+cq8WoB/HtZNvPS6F7kVCT+Px6TglJ5knXpko94b9/LXbu+IVJ2F37x3T9ccg269QooXuC2Wl0nO7bEUhRn3QExV3Ywxry1tyqVqlz4iVtcbg28vPd2z1PaCiJvF+JJOH0Hx+Dws8Z0argglnb0Pjku5ESwonHuVads0M1BqIqEeVqXky/H97b+Ey272lpM3pHlqgEw0gz6ckTFlM/C4JE9eyQx+adv//A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8OYOOEsC8xGwgh2M9ur2WnW0MvOJQtmg1NeINxI8RI=;
 b=T3wmHqtSrp9c7BaihIcu9VJBLHCPXwJdw4j6UVXMhsf46L9RJxW2H+AO0N5ci+HffPxdVbNhpL5ZyUX2tNnJm+oH3Nsx8E/kCayea914/zEErsfXV2hNl4kBh0MVaFhNnGjcrNezjUr+lTU+nClVfE+6caAL5lRjhd1kzNA/pkdB7tCvZXMZzPN1aVKkGpCo7b7o++yGTl5hNHHMtjJj2Ejk0hneTmPfhYmqWfFy8Sxpl3lGTEIBwkc0ng+hkQjL5D5n27IHxJrfSUan+87U11hdlD9uhUDbyuXke/kWErLuyGkK0fUARF2JrLLi99ITcCuczcFEphpxt/ZAIz5HyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8OYOOEsC8xGwgh2M9ur2WnW0MvOJQtmg1NeINxI8RI=;
 b=uPS7Gc29YYvm+Pg1EC7kLwNAtXQKwlbHL2WrXKcmxcgU4XSI8zXH7RQm678bxsHOHduC6ypnxFXu5HoqulRUQzTemscuwEHD3hSWU/Gv4gXZyj5SLp8bbCT3NuUCNmqWGexJjEbNfPLNOayyoJtjlqNuYNibNKS4Kz/6q1fUzjDRS9CvNEp2A4OFEtWhXZIuQSqymtQH+1qGCGGNoeakqG2ghJLPxlEPh3tbZa5rmRIijUtcF4Za2Tl3f8vnCb3f1agPQozBb8+8RCHl5qmtxb1fWCuo47+dlzXYpYLAHNRQ9J0Sf3WymsTl5bMvJX8tfMcSwJVGJpKc9mfTSJ0ulA==
Received: from BN9P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::11)
 by DS7PR12MB5765.namprd12.prod.outlook.com (2603:10b6:8:74::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 10:59:36 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::c0) by BN9P222CA0006.outlook.office365.com
 (2603:10b6:408:10c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 10:59:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 10:59:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:21 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:21 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 12 Jan 2023 02:59:17 -0800
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
Subject: [PATCH net-next 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Thu, 12 Jan 2023 12:59:01 +0200
Message-ID: <20230112105905.1738-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112105905.1738-1-paulb@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|DS7PR12MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: 07bffec2-1b6a-4c26-399a-08daf48c17a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDOP2ZRf67vkatBBFRGeSCFP3G9HvnuDud+iaDmI/6P8rPnbzAbp1gMqYtg/eW+reQTSFYqzp+xKUw5Hc7FpBbGfWMsLeqmH+d7qQve99Dnn+XM5Sy1Tlode1swNuHVLsdc2Cv9YSET6bCz53Lbb4PCzJcXejERnPVNtDxAauF9hM8v7EZmt0bvmQ6jk0Augkpjcd8nZUr+YjyQ4E75mam2bA3Ch8FOAkTSpHvn9lhA6WFm8efN2lXtCI4fhc604gDk6YrQfF9IP5CoVnkPxkDfXAAqXqcDsIBdtL/lrjvJNYjyDixTJIhLNZtUPYIT3OPfq8XD4qyPCGPW69j4p1Hy8tSST4Pb5rqscfmzPyl/Hj4TxYPoj3rOuPaBQcAw/s5q2cvuzndEn/Ck36wMRYy/GTZ5YW3QUzE82BuMMDChnRu6x/06kf/YyKBXKclbY9mI+XUsut5/AOePRGEIw9U8bFXpvVhLnt3iEeLJjKDPGAHmYIeeDO5pj/IKvIvSHILUcForluzw6lIvIIRei4I/xr54R0hI2pyL7ZJrVPEOdyVZMjD6kH1/fICsCyJcepEM0rxku6QJiVT/jRAfFdfubHfzfHZ8k3vvQYiM+4bH353YssbpJTw7tuze1NasDqCHhc0e0aA+sODvS6Ey65jY1Zytoi+diu70usYBNvjLpvks/ulA+0iHETHl0ic3RBBeXy/ptvb6iI7+V5vh6WA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(70206006)(107886003)(70586007)(8936002)(41300700001)(4326008)(8676002)(54906003)(2616005)(6666004)(336012)(82310400005)(1076003)(36756003)(2906002)(40460700003)(36860700001)(5660300002)(82740400003)(86362001)(186003)(478600001)(26005)(316002)(110136005)(356005)(7636003)(83380400001)(40480700001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:59:35.3749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bffec2-1b6a-4c26-399a-08daf48c17a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5765
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

