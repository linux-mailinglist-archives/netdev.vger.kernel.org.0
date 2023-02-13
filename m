Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCC0694F04
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBMSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBMSQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:16:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D06226B8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:16:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqcuk8f4FdXrN4yKnJnG/LXDwdaTuSSECgtx0FeLsPJHcYZp2JHzlJqWTEqn7WHb/BVFB58N3WORUaZqRlI0l52QojPJGEzPUlBpZ35LSxCUzKJZgSRWFnNHB2gbLtY2L4BtE9dGm1FLXejMcHXXUK0GSsZW3qi/0w2BHidAUXmySbI9n4IEjg6UNz1g1nledBZpTCalEOUjxnxMY0M9arNm6+ifLcVasa9of/DAa8kL5/s/gc35SEBo/Jnii6Y5staR4FUm7b5BrChu0FrU2wbr5CT5MX4wxa1dPeULr50Kl7PZVnIQzNVVY070aHuRTIvgnV7ZZBO/eADNYUv5aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=c7sZTjJHaeAXKf+MfIVS+aKAmVGoMh9Ct/uhGe++Mcmol1M8wUwccmYUf892you0E987Epb3rcBm5QKic8r4VUe/TVquSlAxuvvez+d3DOh+qKOSxvZv3r0ZJ/KLrSNVHGFZBjB/HpjYGXSq8ETpakoKuYxrb002+vV79IZDiTCePV/f0lla477QchL7lNqFVPRvBl2Tl+3R6KXYLyg5cTBZdBgQOsfp9aDt893SnwEUVwyCdJYfCryzgZol0OiY+hPDMeN+XNZJ80ok+Ag5FHAfYZhdlxy7E+wshgVh/4VXpvvP8+LLWTglZZWAWW5VlPxVzfNmoRFUxZ6kEQQ7vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=HlHtnWQ/YuyWPhFwO5or+phrt8vBNRQYGLqQ4aF5IKA4SWMKQl66fkWqp/TCdHhL7cg7oAaX6PZjFq6v4UpapZP2oyzmYphBzI5fdP9ZmC828p3P++CPYgPhmAV6uMhB8L8gu3Q6Xoi0XjCdjBWeOv6fSMZgWiew836BxonEHqs27DXkXe+92XvmjNKVYpy31rCEZ0O+ToaSkVPSmI5vL5Xc7Szt2ke2vyN8wGVMaARZCAqq71YYKY+Ge1YKkV1JJVnw+rkYbTYmkAf/0fHd816zjFDUQWruuWxYoSD2CRm3ceVjs024rRqD1BYCCZvalnBPB4SboKP6U0xhuXcZ9w==
Received: from DM6PR13CA0067.namprd13.prod.outlook.com (2603:10b6:5:134::44)
 by DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Mon, 13 Feb 2023 18:16:17 +0000
Received: from DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::78) by DM6PR13CA0067.outlook.office365.com
 (2603:10b6:5:134::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.9 via Frontend
 Transport; Mon, 13 Feb 2023 18:16:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT103.mail.protection.outlook.com (10.13.172.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:16:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:05 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:04 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Mon, 13 Feb 2023 10:16:01 -0800
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
Subject: [PATCH net-next v10 3/7] net/sched: flower: Support hardware miss to tc action
Date:   Mon, 13 Feb 2023 20:15:37 +0200
Message-ID: <20230213181541.26114-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230213181541.26114-1-paulb@nvidia.com>
References: <20230213181541.26114-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT103:EE_|DM4PR12MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e4acdd-e110-424c-467c-08db0dee6623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SMCgmKFVFr46+O1mkcgxX0zDt0jLCu8fKM7IdNMB+xs2nskW7fNh9I1CL9/3Q7o4t29W7NcOAcmFSd4YsduGUF+ATB201Kvb7IsAXe3PrxPslvxuByrb7xgGUVkENY4oMBYeKkglk4fZUaRK32UinAm25sBsm+CoD6PXBdQEnTLixHlkTwDP+Ba6i/FCfiZJd10wEZMMAHEo9J4r8S86E7zg23u2Ha+C9sA+VUgEmobP48wwurFjKXWGMh2KY3se3leNOVYDJ4V7e/yCSmu+2w/mGAIXrgaXH+SorYrfgzwNaleWHJa9ct2emYa0qBfA9EvNBzT5qEDRWjrBSOTdmfu4eETXLccMv5MAj7SvQMnyDt8aoSgNfVKVjNKMe7b8BIPPS08VGeIK2rjbfGxljKDoyszFhPqgWKqtRjOqbq/oDIfpSxhNfWwzbHrEcVo3hDxQmp/bQ3hx0HT6e6kOZkkZnJh7J4FkI7LJvfFMIpsh0uhKj1iQ49SjCep6vG+bTuQp3NntLWULcb80nYI0cg+ZwlTR66Kr1vwlek1gdMK67WPP1dJNzMSztqoeqD00whlvEEqeiXrPAL2RTIr/McasVOzo8N1xtmEqqR44qehjCVAKjM+DX9IRlLJ8ZtTWmt/v1q2YrjfAAPTlE1xX0zy4LzzHGyX4q+f+tDPhGpjzDF24xtmJZ9rBaKwvLu4Ozt+dormYSQx2ZkELTkYB1MhdgYG0R5k2rz80AN5H0M=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(4326008)(478600001)(83380400001)(40480700001)(336012)(36860700001)(47076005)(36756003)(426003)(86362001)(82310400005)(921005)(82740400003)(356005)(7636003)(6666004)(40460700003)(26005)(186003)(2616005)(1076003)(54906003)(316002)(70206006)(70586007)(8676002)(5660300002)(110136005)(41300700001)(2906002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:16:16.7991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e4acdd-e110-424c-467c-08db0dee6623
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5769
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
index 564b862870c7..5da7f6d02e5d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -534,6 +534,15 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
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
@@ -2227,7 +2236,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3449,6 +3459,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

