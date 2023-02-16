Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04A4698F2B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBPI6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBPI6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:58:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8441096
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:58:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2Xjl+Mj0mvL3vYCzdTPPwWSJhFVNBU60A4QQ9sEjY/HWG6rj8gt7OvA7LOXowa+HXUuByy4NZhVKsKpE69dGMnFRp7+AY3P2pN3njkRBs3bhOhkgQf/pEOR+YrNun67H4UH4hF3O2YDZjGKLJPt3zhdW0ZVsyUEav0dZmjeziEVW6YAeDZ0XPQiOlMlkJT+H9O8w1zbcYJJ+HmNlkdRmwSbGFYRLxYbctN+caos8CScK4hIHwW8jsmH2A7/n0WRVoN723IPSAzZg1DQcAhg9pbUmZavo7inHgxqLZMAYn/6LPbUVT9lMf9BytGfCMrESsUT3uu+DveNLMX2w4ukuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmP2EyeAu1+YUmH1maRZuYA4RaV0Dqpvh4+zpES8ORI=;
 b=Jr0WAsF2ESsxHGFUj+vHRwO6/tDfyQmE6axhM/javcroOJXeoAixx6ILlXpkfQl1wH9aGmKSmgX1RFsHfQONtZsXLcj6W6TDVhJqm+whzE80+Rv7KV5nP5YL2x+WCn3YOF7hpAZLCy8ncW96iFQpAsvCIFrpgudE3P24N6mtOKFnT2w/mvPPH9wVlTyO7zvC1XhT6y5jNvlfjJvfIHs80SYS9UcL23cCKdFGtdaBuURm+2K9ruU7R5Se+AcuwfB01tkv0BF3+qClTJPW3p21qbYJPnR4nTOTTezl+a4OiVYJKrQqO3CdO8IdTlOdDp/5ag8XNRKCJf+6+xICxNpg7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmP2EyeAu1+YUmH1maRZuYA4RaV0Dqpvh4+zpES8ORI=;
 b=Hhx9l53baQGFXj0LIiDyGMG0I5DJTv8J/WGmRyViIh/zf9gOua16SbBoosOZi+fdOenWrFT6OFU4B5y113SdCI018C2Qea4CBY0p3Gk1yD9/qh3e+pPHcHfIUERFqKiYCP2aiVxC0jfa5m0/YRJWBtyZmsFG16ETCbMhfy8F227rWEBJXqFaVkEOx8G9Hx/bCMDrCyOcME2ygvYeuJqtS/cxePANBTpcU/Cfs7zvPweKQ0e3La542I/OqXHIimi1t1QG/ucZshxVWjVF48tNGYD+qR95Wzw6VVbQYlCwgAhlPSULS2Omg0odcViw01P/Bf5KDs97BHAw/9T+TK/siQ==
Received: from DS7PR03CA0162.namprd03.prod.outlook.com (2603:10b6:5:3b2::17)
 by CH3PR12MB8709.namprd12.prod.outlook.com (2603:10b6:610:17c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 08:58:25 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::2d) by DS7PR03CA0162.outlook.office365.com
 (2603:10b6:5:3b2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 08:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 08:58:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:18 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:17 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 16 Feb 2023 00:58:13 -0800
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
Subject: [PATCH net-next v12 4/8] net/sched: flower: Support hardware miss to tc action
Date:   Thu, 16 Feb 2023 10:57:49 +0200
Message-ID: <20230216085753.2177-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230216085753.2177-1-paulb@nvidia.com>
References: <20230216085753.2177-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|CH3PR12MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: 098b92d4-2845-41a3-a0eb-08db0ffbf6ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cu5lA0a6lQZheuujDpsDtepDzla98zNqPXLn/ZzUrBMyXO5VTbFi6/bFUgrMzwMzOAFJ/T4UP0g3Plc86vX6nYN3vPv8Kd2hKWPiR/ADq+Mp14jNeW0afgqN+PyH8bliwLJ0JymY2EiWaPgpiNZbgYdksh8tqTmHaYXlg4XAc8/t4vbNnrEPyjdpG9JBRAtGC4YNbd2KeSVoymQ7djGI6HFSaPfr6otZ6iBX43oQj97gk4yQHXmmTACmS0Z4ashInLuV+NWmv2MvW/ZX4DsO/iXpK83AycNq6cc3b5lwOwgItey/nTSJUSL9RcClJJ2XodeQLkQNqBMwLDGDCbS4YgZ0zhsYxTLdeb/m+jw2pRwA+L+XheV13zhGz9p1cQ6zmR44Vh1SlH4o4etDmakqDsCsw6HlISexJmo3k0zKZ8mio8lKnAuJUGZ36lCzTgj6TV48lk9SJM+4BmJOO+24OS2aT+mIfUBkFqxiH+Yq5KYgnSPiKNiPxnCC0YteK5ApApQ1X/w58s1KnHUignWSOlfHzCIKL4uarvzGG0VonaMa8kaciU0DV7h4AKOetLQPSaDg5UHnArMYrj3qtmsCujoXOqd97dpunkGmlLJ1INApeIFdY89BBk+pUwldIGvch7WHZuENdc37384Zuw2DtFofQvJMPPi3S5larR+XtJQi/CwgBwh8Guk9imDLGBhr2f3W69utRM2vXzS+ibA0Xh1FoGTCJK29R13xKZLMS7s=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(83380400001)(8936002)(86362001)(40480700001)(4326008)(8676002)(41300700001)(921005)(356005)(5660300002)(40460700003)(36860700001)(54906003)(316002)(110136005)(36756003)(70586007)(70206006)(7636003)(82740400003)(6666004)(186003)(26005)(1076003)(478600001)(82310400005)(47076005)(426003)(336012)(2906002)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:58:25.5430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 098b92d4-2845-41a3-a0eb-08db0ffbf6ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8709
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support hardware miss to tc action in actions on the flower
classifier, implement the required getting of filter actions,
and setup filter exts (actions) miss by giving it the filter's
handle and actions.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_flower.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index be01d39dd7b9..e960a46b0520 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -529,6 +529,15 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
 	return f;
 }
 
+static struct tcf_exts *fl_get_exts(const struct tcf_proto *tp, u32 handle)
+{
+	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
+	struct cls_fl_filter *f;
+
+	f = idr_find(&head->handle_idr, handle);
+	return f ? &f->exts : NULL;
+}
+
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       bool *last, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
@@ -2222,7 +2231,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3444,6 +3454,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

