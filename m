Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08BC4F77BE
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241949AbiDGHj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241956AbiDGHjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:39:53 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2056.outbound.protection.outlook.com [40.107.101.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D5413F48
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:37:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6tkwlC9FkpDALdU/Q7mIhiMNTEs7rw9Val1dfMAHZkUfBgsLl+YgnToJpC+m95dC+AhmaMlaXHqS6Qv6JLK1DqR8lYPUmbM4ImJkAbaH5mawH4G5RzmW48h/LtL4BngwP2PuBCD42aQFSJaPeqE2Eotkacy1/jeWg/xepoPc1aFmlUp4+YKyktPfIcrPKH4hXBbTTYfa3kwz/7Ydsiz9Hbf5dbCU9MlJ6PjDEC96FTKORnYZOq2gEakEHMqQS6EFRstNLSSFsMJhpQz7sjAAV35CiwWNt1+7FgdxwWwLFZ/uDfBDQbzzKS0jS7hTSZMOZgElbLxVKEe6tXuOpkccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGVxqSTzIRgRb0rue+YVWQ59TFoeR6zPuzqQ//DkOrA=;
 b=CE8rpIlndHSTNx2QSGdduT+1j+iCs2ruqOwH5TFrpIFLkouWJPrR/knZpMtNxDOL2Js7aydadapvlytgEkUMJW7TNhBwv0y6H58vkwEBOwfggRRAnNkzgI7xJLarj8Zg5E0YKIF8TH4c01t3sZbSD88FGVTqtV7pfnIq9TvLfm8ww9oNNjy9U1Q/hkq7YIATahhbWcHU2rlQj0t84Ds+7OIRn9mWGz8NpNcaKjy4dOaN7QPls8IROjA+GTFX+epCtOAPTiP4l7Ve7INB3DgM02m0HFYdI7sP2ZeYve0ITxm0GMOmp2XFt2pbIMv+aMNYJrN5dp2Yxg8+5ElokZUFjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGVxqSTzIRgRb0rue+YVWQ59TFoeR6zPuzqQ//DkOrA=;
 b=tF4uRWsNdOdPm0xdYddLdao9i8aK6FGP+T1waIXTh1qnIMhcDQZIrckWNvgaI8T73Apadrk5Lcx8C/AMX9rpft6aJn9SOoWFKIedkd21Sp6C5ZvgKH9+GwZQRNMHusvp52ie4sujYimAncjaAcDV4oyaj/Z1Z0uiPrl7S9kwwr+75Sh1CZgRQk8Sc57morl4BgnbId7zneaqUXJs6PXH1a6ZbkoyCtbxcRGKQNwFOHhoSYI4f9xqc3iUOtvyG/m+ZeUZ0TyNKgDxhHezWjN/BnMl9wAFmGTvDuw/iaaPuyEWI9h0/fQX268huXsrvQDjDSrcnv1H1S2i29u3YTVAlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:37:50 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:37:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/14] net/sched: flower: Take verbose flag into account when logging error messages
Date:   Thu,  7 Apr 2022 10:35:21 +0300
Message-Id: <20220407073533.2422896-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0044.eurprd02.prod.outlook.com
 (2603:10a6:802:14::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6007500c-60e4-429b-300d-08da18698473
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB52289E8A7AF5C1BD95602D05B2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjoW10giK8bbA9/ycFDrD8cZu2LNHBvZ6XOcg/A93VqmV5DFsO4eVe3HJgcJIAPDuYvjsr3fxFg5Q2P5uFQXu+MZNN5RNl05ZcUxb8oGT3iVf1e7IDQfpkFKu0YZf+T0w2S0xnE8MvT6Gz1WMfCKBLfZAxL8357qsyZi03xZBfXFIcbe1DmsFNgcnu0RnbN0JheVVywkKvZuACmNQYlMMjcApajbSS4b/mJRWnoJ3YprZkAjSDMIK98ai+i7g1D/oxxC4OMFx5DEdK5+oc6IrhgxOC9z8o8AWNncHvIch9JSlI/YGnkFm2EIQK+viZz3TXwAt7X7xxdZ1J0wyOyzGBiDWH0Pv29NBT0avLCVUg7LgULF6LfoKQBE89T6z5PxAvr/WrsF1d584NhBeQdAYCt3LXpxF+SVXgUtnnaHGRX6LZO17KxJBnoCJiWMLx5C58Rv6gFhOGIhFzIgXRqcWJxPTRi2NSJfsFBTVXMi6T+FUUR/RPGHoX9L3D7xBxcfebHfKrhIgoggdbPulZCydQNOAuXrNFUs7NfkGuYN60kbZ7++2Uo1yhm3VPPPsBBs9hxF4xiSLZDF76PY3JWFGF5iY3uuIewHEyINWhmZ+6o0g/GEaW/IOV0xuJscbBgnsdMrxyLxbY6AvunKio008A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?goJUezMr/ac7sVSsttKOTh8Ma3eMYqQ7iE6hXHpIOK+6/qwpQhwBn3c9IWwe?=
 =?us-ascii?Q?BsbZ6V4U/FUUNYkl4GIyyaZMq/zlYyAERV0BgaWEO1hWYacWESRcqbdSA3s2?=
 =?us-ascii?Q?In8ZksC6ipQrAzpyQSV0hKms3i2YV5MXLVnex10OKwTU01UI1T2Q6AFK/BzZ?=
 =?us-ascii?Q?+4NdYWQltIVRBL9UvekuCRqtQU+CzPwZz2LQzuQ1zQfwHWwkbuuz93F/VPqU?=
 =?us-ascii?Q?JncaoIca+/Xs4c0MkN3NcKup6OJQwMZi5gnvRiwRNHdd103WlzuubKjZR4sN?=
 =?us-ascii?Q?jozTDPUjM/04GW8SRvoxuV8PUFXkighp1zrds2MynCeT1CnxptbChZMdayh3?=
 =?us-ascii?Q?e042u/vL2b1bHKbL+nKrhgf5Y1DrGjq5hydHEi+FCO2mL6FUPG5zq4EhONfH?=
 =?us-ascii?Q?2/JwJPU+UQroYBtxqpA/gfUxsjqYGRXziQQHOOaLE2gAHYAo2NAlsSBdYkMU?=
 =?us-ascii?Q?9Hj1mrxqmcec3kZPtGKdMR9C0IbeTX/aDgwO6snIZQQz1c7GwDbqkSV7SNm8?=
 =?us-ascii?Q?wnyRkB8vXhfYqd3kopMa65bEnqUi/XCEOFqpJ2djy/swZCKSEkr0aw1XniKW?=
 =?us-ascii?Q?zJ2xgKcJ4/OlIXORYzVzXuD69FANYB58KpdsxE3RYMSkkMtG+TcEAcWkahTT?=
 =?us-ascii?Q?OPaMYJP+5thgxQv491bs4EXC73tQFEMmuJnv+mGDMeIX3C1IF++lYbIfqdaE?=
 =?us-ascii?Q?SC5qeAMTkXnQbZfUhmlc5zxJbPC67ZNNRUiUx7EZ0whVGbvH8AB5wh7Bom6v?=
 =?us-ascii?Q?XoW+XOqAJXK51Wb+WVrP2B0K5wDqgTYI7ew4o/ckrvaIJSiyRF+v4S7dTEta?=
 =?us-ascii?Q?PDVHBmwRQpwIvyHSD3cocGzquI3rbsTpVSmvsSr16f1njD0t+6xGSAn1a7EE?=
 =?us-ascii?Q?SdnKLvvv6RjK1SxSmMhNPynjfOC6+izkygd3Q2duOCRqHZ0kMgyzo29B2NVj?=
 =?us-ascii?Q?5EX74j0+BSjmNczGWvFKsKrPwcA9kHPJFvjZusDDJP1glAYVUmmreemgMG+O?=
 =?us-ascii?Q?foH7dl8pCcn5kr6bMIkjCryKC08/NTYZYsgRexetFiBF7GHmbvRRQO0wIMIe?=
 =?us-ascii?Q?BWSCHKG1Jit/1v9GD11Y4jBfNH1iQ6G6a+jlQMlF2E03Hdg0pq8o+W3Gl5/H?=
 =?us-ascii?Q?mI43gZ03qaS9cvCdxoFL1g/Hn4pdVzbHz+wvTB5KXTTACiIYAJnrpsEq77UR?=
 =?us-ascii?Q?6zssjU4gIsNcrPjWuSJeNPhdULDc81+ciivsDV2SkBeYoDRMh2HtRgiLoyId?=
 =?us-ascii?Q?H+n9DN/OsBwWEQs0aG/iLgjbSKqJCC2WtOfL2939JwAg4PkfR2n0DiSvqLzu?=
 =?us-ascii?Q?KZQDqNGd9uCRy5gBdBwvILIBj3A/StS79ky5ih50TT73XMNRjwo11+9sc3Kc?=
 =?us-ascii?Q?hQtz9v+m/yYeDdtSm/3kNgIWKdfKsS3b1TcC/DvU0cMnHuh0ol8NY9XLM7Qb?=
 =?us-ascii?Q?cpeFFy4wKxBr81OmqDcCSHLXd4rsTKBdrq5vS2S2ESMwvbzeaEl3/k2+Gl7b?=
 =?us-ascii?Q?3bLRGr80t+ynqJmnASX7tK6WBNiEoEiew9BDulSKKQY9irKpo8WWGyGLry34?=
 =?us-ascii?Q?+QZHA3qdrDYGxHtwrkN91xLC0HT8SnEajNpf8cZuOZS4OwQzab+aCCLi1Elu?=
 =?us-ascii?Q?zDOquxl2lwUEvxWEGommWrc6oEzy4xtI3sNaZFJ/LHUGgXkJjFQRdj7zRcFd?=
 =?us-ascii?Q?3/LEwOqevhKvJDsUNy9fepMKaSb9UbhpQDSud2Ywj+2T9Kee0de0x3pWC+vs?=
 =?us-ascii?Q?MQN612aPLg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6007500c-60e4-429b-300d-08da18698473
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:37:49.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kma597SRAQTDG+uRWpHlMkjB6mptSbgjYvNTeZEkzNpuiHPaCTkosjPBFT5Mt6XdSPJlrJbleIcHTxJNBb321Q==
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

The verbose flag was added in commit 81c7288b170a ("sched: cls: enable
verbose logging") to avoid suppressing logging of error messages that
occur "when the rule is not to be exclusively executed by the hardware".

However, such error messages are currently suppressed when setup of flow
action fails. Take the verbose flag into account to avoid suppressing
error messages. This is done by using the extack pointer initialized by
tc_cls_common_offload_init(), which performs the necessary checks.

Before:

 # tc filter add dev dummy0 ingress pref 1 proto ip flower dst_ip 198.51.100.1 action police rate 100Mbit burst 10000
 # tc filter add dev dummy0 ingress pref 2 proto ip flower verbose dst_ip 198.51.100.1 action police rate 100Mbit burst 10000

After:

 # tc filter add dev dummy0 ingress pref 1 proto ip flower dst_ip 198.51.100.1 action police rate 100Mbit burst 10000
 # tc filter add dev dummy0 ingress pref 2 proto ip flower verbose dst_ip 198.51.100.1 action police rate 100Mbit burst 10000
 Warning: cls_flower: Failed to setup flow action.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/cls_flower.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c80fc49c0da1..70e95ce28ffd 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -467,11 +467,10 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 	if (err) {
 		kfree(cls_flower.rule);
-		if (skip_sw) {
-			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
-			return err;
-		}
-		return 0;
+		NL_SET_ERR_MSG_MOD(cls_flower.common.extack,
+				   "Failed to setup flow action");
+
+		return skip_sw ? err : 0;
 	}
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
@@ -2357,8 +2356,9 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 		if (err) {
 			kfree(cls_flower.rule);
+			NL_SET_ERR_MSG_MOD(cls_flower.common.extack,
+					   "Failed to setup flow action");
 			if (tc_skip_sw(f->flags)) {
-				NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
 				__fl_put(f);
 				return err;
 			}
-- 
2.33.1

