Return-Path: <netdev+bounces-11146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF0D731B8F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A7B11C20EFE
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0AC1097E;
	Thu, 15 Jun 2023 14:40:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6C120E2;
	Thu, 15 Jun 2023 14:40:19 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20729.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::729])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851EC2947;
	Thu, 15 Jun 2023 07:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUYm2l/jknbSfdr1faoKAn6nVTc6vd3TnQ6/zJ6LBd6DRwUetGL32QkcXvDNrT0g3E2RGSAv8XWiLiZHUgscnLU3bpbMbyJo7e/FEMfhzbtsIHd6dZUsDYzVMznbeFH9ljSaMhrZIbnkWNoXNX6h1KwEoPAd4a/lLuhdKGlXrjrxwRw6LC2bIMkzaTG1dFsgjY1T7QQzNZNVZTPN5fbPYMaJDrUllCGcRU2Xy977+4ie1d4Z0jL3Eqv4C82h6K1KTVjZ8cAulXiFU745VoKuh5tEVBqJhSFRNpzh6Gz6wlgtuHFGb/e8FlECBbJ7aukX9eAH5u2JztsIFUeko7wE5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+ynb7zSs5VPYNedHqyaU+ZjmsvlKfFFdXa4N3KFvgs=;
 b=e6NUGA8htLRo1CZYeoaAZ2xj9p5BakGvZgAHdccaxJuf88kBsck93pVRxkUnrwyVoxNLxd1YNvqjGm8iSJcOlxota7h3PjhXNhNt+/KXLLkwBcyYwyDqlj4Y8LYac6QcX9k19wF23OCkf663OQOTfea/Z2QID9Ip2kBkN6aJd9OPiMfR/6WGlxVRVay5R66LHTTG7bgRK3go/f1YKPKqijcNYLVzauqXJTSDuE641arEzMhFxuW3tV4DrmRWB9wypXU+HS/8AYdeaFgas3ZXX+kZ9+A90TwhjLSSqpgModt6qqHZN/KfBC3dwWNo4CoPfNRQBUmpeSWkS7DVrl5MUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+ynb7zSs5VPYNedHqyaU+ZjmsvlKfFFdXa4N3KFvgs=;
 b=SpQHviDjQzqH6N7D9av/aBf8di1LKis5ei90MaZe/tVe3vN01vbao1xjqztjzzb/JRUHUzrpdhPnw89AssdcDAR2mJw6cbK3XcFsTGEMextnDAEm47nHGATIdzMUrXopM/FIlDIRpWjCcxXkBUmMUqRxvoGCgEY894rOK2diQwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4613.namprd13.prod.outlook.com (2603:10b6:408:12e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 14:40:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 14:40:15 +0000
Date: Thu, 15 Jun 2023 16:40:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: YueHaibing <yuehaibing@huawei.com>, bjorn@kernel.org,
	magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
	hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxtram95@gmail.com
Subject: Re: [PATCH net-next] xsk: Remove unused inline function
 xsk_buff_discard()
Message-ID: <ZIsiyKfr/WdzKlji@corigine.com>
References: <20230615124612.37772-1-yuehaibing@huawei.com>
 <ZIsW47S1Pdzqxkxt@boxer>
 <ZIsXdcawAWc/9Izo@boxer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIsXdcawAWc/9Izo@boxer>
X-ClientProxiedBy: AM3PR05CA0146.eurprd05.prod.outlook.com
 (2603:10a6:207:3::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4613:EE_
X-MS-Office365-Filtering-Correlation-Id: 23b307c7-52bb-49fb-b7de-08db6dae6e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lwBsg5S61cjwAd/RkOXd/r9oZHZiaAKAOSV9wFJ2FK5WaF6vgcL4WiVSfKGJ6pm8GTM7z2IC0Z58I/IopaGfM/iwjaEy+PsYE8+yfPS4KDj0BiNxgq0ns6QtwaqbVTskVtxxQn1bcVp7Zqb2JDNeIOzzm9U7At66E3mLRUU3sznDNQ8wtLf3I8qjY1RWSJDRO5i2XfXrzt6v55o2vUAIZfQ1stwGFKKX+W3vOv9AburUHcQbusiWS5i+9G15GGPyOMqbZpTngP+/XGcY60UyTR3Pk/d+k5nFnR1wmXbw2CK07ngc/qkEuCMmGxt7deAmSo8w/ZhvaqDHTEFrz83BrhrqQEQt7p6Qdbf0dakZ+tozBe/MgTQnuX8N5cDXIIXwYeGtQRnkdj3l2QyZB3njPuvCBREGsobxAFX1yVyzGoJ9TA6cNWGWINzGRkAPGjHVnNRCWoN6YXRPqsCigrSTVPUKICDdwJc6y0EKRfHCNCYm0Ku4iGdD32Wq4noNxhAtGFk1peXu/TncnAY1ZsswrumFHqO6fyfsEbxBIQjl6iXdIRNUm8VQWkMEkJK6Vtmo4xCvs0Xy5X2tJcxtoUMC9Ku/GOXpaTQx6tfideAqePo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199021)(5660300002)(38100700002)(2616005)(6506007)(186003)(2906002)(4744005)(6512007)(7416002)(44832011)(478600001)(66556008)(6916009)(66946007)(66476007)(316002)(6666004)(8936002)(6486002)(8676002)(41300700001)(86362001)(36756003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/UH6LY1P5Mkf5Hg2GXjvaENbD8/LwuMfSdeh4hGRptgOrLTLeZfUgeCkxfNU?=
 =?us-ascii?Q?mUhAFfHTGz+A9wL0kfEXV3LbkQ7RrEoKRTlEF0RviF3kkZKxXvIHj6t2ydt2?=
 =?us-ascii?Q?24qSW7/WXL++y3wXac0gsgIf859Wk3fcAiDb4XtvsFPxMOcfQxqHioae8+na?=
 =?us-ascii?Q?xWLMpg4VJIaszyr/7ZHIpJecPTaFUxkRP4w4vSOsSqdUr3CzTtVkYdpJ1e4V?=
 =?us-ascii?Q?9/7YIqShjTPvOiRyoNLd/mYiB+DBL5STgj9JOcN6n2BAkSz7pNVZmmo1am6g?=
 =?us-ascii?Q?0NzuIJJZ64ApgEOR+jGy3iBvFlMbBzpKdFpaTwpjmzPnVP5WDH688S4RtduG?=
 =?us-ascii?Q?hcy27+mgDSRYmNdMY7DEjBZS9Nf8F0GUL0PoyT2MMu7LztK0p6K9XMDC3IHw?=
 =?us-ascii?Q?E47msvv7A5uqv/cS0zITIQNCNfhVUkEVttC7Q4Ox7tnbbrJHhp5BqjON4tXy?=
 =?us-ascii?Q?vvzkg+MQ/mpMU5vF4T8kXIDtrrFvkOLzQKk6FxeTlFxu6eJspaBaPbbDihc7?=
 =?us-ascii?Q?7bk2XDYNjj+h+nW+vo3jKRP4cWDCMaiHoDwN5MWaezyXW9mmwmSA7wXh08y+?=
 =?us-ascii?Q?rG+JS1EDQ01lbqdbAbSZCLhoF6ZF9Z0RC5Egzo7vyJQdnl2xV/kp6cRV24wT?=
 =?us-ascii?Q?I23r74LUM1DkZEH7KgPDdFR9eLWfNOfoF5AwhGvH06dhrT4R5n9QFGnqFfn2?=
 =?us-ascii?Q?kfb1mrJPjcgX99RvNb69hrkrQh7wytMjf6Nmpf9FeJY4dSdLNL619sfmr5ts?=
 =?us-ascii?Q?wWlDV9VSAr+Ihzh4g1YAWGide4dPGtqFlz1kc265hfh85c1z20mTJzZ+5lzF?=
 =?us-ascii?Q?82LhBpvu03FyayMgR6rriurcgmDf7Peg8AFqd0zewnChIJRR2Lr6LJ+0PM1h?=
 =?us-ascii?Q?3QjKeg0R6oYgQ9RAi+9nDB8gpLTrMrjHsKRRsYt5E4k7+fIAjqNwB+5JPWEr?=
 =?us-ascii?Q?mh8ZTQlCiL9bSJSB1p2jfDYeWtLnT+xj9a+fdYVa9fSS6HQZaOP4dyx5B5oh?=
 =?us-ascii?Q?TG357mgbz8+R/UXldONuJOXEDQQN/ApMl19nmbxMXPn4kMpwf333TkDQA5rk?=
 =?us-ascii?Q?+pVEeDwawRN3P6yW709uz4z19cvSTxsyQP7lod4DtYbsBkMmGCXGBjqiUINH?=
 =?us-ascii?Q?MccMlXoz4JXNh55RjADNacYuMdlZ90ksNboaQxEREo97rvnEI/+EjmGC2ZTA?=
 =?us-ascii?Q?OUC2nU1jyxKxq2ZlEDmbGYnV/Z/5pXX93TQZfaMT1Uj2kJSNo3SZs1U+Tm3Z?=
 =?us-ascii?Q?INUuI2fdedTxUJEMhLqJ6CDUPekFs40ktD5UZAmIuhGYa4L4poVeK7VH3cJ0?=
 =?us-ascii?Q?IHQSvd9o9/hGWPjgUHDqxbMeMaAJXHLGgXu80o8K59eTIxdiHAzBVlTqf9O6?=
 =?us-ascii?Q?b6uh+50DYr3trElwQtgnbR/j2zXRjYGLrp6fllxxo6lDRoUHhI4S14mOhK4o?=
 =?us-ascii?Q?WOlkHy3e5KWR11DHqqLNwubn+kf+2HQY+U0s2iyYV6dBVc0R9sr7R2Dgo1Yj?=
 =?us-ascii?Q?6nDMkGj44RqAJ27X2aXg5dnirWY7mIpqZyYMEiHxReFPVegr1SRuQfSVCFQk?=
 =?us-ascii?Q?VSlHUsM2AaiaPbjLCnUyayrLXin+m5VsHl8KjNi1L9PABsgGg2Ec/+zEwKSZ?=
 =?us-ascii?Q?+6khDgYk/UzxyKih2y66/viWJe+3Zjp2LiTSb4Iijomz2c2y9WySGIgWOzrt?=
 =?us-ascii?Q?1aCtVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b307c7-52bb-49fb-b7de-08db6dae6e99
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 14:40:15.1971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWwWXLJo1nO4FKpXRDSsgIOlKmUrpi8KWasZSgVikF1KHPR6OMdBxIqwwm6iKtqYXRixh7MepoklxRP3qACjzNheL+fMjmql4Jk6WP42wBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4613
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 03:51:49PM +0200, Maciej Fijalkowski wrote:
> On Thu, Jun 15, 2023 at 03:49:23PM +0200, Maciej Fijalkowski wrote:
> > On Thu, Jun 15, 2023 at 08:46:12PM +0800, YueHaibing wrote:
> > > commit f2f167583601 ("xsk: Remove unused xsk_buff_discard")
> > > left behind this, remove it.
> > > 
> > > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > 
> > Yeah this is a stub for !CONFIG_XDP_SOCKETS...
> 
> Wait, I am not sure if this should go to bpf tree and have fixes tag
> pointing to the cited commit?
> 
> Functionally this commit does not fix anything but it feels that
> f2f167583601 was incomplete.

FWIIW, I think that bpf-next is appropriate for this patch
as it doesn't address a bug.

