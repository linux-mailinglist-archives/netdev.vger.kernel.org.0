Return-Path: <netdev+bounces-8402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6EF723EFD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810D11C20ED7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6078A2A703;
	Tue,  6 Jun 2023 10:11:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8F2A6EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:11:05 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491E51BD;
	Tue,  6 Jun 2023 03:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcHDz5zsRywJHW+pYM7kfiI6mxtvEBvpTtc8tsCyUdLPVu6KYmeKBxozcRlykQy90OZRB940erKagh2fMpaqvXOmXA7W6ifvfevP+qArFiBJx4rTYbZcEOOyAmjIkooXyBeiurZRWwvHP3uwA7ipCw3JDpduky5jpVLOF/ihL7Ih6TSgWlbLwuAjHmx4l4aEhmaN7RRnMGEj3jbplx6MvxoPghVB4oUHod87UE2fh58+L6l7X6M0gEu0dXfnLwwsngeOY9NpiFdhLC9RxDQc0jqHwJjPRf2Ae2TgY6Q0nw6tQoPoZo8q7Y26pKu/Myg2/Tqg2rYEapYI7wGiPkTGSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW0SF987boLgutvROQ9gDml0gd8Xfn2dg/ki2laBB0Q=;
 b=FIg2cTUgqd9FI+7xy7NPTR/RKHTRSZF1lPqrPwhIVXZwAnZczB6xa9WMdPMoL9jNACnyvFEsd8p6/6P77l7iGhSXlsDse+gxE/QFwvJYuDbovyqhWyx0WjdV4YlLjHB6wrlxpoucYwDcw6lQ1fSKFjOirczu+wj/VNccOsEnqr4zBRJoR5Sx3g3RdcuwxAoTSQL2bvh/Ge0Yw+wfwECh6KqPEiQEXf/3TNVrijCpWWbM5rMoPwyd3/hs5ralt+/93ff0bNP07FlICQINCV67SpRFJHHRx4kz7Lem9ZWLiFk/KmxG55Zgwhv1Qm4dVkMy3bCPzKiqx/NkOCkwt74MDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW0SF987boLgutvROQ9gDml0gd8Xfn2dg/ki2laBB0Q=;
 b=Yg0om9D0I1/+g+Zun0ErEo1t851k3Dq2xjjzhOa0LUc4Re94hiBKrmlHb4/3NaLQbujTARq3jdEVYxnoEfuEldBBlhrlGf+6B6GE/6tBFzT67FZEIswRAfySGTm6DfyTja+B9rpnPF23OIRMAnGbp/Z0M7Fe64k5K3bI3AkGP+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5896.namprd13.prod.outlook.com (2603:10b6:a03:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 10:10:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:10:57 +0000
Date: Tue, 6 Jun 2023 12:10:51 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stefan Roesch <shr@devkernel.io>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
	olivier@trillion01.com
Subject: Re: [PATCH v14 2/8] net: introduce napi_busy_loop_rcu()
Message-ID: <ZH8GK0SIMEnAzUzc@corigine.com>
References: <20230605212009.1992313-1-shr@devkernel.io>
 <20230605212009.1992313-3-shr@devkernel.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605212009.1992313-3-shr@devkernel.io>
X-ClientProxiedBy: AM0PR02CA0156.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5896:EE_
X-MS-Office365-Filtering-Correlation-Id: 45ed2c2f-6c1d-4ec2-4c9a-08db6676520f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bVyPPRh82OjUtUaLNW+2qA7OIjSgcT9qXscs6u8U5XQBAUVEonlRXASm3l7tCWjZt9uO/1yE3/tIMiuCSGyE98n4mDNpg2sGJZoDDX/FG3LEOp7KdMITxZD+6vcj+DeO//UPsWQhKjQS2inX69fIElw9xvRSxYRp1AMVeQF3WYJE+Z9PSylhKT/I4ymkUX5bEFeHi8gZkGXpiVjnWkK5gl7yyiLSkYL9f9bn4qOsPPXvIcf296HonBDBeEDemmnfniwG71d2PaLe0ob2cPhTGh2/ldFw9JZ30joaNvd2ZvlMduUqXUb7BGYw1dnLLMA0MBSlcSsOM9ureQjT6jCSUAC7yADjs6zg/KF90vZqixspVtPgXF3MKxraU5M5vr4B4GNj6WK3OLYz9NADSxpNEL0mB0zLi+Px3UMjQDGaqAHVYa5pb4mWhL3OMMOaqtdoRo8MOd1nV5Me0hlBB+DPPyKyQ7jWCpHEVO5WFjyfd24idwr4kT5HHy4bwBUCbPrObQfO9ekhybDa9IPNxH9tKTv5lTxjVxQZ+nC2WkIG8CsLsC5SVbgvZV/2SIQb9QXH8B/aBVTdO69hHC1ITWA/2/nY8I6VtGuBSWB7aSwGzyY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(396003)(366004)(376002)(451199021)(66556008)(66476007)(66946007)(41300700001)(2906002)(6666004)(2616005)(316002)(36756003)(86362001)(83380400001)(5660300002)(44832011)(6486002)(8676002)(8936002)(38100700002)(6916009)(4326008)(6512007)(6506007)(478600001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ebrpvl/x7QKDMeuR6tl5e5pCYCiwxHi9DGubMAJsG4L83nmsXuIzMGYlvqev?=
 =?us-ascii?Q?+XMmCQk01TPqXe5O2uhQRwcdAshcvVGTa78Mp+n6pBkHnb4ZAdiJI/S4oKEH?=
 =?us-ascii?Q?ePSGLaxp8EWXStZxohoohq13sbu+NiD10SgIID+dhU33uWheuH3jv5GkTdDX?=
 =?us-ascii?Q?LlwCp2HHPDdF7mYAsQPHTqRA1pWnmPJYE0UthHw39q2HFKEClmd6uD+lBXny?=
 =?us-ascii?Q?rjdcfJOnH0QyYzujblF5UuYuOwvY03wwEmbZ8/5cftr/tLYsgE98AjZr0ncR?=
 =?us-ascii?Q?yS/4ZgfA5CVHxiFKWGhnyXP2nCSYzd1vAMS7LFlGyzP7FKDKp0/4LHrtF701?=
 =?us-ascii?Q?xdkiHs0IY0la9oCuVKFmEFgQpvqrXEXIq2GFPVP0guNcLm2QIt+XnvWXxnxW?=
 =?us-ascii?Q?7ox/V97ABdPztWjuh+DwYZeBqBi7CKrx2ysRJAdbKTdf9pc5Od0mKgNQCzU+?=
 =?us-ascii?Q?LPTOOB7RfmUfniXuGxTtpbe81BURD2aLBxroBEHDpH014vR1ccYXWd18dD2m?=
 =?us-ascii?Q?XhGZRol0paPjcRjGVYgx9mpWsKJEkxiWV7VLRDytO99neQsF4UcAu3zTCbPO?=
 =?us-ascii?Q?V5nba7PC7nillD7NGgSHcZtpjdjhLYcQ+9SEl+El43TO1HdlPeYqRuTyGVEq?=
 =?us-ascii?Q?eNlXxom/YXFE2kDBeetTWbwVThmXjFP+ZeMu3Jv4hI/29X6WhVPH+SraO5Ix?=
 =?us-ascii?Q?ZahypwEdsI9ANuQQLOIQ472trCQIdjHFHgRZnjuDIJ0zfuUnBqROa28hNpn6?=
 =?us-ascii?Q?ZD6G1XDrbssZLH1ICQg4J3W+DNwo2Z1UNTgv0leMD3qaZjI+XG5lhC6bFIY+?=
 =?us-ascii?Q?eihKmiBfC+FIxV3TF2e4JODKZRtraqmzMjUrPZOtEXrv9W7gJbqZpowvN98e?=
 =?us-ascii?Q?aNUUB69+Yql8bFtYzQRwN9nyDa6rtpzmhOr/coaqrwOE8RMwDT2gSorY7y2H?=
 =?us-ascii?Q?c36VNgSY1oO9re8OfLsWdWGKhQFRz5hYGXZBOmwL08/iVh1LuadmiaEj6SQp?=
 =?us-ascii?Q?lJKW9pxHfpWvXiYl1YldNKPL4x0vlTRBZK1MguIPnGyAryS3MKhH05g1eJrA?=
 =?us-ascii?Q?Y9nQ57oXYIkegqSNHydTyPms4kaIGJCBVIWfGGWovXOA570EdI82hr2rI3Fh?=
 =?us-ascii?Q?Y6m0wM0Vmjc4bpOQoFPlvTQ3TrDyXfbbLHHP1gp4HqMiRU/UEQ/yHSJ8kO9f?=
 =?us-ascii?Q?m58QCyr+Elkl0eAPdGgMTc7b3N64oxWqVKg4UzodfgqH08LSpRAuKIqrneAX?=
 =?us-ascii?Q?q/xuK08EF5sLRsjCzsKWnWoSUZ5U90wL6pYcJCRcTSFpNBqKtiihYTnVeGw2?=
 =?us-ascii?Q?6rf3oHDBZAwsBfXUu3i9TeyxTFbDGS1U//7+Pqus6ADvjIk9XIDYh97kkFtm?=
 =?us-ascii?Q?qUcJUtqKFSzajdsAi7M3v+LkcYA+XGpOotmpJRXvfN+QlgXbq5cOw3jw0taM?=
 =?us-ascii?Q?troQEvj9+qiKKIJKwcX+zsn0o1nYlqS2e/yygdSnn+Kszf3iDP3/LNnDRW7A?=
 =?us-ascii?Q?uilgh+1LgwXTArYJGYAKAfafWuG8FiQe5TF1vMOHEgFKycfs+je/YR5ZehFD?=
 =?us-ascii?Q?dVQGJKKExzKBROkmG7PH1w+ZgSRwwyt5QYRhISonx4C2WjjpS82hz88CtNQh?=
 =?us-ascii?Q?cRyf4nMVgIwvIoln8p4NjDZFWhc57E3xKKoqvJHvfVhElZz6bmAs3HgJssqW?=
 =?us-ascii?Q?P/7EPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ed2c2f-6c1d-4ec2-4c9a-08db6676520f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:10:57.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyMuCB9gFA9AzVzhs0ikLnw6RlkaPcIWbQK9KNGpAMEbYTgMUAYGuyFcRXNFhyABPjtLAY+GhCAAvb4wzTHAGi/jA+0PH86ozfLWSM1YJnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5896
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:20:03PM -0700, Stefan Roesch wrote:
> This introduces the napi_busy_loop_rcu() function. If the caller of
> napi_busy_loop() function is also taking the rcu read lock, it is possible
> that napi_busy_loop() is releasing the read lock if it invokes schedule.
> However the caller is expecting that the rcu read lock is not released
> until the function completes. This new function avoids that problem. It
> expects that the caller MUST hold the rcu_read_lock while calling this
> function.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

Hi Stefan,

some minor nits from my side, which you may
want to consider if you need to spin a v15 for some reason.

...

> diff --git a/net/core/dev.c b/net/core/dev.c
> index f4677aa20f84..fcd4a6a70646 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6213,6 +6213,37 @@ static inline void __napi_busy_poll(struct napi_busy_poll_ctx *ctx,
>  				LINUX_MIB_BUSYPOLLRXPACKETS, work);
>  	local_bh_enable();
>  }
> +
> +/*
> + * Warning: can exit without calling need_resched().
> + */

For historical reasons, multi-line comments in Networking code are like
this.

/* Something
 * more
 */

Though I notice that dev.c doesn't follow this too closely,
perhaps for other historical reasons.

Anyway, in this case I'd suggest a single like comment.
Unless there is something more to say.

/* Warning: can exit without calling need_resched(). */

> +void napi_busy_loop_rcu(unsigned int napi_id,
> +		    bool (*loop_end)(void *, unsigned long),
> +		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)

The indentation of the above two likes should align with the inside
of the opening parentheses.

void napi_busy_loop_rcu(unsigned int napi_id,
			bool (*loop_end)(void *, unsigned long),
			void *loop_end_arg, bool prefer_busy_poll, u16 budget)

...

