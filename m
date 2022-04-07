Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C524F77C1
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbiDGHkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241955AbiDGHkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1598960AA2
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq+Hz3KPbJnlDfD046Z12TwHWJAyWCF9hbhb1eSbruB1aEwsIs5c8mRQK20pONRnAb4sY+qUm2EoPnes7CQBPxRz7CmBq7PYaiaibA8RJu/XOUiNKT6ivzIAepB8WitmRAU97L95M6WddxAbJiMvyfg14c9IKeUGPf53VmVpS5z69Owba85l1/t8p7NIk8ylPXCsO/IgSweovB8285sR6LnY93ZJZEKgROEht/CYF07aqi91/Kis0a0FAlHV8A/AMb9gX0J2IbKGnAABj7hTBmXlGEqewbXRlN+ZibUbFfICoL84AZX4fjA7VU2VOpB5N+NlUIK+e4vuwkY28SO4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nAZG333hjG0276Ol3cCgvy1+Bj8+2QtMaM1S5Zt6YA=;
 b=dyAKr0hG+RRKrayFolgiZyJZ6x7upWJSh3NUZsZhdA9dZGLH9GgTIWkXRiU/6HjSUIr71hoV3Xc4nfVODAWiBjJK1Pqpk+ZzSkHV0jvFsyVCtYqyLXQZGjGhUv3tMhb5cX2c9L0bZPvhL1DfMbRhgDGoKP5SBASE/LaAkMMUJONkIyH8S2y9yjJavw/HlRBPvCXgrv9G85OVOWHh3MEOF1k+69AjL85wnwHvQBvPOKAA66NIz1PBA3Yi6YsY/HWSguoWlwVpssFjbqRad3mAEax9U1OD5y1oFL2h/UyejbfmYno69sUWhF9eBe98WCMcST3FNCAWxnyVhEjI69gjLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nAZG333hjG0276Ol3cCgvy1+Bj8+2QtMaM1S5Zt6YA=;
 b=l8C6KXbU2txfEu5EbDbUmuYp7QFi45x2pYnzV/ATrq5m3mnG9JY/Q5SrI8f+uLy7JZH1KyJfhPFEfAhZ2h1G2msSmrXig1rG7H3c4XiuUmnBSptSHsIfLgVQXxut3c6arvZrDYgZ0LCK3JwXOJptcyqcK0wqBTACdgbKiQ6rpK9vE9191FxXOBz5fgIVnsiGRmM3CZMQywnzBnI3gqzEtK1pSobn++NlqmnV56YwJbTmAF6d4yLSRixneYZMJbBPoqYl6G86YJeo5ogaOOQyBLXuD9/j1B1LNfV2Y5R9klU9ounaxBrMqiozdAPpW7XkGvO6nQ9u3zxuNOjaEFePxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:38:03 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/14] net/sched: act_gact: Add extack messages for offload failure
Date:   Thu,  7 Apr 2022 10:35:23 +0300
Message-Id: <20220407073533.2422896-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0200.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8079f5de-f391-4fb7-241c-08da18698c8d
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01887A2557B3351270AFE71BB2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRmjfTcBaS+uqNYCB85uxy1CCm9a/Ac3jhBtFaqE2B+yLVTn2kshlaThKf+fODwD4G/Nz3OIQ53EnslrsNUSfPb8WzQuKU3xC2wZzeVmzVqkEy2PmExWLnt5Wvco+IUaGQQeThH06NsPRra2xyWemYIfUjDGhbFNityC3KFLJVrklTwNQxtLQyiUh3+xWtPgq3NPwpFK1ouf2fRigO0byA0WVOQJKYrHz/wAyAw5KglQYS+lyyUzlm+9xBLGGRQHG4dk3M4PKrnbW05KVaY952ZB6y+Av9y/scy3VdzcGTDLFiCsA9kPg15eaEkWB37qm5jkhspbe1ykO0ssFFW2dUepO9g5bcL2cmJy/r6USv6ig1fNhLMEDg2JTr21TVptgcRLnrRgm9ZJzc01LhmazKUBm52MqPlPO+S8DIgqO+qGEepKLt5Sd8uXwY23aoo+BJpIgE2dVyEDj7hrcgDeicbjdiyTMajZsHc+StrAP1z63G5vcUOBKc055fPFyGi9n/l+k8sDbmeAiAx3XjmdqRDPTon+K6dpDkz+gwAYj7a9X/xExl9ylvkWiZ5h9Mu7WLn1Qwdv7BT+J/3/c5jGpq6RA5MJmRVH1kluEV6jezy9oP0Z7bAM2caeDJb2jbAH3OsWVJ5nciZopwQD+yLfRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(6666004)(38100700002)(186003)(15650500001)(26005)(2906002)(6512007)(83380400001)(6506007)(1076003)(36756003)(316002)(6916009)(508600001)(6486002)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1J3yIKK53ma33bnp/8gvV5jXsgcP6BsllCn/tXVAcU3ajdW6lMhTVTI1Dhoa?=
 =?us-ascii?Q?KYfAc9jqKX1strDbSPazLIelGKDYhjWRpiCNKpIu7v8tmcgfVNs15A8JemxF?=
 =?us-ascii?Q?uYF2JhS4aOCkdc8WGMSPnv5iW0MeSVjD/0PNdoMqWUNu5l8SXY3opojOkZ/o?=
 =?us-ascii?Q?m8kToqb/FrC1M1Kz4BqpkEU9cs5YG1zkIuumSAh5tqOzibOhQz4n9FVc7rKa?=
 =?us-ascii?Q?DnkWZylsYjFVewcUnWv9J49wacwAYRv14hAATF1Ueb/lGavY/s9VVWB0xkgT?=
 =?us-ascii?Q?h/xv4PlzfNAuq78GQMw4guRHY+I3+odmnKkx/hL0Y4eEeEkbIYiOWEzRhsoC?=
 =?us-ascii?Q?IjVBpz+J3uof80Tmws5lrwG8VgBj5Bn864zrLE1lKsVYNMMsv6v0DVMpU83U?=
 =?us-ascii?Q?HFUM6480zjnQesbeQdXKJy/TYFVcFQhSrhPg7aVGzB98QyKFCsqf3wxgt1QP?=
 =?us-ascii?Q?CjDKsOUYj7ErGyJwPfThx02VP5SgIEvrTPh4SV50Nx5EMAq3T3jSh0s3929g?=
 =?us-ascii?Q?TMi6if6X/a42Xh3ER6c2T3q5O9JKaErvsRbbXlr3ErC/Gfa4JFB10mcjzmKx?=
 =?us-ascii?Q?EMY5sqvU3JCmA1qaddYq+w0pF1K/ZnHD45xAvTZJ5anpqqu/Ridvsk6V6Zlq?=
 =?us-ascii?Q?ICAAkE/IGO9GGlsXjxesz401hfW1jO4T2XCw7On2Gmhl/71u/jizHComDwsm?=
 =?us-ascii?Q?/c4oQ56HdGw2BJK0qA3t5MBy/GYA2XBHyULveDyFmc16g33V7FNMsGQGjSDh?=
 =?us-ascii?Q?UHqZugS4TBFPLjn22cTILBx/4taue0XeaXt9gQK8hDZk4pCUNZyrq+b6NIqm?=
 =?us-ascii?Q?puWezilk/LEsT3QvH2H25cPWxs0ft2tvFTGPde67jH7MZzJMfli5DxOFxjc0?=
 =?us-ascii?Q?vfalZgymTWXehYHxmCDFXjXrsgbBC0evPTeJpDPreGcSVmXFVHU70mWgGq2R?=
 =?us-ascii?Q?gDXIclmpU1H6h8aLPf+03iPoCsdAXKiRDbYjsgZsIX8gPoJgESNgcAE77avg?=
 =?us-ascii?Q?tQUamEwd6NHk0moxQMMOLldljKLiXnX3qb7TisZ52PeNqhbLVvRM7y4wul1C?=
 =?us-ascii?Q?zdTz3n7HLNt7FirDF2kj5pO3k6QxJ4bggx97ALu6Xna0LwnKQqzQT3hUUK4q?=
 =?us-ascii?Q?r4YwxqYsBoSRHPKDntSKWIQ4a51Z83fnF6rqdb+WKWBZHj82hG9gdQX36cy/?=
 =?us-ascii?Q?I7//9IvDzhb24lpGmWk7HLmKTErqdSn0jyOx/WbiUDKTCx6I/0I4V9QaTsWi?=
 =?us-ascii?Q?P9pT4Tj5AlQTgoM2wFKN+sAlFYaneOkXMcF3RF5Euh+pUwlYD0eQb7kX8XWI?=
 =?us-ascii?Q?yPD94q6OZyKg+cGa3OyNdncBvEJqE3Lukgucns88t2Q9sIfHeILbIKWvdLZq?=
 =?us-ascii?Q?qnFXgTTkzCceK5chVpuaHY4fdxWGu43N+6dGCKatv+4Rm6J3cWj4nxQvlRi+?=
 =?us-ascii?Q?FBH6Fry2084969ToyLdwKvvuzkaky99ZoaMOzK9/ApWI+4/cacVc6ahpCgZ3?=
 =?us-ascii?Q?qZQ6U/vFK2Mhz8bxfa9KCAqC376YFM0FhPGjsa+fPoN7XRo2IywZOBtwv7IZ?=
 =?us-ascii?Q?h5Mtef3Z2atSrQhSPCkHd9Lw7LGtYC9AjOOXsVevUb+1++0LKr+WIMfx0P8j?=
 =?us-ascii?Q?MH8LCYgURPbZv8TOeVU16nfagIojwpznsLI8+VUcIogQaT0KucdlYe60sgXl?=
 =?us-ascii?Q?oUufVYn8XYNbfKmo0yeleppH/VGSBI0aqTL/fV62frDHSU1F9hfdWWKK6vTJ?=
 =?us-ascii?Q?n4Yjf5T+1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8079f5de-f391-4fb7-241c-08da18698c8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:03.5976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFHlrcDxJntzWrupLMDiyIcVrutfmMI++SggldCROqZwPcpoJIcY2eIb/VQ8lAmGQ1TiHVqFqi9vtYCGUDoG8w==
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

For better error reporting to user space, add extack messages when gact
action offload fails.

Example:

 # echo 1 > /sys/kernel/tracing/events/netlink/netlink_extack/enable

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action continue
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-181     [002] b..1.   105.493450: netlink_extack: msg=act_gact: Offload of "continue" action is not supported
       tc-181     [002] .....   105.493466: netlink_extack: msg=cls_matchall: Failed to setup flow action

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action reclassify
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-183     [002] b..1.   124.126477: netlink_extack: msg=act_gact: Offload of "reclassify" action is not supported
       tc-183     [002] .....   124.126489: netlink_extack: msg=cls_matchall: Failed to setup flow action

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action pipe action drop
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-185     [002] b..1.   137.097791: netlink_extack: msg=act_gact: Offload of "pipe" action is not supported
       tc-185     [002] .....   137.097804: netlink_extack: msg=cls_matchall: Failed to setup flow action

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 include/net/tc_act/tc_gact.h | 15 +++++++++++++++
 net/sched/act_gact.c         | 10 ++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/net/tc_act/tc_gact.h b/include/net/tc_act/tc_gact.h
index eb8f01c819e6..832efd40e023 100644
--- a/include/net/tc_act/tc_gact.h
+++ b/include/net/tc_act/tc_gact.h
@@ -59,4 +59,19 @@ static inline u32 tcf_gact_goto_chain_index(const struct tc_action *a)
 	return READ_ONCE(a->tcfa_action) & TC_ACT_EXT_VAL_MASK;
 }
 
+static inline bool is_tcf_gact_continue(const struct tc_action *a)
+{
+	return __is_tcf_gact_act(a, TC_ACT_UNSPEC, false);
+}
+
+static inline bool is_tcf_gact_reclassify(const struct tc_action *a)
+{
+	return __is_tcf_gact_act(a, TC_ACT_RECLASSIFY, false);
+}
+
+static inline bool is_tcf_gact_pipe(const struct tc_action *a)
+{
+	return __is_tcf_gact_act(a, TC_ACT_PIPE, false);
+}
+
 #endif /* __NET_TC_GACT_H */
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index db84a0473cc1..ac29d1065232 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -268,7 +268,17 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 		} else if (is_tcf_gact_goto_chain(act)) {
 			entry->id = FLOW_ACTION_GOTO;
 			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else if (is_tcf_gact_continue(act)) {
+			NL_SET_ERR_MSG_MOD(extack, "Offload of \"continue\" action is not supported");
+			return -EOPNOTSUPP;
+		} else if (is_tcf_gact_reclassify(act)) {
+			NL_SET_ERR_MSG_MOD(extack, "Offload of \"reclassify\" action is not supported");
+			return -EOPNOTSUPP;
+		} else if (is_tcf_gact_pipe(act)) {
+			NL_SET_ERR_MSG_MOD(extack, "Offload of \"pipe\" action is not supported");
+			return -EOPNOTSUPP;
 		} else {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported generic action offload");
 			return -EOPNOTSUPP;
 		}
 		*index_inc = 1;
-- 
2.33.1

