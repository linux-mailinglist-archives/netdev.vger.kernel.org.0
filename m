Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED56F68B0BE
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBEPuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBEPuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:50:52 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E601F497
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 07:50:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2h18WzL+b17LvCJDuFqXG5Ygm4lSBZPMSovDrScdLQtl2x76lMa37QlSYQEaYXM5lSL2w0YWNtF9gmESBM+pF/UGbt2DuuSopA+DArcY1GNhodKts+Fiy6ycAc6i4TZ+rcsIVX787r+9FTWnRALQT66FZgauQY5hkN1ADf+fMB35XUYpJukHu5Ea5BgtrLAQKVsaKMshRmOFMQ+FY16Nw9rDdTpGxfe4n+EYTy/qsQPQbaFdvgp5VYg9cf53PrNjeYh+Eypsa34AdTFLPUGOmIHWe/qKln1y/ar7vw1PfFFFFGl9OIT+nl7tFBVjoirSHBiFTiUHoCEXluTBb60jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=Ug9Bvgp7JKcUVkhUMzPkDyaaSTmKDmNkeN6GFKmCQPsTJ7fcZvHaoksopyUnSOZPerc1oV6K5QFxiO+DLW+gVVG1VCg5DOpNHnCXvOKTeotKD2qarktfomWQi0zChf9zEiaiqeQNWFi1cqPxwxhRvgvFVnu5L8GPGSGBae2KQg5j/vrlLO5bIGietGcLJVu0V2X1wqB9ySQaLM0qZl0BgUc3OM2OfJfbeuXFYjQvAiwmyjExAVm3F6E2st4NywP2fYovFjtesqie/kdI1RSjVU12EIioPigDOhKH7nQ+HpEk0lyO+4Ye9ymJuRctd+SjSbt8u5B5yBGnCC5M2Nl/ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=GKJesSLl0Vpen939BhY28p+tbOfRc2Q6sZTWaOfxSB1TV2rPJXzjAp0tnood/ADyCXvenGzqECS+CdhQGsqSj4O9GkMcpzvj7hgHDxXAFDqReWaNgIAO1szPzufauy4n+B71SrZ48p/q6TPVF18jj4ITfKgM+BNlodS+Vc/ixz5N3PvpOxOhpR0CHjp/dl3mT+sez+6Fi/bi8eXY840AvlPCePNN1OGs0dIeb7y4U36Wn3u4NhTUuc+b6e3an/R/uKGunxfgTq3AT95kmmzQl5SblSt7zejQU7INO8Il5bpfJBWquhHU1YoJevh5oRNXVE97yK49TJ8ue8ALVDpHzg==
Received: from BN9PR03CA0729.namprd03.prod.outlook.com (2603:10b6:408:110::14)
 by CH3PR12MB8402.namprd12.prod.outlook.com (2603:10b6:610:132::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Sun, 5 Feb
 2023 15:50:00 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::ea) by BN9PR03CA0729.outlook.office365.com
 (2603:10b6:408:110::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 15:49:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 15:49:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 07:49:52 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 5 Feb 2023 07:49:51 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 5 Feb 2023 07:49:48 -0800
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
Subject: [PATCH net-next v8 3/7] net/sched: flower: Support hardware miss to tc action
Date:   Sun, 5 Feb 2023 17:49:30 +0200
Message-ID: <20230205154934.22040-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205154934.22040-1-paulb@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT054:EE_|CH3PR12MB8402:EE_
X-MS-Office365-Filtering-Correlation-Id: a1de5732-47ee-4515-5874-08db0790a343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/KN77muRdMP9XAlYRWMj9eWSr7pdELmyDr7nvZN5ibw+jqfif/tSbFDfMGyh+a16gTzcx/U98PLyRlN3GuMNFg/mPLaeeu1RZkRPB5QtvbvEiH9rro8BfsulUK0nM2YZm80LGUAbytkgJmAbjiTlSajG6pwhz7ePV1WT+zkbF9NZK6SigSGgtju6tHjMq4ugjMf7KiZgxGduR8brnHAjnONtqLcGMx7Fia257F7pCpTJ9dzIpzMAnndtWgTaGV0g5xa36/ut4o0bD7bR0Vix3vb/TBPo4cYPn+b15gNFnxOgHb5Gzbm2rCYunbZ5WEqeql5v1rSaYl+oE1yfaUUZaQglfkeh10rIw2zY0f7GuJP1Eg8SQjf06tr9fL7W3RrszjoIzqFHqaIBWzuZcDjAFBjVASqXPpzJM/yx3wHck8owV6LTnrW+MDGf1I3Z8IZYRD1bjAmVb6675uPbA1gpknwbvVfDxOFYyXFZi/9kGstpS7vulVgOmqzHGQn3xSUXSZWwPeQQAIgndIszXdeM3x4l5oVPHzF3nsPFXRxZp6VdPqzs0+DXDX0M4vvaSj4Ei5EnFrLMI3sDeHgy5a9Mtd3S+yVVjLvwKP7vwQuqw+hlExX4A492NgyRWbTzJSZeed5PJBQ9tymgIUfFhZz5fP0dRMmI9IpRjYaoiSz0KjNwf+LZAtRyl8mM0wuDomFBbKceEw0vFBcYmGSQleEBg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199018)(40470700004)(36840700001)(46966006)(86362001)(36860700001)(82740400003)(356005)(36756003)(7636003)(54906003)(70586007)(8936002)(41300700001)(4326008)(5660300002)(316002)(8676002)(70206006)(82310400005)(110136005)(40480700001)(40460700003)(478600001)(2906002)(2616005)(83380400001)(336012)(426003)(47076005)(6666004)(186003)(26005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 15:49:59.6967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1de5732-47ee-4515-5874-08db0790a343
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8402
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

