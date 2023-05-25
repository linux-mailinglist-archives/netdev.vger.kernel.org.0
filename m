Return-Path: <netdev+bounces-5245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF435710632
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 421481C20B9C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47542BA38;
	Thu, 25 May 2023 07:23:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A1CA923
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:23:18 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::70e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB939C;
	Thu, 25 May 2023 00:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgoKMsSmYqqD0dpQgIp6kz5726T3ZxQfkxcX5e3FG2j9BTbbFqhSesb85Fh7wosKPVsXN9kubfTL4G4khtZDUHXPYSutBsTKbman5LCbM7nTNaySnm2WJOmRFKyoThpK1bXnI60VVpL5ksmU5zbjAOAPUlQ9P0k5b5XJUK/ze06cappTpysqI3h8foyOvKcvPSVFrB2Aw5Z+hvopUsMFKvOMa3+KzJj6yyogyOY46aNl9e0ldAWMbku/qU8Htsgq6dZ14x5nsiGTsPky0LNyHx7EdtOkWHet7VDExwVnLEaAXw/cMkzMtCDePOWEze+ipFF63kSg7eIcgzcWGtm7Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/megE2YfryWlCKWpxNZuimecRZzVeiX6r0U2A2pSDQ=;
 b=VsGzrxPH98HrYBm6BCyhrznvus9e9AqOC7ecZXnYLjFHstTfw3fGKb8sKut0cJ2YVchdoetg6jGZwFLErBNlb5Sj/Gz1+XA4Ucbygyt7ocyHRRNvSFpT4+hetcPbAbVxPrk9GjJAWln4Z7ujYm/vatQAWo3h8i+fZEkxcLCSY6EttphGwPTOr+FPMcIXJOP4wfE9KXS7jTzLRpAd8R6FU50rn5wKjJK4cLE6PLcgXGkF2d3FefslOZHQHrhRPwbYjQLxBZ8Coh+b2fAWtFXflA1O+9pNl2wIxRWpyrYKqWi3CtaqujWxGa3lO2bAR99USFHtg8QsXQ/UF04e/OfM6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/megE2YfryWlCKWpxNZuimecRZzVeiX6r0U2A2pSDQ=;
 b=jsuj5aqeOEAzSbyiczwSj7ZRuQU8NhUKfn+adeTOeWlPRRsBaIq33ahdn4dnpg4pv9mSOGovRuzZfWW2TIRSl7SRRLGStanJThYj4Uou+6mnbRnEr4hCD9zE1VG5c9Z5PGlKCjiFB2kvpQSQCOrQQdbEyPsJY4nEO0+7tPrHjO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4949.namprd13.prod.outlook.com (2603:10b6:303:f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 07:23:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 07:23:12 +0000
Date: Thu, 25 May 2023 09:23:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, Tero Kristo <kristo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v7 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <ZG8M2EDSG/NtiTwF@corigine.com>
References: <20230523023749.4526-1-jm@ti.com>
 <20230523023749.4526-3-jm@ti.com>
 <ZGyfAhp8op4GMElN@corigine.com>
 <8985ea03-a7dc-a0bc-a238-3099caadf740@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8985ea03-a7dc-a0bc-a238-3099caadf740@ti.com>
X-ClientProxiedBy: AM3PR07CA0093.eurprd07.prod.outlook.com
 (2603:10a6:207:6::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4949:EE_
X-MS-Office365-Filtering-Correlation-Id: da8b8678-d339-4ac6-ea5e-08db5cf0e5b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mLSTwQQW60J3+7Nf5Z+/zXPQbB5KqA9qpbUISDKK03ohY+naN95EAVhpAaF3tprO/k67N5HQQ3GGEcVWvjWBdBN0wKPJPXlfohViloQN+zLd9p05iimrACVZj99PLKWZ0kH5TfyZTuO2695MgglnlLONmRcNuIgshHfGzHxpZDUQrylRYjoXMT8PzVUtvwIa4CM59oJXeqamfwu2EU/GKR0TrNJShd5lfKI1JzwW/o3FKlL6xe1yhkeiqHOrgSovtvvx9Wp7q6By5NdEXd+6fHQhgONZxRuwNGf7GNNJcCx0Uukw5gYTGTnmLPJw9rlhxPcwgfvkMENKp8ziVgmhicLF736GXq5DdXRDnVv5fyeMQdUiMkBXNAB2PubfDWKqzrmltMM9AEKklUyGZypI4zWkLNnifKIWzRiVB78mLzEuI4yNO5usBo5Jkeur0mkenQPS+j7pHYPgLmlRTn/abFuo1KWXixEMQLkZQqBVhSM6RolKtQjP6yXpfBfuqmiwsRlBczxUsJniY7EOPZiLJ3WbtReB949f25RDsiQA8XE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(376002)(39840400004)(451199021)(66556008)(4326008)(66946007)(66476007)(6916009)(8936002)(7416002)(36756003)(8676002)(5660300002)(44832011)(316002)(54906003)(478600001)(41300700001)(6486002)(6666004)(966005)(38100700002)(186003)(6512007)(2906002)(53546011)(83380400001)(6506007)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rFnSqE1yBiIyV89lxHWSoukKXT/Wc5U0ZYn7gCbYCNtIfY73vQ+4lwkL36we?=
 =?us-ascii?Q?Hn/JRltrhHWJdyVOfy02JfStNe3061eZpXKlBm1SddpztUBgYDPJUW5eObu/?=
 =?us-ascii?Q?OcxYwHtxdxxZjg6iRiO0sBShkM0VK0Qw2AxUl/tyy9mDQT0OBSIIL/Xv1e4p?=
 =?us-ascii?Q?bhaD0DNj5CyyE7s4c/5cphTwitHnl9z+UKudL4BOlkjI+rXpwt1lcm/Av3kQ?=
 =?us-ascii?Q?c5XO5YSoZWpATezTfsCvQTy4MWzgtmhVMnUmwQMIzf0bKSAouI6J+VBiWqQx?=
 =?us-ascii?Q?cakicJKtJtFQgSxbHgoby3p2MURfkeUiuXK5C+8XaurG6DinabGWviDFldJt?=
 =?us-ascii?Q?7foHlWZ/QCrM3WPfNI/e9BbCgLfMM6Zavgm1NJhBNhf9FCMa6FxQj/hAXBgT?=
 =?us-ascii?Q?iEkgziPvb+6qLtKYEZA40L9rae+slBPsjAJkgNgyE9tnJP1eWlrkyQgbnl5v?=
 =?us-ascii?Q?VqBCua38u7fA0jYkYxHMCCWQa88YWJw8vBMV6GOxKhBSN5Jzt/UV3woNk0c0?=
 =?us-ascii?Q?rsB1uiCg8LPzq51tV6JuhqUtYVEul7w7Za40l/B/0QfkhfUPPluPPApYEnMa?=
 =?us-ascii?Q?djzka9bsF5HsJ+30XuUHv9X5Lh9N2U23MDe92MabWHwqglW9F2MAZEBQyM3J?=
 =?us-ascii?Q?Ltv6OQp3moLpIug0x4LA+fYy3kssbVTxt28lwxsqoHfLyxyqCMf5nKIIvmCy?=
 =?us-ascii?Q?at8kxeVdKrjeana9BSIHTzUtNXddhjA3UgwCNgOS0wFB/iFzXZ81KMWMnaqy?=
 =?us-ascii?Q?PkaR1Le6tbTnyJhhKAQ59u8BW7+lRy6SB5igcphYggAkgjh0EzLDQG5p+PiC?=
 =?us-ascii?Q?7UnAXB+VYD6wlsBeTe6J8AW/b2LZO5/8fSNvRFpVmlUrFMzCQAYs/HE+8d2z?=
 =?us-ascii?Q?4r3jsfqk1+jRZTYhBBaoHyeeKZyf8L+/TTXn1D54qNY0N2PzObUIzvXjr9bb?=
 =?us-ascii?Q?NSary6pjU9qysvcDqS3f+auoryzCyTX84Oe+WhxnzVGMVWyh+UOrMShBgL59?=
 =?us-ascii?Q?70za5KOvqois6sZ6NgaJ8Nqb0cf9HzRQqIfOjs5RpjM/+iUtx9lZlu06ClRv?=
 =?us-ascii?Q?guqNAh3OeawZBd0UjOGpScNu0XueTWPWyhim/mUCYxVaaaIAZGiyWklKx28C?=
 =?us-ascii?Q?QHBPnkaLeU+5VG6YAz25KpoUDsqIXHZwDtyub3sR4cVSNEOFW6N1qnpKwb9r?=
 =?us-ascii?Q?5oTVNvqTjVtXnBBFuRBJ4wIy0Da3p5i6/fI7sOKuKO70+nrBVHN8CN9ru4I+?=
 =?us-ascii?Q?WJLeKHJJmBC+2HYi3zwkgYAoYt2svtyV/MbuVbVRolKYCy/KIzLns+alu1Tm?=
 =?us-ascii?Q?NacoRgxpmX7rpJXSyRNJInBPvV2XaOGw9bXSPK4kMI4HfKxPNM3t2TH1H4FF?=
 =?us-ascii?Q?cY7gUPlTEHBvuty+rwJJh2aKCgHUc0fifyE16wq/LUvkmnO5t/sjb0vm5vwU?=
 =?us-ascii?Q?QOKRZk+B5r+d3XAStbFcc3S9sAQoWNzT8ThgXYVcLNcRAz8ZUyC4IJH5cg/r?=
 =?us-ascii?Q?qa/Q2a8KzCr7E01jjVt2BTBrYxTDG9RsRjtMm+q7abOJdlCftwoiPu4cMdPC?=
 =?us-ascii?Q?qejgXVTLWlHXpT2UmP4ZKZexuiKrco3BGsXjVNzhwxUkj3lEOxVJ7mLBbms3?=
 =?us-ascii?Q?G61IpisRvbBF6yV5rllZsvnBYfYC9BcbOZJDxrGZNs/VPAbshtM3HRXQT5yX?=
 =?us-ascii?Q?NoNzQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8b8678-d339-4ac6-ea5e-08db5cf0e5b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 07:23:12.0376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWajdZrPI6M+6PPig4Ei/XgAq0n2RbpvNIys3IFYqNmTtEYwbfzMZvqMarDRGuy4vankqhhSk3LCFK59qBGsmnWtjAYCRxRsKQoX6cgWoOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4949
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 04:29:01PM -0500, Judith Mendez wrote:
> Hello Simon,
> 
> On 5/23/23 6:09 AM, Simon Horman wrote:
> > On Mon, May 22, 2023 at 09:37:49PM -0500, Judith Mendez wrote:
> > > Add an hrtimer to MCAN class device. Each MCAN will have its own
> > > hrtimer instantiated if there is no hardware interrupt found in
> > > device tree M_CAN node.
> > > 
> > > The hrtimer will generate a software interrupt every 1 ms. In
> > > hrtimer callback, we check if there is a transaction pending by
> > > reading a register, then process by calling the isr if there is.
> > > 
> > > Signed-off-by: Judith Mendez <jm@ti.com>
> > 
> > ...
> > 
> > > diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> > > index 94dc82644113..b639c9e645d3 100644
> > > --- a/drivers/net/can/m_can/m_can_platform.c
> > > +++ b/drivers/net/can/m_can/m_can_platform.c
> > > @@ -5,6 +5,7 @@
> > >   //
> > >   // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
> > > +#include <linux/hrtimer.h>
> > >   #include <linux/phy/phy.h>
> > >   #include <linux/platform_device.h>
> > > @@ -96,12 +97,30 @@ static int m_can_plat_probe(struct platform_device *pdev)
> > >   		goto probe_fail;
> > >   	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
> > > -	irq = platform_get_irq_byname(pdev, "int0");
> > > -	if (IS_ERR(addr) || irq < 0) {
> > > -		ret = -EINVAL;
> > > +	if (IS_ERR(addr)) {
> > > +		ret = PTR_ERR(addr);
> > >   		goto probe_fail;
> > >   	}
> > > +	if (device_property_present(mcan_class->dev, "interrupts") ||
> > > +	    device_property_present(mcan_class->dev, "interrupt-names")) {
> > > +		irq = platform_get_irq_byname(pdev, "int0");
> > > +		mcan_class->polling = false;
> > > +		if (irq == -EPROBE_DEFER) {
> > > +			ret = -EPROBE_DEFER;
> > > +			goto probe_fail;
> > > +		}
> > > +		if (irq < 0) {
> > > +			ret = -ENXIO;
> > > +			goto probe_fail;
> > > +		}
> > > +	} else {
> > > +		mcan_class->polling = true;
> > > +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
> > > +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
> > > +			     HRTIMER_MODE_REL_PINNED);
> > > +	}
> > 
> > Hi Judith,
> > 
> > it seems that with this change irq is only set in the first arm of
> > the above conditional. But later on it is used unconditionally.
> > That is, it may be used uninitialised.
> > 
> > Reported by gcc-12 as:
> > 
> >   drivers/net/can/m_can/m_can_platform.c: In function 'm_can_plat_probe':
> >   drivers/net/can/m_can/m_can_platform.c:150:30: warning: 'irq' may be used uninitialized [-Wmaybe-uninitialized]
> >     150 |         mcan_class->net->irq = irq;
> >         |         ~~~~~~~~~~~~~~~~~~~~~^~~~~
> >   drivers/net/can/m_can/m_can_platform.c:86:13: note: 'irq' was declared here
> >      86 |         int irq, ret = 0;
> >         |             ^~~
> > 
> 
> Maybe a good solution is to initialize irq=0 here.

If it is valid for mcan_class->net->irq to be 0 in this case,
then, yes, I agree.

> > > +
> > >   	/* message ram could be shared */
> > >   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
> > >   	if (!res) {
> > > -- 
> > > 2.17.1
> 
> 
> ~Judith

