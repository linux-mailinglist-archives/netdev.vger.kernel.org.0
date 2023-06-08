Return-Path: <netdev+bounces-9181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0A4727D1E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167A31C20F7B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E97BE70;
	Thu,  8 Jun 2023 10:44:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72FDA3D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:44:36 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20702.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::702])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393572710
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhTjFa1vEQIgABEbCvTQZ0yyXknOcHuv6xt5PRlW1jrm9qHEqA/VuHXvQrv+BjLIAPEs9nEhRWUbe4WOkbtnIu1jaZXekbK/hfJ2SBqVPK5oc/1lSSheGqLUZy2Ba7ta2HrPT2WteutF2og3KoqvxHfbkGSPO480ztDJ49/OQDaJusRZZCfelhXqs5pB6uZMU8RPmCbeWHKkBZUo8wT4oKwHxVssr95yopc7U7oIyvcYk+tj1Uqh9+0fGBd6F3ORz4KZ00IRCchpXZhwy3z6ZCF/XtEgHIUMxOemfJFCnAM6RBC7pBVwfzkrGSqjuVcJ395xhWbBOQxVfHMrYeLXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjGZGOOEYHAjeqMtz/SkfnZTNawk3eKNI98ySV+k5r8=;
 b=IcWdMJj3+pZGJ4KNUPm1WbG2wQW4Zj+3eDm16++LU5txx26bSGcvnWChmEwi3i3qjeNlOMg8HRLuZfRVzpLh96jHxn8EqaRSW1RmZG46+u88NwrW97DEoBxGshftK9TDY452rz5f3ybNZV9Uryehb199Qkjh8orY4Mfr17rVo6NbN4no2aktHz6XXLAwWwlOx4mOIBh4COuiw0y3gKCIn6tBGx2hn10/lymIu7iYd7dteklatIutYCYwZNXWGQxgt5cRFC+sbQwDmcwwGrxGkv7ZUN1EipyioRx2rdtc+HltT2rkijEy6g6nfxhF8eQKiKFDpqlmQO4dAmJJf10w8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjGZGOOEYHAjeqMtz/SkfnZTNawk3eKNI98ySV+k5r8=;
 b=o+upPG0u/VDoSDg71mdD97GWXA92T6ma5lGTeXYDle8OTROzTFkNOdv2lf8yIu0B8CTmQ11jeaJ4kr3F0edayg0stY5oWIhv9O2+S4zliTXqEzz5tG2VLo6K/mIQbwBQ1T2EyFo8J8jwWOfdccqTHnIDVDoqDCw+0S6Z2FYTsdY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4803.namprd13.prod.outlook.com (2603:10b6:a03:36d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 8 Jun
 2023 10:44:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:44:31 +0000
Date: Thu, 8 Jun 2023 12:44:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us
Subject: Re: [PATCH net 1/3] net/sched: act_ipt: add sanity checks on table
 name and hook locations
Message-ID: <ZIGxCWZJoSGJZiUw@corigine.com>
References: <20230607145954.19324-1-fw@strlen.de>
 <20230607145954.19324-2-fw@strlen.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607145954.19324-2-fw@strlen.de>
X-ClientProxiedBy: AM8P189CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4803:EE_
X-MS-Office365-Filtering-Correlation-Id: f834791c-f4ba-4e22-ef00-08db680d5785
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xKrf/P1HMQGorc24v9OTnlIUWrrLFSWsxzVgu/HNIBheTTYtTLtS+xc21/fDqyEUqWXfuIrgNQOcoATT8T/KM8T9A/SB7uTaU0iGN0CG9tu95ojuMV9HQR5oDl0/3QPwOQtt6NdAhqsUWbkvz7+1k1iZiDof3Kwff542LbdAE1LCZXdd3RSXkU0e8oAVymfMZ/vc+eNDHdvMASCwAvULqsPIK90MaU7KcC6cB97cfcY4bQQEdT5rsCL74mPsBvJ4JQUsbfxw2oREpyJEEm/uaky/qCMgip6BXgzABcVGSdBQMd6O6vS1erB71TBXwvB4LVxR2ujgtUBhOVXa6fzeGT6IVaQHGqvrRPCcYhSZSmCW4QSk3yhEH2GacXWzWDyPrlfQgNR4+APA3PkQVrCjsFLJBVC6Qwjsz7qbiIUeJrKeeNDCRH2rF4JBLsoUsP+iWjVkGW4jU3rSQiE/jPg+dDKnsr0fMBk+L9KAaScnkk5XMVZssMq3pvLN2DE7zzEToFKaRGcArECz2jfOb/9VcoJhWLiUYZF0/MmzBK9SvMgbs99LKpLgnsTX9phsogxzsX6YIPB5ZYQX49HIWDWeRfSmkheiN0feWmIUaCCRq0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(39840400004)(136003)(376002)(451199021)(6512007)(186003)(6506007)(41300700001)(5660300002)(36756003)(44832011)(4326008)(66476007)(66556008)(6666004)(66946007)(8676002)(8936002)(83380400001)(2616005)(478600001)(2906002)(86362001)(6916009)(6486002)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NMa9f8jaLSQZV7FlMGwkGNwJXR+4GKbf+BnplmFxTjue93coEfbOHblDuFwD?=
 =?us-ascii?Q?lIptq9EUvG+RKdo1V3oicg2S3CxUV1jcsn8sJYmQfjyrbM1EehDBU6rJJ5/U?=
 =?us-ascii?Q?0gNG7UWRiD9Jel9nBEwo6rEykmGHWeRRtyPQP6SJcdrRGjZA1HDVrPmEVyFP?=
 =?us-ascii?Q?okvkvP0WuIX8Qyqwg0HyCLJHV4MYLzYFglwKR3Umh1ZwedfYxP/6a5j82fZ+?=
 =?us-ascii?Q?wNBWvYfU3gOK3N1nFv4gSwzXCAuZryLgNOIuNHoGl/+zPG5Ov99H8Eq2dzJM?=
 =?us-ascii?Q?QpUH/7PSrD3EQDVVaLMXIWlL47g/HOJmJxzxUyCZUVmVkXBTu6cNxOaCLxgR?=
 =?us-ascii?Q?/jEayMcxDqSE41upKOwexCKy6Avb+aLcS6cvrNu6rVaH5mMzUfpqJQjk/w47?=
 =?us-ascii?Q?HtmPb+7hlUQvBum/nxXcq75+4B4LQFtGalWinNYBokAUjrINijq01nq4R9yb?=
 =?us-ascii?Q?4+shCTS33/8UHAQ6dLorXAzQfWekwbe7jEgeyxZIRZE5rRd50PhdhKqyQkaX?=
 =?us-ascii?Q?xxndarTJZsg+cauBtOUUnndrPkxn3S9vQMYbYkXuS3JMLePYx6gJSRblMrtC?=
 =?us-ascii?Q?DJ69x0X7FpAjSToNhgHA016yt4KrvQK0VUPLgpqRCYuO/EcpqDt8fyxPqNI8?=
 =?us-ascii?Q?khd9vUlP42iUMsH+2bppSiFBtWg+CXa25MUvINyul4ihJTKwyy87e4nr4yM5?=
 =?us-ascii?Q?UiOsrwzS6QSoLDxROSnNADapAfzCQyi4HM4ATfXQQ7Iggbvmy9qVnHUk197p?=
 =?us-ascii?Q?plxnMHPPRiSoSeNEeXLbcJIyK4Hr8DyolcjPSsADX4ml278r3xF+Qa7CBFWT?=
 =?us-ascii?Q?Pag1LS/x4swUSXutjq3nwHG1pSitFMWAm11sBTyHj3kXGiq/DDOGQbyoWVmk?=
 =?us-ascii?Q?oRnZbtwfQzvXdAdzLTVoaXaOSMo/POZQ+Uxuzu2nA6FUWF8DM6QPDEmKCUls?=
 =?us-ascii?Q?dp/n4wDORxdsfEsrmS8wblEqr5rW66Sb6NKpgpC3lxfgnNOOhke9cDyGvOrb?=
 =?us-ascii?Q?EuAjg0gysfmy4it8LTmoxe4U0iXpK+0Oq1BUDcTOe7pDCVoGsJwucl5+//g1?=
 =?us-ascii?Q?nXILnSuca9n98Vjetyad76VfZc1oweH9gVOAaDQ98UVunZCzcLGWjxAHpiFR?=
 =?us-ascii?Q?BZ7VK/ncbGnOiypE7UxIXh4Z7dxSUoyJmWvfPnaRTxdhF2KnYL7S5+TZiuzu?=
 =?us-ascii?Q?vOWPyO+yEURrIVzlW2OzXR7sGsorGX9v4PYTwLDSVeUM2lWrcKOSOWrjGfX7?=
 =?us-ascii?Q?8R25d7zJx63gT8+4rRP+Mw564bvD5qhQtbbjZzzLoGplqv7DGO/5vtIZogCD?=
 =?us-ascii?Q?G+KRf/lmKLNGApZP38grklLeOLCCrPNJkq1AlN6qjMnM0EB0yR9sInxNAH7k?=
 =?us-ascii?Q?tAyEaGJnmbXqE2zAZp6epDIIKUL4eANn4kSQtcE1n/IFGBMgEVyf1LrloxPc?=
 =?us-ascii?Q?9JBl55vfdNL/dhfyBmQPMp7UHxGbamf7LY8dl2VKhGQyfda9eKMrBQhQ7Cih?=
 =?us-ascii?Q?474OgYZgk6JaTECbg4TXkkNdKHM7lv9kD5kMdraEF23SGBmNitUGESgkfvhx?=
 =?us-ascii?Q?6Y+C2YGG7xIj2+yUNwjucLOErNxKYSitmPGIN/uZNOr9q8Y24VUZnehg7G60?=
 =?us-ascii?Q?reSei3BqR9UnGXmb2JA8ZYoj6rscQa5qU0xFHSqc28sjqcUAdpP4l51Vh6gq?=
 =?us-ascii?Q?ewN37Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f834791c-f4ba-4e22-ef00-08db680d5785
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:44:31.6313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nT4kIZ0bocC2egfEkfjipkbu3E82eKoCSFs1US07x+BtYe+dmfgTRB1wo5qmkU7C4gzeCuKHwp2ZFCIPtB0syf97Vu8b7orlw7/KsEGSuzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4803
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:59:52PM +0200, Florian Westphal wrote:
> Looks like "tc" hard-codes "mangle" as the only supported table
> name, but on kernel side there are no checks.
> 
> This is wrong.  Not all xtables targets are safe to call from tc.
> E.g. "nat" targets assume skb has a conntrack object assigned to it.
> Normally those get called from netfilter nat core which consults the
> nat table to obtain the address mapping.
> 
> "tc" userspace either sets PRE or POSTROUTING as hook number, but there
> is no validation of this on kernel side, so update netlink policy to
> reject bogus numbers.  Some targets may assume skb_dst is set for
> input/forward hooks, so prevent those from being used.
> 
> act_ipt uses the hook number in two places:
> 1. the state hook number, this is fine as-is
> 2. to set par.hook_mask
> 
> The latter is a bit mask, so update the assignment to make
> xt_check_target() to the right thing.
> 
> Followup patch adds required checks for the skb/packet headers before
> calling the targets evaluation function.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Hi Florian,

I think that patches for 'net' usually come with a fixes tag.
Likewise for the other patches in this series.

That aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


