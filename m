Return-Path: <netdev+bounces-1699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF726FEE73
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3557B1C20EF8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C691E505;
	Thu, 11 May 2023 09:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2451F1B8FA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:15:36 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35C77EF5;
	Thu, 11 May 2023 02:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtBxSvHdkLKxsuctw6Q8Z5NtTRE5vrHUhNnEI4CglhtKZgNY5ECOHMpzE74EU0J+7iZssoLqgmCE7WmQX8tmbgGWfO4phQtE3Kfp9egGSx6ehBvL6XYINqd6hli/XnNIpRtjouAxCaN21uuz6iHu9fulJXUcqMT8x/zNVebO4kWvRA8JjocmOoVlyRaGIZfbf15oMX25EzbRl6bGti2mYaAoqyWWgZOKIykVZoNfjxf/qV0BncA9sSuVprJuHMOZdmUAuug4MPimF7AmzoHGdzpvT/UMdCWLlixrcJs4Cwqo3TjkJZKKx4/hBFP5jIy8tmfrLB14LB/sIbeTyA/LfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiCU3pY/KMHqtvzOg0OI0B2Sj7WN6kL0H+RXEBY2Swg=;
 b=THubbHYaioc2dT6AVFfzbTH6KXIY/DjS+6UTPIlXeMueQxftwIpXwrLs4sV26mfGZ2f5Xk//fjvsxhME+AMBESUi4VzUii5LQPenPNcvjE0y8XOqqV1RpEFTSGsF8JLSP4/483qwufJOwMZvIyQGlinGGbwIoCEnU7GAICPiLoiFDIJxIm5pZ++GrbK4cAUaXRGwf264ermPTOZt7xn9F/5/Hdzu2lyS8jk32wqJg+J9rQa7I1MjIZiJBur5MDg6pLLBetphTjTankISjXvNubpAptHd5w9aH3PFerk8XaoKQ+jaHyh/LdN16du7lmRJuB49cqG3dKW5bgAF/4lvwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiCU3pY/KMHqtvzOg0OI0B2Sj7WN6kL0H+RXEBY2Swg=;
 b=tcM6yGQ43PTBRtdfqKCn0xR9dNkHNLdjHEoug4Nrfwugd8VERukmhIeHAQsVyEVP1gTFsBxUN1IFNnQWWxoHzcr07WryF4Uwo1Ki7KlyNWC8+ve3wo+ZXaeuntrY/2GXrswY+KVsKgCVRRUm//LSMxc/Yx4uhxfnCZB7WtVEaw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5709.namprd13.prod.outlook.com (2603:10b6:806:1ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 09:15:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 09:15:29 +0000
Date: Thu, 11 May 2023 11:15:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bilal Khan <bilalkhanrecovered@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	majordomo@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix grammar in ip-rule(8) man page
Message-ID: <ZFyyK4Cvcn//yZdV@corigine.com>
References: <CA++M5eLYdY=UO2QBz17YLLw8OyG6cDYHm1dvs=mc8zQ7nPvYVA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA++M5eLYdY=UO2QBz17YLLw8OyG6cDYHm1dvs=mc8zQ7nPvYVA@mail.gmail.com>
X-ClientProxiedBy: AM0PR04CA0096.eurprd04.prod.outlook.com
 (2603:10a6:208:be::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5709:EE_
X-MS-Office365-Filtering-Correlation-Id: 33c148e2-e3ea-416a-8d3a-08db520043e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A2kf/fHyqJaslBj0+6jzRAQ75KsB2BsPmw3s0DRalEKj4j7nvoKCMxKGD5EzAUD87vfkc3cf+vvMuxA2lkc8Jfov7vL+oCt/gjsBT6GhVJJjrBDzmUnd+Pohqm5Hzah5/S3wNM/p4qpdEbtIxhPn2ORJiKdkuNLjQ7L+1WeHbyfuotMqLT7/SqNK3V53tUlhIQ2N9ES9Wxwwg4pb5Qut7o9YN8kA8wvF/ezMqZ4lJeUM1Wet7rDXthnE2UUgzWMYMvHHXRnjRq0AlAOPj137EqGuJshNlK2c9KnyiGIrpb6aRDtbeQPPaZtySbD/ucel0bLXtDoOjRwKUilU1Wx45nGOe9s+CeE/1djnyVx5WYxcTgeqohUtcBgLZReZfU91UH9mt4AFm2OqYqod9dw8dfCoY3mS47sWnKvOS0TXzQDEMQZ6jqHz15xbzyvSSLDT6zUNnC0susjk2rnl1qrU5Kb6d/eHnc+31LeDIut+kxCMtR0ZreqSfH6qTPYyh8MhVGrmq3EzuSDatrvpaZFBcX5VYYhu/f9aCenXAwCx1AB/xmUx39A1hZOlM0HPSHRpaFT6RvPiwgJfzTVs4Z5FTn9iWYnYwokU/PlLdzTZVNk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(396003)(376002)(451199021)(478600001)(86362001)(2616005)(6486002)(6666004)(66574015)(186003)(53546011)(6512007)(6506007)(36756003)(83380400001)(38100700002)(2906002)(6916009)(316002)(4326008)(66946007)(66556008)(66476007)(5660300002)(41300700001)(44832011)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?geC40m4NLhmV9EW96eaurKzrD2D1vFVInZqNTHf0DlxmcigwgUwqQHfuBOhv?=
 =?us-ascii?Q?8rYPzUaGP5jjXRmmPZW86YNphRqIlqm0bFVBl3SfZ8o8aF9l2pMP+rvgGyTR?=
 =?us-ascii?Q?aO0yHRdOQYA+AcNFomn0aGh5LQoiGffovtmN4leNFC+dd10hry1LFygDsQaL?=
 =?us-ascii?Q?PqUP89qKpNYveDO98XWUZrtRo9tACcqsNg1edIiUkPPcXvTNZF0DKO/VGFxO?=
 =?us-ascii?Q?U9jTkwHGxTSOS9CkAgijw0mtaN1k/aMJg34IdCUOSV+Da5o5Fb7nXMFstU9t?=
 =?us-ascii?Q?tGfaZOpPEwZLoZKzI8jMlZkyY1C3KNwP0X1Np3thvvzmCGZkwcPmRmjNOlVZ?=
 =?us-ascii?Q?db/jMbAEZeKz1Wg6XNrtpHuwFuJ0rhBaPLcCy8dZF8MAA3Kg77X4oRkByxOM?=
 =?us-ascii?Q?n/lMuQoEA9buf/gC4/3G92BM9Vmd+SoiZmtVVBcJLwzDxgTjN7G6ZT7JVKdM?=
 =?us-ascii?Q?kFFjeBWBmIpmdTn2/5Kd0B0hyAlG8BdRdN2cdCbc59aUSAFLvbTvQVD1oRk4?=
 =?us-ascii?Q?mErfzjrbajsO+yCZFHwOoWDLxjxBGnfsbocij7kO78I1ljZD6WBrji+85Hj1?=
 =?us-ascii?Q?TG8q0yl+H1COp0pPfhiIpe4r35Nbi+zDMgySwO6Ct8zecNRsoAjcTeFsMW6Y?=
 =?us-ascii?Q?hQUDisWOsYP5Z6mBFHcCZZ2atBud/CyYCOmdun/FE957Xugk6oH91g1z2BYV?=
 =?us-ascii?Q?PSP0Bod6075VetKW15MDH7t9ZUmUPbx/iECNbVOslW/X3h4RJ7djlC9ihosA?=
 =?us-ascii?Q?rgRZXR8NpJtw8gvPsIIWyoEVOa6Ust7HKRffUQptKJCcu095FFefjCuVhPyZ?=
 =?us-ascii?Q?qVOiB1YhREnrCiUEhIcIyLAYZh+rvYYxtpe44YYSdYJl4khEYhoZBhRl7Mnf?=
 =?us-ascii?Q?gUgqSogt8+VyXpDIhRvUc7Mqcc+DhyphR3AG417bKLZFBlrfqksNvqwiF5c/?=
 =?us-ascii?Q?h6M2awNu2hceKItRw2YRh6KvfAF8K8+SSNksmdXrcm/gY37ziLigaKkBsIFo?=
 =?us-ascii?Q?2vmBlbXnLULFzdLrOq63bkDPake2U+P8ByliseekmXQjH08qHXvXPGG/bMty?=
 =?us-ascii?Q?x1t2/SW+ujDqgBtO/IvbNRgjYjwIu6Py2vIAPHbJNtqM//DG3M/DjItAOSxy?=
 =?us-ascii?Q?yUME8yv55qYSvTKo6CY2e7Ke4Q3cv29K08OqMzZxHkX0oDVWNy4hvFHvIkvW?=
 =?us-ascii?Q?lhlH60eSWmSMuuMQHn184uAGuFxla8Sn0GFVIZ+0swt8kXI0qxbi8+GDFkvt?=
 =?us-ascii?Q?kGhCF9IkHNhSJvHCdfbrkQdKKuSAKSIdhN7Q20i8XykHA/mLw6UE3F6rHHGX?=
 =?us-ascii?Q?3Np8o0Cr67IJc3RHCSGaK7xcfG82X8/u3HRu/6V/6CmyDhPYCGhbhIZVsM3g?=
 =?us-ascii?Q?pIt0bhGWLgkBF7dr4QLh1Y/6mjAqICbVA/i9seWobB0Zl+t6uQPXnD6PdIL3?=
 =?us-ascii?Q?OlTD7ia9+XNE8pVFFG0UcFgoeuyFfuxVNf2dP68ZoRmpFHJZyTWiKTTpHwZV?=
 =?us-ascii?Q?RRVPNH/nsFrY8x4S5GfSk7F9ZUzu0Ns8VgMHNZE20O5Yai5XQWZg3c8dlTa5?=
 =?us-ascii?Q?BElFjuWcY6M/q6lZ18+jCEGdT1kkZK9Nj0ct2OFl6kVdsVhtJBtoGMJLt+1F?=
 =?us-ascii?Q?bHc+8riYLBVS4Nc+R9bk1yzPrENZKFY3f54uXJ7hof7SOpT+DyeJi6BrVC+H?=
 =?us-ascii?Q?il/yzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c148e2-e3ea-416a-8d3a-08db520043e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 09:15:29.7764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3weLW3O1j8YPqWWovnCya2ybPBFJwzz4b2HLfba2M70p2UfGPhCYC39tfgf1A/P8/QHk5nz3+bBQx0tTwrxnIJA6H2kbYmOaKPqytBmlxbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5709
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 01:05:02PM +0500, Bilal Khan wrote:
> Hey there,
> 
> I have identified a small grammatical error in the ip-rule(8) man
> page, and have created a patch to fix it. The current first line of
> the DESCRIPTION section reads:
> 
> > ip rule manipulates rules in the routing policy database control the route selection algorithm.
> 
> This sentence contains a grammatical error, as "control" should either
> be changed to "that controls" (to apply to "database") or "to control"
> (to apply to "manipulates"). I have updated the sentence to read:
> 
> > ip rule manipulates rules in the routing policy database that controls the route selection algorithm.
> 
> This change improves the readability and clarity of the ip-rule(8) man
> page and makes it easier for users to understand how to use the IP
> rule command.
> 
> I have attached the patch file by the name
> "0001-fixed-the-grammar-in-ip-rule-8-man-page.patch" to this email and
> would appreciate any feedback or suggestions for improvement.
> 
> Thank you!

FWIIW, I'm not sure that an attachment is the right way to submit patches.
It's more usual to use something like git send-email or b4 to send
basically what is in your attachment.

I'm sure Stephen will provide guidance if he'd like things done a different
way.

> From 26213b82b4d3c5bbe7bca5ab5378c55f1e1c9e78 Mon Sep 17 00:00:00 2001
> From: Bilal Khan <bilalkhanrecovered@gmail.com>
> Date: Tue, 2 May 2023 14:44:32 +0500
> Subject: [PATCH] fixed the grammar in ip-rule(8) man page
> 
> a small grammatical error has been idenfied in the ip-rule(8) man page
> 
> Signed-off-by: Bilal Khan <bilalkhanrecovered@gmail.com>

In any case, the change does look good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  man/man8/ip-rule.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/ip-rule.8 b/man/man8/ip-rule.8
> index 743d88c6..c90d0e87 100644
> --- a/man/man8/ip-rule.8
> +++ b/man/man8/ip-rule.8
> @@ -88,7 +88,7 @@ ip-rule \- routing policy database management
>  .SH DESCRIPTION
>  .I ip rule
>  manipulates rules
> -in the routing policy database control the route selection algorithm.
> +in the routing policy database that controls the route selection algorithm.
>  
>  .P
>  Classic routing algorithms used in the Internet make routing decisions
> -- 
> 2.25.1
> 


