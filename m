Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2178E3504D3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhCaQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:41:28 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:33505
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233900AbhCaQlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:41:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I39QGdu24SL80TgdGtC7wBbodovheYH4WVPTLwgcIUfaBiF6zmD5w2tW9Z0kzo9Tsab65oRaugJLxV9LumB/kGXjriD6RPKV8IKKlBzrVFyP/rvBQHaDY0kINROe0zMqZnFQ2gNgNnmlE1hNgWxhJkK7yVca2iKF+yn7mDA1FhXDkUbFZ+qYyfo/gWFPKPtQ5S6TL2FLrtcAsBiqRj2EZKVs6GykMiN1t+Ij3t0MF48NAz1U3wM2wmG7JcgzqpGdlKaYWRswFmtTzqhIz17a5PA7qA11fPm8V/NeiKDESjajTTe8ZzAXGJWQt+oJseRYTBLty8KJbkD0gzR08BKTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOBpEIMM2rZwZ97aGYOKb0f3nR5Sey00ri45JQsT7V8=;
 b=bPsQSMIEuxe3kpau0/lN23ym2cltT/IEvp6r118t3oMY5TqYsLwgy8Yvh7YGT+6e7Gfbb/rdYmpCdx/UPNuJW5l0jeCEj6FcS8ZBnZcAp7lthDSuKKAbh/DvR5kUIoVj42s1Ysj314NemLCnt2+oT2+jCoQTa2KR6v5BPNxaRrefziSMMEXjAy+4pVmZXcSotjjnbKOwSi49SSW0X8GpGd5Gs1uYDnNiZscB6lzsA8eCGAJeydz8bSEx5Zk24jPQIuffYa2Aq2UpHHjvpK5YkOnxcgZ+XwIy4JmZ/oHJ8xsQVn2oYx3F77DdtDsoQOXqr4RcTbjvlhCU0KSHTE6GcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOBpEIMM2rZwZ97aGYOKb0f3nR5Sey00ri45JQsT7V8=;
 b=cAZowgCRXhTdTEUBxUVlu3FlkJFCwZxRmU+aFrW+scDz/+08FSZoBgu07vCCYQbsSr1w8rSzSs1ZEA+PzfkAByxloU28PqML9gLMc2UAqVZKaGorUlYKJciTV0DkKIWEX5HE8ksLuajcpkya6PSdSeiRVWWH/fVrpA99txV6eB0Z7Q8tpnsExRbnMJpjCRlPNNhB9VhzyTIpkUcKSMjIkYYTO9rMrGmyQ01YFQjIrSXyrArAtCvVO4WykBUsAbhTN/TSvJJ0WLmgSdx6/wZ9uRTcuOHFMohJQ2+RvJOYlI6yXfCLYyjtEOgFFZgsrIMbCjJw81lqRTe6SCiYOuQsgQ==
Received: from BN9PR03CA0446.namprd03.prod.outlook.com (2603:10b6:408:113::31)
 by DM6PR12MB4828.namprd12.prod.outlook.com (2603:10b6:5:1f8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 31 Mar
 2021 16:41:00 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::fb) by BN9PR03CA0446.outlook.office365.com
 (2603:10b6:408:113::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Wed, 31 Mar 2021 16:41:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 16:40:59 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 09:40:59 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 16:40:57 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH RFC 2/4] net: sched: fix err handler in tcf_action_init()
Date:   Wed, 31 Mar 2021 19:40:10 +0300
Message-ID: <20210331164012.28653-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210331164012.28653-1-vladbu@nvidia.com>
References: <20210331164012.28653-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddbd19e1-b994-4ca7-b337-08d8f463c40a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4828:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4828B906025E6648094EA170A07C9@DM6PR12MB4828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKpry+knBHbxGk/MUPR15g6xO7DOCqffzyiKZmw7jPWc4ftaS7YazAkx+NRVYkLz5hJuy37kY0797odBoQB+fO0AwssAgtdmjbm0wiuDIpEio/E8xp6pPVN4OxNo1IpacbTCRdmE5X13eVipgIcAKB49fPl80Et4lNLyK8FD8b1xbgBPKgxQjnxgH2CuE+kdzZ3WBMsP2A7CHWN5mQDYEublgPAyBPlJrLAW+J5vAIZN05HH7f+GG0QUujeJH6FTcaeK1dxWeZcM7rT1HN8IgpVg7dIbjCfPsiAJXHCohI7XAPExVWYbT1zwWEeDhb00KOEiweC9O5F3FnMvl8lttelofM9Q4FXrtInQc3k4L/nD/mBbIcAPkjEbB/7nrNKGNSYjDTmtF1NpnCY0zvj1RthXCiO26xzyMwUVT+Mfx3q+srVW0IX0/DWmfuWXFRBUsyhED45tt7RDn94goRXC8yHlTf7LOqgabxwJtoaCzYz+aSLSrQuOwNXXKpUy3+0xhnYEPDcIIDK85TN1tdvARPslH0A5xvzor7kdLUgHuF+30pLiithG6SordJE6Lw63GizK2u3FhWThpAFUMucdJrfGzCcj5MAWlMiOkxM2kp59I7dgWeBvQEleFEZC+j+ZC2G160TeQi9WVdz6BMz1/WmYn6YKiIcr1igzCJo7zEA=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(4326008)(8676002)(2906002)(36756003)(2616005)(107886003)(83380400001)(82310400003)(54906003)(82740400003)(7636003)(186003)(5660300002)(36860700001)(26005)(1076003)(7696005)(86362001)(6916009)(336012)(478600001)(70586007)(70206006)(47076005)(356005)(6666004)(426003)(316002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 16:40:59.9331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddbd19e1-b994-4ca7-b337-08d8f463c40a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4828
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
$ sudo tc actions add action simple sdata \"1\" index 1 action simple sdata \"2\" index 2
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

Fix the issue by refactoring tcf_action_init() error handling code to
properly account for the case of partially initialized action list and only
put the module for actions that haven't been initialized.

Fixes: d349f9976868 ("net_sched: fix RTNL deadlock again caused by request_module()")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_api.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index eb20a75796d5..4ef556906e32 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -753,20 +753,28 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 }
 EXPORT_SYMBOL(tcf_action_exec);
 
-int tcf_action_destroy(struct tc_action *actions[], int bind)
+static int tcf_action_destroy_1(struct tc_action *a, int bind)
 {
 	const struct tc_action_ops *ops;
+	int ret;
+
+	ops = a->ops;
+	ret = __tcf_idr_release(a, bind, true);
+	if (ret == ACT_P_DELETED)
+		module_put(ops->owner);
+	return ret;
+}
+
+int tcf_action_destroy(struct tc_action *actions[], int bind)
+{
 	struct tc_action *a;
 	int ret = 0, i;
 
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
 		actions[i] = NULL;
-		ops = a->ops;
-		ret = __tcf_idr_release(a, bind, true);
-		if (ret == ACT_P_DELETED)
-			module_put(ops->owner);
-		else if (ret < 0)
+		ret = tcf_action_destroy_1(a, bind);
+		if (ret < 0)
 			return ret;
 	}
 	return ret;
@@ -1082,7 +1090,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		a_o = tc_action_load_ops(name, tb[i], rtnl_held, extack);
 		if (IS_ERR(a_o)) {
 			err = PTR_ERR(a_o);
-			goto err_mod;
+			goto err;
 		}
 		ops[i - 1] = a_o;
 	}
@@ -1109,11 +1117,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	return i - 1;
 
 err:
-	tcf_action_destroy(actions, bind);
-err_mod:
 	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
-		if (ops[i])
+		if (actions[i]) {
+			tcf_action_destroy_1(actions[i], bind);
+			actions[i] = NULL;
+		} else if (ops[i]) {
 			module_put(ops[i]->owner);
+		}
 	}
 	return err;
 }
-- 
2.29.2

