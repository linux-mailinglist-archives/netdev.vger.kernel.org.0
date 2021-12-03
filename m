Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC8467755
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380773AbhLCM2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:49 -0500
Received: from mail-mw2nam10on2132.outbound.protection.outlook.com ([40.107.94.132]:46432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244687AbhLCM2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1QSvpxjSjpOBG8L80jGlt5p88/U8fSTYjLcfxlTHFedAp9w9dF1/QPGAC0mjwJ9Xxz9SvR3FbD8riiYsdj1zLQPUqnMae++yUtTbOjI4HAb6Ja5coNYrs7EkoYxzTRnMMlruf5VOa+FB7DQZHv1pMi8jssDutaIdcSRJITytu02Zjovzd7FdNfdppx4/QoTUywbXTDqRgKhDV/szCDNJPEgFOx8Hk10WWl6P7q5K0dubH74/AZzadrq7p5BMTtFu3fEOnn/bHqMVSBFhDWMGSkPPJKWUlRNCLrTRdck46cFVJJg/y0yJf82MlMGAL/Qz4r19S9z70sdRXrJQFGGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lh6WPemjbx317oyN9/BM6DLmJNvc13bAQG0u7nkGCDs=;
 b=X8RcUp2bmLM8FDT6NRQPR/YX1eLaLTxnTuoN6ExyH0rPsCKFnv82Rhxoq9X4jA20J6g4UUeGCLDV5qaEdjAqFEYh8soPZCge2L5UXbyhMo9+Qm3p70vTi3THxXs0GoN0OvOn1SDpB8BbAierRuNptREfwhjLx0xeh2dxUe4MomOzPpuinne9HURiTZYcXRH+ZfZlHMVO5EkMKZpUflFjuUGvYCSx2pWupG4g994zYLK8MdpfscvLOcu6Fk+yrZt4wb1klmHmdPoop9jRf/O0JQfnnxwEtHB/VOM3XfbKTsHqI0wLqWw6Eh9WfUTDkCO97D25BY53SUQ2HoCG6pQYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lh6WPemjbx317oyN9/BM6DLmJNvc13bAQG0u7nkGCDs=;
 b=dEMuawqGZyuY1GkOqUc/ppLXi3v2cAF3fmzuTTmSO98ByjOKeYF+sHzjVJUTQsunoZai5HEOLH8af8YiuyQ9WCkBO7wpEjrUPWgRsITotdMImuyda0ZWpnFvtHl39KnsGeYUUZ3C6bSqasz9lJJ98/zBTOdHCbPiGEeqWE0YTTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:22 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 09/12] net: sched: save full flags for tc action
Date:   Fri,  3 Dec 2021 13:24:41 +0100
Message-Id: <20211203122444.11756-10-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dde3ce8e-f4ea-461f-f8ee-08d9b657fa1b
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5423783EAFD60654906069EAE86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYWhsz/+NIictNN4vsOF3KT9l9Do7HDxku9Q76JYYozm/d0svitj7vaIBqSZeQ7ATKuxfCEpvNQbpNgNvfRk/QeHWU4zsK6L0tdy5aIvhFL0nJVe9hJeGP5jmk+tbXbgVUL9u+y7VsFX7n2vR44udMDGJ1IC0qgGWK9se5gWyMOzrhjKpm2HKa9hAdwEHdbNRuLrPNP1GwwtXU4cn2QCfJXcwi2AtuQsKhSIOMwE9D5NmC7fdeve8d6toEsgOcWVw3/BTwDUGnxDF2OkgogA3SJg027MNVH5ezq/on6/Pn/GdUxoT+nwXQAe6OnxvprJPo4j4UD1YdNxgqtivAmTWMkzrHGkCXk6LjvkRY+OL3sy4ebtDm7uL0DHSIW3y/ZyfAxLAwRIOdHMkQ3f5Cjzh4lZtya7DusAoQ11bjjAbN/enMMa0PRHNJ0VhgAuv90aQQ5/X9LFA4NNfWWXEoQdOiZhEmEoPs88SVeEzsxqP7syTZpFXmDNDzto0X5MIACcLmHC2gtpmV2D7mP/+bwCx6Zu4rJyCdri6Rv/VmgJ29ZyIoHfmxH9xywy05qPFGhIu85S6ne3GdzteEZ9E+D4PqEmhPJZMitM/DC8WbsnfI/fJHrXLyL0Hoc4q+M3zKnpd0itEnr/hKvHV+ZwgB88Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c6ga1W6W9aYM3HsEcwyB1ovxgjS0DEHtyWJmAZp0jdPKxqEVRP0QFvRtFsQx?=
 =?us-ascii?Q?chg7692doQ0p4XIWrylXBMDPhszfB6IVBe4vAzEXxHAF9DIc32QN5YtGDiv8?=
 =?us-ascii?Q?yMBBYxcmI0cqEr1Kd50vpPHycJATXL+WtqQ0/Y+wKogopRQqr5ZeHVfJ5B1O?=
 =?us-ascii?Q?usvphcIXVAIUjRldoI2Yhyb2/t7/ncS7YRm1MEEYbvH3BSSEgiO3hxKKZf7c?=
 =?us-ascii?Q?dodITbCWhuK25swKq+Yps2yBj/JKlLEQ6KidmUlTUszha3bUpttcC92EsOOE?=
 =?us-ascii?Q?MaBzG52rrlPO+UmEGoqRxf2XWTQ64PuVMsKqh8tTpJTvREaMC0BxHi3OIyj4?=
 =?us-ascii?Q?jBYVtLKc42sZWiuN88HYGA+cv8UaYrr8Jtc/ZufyosdKIUMbCbAYzlEXYq6G?=
 =?us-ascii?Q?ETGMaNq35vTZtvskoEB84902MilXqoVpCM0lQnwl9jKx7r0oFJkSxSjBbQWM?=
 =?us-ascii?Q?/BYExHVKZOFbXirXeSniNjtMBRediSxlTZPW2lM/3uODr/kcPKPLzvAifODY?=
 =?us-ascii?Q?BC/RyBQOAYg4f4HxgMgGGu0ZhQaKWEeifl2bOHGiqwAHsxkKDZIFSo19UhhZ?=
 =?us-ascii?Q?eQTE1loJwqASbqPPkfohndEYGoCtS5XO8/LaxVhqbk3FT1ZJd8FFff0oIwZj?=
 =?us-ascii?Q?nKnjd0DXqbL5FzvmRB4swRI9HvfAoiEhxvCHCAcMb29TS0IO+7yP/0mY8MeQ?=
 =?us-ascii?Q?jlTBJxtZ0PmutuyBU9bBcXhvmiY4vnMvBMXjNdrTSae9ajX6g06orL1rbqzH?=
 =?us-ascii?Q?2hA2MwC2xfvwy4A5RloYw+NzSyPyZPtHQTDMWisQvFtIgLviKEH3oXx9pzK0?=
 =?us-ascii?Q?VTbnFFu42fZCIUcGBjBnA/1xRGOgoPeJ+bETqm8DzevJp6iRSrWopDxvyK9v?=
 =?us-ascii?Q?oKzAvvc+TPfSeWY/cnViS3wWw22NOpQq7k86yUyV19E2dVnAVj7vo1NHwU3a?=
 =?us-ascii?Q?EmSmvoy7H2rO+r2x++VNeLx6Ej/OANIPASdutmbMA5LY2GzqoyGJwAuk1whm?=
 =?us-ascii?Q?L7UUjDNxerQdHLy7QrbLkvxwMCdnYKkKW61XTu4ZvTkjUS/9/HXWczBPEwJo?=
 =?us-ascii?Q?aIgakCUtslurTiAvUReKa8bqxUr8uimdnSAItbhFi4aKqsU3lleEfWqsVyro?=
 =?us-ascii?Q?UON0oPfsW4hVYNYeILIJ//8fsC5aFiL4p6i8gLkpGWX5D8GVhxP0rns9Wr4s?=
 =?us-ascii?Q?9/lqzRe45nKymwn81m04ZtOLtUnxd1avbG2Za252iiNH2md66Ug5nORNeBaY?=
 =?us-ascii?Q?0BqO6V6DdHXdYipETF6tf4pVwxASBB6ac0FdTHyooBRtfVUQwi+/AbdFkfer?=
 =?us-ascii?Q?kaTndb0kMZ/c1m01mmRyUuU+fSzbpJSe2Ezv6x+2CCVZOOVYH4GwE5XgkiUA?=
 =?us-ascii?Q?jTrEmccHD3+lZSX6xG+JbjGQDm6IoUdChWCnJssKnuMc0goC3i0WF7tIc8ON?=
 =?us-ascii?Q?z4mdqA/I7nmmnGabY/oarKmMKbsl0PU3vGoMVUtE+KyO+VOva5L/CM/McoP2?=
 =?us-ascii?Q?vWgDnG9UHHyX5PU10KxXtaTQWe8x9RolLo7VAf2cw1PIlvLqh73cWKYSZoSQ?=
 =?us-ascii?Q?wF8jgfoyEVwVS5/ew74XDyGxGOx1HYc+IGPH4nuATGkZvmEidAwAvzRtiEvf?=
 =?us-ascii?Q?9p4F8Qy1Ksia9TYYx3ls/pujcpI+3fPxZ3bZZudmiDnyi8Fhm8HARB5q4/yv?=
 =?us-ascii?Q?ZaN/xvQKicrvOQUgPbsbxlD/hKUf28gCqi2KnxZnoRorJSM8foMYUibWstA7?=
 =?us-ascii?Q?1oW+gcfCUVvBa2NekP2fiaxOw3mu058=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde3ce8e-f4ea-461f-f8ee-08d9b657fa1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:22.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //RQ3ZyeNIgMTmEIgCk7sCsUJhwCEOYRAqRiKGcDb485+25F7UBZUjdC5ll1zpKwEdwaVXrKnQS66f/IFho1GaXcag5OqCR00XEDmjQH7gM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Save full action flags and return user flags when return flags to
user space.

Save full action flags to distinguish if the action is created
independent from classifier.

We made this change mainly for further patch to reoffload tc actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 4e309b8e49bb..e11a73b5934c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -668,7 +668,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
-	p->tcfa_flags = flags & TCA_ACT_FLAGS_USER_MASK;
+	p->tcfa_flags = flags;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -995,6 +995,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	int err = -EINVAL;
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
+	u32 flags;
 
 	if (tcf_action_dump_terse(skb, a, false))
 		goto nla_put_failure;
@@ -1009,9 +1010,10 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
 		goto nla_put_failure;
 
-	if (a->tcfa_flags &&
+	flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
+	if (flags &&
 	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
-			       a->tcfa_flags, a->tcfa_flags))
+			       flags, flags))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
-- 
2.20.1

