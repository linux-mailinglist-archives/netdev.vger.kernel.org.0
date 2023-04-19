Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFB6E7E6B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjDSPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjDSPgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:36:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304434C1E
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuoQwUdxH4ONsferpAUYjQMZM2UOpiO9bzL+qLWaD795bAauNpO5gUCwrEXToQ6dkJs5FI/FwAOndyiJigR0oDw4B3+Lt2PMEgmbQWrks3WvIpIVJX4Ox8+cfv4hFeE95FqGMdy5XzgPFjhU+HYbWULlUGlueA4wpJfbpWcwu6CvDuWpS8LMNlxqwyXdzj9LrmDWSucmwFPXKWr8LdD4/9AW6IEmxIk2dGcAvBQp6gkcdV8UpryU8Xis+JiwCx7tIBQeTQ28tXjwoHJH+ZwnBtCwJ/i155zJKQFywmHcwQhqwdGdvCE7/RvHtlCORWKOrr3XpPlPUYzoUzUT6xtEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGiHTPuD//V83hBeK/0kqBvdMWAAjILZAz+t5SR6Z5c=;
 b=GjWnGwui5DjJLc24FzLSB6fRjeQp865fYgv0VbKBO/f/siyxrNNRv5RQbs9mkl34zGm1nSjNavKm3opt5GYNiIbN/8LdWL6U1Fc3p2qScmDQRmm2VBDHufbk7fV7t6FESfKMKp7MKK8TaS3MCcFd2iNBeNwkPQqOibiVGe+0jlOYrfgXsw4vS/VYsiwx4sNH2um7PYzkPml2XkvYLjzSeB+YXsOfewJffBNxY7ql9DmgghQrEek+vj5zXKtFjOr6hfEze/Brwm9gFI2NRrB9tnCuVZ0vhqJMW5/f7/2puCFRBKHUcrTu4T8V15bZJPtyzL7VjcOtKZdzPSGhLDXU8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGiHTPuD//V83hBeK/0kqBvdMWAAjILZAz+t5SR6Z5c=;
 b=FC8lcD1hudVaWVu1m6LzxtTcPiCGHJWji0wJfjtpJNe5xWSiGjXTlPkhe7oRHl9P9WSMVjzowpTd9Jx/pkW8FnuSlsr7uW3GBk9T1TY3BcuUZdqsGDS7bChNJnBI87sgRDIg1frwJ7fICeZUq85eIw4iyindRem6Leoj3IHo+SrAvk18U6GmUWhkQcXct+tGfJsGRx2mmQeWw9ykNcFpWwXA78+4qJ0YwGTyz90+OtcC2F/wJRHstCE2gjXTC+53Zj9Djjhmr45Vp1hXbXeRyjLsketnRUaJRV6kZx9cCK3Gd4ApIs90jcRaRnbWMqrI/KxY7u8jV8s68WHkpGgBAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB7623.namprd12.prod.outlook.com (2603:10b6:8:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 15:36:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:36:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 8/9] bridge: Allow setting per-{Port, VLAN} neighbor suppression state
Date:   Wed, 19 Apr 2023 18:34:59 +0300
Message-Id: <20230419153500.2655036-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230419153500.2655036-1-idosch@nvidia.com>
References: <20230419153500.2655036-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0009.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: e5bd8e95-9776-478b-4a19-08db40ebdcbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUAl3Bq2N7CmW1wCHz1ZRgq8JZsZM39+D474JqPK4dXVl3QbMLDshSOGC5AcBT/m0Pj32FP4rNxYPZwD7JhSTzH+Va1JLBkpXR93hEaIHDeRlrk89bay9Dbcj3avjAdMrc7wfG/bjwpXwcy4fbEqEntLpPczI4hCTAufIC5mZFLTIaUKboI+iNkCUBoTdvOfjOU+57xH9Qgw3r21FBEc7+AU4rM3COgic2VkEeqkt7BDRPHRHBBEC5PPapDnhsAbUi9PuH1YACgqbIVWGVK9fkp0tq2XujTYrvPUrIFm/AIEWl0/rCyhLkmYbxmk4dP6JXn2/y2qzQpSDUNUY7Iaz6V2b8xNq8B/72EDutcFccnhBYHTUcT7z9Unvnj57CJGEdgzozvkWfUkuBhatYJvfSklj0WImEM0dTZfu3wW+9+OnOnEUGjIlN7EHI1O86EYBGhwnZHV9ioiUdtYhMFj2raBuAvCftjlzWt6D9wP3NXHEuiFENaMG1nNaKeDxDKuPljyGZf/ycW/MW5v+0tmLqrkF0TsNkEms0JH6h+ArM1ssBTRTlT3ktfPyW6mqbw2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(2906002)(8936002)(38100700002)(8676002)(5660300002)(36756003)(41300700001)(86362001)(6486002)(6666004)(107886003)(6512007)(6506007)(1076003)(26005)(478600001)(2616005)(83380400001)(186003)(316002)(66946007)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m8EwoyNrDxJODDXiNv6+7zTzp3cxj6rWgwN6rTi7wCfQ8UO2RodLVa4Xwx7Q?=
 =?us-ascii?Q?SXdPByYPb+8cvYo3b7GI5W+Oe4MKUSCwldnWXn5K4iZ4OBlWrKxvR8dQAU3U?=
 =?us-ascii?Q?EUWpbErrr+qkPPwZu2b0e1jBzUgu11oRWmxQ/ntkWYbJeK+rd2V8l8kpEGrG?=
 =?us-ascii?Q?CdwGngEKJ9cJDkV7XiAckpcqGzc5ADw+0CW0EYcl8GOpeoiom6FxrkfVoP2U?=
 =?us-ascii?Q?BRx5d4g3inFSY/vpONGrKt6xovHkPsKZvz7QCF6Ji3fFNRPB6CzqK25SGU7o?=
 =?us-ascii?Q?IzEVGEQgDi4UNFlnF4vBGRuz1Qz/GTgHEpOoCABgsHAlbUhmogiOwlnpvGz2?=
 =?us-ascii?Q?WXe77f+5JqUyHidSn4HL5bSkTYwU/egDTYggWX9kAClv8CNRvrcHQZBs7Mz+?=
 =?us-ascii?Q?D+zkKC31lhDDNA5l/JeyhvbmXAVJNKTXIJsF2UcsIrMlay2EfIBqHCXNH9UI?=
 =?us-ascii?Q?UBg9QQQdozIhrSw45QT0L1VUBeXv2keoomjYKEd7cHeUatOZUsapFgI3Igz5?=
 =?us-ascii?Q?aylQ3tzK34GtSna0U8lYMYAgkybMppzJIe/veUlMD+oTbqMr8yR7Za0vI4qV?=
 =?us-ascii?Q?Q36SL1IOTDCuzh6ibkibk6+eZY0QsyR0yqdFR9jUqKStdCHKCxTPhE4cfHJY?=
 =?us-ascii?Q?OJdAbdqD7pl0IFxM91Q3nKNyU6YrFSFg7SFMRRw+riw09PJmf/quxiiAbqNH?=
 =?us-ascii?Q?SxMAHn/AXBjCvD5skxB5Ijy1z9/ffwqgNefckBpqN8ewSwZJqez1T4+ndzdM?=
 =?us-ascii?Q?rxp/sNkFcKbjO3eXM6dK+EFre6mcpHhlZm4LdK69hCCFQS0rfTfKTNPOUzGL?=
 =?us-ascii?Q?fLtX7PvRXBB77mjjPkK5hIDpIgwY6vfVKiWPFsYlxawe3q8LFyuOjcM4jh0m?=
 =?us-ascii?Q?WyB9zK1b28xV6nxIQvmiWQ4SpBaUNyAI6yQGJlA9eUvs989JEePEeK4P2TH0?=
 =?us-ascii?Q?MYDYc4+Ccb2kZdLzjEhoMAFEqNcQB3W0qXAvkj8IyeWvoE0wQ9hXkDIPcubo?=
 =?us-ascii?Q?BvsybK/ev69u703tGSi+a46guCpiivcYOQIdLyDehOGwgegfV1pWdKFT3lRO?=
 =?us-ascii?Q?rP65wT05AqaEpEdBXhymj6fAhdsFYo2NX1zJyJjKY1maghNyVyLjPhysLI19?=
 =?us-ascii?Q?R2nwoSnmBVUbfOUn2bY2c1PJJBEI92wKO38EK2LeuZt7qive/AXBLX20yiIH?=
 =?us-ascii?Q?SA5KvSRvlKribR3XaXORtZlk77JPm8wU/qEzCw0b05moaZSxa7Ue38NHfmDN?=
 =?us-ascii?Q?vTSjXZKanANJgpPt8cC/emasc6EJhI+SzvQZxuJes43t0B3/xE8yiP/v/3QN?=
 =?us-ascii?Q?lNJZQ8hnuumIhcRW83vm0iLPoLR7IXb30UJW/3/EmckBzX1liBEELqrqInSO?=
 =?us-ascii?Q?0HwIZyYJjWGOiVkNQUIj8idB+qhrLt6XJG9Q/JBOizYCz75UPIEX3qOj9YYa?=
 =?us-ascii?Q?WNvkzL+UaUfqdARqIMbQXkn4TAryBQdmhuopRnsvjF/MSAKTU5w96Ak2EhgE?=
 =?us-ascii?Q?vCQ93znBc6jEyvc3RgN4kw5LpnvMnwH2Nf/RS3c3eTwkYNSGP7i6DPr2WLhH?=
 =?us-ascii?Q?5GZe6U4QRFsVaDMlLpBDUm2CAoma2jQcva3ZTqz9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bd8e95-9776-478b-4a19-08db40ebdcbb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:36:37.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YprNUufC+i99dHxH3czz/7TXY2/KFzzWjz1ft/8sb9Sk+BUs4VsMIymN9nMt0UISizmR5coT9kTjYJ37l3QKwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7623
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

Add a new bridge port attribute that allows user space to enable
per-{Port, VLAN} neighbor suppression. Example:

 # bridge -d -j -p link show dev swp1 | jq '.[]["neigh_vlan_suppress"]'
 false
 # bridge link set dev swp1 neigh_vlan_suppress on
 # bridge -d -j -p link show dev swp1 | jq '.[]["neigh_vlan_suppress"]'
 true
 # bridge link set dev swp1 neigh_vlan_suppress off
 # bridge -d -j -p link show dev swp1 | jq '.[]["neigh_vlan_suppress"]'
 false

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_link.h | 1 +
 net/bridge/br_netlink.c      | 8 +++++++-
 net/core/rtnetlink.c         | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8d679688efe0..4ac1000b0ef2 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -569,6 +569,7 @@ enum {
 	IFLA_BRPORT_MAB,
 	IFLA_BRPORT_MCAST_N_GROUPS,
 	IFLA_BRPORT_MCAST_MAX_GROUPS,
+	IFLA_BRPORT_NEIGH_VLAN_SUPPRESS,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index fefb1c0e248b..05c5863d2e20 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -189,6 +189,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(1)	/* IFLA_BRPORT_ISOLATED */
 		+ nla_total_size(1)	/* IFLA_BRPORT_LOCKED */
 		+ nla_total_size(1)	/* IFLA_BRPORT_MAB */
+		+ nla_total_size(1)	/* IFLA_BRPORT_NEIGH_VLAN_SUPPRESS */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_ROOT_ID */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_BRIDGE_ID */
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_DESIGNATED_PORT */
@@ -278,7 +279,9 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_LOCKED, !!(p->flags & BR_PORT_LOCKED)) ||
-	    nla_put_u8(skb, IFLA_BRPORT_MAB, !!(p->flags & BR_PORT_MAB)))
+	    nla_put_u8(skb, IFLA_BRPORT_MAB, !!(p->flags & BR_PORT_MAB)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_NEIGH_VLAN_SUPPRESS,
+		       !!(p->flags & BR_NEIGH_VLAN_SUPPRESS)))
 		return -EMSGSIZE;
 
 	timerval = br_timer_value(&p->message_age_timer);
@@ -891,6 +894,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_N_GROUPS] = { .type = NLA_REJECT },
 	[IFLA_BRPORT_MCAST_MAX_GROUPS] = { .type = NLA_U32 },
+	[IFLA_BRPORT_NEIGH_VLAN_SUPPRESS] = NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 /* Change the state of the port and notify spanning tree */
@@ -957,6 +961,8 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
+	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_VLAN_SUPPRESS,
+			 BR_NEIGH_VLAN_SUPPRESS);
 
 	if ((p->flags & BR_PORT_MAB) &&
 	    (!(p->flags & BR_PORT_LOCKED) || !(p->flags & BR_LEARNING))) {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e844d75220fb..653901a1bf75 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -61,7 +61,7 @@
 #include "dev.h"
 
 #define RTNL_MAX_TYPE		50
-#define RTNL_SLAVE_MAX_TYPE	42
+#define RTNL_SLAVE_MAX_TYPE	43
 
 struct rtnl_link {
 	rtnl_doit_func		doit;
-- 
2.37.3

