Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0486694F06
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBMSQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBMSQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:16:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA9544A7
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:16:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1ycDcjeIgGYZAOeEPeYkvRtJPzaBUqEMS7KBm+XvRhyA9h9mGliFdlpF2F7TutP1wOt8nkF1Ky4VRY+kBFbE3kM27H2IIqyaK96hAAsCqldQ7dQrw7ygTRgscVrqxijwIF1xm/FK1V/XaS9XurcyBTrEPreGUIaD8xMgLnI6PtW3huIOqNevSxPZewyA2P8Q1qZzhtubxHYH87ZC3ykQ27KUHfAYIA/9BtlMWVkzUuprZDqLFnXxISjc3uRoRvh1tue4sUKqC6yEr6nzvInfWGbmycYfieYAeCG0bTCIdgCibJobSOTjqIChnXCKHy5Djx9d5AHN065kRthsfiEuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=J1oGXkCBPUJ8Kl2b+5/4fi9mgPQFjLGBog5OqjGd0C7baoLaiY3YPZofqqLfZIYW9FFHHNYE+uSY9c32wyy/CLHUNRFXoBEwIUKsOm7y5Yr6sh4eN7r0IqHE5iq9gFJaIoj9KZuR9PIrAVLMHpSzjnm40CTYRX3jyuH2AWgK7jLAIjTzDyyWtSj1D7M68+KUauwgcru+TJ/DHUEIjN+YsSx8fgf4UNwO1dbLObPJwVifOMOuUHE81ne862ZuqRNk71e+VtiYUeaEp0C/yDqf4Bs6QChoZ/2/V0yNOqoFEA7IAtcWhed7SKmgn+HU5ANF9SZjFWwxCqcgZPm4QUw5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=fUGM2x9nVBEWNkiKae5HYQlnJN3EjuPz3EQK5PsM8MErvQWH4EzUrRHdaNmbwdHgwtsmr9wWoOyHE5/1qWFDpL1ybqHWXbkF1fhVmNi0W23gPSd73ftq7m/Zf0Y0d7sZhKJgZoBb1OQZMLDHIZgtrRS0godiSXFxTFWKCo+vg5CJCuLDDP53wFaARy5GJxc2m5BUnsQ0lhqGtY52eSh2C0M0fu5dINkws5fk+ET7ClhuZDYG89Z3trZqY2qrcKscE7nRLAOL6ekbXWcRVSZzUG7g7KjZCQFkkl77DyWpmmITwqxsQQjTYxMLkQFiP87ZfZoEwf8ST0NDUnonXpiqtw==
Received: from DM6PR03CA0097.namprd03.prod.outlook.com (2603:10b6:5:333::30)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:16:13 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::1a) by DM6PR03CA0097.outlook.office365.com
 (2603:10b6:5:333::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:16:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:16:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:01 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:00 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Mon, 13 Feb 2023 10:15:56 -0800
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
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v10 2/7] net/sched: flower: Move filter handle initialization earlier
Date:   Mon, 13 Feb 2023 20:15:36 +0200
Message-ID: <20230213181541.26114-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230213181541.26114-1-paulb@nvidia.com>
References: <20230213181541.26114-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: a689cf44-dd85-452d-0430-08db0dee63c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JhTNtyT2NyTOPKzd9XG/R+2uNbvOjM/QvMFADUj4mRcwm8jhYffzlmD8IQry0fbr+CIk21Y1tz0elqeOricbQuJwhyUdX0fV8TgKUsFoiqe7DV5Cq7ndg8rdXnxJBEJm7LuFbrXIRoLM4lkvAp+BXXVLaP9bhySKnlLN3RkC4qE9SHPRfF4eGpUsJ6V4sNXwTxCUsuwBvjr9pF1bonyXvcUFMIgXaoK5nVHuu5dKyJ3uxZhS9XMP35ZIW9agtAe2LqGM3e+GMSXYsBO9tsrxT7sGC0HzWKL4Un/I0xPw8e7i8M8Tr56q33MupYb0jrsFrDPyOlF02+xgEF8buQIz6lUJNb1gB3zoqpV8Uc/LXujZdJnpNSUFq3k8q5lciTmEXhBi+3w6EPlSVPpcXp0J33VJ6fuyUvId2kKuDMXJi0wc34I41KNEoqgI2Z9vpilAry5M+pWeMw253/2hgk1yHlPGlAdErxG4LtOsqjJL5MZ0fGUoEoyecI9mX5T2XZJItERtkgJw2fB/VCjWmLst1lHbEXMgpt/NPXFMYCoiplbOVl0il5m3ulbHmzQLgd1Nx2ko3aLPO1GeWr0yW5SSS0SUrBSFhW+xkIU8Ttq0KVx1yQwfwsvAF7Cofq9YN6uaZm7+hF/BBjBLY6ANa5Ceh57AkrIEP3sVUU0UZsJt0ydOexsGpE2oU/rp+eTsieLSd+/o+iMujgM9pKpXqSCzMA1WOsRk7UzNYW52/23ZgJ4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(8936002)(1076003)(36860700001)(4326008)(5660300002)(41300700001)(36756003)(70586007)(8676002)(70206006)(86362001)(40460700003)(356005)(40480700001)(921005)(478600001)(47076005)(2616005)(426003)(82740400003)(2906002)(7636003)(336012)(316002)(110136005)(6666004)(26005)(82310400005)(54906003)(83380400001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:16:12.8687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a689cf44-dd85-452d-0430-08db0dee63c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
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

