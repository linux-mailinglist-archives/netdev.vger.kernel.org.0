Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFF068B0BD
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBEPup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBEPuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:50:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006C91F494
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 07:50:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7Cs049tP4au8mUQG2C+3dTY4IUC6yjtRtMrQ1+5UiVQpyAMPWUGXGbMuLnzSpQct/Y/BSrlyf2ToI9zaxSIj+WVGo1yjHgci8+gTFXdbGX3ef8xh63hwEvdpOFZ4i774DtqB4twTGfevi4m3GAUYZGzY9xyB0fxV3ytZtYNUj6zZ/vISpn0fdZvsJqE/4TsMW5TfITVK1ukgEJ9cY/IXUrwuWQ3zCBhJSzwmIGsa/IIu0Ul0Lv6rN0ML8ZcB7mlEG0qVeXNx5yLl8fiEq/fTyV9VB0L3sjeq0bL0BfOBBZzDhWJgH8zjtmDxjOvA81sYL+DXc1ZreXScZdqGSPlDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=hqvmMnY0S4THtfpQFXWWSYUvxCtn6AtBhatY5g57Ox70xjLoLOz6ClFlnyOg5qYsbjGk6cO5UxwC3lXpf+jc8FUEqkP9TPaPPoow27w472k+uyEb+WYPu63ytGk/pdXHyb9tzjiYR9R4CJxoY89FEzqOU39wiY5mq8wHMFhkGHGc6YXoRPrgryn6+VMk/FS2eaX0Pw/hwLB+ZDHKj7S2mrwk8XUPZbc6ARUs2E6scu2d7hkVn+8eCk4pwL+3f/Fti0FCsaWFd4k3ktBurud4mK0VoG+Tb6lpnEXOMO8Zc0lrfy1aPqAqKcfaLdaTfhbwAKjV/D1gZyzcIxxOQr5lbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=AsOJHt6yRCB3cLiQyKW4pf4ExEFU7BMtGQpcEh1YVF531HH2xnVoJua/JiVwIGlGOTJudBgWrGfedieXgaYsfR7CwF3HsXFLDEBILCLYEDEPZZwOCsIrBTJSf6qr+JA07zViPiad2vspLVIc0Aug5Omi5XjKunN76FW4yrLyRfTVj6Fwv01c4/liQAO4dm60067AeSo2wIw5SjFXN4+Hv3LLCQui3zRttubSr6cUDjUYqezPs3WigE9FdhJpvZZyqHW2mIt6ap2J5KZEmFb2w0N4QgwrXlBfMur6jR7vw4EL+HrG3/ZL9Yd2/AnfE1yJdsoGxHxuFp8UEEQnh4Sn+g==
Received: from BN0PR04CA0111.namprd04.prod.outlook.com (2603:10b6:408:ec::26)
 by DS0PR12MB7779.namprd12.prod.outlook.com (2603:10b6:8:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 15:49:55 +0000
Received: from BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::8f) by BN0PR04CA0111.outlook.office365.com
 (2603:10b6:408:ec::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32 via Frontend
 Transport; Sun, 5 Feb 2023 15:49:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT099.mail.protection.outlook.com (10.13.177.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Sun, 5 Feb 2023 15:49:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 07:49:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 5 Feb 2023 07:49:48 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 5 Feb 2023 07:49:44 -0800
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
Subject: [PATCH net-next v8 2/7] net/sched: flower: Move filter handle initialization earlier
Date:   Sun, 5 Feb 2023 17:49:29 +0200
Message-ID: <20230205154934.22040-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205154934.22040-1-paulb@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT099:EE_|DS0PR12MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: badf97ce-ab67-494c-9daa-08db0790a067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XzVRxSLO5e3/HD/AZO9+FQQzLle8gcRqbc1ehFneii8tAJUsYC+H4qk739O+ZQNF5MvinVygDotOOltfJ130ND/EhLaMxd2GQs9J3tvMOT1DU1BalWDmGHKPelq/n/eAdK81wNq5gw0Ag41otZmtd1UkoNr5hAGb8AXAI69DX0At8SGZH0A5FEMtb4hbm9LPYBkbhsum1O3TJqVNagLFG/fj5GSzpUgLvZiX23abAXC/6B5BvrdrHHCBrNbzAQWXZR9HE454VRhTUDgb1+icz2lNLXdilpcPV+XsXv1CaC08ZJT5WmLGHeFbhHcfi5jGriTdfCUcTd6KgyvJ/nMUg+HmokBHQ3isg/YHUbk2DzAdlExFp1Wk0qzvJeNqKwzWYpYEZ+hvqexk5R2vBBEqeNgUIyAzegSKqy6Hi5DdWGJH3NuOyGY0mLTaipcTq7SlRkyEFQ83v8Lf2mNk5zoKbcFek3x6S3wUVgWiWN1WKF0/4BzRbiGDwd4VnWilcm8P2bAPyXEs8ecW5dbYLRS1gtLN7Lsh+ZR18uNZLmhQTkLTop6W3PJ1EpOS3s5cdvAY7A4dOrfVagwegXnjIN/aXHCGkXJaqK1I1wenEwLhf9mhRoLyU/TURq5ZEDSsHmSv8Q8N5Z1KnjCUiUP5TuUzM+B+bGeYE2tREptnF4AtNjtG3lwv+bcCvmhQXJt2qKbyHo/tvtpmE2KVFwKIxv3+A==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(82310400005)(40460700003)(40480700001)(6666004)(1076003)(478600001)(2616005)(26005)(186003)(4326008)(8676002)(70586007)(70206006)(316002)(110136005)(7636003)(54906003)(82740400003)(36756003)(86362001)(356005)(47076005)(426003)(83380400001)(336012)(36860700001)(5660300002)(41300700001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 15:49:54.9012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: badf97ce-ab67-494c-9daa-08db0790a067
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7779
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

