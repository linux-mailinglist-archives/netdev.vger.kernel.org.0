Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434634F77C8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241971AbiDGHlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbiDGHlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:41:00 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2067.outbound.protection.outlook.com [40.107.101.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3EF2BEE
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frFeMFxVRiEe8DMCLO1j/BfTslqpzkJ5GwYdG2DslmB/wZrSuAjLJFUnSEIs3XqIUsu11hV1CLtGOBp0YzPMGzKTQq87TMlxxYx93euT4C/+h5JdJYGQuw47/7JlCyFT6R8m3YU+IuoqiW/ZOFS59ZToR/o+hhSpi/C6/nOAtAeaODI7VIxIO/MGKRFlcD5INt5dPeGe/fGaYaATZKLdm9WiadDq6l0Cx5vFYsL9zbl+JQXMDCLYqrgHND1K1je9UTVoZ9DCmaf/5jpADZFqKXzhEdcAGr8bthUwZc9FExQcn2BnZ1O1GwkYtqpGS6kSMg1sKbVv8tGuJRYyMhz2Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6krluR5BAwuAl6bt0zgFpEh+MOxt2TmdVoUxMAPFXd4=;
 b=aYYKw8UwNc0uPmIxkZORHr32VkyVXqNAmhc01Mmbt+m9eSnNy81zXnYOZEq+OCAjszbKq1X2TlJ+XmSguqFd9OsTgGS3X61AQO4r6lpV24UWEMX/hasiMIvTrkXGjaEqbTsE8s5EP7WEo78Zy+L/RxtmIHFkbJg7SUgHuyflvg8kIEgTg6b8x/9NUUImSrbTFvGct5viYYWavT3ee6CQ0nkiKRstpxe+3oGy7AJ3tt0vAFttifutCp+EJazQh45Kzqifybge/umOfqcVt7xSK/tFzLwzESiDnDPI+8PREiEOCu/bDIZTIp3TDuACoBiFERL654b/4NIuWAEb774dmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6krluR5BAwuAl6bt0zgFpEh+MOxt2TmdVoUxMAPFXd4=;
 b=dALm2w3vMHENHFFSPsOf8xswqGa7apoyLzTr2OEEHaSGXrtkfY89q9MB4n0Q467+VKWecwp36tEzg1/v3qMXR7V9rZ7UxiQF7tHuY8BrrnXUybc4+fyn9ceMcYR3StZaOJR8MD8azs8hJrUT2GOCZiC4CptTdMUnTuHsx2jqWX+nPzstTkHAWKGROEx41Nj9Yr1Z44C8py4vcLgvXGLeGUxLUdL8LtcdzFZEMRcjjpqoxSj7STLbZ+3ZqMEysxA4HG9tbSXFOuWb4+m7vlN7KTVP15Yofa9WV+37R/u4Eq9LwkiY5fg/9aNH3IVgB8Zr1X7Qqby/XYVPTrMXgiBy6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:38:57 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/14] net/sched: matchall: Avoid overwriting error messages
Date:   Thu,  7 Apr 2022 10:35:32 +0300
Message-Id: <20220407073533.2422896-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0040.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 864919b1-65d4-44d1-eef6-08da1869ac76
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB52289192B36AC804D8BA7B60B2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7JrRGB+v4Lkrn+bPOXG2DaCaznNwtYZpHzzN7ko8X9FYWi99UFU/Zor8hlXGne4/lX/Kw//lmSIamGcWCaU98QnAk9LyJVNh65LYyVcizfYNNho6CoZCjKCoKQS6vlhVkjE0WEhG3K701cR+sFywFTYo0JbDBGpq+H73GW2jxpoZbU9Ok3GJzzSs2ChIgGAxQ2fnRFn4ks7flurpkaU0CmjTMTDn6MIDaDdHbse+wnGMJXIab0OVvc5oO1OJVD2OxRvu0++cUKIyLcEH6PX/TclVi2fcF6KQQ0bTxcixuQ6vjzMap8vX2NiDYnsQZVlcIG2E7/2Olw7bpRTPOhxQflO7Q7dLLNAUSm14dAx8GyBHygeWMxfSWtssn0K86uuCDqNXh95JXmyFOPheDlHUSDRzMH99SjdGP4aqs9dCTGeQ4mqBvaShaZD5W012ly4Xl023S+s1GeZaUGkuqGTAPGhszLN1PtMd73CRdQJwECNPxOtuRrMQwZDwzOlXhkukoXDGrVWwx2xteaSpAZHEVWIK5G6MooYc4tcNqBx7woBihtYH44DzmSash4ykhwR+1Evl8Uo3EXYonSR0d3ORUnPRgj8PRCuY8pXJ9HE1tzP1uKJtQhLxIDqgdI/w3cdXWowpWR1YnZxVSrw2Grycg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c1VSjhp8FU9amA6mbOmWD6Pr+I3gegn4nvZjCwJZoiQszyseFVppnRSBUzjz?=
 =?us-ascii?Q?pWgtQlZApK78kn9q5cgvjapmpR+TnAIyONaDyj3Rj6UfRljlLR8izA9bmxZr?=
 =?us-ascii?Q?L/kGe0NuZsgvC1yUkaxMdAi2lpkmXAQkcX+9K8o+EXEhPiV3XMwN82hc2K0y?=
 =?us-ascii?Q?41naeK+jGVLQxJg3eOSkMLuTYitTHBH7eOHkuQo3MCVxhfV5Hia2xAfEllpF?=
 =?us-ascii?Q?11mGdprKB0Lv0vnuDN8rkV2FlcTV0oUPttlAmzCAvtxjHPVZslLhu2RZE2M/?=
 =?us-ascii?Q?aV6RXBkCtI56WjDg043s6uW6XsGFO4rJPV9VzfLV3NOq2Hl796KOjGpTp8OS?=
 =?us-ascii?Q?pt7BCLptjpI3fetmi88zcuJVYjtCTQapjB2T5RvfBjhgQ/QXCZwLuEHLk9R3?=
 =?us-ascii?Q?p1CvUXh3sPwzQ+t0wk9YlpkKNTftXH/y0l5sEyHvTpGfGAimW52Oytb3zaL8?=
 =?us-ascii?Q?+Qr8tBpn4hYr5dfJFGj0NoFgjRLdcvfy+jCY4FLt2/JCFJ1WMzfGXr5+4ui1?=
 =?us-ascii?Q?SZ4f3NHb+ozLq1UmH3Z5S97YSoAH8PxCUk4eAKkPUfrGjI/LHKUYEjy+Ypi9?=
 =?us-ascii?Q?L/lGjanzQR+gUvS2PdHYDxUTj7RD275kx82Fqwky3wFwx6z7vhF+RuRkowm2?=
 =?us-ascii?Q?dlvGc2BaR64dkSMmO1qJ6skm0T7Kw4WPQ+Y573bAgcBsvMer7VEf4gXXF7s6?=
 =?us-ascii?Q?stM+pb2yZYAWvvzCypWoH52VO1JLHsMPzT7lfqj4sOuilc9JRLVGagnz6/kW?=
 =?us-ascii?Q?fvCQZwitYMMnYUFGbULCg8YqZr1owWWZF10qEA7Zgn+Y/evsAFoBz/hTxMKb?=
 =?us-ascii?Q?g0rqnVSbHV+ca0Nnyq+DErNOEIyUbCgeZ8dZ6MiJ4/kpqaSbEXCHFOH9rO10?=
 =?us-ascii?Q?65K0A8AzzyqCS55Pj6lxWxI/ggsnX9ccZA/ORCsLR9ZbrcMiye+89dno9+O3?=
 =?us-ascii?Q?2FuWXiZE++OMHeMKOa98LMy5uvcM7N4pXNg6HIH42vuW+MsrBj50ci22vilX?=
 =?us-ascii?Q?lha7VH4XcQ7g6HuDZRDaymb/30A60Ov+LQAanELOe3Pg3Lxy5dfBRoKIQZ+L?=
 =?us-ascii?Q?nx8QHkaaUrJ+jmnbXgLiw+cw7Yq3jS41Ttc+Q3/bw9OYxgNHqC9BpdEAyQ0D?=
 =?us-ascii?Q?kf4im4P/dqJV8Hjja81D0/yKHj3yd1C89RuEYn8ekMZ20AIVWnXtz/yMvts2?=
 =?us-ascii?Q?DcttKzx3/Ku54R61kYtf1uvt+v/t/rUkivpawRJhIsypScDXyBtoNBKJ9qp1?=
 =?us-ascii?Q?1nVOc70oWpLAi3wjrxBNgPoyjo0gYSmSy+fCWRwRvfWvbcVF2pRLKDwU2Ezd?=
 =?us-ascii?Q?O6xeKA4xNeRDoRXhJP0UV1eXvedmiqO7Ghoxuo86j9IZuhZvoqF1+/g/KCAN?=
 =?us-ascii?Q?8nIhWi/TPi2KM+Vn1LE9AGzyvmaISPgw5NoG1aREiCst8z4RaXzYJH8Dy3+8?=
 =?us-ascii?Q?cWZkgWcAsuyE14MSkU0aKkR5M97Z4jM80RinxIwLKcIaPySLs7ZKPVkWIZxn?=
 =?us-ascii?Q?MlwZn1So4QDId8njg6txlAxybr/HTwSUDa8BBZxj7Fd39iOwPxOKPvq2Pinu?=
 =?us-ascii?Q?8SXJUGbF5UTbqm/UGcdgCCddUFn25bjO4sxM+TH7YWYEDzi4utoG9KylqaFo?=
 =?us-ascii?Q?GcWrEIF8keTUn1zf/xHfwMoKJ1vGeKMwUcszXJoyG3+q+ePc7SVXa/SqiEmp?=
 =?us-ascii?Q?XiMRmGZnQ0r6+4LOon3YiJSImtZiE1QCXFv7PaV8rGcpLGksBnaVC0vD2N07?=
 =?us-ascii?Q?BCsSdx35KQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864919b1-65d4-44d1-eef6-08da1869ac76
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:57.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swhQxgY6wSkitYJ80s/UcZN5ezR81Qi7UN7uu6pZqaU+Jgt8LGRUQVoZ0nU25ZxSdZQ9GvmjCqvyj++54rftJA==
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

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action police rate 100Mbit burst 10000
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

After:

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action police rate 100Mbit burst 10000
 Error: act_police: Offload not supported when conform/exceed action is "reclassify".
 We have an error talking to the kernel

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/cls_matchall.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 7553443e1ae7..06cf22adbab7 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -102,8 +102,6 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
-		NL_SET_ERR_MSG_MOD(cls_mall.common.extack,
-				   "Failed to setup flow action");
 
 		return skip_sw ? err : 0;
 	}
@@ -305,8 +303,6 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 				      cls_mall.common.extack);
 	if (err) {
 		kfree(cls_mall.rule);
-		NL_SET_ERR_MSG_MOD(cls_mall.common.extack,
-				   "Failed to setup flow action");
 
 		return add && tc_skip_sw(head->flags) ? err : 0;
 	}
-- 
2.33.1

