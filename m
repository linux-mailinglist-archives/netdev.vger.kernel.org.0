Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D487765DBAE
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbjADRyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240177AbjADRye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:54:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699EE3FA06
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:53:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jd/gXoApyj/bO6JPp/JjjiUcuWZLB8LbFycwr/6J7tRuNbRotR1RTYP1Tgt4UoD4yX+UX98MBgjKNNvqT8ixJ6tUWR1cTKVG1y8bGEBMq9KE78pxqLWctKpAEEICoQV9ScRIZdz0XJP/ZKzubw3c0y4nPMAz9FbHXTDYTLDV6Pm+m6ASMqwWtvmbTq4SzRurBvWNL8tnFkO0Pns7mnWCLRYrFNKPIvSDVJWJkVJRaH7c1OmiHbZ9Z7YVOC+nVaqvb+t2GksmYbCc/usNLVfn4ER5CBHqLlEn/j8P+nrwaa+xvRCscpCHWdqWQFa64kVs8cJ0K8paHDK2RAq+i4MuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5Fj2N3fvxMuwMNZc83lcD9qN9LUheieYw1wxLI3lfU=;
 b=epVS2IYQrBjo5SaQY2PBf/L3VKti8Ds3P9KkAtP1amzvgQjW/2+ecekse1g5zhmm5l6jUImqdD6M6rpNBEWK3fupMnoYWcGWwjOwprOUSwfo45UYc5isuiFJOa1Ajz8CYSNrU5b4r2IxrLknxWZVM49qepCrmyDuwrbdzKIF2NyAoxPHcHTC61D7WlR+nejC6g/53e6clN3GxKnyW3pS8NGoJgJ3J0jnFkPVU84f1OVuwBwMfpI17fvJ1ZoSmkznyj+295KGjdzvtUpK9UQZv4EZKOxzTztWDTjL8xBPRlHa9XoQEB5LnFS0cmwjM0OS763CqPceniPGN30UISzZug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5Fj2N3fvxMuwMNZc83lcD9qN9LUheieYw1wxLI3lfU=;
 b=Ea11kU0L7g0BAhAozBIV7biT1HPzbejg9CrpCe1P9eiHFYuZ44Z9jfQo1iOm3GCynB56vzTqfIOnB8RbonR8BZe3KatImfe4pEmc5hi4KK+247U/VkDINfNmQIIv45Ma8Pl87E3DZJfuKWRmtOiZxyJretBo7fVvyhpC6Hy/Rf/84bS3bBXx/HNWMvjbQV34z7awBjAtG6hS+ehmwIj6njgpm+m5Is6HtXdrHv3mEYv7yok/9y4+31RP14VWzW6zoeU2jz8qrBBk5viVnTv0NTF+GQL/Gx8bCx16I3CQJhqYOAvWem2ACrGc5dKabmY/XoUJ/StLi4RtW3kskNPtCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH7PR12MB6762.namprd12.prod.outlook.com (2603:10b6:510:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 17:53:25 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175%5]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:53:25 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net] sch_htb: Fix prematurely activating netdev during htb_destroy_class_offload
Date:   Wed,  4 Jan 2023 09:47:45 -0800
Message-Id: <20230104174744.22280-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:180::42) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH7PR12MB6762:EE_
X-MS-Office365-Filtering-Correlation-Id: 96908156-46cb-4f1c-80f6-08daee7c93bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hb/QX8p9xtrNT8Vvt+QxFe9LyF77VddH3ZrubChk0g6VmHznwd9z1KHZYNC+mqED+8BfMVJvU7nSvG9t6qWcuwOztVAsKr4hAp6R8amdUsmY9zBmuDK7wNTM6UZzAho7BShPUSmxjLZvcPGRMbS0F/6K2TCpzCNawu1Qupwq4rvHbLU6jwvmpeOnU8tIq+U0mb19Gc8pX2NOANc+ZZbJwHOrypf7a2korGv5mYAYPrKIQUONEacNa/bii+1jearKgixRFVOuxUXrRtv2slKk+Eq+8uLNC2RCYbyhcdtYxIJnMdVdW1Fkj0yU8Rdsx+bEZWo6+ZabalFZVKeSYBW9LmoHwe3jRWaePuf4m/1OlBwx/yFyMJDeM6M4Hi8rb3XKcecn5qSx76MZQTx6+rotBXTfN96voWlHhMIaHO85iev4Rwi8QnmW1zGnAC7y18811TMLYcr9+shfFxNWimujWGX4I7pYLIwupl2lLWFVLJ4yEPpxlhrxZmpaxtHWhRbBdArUjfuvfjjlBSKk0VU+NhM3CZRPHsbNjlc1nVE40H49aOw8fLq+ROadZHXY85WdyA0X1z4kdlFqLKO4zLDvgFD9BPjzv30O7bxpxJCZPsESiE9imXDAjEB1uVC0trXRCxvUYQTrkGtJvLELSmkuGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(478600001)(38100700002)(36756003)(86362001)(1076003)(6916009)(54906003)(316002)(2906002)(6486002)(2616005)(6506007)(83380400001)(66476007)(186003)(66946007)(4326008)(66556008)(6666004)(8676002)(41300700001)(8936002)(6512007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FjMjF0359Gp0qunH3+u6x9ooxYMmywqwJDV6F5meX0xgrWnAvDWUunBb4i8x?=
 =?us-ascii?Q?dPF0WPx6FXHZLP+sx3xi84puJqEYYaxXceoX8ZnGZBIjVm2ewtc5IX5zRyUB?=
 =?us-ascii?Q?yQr9xcyVp74HpZExHuKxOqL36TQ+K/5Z+D5qveYNf61Q9YlLMAvmAoaafxr4?=
 =?us-ascii?Q?4cngVH2EUyZKasizFYujCRDmDXSpUKVXC1hr4wtXlBoqZ0m3LFX+sq/P2JY4?=
 =?us-ascii?Q?+DJaZf1qt+ogu06YlwH/nsJ4SSuw2slXPtW+dGSnKC+QPhB4+aX45lf9Rx4p?=
 =?us-ascii?Q?aydFniD1iBsphCDVp4A5s6SfQ/fKmwJLOauj3vMtscYpqmzwmluiQaeH+He+?=
 =?us-ascii?Q?WnlTy1e96lGQVZaN+Z0rRnNUFGbT5qSxXOlFjyQqeKUNrjQl/KLQEsuS/J+j?=
 =?us-ascii?Q?ZKBWQYrJ7bZHMgNClSnlfHPX83mqUAXYQCfjxxYxlNNiNBpffbd5InWQhnOh?=
 =?us-ascii?Q?esMQCd3WIo87iEosDCuFHSR5ACEltGboAa+IOV9YMWywt/oA9K1EOWZ24fq1?=
 =?us-ascii?Q?yjhgK+2oyQNsP6zDWkN44WWPsjWiWJXyrZPwMd7NPcrsm6M1QCoNvUkxOmd0?=
 =?us-ascii?Q?oErUEzCrhzTH/C8/BStpCNIVqQjh/rLbB57EYqUwySHHbZx5s78OBOTlACNw?=
 =?us-ascii?Q?HcFUqxZkBz5BqkRQfhGcI0Bjsnf7pTlC8RGzu66CegAcbp3BVSzfJQoxivPN?=
 =?us-ascii?Q?UFQMAHKgxAPYjJA382u2cd2jEsBa3cUIwiayDbmgt+icwRq1t+BNxDjok7KQ?=
 =?us-ascii?Q?8M1khR06icBb6qLOV7YqWbgqzWRhxeQE3FXic0sOX/TAVLsdfaWYXJGtlAbk?=
 =?us-ascii?Q?qHXLwlD8wza76PcTn4jBYYA0EsvpT7RvKJ8c6PHvlNhLNHzvbv0ldR2aItVo?=
 =?us-ascii?Q?P0OTgqPE8a3N6dh45Vv/R8W8lSnyAPqCWOr0g+5HI+pFJJn/yymAWq1d82Qe?=
 =?us-ascii?Q?THargFlyVCx20Ep3tL33mgJCs6FVmK9Iwrn//vk9Ar9YOTdtRGjR60yjIaMi?=
 =?us-ascii?Q?jtOzss/cJD2uUoSTVN3/O8Bq9KGNF6E6Snsvz4cKUBXdVQuIlZqa56mkqcYO?=
 =?us-ascii?Q?slBIBvj6GY5mpj1cu+0p3k++bbHxg6xlEDxsSs1P+Zo+j8QSlZ7/efu4FpIn?=
 =?us-ascii?Q?08lLt5j2vCcvDmjOqide2iHqM2K8ftNblnmu3X47020FFDZhtHSB6AI527N5?=
 =?us-ascii?Q?FrTc9fod78XGdGlkhOzuQnn1A0grtk+IRSyEeTMcFub0BLw6gz/k9uMLaSv6?=
 =?us-ascii?Q?RwMoZmZitVVq1IrZj1+zLpbOpX0QCvZSo+HLRzAS62orkGuBmF5G4+lQuNA1?=
 =?us-ascii?Q?NOnMjIvXgyhxIuAhhIHzSCwup2Gln2+5LUsZSnN1hqIsJ3PrVp9GXgpO8Eex?=
 =?us-ascii?Q?UeG+VtmTc0VAbIpOSHJrlmEAzn7/a2QsfLhcW/kBY1JKAhzigYjbj4EBUaPS?=
 =?us-ascii?Q?expW73x1CB0O+X4o3eAvKqnX7kYjNFC1+HYn7+XlJhDR4pZP+1QxA28byBZV?=
 =?us-ascii?Q?MGi5yf0DEKO+qNXfwBTwC+K3yyrZa1g0wZ379Acb0QURbN9X4a7M6ezk9a1U?=
 =?us-ascii?Q?syhf31a7qvkMG0+RrWgG5357azaspUScn+X2t6/g9RfIcR1okgRhXldz6FfJ?=
 =?us-ascii?Q?qvkts4jxPJEt8Tyvf3V62xturIJgO8aEva5w8b4jlfMhNa8nsjSRZe9gBhkT?=
 =?us-ascii?Q?VJw76g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96908156-46cb-4f1c-80f6-08daee7c93bf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 17:53:25.0065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ywMt5pMLeT7J8+bIhQw6x3Gnu2tOVb69M5UDHE0Gpqhv1qm74063UcOQ0tJA2MAisnvKuvqMB93E2D6kcCnglQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6762
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the netdev qdisc is updated correctly with the new qdisc before
destroying the old qdisc, the netdev should not be activated till cleanup
is completed. When htb_destroy_class_offload called htb_graft_helper, the
netdev may be activated before cleanup is completed. The new netdev qdisc
may be used prematurely by queues before cleanup is done. Call
dev_graft_qdisc in place of htb_graft_helper when destroying the htb to
prevent premature netdev activation.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 net/sched/sch_htb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2238edece1a4..f62334ef016a 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1557,14 +1557,16 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
 	WARN_ON(!q);
 	dev_queue = htb_offload_get_queue(cl);
-	old = htb_graft_helper(dev_queue, NULL);
-	if (destroying)
+	if (destroying) {
+		old = dev_graft_qdisc(dev_queue, NULL);
 		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
 		 * all queues.
 		 */
 		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
-	else
+	} else {
+		old = htb_graft_helper(dev_queue, NULL);
 		WARN_ON(old != q);
+	}
 
 	if (cl->parent) {
 		_bstats_update(&cl->parent->bstats_bias,
-- 
2.36.2

