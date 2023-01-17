Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB566D849
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbjAQIe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbjAQIek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:34:40 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEB42BF15
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:34:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqSL9z6HO74wlKtIyyAT/dUu4M+SU7J0OMMhGgtiPq2hTHKxgbiQUmvAUr7BA5ZdYFtSOMmqlWv9EgW9bq/YhX1A9zK8hPeuS96SKfoKNDzwpbwiLn8SBMqnZ3qZFHI4VDZhY56Seyv4Iw66nWfLyAU2ycKmEO7g0wOMPum138GrYiI0D5/dZ8KuCTly1hNo7ZaKF+K9u+UUotYx7QaesmAo59XEmcDsr5GWb82/pMcaiaqvUKztg6Fylm1sCgrhkdWwc/UFbtPg2HqFnyaZ/2ZY/Mvh2dbA/t3N+9z6lYJVRl8g7GXYHWbRb+0y4XbXY87Vzj9WOCe/W6JIdUsMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yntnSlDeBZedWEfeAHF0iOvpxo1iH5hurKBUozia2qo=;
 b=UpvIv9eA6hK/UKbXeEDLtdXLE7zNNnFRBqZesQaWX4gIUoD6tkjBkk1c0+PfpEAeQGHGBwAiCS27WcwFl2m0hGzwRlfLBAfMmasz8Tw0tBk80fiqFYZn4K67UoP+AJequG2imbz7R/69QnmFu1rpZuRlERXmhzkXfA50L8eZ9WobBvNFNy8NBj31qKIdOGpgtAzofDe7gBozm0MnYE1H8mUEW7RRAVQNQGuXMb58L9NVr9Z591q2jpYPYNH9ammLkbiWCN/Er3iBIa9uSUD4UXH1SrIaZMvPlVBpqxJ7x/0oPIwl0m5weFLuZgaVvMzF7EZkPh/7d+o009YkYlIOcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yntnSlDeBZedWEfeAHF0iOvpxo1iH5hurKBUozia2qo=;
 b=pnQ8y9cCLHAW21iyTb3v624vu/mcnZskDSZolLjH4/5kfWyKCJ1alzVseDNA6TFfIlIZfNvgHa34d5DhKlcvTnAZtQD6p32TKTr5pDpdKyR0jk6d75tZbWzwpPott9KLMS3yQ1S4ZgVsxJOyVM2X83YanhhXII8J/7/hrvQXlfIQPaY65mM9MTiTDoojVs4vw/sQFFTtM8Q//9El60HLFsWsh1WOv6uxgeFi+1MOj0iBUTUZkHYIRh0R6plsAacAsfvpTfAv2ugU1YP9hyKzw+h/exiQWcU+rBNwm2cQJRJw++srV8k0G5j8GdlpPzZAcUY64SbKBOaVMJ7NBQbs/Q==
Received: from MW4PR04CA0051.namprd04.prod.outlook.com (2603:10b6:303:6a::26)
 by DM6PR12MB4075.namprd12.prod.outlook.com (2603:10b6:5:21d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 08:34:13 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::44) by MW4PR04CA0051.outlook.office365.com
 (2603:10b6:303:6a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 08:34:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 08:34:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 00:34:01 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 17 Jan 2023 00:34:00 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Tue, 17 Jan 2023 00:33:57 -0800
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
Subject: [PATCH net-next v2 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Tue, 17 Jan 2023 10:33:41 +0200
Message-ID: <20230117083344.4056-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230117083344.4056-1-paulb@nvidia.com>
References: <20230117083344.4056-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT019:EE_|DM6PR12MB4075:EE_
X-MS-Office365-Filtering-Correlation-Id: 792ac4d5-0a11-4594-5874-08daf8659cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uotu+ENK4P5zOwk7bg7s1x7X2I0vBu9f9pO55cvfnPqKyNl2kOmqKy//xJJhRDBJdhY1TLIQFIZBEA/Q4DSSrqT/HAguC4wFVz8vb63fmgOpi9X9T3QIwMDejbtE5fD3JkRXASrFtPM6QovUuTzzfDO+V3B/Vombn2dE1WD+bfSDyjUZGn7APYazbhlrHamAcK+3sHILG/u8BayS7Pg60p2wTc1bvZPWza2e5KxSaenulk+l6oe2xe/43eIDkngEtA/sZWjcSMmPvz1zCFVGw7E7H4R9lK/pnyLnppPN97Ky4BYKstM9t/0M0L5XLfapGA6bH6/PzRIyTNyPQxdcy9COhUPAzbGWjBcRgb10b7UPUxk8eL/FPbfN155ih96Bkdiwz7UbHVwhmUA9DwZFjRmRUxejGpQawpy7NcW1lLn5W1qdQzeQIklP8XLN0bOU/qvc4zOq1i48DnH2ICSvwGMJ5zvfkyC6Snmo2ZNpDsdqML4wgviXXk9eDYDiBV2GKCWGCDpfPdbu8ZKxiWUvzJMGWMMNe+bFlwcaoUsA4ZBxfWGAhSojUmsLCvtOS1sRHZ2Uf5TkAH/pqV9HfmMXL203RCqC+9AezhvUFufKElosq7CIi8HrnSAMxeFgNnGimns79LuhMnU4c5Esy8e8W17wenaID9AfLMSJ4DZ6nUvAxkD6NibtJ3notezb0SX7Wb80UoAYTridKiVlTRZiHA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(70206006)(336012)(1076003)(110136005)(70586007)(2616005)(316002)(83380400001)(41300700001)(8676002)(8936002)(6666004)(107886003)(426003)(47076005)(4326008)(5660300002)(36860700001)(2906002)(54906003)(356005)(82740400003)(7636003)(82310400005)(36756003)(186003)(478600001)(26005)(86362001)(40460700003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 08:34:13.0186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 792ac4d5-0a11-4594-5874-08daf8659cb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4075
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
index 99af1819bf546..c264d9136ed06 100644
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
@@ -2229,7 +2238,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3451,6 +3461,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

