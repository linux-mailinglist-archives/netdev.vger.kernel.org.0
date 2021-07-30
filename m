Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5BF3DBD82
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhG3RL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:11:58 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:30534
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229834AbhG3RL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:11:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOkJF90nELjDK1nM02X2Y+3N8vqh2vHzoW5vCARhzLkYNX5naB8C2f+5r9+lHfAr2oC4+DFJyGpUr3Vlaci4fGl1ah2r0yUNOMvu8ycu/s3ZuJQ03Dt4JgzIgwHgsIA1qQJydpCv/BCNru8e8/8gVYJ0jw51seT+HXMbMm1wJICg9Ojc0wgabkOYyl9JImQ9aNlqocOprN8PwRixS02gpMeque4Pr9x/F0PJ5h1mOopKdtrx77LneFlQLJZvjffAiysYGn8GuKV4f+dxuCeaL39b0D1Z4cAe3alj6K+aT/6+GaloIoNXb4oBQZsWnacqT6kiDT4FNCdWSUWgG7AGAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM5p+xFur6VDdH7Zh1qOywaEyyMkltcfxgiQZi6R3i0=;
 b=EEcd6mmbpqDYcl61B0AmiGFUZdyXFF420DZRuHxZjuDUC7TKY+ex7YgVxF1+uoN5pqE+ycx7tOm6UeHGxC9dwJHO1O9749SIcQygvCbxSnwdyy/Gsqf8MTar35t4m5vGSIe0yCdJ3h4N0ycVo8d8kTVy8bYV07x6lpKPOYCVMWUJWRv+ALE5Uos11bKFSoy9NEDJ14fze0HQaYH/k0OSa+qtbtS/hUWU3sR947ySS1waAAW6eip4Bpo5Ki1KnsotzU4+M4+ou9fwzYwRhsuCo+RunSHw3VW9ohY93GH7kA/LHoEA/ZLTwZxk/F13GpQyNG7gZjGj4g/ZbwdMuzQLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM5p+xFur6VDdH7Zh1qOywaEyyMkltcfxgiQZi6R3i0=;
 b=fTny+gzMBSu+weiRV8luxI2pLs53CeX3SpqGlmh9/zE4dJiVOUrugZgmSuCbojv+6EiLCsn7c1d4L0FpmIP2UPk8myqcVHSU5JPj2X6RAn/i9sN7SjcpNFgc2S+CcoBJyz96A8SHjhryJnQOdpncRdE31k5afePPxpUNYyXvtC4=
Authentication-Results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8952.eurprd04.prod.outlook.com (2603:10a6:10:2e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 17:11:48 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::600d:b73b:38a9:3c5f]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::600d:b73b:38a9:3c5f%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:11:48 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     yannick.vignon@oss.nxp.com, sebastien.laveze@oss.npx.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net] net/sched: taprio: Fix init procedure
Date:   Fri, 30 Jul 2021 18:53:21 +0200
Message-Id: <20210730165321.1179952-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0131.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::36) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR06CA0131.eurprd06.prod.outlook.com (2603:10a6:208:ab::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 17:11:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17d11474-40da-47e8-cba0-08d9537d1da2
X-MS-TrafficTypeDiagnostic: DU2PR04MB8952:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8952FEE310C88D3FD2813010D2EC9@DU2PR04MB8952.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I1Dsaaqsf08rmr0JOrt8gMcdMH7gtTxCf0xtKf+XeMLD9ABNtBd7DkrwxEMxfgG9dHbktq+31r/u0lafvXC/Hq9010rS3/EXLvPwIUl919t8GUDLPPhT6BB3pba/ll+sS8Hi9rLdrRCCmq6kaYAVOWXzyc+L0ESIStbdMGBZF6eurlYmuOX/kMVBMl09rKQZ+xmXh2ycZsJTyCD/b1BadRjJ72vejC340lKTiSk+wSk90zr3nBqd17aHTy4la6X04F+qYY35cLzDw5ipBp8Jpq7a1lotRAf2Wwihi1q2qpWdlPFER0Zb31fpaN/joeMw1Nk7OO1UhL/cT7dk6751jTWC7M73AtSBF3ZGNsGUPfixaoSfN8hrvwssPKaMQgMVzOBABjH03AFhkTKEYJ42jJHJEnuIlrrLyRjFRHZrISBp0bC+VhJQ+GF1ghEMDbK5fNMpFWfmLkBR/oetgXc7ujg9wBwIOzlJ55ttk9Z8bptSQdMrt57ntkiaSL/LQuxhpXxh8ZGkir2FW+v1rFE8T+6RQF1qrJEhReYfePfEFBOoa8TfmXzGbxlCBujBB4imalwrYhajF+o5bqFJ6pZMBxICHh77Wy5b2OLSTRPSct8rTiOlavjDVko3spXZ+VgkN20bL1bTRPSqwclWM8feR5pe3wrCs+t38DsbQW2fOo4FRIVhUzn4Hp/YdtWepOLZY/ntoOE19rpPbEITfms/mKlS45pMy2/Wi6grkDshrsk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39840400004)(376002)(5660300002)(478600001)(2616005)(956004)(38350700002)(26005)(52116002)(6506007)(8676002)(1076003)(83380400001)(44832011)(66946007)(38100700002)(2906002)(8936002)(921005)(110136005)(66556008)(86362001)(316002)(186003)(6666004)(66476007)(4326008)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WCpKpadeQHO3SboRJA69/aAo7bmOp3Nx0MmHWORZVRp9QnhiYmfwUoYJmQ1A?=
 =?us-ascii?Q?IJIk69ScxQXG3kqyuNQDsZr4HtTz2w775B5hmSjgQqvC5OMkh4q4XHGSTDMY?=
 =?us-ascii?Q?w9zfc5twcMPv6xjuWFQKvQMu5SyG+wxS9aOJMFi7gkshKmDY0Sv15RwQbSB6?=
 =?us-ascii?Q?Y9jSFCJjegU4Vq3MAgibVsdZMqFsu89PfcYx72S/z1TLfsvI43/lfG0pb4nm?=
 =?us-ascii?Q?+Cvl5D22BOwwCaFCkhQcIKW/V/BKUi1P+RyZ8m+Ua/uU0jUS0GML0H9cPPx6?=
 =?us-ascii?Q?7LRPTCmUGCZBjM6Yx3vutd/AQtBdFap0DyB61/iX+J+ypPSRMkoYcrdKZFQB?=
 =?us-ascii?Q?pcxAl7g9k61qvsZM6gAVMThJt7FLTttYa+f07wet7vDrhjxRysqbcLlvCSkq?=
 =?us-ascii?Q?C8tL0eO8gQN+CzkUq/aIxXHGBvU3eG0eSIemw0GCST0QpBazgvG6sluBuUbC?=
 =?us-ascii?Q?fSzq8XCbR9GXUSF/X3w2lO1sWyv9MV5Nw+R/qMGRcC92infvjAL1vWRIKHCG?=
 =?us-ascii?Q?ycFkqswJg93CtVgsr9KebR/Q7khjktvW7+Dq1pSNazwkMxLTLgSYdSEmuB94?=
 =?us-ascii?Q?b7iRWmonlZ3Bpfc5sXpwZtS1KXvVavjTEwSpDzpLteoz4XMeld63u/QuTAdg?=
 =?us-ascii?Q?pBH9h1u+jcEjEhqakv/SA8OVsZ45DbtMwZ18Q/DFrCKN8uqJhKA4Ezsz3/hh?=
 =?us-ascii?Q?CpID6CVwEpYw0Url9+Z4G1rBJoH72UR0qiQvaYWWGkQfjwBhZxj+HAso1e/k?=
 =?us-ascii?Q?KnBcPc6uJVHlkdyLe8p6EEDgOm9le7MY34q0YaX/jKfqaNiwQPFk+iYbnNrV?=
 =?us-ascii?Q?mtGRqOpqyRlqre7we6bTVoZtJ27SvkBe4lSz9WJLXkqntzZDKvmv/DlIel9i?=
 =?us-ascii?Q?gCYwbCqoSZBWivgrfgntufOV2V3BpUro1LzX2XGOiq5/PYbnM6uILct1Xep0?=
 =?us-ascii?Q?EXxftEBOTumE+4Sc9wG3BkIP35COVlfNMVjGzJEAsG5FFfnuD8j1AeBRIzPW?=
 =?us-ascii?Q?THCoexs0KRfYmyPpR1kRPLoOE/2KvQkNXwIyezX9s4TvpThkg1jsJlqWFMun?=
 =?us-ascii?Q?pBEc57fm1K6mz60K7JOGn6Iwq7s6COUcFEKpT32FnF6KBANHISBuljqC2KFO?=
 =?us-ascii?Q?Eh1RhJb+ykqdOHPNxWiIx3d57wDD2nNkuzDuTXklh1cHN7ENfOiNuzoRDPr5?=
 =?us-ascii?Q?GXblhdnP0ecV2RV4y+edpA1zrhNSdT5+mfDus2YSnyRwFq0ZanR8FQBvrb55?=
 =?us-ascii?Q?HcuHyunxdxqAxjwUz3bA6yPwK3b9ufq6hRDUapUvLlhcf9Dq/g11ey+EQQlN?=
 =?us-ascii?Q?6j53nR+EmgdF6hdjYVar2xY+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d11474-40da-47e8-cba0-08d9537d1da2
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:11:48.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwJJKzRgxNnZZibYzupV87t7ivAsgpo8ONKvWvrgbdn9NnfdRi2ayMoTBEyIZ1sKBNBl7TKCU81nXscdLq5nBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Commit 13511704f8d759 ("net: taprio offload: enforce qdisc to netdev queue mapping")
resulted in duplicate entries in the qdisc hash.
While this did not impact the overall operation of the qdisc and taprio
code paths, it did result in an infinite loop when dumping the qdisc
properties, at least on one target (NXP LS1028 ARDB).
Removing the duplicate call to qdisc_hash_add() solves the problem.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Fixes: 13511704f8d759 ("net: taprio offload: enforce qdisc to netdev queue mapping")
---
 net/sched/sch_taprio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 07b30d0601d7..9c79374457a0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1739,8 +1739,6 @@ static void taprio_attach(struct Qdisc *sch)
 		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
 			old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
-			if (ntx < dev->real_num_tx_queues)
-				qdisc_hash_add(qdisc, false);
 		} else {
 			old = dev_graft_qdisc(qdisc->dev_queue, sch);
 			qdisc_refcount_inc(sch);
-- 
2.25.1

