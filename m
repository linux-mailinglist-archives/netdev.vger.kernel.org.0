Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550FB4F77BC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241963AbiDGHkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241987AbiDGHka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6A062134
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYNQ4lNdBxsQQj5AzjtfIBE5CH9Zftbc9i/OhD8Vz75Jyzb1hlAKMpBhuKSJK685hw46aeK9vl1G31CiTmh3zg14PRTOJtzh12WktfWKp9QX8Ye3lCiYGgLk/s3nXL5jUn6RER6gYsysz/VO2BF8+yoflQ7M7LS3y1JOh8Z+SSGghrqKQCiTChHqE3YrnBYa6eGFaphWSwW2c27gcPR/UJdcbCdaNw4bi65QcJ8X2s+J5AkDwAY/XfDdDcioHtHiK0rHtwFaY0K5H8GYEIKiuVhUnEdQbq+M6BwfYm5y/Hw9WontI2L245A02zM/diFMiUU9g6hI6tBjppAUAB5yRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMP3MQ4e4iAC5wVR+3ua/JgP3E2tnc/4QlW8D+0MmG4=;
 b=PtTVmsSXv6ASHia5gBiUCL/7Q6XOaMnDt1dNPiauyV41LGYyyJpj2iKJD0kwg+fYTT20ZA/tfo4wWu6mp1OM1OptZ7e61dHsNXIp2fYzneB0NUY4d7zsp0ZX0q+OenOJDpm81174O4e9chX/iP5/+f2k2nEZA7mlu5hyrDgY4omnqf/PFqaffswOmJbArf21c8jE0e05rEeKYF5Djku3LNzO0+fyz9rjukQr0wI1HkPUYtXeb/HjG+b+GCD8Qs2/+m9cm5A+TkdMTVGB8hGdves1pBobfmS0/xaX8eCx+hegQeE21af4+7x1kVIEWatRgURMrK6VUUtcl2PI2PLomQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMP3MQ4e4iAC5wVR+3ua/JgP3E2tnc/4QlW8D+0MmG4=;
 b=BrT73VOYLaHVcMKN6QOZEbSJOS2p3jB0XiQMlda4ftTTTusggqli/+v9smOvcmAEqGh7rzNQoXyv2ftpOl0g5/EIT+vM+83KKj534k7IFgqnl8pYKuDdpvTKURilwApztCzM2rnD7InVXsbIHqx60v60dDFRvf2KWPPxvNcZpnG0q3GC3uHTBjWKxJlrKInxCsOivGnE8FF+C3iFsMcumJWSHhTNhuOEOGPlYd4zlpdcxvVDOKG6wyq3Ao2Rtgj/q4FCgXwhCw1B+/Q82ddp1T0j2tIjyRWshEJ6u56jt6ATATOAlpzZ1Hv/63SLDbcdqcul2uuPdu68Cr2WbPZ03g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:38:26 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/14] net/sched: act_police: Add extack messages for offload failure
Date:   Thu,  7 Apr 2022 10:35:27 +0300
Message-Id: <20220407073533.2422896-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0151.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::35) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b3548d3-04e2-425f-69bc-08da18699a5a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0188A3A21E57ADD3D5C2FD23B2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y63IN02+ENIlY5gD0tUMOgBLIoEbPDDjyVoSBcIYtP0CMrX3sMKdt7lFKxfZxExO17wEzuiTg3LMn7enNo5AFZmURo9daU2ggRfcJGF6JAVoPMxRYFF2gMzsazWmpU0k/Mju4ycE3Qju1yo4b5reVYzcl/Y1AV8GORFp+MJHK06udm4B1hom3DI4/Hnfgt6iFd9mJFq9qST9NJxkHsvZoBr3SNlgdeFCRmuOU42ZcbuU20hI44pySBGTcAIBuOtTadjCh6AtpuY/rBNNWg4qksfag3QOFAWVpzuoGgbbUYNgT4Maa2O1pfXW631JK2ijdcRYFbA6peMsB3raJ4aLZcJm1MtISStc5a60rZSPkyljWK+29SeC1JbLfs3WrFELnu25Gilsr0xRarCWs8nxYpUy7JFFG8K382w7lgmZnvXdS16wzqEtztpOz61hUW9fPiplatQmIErgVPpzSsgC8iiFmpV6z4Yvw17LvmrnKup+fLS9e4V5cIzzMJ8EkfFZ88Jf+RgFP+INp7qgRcLGli3FfRW0GiXS739JblK88XM5gLy+arMjHiZuAPO5hhVpSknVyTjEhGDUs7KrmRDEzYm292cI1Kowu2/PURxBsPdYHP0aAXPsAwUTzFKWMRZjaVnzy0CM3w1lWCR3tND+Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(38100700002)(186003)(15650500001)(26005)(2906002)(6512007)(83380400001)(6506007)(1076003)(36756003)(316002)(6916009)(508600001)(6486002)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXvQOcPeaM9wBqsc1l9Eb3LPMaaHt4r43iqHeWrfuPH1K8ewss/8QW//Vx8X?=
 =?us-ascii?Q?XCCrxcvvpsJmjj8e+9oD1ZicSqxRDgmNoJc3SWsv489TN8k2P+pqGx0+tTPq?=
 =?us-ascii?Q?R+WXzOfPvVexYXWzcbT3lwZM/3KYfwEWt709aLmykS/5eBeqJkVjEZNiYp6k?=
 =?us-ascii?Q?WIlIgm9mRtd3vjYCVe3T88YBKz31lRrp72p70DNIZdyod5BTLNDHFQbNW1F3?=
 =?us-ascii?Q?0vQDB548KbJvFcAFaQyGgGNTzlG21/CFY99/3jeSIPebAZU6ZqnnxRYb6chY?=
 =?us-ascii?Q?vGkMCge0rqzv5OWZUVCVgM62vM9RkDZ6avNuGS9iimsolupJ2oE0EwxYIaRm?=
 =?us-ascii?Q?5ZUUrjm97lQzqcq35YQXJwtwRD/qgXMOWnbzOMbwxp++pBWxh6PsrCxUuRne?=
 =?us-ascii?Q?WQKnFI/+YKZhhzIoIjSEW/XDoBMz0iSBjNRx9e6S/2v+QPTm4XYnuazsa5B1?=
 =?us-ascii?Q?HY2tpQ4850JzQ2dJ5/Q4ZF7HYYhHFbMhmPQdbrWcP33DTnzse6kN9NqXXTXi?=
 =?us-ascii?Q?GXMN0iI4Q8pH0GjfDJpfn7aUQ4kiL5WNevpU1BWIwpatuQMwsWzyUr3ebDTQ?=
 =?us-ascii?Q?1vv+4gwqTueuDueXlJ0Vm+oBSyoBFGNRNzKURMz+NOAEjqwivmGb/DnlrqMn?=
 =?us-ascii?Q?8du5RCddTiujMlJZTg6CFGfHcjl7DwI8R0AEzpf4SZKfsBC+bZtenzQn2DUZ?=
 =?us-ascii?Q?VLvJLLM4b9JZj7mnN8LdN65H+k9KOnx0RGfIyhL3T9XsZNwyp2WLIoOhZHyt?=
 =?us-ascii?Q?kk32PQzTqU4AHUpaqpVaQdwsv30Ll71rAucbsbbIPTIiFB5jIqzkDOVTFK/2?=
 =?us-ascii?Q?LC060tjBBd6xn4JZJK2hxx0jljbcMhn3gaKnNMS4fQc5FsilyqYdaFr7T2R/?=
 =?us-ascii?Q?0RWcB8nHghxbuE/u4ezK4i/KH7NWSkkt9Zv/5DaCoI9jSaYdLP4gu8Lci+iR?=
 =?us-ascii?Q?naegGGfdw3KWZy1/YCwx89YhK7FCBor3xzQTYXrIyhFyOwSLa/6SHx5ZLFjq?=
 =?us-ascii?Q?v3L2/++uBgxOzMvX488YuHt9yPdLyfFGQAHDObRbCNAaAMOowQlwR1RGH/Nx?=
 =?us-ascii?Q?XqHzibQvtTtBjLQJNOgMa+JVgQ2xjIh/YCVIqFXsDwr+mO9F+7QIEDSfoYrB?=
 =?us-ascii?Q?7w7WUS6859xD+t4wNjcRtYrqvUDxvNTbRFwEL1zQZKaaqHfFB8lg9rZkcb6S?=
 =?us-ascii?Q?6DlUeqRQPOwNCBphT9dOXhRLdyzjX11/XTB8Xtvy6SpXUR0ldHWgsN1Pvue0?=
 =?us-ascii?Q?hLxNyb7EE0cLtABlmFYtuKViULhmmh5t4gSHsDXZAXE2CrljCMxD3w3AViQr?=
 =?us-ascii?Q?EuuaZN+BtWadaXL3MBbou2J9+ybUXpwPyofzxF4qyn2jND7D0Ck5GC+vbZ6P?=
 =?us-ascii?Q?JurEr+Qm4MSjG5zjgOyqxthKEPLsxSivHetqiX6iB5/3GRZha4PfNkR2EkVF?=
 =?us-ascii?Q?YwjnBqmXBuyAgB6pEn6yDYL6DR8cdp2YgHs4My5yIiLE9OhzNg3P8S7p84IQ?=
 =?us-ascii?Q?Csa7ML7pQ44yMDgHgw7CyxKBXjogsEa+wSLxUIEmunLqkeZPT+nR/UBRkLn5?=
 =?us-ascii?Q?6XXnT0cAABAbE5C/bY+W0DAAeSWi89cwki5QX7Tdv6tFodrKurSiyNAsqo4a?=
 =?us-ascii?Q?za0o/4MOjD/HO34t7HHD0hnIPReRaToQTqd3tJpGWRUytv5B/pFWzSXKjMr+?=
 =?us-ascii?Q?IUHgt9Oeh3llXuJpe7xoycc49m7SleezvT2Sev26QciQ4ATEIKLJ8DD4kS3v?=
 =?us-ascii?Q?ykQOegry6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3548d3-04e2-425f-69bc-08da18699a5a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:26.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqZLGhC/BEAAg4+xb9EjDiss/uGpvjUatfpvQO2l/Ev5n/EWM6pcF3xnq1EHxB9MQs3EkzyzsMv4TIPU/bTxuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better error reporting to user space, add extack messages when
police action offload fails.

Example:

 # echo 1 > /sys/kernel/tracing/events/netlink/netlink_extack/enable

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action police rate 100Mbit burst 10000
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-182     [000] b..1.    21.592969: netlink_extack: msg=act_police: Offload not supported when conform/exceed action is "reclassify"
       tc-182     [000] .....    21.592982: netlink_extack: msg=cls_matchall: Failed to setup flow action

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action police rate 100Mbit burst 10000 conform-exceed drop/continue
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-184     [000] b..1.    38.882579: netlink_extack: msg=act_police: Offload not supported when conform/exceed action is "continue"
       tc-184     [000] .....    38.882593: netlink_extack: msg=cls_matchall: Failed to setup flow action

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/act_police.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 77c17e9b46d1..79c8901f66ab 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -419,7 +419,8 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
-static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
+static int tcf_police_act_to_flow_act(int tc_act, u32 *extval,
+				      struct netlink_ext_ack *extack)
 {
 	int act_id = -EOPNOTSUPP;
 
@@ -430,12 +431,20 @@ static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
 			act_id = FLOW_ACTION_DROP;
 		else if (tc_act == TC_ACT_PIPE)
 			act_id = FLOW_ACTION_PIPE;
+		else if (tc_act == TC_ACT_RECLASSIFY)
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform/exceed action is \"reclassify\"");
+		else
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported conform/exceed action offload");
 	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
 		act_id = FLOW_ACTION_GOTO;
 		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
 	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
 		act_id = FLOW_ACTION_JUMP;
 		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
+	} else if (tc_act == TC_ACT_UNSPEC) {
+		NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform/exceed action is \"continue\"");
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported conform/exceed action offload");
 	}
 
 	return act_id;
@@ -467,14 +476,16 @@ static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
 
 		act_id = tcf_police_act_to_flow_act(police->tcf_action,
-						    &entry->police.exceed.extval);
+						    &entry->police.exceed.extval,
+						    extack);
 		if (act_id < 0)
 			return act_id;
 
 		entry->police.exceed.act_id = act_id;
 
 		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
-						    &entry->police.notexceed.extval);
+						    &entry->police.notexceed.extval,
+						    extack);
 		if (act_id < 0)
 			return act_id;
 
-- 
2.33.1

