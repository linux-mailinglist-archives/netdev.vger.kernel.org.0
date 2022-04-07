Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D834F77C6
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbiDGHlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241998AbiDGHk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:58 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA5D1AFE8A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO/At8vbBJ4QhEVrQ5yqDe+UP8aW2FCjOwE7HbQu5jTY8SrDQBgwLKvhL5UqSWrcZVK74TjQW8UteTCJixdvFTVgX/QQkF1MhJFOkbqt/HeyG0oOjFfz5Sgj3QdBCxxmkl+cIFm3mm4bucGchmkeqQ9/q1+tkNCWAxIHdcbM9zxkDx8wqGBjIpauX9x1NAhl802BX7YzhHWO4uiTaGuocUeu896YLIjky1YqE8ij3l5SEC6sSGe/S6RV7vYUKqTvQuM/o3eKYvx41xwiqQJ7Gup0ydqGviVDG+CL2UDf7BN5t13xkC5p0KURIQJtvBwHzGWyWkOhP29vQLYBQh4XXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2ljHDXK+hi6sPxoIcWMIpIRfINaxSCRHFL7w2D0m7A=;
 b=QYv9X/GRNA2e9Df7VedQun9BU09PgxkCWsAGmJgZii2Wyy6j4riSlOXOBPny4+ME4NrcqQ2Pv+lUPR/OqU9R5Q4E5E+oWJ/KOCb/T6y78fMl1L7vSfEyH2HTRwk9t9Rk/FGR1QcEHUPE56y2sGJ3msV5tBp7hQUakCdjqIEwtQSV/HPoM4bOq7xHhhpAWA2kRNnANwz5DMUbIKrApSLNa/gMZc6QH9HllHPq+Hq31OSqQ+VQT3sv7a3XfHW5HSt8Xrklxoi+SumHre+xCNWoRYbmhKRss/xasC/9tsmwcdjafONoAO/CP5HKtQ7M2Z6n4fwaXIXSGzJFlE0yxVuzug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2ljHDXK+hi6sPxoIcWMIpIRfINaxSCRHFL7w2D0m7A=;
 b=RkiXY8/KYj956RMoHfk2Jii9u6iyQp1bCqMvW91HAtCNI/stBfbLsy+vROpm+zInxmSmMMc5aFcRVY9S9a13QKKedb0+KPHkavPLxD/N2aItG5RXxZh8Ww8uYsDzq6e9WcqnfIrFEgtG4gGZlzC1EzAhPNAeP1taQJf5f7yaQfKgCEHBd3lmfIFHKCbusSqjzizQ4bFmx5FRPHeQbFcLXyeuNOtsWCACA2XUhQ+KLAZWCMGyxNZsbm8Q3kv2c8ytMNT3GrB9lSCx3Bl2V5v4WvG4raOhQp9DT7S+vcrlwuZ4w09u/aPG2xTxl87evICZw7E5gjzx7FQ7tEa59X3fhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:38:51 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/14] net/sched: cls_api: Add extack message for unsupported action offload
Date:   Thu,  7 Apr 2022 10:35:31 +0300
Message-Id: <20220407073533.2422896-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca10ef73-c9e0-41e2-58c6-08da1869a8e5
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB52282093A340D5906D303529B2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQiUsUaNauqYny1UO2HfjXqwkQi8ylkcDfywwWArKFLTaKA+bMsxWpCeYb5/6YcyZBcBqsc8yOIdm6wmQc0pX/h2i8QWze841244In060aSPZQK+umb6mB5S+fTYp5AQ0DGNqhYaedFmCb1KlFLqbKnb5ePd4nTrwbjDGWSQV6111939K9KR1rqjZWU70ByNWmegBq1AgFC657qjfdJ8XWmJshj9MIA+Zefxr9ESL6+AP3XJddoazpuT4w+Nxk1OhjgThLZP4M3rcOzb1fuZwCrQ4BLujSgfmSOBsDPZyMODf3/Ps0oMOByKxJBfPd4YMVWc3SVBlfAY+g+cViWhgcDTbpliqDTAwiC+GyF1Fu97AupEQYFZS4B7JmtLGXE47Zj2CZmgvftLmypQzkT8Y/+2kxL+HIS/GqNMVLyeacbZdAnr7KZOkMtbZRpAiyB5+JldtZyNPelN+Wv1er4WH+wQEEbS2Tb/71lZOmxLDTxUz1wbkzvXPuM9dbugGuhKUrx0O8QTJ0naod5p5BYXBEeiIk8pc/Lldqa5E7riQLRZAg3mqCH/M2jwE6oT+H0i6zOzuBmDzFGM06fWUTzmAU7DI4MoJxo9kCWz3ZvC2bpaTBXTGEmRIPQfM0IQkgayqSpRmHBXIwY1GAMwCw+lvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1+WGQswp4bcdBHB0ZaofflPndC03uZ6tB+BYvdlZvMK9DF3zQ8EEtkxQXuX?=
 =?us-ascii?Q?M0gbcsZsz+iAO/4drubtToe55ZDk59ey3brkIuCr+K+gp8Xha1n3tmeqPIsx?=
 =?us-ascii?Q?zZTbmA4GoQtMfLI2MSY6VyWxBakcAA+UL4TagbHj1Gr+9gJ1DebCbNQY01mJ?=
 =?us-ascii?Q?se3gxSAu1TW5yG8KT1LCVHeSgLonTq6J8DrQxybKnuNx08aBnL7VqUsp7aPG?=
 =?us-ascii?Q?M0YhLeDQvdGlvGQ0fmT3YiAFk4It4u/sdzbgqHC5gvVIPmlwZYH+ilualLos?=
 =?us-ascii?Q?FNOQ6qbdKoIJy+NNiGrbuVv/yfjq04okxHha50FO1zGf3EWmrqzWU5XnTXL9?=
 =?us-ascii?Q?R/PWCka2336XjAnSm8pLftaWa2EoplvUBlwb7TD0w4aWgPAYp+Gc+eXIwFw6?=
 =?us-ascii?Q?sTllt1AtdDsojjj78nyRXXLdkQTihdbyCf4TChr55oVpLZdCcT7RhBPAKh1K?=
 =?us-ascii?Q?+Btk7d2uQThXiKxe8u9n4ZsA6Hvqv6NS+cfwKTWMELgxCGvRpAiBeaEyQ93R?=
 =?us-ascii?Q?sWJHkUcwW6bCMdCXescS9kJUfsJW3X8+9Ft8tUA5LIOY0Pjmi4p281OrHH6o?=
 =?us-ascii?Q?FQAlLNlFcgtn0jLtISaxYfePQD7o4u/GLZmgzrslgtgxnK/dqjBgm4uesZQE?=
 =?us-ascii?Q?osaGo8ZN+ygM/ETJwR+/ZkhqCM+kt7zIilJxqT57Jtsg3mtzh/eLn+Y4Ckb1?=
 =?us-ascii?Q?UEEL/9nvOk4sYoszeqGVeeDIg3VlLXGcvRBagiuwWGKYrfh3m4z6KeKs/reh?=
 =?us-ascii?Q?QIzedgfBIq2Stow8uTX+Fk6utus4rgKeuwzLqVrvOWlWwykBGOKIftoOl4Gg?=
 =?us-ascii?Q?LjAEl5uJd3Z7ciCQjfZOUeigiwmTT5CvnRV1p+d4Z0hd4+LQ2zu1+KRfpmIK?=
 =?us-ascii?Q?dRNOheRSmi4G+o3QJmRXzNBdbLDCurPV77Ibzci/2+DuntV88xR6Z1SPXRcz?=
 =?us-ascii?Q?gSgySqTqRe5hDhrHWAJpBq2T6d5pd3iPcb4TXD6TEleOCvrfdthT3X5+5FiB?=
 =?us-ascii?Q?kop6+JHFnVFIsjeFo78c9YwC0ixQTEpFKD3GiiXpmewbAZCx9+NavpguIHg3?=
 =?us-ascii?Q?Q9H3z8CufyyNRv9lwrbWOePT5dE3NGN+ZpGGHhzYf+moYVWM/smIptkFuFDX?=
 =?us-ascii?Q?SnxafFMUAEEtNzIvfcbzH9wQAxDGvmSRBzYZe5hh5jLePoMaCUsA1VlC24/t?=
 =?us-ascii?Q?m8fxhYuk5rI9HpOuR+8mEyv+zUKOd8oORbX1MICESh1wFYxc7gtgLe7KjnDs?=
 =?us-ascii?Q?R+UGn9Rhnl+oiEqvdoMESvV0jTFqzzAn+Xaw7PaxiV4f2vuC6s99dZDuE2AG?=
 =?us-ascii?Q?8et6wgnxouddW8W57uk37KPaEkxMjv2zTMPGTBEJsWPk7pgxxX6rkh3pv+7K?=
 =?us-ascii?Q?t+xYIyvYSawxpAmGEXt5iPu5b0A/AXTdj+MRT1jpCpE9epp3+KhrsyolbMuj?=
 =?us-ascii?Q?bNVrN3vyyGIMNajEODcO/Io2T9nGoIdNKE1L/ymWwzOgkZ2XRSnvM8LO+QrL?=
 =?us-ascii?Q?hiKCI4a6NDxmsbWsChjOwZvBJTTET1LDPHrcbfprryFG+2jwhN3hEA8ukH8p?=
 =?us-ascii?Q?kR6tpj22+C8K9p3mBU80fiagDdMkGd2QXQ6P9dIVQmg+TAN6ADlcRImCMIHJ?=
 =?us-ascii?Q?RULJ0yKhfh5QgbxfyqWOXlOrSNoxnWgRfidmiihWI6CIJGUyQmTFkYjAfelL?=
 =?us-ascii?Q?Xklxgek5JlHQeY0l6F9NDM0gsg2b2D0sGkqlc40eCUxoCAYPhbQGVAZxE+rk?=
 =?us-ascii?Q?V9E6Ix9yIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca10ef73-c9e0-41e2-58c6-08da1869a8e5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:51.2612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: io6DCnyIi6bJeKJcF1XkBVeLJwrq65nLiEtmkrW6CKtYI0EyWTO94VenP4UnumZNBGHet2GRj2oEnbNFYa9/8w==
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

For better error reporting to user space, add an extack message when the
requested action does not support offload.

Example:

 # echo 1 > /sys/kernel/tracing/events/netlink/netlink_extack/enable

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action nat ingress 192.0.2.1 198.51.100.1
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-181     [000] b..1.    88.406093: netlink_extack: msg=Action does not support offload
       tc-181     [000] .....    88.406108: netlink_extack: msg=cls_matchall: Failed to setup flow action

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/cls_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index dd711ae048ff..d8a22bedd026 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3517,11 +3517,13 @@ static int tc_setup_offload_act(struct tc_action *act,
 				struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	if (act->ops->offload_act_setup)
+	if (act->ops->offload_act_setup) {
 		return act->ops->offload_act_setup(act, entry, index_inc, true,
 						   extack);
-	else
+	} else {
+		NL_SET_ERR_MSG(extack, "Action does not support offload");
 		return -EOPNOTSUPP;
+	}
 #else
 	return 0;
 #endif
-- 
2.33.1

