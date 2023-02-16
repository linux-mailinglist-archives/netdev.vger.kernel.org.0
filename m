Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD17698F2A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjBPI6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjBPI6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:58:31 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A5D4C17
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:58:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OuZl+9C6DBfKRBPl4MSeTKlzyuWXvtERbzgzV6hSPamX4CDe7XfGmV+HVg86RkhTEZetX3VZTI7EBIjW02gaAWt7penp6MXRd02Y8tfLHVs6Osx78Ry3rqIzvThD9QOi+I0vtAC6bdo4KUvdw7yEuX6y3wOQlEfY5gJe9o17iPnfUytBSTXMAbtR7KeZpSLnc0iLrFGIqnToaNy4S5MXnTgFgJqgCgrY2QWZt+HFp9Y4eC6/ZXSCdeygmRTMzoO8pHKSKYkq5v5yKQzRwfEg8kjvbtGwiQ3hQ0kjdT1wMMn0BroVbDFlV4nRSxttKWFTNYD5xfVbURhsPOoD827Awg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xNy9v9KFWqN9Pc4lpCxrHmKtpQAlNLYE48Cq3T4vZIU=;
 b=N1sg6INgjovOjYy0L8QkPe3wS/311T7lTG5u98JUoPcPrfVwZKH53hxjnyQnUsMJ/FXPMwh7yOl/g70dxXaUnsxBV9xOEfzMdnf81VT9rQeiii6/FJ3c7etzXaQIPESn6x207A7eRWJuw8O0oOT4tjjHKTUBzOnpfmeqhJesVLPLK5ftmsYAy1EBo65DanLkltnqSg8f2xsU4VBf5Kki97/HyxJ29iByu9yqL2sxetLl71CE++8C2oHmM6LBnsh9dV7mqdYi0JPrz8umm1l3AGbCsIXVLMgyp0o7NIqwY6KNL1ziuzqpFPThdPDNtz/f/opLtA6S2DLYKvBzfeiMqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNy9v9KFWqN9Pc4lpCxrHmKtpQAlNLYE48Cq3T4vZIU=;
 b=B9Ct7gdU3vZ2aIoXxPpAwKjwNcICDr9AAYVU63sm+uQXNz2M62CD3+SXFTPZPo3y5vfK8sYccB2vEOyMmWScm89s5DDtgdUHmvYRWT0M8hLlXOp6gZzq8axd84MP/7bytuGeApn7twZI97UZPCI342LmsMHych/XKj9h9T0dUyMjIlvmGqd934uY2vr8dSe1xUh4KA7xHKFRseOoFpXwGb9oVHt4dQVG9OheOpGvmTbANPYpdEDvCxOAJT6Of9l1Xettcy0XgF9L9DMeEydcL8nKVe2d2Lu57jfRLmMOWwgF3qyjPdtmY6NEK4v4QaeagwFGWCJEugzOLfmrBtMFVQ==
Received: from BN9P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::12)
 by DM4PR12MB6494.namprd12.prod.outlook.com (2603:10b6:8:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 08:58:26 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::23) by BN9P223CA0007.outlook.office365.com
 (2603:10b6:408:10b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 08:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 08:58:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:13 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:13 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 16 Feb 2023 00:58:09 -0800
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
Subject: [PATCH net-next v12 3/8] net/sched: flower: Move filter handle initialization earlier
Date:   Thu, 16 Feb 2023 10:57:48 +0200
Message-ID: <20230216085753.2177-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230216085753.2177-1-paulb@nvidia.com>
References: <20230216085753.2177-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|DM4PR12MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f1d76a-fd55-4a8b-c188-08db0ffbf70b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNiy0msfLnoagSGvIhqoJrpAvfaS6MJwPIbF6ToPkq42ynJ83kSqtTMJYHR7a3sSkhggd02BG8yJ38BFtBdDI2LLCav1srE+SnvLaIF+az8B1oBbQCzSlvVHOc4SgQ36bohCROwKAGf3W7V59BdFPz12jEtLGMSQnf243gquERVntPdUOlZdfkGHUY23aESWf0E+pbaRm837PYLQx9hMBUFsUNUMNCP3ofdeHRnLTCNkJEUb+BAeZC8p49kQEe0ChhGDpcoBxHT2EY+x7v+vCg0RoXheC2MYhGJtY5kX2BWKhjWw3265bY21JUvRLABtDI+qaQiEH1jfjF1EKh0maYUPlEpQgNFDKEKPRSP78SbQDaRpBbvHODadJs+aqFqYaXGVTDLfRBu09VPanWceAJS6qp6kzstC6F5P0rNxTHz6whaLAArD3B/k54hOhcLOpHadItNptE0jKm3BvWZEHtwq3UYRKqg8IYSIcadKrqUo6y04r3DyKRZknBw59Tvyz59WGFLLNLcmx2wSouTIInubMDwt5k8MkzZCxtsArQNxzb4/gyXXNkyE43W1rWP1a8aTsrUXPvqMAa6MRsHIMQmnzgeyv/Ivbrf95sNpIsrQQnzpZYBbVu2jHUrx0/KxDH0XOsYR42Y8VoCLL7gyJqAQezDfEnGRqrbeZALZQB8T4NthLaqpcPWvsry3auVab1O1BO/X2tb2BorOOaqOW4K9tGKVPiFkKF7YrJyQsS0=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199018)(40470700004)(36840700001)(46966006)(36860700001)(83380400001)(426003)(336012)(40480700001)(86362001)(82310400005)(36756003)(82740400003)(2616005)(54906003)(7636003)(5660300002)(110136005)(47076005)(40460700003)(921005)(2906002)(70586007)(186003)(478600001)(356005)(6666004)(4326008)(316002)(8676002)(26005)(70206006)(1076003)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:58:25.6976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f1d76a-fd55-4a8b-c188-08db0ffbf70b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6494
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

