Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD774F77C5
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241953AbiDGHkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241960AbiDGHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC070140F6
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHvd419x+hbs9d1IRMCdRVdoDnWMIgFrO3KBrILr8tZM+f7kmM3bGzU29sgRZFpV6uX8/nbQEaP5rSEiAD/cqVh3crfcVd7U+ry07rt53GyTq+o5fbAzFmDVSDYFy+mkwrihwGCdmqHPt4gQ6vhNwhdi+ruUAwpS4GAqU9pxTpoG6VoWCIOBWNggRpAhFq9bXsziOOCVykEpTZgS9gvwOwfVdL01SOoBXOS/3b8Cj62lmPoX4LgTyLx1PcvElgdKt+YGSwKyNFlB16VctkJtdJTL5F+tiU1El3kyG+BOr57XFmIRnILZI8c4KoMs+qFBnbHozL2xd+vXKIGv2lTb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STaKNCJq3jTEeXRYlujUmrDLynBhQdFUSz5edI90P68=;
 b=YBoQverBCZHi73qaU/fbdAokYEvnIv0fbq2mjzNIdYQ6VkZbGsFyhtZoxcU8VLtrcNy29eoq/YiTIzW99jBUipTLl9h1uYYUYigR3D0KpXLiDmezeQjjb15Sgo5kzw/Pn51BQbMvPw1gENqS04jjgF9x73g2t5BCfaBW9dUPFVDu8QFpXXNyiOf5HfsFzCHNo4YyM//CLOQqDaY7W0Fnaoui1dYxXVc3Dfg+uER9F5GA4pt1WKjcdBt95mn4IUAkbuqFR6WPckmoa4T9216ECl0gBw8dC6YWp8Mra4cuMs+/MGktHqL1kl5FiElfZcUYbFYlyK6pAony7Kxtyu48hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STaKNCJq3jTEeXRYlujUmrDLynBhQdFUSz5edI90P68=;
 b=lT71C4S7NeIKm2lUro/+QcDNMc7ik5Mv4aHPSH4995csnour+EmAPNlUD7P9+z2fw5S+Ykl3FTFsfct6apkdvUK51/HxCv6y0tVlYYYrBAQodTgd6Yc+/TXRVGTIcjCDXRz5PSurMGgqu9q8pFbjOkBzQbQsbMvEcWrgOgHM/lWsz5fEVa4/tY5J8UijAYCJ+CQU55pP/Gx03CzThHJTIgXMDxquIvCbL9GC4V0eLsUP8+oX971yEQykLlx0fp5lAJVZ8HHXB21LdG3jDU8Dg3SMKSoTa2/Bqia2MJkt3JTtnXyBpCsz/BpTKIWYivMPhzqAw/CYFboSh5KKlArGZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:38:15 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/14] net/sched: act_mpls: Add extack messages for offload failure
Date:   Thu,  7 Apr 2022 10:35:25 +0300
Message-Id: <20220407073533.2422896-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0018.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44cd679f-b1b0-4d5b-47ed-08da18699354
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB018803D68D0A70E1800AAFB5B2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZSlkIc83GV13fxe/lHfhwiPmy9Ew+fFW+wK1HnGF0h3bRc4xnWV5q07OhIhNuX9mI1/9WeNjHAvPmCT5xy/ooakr6aTXjhfqI99Rid2Yg2HJR9SeVjgguOPidlD2hTGEGgixy7U8lcyODdfgD2bPazV8AuReQmA0wo7CtvWGL/Iz8YWqLWFBr5emso1VEioPbN5ZXcze1HZCcSIgRd4Zr1//RLV/bYLOTBekiU48w8DKyQiCUwSQ/OC+V0HNzzoGpdT51eMmpI3DMc1FSoH7cpHJDi3d1Ze9ix9K9mkHBlZZ5Fdn215WhEqg3Q6PLj12DTwNliObH5shn8NEkqUymgnpcaQCFH7Enzx1cDQTaLR/68MR/m4cIMXqbVQZwzA5sbLMxBw799M22fsOokgAXpGBJGyK870KiU3T3ewiwaXAiA8J03ZZWloflTvj9C2AXzPxDW9zgt6QAc+H1IX2BnorCI+FS/iuzN31ika6+0I18pBWXukFQSDqRIRf57olFD9KoSfAkqzAju5otmwDbePlMspamMUEUHkXJRdmRvsIrRiP/x6yQS2nq/7zbGqx9ilxgNO9VhGRp9rjkFbCAhpvUCZsoIgh2m82I7MErDxrY4VTtZM/Og01ceJXken3hHwmMtRAsyDSvnUbBf71A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(6666004)(38100700002)(186003)(15650500001)(26005)(2906002)(6512007)(83380400001)(6506007)(1076003)(36756003)(316002)(6916009)(508600001)(6486002)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/HenJFHZ/yo0lUcia+u3OBtmsNGdEtKfd+ImlEKflkhfL6nMOXmkzgheOnBH?=
 =?us-ascii?Q?HIDFsuz8F4dGfP4Tvz5KY4bWybR+rDbF0EUw95PwuI4tKGcwD6RK+2IAHdAy?=
 =?us-ascii?Q?NhGJyuhxo4S7ZptzUHSdkG/O1LPoWlUB4S2dCNnw7ugSM1HCBti39ZcO/aUH?=
 =?us-ascii?Q?ntJ0Lmv9nKo3uJicZvfc7MvddjJk3B/HS8QimAogU8+YK8b6O0Yurb1+d7/b?=
 =?us-ascii?Q?QRcm/qFjqc2d0EbEMOLn+hh1Ocz+etgDclhEG5kIcXK2SZgcYKGgRXUQos3X?=
 =?us-ascii?Q?gFvsfSU95BfHLNRpLalY3kle5W0DeoFe/6Y1f+nnuqbHBnEQt+Ez3LHVG5aY?=
 =?us-ascii?Q?XAQCMFH51xSuWr3W5tYt1y65FTU9acFgfLu1rVapyf0L/D9PYihiFzFvVHbq?=
 =?us-ascii?Q?H/TeQ1PrF9Zo1JBpLN7CmROLp4Bsiz/XHiy5/iaZnEZSk6W48aN8D6DqEChB?=
 =?us-ascii?Q?0plpMKEW68/VTloAAwYhwtfSP1me5N31Zl4tlX/msxYtG6By9KWGgm1/865o?=
 =?us-ascii?Q?JO6d1ZcCQ6YE6gU/l+OvPDKuptBu7ROVlCuCeGhSULedYJq8R3Qk996dsWcF?=
 =?us-ascii?Q?TAsMCbn8xqugRLhxtKpQonJ2SQUeX6VeO9MPtPUBL/tBmwtcQf3nBhcbIH2c?=
 =?us-ascii?Q?JPycOnOshMNbv9kWkbB+9KB2iB9cwst8/lcnHUwkq2Tpml9If8y3P/mSpiaa?=
 =?us-ascii?Q?FwAaykA4Z7bs3vqcv7NnOer+xRJ6UZDmer/dLLYWeeKWrWpoQOGanEFEVkB5?=
 =?us-ascii?Q?dz1O525tIF5uQKz6DS38zuy8SxRsO5EbDkV5AhCzJpSW6z3koGKPQbLTEIXa?=
 =?us-ascii?Q?dtMP2X9OAnKH5ZZl+S1Tmxnm85bOS8XBbmfXGQcR154v2oRN94jB3yommP1K?=
 =?us-ascii?Q?H8cpy46e0x47IeoSiRLEHN+SLmiHrM1TQasPcSHHwWAYgrnvn71U4QvgUdv/?=
 =?us-ascii?Q?YtR4/ifV5uxFCketLpw717fjFUAYFigPWOave/zNXwU5DTUxL3BxFMUxkqCw?=
 =?us-ascii?Q?/vED+GZ3vEAEm+KRLsX2Hg2iHvxHRnSy5JEwrK3WkmDw8Rr4ARdpfMI9abIS?=
 =?us-ascii?Q?OaPL5OaTuhM6FnG0tlgZqCPAYSn0pmrJ+ZdXFe0CzdWEWSVp8d+0FU13IaUK?=
 =?us-ascii?Q?uq7ua31JX3PNBFqBWsugfyQIVLeKZNrQC+cwpqbqxms9B1rmKvTaY8Z6/BsZ?=
 =?us-ascii?Q?QFU0lm5vngcpNu+DlDkUzpLfIdDoStk1MHhqcYOaWCVs338fEI7bcbyDxaIM?=
 =?us-ascii?Q?75+qWlcy2fSDaE2kzsNgU7WsQxb/5tmq8YDNMEYBJ0h6+oWjel6SZO4Rz9MB?=
 =?us-ascii?Q?4tJ/Pc0iNJ+h2LsLVDOCvAZiM+yaRCX8n7xqBeVPBHYXuu+pT/BiViivQSRB?=
 =?us-ascii?Q?vseqE/dvpMWhxGfbncBXt69IMU8qXCPwcnWZsgXll0SWVfCG+8B2tk2Bt49K?=
 =?us-ascii?Q?uPvTRR7YsMMvZCU1gvAQGMOX+OsAt5GakN80SFeEhtT8CT5CnOofqI5k7Ou7?=
 =?us-ascii?Q?oqkWWvEzZDewduNxhXyBLwpIVM5f0XYU27G7Wo0A3oC9CWvKMWj3s4OUysO5?=
 =?us-ascii?Q?MwoymsdCsDP+JwST4eVfF0lhbLN/B4o/H5MKKw6R6E5I/mgU/DlaSvLrg4Z8?=
 =?us-ascii?Q?qQlWL2P6qH0N55iWOmxxRID5OmEVfV/Ts35egZBTTNZL8j7A+SanmWFLU8gv?=
 =?us-ascii?Q?njLCHNkMAw1slRhDqtIpOpM1FMJJ7SYx/KXi9uJaMr4MqcALEx5vYYX5dL1X?=
 =?us-ascii?Q?kiHm3DrTPw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cd679f-b1b0-4d5b-47ed-08da18699354
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:14.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2zwra34EPaoOFStL59LyvQTVQ6gn8/z+xikRyYZvyn+5Jh/uxcM2k4qy5NwbjtcGQDJUqCofX9FzyRvIyEuFQ==
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

For better error reporting to user space, add extack messages when mpls
action offload fails.

Example:

 # echo 1 > /sys/kernel/tracing/events/netlink/netlink_extack/enable

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action mpls dec_ttl
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-182     [000] b..1.    18.693915: netlink_extack: msg=act_mpls: Offload not supported when "dec_ttl" option is used
       tc-182     [000] .....    18.693921: netlink_extack: msg=cls_matchall: Failed to setup flow action

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/act_mpls.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 23fcfa5605df..adabeccb63e1 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -411,7 +411,14 @@ static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
 			entry->mpls_mangle.bos = tcf_mpls_bos(act);
 			entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 			break;
+		case TCA_MPLS_ACT_DEC_TTL:
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"dec_ttl\" option is used");
+			return -EOPNOTSUPP;
+		case TCA_MPLS_ACT_MAC_PUSH:
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"mac_push\" option is used");
+			return -EOPNOTSUPP;
 		default:
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported MPLS mode offload");
 			return -EOPNOTSUPP;
 		}
 		*index_inc = 1;
-- 
2.33.1

