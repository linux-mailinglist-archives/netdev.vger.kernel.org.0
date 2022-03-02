Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9334CAA47
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242403AbiCBQdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242580AbiCBQdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F3CD33A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/6wFgWjSx5ke+FOOLAjFiZ4q/D4lCv6Fj1Z2lfDqIRSVcr7FeRpihe8vMn8Ic7IFVI5KR6v/KlNkLZWUUHtJ7I/HV84l/yAQN8zjhzCzDL2ZspX5C2GGqKEHwCzHdLozvxc4qTkAI0Rv7lSaLdOOkudPkIDmlvAlY2JbyWafzxGLrbHxfJ9FzZWvxXwAGKl5jeOtJ/ssuQftjLqRl9DIemJMtFLpOpEumaAv7oDX21bjwdZsvcDl7Gi311XOhuIItPAcXci6IhY0CVaFIOJ7CnHxtV+x7ofAqoJl2YlH9NfZJ/llre9TLAQKfApc10HWEODTAMAgSPxQjvZOP1Qsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHqjnoH/JZq+goiRWF8FpvScZ7Bv3IHryMtDQKet7oE=;
 b=cbxXv5Ih1u4jhxFaGYOuYDs4sKrjcnrj3Z5V8RTpdMGx6pjErXrQdjyKG+Otmf4HyIX752SbJXlv/8ewdkfdhNBSWwAIxg2PzwS6BTPvZD9ATsosYxxYhOrFbolLnV/oYmaU4csaPeXIhe1EoQh//F00iES/QyTA5e8/UXkxM1hQd0muCzNeqlc1PAHt6AE5ht40s2a6ioMN8oBR/ET/ys6VkcQ3dOmyB6BWETli6ylvkS2YqW9vBS+XwOBv+1C/Sbl4sClHD5ER1ACNpXcKEU04lOPD/wK91Lyisb604eq6qBqMqA60seLANRzC3fvFHbND74oC/iPtkGyipZC0Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHqjnoH/JZq+goiRWF8FpvScZ7Bv3IHryMtDQKet7oE=;
 b=sgIr0dCbonqe3fQG5mbj/YMyR2fc4onbXnKTAr6Ckh8DwRYzYTtBq5Y1fDKOO6HIdchOmCvxLtcVREl7PjUj0YUJh7iHGVoCmr4mtx7hWizGOTA8rYncypXcHruMUzNbkBVeXCMR3fxuEOk2NrB4+pam/nHjv3vZN1HhI1Ml3YZy4fBAg2Bs3V3vhOeRLJZVn0NlWn7QCSFkXN2R/ZrYZ7IkSdu5DbIsxzRkHC22TpPEifJtsCswAH3N6s+btEdBEVt07C5FjV2yk/zh8+AM2SJ28q2DT9/bfWgYmvL9Ud1h8vpy/LvEFmPy74urxiHYOrOQT4wiSm1czONLUGDKsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:32:18 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 04/14] net: rtnetlink: Propagate extack to rtnl_offload_xstats_fill()
Date:   Wed,  2 Mar 2022 18:31:18 +0200
Message-Id: <20220302163128.218798-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:803:104::32) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db316f0b-cc9c-429b-5d21-08d9fc6a3780
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1942F0151F7F791CC4FFA355B2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bu6vJdeAe08KxoH2rnOPpid71+58twDWmej87uQ48c/meBDIw/M26/YOIF0cmIMwU30LJMxUGjXLrdDFj2LfZoI5MDA7Ye9D1ZwjbkItA+JGkrztF3ESazPd/tqeqUnaYTVq/N7fVCtctG7USTu/S994VhJuJRFjJE2Lzsz+VbiVe+tUuKTMFnFugJiZ0QGqZtrgqKs8MvT9xfoAyGymYZ/aYrMumpRbrq0sbcnsJgYYuYcwA9n1W5UuVp462pYO4ckfGDrQDmbvtFzPqULNLwO8sreXQ09Ojn2RLNDgddTUPdmDyoRcMGpP3Bl7baj+feD27fe3ve09bFHw7Bl1va+/fhI5AugIiVD1qVKV2PpXOZIWU+LLSvgmoKq0tKMlgI3w1pGMNo9XPVoAEmj6yN4XAywLnrNEcNk+eLp/Z+ghvSvygySms2d447FheXOT4gkwI9gtYVngc0BSFowmmBL8ErKZ39xHSZB+fXY4oQgvWkYWaO1luLruvWY7ItBL00+xBBW1Pl53AceYPo3CqFXialW4cYhITUypM2Hls7RPUu8RyA/Vd9vupALbbA75eyVwC8DpUbjRPH7aqOafuLojIo6TNSpEP31RzTM6IczhvhM66ppakdOUYLgtU2DLa9sB5Zy+VPpp/cLKKRe75w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(6486002)(508600001)(2906002)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dWKxdB4bA6X9EYIoUMfWvddW6i3jTLzH5SOisXb26j9BAs+pTHlcZnbo0M1g?=
 =?us-ascii?Q?bmV335lDDIyrSJ+Iw6iWY9La4E4N0yzAhsEV/7oSHDfAg0Tb/N+T++dXLqj3?=
 =?us-ascii?Q?IoDwt0zS3bCSOCRGWz8jFE9d2s+kuoSdX1uXnJ4apB3tbE33TZqSHbucSyFY?=
 =?us-ascii?Q?NxhnLITgd4ReGN/IN9zXLYEkpOg9PSnguVA2SqGHCSnO/BvRrzuCfnr79uru?=
 =?us-ascii?Q?3urbGsIDagVKOGnuIsbgdKNQVf/sRcgsmOWqvP/+gUVwqZZPVf8NumPMYp41?=
 =?us-ascii?Q?dsT7ybEOcU8q9y+zDF4zojNO5aHLrofevCZY9A0YfAO9aoWg8HsRvI/2xIH6?=
 =?us-ascii?Q?D/0ijbVSnuWnhvF44mJftk9byhZGrSZXpUf6ETiLpBc1UGDwpi/Yw9lqBI27?=
 =?us-ascii?Q?98LPVE9oYqGSVBaq54M9gcKIUTSu7rUu1hxoBuqhXFSL3dfFEOIaATGXaKb8?=
 =?us-ascii?Q?SYNQznqzivoOXXTr6iUTEeecaNLxUzVU6tOJG6mgGcEXnoy6o9Tjek+Qv6BG?=
 =?us-ascii?Q?j5MlFkbhqMq6F3JZWo0xFVB/revcvO6fuv2S+9ZMAP6sRoITIMPY37efaKpl?=
 =?us-ascii?Q?j6j0/0E4jrj7CiLDEokcemNBYoPZplKF3BhCBiy23UKwyg7cm6KXxZOIbmCF?=
 =?us-ascii?Q?DqckuThPE4GlfoBRzDSBTQzeg099fMyXjqq7s7e3zZ66UDn7BLgUPeSBs60T?=
 =?us-ascii?Q?VcWh8Skl1KVuLZ1sorfKpkdniZWD1tDVbVtqGNsW8BJRdz1EF2e9aGPoSkii?=
 =?us-ascii?Q?+XmwKuT2zXFa/oPo75ZNn/1ChiH0n5huwEbCyaTwyDJQB8Y/ORFotBo0jie8?=
 =?us-ascii?Q?iN5g3k0FdaumILqhRZayo1YWwABrjl/5IUc3b8EhDG9Yu1lvBgHh6RDTCy2w?=
 =?us-ascii?Q?t/qlNRtwqmFnONEsvnwTjh1xe/NPGkMnuoG54f0MQuxx6IdV6Mrm9Eat47cc?=
 =?us-ascii?Q?vaivsHpBlJT9Q+J8AH1F6/O8yOn8UrCE/eXrsJxcidnPhhHhyyOKXx7xkq5y?=
 =?us-ascii?Q?xRs3/o+kQJQtaHcKMKCsySPT5SQ16MFageTrr1M5lwjkrpOPabTHF76HHxGi?=
 =?us-ascii?Q?ZIG8xnaPCrDkFR8KnwNCOJfvnXstq+dvyjL0IKQptrswEuq1oQ6o7PqqwgcD?=
 =?us-ascii?Q?3eFvJok00tJcrXx3DXAXy6pU/VRGk9RKwWwXaTvi3mCxlmW0gdPfM/DzIk0f?=
 =?us-ascii?Q?ZMItbEE+Kt9cZqc8oi9zOmeusv+6IsRWpZqXEoZK1xERQayD62Dmf1k/h2mn?=
 =?us-ascii?Q?9ifowca3TQHXXvO9lESRSBxA6vFTLjF101dp0NkwWFN2mTNuzSriV/rABXXO?=
 =?us-ascii?Q?Nxm2Z317UcdHKglCTeEBkQsYPuqZ56y7Ezc8yQpEJPALJRYFEMCi6yGx+fxN?=
 =?us-ascii?Q?uIp0tsJynu7HZ3x5Hr29v2rX5Nu38QspJPc7gRlWY2ObaypqbRFaGIhnGe32?=
 =?us-ascii?Q?TB/cmSM/1h4KL+xNmf5jjuBLVI96m/SIqFsnoeG4mIlWWvr+KE3oMLZhaeeH?=
 =?us-ascii?Q?qVqRA/f+aakF+pGcsYp7+HjS0twGRyFUbjU0k8BLfDRYxkIw94MfIuZBHNeH?=
 =?us-ascii?Q?aRa48wm2CyrzlNz7OFrhdPspFOaN0B1ZR8y51nXmooeFxkr57VKUgln9GY1N?=
 =?us-ascii?Q?MZ9ICJfWvJ1075v4565ca+Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db316f0b-cc9c-429b-5d21-08d9fc6a3780
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:17.8465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjH+l3RY2TFjzs57kLMUVea0CWK+BQzdRVYzyi9bZWfya0HLVWYE0MFGAxBPQ41mGi9N1Hoo4ha7FFaSpdfkjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Later patches add handlers for more HW-backed statistics. An extack will be
useful when communicating HW / driver errors to the client. Add the
arguments as appropriate.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 31aa26062070..594aba321f42 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5092,7 +5092,8 @@ rtnl_offload_xstats_fill_ndo(struct net_device *dev, int attr_id,
 }
 
 static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
-				    int *prividx, u32 off_filter_mask)
+				    int *prividx, u32 off_filter_mask,
+				    struct netlink_ext_ack *extack)
 {
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	bool have_data = false;
@@ -5147,7 +5148,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			       int type, u32 pid, u32 seq, u32 change,
 			       unsigned int flags,
 			       const struct rtnl_stats_dump_filters *filters,
-			       int *idxattr, int *prividx)
+			       int *idxattr, int *prividx,
+			       struct netlink_ext_ack *extack)
 {
 	unsigned int filter_mask = filters->mask[0];
 	struct if_stats_msg *ifsm;
@@ -5235,7 +5237,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			goto nla_put_failure;
 
 		err = rtnl_offload_xstats_fill(skb, dev, prividx,
-					       off_filter_mask);
+					       off_filter_mask, extack);
 		if (err == -ENODATA)
 			nla_nest_cancel(skb, attr);
 		else
@@ -5506,7 +5508,7 @@ static int rtnl_stats_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = rtnl_fill_statsinfo(nskb, dev, RTM_NEWSTATS,
 				  NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
-				  0, &filters, &idxattr, &prividx);
+				  0, &filters, &idxattr, &prividx, extack);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_stats_size */
 		WARN_ON(err == -EMSGSIZE);
@@ -5562,7 +5564,8 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 						  NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq, 0,
 						  flags, &filters,
-						  &s_idxattr, &s_prividx);
+						  &s_idxattr, &s_prividx,
+						  extack);
 			/* If we ran out of room on the first message,
 			 * we're in trouble
 			 */
-- 
2.33.1

