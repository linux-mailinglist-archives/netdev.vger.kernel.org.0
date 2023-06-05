Return-Path: <netdev+bounces-7949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A592722316
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7ACD1C20B90
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F02156EB;
	Mon,  5 Jun 2023 10:12:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0964432
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:12:55 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2111.outbound.protection.outlook.com [40.107.237.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A114DF4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSStGb4dBOBUChTqYstzBmWO18V/HUKhObrOf3ZxGo35CxNP8NKrgR+sIdSdPtGR5WVlAqupjoIAvVIR0H2PekI6YKmdypXFmJR4SZeTOuWF2bJJzbaFKjdp520Rs14TG1RoYdGjfdEbPu8+cUE4qR4A2kK7ZqsWSiOn0x02R1G+cjtMYk6E80s64BzxQmTuLJXVQv147Xnw/Pr9Yxk7djypyuxgN7jTEvgPOY9inmsOJTsOT06YdNxMNUqL4IeaX6BfMt29YS5s52+ES0bH8wYb00rbXnQ879K+Ya03GISLtB+v2RgtdH+h8SYXWygOSOEPy4sdWU//q11lTEBYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdXx0G+FAFNDkNyEJZnAD1d+A480duzHBBycDSfA1R0=;
 b=Dh67vvmemRqfLr6ZPmdj7qF1HiS1hX1Q8IuMmIAlF1DeTygNQCL1qaKfgl/efZ5giksF95IARWwCyrTiEiRQ8vqneKT1hGoykejvBtjamTnTVV3eTYJTWtGB3Rt6vltB+FHHTQCot6pCbgFhs05XA5OejIuLpdUyxE/pNLcJ2bCwVi1sVi0GCB/ue9xuUbgMt5C7dasJAslGnSjgInxMF8YgR8QtU4DhiC00iOoHSkI8gNbTpRfNY/fTNfzzZsQoeuuo5q+RJoBzz1NgiKn4dOlDIuNTXUbFpaqJiYqC7YzGeaF5t8fDPoWr+LQgS/M1N3WUqiTT3Ax2kyQaeA86MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdXx0G+FAFNDkNyEJZnAD1d+A480duzHBBycDSfA1R0=;
 b=mgFvlWWB5GWaqM9Vi8wvweQ/T0pMdn6TYtW//+myZQ4ktiwmJT5cTeoQvurHCUdZ/kCWteuAA9SuGTJ7h5cd8iwORZFUeL5+EsXAysezMTjdUt3Q1RjzZadPChtn4PniP0xKqggG6ujhKqH2G95SJ7H1kh+f+MsPSTgBpTHRF/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6534.namprd13.prod.outlook.com (2603:10b6:610:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.13; Mon, 5 Jun
 2023 10:12:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:12:51 +0000
Date: Mon, 5 Jun 2023 12:12:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com,
	anjali.singhai@intel.com, namrata.limaye@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com,
	tomasz.osinski@intel.com, jiri@resnulli.us,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com,
	khalidm@nvidia.com, toke@redhat.com
Subject: Re: [PATCH RFC v2 net-next 10/28] p4tc: add pipeline create, get,
 update, delete
Message-ID: <ZH21GzZ6HATUuNyX@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-10-jhs@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517110232.29349-10-jhs@mojatatu.com>
X-ClientProxiedBy: AS4P190CA0059.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: e7448bcc-9a77-48c0-dbdd-08db65ad6bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sgnqtVcpn/enCpPkiQ+H3CDL4WBHL7iXyv/zPWTMecm6B7kiRm3Qn70PhKVTvrMNemniLrk5sheH7tqd36ajWF8T/DGt1WAjNyOXm6/+n4yXctiHh2kHYHoOKhGK7CrxQ3PwNutAF9EpeTQHOv771qSy15pnkQsLQ0/SwG0uyyIhiqNF26whw6jD1drfi7LRQFCFgTrxwvzk3Kkb39P+amBZ+XCkAmhsjYZ06IrrmtxogBP9oDIxN16J/HPYoV+rYCGAxCl01s2nURl60Bn90SKN+Xo3mEzTsGb8XfgWEFiDmPDAA8aqvGvVCW48+9naWSGi6g2qh5H9GgJaeA83DqaF3FU+DkgBPCxkpKy6ZynQrHQO32GVu19mtHAEytZ3KrPAElRvNgWv9G/GUFtEYMd1i4lw5JVT7Ezbjk78OFtcHhaObvEpWMxEyDJ7NcGNvMqg+RMehsQEZkdhUUDZDcAHMYHKrZ4YW9jVEpjvZ9XH5z4GdGjL8bLVkhffjwz+df6aI9MGsHu727vvo6oIIuVD9cPHBtOqXwgSuO54HNr476T1Y2y482OR2BbNdbIiEJbuz68VHLWZd1vMI13oxJijGdd/vSJRqJ+HiJ/Jdus5milJHGF9iRybWl+ZBACpUPSGXO66XWfVN97PKwt7AA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(366004)(396003)(376002)(451199021)(8676002)(8936002)(478600001)(41300700001)(316002)(6666004)(5660300002)(6486002)(186003)(66556008)(7416002)(15650500001)(44832011)(4326008)(6916009)(66946007)(66476007)(6506007)(6512007)(2616005)(83380400001)(2906002)(38100700002)(86362001)(36756003)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W4mFxA1DP21fJQfGI0NCv9OAt14r4coFHeiTScbdKwFA5IX1WjemY8Y1nJsX?=
 =?us-ascii?Q?JUcLagFlupr02SC5uv4zysVASckJaA1b1L1s5MjCR8C2wnrDZ4jb8CCSP/dI?=
 =?us-ascii?Q?PtmxjZIFaC8LpbufsrlKk76reOp6s3u9NcV8jpQukopZbV7qPsEQzVwbb+Sx?=
 =?us-ascii?Q?3UxGjST1YGy/rUEcDs6qfDuR+NelB2fAKrXw2Ea5YhYWmGi+Gf55aDlj02Yk?=
 =?us-ascii?Q?PFq0lHPNYU7/4LpeeHhXyUQzC4ysu5bZgg+W6WzG0KNuOklZYRq0TDjWouER?=
 =?us-ascii?Q?CM4gH7EVzlcodrt9l6G8mJq+fDYnZ4UKZSyKlBPEqziVhTySrRbwJo9+bHxB?=
 =?us-ascii?Q?6JV4+ZvE3XwQNuXy0AQRC7K8jeVOqHYiQ2vy6Zcopmtg4Fd+in8E2oGe+hKQ?=
 =?us-ascii?Q?0RoaBobvO85C6HDOFOmpCgqc7aOyalibkWHB0MIke1Dx2LXwz3toycW8XoHZ?=
 =?us-ascii?Q?hX4MRZLoxS3EC/A+GKUs8xbniBM1wjh7lbxfcH/m61kMsCXxK7LGIIVibFln?=
 =?us-ascii?Q?Bod243E2cv+kOpKysFdVlyi6YhCilf8jKvJEARNtQbLojhxSmccGFLPzs+FI?=
 =?us-ascii?Q?sQ2hZnHRfs8IUs4spER2Deervjt/Vl4X8WXvDuxsor2HBVW0oMBnOx3nDskl?=
 =?us-ascii?Q?yx88WZtsacCJy0ZTezFHW8gpFQJGaKOfyTlSfTfyNCpb/DUFDQZc7w6sZUlo?=
 =?us-ascii?Q?PBPCKPwmNOZzW8XVg+KdlSovy732EfIeBC61wsOURCeMWOPpHTJrllkPk8VD?=
 =?us-ascii?Q?k4EmqBy2nL7v3q9VGJXKf7ZNtWa4R7NRmT0pVP21tAG4965Bt84IzFlpYrne?=
 =?us-ascii?Q?iN9ZJvJemoBTb/ZJmK4893mHmfesGEd6pXIG7+xCZTHKZWo3SlCddWBRgZpd?=
 =?us-ascii?Q?m5PIf3/NIZwkyhQYlTpLup+GiUCIH8zRLrophx4Ql1e21qaw2k2bpcJkZjLq?=
 =?us-ascii?Q?/kyt89cYKH1brjqR8M1i12DYHwnS982eFb/5PfMU1zkxn32+lhTChOp0OtEh?=
 =?us-ascii?Q?c7+uwvsDr1Bxcqkd+rLhppODQGW5w31/EOgm/d44d8EQVTw/RRvrw7YsWKqW?=
 =?us-ascii?Q?59/VrSYPh9Y5TFDoUIkzEzoODxqwNodYUMUlU3P17ye9TcCLLOnUI23F4YJv?=
 =?us-ascii?Q?QMwvVWAeC2T3N9jACERqgC9JEk7A6r6Ao3jzkIrONWvK9saUAe4XKP7GFCH6?=
 =?us-ascii?Q?dsWd7pNyWerCdrokTk9BEWEXWnzQPCi6XjHCOZC8xXmTwP3mOH6N4pgTTVn+?=
 =?us-ascii?Q?OzW/pW1VJ8Kg3FMmjFZuGrh/9fIBtNo4deLub/9IgDH+zpJwAD5lirzl+8EE?=
 =?us-ascii?Q?RipTe/pWgVhuy4qFHXydyv/1i9BHkdgaXrQTdRImthCinRiHiiqaUe+OYjel?=
 =?us-ascii?Q?Dg7vYRU1iy+QTyVHu0B5TYFY5PoPy2tdXrgX4iwQCOsoNnkGinCQcdXZFHJl?=
 =?us-ascii?Q?k0/OvtllDB36mwYYjje1UmiOtB7+fKNGgIy1WOmBAA0KAWUeTnEOr83cBZAe?=
 =?us-ascii?Q?PYVSk+tdpt2xsViD+pnnuKVpEba+FuyEEJ50QI7aSCBYmFhi80I1JWMrOMvD?=
 =?us-ascii?Q?93vbJNtFpLdA9nZhOcXKLxQHXTY7eMJvB/AGBsSKFYFBOHZJzzM/6Y7PldU2?=
 =?us-ascii?Q?nitaYWz6Mll3LGCorfDOd80iI8eZR2oDtX8jo+qminwBWtxc+upfaiE2TosT?=
 =?us-ascii?Q?ye1HPg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7448bcc-9a77-48c0-dbdd-08db65ad6bc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 10:12:51.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJTzAcOwoDon/6ZBWsgKswaTsJ8/sdCs+WGxNo0NYmr1IBW20Gf9H96Rej71LvEGUFBmvhX8eLm1XeIIimLiSLN2xFF8ScA0L7GIHYPEI7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6534
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:14AM -0400, Jamal Hadi Salim wrote:

> +static void __tcf_pipeline_init(void)
> +{
> +	int pipeid = P4TC_KERNEL_PIPEID;
> +
> +	root_pipeline = kzalloc(sizeof(*root_pipeline), GFP_ATOMIC);
> +	if (!root_pipeline) {
> +		pr_err("Unable to register kernel pipeline\n");

Hi Victor, Pedro, and Jamal,

a minor nit from my side: in general it is preferred not to to log messages
for allocation failures, as the mm core does this already.

> +		return;
> +	}
> +
> +	strscpy(root_pipeline->common.name, "kernel", PIPELINENAMSIZ);
> +
> +	root_pipeline->common.ops =
> +		(struct p4tc_template_ops *)&p4tc_pipeline_ops;
> +
> +	root_pipeline->common.p_id = pipeid;
> +
> +	root_pipeline->p_state = P4TC_STATE_READY;
> +}

...

> diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c

...

> +const struct nla_policy p4tc_root_policy[P4TC_ROOT_MAX + 1] = {
> +	[P4TC_ROOT] = { .type = NLA_NESTED },
> +	[P4TC_ROOT_PNAME] = { .type = NLA_STRING, .len = PIPELINENAMSIZ },
> +};
> +
> +const struct nla_policy p4tc_policy[P4TC_MAX + 1] = {
> +	[P4TC_PATH] = { .type = NLA_BINARY,
> +			.len = P4TC_PATH_MAX * sizeof(u32) },
> +	[P4TC_PARAMS] = { .type = NLA_NESTED },
> +};

Sparse tells me that p4tc_root_policy and p4tc_policy should be
static.

...

