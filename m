Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DF4676DD1
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjAVOzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjAVOzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:55:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02C01BAF7
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:55:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lm+mTHKukVzmLCBQstU5cV/eP1tDnYBc4+8nchU8pM1zqUx27EWf/2KdopUmZLCuJ16u643waRhT4sgiaLT1jWfj8JeMv+wOVJWHiQ3CxmV3pkEywzIDypkf+PiIN46TeMvO30pRoWwdX9FDEY2t02uJEU0nYKx5iDRksaurJeUNr0QroRYIgnrN7Dxve4FigkDXG4gsf8Z9S7F5+VMA6dQFq1/HsjoL+vbJdAKPPTRZZnugGmpxLPDV9vpd7tS9xatzKe+XFnSTJUf+oISeliUQNhBlAJLQNWCqCqZyof6iRKTwOLdOodRqoRat2BnvNWCG6OXkR7tNNfngqQConw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dekDPZk9FxgXf3YJSkVjUhM6H/42++P+Sk+buldWDpQ=;
 b=Dgf6WZAvdejfJjgA08kzKLzt0UmuwPN/vnZdbWdI7hivbHSa1f2BLrNQy9PEyIY4TGlk1e0DouZa9DvX/8zvRteMYgRwQYk5kJsMUqzXIY731SVqOrCBMg9ixgbA0gdRI4Zun7SdbYb2bFk61iAu8fnKe3FlPmnwZxCOZlNil2hyMQ5ijbkt6OSRijKQym1VnZx0+B6PAmKFrRjOd27cDXXdl4KuILVrmdtYZp/ae1vEAWw6TOfzjjoInJRsQpuBPbdNKeVyp0Hz/MdI+13/1IimGMygjbxWOiG0aNtpsriL2a9QKZwOLMU9etDfBY40n2rae615F3P22dyCWPz3Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dekDPZk9FxgXf3YJSkVjUhM6H/42++P+Sk+buldWDpQ=;
 b=p3/E8naNUUXPoWG8NaH8wFvGoJi78PdYrJt+XzFfN7CkXO4BpzwJN4lMXeOYbuuzRUNeAu89N/svf1SilCvzdhbIpQQTj91Pa0jv2zoJb/2mPtCjpMMjCRYFHzDow+FS9SLK1ZDRtnMXnMGMUErnT78SZmadeHjVTDO075FWLp0jBqoGaSHroUKqANE6T1llz0/PhJy5BYbYrerO6nqfBxGi4P1Mty3IHckuORhmNwI9z/j4ZQLMGbLQrX1UvE6f/gt6L87fYuU+JS2V+2GVwXfrRU25F5fJoyBkRFDMVupesyE8nYFJzz9jO9UjtInNpR0zlRv1O52vF9rkpfSaNQ==
Received: from MW4PR03CA0162.namprd03.prod.outlook.com (2603:10b6:303:8d::17)
 by PH7PR12MB7986.namprd12.prod.outlook.com (2603:10b6:510:27d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 14:55:35 +0000
Received: from CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::89) by MW4PR03CA0162.outlook.office365.com
 (2603:10b6:303:8d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Sun, 22 Jan 2023 14:55:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT108.mail.protection.outlook.com (10.13.175.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 14:55:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 06:55:33 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 06:55:33 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 22 Jan 2023 06:55:30 -0800
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
Subject: [PATCH net-next v4 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Sun, 22 Jan 2023 16:55:08 +0200
Message-ID: <20230122145512.8920-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230122145512.8920-1-paulb@nvidia.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT108:EE_|PH7PR12MB7986:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d846f2-34c9-4fc4-5cc7-08dafc88b753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0r+JQAesbBoTI9qlF5rNYI44x26ABS2EQRsWF5sAgbRLm7UeGsqXxCTcng8SWVyF5PvMMYH9pMrp3nQGH0bsKgFAnEIAHIneKMo8SK6OkYCpRHytd5KvdaiL9g6oI4XCZj4rJ44qRAVzsWsCyg6DHJJtfxtfbT7P7e2boVHzm9ogT8CAeURLVnzxW5Rd4YkAM7hdIl3u0r9A3ASPeYCDZ69oxddRqwDjsR/2cLrJZK++N/F/pW6brBzWq2g1kgdUqIm8FKg+t6qJQyOpH2dblxCxGD2dJfON9lgAQzs4l1CI+GvO4MDx2wfX+zQo04DFW8bHsJXdlVLQs9e+/zGL2Pv2acctGL8qgxHFDaNHsX+6Z1GfOpdgqRZrGcD41TNw7KXAOP0Y+mjDOmTn+7ZwY8xlHSeGOnSXdvxPo5L/9xZ0WPhijFShzoZYEoZfaOXQpfIvPUlDfvkzZahFYGruhFlvmY9vUSo9W5LtkHbqetecJhcDUZwCEHiEDRRXzhHAqkU4u9g3IK2v/1DsXpFcbSPLJhXxrsmBvwLt90exFQ1f9HKe0etKNXLjrZ+GClGxjNklH6AkkQYZ334bbVNDItVW6g8LbTB0SMBdWRBjdzuKbt7Hv9wd/aAB3F5/kfADk6ymKnBybQRoZHtmszaBhmOCal66DgWCNhckoui9dxFxo7aJl0wfimHFaCo6PWIf6JCrMF8USv3c1ZNXe5diQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(478600001)(54906003)(107886003)(1076003)(83380400001)(6666004)(82740400003)(41300700001)(7636003)(2616005)(356005)(316002)(110136005)(36756003)(8676002)(86362001)(40460700003)(4326008)(426003)(5660300002)(36860700001)(2906002)(186003)(40480700001)(47076005)(26005)(336012)(70206006)(70586007)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 14:55:34.6854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d846f2-34c9-4fc4-5cc7-08dafc88b753
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7986
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 0b15698b3531d..564b862870c71 100644
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

