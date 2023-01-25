Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B9667B5FF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbjAYPcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbjAYPct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:32:49 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F1F2B29A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:32:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETevywkw1X9I1h4Y05ZAsjZUvadOVQShYC8JsFP3Z7MkbzYdLUGpTM4dEeNeA3Tcr8C12OE6rOz5SI7yBmE84hLvPBD+q0IJswkOkgHTW+jUzJRZP2G2BeKPJKR8Uh9k2Jl7OH9ZFRghYNlBTzMu+9BCXUHL16KAYUoZJWz1uGm1IRU4mw5PUHHMweGM/AxeC5oug7vWZzxBHrYjzKengT037aFt3jZ4BlU69ZVp3LX5OU5V9rpyaeYj0lecxbE8uAOWxW8kFjjXp2Hq/SoS/hQf1eohxG09TYOsPR/kEuX464Wyuguc6sf4/DsZ+ZAIzmvg3j0foJsVviBn40y3qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmYLNu9HjbbY71BrickyyVbrpZFTXvxVPzqyU6pgiOU=;
 b=kl2yryCRW98ajfs18vjfBGi+TruoeyDfP6roknmeIL+5oY+PQI2jNSyiTx8GQnzmcyhViV+fEGXXgKV9goOp9atfhrzvd0QpWvdvcLYLVURVOMS9YfPZiNoI/mYFKiMnP3Dtq27XaRMWxuhAMzB+vvPRu9nNIH5FORZee68wCOwfLFmVb4P2EClxkqMkOGMmqNidfWfEfIKtv2VId5jRsjWv3GstbfJ2W4uNJT2l0VtPBv7+S54yxCmbf9PbM17OKp4vL6k1Y2yfxM6Hf5PP5Sj2HSpsqS0B+vK8MakmGnSnORVwM3NpuADQcRo1OxLvhBrsObyx4od20QjXljeGog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmYLNu9HjbbY71BrickyyVbrpZFTXvxVPzqyU6pgiOU=;
 b=JW7A+weyjJ/G0r1JFNnAii09iW3bXWr1yswL9MNDlQQoZ42XODK7siutW7uvgMZAz9fZEu+TjWbrcbiQO6FZ0e+UN9Qgm1v5LPHtc/OW4X16CRn/02N66OvuhvT9fh5IunlsU4qweeBXRHL26agpx5mG4WAxgbvJA4mZq90jco1sgvmF1MYP2OYX8Qr8W8bG7YPq4YAq/h6RwienhTMAc8hebd3fJcmIGMXvnUpmXvsTgeP69Rlb1IEE7gWMHP77qoWPNTrytiVxUnJzZEiQw89YFffCuVUylUyMsoiI/igTZJ3pmH72stMnn6TNqWwmn1E+naou64M8vwnmu8gxwA==
Received: from BN8PR07CA0007.namprd07.prod.outlook.com (2603:10b6:408:ac::20)
 by SA3PR12MB7903.namprd12.prod.outlook.com (2603:10b6:806:307::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 15:32:45 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::60) by BN8PR07CA0007.outlook.office365.com
 (2603:10b6:408:ac::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Wed, 25 Jan 2023 15:32:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Wed, 25 Jan 2023 15:32:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 07:32:34 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 07:32:33 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 25 Jan 2023 07:32:30 -0800
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
Subject: [PATCH net-next v5 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Wed, 25 Jan 2023 17:32:14 +0200
Message-ID: <20230125153218.7230-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230125153218.7230-1-paulb@nvidia.com>
References: <20230125153218.7230-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT056:EE_|SA3PR12MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: baae11a6-a1b5-406e-a70e-08dafee96808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fnxEE3OUqd4Hv7SGA3oxHeu8i481iZ2rA3/i7t3q21amcUjKlIxGE0A76w2UcKmQcd4YqaAOHXsOf5/nXuRs5a4Bl9PI0gSCFIamo+8zsrKAE46UzHjglwkkRw248LUwhuW6tJAm662C4cFT3c//d/6iNGr23vCv32e+6xhUUJgWYzBZVXGhYd8Ye2Wn5m1BxammVXUvxecSpyMSUfl6JrVwI/agWLYE8sweTHH/pWoEoBexF3hk6j+X3fw5fn68L0D6RTARbESft4F+vYht5btnD9AKVHRajw9jHOyDuvUQXp1XTpy+4JumDJuQnjgEHKMNzQV9wIMhvbBCmHVruKavXjp0kK46xZUv6QqGuBfHjS6mygfxaVaS2JLN1f4wZqjEoZjhmj1k3QgRI8i1gO+Pv2ShxRwbXTh2xIjhnr4XXGcQnuB1bOly9DWLI+qIwIB2PIPRSwkd6gw6frlArPCJfLbXeVAdDvwaiPvVc43S3fuGprikfVEZ0LYeshFYsZ8VAAgh5cNvBvz/OU+gpuMdQfxxLUs2dWeCg6sJh3I123cg4Vd5uOJRA0onYHiZ8P9/z4PljObSmRz2/TMocPqlJqxAGNxXQs52BTDK8O7g+f8GnvsUt7lnnsMFKMA8R2XJ1NXo/KnskUIlWq6dX5kpYpY5I9yQiRvTMuNmjpAXlqPAb22cTrDO3Mzy6AtBs54V3hV0fEbpiVSB5zl5mA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(41300700001)(36756003)(2906002)(426003)(47076005)(110136005)(316002)(8936002)(336012)(86362001)(40460700003)(7636003)(36860700001)(40480700001)(8676002)(356005)(4326008)(70206006)(54906003)(70586007)(82740400003)(1076003)(107886003)(478600001)(6666004)(82310400005)(83380400001)(186003)(5660300002)(2616005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 15:32:45.0547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baae11a6-a1b5-406e-a70e-08dafee96808
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7903
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

