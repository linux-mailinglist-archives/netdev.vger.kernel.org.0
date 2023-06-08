Return-Path: <netdev+bounces-9183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B224727D23
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA48E280A6C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D97C14B;
	Thu,  8 Jun 2023 10:45:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D4CA3D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:45:50 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2115.outbound.protection.outlook.com [40.107.220.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8972719AC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9ws1UzBtccg5axpAwQ19zi7PfThvL+txdw0k+S6bGb6LZOaBwiXTMcEp8VY8c2NuxJfgWFajDty8AmFfA6BOGwZvRwzzt+9mLwSiMgQTrRUVj2eTGpptDk5GBdUcpS5ySf1EALf5jxP1Z/66koxFr+N7Pcwe2Gbcj/KDAHlikOfB8/dFxDTjZ9NPKQJAvXdjUfeKL24AtemF44D7wqJ20bY+7I1V5asPWf/vludKJGUdaQDWZdOVxrDVNA0d4KQOQVcTyu72rC1wnL9/DXE5OtmR7P9hdOhITSYCFkiZ9v55J6xlmHo2b4+LBEQHULmr2/C8eXZPnIpk6CYElMbXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIWxZzSVEqVLR7qeXUc0EmJ7MgoL3/XpNe5JkZNFSXM=;
 b=BDkZM+AyWyGt+gyaVXhvdU8gaK+OrFeY+YjfSYYdVQ0dCaNmX8JshXPQj8O7cUxCSIQAA1BSGjVwnxbM/4L6qtLPd0MB/50W60Fh/R6LyATvfadob+xnAhxMiJ+6huGDlDmYKB0sgqq4bTYjdGLc18H2UwOPy7oUBVrz5P18f1axYmEyQ7Q4yxHTPB74VDNvrVZMq2WWvEsg9EKHBCvFlwv954PP4MEnRtsbtCu/wjNDOtXSgzhkDjREiAv2bEy2DzTGH88t/rqREgAh+h6NXzMLzrfWNBv7fDYk0fcIwPZYKYygEBWnR3J45dt98MRLEOYnidk7FnEVGdMzLWTRGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIWxZzSVEqVLR7qeXUc0EmJ7MgoL3/XpNe5JkZNFSXM=;
 b=aTzR68szdvfAx/GpeaBpAPZFGs7LWBHqz/BNrzwaJoTTGS7/svVU1fYiwBOTGpI89btRUHv6uUG4DQ6wNKIwbajH+0qNYQ2U+YY5gzVkMi49XHiREq1motrxPvapI8L5JWK9+Q/UYJZMzGQN07xHd9RXRst2W1rJsAjLPLkq8Bs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3875.namprd13.prod.outlook.com (2603:10b6:a03:226::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 10:45:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:45:44 +0000
Date: Thu, 8 Jun 2023 12:45:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us
Subject: Re: [PATCH net 3/3] net/sched: act_ipt: zero skb->cb before calling
 target
Message-ID: <ZIGxUtaYoRl50Ldv@corigine.com>
References: <20230607145954.19324-1-fw@strlen.de>
 <20230607145954.19324-4-fw@strlen.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607145954.19324-4-fw@strlen.de>
X-ClientProxiedBy: AS4P191CA0011.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3875:EE_
X-MS-Office365-Filtering-Correlation-Id: bf3e6f70-afb4-4d46-2c47-08db680d8315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y80aqrRzABbD76ODdQ8C5m831pjWC4wXqx/vhq9wdcg1xKmOC0EB+iIq0dJy1PA3wdlqSIruEeAKEY2M6HapXbk07z78Izc4i4qUilSv1cVH/axeGPkeU8x9jgK6cTzOs8JWPGYph1X6KBEk8EyapwkgzJk+/FVNRwlnJxVjjC17fKB4MTk6BKSjDXazTtriMEh//5WYPkxaWX1lhMmzLGOFxnjxbYYZ8MEpZl7iYO0E5Ssms2MgNgs5d1WJMBNQS0SoLyh6EnNU3qa3aNLm1IOOuIZrR5qMD8bvUAAfIG416N54KdF62iX2inUSwDY+IjrxA43fQtXkJHv9goRkpix/RbaIZ06nhfRdb8r5WdPreyq76kSM5I2+wIjgwWMihWc7xRgnf8s56UyXPwKJ/k9MSNI1wYAmyfsXNMIlXtRiiMkt7hA59SVQG4O01EemmYLSMSce9cDFqboMHbJt3wO9Q+Qj/Ac/v5S+/TrOmma0oP/hWEwIUYWAyj45nqDz2L0vBA0ppVUMMJSgRch7OlD2vO9JuVKBUdm5ZZ+snDwKDGhHmI4QpRYnrBiMr8t6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(39830400003)(346002)(376002)(451199021)(2906002)(6486002)(36756003)(6666004)(2616005)(83380400001)(6506007)(86362001)(6512007)(478600001)(38100700002)(186003)(5660300002)(316002)(8676002)(8936002)(66946007)(66556008)(4326008)(66476007)(6916009)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v+OzYbh56vjtdbf6gA1g+hEWdbAMExojT7GqjhJhBJ1w1OzecTRTQxgDr7wO?=
 =?us-ascii?Q?0PafCsiEySTORgVst0Apvy1pCeS9bpnyfhAhjq0QK5S0hud/Vc7VpP5YSj1c?=
 =?us-ascii?Q?kspheJfgtXAoeTIckiZuLFWr+FtunRzTyrMcq6X02AkDauoSzDvEWSqd0CD7?=
 =?us-ascii?Q?cSh+omgyYq67j+RirbEkWqIi/zzKRmPVpY9QnlICDZ4Mgby9DwDn0aaW0lx2?=
 =?us-ascii?Q?CzH8HkUtJwTQiiUGbH509VhbLtMGD/NtLbDK6AYDvvgEL+k4lUBZglJAu38V?=
 =?us-ascii?Q?rU32/Q8kTB5pDSqRLgc2qlLTXoIbyMnAKNpXbGGPhwjhOcFP0XtH1ed68bOC?=
 =?us-ascii?Q?rVW1wplVBPCVMufRo0cy+yX6O0UVRMT6v0th79hW/V8zaS75dQQ90Gauydum?=
 =?us-ascii?Q?0bZP+9Vxuf04x50e4IyNarQelftCTyW6HnT9ES5FG17jYN6QIfQf5UKmRZKH?=
 =?us-ascii?Q?Wluk4OEUIQR5zAoaLJPjtj31GuKsYwz0XjCN3XjRNjCvY72aSWsTNnq8QlAj?=
 =?us-ascii?Q?zpLRZmpSmciuCk4JW3hiXwtKLoO5KxAKCm+uDI4JyNwI57DLdvu993HApWAs?=
 =?us-ascii?Q?lVBVseo623OBDE3B5fZrUuSQdtmSRYuJQ/aEZdZ2Kn/oKb7L+mdqkOlGKF+K?=
 =?us-ascii?Q?PEU5wOwRbYpGLCE0NwdOf4T5tI9rgvqFbcQcGn6s/iSzLO7eFNYJYTLxG213?=
 =?us-ascii?Q?++TUDtoY6482qxLhYEAS3fv81Px+wlAIF8J+B8ipKOyim1cflUg96mTzY9hI?=
 =?us-ascii?Q?mIQopkd3YfpGCzaS4mFAJ7EAkMw73lNtZTdv6zBO2PGPTyEmeSv4r6jfgnQx?=
 =?us-ascii?Q?E9iy5+zWVCMLXsE9CfId+FfFrWaRGmj4mF9pXDF/LqqpfL46JcNDeKSao1+4?=
 =?us-ascii?Q?9A/2j7NqOtmwyLmuNMbdivyBQrjJoOx+YldnLX3PXvADkmDOAD0Og3SVN7z0?=
 =?us-ascii?Q?Mwnw4l15JV9e86eRwx800O12J08qr21ebHy/s5mStJYAaVtdNB8hGoJyLwA8?=
 =?us-ascii?Q?DVyuoJ2rsihWUmlG10bjLVoEleDnJqX/ynZ46M4K+dIM8BNsEb99s9uBmycu?=
 =?us-ascii?Q?ws0ruK48rL6FDWaeLHZrRptaPXj5n9uWN6KCdge7bDxODD/Y5Foz37wKbDca?=
 =?us-ascii?Q?QOqE9XT7SwZWeqUVZSyxNnfWSjnuJ1mB4J+KkGWiYuYGCcjVBzZ8vGHdSZoJ?=
 =?us-ascii?Q?X62tzY7E8O4bejWfN/gIQP+nH5ckf7dGxfTgTt+2nmBQvv8inJDrB3+8Wvgp?=
 =?us-ascii?Q?m1x3vBUn6kh9oXSW5FNSGjaeDRIIm0ko5uoyyIx7QiM/SeQt7cdxuhbRip+W?=
 =?us-ascii?Q?Odz4Xs6bvGwDJZZgyvR/PQDKUupnPTXXURyp7mFvl0jxjvnaAYvpT7qJ6wob?=
 =?us-ascii?Q?NG1jsBR/go10WFqfHZY2g/aX8VIjRpe9D4IOBLAsTOLIxSiLG7kxZhyRzFXl?=
 =?us-ascii?Q?mMvjTNGrCiuRuRYw9GgQgASbLin+Ehu0CR3oICgJhMKtvzGq+Ifg1iqPcUb8?=
 =?us-ascii?Q?Eilh4D+gIM99SytXDOKHM8lmuFU36AK2vHLdkvGIAIpBrEguDgej3MHW80ur?=
 =?us-ascii?Q?zGPHxEXcwaXwITc4vv7c6xdISr3b2WUlnspwZTveKcHtjtjzkSGo7TwEPKgh?=
 =?us-ascii?Q?sM2mqJA1e15KMXP8ayKduXxCKTHGVksopy0jmRMebNsZPuivLl5MXcSufcAF?=
 =?us-ascii?Q?WH1dZA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3e6f70-afb4-4d46-2c47-08db680d8315
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:45:44.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gwf326JvGy72u6ikB8S+VwLKUPM0NgPxVpZsK8jUPl++81LqlRT0ZbB2iWUP6P16+8BJn6/ipDb8ijsBpDmLNaTjVHWm6/Tro/Z81zCyR9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3875
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:59:54PM +0200, Florian Westphal wrote:
> xtables relies on skb being owned by ip stack, i.e. with ipv4
> check in place skb->cb is supposed to be IPCB.
> 
> I don't see an immediate problem (REJECT target cannot be used anymore
> now that PRE/POSTROUTING hook validation has been fixed), but better be
> safe than sorry.
> 
> A much better patch would be to either mark act_ipt as
> "depends on BROKEN" or remove it altogether. I plan to do this
> for -next in the near future.
> 
> This tc extension is broken in the sense that tc lacks an
> equivalent of NF_STOLEN verdict.
> 
> With NF_STOLEN, target function takes complete ownership of skb, caller
> cannot dereference it anymore.
> 
> ACT_STOLEN cannot be used for this: it has a different meaning, caller
> is allowed to dereference the skb.
> 
> At this time NF_STOLEN won't be returned by any targets as far as I can
> see, but this may change in the future.
> 
> It might be possible to work around this via explcit list of allowed

nit: explcit -> explicit

> target extensions, that only return DROP or ACCEPT verdicts, but this
> seems to be error prone.
> 
> Existing selftest only validates xt_LOG and act_ipt is restricted
> to ipv4 so I don't think this action is used widely.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


