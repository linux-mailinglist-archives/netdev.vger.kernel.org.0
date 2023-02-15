Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9542669871B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjBOVLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBOVKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:10:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D5E9767
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:10:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHs5k99BsfnlMZFzxvuGBdHSBEqTPyZz3FM5P7IT5dPEx+6nGHNRdmTDJyRPJEkSbpegKNepy42kS2eArKMxmKaqzMyr0XKnRGlnulzv41Oxg3CTiJ3YVrvSMCpstVa8LiDNB+hCT5qIIjhRCW8H78m+wzSAy5nyfhp3QWO302L1cvxvO/qy+jvkgkrspQh6JMrmaIwPPJXEipmov/D2brp7GYdnjIZ8XuCk0hnHldnO/x00fbNGT1GvaDUTwLo7LxShr1Oxo25Ceezroo87WEnmVWlFDRycbJmRpVftvRttAICC2g829Aav4ThVGZltoM2Qq3+zC+ap/hUBQnO7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xNy9v9KFWqN9Pc4lpCxrHmKtpQAlNLYE48Cq3T4vZIU=;
 b=DUoWWdgceAhJURP88GkGYzj8oeEQqClshXQf2lZAMSC9jA3aS/dyhbE2KIPFpHfIKO6dl8/2CI+fTG+tqiqgBMZeNofdmpHgkkV3hr56dF+3m1XvBxjT+oBYg26Ss1QW+8nxnHJkcDyrEwz6RJk7JVUgXsE8L5ttm+zX8iT0rNgMtk95jBxYQ73fkSgOzUIH+xcDfn6BQp3D/Gbd1FzpPENjDZMy8J172K3Ap7Q7KxcOa9iObO9bjoVRk80Pont0DNvPpVLK3yf5vyqWDzYZNhJnCqqdcyLcs+5+ZwMVQ9lKhPKyM8GPgktszrbAa6jQe501dmpfQgVg+8IldwP5zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNy9v9KFWqN9Pc4lpCxrHmKtpQAlNLYE48Cq3T4vZIU=;
 b=O/0vM/llSmowYR6gl84F1ZqLe5itZs0cRVMPyDadDxoQNB95+l7yGRuiQUELwJMfS7VbTSyc8tVhepNhgz49Rk8VMZCyIudTuSefvDMC/kBqq3SmfNMu3ZvLEZHlbufC9lILxkrgi8AskWmt0TORTBG/o8TYRD1/+/Lp7pRKZHnFWMPjmWjvwDurX9S52H1uRUaPVlobVtHNKgRNp17QGWEA2EddRS9M8eMFGojK3v/C7DUywNBTtnRbDoKDqrTS9unMzMLJw1wThWpbc0GqIB933waRhST/dc2Z1gD0qK6dX8hGFxDeWuALnxcvCG1gYdHiouoXauDhlMysElbPrw==
Received: from BN9PR03CA0105.namprd03.prod.outlook.com (2603:10b6:408:fd::20)
 by PH7PR12MB6955.namprd12.prod.outlook.com (2603:10b6:510:1b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 21:10:48 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::d9) by BN9PR03CA0105.outlook.office365.com
 (2603:10b6:408:fd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 21:10:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 21:10:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:33 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:32 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 15 Feb 2023 13:10:29 -0800
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
Subject: [PATCH net-next v12 3/8] net/sched: flower: Move filter handle initialization earlier
Date:   Wed, 15 Feb 2023 23:10:09 +0200
Message-ID: <20230215211014.6485-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230215211014.6485-1-paulb@nvidia.com>
References: <20230215211014.6485-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT030:EE_|PH7PR12MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f09737-f089-4500-b31e-08db0f991c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsINJqy7nPMIiwQt3gtrzNUYGjQ5gVfKrluU4uIdYNUfijam72RyKQpu3ZKx4z6pUqxYF7mMWrV0Wt+FN72DJaC39Ii7vj8LjoD+lttoAWrAEZBQ1OF33cBhm5EXEoClRzn/N1c4zei0TEDgaUsQC4A189eCdL4FNMqFAqjaH+P4qHwkW+I8r7L+C/LzKq2ZPL7CDYCycNSIH04B526mH7AZ8X8+jtNApxE78o13DBLVpjDoMFeZmgx3wtPhEMTzdtLNM6HJtlgOgxrkjYnlSOY3Eu54Q6uho4wZJAvmdsYlxmywXMIDwdjSr7O/t/HuI2rPSqPcvQwcgTACT31aoxmyMBHLFFjfcy3T5oPSar+x3Pbt8k4LiRyg1zpmLkVL9F7rEcEw1luJa2OL4dT2ZPwHGe0EVDgQW0Kwbkbg20+wveguFsQkO0Na1Jnu1qwoH23fjtyqEQwVjKYYpDcBnuGl08qWgmURlz+d/IoPLEkex3HcBDLRQ152XIV8A4Lu/fP4XXWJ/0/x3KiAnSsbgcEvWNzz8LBMz1g3bV+y5P0Jz0+oULEtGiVF7A82FT6CvV0EHauL3D4jqSlA6LDDsbg2Cq1LO8hoCxrlgM83YR7WNSeIOv0nG2nGatfdD3N4712inve/gEoRoNI/Mk5VOYI2ninEUz3MUHVrrzV5Ct3HNzmrSMM7mGMim5IXrIo1P41JK6IBvKNQ69iC9hu/CpKN+ztrO593CHVzjg64e0M=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(1076003)(186003)(5660300002)(26005)(41300700001)(6666004)(7636003)(40480700001)(356005)(921005)(86362001)(36860700001)(82740400003)(82310400005)(36756003)(2906002)(83380400001)(47076005)(336012)(426003)(316002)(8936002)(54906003)(478600001)(40460700003)(2616005)(4326008)(8676002)(70206006)(70586007)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 21:10:47.6860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f09737-f089-4500-b31e-08db0f991c1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6955
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

