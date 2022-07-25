Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A928C57F7C3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 02:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiGYAPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 20:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYAPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 20:15:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F66C5C
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 17:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTPDEkmNoKUztbZRHS5JgmuO3R9eDQH3aGWuhg8ItilI+7Cf3jTKRBsCtvBpDNA5bUCNxFQmBMUmACmLZsrr+dDKGABvA/HbtP2eHs+vC8kHLFS2vP1KLl5A4XwHSwoJ/i2Iqsf0/SyKn2JswSm1JyfVZT2zsaIs7NHwpBsaCG4pBwSnnNoVM0gaqJk6kp1HZJtiz04qekLYrUy18qcvUhAzQSzYnvArRxl6VxUCEvIEEELP2Ox6Rs3GhS6EZM26w417tD1XLs945tJnYY6ZjvxpLcjWA7Ld6Bh1Ze7BKnu0tvWYZfXKhdyV90HYsoyLpqdXbFNwAqmD8XWF6qhaKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfG18CqkicX3Zh98wFWzVuBJRVRZ5OoNRxgtmXBUkIQ=;
 b=FfrKkIvckmQLCDkEoYq5TTRW9kaNL8/Zbx3EQZ5em0KXI2bY/APEc86w4L7q/39f5F9NCFbxAHDmjArebILn8++u6Z1DRXwNVRvBn9pnaSPF94OGyOdp07DLiPgCtHN8p+jXqhlG0X9D4DvDAHMStWs/b6M1Rya2F7kyBOzovCsQMVU0d1aPRPjm6Hly1MaI2tkooZN6uPJM+qhf62LhRl7op5oHXy8b4zRHy4aDSKc7GnP5KSdg/qZNj1JK2mZhb+zHkF39tk7EjVDC9W3r5h6v4OcoL8OyXoJ4wyugLnf+To16bvvw57VkQR/MZlg63D/OAaHHCJMcFKCA17dsHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfG18CqkicX3Zh98wFWzVuBJRVRZ5OoNRxgtmXBUkIQ=;
 b=kni+pcebiRNZ6nLZJcgHmg5eyOPr0hQR/91Nla1Me/CEiwZxtLrx0MR0khO3D5ZOHWe3jmvS3+3Cc6/Fg41CIKi26bDJa+2BVkJAo7Pydi3B6O33t3ldZuLE55ylhOR9O+GiF7YfFonhqjcTjTV05vNGcgIJg4ocxtd4KPyOjBv//F6k/W4/cbO9OqpYSta6ea/ymO2SjjK5mcHY5X0Q8Cpsq+63TgekSTEKMbA1dmMKjl0vzHvx9wMQJ2WHTX1odRs6GsGvBz27yl7s4gzNoHXa+U4TndJTjdi6DObHbuUCbbUWXkO/QwUyWf27tTFW55OLe15vCA1qfiTM0yBBuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by DM5PR1201MB0138.namprd12.prod.outlook.com (2603:10b6:4:56::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 00:15:08 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::d807:b9f2:c02:59fe]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::d807:b9f2:c02:59fe%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 00:15:07 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] bridge: Do not send empty IFLA_AF_SPEC attribute
Date:   Mon, 25 Jul 2022 09:12:36 +0900
Message-Id: <20220725001236.95062-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::32) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39fa3427-52bf-4d22-16d5-08da6dd2bb10
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0138:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DDsUbeVwjEwHFNwepRQQDiuEIbr7W/rZLGPDXSSjXzkptu/UtbC/wn/s3EyOoV59GX8TeZcyYrHPiNAdHsWSUy48OFy0aXoGjHcvarEK4yfVBvUbMMXr0QcEXOeJgZt3ypnwiSTCUTeeQKwG0aCftlGUvxbyp4/MnmLW8TfGxSC8v/QmJ9LviSat4SLlBG7dEKFzBZYhNQ2HlZi5FdDIYQYMCCNhnL1Sq5SIMDAiRHC/6l/I+2EE74QBuREwEQ8MetMdAJDBS/GW7iaq1YQDa0THgkUOM7zASS+q3SEfEKp+Uti7uiD9nWM+TPXZBvlRAcF8Lw96wa3YfnxQ50NHCIuxX9uyy/0bL2O2YZxLX2hw6tQNM/zSjHcXY+M/qpaUbJ7OvxIyD6Dpzq66CY14lnIIyFWJC3hynTG/h1t6RSsbJssgbjb59NzgIawa9vrwMeP/2s9dTxDfjtg/h3hsnqg86eEkHN8GSy+hBbIjz+o4d+LKL8yFGnh+TMUQlQDW/0MkdNHBMh9bTBY41CQhfdj2J0r1A9ymsoyDZvadMLBF+2g+Qj3dZDuCBf/zjSBDP2PupPczu7/H/8pO+QSCS4w7IqKtF/0+WHZtYwo3G2CKxK5khvhISfmjCACyuIh32CMF3cZUEK9IwUS9llN7Z7umZptiG43kgutiX+4vLe1KNldONju6Kolisbua+XJsZwqWlOPy/s4+yJ3VCwCQWuoicnyh9mjaUk4BdJkOHNo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(66946007)(5660300002)(8936002)(66556008)(4326008)(66476007)(8676002)(6666004)(2906002)(86362001)(36756003)(107886003)(83380400001)(6486002)(478600001)(6916009)(38100700002)(54906003)(316002)(41300700001)(6512007)(2616005)(6506007)(186003)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hr/rT9oWqbkgaoAbO2T0u/4JsZLoKsSlVS3RcrhDdsiWdH1yMqgJJ/mZ7Ibt?=
 =?us-ascii?Q?aml5ebpmwTLlWBYau7E5lAS6luGayMoerb47ko1PSqZ5mL+dOOwva1pqfH86?=
 =?us-ascii?Q?lFeqko35CYaclegl26ejPb4gDSZj1FOza7qtvykP/jgsEdm1Q4JRn48Fd3n2?=
 =?us-ascii?Q?60AH6iEhWyz2F+Dq16COY0s2uubxpsYxrDnIUvdHBhwaj5YLxWPGEp7kenRY?=
 =?us-ascii?Q?vBEkDGgApm9Cn7ZWgUJryWOxWCM4vJGr2MxsdJ+mqLN+3G3tm9HYOniw7K7U?=
 =?us-ascii?Q?tvhSINxSX4vovXhKvcH1BmQ1tAURO2rrbx/l0sol7Zodir3AsMxTzBDEzJoj?=
 =?us-ascii?Q?2++a+OQXaGfYXgzMiSHIjswRVG/SYGOnxLYhaUowDwG4muuVpr+z7lxtBSqN?=
 =?us-ascii?Q?65sJWYsfBq1IfsyNmqYOXzIUxwcnRraeF03bJTqpNmru0ZluehmnW5MNt3fC?=
 =?us-ascii?Q?sYwpz3W5AmiV8BXvD7aJASBWWoXnSHxVztF4/lxkbLBm8z5WM9pYJXfnjf9n?=
 =?us-ascii?Q?eFQtcRivz7nqpcUSEyMh/nPJxigabKqbNR5ZSDW3gPgyfdvD7zbtzZ/QzWTZ?=
 =?us-ascii?Q?VAc4jFzeEn4ZVrSPm4iowlQ14phvBe6I1VirkpUcTXEDaDN44quTvhU919z8?=
 =?us-ascii?Q?+HNR3RwuQBN01tNztojHVATJ21ki4y6A+spikeNZPnkS/IculXdHp3exgSqM?=
 =?us-ascii?Q?1OdxGvX57jNrCmCR1UFsga/8skRVqMdhCKeA+p9uHeAo7OIM71WI5Rk/GoKU?=
 =?us-ascii?Q?7dR+vGIi5NyMzKbfBz3puLckjfTSD+KAx+P4xMKYSM+1WWs2nG/SBmbj7FUu?=
 =?us-ascii?Q?JN9/XC2sKTdM/JQwfIexqHbmiCJrVYZLLXBJj0QHueZgq8xbBQFRPVZfwjTH?=
 =?us-ascii?Q?Gwyea1KL3rmPSKcGpaMMq/Vby424yBelrIcQLh7JaMvCG4tdkRGrmR12rHma?=
 =?us-ascii?Q?Z/shVt5+E6CBwGN2ZSG4amIl3SZPBobmVliHm6mxJEej/fH5pioGXtHgrYIL?=
 =?us-ascii?Q?rCBD4gpa75KniwNpjtPjYUYL3qgumaUPJ9bnscnkhPeAa+CZ7YdYlkGZUcb/?=
 =?us-ascii?Q?Wz7NKn+tozw7yL59YhMXQhpBoE6VUWA5VqO/hXn5A6yg4FBT7WsxYm7ibsfR?=
 =?us-ascii?Q?HcEvJAPn4eKl+g4Mu0147kuJDnrk/1JNxjQhvnaWJVo7XlPeZLAbiKiQdvaF?=
 =?us-ascii?Q?HJr6BrSfwQvLvgpQOH552EoWDr6kPySrMEL3Ibunjs0izk2o6hUQWYafi1iU?=
 =?us-ascii?Q?EYq3ApimHvy6DsaA41iABm67PVvSXN/WLLBSE34npBFADO42sN0aNY/JI5JD?=
 =?us-ascii?Q?eMnXj/qD+tteyjnKQjq/YP9adC+vRJUKu5tyyvbhnNoR+L5CTizgqfQGpxcQ?=
 =?us-ascii?Q?gw/1QpcwHScYXPcyqGgNnFBcQ28XYRTR6EGy1h/syH8lfjv6mGr2kxIKdmqE?=
 =?us-ascii?Q?uMh/VZljlBiTL9nn+Bxu5H70U5rrjvHZue/kMjNzq7uS3dDKITdPhKhz3Rnx?=
 =?us-ascii?Q?IjBJ4vAcFMhY4+eXZ5GS98mB7kZbOwrbZ79q2LiedyQYt0ZojaB3pDzeT18+?=
 =?us-ascii?Q?MkMg+5KScLlc/OaXowOPshd6QWim2NZEM0dRdlKz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fa3427-52bf-4d22-16d5-08da6dd2bb10
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 00:15:07.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JO8JCsoxJLtu4MDvefMzGW3gh1+MS4YuUMm3s87PGQ/7TybVZVA4545TRn6COPKCXyqXTfI9PH6dYdW+w4uqVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0138
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit b6c02ef54913 ("bridge: Netlink interface fix."),
br_fill_ifinfo() started to send an empty IFLA_AF_SPEC attribute when a
bridge vlan dump is requested but an interface does not have any vlans
configured.

iproute2 ignores such an empty attribute since commit b262a9becbcb
("bridge: Fix output with empty vlan lists") but older iproute2 versions as
well as other utilities have their output changed by the cited kernel
commit, resulting in failed test cases. Regardless, emitting an empty
attribute is pointless and inefficient.

Avoid this change by canceling the attribute if no AF_SPEC data was added.

Fixes: b6c02ef54913 ("bridge: Netlink interface fix.")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/bridge/br_netlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index bb01776d2d88..c96509c442a5 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -589,9 +589,13 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	}
 
 done:
+	if (af) {
+		if (nlmsg_get_pos(skb) - (void *)af > nla_attr_size(0))
+			nla_nest_end(skb, af);
+		else
+			nla_nest_cancel(skb, af);
+	}
 
-	if (af)
-		nla_nest_end(skb, af);
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.36.1

