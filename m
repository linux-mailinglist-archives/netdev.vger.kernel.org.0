Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F4667339A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 09:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjASIYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 03:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjASIYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 03:24:30 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6E05AB53
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 00:24:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAN5pBFK48PaJ1FhrW8neZddzQjwgm/jMIaQPvBSqKXfPHf7JUWEPauGBjwTLp7p02EvYJTvx9MSF5hA7/G0gSNOY8yTVO8KPc6IbY/diIsVTDAliKSXjRST1vAP5qSKKJnY7ek/sA/Yqll0F3LJjoyvJZYhIUkofrKzifkO5Fgv+O8tMcVPlDy9xDPF5SnVT0/7Dx7+5YTIAyYJrcECE2OGwJbXEmVt5EJGAiEWTP6eF/RYmH807QpRyTellBBsXiCEUK51FvxdZ7Ma0ugT+93t/4xcApXQpZwdCc1wb++58bZbakAEoodWF+pQ88xUhvZX8i9mN1ybS2CDnAJlXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pYP36BjI8tuK/TptL4gjxbDQq9indNGBjpoZwBV1lA=;
 b=VE+4Q0ccv5KqBLixGlDfSwq48XROrNxF7jnitpDsRafI/ep3GPtDeFtaWp9RxErV6sHXoSyN3twUlQHwVNbGyDqAvtVNfr/1wdkWnvv+vwdj4boYaZMEMRPC14xqeH/odWnLlsBntbqodFmH4bEiw24VRzBMa2UV/LnQPPOlJxPrNKQyOzWX7i920QCWka/N9HHKnuIqno4KzpOvBpdyCYTTNXCRSJef5Ou8id4F/R2RF/erOKf0f1PgeYX4gk5KDhdYfkSX0BGeNtYbJhk7xqcZQKKDho+/IeKXrzRVWzNiF/SOXS8UJRzkNGkO7wCeg2ebTS0QEmbJPR1gtVwS7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pYP36BjI8tuK/TptL4gjxbDQq9indNGBjpoZwBV1lA=;
 b=k3ym/rcnV8LHhM+UY4nMGw5jtYJ2R1hNtBgyNLG1fWr97uNcTOSRSi5kf4dYPg1i1Nr/8+lITI1rmkJGDQ9L7ynlTOCEJuYjd0LYCeNBJ+AUh8gMNqFJQIG+F5RspV0VFsqmPyzbrLcNrpO1p9ULigQ9UQbxZcXD33lU7i7QrMG0ldaopdmJXB5TrRYCPI5ziMdC8ShKmQxCxyD+EMe8tnIZXdMjWwkC5hsOkL80c88qfE/pczOw3RAZPedwPs8UObKYsbPqcwvY8/3vpCjJmp4I9Jno/Qxv1l7P4AW2l2VcuqUFNa+bYdNegDJF9CRu/nIibhf1F+Lt09YD4G3xjg==
Received: from MW4P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::11)
 by PH7PR12MB5783.namprd12.prod.outlook.com (2603:10b6:510:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 08:24:25 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::85) by MW4P222CA0006.outlook.office365.com
 (2603:10b6:303:114::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24 via Frontend
 Transport; Thu, 19 Jan 2023 08:24:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 08:24:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 00:24:18 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 00:24:17 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Thu, 19 Jan 2023 00:24:14 -0800
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
Subject: [PATCH net-next v3 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Thu, 19 Jan 2023 10:23:54 +0200
Message-ID: <20230119082357.21744-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230119082357.21744-1-paulb@nvidia.com>
References: <20230119082357.21744-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT020:EE_|PH7PR12MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: 389d34cf-ceda-41b0-cf35-08daf9f69375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUkWFrVBevcbJwxyrTk1/xTNGokY8c5f+91qAkYojtPmCsQsx0zIwJ/EtOTUo+8SDViRzHntnahAtAYEZ5Eu/RZjRyMhHr6tkkZj+mff0GAn2CeEDt3oTx4VaeqX4tom2Q8VM43lIJE6R1tFmNxcUfqRzfWwIVii+gA1wo39sNGBm8yyWTRGUgvXN6sgDViQj53rsOiqywtXuDDDZewCbx+LLKn971qE6qX1kK6QipELhaFq+J8M2UUk9zOMeRD4AX/l4oB0YWqLtaHHyvZpJD+YRRq5dIFon/zQwDKA3lbolR9vvwiUjCGpeO2bQ4X6QIF7FVL+TwdjoNRaDYoDPGDQEdOUl9ffQuOycprA01IlVLN5BXSSeaMaTiusinjS60Qr+O/hnrAJloJR35eBYg8ILD9htAcBjrTZ6oby/U4cpVe95tVVkx5yGUwrlaBHA3gWSoaqL1SdiwdWstKsP/6s2Mx1dwIaDNmggT1EGbcMrM4HgsedXev5mZycVA8MvSCxVdrKZeRivqm8ayWWV8JKgAxDBiLSNBT4Sy1q3FLWO7EeJmIZx/bGH3+PhOk00INVYrURbYI/ZSCUQ4gLscs989+aSf5zoOQAHIHfD6t0rl1IE0nMYRk+S3vA28JptYTEDrJ7Yd2wm8LOHKAxnTuRSHXUQ2SU2m994WmF/6nOu4okUZR/h6QAm80PF5oPta3eczwJygWDupBWSRC6uQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(107886003)(70206006)(26005)(186003)(70586007)(6666004)(478600001)(8936002)(426003)(47076005)(5660300002)(41300700001)(36860700001)(4326008)(83380400001)(82740400003)(8676002)(2906002)(36756003)(7636003)(336012)(2616005)(82310400005)(40480700001)(1076003)(316002)(110136005)(54906003)(356005)(86362001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 08:24:25.6651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 389d34cf-ceda-41b0-cf35-08daf9f69375
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5783
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
---
 net/sched/cls_flower.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 564b862870c71..5da7f6d02e5d0 100644
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

