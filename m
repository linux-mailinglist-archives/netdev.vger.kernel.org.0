Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36EB67F834
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbjA1Nnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbjA1Nnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:43:39 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2128.outbound.protection.outlook.com [40.107.100.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE79468AEA;
        Sat, 28 Jan 2023 05:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdfGWHhejrqBfnfcHRYMnTIT8D9G6tLVUNYWchJaIxA/tr+OGJTzpiCpiCKqBHHVIJ0aWTgLto6nw+pYuGAurSzY5IEb9ZNvzWDNjJTnRgzn73mCEnORBf2HGCEDaJqFeUYtOkS1KEgMxaoZ+1BL4pxxlnLf6qw5KcExBRu+I518o4ZvgOMM3sNp9BgbYpLjgEf99CNaJFIkk1BhQIw9dyt8kyi/JtsvudECcfpWWWvmQ1sxBsW66ld3a8ZhIxLU7vYQwddE9uE0Aj3BF4H9ipUWqdTcXY+D/DfcVgIJ9cF+/JhQd9TQSJmZHNDLVni+p4j2Ba2imlWSgtPCmzSR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLkgNeJWU846qyoHRet8dXuelO18NAQFL+Rv1YmYlek=;
 b=KREBAZgz2qfbaXCPrjdgdJji7BUho4NzL+zYBKimPzv1tWMeavd4r+S4sUtB4kFbyQ5POgfsKGHu5UXVYGhcLiZsFyVybTpSoPKW6I5pbuBEQVovh2+edavlJgCgTkJkS8guGyVwyR3f9nvdqCw7DhUsBE3gKwzEAHozsoaAhBdXOS22eIHfaYvfuw4k06xLhsAiIr8Xw3Jc1Tzhx34b5MovC8VHByvFQtSktSJ9LnWcMTLHZVGxmnzXMkMuRWzwmPeZmRwSpSWxNK25t7p7+Zlogv0RRtUrHY81cwFhRl6vWJQbs9YP7z1bFqqX+YB1e3cKGi0UrCwp7XQfpuQ11Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLkgNeJWU846qyoHRet8dXuelO18NAQFL+Rv1YmYlek=;
 b=T/yGww/RlNOTC/3Qsoy71uxufBiqPVjbxDtM2hTaNQiEZWpywFq26RwvW2joCTRGlvdB/auArHIcVboW6i6rw9RE01kL0l98ZCLOjn8N055e27jFoM9rQ5eklZR9qif6XHGUtwv/oAq+pgLu1paILWuF0R4p7Z4zZ+ipLtGxWA0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5444.namprd13.prod.outlook.com (2603:10b6:806:233::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Sat, 28 Jan
 2023 13:43:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 13:43:34 +0000
Date:   Sat, 28 Jan 2023 14:43:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: sched: sch: Bounds check priority
Message-ID: <Y9UmgDQibo7Z0Nqz@corigine.com>
References: <20230127224036.never.561-kees@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127224036.never.561-kees@kernel.org>
X-ClientProxiedBy: AM3PR07CA0093.eurprd07.prod.outlook.com
 (2603:10a6:207:6::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: fe59e432-a4a5-4ba4-5e90-08db0135a691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: canD0FP8s/CD0SPMwAK5f+EjnoEiBq/bLpwaVapvhPkDyrBB1GpbTI8Uh0fGHOHKfzOvqcU2U/+YvX9U5WyCDKymnBtmzEm/IqVAggHLhihY7sw3E3GCMIMY0ay2sxK/qQfcyRSmTKzrKNLhhF1S8PiaUvu3mIJ1lGKOfxcp1bpuRxjliASURKbOc6U5Teo7I2cp+eMNe2yuo4Y7pfMoJHmeMPx24aac1B1UyD1PFXWHiEV4XhPVK2x7Vu39MjLXEd2ZIyS5ZsKB/pDsXpSipTbP/Gn6UUnE/r/vKx2BxaErN5REA61ZAEqdt3f8t/zaZs4wmpTrasJZBeH/tyNhfgdc0u8ZMFDERoc0A/sREh2AW3xKGKJHFRzF8Ds7rwfo+MKLa/GJXNTfioHI7Lk/ajOt+e65cL6k3xvtz2meFqSJdZrSh0P17f8V6OC76Wvq03G1MrJww0ofWJcpNdRbuCEpU9GKHc3Dz3qH0qcjd4JYE72+O/FzFw5rVi5JOWKqr7JzTcTyXLAWSVSPZEePPtCrtax/XE9kBFiJ2KTUKmbvPnmCbNBV4niet+j3zarWwBRjkzZ064aOTAKWH4p6N79TSHglsC8b4KtC7/sWrKJYW0OHSN1PxY5blOU570qW4k7bmANkeJT7tFasc4PItQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39830400003)(376002)(396003)(451199018)(86362001)(38100700002)(2616005)(54906003)(316002)(2906002)(4326008)(6916009)(8936002)(66946007)(5660300002)(8676002)(83380400001)(66556008)(41300700001)(6512007)(186003)(66476007)(36756003)(6486002)(478600001)(7416002)(44832011)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gF1wb9wtBTdqH6Nok4rf8Cy3yWI1QjpPwhvBEaYrNChPgdym7wZt40Jlkpqb?=
 =?us-ascii?Q?NEY9Z7R+eUIovscS8ENbiC/lmTHzJ4Rtm7afClZxbKsuFqz907xBXXpgvUbk?=
 =?us-ascii?Q?RHC+b3oiFzfrpQYnCVMhCC9D10SLbadKlCZjXg32vbKbNSYIdj4ZgQ5H6tJ7?=
 =?us-ascii?Q?i6N7HQL4WsOseaQBfl8189CO1T4RvPPgtIKQEXyDhtxFLkC49v3HRM32O6Eb?=
 =?us-ascii?Q?MXWhzZkh8o+FQV6cirq4+82gpPeTG7ijqQKhsrfLJ9ATpxsIc9WZegxStRl8?=
 =?us-ascii?Q?+VfXnH8jrnchCMmlgAR0GqPa6SBNf8KegHqBBiEtQCp6z5Xia2pEwDzF6tLG?=
 =?us-ascii?Q?LbxxN9VtDDSF8rdK/uNJwxc4by23tYRX63GvCO/lGZcSwJ0v0BFkhUJ0MD9f?=
 =?us-ascii?Q?nDtDVqjFTwNf1ZhbIlFRQO1tH2SWvNQyRqp9eQ+5zIScTuX8R2KfVsMhbkpE?=
 =?us-ascii?Q?vnHqSJtKX3afufpZ9eY56X9LoPUbD+Q4HaumXAqYdFTXlcD7h0LxKbosJ/3R?=
 =?us-ascii?Q?9l3+jBU/oFzeZk9YdsT6ZwjR42QMfrEVwvxpS7yHBSu2FffgiMn9m49UR1DP?=
 =?us-ascii?Q?OVQgMaIp4uruFGk2iwuOK7ZBBt2ny0MWwcdY4MlFDK6zH/8tui7wWrl4yWkO?=
 =?us-ascii?Q?5H1/a6BeEw3TJ5aWj2IPjDl7wUUrldwv+Mw4VrVHDWGEcHqwYFHQu7N/0TFX?=
 =?us-ascii?Q?hSbmnyNWHqrZ2yubcVmotCOdW5T1YgbSJZ+PXIim6BYx9k3VoCh6u0Dai640?=
 =?us-ascii?Q?zWcKjKjAKTb04EZX2ndTjpKRM2rh5wDswWKpNgkIKuri+4tBfPQnFqnYVIlK?=
 =?us-ascii?Q?1DWEduhCGxs7A8GpJ3FDbQnzecbIqme6EgXNLhHvM1GJNDVcKoeFA85MLTEu?=
 =?us-ascii?Q?DNpQiXKJkdpZdZtwjS9W7vNRnmBIMHCm230+2MlWmD0BDb0BZTwmj1vdcMSE?=
 =?us-ascii?Q?K94dKeLwzDi7kdgpOqOpAzbioZHngTpsF6J2iPZ87nkZSes91nNQ+NtaUMpq?=
 =?us-ascii?Q?TddFNcxe1DMjFj2yItfmUKVj5BEjrHC3oAaIb9nTAOILeNIO1oFNRPpaXDOF?=
 =?us-ascii?Q?leZq3/RM1e3/cbWinkD96jfmah2TvuKlYVrU0WUtHr/2FaJbXuFg4QVBWPf6?=
 =?us-ascii?Q?jVWsZrOPnQf9d2u5YmtRoSGZs77Nu08zfjCsHpxYfPikem4DGqaNIH/xy47a?=
 =?us-ascii?Q?+ffuVfGBsM4bCtKxPwXGM7vb4hx0AM/FU+NJASPG61bW7i8fggpjKPDJLgmx?=
 =?us-ascii?Q?WOKAnW3v1M9ki6TAtQWz/I5WOqpb2xuJiKkqbrZSYu6HdPRSTYgsdz0fA2fv?=
 =?us-ascii?Q?oBt71M7tvaUArsAwMH7MPEa2NMW8kmg85JTcpJ3rfai/NKiUfCbLblr/LsYo?=
 =?us-ascii?Q?gUiQIW74bBTgtuKU/Z59kNAJmepoy+Ebh5YxuXf24QrcQBtJO+DXI6r6Z5i5?=
 =?us-ascii?Q?bnaRGgYO6QVh+obvHHMjp0g4thX7PrXBbHEbRb4/lhYF5BDvHL3zQP8De8+1?=
 =?us-ascii?Q?gNqKJ/VeLRLKmh8EUYDxB8Twun5YeTjXJBT0Vs+IcfQ9r2yYnAZsMvxjK9rv?=
 =?us-ascii?Q?Nn3cH1Uf4EnmUpi4cQr9Iuu84Tzenn8UtMO3TcQsSxfAabKhC/RC4nXILApj?=
 =?us-ascii?Q?Qj8YeHBs7pFbnAXhkZvSk74pffW/+UbjeMz8N4bt8IZl1WwMHd2yUO3TwgLd?=
 =?us-ascii?Q?8D6k1g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe59e432-a4a5-4ba4-5e90-08db0135a691
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 13:43:34.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrwUSCQr3nXvye6xh45RFrd3gw2hJxsxQyXd3CkCkoQrpLGjf5h62yUOJhep0yXsn5bvOTFE4N2sgtSm0z+K+UBdmzhF+MhU04MDLcWSzng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5444
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 02:40:37PM -0800, Kees Cook wrote:
> Nothing was explicitly bounds checking the priority index used to access
> clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13:
> 
> ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outside array bounds of 'struct htb_prio[8]' [-Warray-bounds=]
>   437 |                         if (p->inner.clprio[prio].feed.rb_node)
>       |                             ~~~~~~~~~~~~~~~^~~~~~
> ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
>   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
>       |                                         ^~~~~~
> 

...

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/sched/sch_htb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

I'm not sure what will happen if we hit the 'break' case.
But I also think that warning and bailing out is an improvement on whatever
happens now if that scenario is hit.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index f46643850df8..cc28e41fb745 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -431,7 +431,10 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
>  	while (cl->cmode == HTB_MAY_BORROW && p && mask) {
>  		m = mask;
>  		while (m) {
> -			int prio = ffz(~m);
> +			unsigned int prio = ffz(~m);
> +
> +			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
> +				break;
>  			m &= ~(1 << prio);
>  
>  			if (p->inner.clprio[prio].feed.rb_node)
> -- 
> 2.34.1
> 
