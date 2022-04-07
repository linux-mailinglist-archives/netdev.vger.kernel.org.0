Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4438F4F77BF
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbiDGHki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241963AbiDGHkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:36 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF41140F6
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbdBJg6Xt0xtpp1Wn/Tihbc5O164tHbqyGu6oGJFIa+NWoUEof3sLy/Dl2R4nNOBKu57MHA5nm7RYgkqhhvff9DVTIr0QMHuudd//7N82nMP8uyKFv7eAi62UrVP4/0GDD9U2AEZV/noDFx/gM3VK2erCTE0+OEaW6/gYQb9K8BX88y7b5H7fHCw1GbDGbt82aEkTT443SxXOL4dZHnGzUCXmr7S1qMxmtiirwGm2oBX+hXd/RCY627rRTqkobF8AaFr36N/OHfDkbplqGcmwPmoPcBCBRipLt7XIL4A7Jt7h1U/nbyJOaXsKZotKVRzYjWobkpZCRfUorOLlxEf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOIgWLiMoMWEX+/rAF+HJkpjK8UaxXXLfSGPxEs8ZxM=;
 b=XxdlexmlWiMN3GA32vyO6kAPh64eei03+QJpByfjjH6GEdcwxxO6uXN8DH/BFJ3fFNOwnnopKF10bh3erVZfE5z/jc8DAVKrWhWi05f8h9fmngjKSTz2bWvI3nvBCCgxuXacrmdzS0J0PthxcxY6NP5Uy2IxNbJSkRUbVar7Ho39sGQjroSoaCfFMUjFLTurGVIEL34r2rBxZl+c0a2IZKMvLtx9jV6r0iivVZVgtHGITPcYzEoExbAO4vdPKmWYdzrsKuK0B3gnHo79pFTlxe5kNXse7P5FxPaVpyocoBRn5dbnCVp9Ct7kdULjB8SOdnI0eCH3EKHP/ddrQiJc/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOIgWLiMoMWEX+/rAF+HJkpjK8UaxXXLfSGPxEs8ZxM=;
 b=WStGebXUyUcBLu8sIRP25U/HUwkxj3G6HXrEuYwKJCBTJgpY6xRu3Vuql8Y0NPNyhdwPMAMvtGFdTNn1RvX9koKoa5PTF2KGEJs1ICbmQKtGQCsGbtnO8CBu0O14iqRYOvjHiMJsQODlCdhRkhwHy4bGxzznJcnVZImxZxlanhsljrdDU72EwJ9peO5s1ocAwr2kxNeukwXGMhDnp81FNWiXrE7YhcTP8bnXdayjNzZs4o462BEGmie9Q4EWvhEh6DOUmR9KjwE1TVKvETpN13QAEGxksxfrk2u5K4GuzR4VsLn8Mqck5HA1NiS2k4R5BHiYdhJet+OuNZFiDYFsZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:38:33 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/14] net/sched: act_skbedit: Add extack messages for offload failure
Date:   Thu,  7 Apr 2022 10:35:28 +0300
Message-Id: <20220407073533.2422896-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0017.eurprd05.prod.outlook.com
 (2603:10a6:803:1::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d7711d6-0464-4c4d-7a67-08da18699e01
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB52289E016408B1E7FB98E025B2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNdSziuJRBJYS2KcnzFK1ITSgiP2AU5ODEIvLk334/zzxFSf1Qa1Ei0Vxu7TmjhXejzM3NlvGqxLOzRHfDS815dkas/HNbTTMoxmQhvzmEgursjk88HIXBaWhY2GSxvHucSXFQO1FZpDpoPRUW4Iw4IGfEE1zfdVs38F6ySOcnyOuyy1Cut3IbmlfAMEY230Chr1/al45bofUZiYd0r95LWfD0NC2JsCezcr6iE5gPbbzc6ZugzKAG2hsTtpqK0l9LiUn8WNcT3bShQpimqH6XvFsC3ugV8a8OvWI3klh1GJtivCQ/4EDwdnKW3q12zZpZjViCwrb7lYgr4cV/saBJbyvk0J1pbEaOYosZNphmxPvITs5lRBO4pfIo4V3a3rsyIZI3Qz6alQKyo8p3fLBCPLbkbjwZGb2V93tRFNw2KDuzmMzlMn1tAWo+cCfjrrhNdPVP5BJFWb05KQi+4yGEKuJ670MJXoqHw/pdwB15CCcFZmqA8AgE/9mYMzZvucPAjNQhDqcXUX0n2M3jM92AglPDZ4kTZ9oDuHKCNgJwF+L9/iQkMebvIWZUohwjJQNHXrlLTEfkROQeGg+YxTpvr5fJv706zzDqmBbOwqVy5KPtvVqpiZKSS6l8/LYcavBMl6uI0zm47PhzhA956Nyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oaYu/5t6u0juLOY91dyOUKeYSR1oArVLaTbj+mgAjUvpkkGXDOJcVAst7RZd?=
 =?us-ascii?Q?gHUhF5VZeBTW7Hat7gozGr2W82a7BUo47+a9xdEi8mlONdGb2eX9QOX3mZWO?=
 =?us-ascii?Q?JPJFTPWZfUiyWAy+NlARHZgMLvDQjdtoYURF9z9qXCIAkQ52qJmvRRAZC98D?=
 =?us-ascii?Q?WEVYJFlgkPiz6X29cQKW3l8+heHx064Jpft8leFd3s+cmJbeOIsycNdaCzIH?=
 =?us-ascii?Q?tLdo2m39NcxGn4u1nH0MbThLpIGFm3xR3N/iWu92mrhrw9yPsk5+ExqDt7PD?=
 =?us-ascii?Q?7MIjZbC97Uq/ZANFylSjy3Oac4nAgPv2h+jM/gSAq4aqYi/ZAUEsAk4UNU7W?=
 =?us-ascii?Q?esDv8ratm3aWjkRIKJftrSaO6dA6EpKXgo5aC+20UniJw26ouX/zjb5tc8tC?=
 =?us-ascii?Q?iG2AIA+qowiSQv7hvH+TPj82HuuqjqiepJJPVhj+AuLOK+TNp3YTEMyz8UJ1?=
 =?us-ascii?Q?OIuydIFriOUSHuK05PAEv3zAKafvbkRpjCJppn2poT8wkx6q0tfDIkjpULpn?=
 =?us-ascii?Q?WVfgcZ18g2wo0OD/DHXkTMiVAyQwnqwJSH0d6JYNGulNPGmoT2cYpp20Gh+F?=
 =?us-ascii?Q?EWNFdsuWDE+P0mP4NSmEcmJ3NF+qcAhPRVp6tuBM0wm84TxO3t1GGqhM0fuu?=
 =?us-ascii?Q?3ZvAlEyAPDspO76Mu5b1Y01LEdrDuOul78uz+DvwVXJUwW066+H/sQOMc09G?=
 =?us-ascii?Q?727ZZC9BkSZpE3HEMRmP+m/XNtn0Eku5izSJhdw3ani1Wem2GhLEzYVTXIrw?=
 =?us-ascii?Q?rM2+FViNE/Wt3G2j9uG0Pw6eTMVXk/udj90DW0LNQ3kv16C+b2BphG8Hal06?=
 =?us-ascii?Q?um6EoPvetngIdh36IhErmizsdsM/qsxlhMleYcN3i7u4XKM8Wz6s9wDBKDbD?=
 =?us-ascii?Q?soyE6m2sTUsqgCux9yz+G8Dbgz3lXWxvE3IGIVB0Rj8Hr7v8QD+ulA2z3Dlt?=
 =?us-ascii?Q?QLTTsmErXWjuAEe24E1dc76W0dEssVQUqQzT3wtYlb7sXVuZSpUOjqQLBpMM?=
 =?us-ascii?Q?SPIFIuCf3Cp/ycxq4CSLhpZ0uBqhcL0xLsu+TM450eiONeWGu9pCt3SVgRCK?=
 =?us-ascii?Q?PURzyZfvaIuZVcvU2TsbeMZbGaFVrhYK5lQ8GSy/ueQQ3uuVry/iOu6fHKLn?=
 =?us-ascii?Q?g3w/dOmmB/pUmxoUoMuhGmDkNiYHbHFcWS4oOrKjbpFIjW8H4Vu5aFnaY2bn?=
 =?us-ascii?Q?MEkpS/pYJTICaTWK1OMUW16SVGulZX67/LnN5Dc8283b8zcTTS3jHJrUAvjl?=
 =?us-ascii?Q?1/grYqAskOKKMHEy8MiT0wa+vfzfTJLqSi4lHjoyypauTkN4Q4NU62/n3TLM?=
 =?us-ascii?Q?OtAndSnYGY/kABbucSRufCGg1emuSxP4L/4Leca7nu56HCUt6OBOQJoB/XP0?=
 =?us-ascii?Q?kJAh2wFPzKfNaTLd0my93GyayRqoegMfxTNCWmMQIluRe2Np7PQJFi6zFBO9?=
 =?us-ascii?Q?S+nSVoR6IJiGZTS8oE3VJIttT4ohJZQWp85FuTyTkF9WjeSjWNT28BebDO2b?=
 =?us-ascii?Q?rZKBN9n0My4m7GfkBCdtJK7+6xTCIs0niWMpClug//hz1jyu30kiBUPQCcLs?=
 =?us-ascii?Q?SIjwWqw26hNvsNWHmLHQIwJWQjkZxeDDscSdicMVnHw31Ziw818VLrYQiNiX?=
 =?us-ascii?Q?b9vQWEmRiG+7OqHkYbHXB3nSH7C6d7kS/840+jAnFutddUISTpHZDAZoG36H?=
 =?us-ascii?Q?v/T4REcanJd3nT5qF6Yq+8eLRqvsE1nJBXzEUysIfuKk9rffF+NoZn9sz6Tn?=
 =?us-ascii?Q?WzdhGQ+vEg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7711d6-0464-4c4d-7a67-08da18699e01
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:33.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zp3WV0f4riRMj5uRGwb9o2WtR18aMj/bfedX4ReaUDjidIZKJt8dCgyiwmnSusWdno8geW24doDBEGhP3ZGfUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5228
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
skbedit action offload fails.

Example:

 # echo 1 > /sys/kernel/tracing/events/netlink/netlink_extack/enable

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action skbedit queue_mapping 1234
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-185     [002] b..1.    31.802414: netlink_extack: msg=act_skbedit: Offload not supported when "queue_mapping" option is used
       tc-185     [002] .....    31.802418: netlink_extack: msg=cls_matchall: Failed to setup flow action

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action skbedit inheritdsfield
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-187     [002] b..1.    45.985145: netlink_extack: msg=act_skbedit: Offload not supported when "inheritdsfield" option is used
       tc-187     [002] .....    45.985160: netlink_extack: msg=cls_matchall: Failed to setup flow action

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 include/net/tc_act/tc_skbedit.h | 12 ++++++++++++
 net/sched/act_skbedit.c         |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index 00bfee70609e..cab8229b9bed 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -94,4 +94,16 @@ static inline u32 tcf_skbedit_priority(const struct tc_action *a)
 	return priority;
 }
 
+/* Return true iff action is queue_mapping */
+static inline bool is_tcf_skbedit_queue_mapping(const struct tc_action *a)
+{
+	return is_tcf_skbedit_with_flag(a, SKBEDIT_F_QUEUE_MAPPING);
+}
+
+/* Return true iff action is inheritdsfield */
+static inline bool is_tcf_skbedit_inheritdsfield(const struct tc_action *a)
+{
+	return is_tcf_skbedit_with_flag(a, SKBEDIT_F_INHERITDSFIELD);
+}
+
 #endif /* __NET_TC_SKBEDIT_H */
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 8cd8e506c9c9..92d0dc754207 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -343,7 +343,14 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
 		} else if (is_tcf_skbedit_priority(act)) {
 			entry->id = FLOW_ACTION_PRIORITY;
 			entry->priority = tcf_skbedit_priority(act);
+		} else if (is_tcf_skbedit_queue_mapping(act)) {
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"queue_mapping\" option is used");
+			return -EOPNOTSUPP;
+		} else if (is_tcf_skbedit_inheritdsfield(act)) {
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"inheritdsfield\" option is used");
+			return -EOPNOTSUPP;
 		} else {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported skbedit option offload");
 			return -EOPNOTSUPP;
 		}
 		*index_inc = 1;
-- 
2.33.1

