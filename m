Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C178357077
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347233AbhDGPg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:36:57 -0400
Received: from mail-mw2nam08on2078.outbound.protection.outlook.com ([40.107.101.78]:20703
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243477AbhDGPg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:36:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaXiBWTk/7CrLYtJ+K4JALjNMHH4rLPLlJ/11ftj+rJvTXkVbtUh9YhbYjl8ufFaDw30U03u1HIoRW7CE8qRjWQnGYNoLYIhegB2d6PPZL8CNTApHiBKpN/pDpkyuMs2uDikY3jpFb0vq4uCnSo8TAYdemk1378yUJZPp8JlGPxNTG1OUyEXOSfdswKUbSFCaTXAd5szntmfEpbuh+uL8xijLVvdmJPF7mU8iFtgR5wCP9V5/BbH60+u/NzwWjg3YgypSwe5/JdTGpxrtCGV2Xe8X7318QxvTnWwlalWIfPUZL9C8XYCLqENDOMMDmYPY04RF9Ktvao4l6EoKwtaHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmWydUf+44kvoIH9/txTnHZ6z6jdMNGj74ia5GMzEW0=;
 b=JPKCQH6uhMf1fGKj0OuTg2+oJqhkVEIIVopTBL4iTavaU9OeuCV4f8G+c4YiTUu193ChrEivFZVeeu1/4qvUYGH691e/Stt7w1YveJZIjbxgj+FEld7tXAw9iKy+s51707mk7Tm/jN25wnIAzOd1ULhd7vyJHS6v9TUcjYwLdC9AFlpLuzOmmsxcFJLNxgvAKDr/TsbmgFfbd5+UcKX6qimULdAcRXyn/l+YZ4FCEje62X71PQqIk2g4r0o6SRoUnwW8+gDV857JIBx+t9fLH2GRy3HKcma3xGHB+iqb0g9eC5PeJ+JA35awt83vTGUn1a03nP/f3kTZ29nswpzkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmWydUf+44kvoIH9/txTnHZ6z6jdMNGj74ia5GMzEW0=;
 b=oCr63lj5+4odLu4Q0hlzbcby2yzt4EY4c/YUwmxYE6tuRE4bvdXtNqTVcikccru4f7xr++iES1LabQdHGasb6zBZ9l+EIMPD/714n39zS9RYD4pm0qNVmbMdJFQ4Qe6bMPGHFLT+tfDXn/kfe81ibxyflmlo7uLVS1PneAjUInL3/2VVeQnzWYvb+1pS3zZ2G9UdhvXDmDNZztk6972zVg2mIVDJ0/1XV4tbPjqN+90I65pG6djJ/vhe7m8IBSp0VoNgTU2bgIuYG3Ng+aXd76/Tqd0/7omn4y+0nYe6uAt68//7JvfEQ5EmOt/QyQP7NZy2Ye1AFNpl51AOCYqPzA==
Received: from MW4PR03CA0275.namprd03.prod.outlook.com (2603:10b6:303:b5::10)
 by BY5PR12MB3747.namprd12.prod.outlook.com (2603:10b6:a03:1ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 15:36:45 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::d3) by MW4PR03CA0275.outlook.office365.com
 (2603:10b6:303:b5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:36:44 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:36:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:41 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 3/3] net: sched: fix err handler in tcf_action_init()
Date:   Wed, 7 Apr 2021 18:36:04 +0300
Message-ID: <20210407153604.1680079-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407153604.1680079-1-vladbu@nvidia.com>
References: <20210407153604.1680079-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09cb1fef-c764-4150-f713-08d8f9daf308
X-MS-TrafficTypeDiagnostic: BY5PR12MB3747:
X-Microsoft-Antispam-PRVS: <BY5PR12MB374740F1276F64B672B08E2CA0759@BY5PR12MB3747.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oKBB1nubJhNZfM7mMFZ0ojo8HL5S/z+TlgxwilIpEVZqI9ic3FsGI8O02kvqxnLSgnmtGLYyPpOL4m2xo8IONEy7iIx/P9Hg9GWyGUZO2z7uC59BZ8yC5V2CQ6AztMLaCwSQI4dSIAZ0IejhUvf8EP1CNGLn6DtgzFEr3v6sCuSIyeU+LzuKP/3TYrQa//BQVH+uLg8OvacXTr3DYFUlc87k0oJApcPR7Au2iUUrW3iEt53YKjyHGnLGIsNteDLe/WBg9qCK46gMKGXkcgc157RzgXbjywkZtk7RCizr82cX0Dyd3MYNjDY1uY6R1GNaputBYetNKq8O0MV9WF9bpLT3YWEERGJ4fznAqBm+ijSmHrXaFSutjjOHDIP7Y95O5PiuXi77qvVKlaUj2+UZWpGM0G5KZan49QT9RwFU8uWcHRK59MolTIu23xMqc9fF9BL/EAduUWlcEUJ5qSRUhh+asO7GEjyIwaYgWbPewnSGRKQBEJCXQMoBDvoWyk/C9sJ9ceM2rDh3OIFPlZk+R8EIIHDGpF1O4pBj59VlXCeDtGuR2ED2v6OCywzZjhwBBmf08cfad/s5oh23LTTgZ4gKNZvuA3Ve2msN3Ys35s7XKKVoaE9PKCA++W4bwUPORAW6pjJ3kLSF96BIUswvK1bXVNR2Rs0QheEAVIig8uI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(7696005)(1076003)(6666004)(36906005)(478600001)(8676002)(82740400003)(54906003)(316002)(426003)(7636003)(83380400001)(5660300002)(70586007)(70206006)(336012)(356005)(7416002)(86362001)(8936002)(6916009)(26005)(2906002)(4326008)(47076005)(2616005)(107886003)(36756003)(82310400003)(36860700001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:36:44.7453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09cb1fef-c764-4150-f713-08d8f9daf308
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3747
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With recent changes that separated action module load from action
initialization tcf_action_init() function error handling code was modified
to manually release the loaded modules if loading/initialization of any
further action in same batch failed. For the case when all modules
successfully loaded and some of the actions were initialized before one of
them failed in init handler. In this case for all previous actions the
module will be released twice by the error handler: First time by the loop
that manually calls module_put() for all ops, and second time by the action
destroy code that puts the module after destroying the action.

Reproduction:

$ sudo tc actions add action simple sdata \"2\" index 2
$ sudo tc actions add action simple sdata \"1\" index 1 \
                      action simple sdata \"2\" index 2
RTNETLINK answers: File exists
We have an error talking to the kernel
$ sudo tc actions ls action simple
total acts 1

        action order 0: Simple <"2">
         index 2 ref 1 bind 0
$ sudo tc actions flush action simple
$ sudo tc actions ls action simple
$ sudo tc actions add action simple sdata \"2\" index 2
Error: Failed to load TC action module.
We have an error talking to the kernel
$ lsmod | grep simple
act_simple             20480  -1

Fix the issue by modifying module reference counting handling in action
initialization code:

- Get module reference in tcf_idr_create() and put it in tcf_idr_release()
instead of taking over the reference held by the caller.

- Modify users of tcf_action_init_1() to always release the module
reference which they obtain before calling init function instead of
assuming that created action takes over the reference.

- Finally, modify tcf_action_init_1() to not release the module reference
when overwriting existing action as this is no longer necessary since both
upper and lower layers obtain and manage their own module references
independently.

Fixes: d349f9976868 ("net_sched: fix RTNL deadlock again caused by request_module()")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V1 -> V2:
    
    - Reimplement the fix to unconditionally release action module references
    in action create code and modify action idr create/release to manually
    get/put module reference instead of taking over the reference held by the
    caller (Cong Wang).

 include/net/act_api.h |  7 +------
 net/sched/act_api.c   | 26 ++++++++++++++++----------
 net/sched/cls_api.c   |  5 ++---
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 312f0f6554a0..086b291e9530 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -170,12 +170,7 @@ void tcf_idr_insert_many(struct tc_action *actions[]);
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
-int __tcf_idr_release(struct tc_action *a, bool bind, bool strict);
-
-static inline int tcf_idr_release(struct tc_action *a, bool bind)
-{
-	return __tcf_idr_release(a, bind, false);
-}
+int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
 int tcf_unregister_action(struct tc_action_ops *a,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 50854cfbfcdb..f6d5755d669e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -158,7 +158,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 	return 0;
 }
 
-int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
+static int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 {
 	int ret = 0;
 
@@ -184,7 +184,18 @@ int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 
 	return ret;
 }
-EXPORT_SYMBOL(__tcf_idr_release);
+
+int tcf_idr_release(struct tc_action *a, bool bind)
+{
+	const struct tc_action_ops *ops = a->ops;
+	int ret;
+
+	ret = __tcf_idr_release(a, bind, false);
+	if (ret == ACT_P_DELETED)
+		module_put(ops->owner);
+	return ret;
+}
+EXPORT_SYMBOL(tcf_idr_release);
 
 static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 {
@@ -493,6 +504,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	}
 
 	p->idrinfo = idrinfo;
+	__module_get(ops->owner);
 	p->ops = ops;
 	*a = p;
 	return 0;
@@ -1037,13 +1049,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (!name)
 		a->hw_stats = hw_stats;
 
-	/* module count goes up only when brand new policy is created
-	 * if it exists and is only bound to in a_o->init() then
-	 * ACT_P_CREATED is not returned (a zero is).
-	 */
-	if (err != ACT_P_CREATED)
-		module_put(a_o->owner);
-
 	return a;
 
 err_out:
@@ -1103,7 +1108,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	tcf_idr_insert_many(actions);
 
 	*attr_size = tcf_action_full_attrs_size(sz);
-	return i - 1;
+	err = i - 1;
+	goto err_mod;
 
 err:
 	tcf_action_destroy(actions, bind);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9ecb91ebf094..340d5af86e87 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3054,10 +3054,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 						rate_tlv, "police", ovr,
 						TCA_ACT_BIND, a_o, init_res,
 						rtnl_held, extack);
-			if (IS_ERR(act)) {
-				module_put(a_o->owner);
+			module_put(a_o->owner);
+			if (IS_ERR(act))
 				return PTR_ERR(act);
-			}
 
 			act->type = exts->type = TCA_OLD_COMPAT;
 			exts->actions[0] = act;
-- 
2.29.2

