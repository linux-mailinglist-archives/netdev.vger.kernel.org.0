Return-Path: <netdev+bounces-715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F32976F938B
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 20:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D81C1C21B91
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 18:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEEDC8D0;
	Sat,  6 May 2023 18:12:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D8DC2EB
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 18:12:51 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DCC1941A;
	Sat,  6 May 2023 11:12:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3g8tIuM/9VFtJJgtVfJ3jMFiEdGmNZnPDVbGORUHnv7vURT+70aouP679zfUcfEM0OGTF9rxc8X28iI8ZghcGiRufSnfOYR6LwRAq7aJmHqC+eIXbOxVwhWAI9E2keAm8qqq1DJrrCpLSeH0SDjT29WKc2zHD+ZPZKZ2QR7B2zZrERpvTK6crtEDleMPHJ7sgFtCSLFTtPE7Y+PkUrBuHp+eTAFPZO3mA0Ip3+U8buAaH6BkIQuN/wU3sGKqpg+OABLK5zTcJIVvmvL7o58XOvGKjzH95t1yG2el0+RcHYRKBOaTEjcIhInTffYriM+u50AzORZXsIxouCs1dR3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vA8KRBKjbl6Q65bHVf8PNMOuVVY29AVdfuEeJAKOoY8=;
 b=mR6L20+v2CiMQ98Xhumski4HWFggY0/f1WQdoESEeoOxlyrBe2YemRAddGKhtFtNDhHX4zOgSziU09lsmCjrwCCGeC2G+vGCpu2PzYHFjQ+Vfh+RTLoG4CEor8frWZOcHW56eYGDfpTkTCC5uFPm1st2ujnod7LGw0ZLfFROhyFQZtRPXaa7eLBchj+QZ4WyCEjC34HirzhA2OuGj1CqVTuKHBm5qPYHB4bZttrDqZHc5SAT69KnY15shOMcBaEB8HjR/FDiVmRkwvjEcMvghWcCdfnTArSqD9oLiQo9UiRUFJDyLT/uKoZKErKMqBSWAdQy2W/C37ZQv82BEeXKIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA8KRBKjbl6Q65bHVf8PNMOuVVY29AVdfuEeJAKOoY8=;
 b=URSKZTh/W3GykF17lGCnIw+GZ+57PpmotsQi8dHTYQ/yXs+IpAkOK1k448JzpoRMaGoFGdt8HtJ4bgOW++o+BeA/EY8ctzk3fT46d8PdY8wm1jHCk4j+2gmEB/M6h8H7LTHAZs6jERie7KxfvEeyfICmMjMZsY7A5OnHuLywN0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5126.namprd13.prod.outlook.com (2603:10b6:8:31::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 18:12:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 18:12:45 +0000
Date: Sat, 6 May 2023 20:12:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Pravin B Shelar <pshelar@ovn.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next] net: openvswitch: Use struct_size()
Message-ID: <ZFaYlnSJdMQXQ+VN@corigine.com>
References: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR02CA0098.eurprd02.prod.outlook.com
 (2603:10a6:208:154::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5126:EE_
X-MS-Office365-Filtering-Correlation-Id: 234781dc-77a6-44d1-eb7c-08db4e5d7da9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NkBDCEk7e/8K9nSFLoo3sIFdqb0l3l7PY8dm/e5xzFkGNMbdaAHVfiz2rJS6gO8vlxEuEHtWzG7GNuet46lX+vXBHd5M2dBnAKofq+91wi0CFFeSVOjeFRmvT2QcqpaN6FsyTCW8pnoTXaNnWx6ySnhJNSxMS/3Oz1CJijC09plbjmNQ62XfYGZyJia7N84xuNjiEYG51qAJxKS7p5QdfROR6IopaUPRuJ9YRaGQMO0lrpsuCYFHBBRcCXOHnJBoBSNF9JTJX3RC6ibtEHGRCfdTCSR23ni2IxTOzqnH+nniTZ58AeImWq53CNkPtvl0agQ/oTNHlkfnSQjfJC5jpUsRDw31PcGpJd+0LfsoOGiMSE8bEJ+A3hM5mR4RFJrMPgRb1ZfJz/1zIkmH9O245ypAhI33W+T0QgK7tiDEiCdAU5K1bRD/mG+yMOIK72cTVXtaGyb5p0piUQ4Cd9WfDIiSFGB/26WeyLZ16FEzAWVBP1S3zVAjkDH5wt7LfxBMR8Pt2IEEeyWY4QHI3A+X/+s06dS/nt48LhlutuK8lAQWyjvbZE5JoufuvIBAnfc5b2zFgJ920/gm7WhfkkY65CdUaB/5cIOdJW64egaEIidCyENfHCHBA/uC48NiLb8t/4dYH3itMOOV7qXyHcCEQA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(366004)(346002)(376002)(396003)(451199021)(7416002)(86362001)(8676002)(8936002)(966005)(6916009)(6486002)(66556008)(66946007)(66476007)(4326008)(5660300002)(36756003)(38100700002)(478600001)(83380400001)(2616005)(41300700001)(2906002)(4744005)(186003)(316002)(6512007)(6506007)(54906003)(66899021)(6666004)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p4Ln735i95yJMBrXqDWHq35LcQECnFA9z95Mnsf1252fClFEepu7uilIFXxx?=
 =?us-ascii?Q?3ygZ83C0t9XfmirkAzP79dQkTMJba83ReKOd9SU4BD7Fu3R67Bhr6SWAW8H5?=
 =?us-ascii?Q?jJN/G41cfOB3JPAV/5Pi2fw2a63mq7hYt9R0i46VCgD81HhOlhuiDfFIK23t?=
 =?us-ascii?Q?3Fyie9KnRVHFL/XBKOgZ4TUCInzxu4c9XsuD6BHhPy3xiNOZ88QCgDZa40KK?=
 =?us-ascii?Q?LCJgC3tCNxSlkXlB99EGuPf2/xjzJiVZic2gYBVSMdjzqipXwK94/rftrtL7?=
 =?us-ascii?Q?XPcZrBEE/1KCo0um7jBXZmIMwXP6AflBp6VlRb0LWK7H5yn+iX6dR+s6L86C?=
 =?us-ascii?Q?IHfN38P9LvJbj3Q1G2PSAhS3XIMJoEte6/TlFo3+OL0hAPwsmWk4OUG7g5Xm?=
 =?us-ascii?Q?IkUsag0YrOWzbsFGIcUa+Oc5cF0iAGKJpER/WBvRA+wYyddyoyFFZkkV5xTC?=
 =?us-ascii?Q?1ARQ0fcAoRpbZH5mRatRMVYwFA/6LPIrcuxT+gwd5Bp/SAfP/7faofXJY5ik?=
 =?us-ascii?Q?Y5wMZaCb4nUZ4RRuqxr0uiVlpg6J22h1mly9Xz8cBTeBMm5OfqZcHK1QFmdV?=
 =?us-ascii?Q?V++svkOAn1WmefGjibvltWm7ltGuLY3ndp4kZo02E/oXsUPITXyd/K7ymYWt?=
 =?us-ascii?Q?7ePvxabe9irRZe9mizQlUFPy8nvhhOvlZCi8MDNEcetZwxGmio3R+M4XF71A?=
 =?us-ascii?Q?grOwES2qGgiie6tR8yIoSN+nDWft4rBUt4IqUpI5xSPPl5k5ai4zhl1McoFg?=
 =?us-ascii?Q?hdvzQajVk6d9hUDscuxgC66Sg0VCV3T7ZCdTcQ7K/RxbEgAYZoNP5UzFKpl+?=
 =?us-ascii?Q?IKaIbxMAJ+b6hO3HgkJFBFKORK0MZDhz02qLuOsqEkvUAUc+hJvU6kYWsiqF?=
 =?us-ascii?Q?4rSCi7gZwmGDs/TN7qaMqQTCB0rdvRTgtM78wuMOO+gGiOclE1xqpsGroIlE?=
 =?us-ascii?Q?k8m/Hkp1F9Gvqtf1TED/9FJeZA2Byg5JKPgsYG92o8eJ37elFSMJBVCQAc6Q?=
 =?us-ascii?Q?ExxVCE8RWz3ILjw3HQXbkM2YMcDcbZw7YjF8z0rXfZQVJZKnbVkMwksMzXnk?=
 =?us-ascii?Q?5psSpxiGRqIwXvJgUSEZmhV2k5jZopRLR0V1lZ2SL7guQSELqhNrOHG3INVs?=
 =?us-ascii?Q?cmiH7HbbNOtHXfE87nP7mDuQeaaBCjFM8ZTcth/wDy57SGDLvc/KHSbJtz2u?=
 =?us-ascii?Q?16QtTbbvyaM0e//qcDEJbVzNo6vc71Hx7PBX6jaQZlRL8BYYPdJrZv1LMbEn?=
 =?us-ascii?Q?eBgFfZuo/OUMaa4A9P2mZ/RDwOS9kveDNF1B+dzsnKiAcp+qSLjsqiKurUJW?=
 =?us-ascii?Q?on9/o+2cY/X6Tz+R2x7qB2aN05Rp7VihazlQZNrGI9Jpqo0rdsd9XPQY6sZc?=
 =?us-ascii?Q?JUmHqHGKajDF6RRjCWQW7NO1vq5ROKs0efUaYPY3z3hfz6+lGrCB0HOEMtvj?=
 =?us-ascii?Q?3YC49j6bB27ZigzI1iGG2/7vofHPr1eZOZA2btSywRvSJ4zMz6P1l70wKZ8b?=
 =?us-ascii?Q?aTvPDvSW5K89u/eNHfwxicHAVNOUwuNgx6w1sWYzYwbAfdi8YdhNnuOqxDYH?=
 =?us-ascii?Q?F25jGjAqdU63AIlOU1xo2I9TSW69EBgqOtVYxIfjosPdDHMUzbWnYIEeXIDI?=
 =?us-ascii?Q?oqouA8z7mIW6aukl5Ij5rT4Vez5MTNBEBi1tri7FGFvdDHAuE2uPbNddzNVm?=
 =?us-ascii?Q?d6N33A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234781dc-77a6-44d1-eb7c-08db4e5d7da9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 18:12:45.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eevlI2xSOzHFoqCEkCtH133Z6lTFtDBfKfjSBpIIt8PyIlESHfuk/rk8GVitIGptEi0z0GzQZK9AATU67E6Y/4mpnlzj7iUweCvmewXpi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5126
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 06:04:16PM +0200, Christophe JAILLET wrote:
> Use struct_size() instead of hand writing it.
> This is less verbose and more informative.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> It will also help scripts when __counted_by macro will be added.
> See [1].
> 
> [1]: https://lore.kernel.org/all/6453f739.170a0220.62695.7785@mx.google.com/

This looks fine to me, but:

## Form letter - net-next-closed (text borrowed from others)

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle


