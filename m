Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF174F77D2
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241969AbiDGHlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241957AbiDGHlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:41:06 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E828D681
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:39:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XE1uY9p1JhCfOdD37HaPJYyz8JyYXBiEGubGnCBu0BTDUoLTN3t0i9/PgfwjMkK6UNQT1McuLRh8x9ZciwO9ObQCaKPKWZMxQVDxkb8ZrDoWZEFWt8Szjo75dzRHe+LceSXxmMRgS4ro5wQn9rx3PeeRqyo2ELaYMYrsnAdgEfIWf6MpBgFlNrSqN8v9DZujqNW2z1Lv6I1AjUhsoDS29HyLSq1wO2Nv6w9v9k8N0hx7TUVQku7ubj7h/hcPXdW7cT0srHd5UDVZR2VeIO9oZ/dTiuKbeKStUuWLJeiu2q1wIZg5pJHXbzePBr0lTslO1cqnkxeDpIDCqohtirVHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btavt2/xzbLuqE6Uodcq3U4kRMBIJb8FT773MGPEBAI=;
 b=Ca/x2n4VVNXl9HwbK9/XDgjDpGPdlWivQtIWajNliQvZCbR9fe6IxL2qX6P/Xz4GriC47E9iQ1AcgO0yFYH3/vdTLPbLEmTSMFI0l9MbQdzxrjRKfsS/48bMFEl+qcOf5roKfCNbo4fFRfURXQEBUZy+4Dln9C+1kypWa8f+nCfDkXet8ZiurUoenuKn1DpwuJkcEizhWNylJuUZz+MK/VM8AHA1g/FLiAxTQielvo6iIIcWx3t2FZRFe2zOzMOUXno4JGAQsW4aO3YbcDccMAB18nIdh7U1w/UKRNVpgB7A3E0iCbQUfQQ01p4x8NYDs7KXpNR2ATCcpmjaKHSUoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btavt2/xzbLuqE6Uodcq3U4kRMBIJb8FT773MGPEBAI=;
 b=eC7dKw3I65de6V/nQ9eDHO+LYGwErsVG5EvQNurs020XCDQa/WeKrDP8AtNuxfgs74ercNqRxGzpUQLViCpCw7ikkgTO82ACT0xjkB6N8I82h5zShxdV4HrT5rP0G5FUw59H1ag12kZoHMvUdOVEkCTYiAuy2+w4TtbJebMcwFh3raDnhgtyItnc8Yed3G+zzmT/u5avuTUwLW9PdUFlOXDDjQnTjgJQTNA6ppPlz1ecojupNcldCxGQ4rNresM3JtYn76IOp0UTPGGBgkqaC2LHrcqULwqzoJuyXLu44rzcafRgmItygNSc8SarVegA01xeFLdrMNRWEMObc/3nyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:39:03 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:39:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/14] net/sched: flower: Avoid overwriting error messages
Date:   Thu,  7 Apr 2022 10:35:33 +0300
Message-Id: <20220407073533.2422896-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b801d4b-0b01-4805-2992-08da1869b025
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5228650E9496BADCDD3A630AB2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KktY1f6Ox3bMz5hDeRWqphU37Bxanpjvbz36ta3Sz8/597QM+OqFXLNBosg24MCmgyhAR5uO6v2IC/KBmgk0nLbzwKLiSM2Tpwk9qjXusYf57R0l3hBnGnVuzGFONG4PXoi/nUjD2SAntR1l0LeIb+bN3Ewf+gqFOG5VvxaxDCKGus6FEqX3bt9SVPQjoirbXBrgfrYnJXUhQVvMe32d0SZxlbg82OhDiU0NA4SBzoRrmYYf/E7fMVNsJTJejkkaQQZL58/wWJxGJ6VyIvCAKIkZDSJV7KcUkDbA9/1fzPkMPVOtwyDjwJFuVn/5E8SU91MRT8tToT/l+vhk35o7xnadEqf315+PtYz1PGT4++QpDx6xkafMUjN1wmHYqrr5DwYc9/JG+5ao2MAAfyDl259NxAtSd/+leJcpcwF9D6+qaoBsbVgptYzLwbqca705H8jSwBUx/BANl5YJ9I7NYr2lCkMfWRRKggCNtX/VKsjuMr/i6NSapoqEF78JzNcP81DF6Gzz82+19iXyyFjJSAm3AIIgwkSKQLonIvUnXa5bzrRib7DahYUsJGxbns3KyZh5/HcyscakCcij7v66d/S5pVNtpDl9dlqVerpo/pKBdY2VD3Yt9KeaDL43xhsNJz6KanKxI4S4B8RMlcxmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8En4tSsjyQoBFKU5oUadBSxmkNZH8akQzio60MhUkh8sIqqJKJ1Hu4AG4u6+?=
 =?us-ascii?Q?OyblkuDaW+euUu6nqzwROeSz2K6t4VS/pDihgKvYFIIc7v+8bLl8hrVODoVY?=
 =?us-ascii?Q?Q/CTC3bSl8W1tkkPwM+kv6LRIdEYmwfZZrf/0PT+gsIf+AiEJBtFpN+qghF0?=
 =?us-ascii?Q?VtTlGDJfhdgY1moI0hvyLbc8myi0673P6Gu1dZqK1yLZOnbZfdAC+7BhUest?=
 =?us-ascii?Q?u/VM5sHQ3W/AExQOMHmR6sk4SA+G5ORiNOGRA7MFDVTHq0TGMDiOBo529+Ih?=
 =?us-ascii?Q?Z7wB57Apc+E7Nd9JBlv4Os/p2NuTbxSE0jsMbGznm07wLl8/vL+W37okEuOA?=
 =?us-ascii?Q?ZPyTPfjCORs1cAJvTTQ4CqaU79Jh0mO8SQZ5EVNJNIW2UHcA/c5aN5LGb01F?=
 =?us-ascii?Q?c9IJTLx/C7+SnBOi6MyZ5gyJvLi3p8vQypa/ujujIJZES7xVpqhH5GuXxPs6?=
 =?us-ascii?Q?VrH+bS/WNHVBTmA65fhD9cW1N3G/cuMIQqoucsjZEEpp8SaBPyXY+suTQ8yX?=
 =?us-ascii?Q?D+uIYUKnKNoCoqM7yScOw4VV70DZtVLH1sLFJo9TWfFukV9GIq4MoblVPQbs?=
 =?us-ascii?Q?KqxpjfZ2ikcdo9M60+dgrrOieKfMAkjORyCRAxydCFwH4y1Fdn2xBFGCzpgM?=
 =?us-ascii?Q?rrlNeZl9bvr2GphV7FCWNpnwb0Pdk9nIEmY7kgBBUoP3hHFYebcKX1xcTA7j?=
 =?us-ascii?Q?Kk4USZ9z1INQboXGWYnO8Ajqpg4uzbSa6OYyGWtsfBTCUlbg/5nxz89B+zXC?=
 =?us-ascii?Q?HLt8gx8t5ZAQFGwNBRnQiMtLzyoeqvpdcNFuhZ0UN8hEOWOSJ8ypD40u2tnX?=
 =?us-ascii?Q?RZeiPc/4QnTGq9b2zAzclVp8SDgivTSwvexwVm8LUX78Khf6AhymwIZ2Yy+3?=
 =?us-ascii?Q?nZzriVwX45Yt2imXgnhi2jVla3IlnIE3BnbNGmdZv+FAmBLT7ySOFrpSmRlR?=
 =?us-ascii?Q?sM0LLByhDitxWWPDYmTR5YFOHcQPKlCIZnWPKzvYPPiC4aY76tVRY7XRSyWp?=
 =?us-ascii?Q?V5fFdOFrQrbcV9BwCgjbw+UE+b0E2jL8wXKrSRS4EzWkU4IMuiEXFSZdzw1B?=
 =?us-ascii?Q?9LblChXiQOYyDQ11rUWm9oItUGrfV7pjIa40lsqrD8vmSJra2spO/C2zNRil?=
 =?us-ascii?Q?3wrbmjUUCfqBTW6xVe9LVT2MQFk4QgmeW5DKfUnUYSz6yCFL/eUlmEXaGHx5?=
 =?us-ascii?Q?wur4lRDNhnjtwWcuyzTtcQ7xFZvdf4z7R4ObFsxwfF2TJ8yk8JljwzA2E73L?=
 =?us-ascii?Q?4iVHqkY0wrwijs6SSWD0rBMJun8gFTU7gsznY5sBge/LKZGmBhCXwijuYi4Q?=
 =?us-ascii?Q?UJAvtCuzBK9RuGJraAiZ77wCVC+wTl8CAJF8HNd3c6AbJ9sPDyBH155fcmmu?=
 =?us-ascii?Q?8a7+OBtr2nPgupIdAvDcIL84pcLVMh8yCn90uZmAbQTqSi586Ohw8B4RLnHY?=
 =?us-ascii?Q?j787Io0u70hnX0istsH9FRT4xS6RN7dcCB2kPYZ0gt2T1nsLL2owclrEpNX3?=
 =?us-ascii?Q?p3sZdOc60aNXhVGb0Thx0z/OdL1njt/14eAe+yXknnD2+o2tEdM6uT56wry8?=
 =?us-ascii?Q?309VuvZV6Ddz8kErE/zpLAeyf6CpYM8Hd+BuCctAJxBEmIlW2gfIrpaES9+P?=
 =?us-ascii?Q?sx8MrF4bXeyUpYiL6J4OSvw1gOQ6IjFp6zuPduHmGDY1ewiDOwqcxtfjWkq6?=
 =?us-ascii?Q?dUW9XNpFa5ffnAhmV/Y+LGCAlg+x0pcoFXw9S7m9THFkdLeQ92Jk+ewY/X5I?=
 =?us-ascii?Q?k17nUbx3Lg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b801d4b-0b01-4805-2992-08da1869b025
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:39:03.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZJ5HldIA087Vciww4KL+5wF6tvfitVLm6Jcr5wCVD8Bmx8SGYbDh8wlal8gXPMq+RyLDrgNnM14TemQvLgUyw==
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

The various error paths of tc_setup_offload_action() now report specific
error messages. Remove the generic messages to avoid overwriting the
more specific ones.

Before:

 # tc filter add dev dummy0 ingress pref 1 proto ip flower skip_sw dst_ip 198.51.100.1 action police rate 100Mbit burst 10000
 Error: cls_flower: Failed to setup flow action.
 We have an error talking to the kernel

After:

 # tc filter add dev dummy0 ingress pref 1 proto ip flower skip_sw dst_ip 198.51.100.1 action police rate 100Mbit burst 10000
 Error: act_police: Offload not supported when conform/exceed action is "reclassify".
 We have an error talking to the kernel

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/cls_flower.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index acf827b0e30a..87e030dfc328 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -468,8 +468,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 				      cls_flower.common.extack);
 	if (err) {
 		kfree(cls_flower.rule);
-		NL_SET_ERR_MSG_MOD(cls_flower.common.extack,
-				   "Failed to setup flow action");
 
 		return skip_sw ? err : 0;
 	}
@@ -2358,8 +2356,6 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 					      cls_flower.common.extack);
 		if (err) {
 			kfree(cls_flower.rule);
-			NL_SET_ERR_MSG_MOD(cls_flower.common.extack,
-					   "Failed to setup flow action");
 			if (tc_skip_sw(f->flags)) {
 				__fl_put(f);
 				return err;
-- 
2.33.1

