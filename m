Return-Path: <netdev+bounces-8022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 041E0722726
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1848281232
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B46619E40;
	Mon,  5 Jun 2023 13:15:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4442818C1D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:15:19 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11534CD;
	Mon,  5 Jun 2023 06:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c08zle5QJ4BJ16Gik+vffI7BF91stnlZ3n8RMdW92rZ0AbmgkpZKxPfG0/JtCsxRx4d2yeGBp5J5+/6mVpmLc4daMzEleI7DzDMlgqeiFDtv6KHVAlltg6oN1TZNiYsJNOtImBFath6pm1TD9V0laUeMKKgxg1twGfKZRAZSStRAAnsYMmkzmVOZ1sgDHZnOOaPx3mFlICUceFrPMoL+qqO9y2BLATVlJv34fYn6pnV/pJWvjxMCT5u1IxfW4657+PvE0Ccc/9wV9Ly/9SWuuXLK6xGbCJZCAVGX4/R/cwc6Vz4i8IhUZwPQXhPCILN+85G8wkB7+suo9gTeAs/xXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaEQo3SH1vefAm1NJlWDlk9Ws+zHEcaZOrLoi6M0Hvw=;
 b=RkpYldL8ApxkADDyEHVthzDWladGcCnNfMO94l6csWjqVpsJ2N8H3Dy2N7Lm+8dsmpd/MtcVQdl4ogOAZbLDfjiMcgAftymxecKQoSit1Y3snkGzfpkrHHcJsHL3JEFa1qMQ1LCDdV2mnMvcHGkR862aK/SZQvfKCll+7mqAU9JXQPtS8L/6jIs8L95akdSKMmYIKSMLjiJ2bvinsyIavoLkt5VCmSfaP03dfxGGeqjHEIt2Qdx0n2TNiPYx0V+CPOrBp6BYsuQGOxmvCXHZ/d6FBOc1vzM71fCIibrPHu1+seU+G5w2k7uZFMrYZs25EblhP9Qc5MhDyU9jXieenQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaEQo3SH1vefAm1NJlWDlk9Ws+zHEcaZOrLoi6M0Hvw=;
 b=mFG+3lN8lxoE/BqEPcZblUlQbI39IWvwB1/0xY32GjFJVIG6lpUKlko13upRyAaXd3zlPZtS/LtEmzdFjLlDcEd9224yMgSbD2IeyRNUxYvaF6owek8vp54IkxbqCxzr4L2lbgQc/V4LQwTcJsqn2vEgUQiHHoSFqD/CvpWlw3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4927.namprd13.prod.outlook.com (2603:10b6:806:187::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 13:15:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:15:14 +0000
Date: Mon, 5 Jun 2023 15:15:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wei Hu <weh@microsoft.com>
Cc: netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org, longli@microsoft.com,
	sharmaajay@microsoft.com, jgg@ziepe.ca, leon@kernel.org,
	kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vkuznets@redhat.com,
	ssengar@linux.microsoft.com, shradhagupta@linux.microsoft.com
Subject: Re: [PATCH 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Message-ID: <ZH3f2abyRU1l/dq6@corigine.com>
References: <20230605114313.1640883-1-weh@microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605114313.1640883-1-weh@microsoft.com>
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4927:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c740ac-8d6e-4270-c733-08db65c6e60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r6oLAQNy30CZyc6DN8UBcyyAzmFPRZTB6xi9vTXsFngPfoLD5UHpFjobjwS704jILkutpSiQi8KyZcPxeub1BAFbE571Q/09eyx0/l7YacIwsrgnEJCsFw7ITDRCHR68u+ZAjjn5fB8oIUmVITjMSLJzzlkfTdNLlSxSEnS+az5QLhMctTTI0WPPHBTVJMv0zV0LT72oAwll8wTIJpyBhTYzOQlrnsKJqXkLGx22Y+b4JXE5Z7JKS4vQ2HfRDZCsNPZ17JS4luxD5SojS267xJMHHXkhu7gJUMcA36cc+T0VEHzSxwgLBRy7sXOOxZq4rCEp65VTwhYrjOkOO+TQsGUaTXz7cD4T+8m4mGZ+o5eKjeMhI4QsISJrvSgkzN6xuyhLTWv1Hl72PD5Mw6E3nsCCLiNptwfIKL8eN/ZpafF3Popi1zMc1LskuhADBSs8inqniXnt1e0Ypd0K7WdeKsk2shuJadoYWRE431uxn8bhKbYch7t8aGjs3bg8xCzheQfGar5bncBQZ0hk8WNwC2+ok8M8WH7cFIPvKWtGEuxfHGmNyqc1zOxSvUMPl7cxL9BDWhwDx1ZD2Lkt9VGGuhNZXBi3S0GaQD+NyIZHb74=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(186003)(36756003)(2616005)(86362001)(38100700002)(44832011)(7416002)(5660300002)(316002)(41300700001)(8936002)(8676002)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001)(45080400002)(66899021)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KBqCXVxb2T2Sfyekxtcdfz+N0hmIa34A7PJiAonN49Nbs60JQPTRdfCrYAz6?=
 =?us-ascii?Q?DmbDSsShJ8R3Onjz56Be6bCOpQk/e9/p/koFSUPp9Yw43P5Q5Fy+VwBtcCBu?=
 =?us-ascii?Q?6ZmlUEJjnaZA3qNf6r26/yMptVOKt0uVolanky1oP8ZdiOOh7LW9Sri260ss?=
 =?us-ascii?Q?e86PWl2rOg9O9635UMlz59es/hVcQf4REIDchmU05Vzb1WFo1mXEgoCNwJu5?=
 =?us-ascii?Q?bBbmrNQfNgrwCnTMaA5vAwDvkAh3EiqWzT96yqGvwgqE2IQh6c5fsslebtRh?=
 =?us-ascii?Q?7hDwQR2i4SSSLavyzVuClQbXHfOiCKvw+irtzKcH4khbOeSYTAIF1XRINiFR?=
 =?us-ascii?Q?e3BT55VgWd2zCln4LKrAzSGovTl95PwLMRQwGy2qCKjfUVHM7uvRGtgVHO3T?=
 =?us-ascii?Q?pHhiK3LHxX7+1hLpj47QQsK2ykZru0XK0st2Dbbfytss684V5UTJqlUag2y9?=
 =?us-ascii?Q?i8fJ7ZTJVBqd4vafrJMuoM4+fK/yVUIoEAXenWvSa7Gb84xCUfUpeOop1Ayb?=
 =?us-ascii?Q?6jHZzO5ZTDeNUEVbChUtAfU36bMCyzmBvjBDkkHAD+AE1ACL/i5AxEc/PEeo?=
 =?us-ascii?Q?2Kty2X36XCwRdVBnoePgc/NXXIVYDoOMrtdVqIMblNLDNAO9PcaMgewa/LiS?=
 =?us-ascii?Q?2KSsQKDw0vA8dMIybIoXHx6ZCRnKqb/kKRzyzNFi9pIahr1e1HNyPyD4Lch2?=
 =?us-ascii?Q?E0gEVhuIBUgDCLhtqMmI9QIAzFHmIgZyoFx1Kd+C6nVjaqlxpwBaDK2zmxx7?=
 =?us-ascii?Q?PFcB/Nbo/b7o+IlnnshchUnyjRIV/X+kHdc97NheI4OykHYFBrdxZziRS6OG?=
 =?us-ascii?Q?BbVGj4mJa4zNn9LX5IEYW/kwHd2XlaDwm9b+dcCiHVZ0u2wLxmC0QW6RJHeU?=
 =?us-ascii?Q?BnHPHI1fYwbH9nIny9idl+HjZgNi8DaTDYBdBke5rRy28Tf8g0odjCexB/f9?=
 =?us-ascii?Q?Iq3s0jIwUeQRbkD4R6vcPTaeevGNkfUP0PgHQno5wd454hgv4sp2JVNqBHyx?=
 =?us-ascii?Q?eks/F95UuDGG2G1Yrv3jH+Ns7pv/TTbDYigpYI1GZrot3VxNvIMlCzGrPyGE?=
 =?us-ascii?Q?UF13mFs/s8ETJg0VFGSVrs5wJnQK+tcSV4qtz6Hw8xozvy47MSt0geE4FykM?=
 =?us-ascii?Q?X3Q6FN2e5OGN/BuT/1ZQwzuBrlUvN1BAZc+x51Ivn/qkNBf3dtjTKs2mb2iU?=
 =?us-ascii?Q?nFUA61Nq8WadW86ci8/yh7waVcLipXXiq55MbKVKVaBy7YHR15bRdgZyCS6C?=
 =?us-ascii?Q?zF3bdiH8HurUBb584JZRjywI43jU/TSuxHMiZQJg0PmN4Bei9dJLBsMiKqWB?=
 =?us-ascii?Q?r9YSGCyIthJHJiTjtNf3EUmuTlPFVxzOUO+q4cHV3XrXe59VVL0jljxFD+UQ?=
 =?us-ascii?Q?ixNdntrPOVDdTk0yK+sqUHtHZ8+Ja0ks9W+79SAh5rRSbIvhTZVrg1ObVmrJ?=
 =?us-ascii?Q?HaP+J7MZurz+om1RrH3bkOvVTNbu+ZjzWJT2afUCEZvfEDdGPxGevwQrM82H?=
 =?us-ascii?Q?iQAzga2hY3lqNWliXR6CKmUtkbAB/SdF2YEtAO5kwRoh+n1+HhpcWdkm/WQH?=
 =?us-ascii?Q?m3YTcpJl5Yv4uKspIcUdd9SuDWjPH98E0iaFKFDbFTcTIzhQzmm4u2FvtvOH?=
 =?us-ascii?Q?HknQ5hpnrgCNHxIE/gqf/udXy2LjtxI0M++UoQrLonvSxQxSsau+c1PkSedS?=
 =?us-ascii?Q?xDrswQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c740ac-8d6e-4270-c733-08db65c6e60a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 13:15:14.1936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vx40IFO9D65o3tKFVlcOwB4MIDlAk9cd6MUXgfudgSHRENDFsy7P5RYqjYJemYSuJRSJeqUhvIIcSFln7y6UEvhGbAPyQqtHWW/Zkpx1Yt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4927
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:43:13AM +0000, Wei Hu wrote:
> Add EQ interrupt support for mana ib driver. Allocate EQs per ucontext
> to receive interrupt. Attach EQ when CQ is created. Call CQ interrupt
> handler when completion interrupt happens. EQs are destroyed when
> ucontext is deallocated.
> 
> The change calls some public APIs in mana ethernet driver to
> allocate EQs and other resources. Ehe EQ process routine is also shared
> by mana ethernet and mana ib drivers.
> 
> Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

...

> @@ -368,6 +420,24 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
>  	qp->sq_id = wq_spec.queue_index;
>  	send_cq->id = cq_spec.queue_index;
>  
> +	if (gd->gdma_context->cq_table[send_cq->id] == NULL) {
> +
> +		gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
> +		if (!gdma_cq) {
> +			pr_err("failed to allocate gdma_cq\n");

Hi wei Hu,

I think 'err = -ENOMEM' is needed here.

> +			goto err_destroy_wqobj_and_cq;
> +		}
> +
> +		pr_debug("gdma cq allocated %p\n", gdma_cq);
> +		gdma_cq->cq.context = send_cq;
> +		gdma_cq->type = GDMA_CQ;
> +		gdma_cq->cq.callback = mana_ib_cq_handler;
> +		gdma_cq->id = send_cq->id;
> +		gd->gdma_context->cq_table[send_cq->id] = gdma_cq;
> +	} else {
> +		gdma_cq = gd->gdma_context->cq_table[send_cq->id];
> +	}
> +
>  	ibdev_dbg(&mdev->ib_dev,
>  		  "ret %d qp->tx_object 0x%llx sq id %llu cq id %llu\n", err,

