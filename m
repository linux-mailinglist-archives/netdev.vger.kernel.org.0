Return-Path: <netdev+bounces-4874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E296870EEEA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6143C1C20B46
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B501C6FC0;
	Wed, 24 May 2023 07:04:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B271FA2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:04:19 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::70e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BABEE43;
	Wed, 24 May 2023 00:04:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDJQiDcttyihxXUuz9jJ401tpDJ8im7yz1C0GxhBcu31i3gRRAmVbCgTvUQ/lfib3nHzWoFhPCyIOI6Txq73an8Prv7jwogzZFKWYGfiTE59ZgmfExuyhGeRSN/zup0ZyqJBGxIoid4pnjcN+PnAu334p9vOYCIzXfWWzCnJ6IBi/pa/662jFlDH2gTUiXsl42cu7yblhyA/Q9Wx0iUBUkrMaE7nhdLTgtUNsOGqR7GqTPp4h7tFC1X2+8YAcYY1wGZ+YZLmVvahDgb8Aj4g76acupnKXR5LMSNi0upUI41mm39cYY5S/jzQEzXxDOSNxNbZ2eRgqA+7OUw/Psvz8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbIiLhDSOb3ep4comWGnDxc3ZUf6czjFJ/ODm6Tyfi4=;
 b=WIhna/n9pzc32JoLPFm2L0IEi5Bv7N86np8LWioLaYtkijGrg61zoymMkjgnzT7ClhyWz8X9dHQX8eVkg0U6TrcCY22v2jDezx98bq474da5ST6ZrLhFlWLkPImR5i8XHlJyWjdfTuwmOAP69lNeNSoGQKOexbZFQxAkGA8QXTXTnngn11C36qzAynMxuDNsWD1hMHu9a/qTW/osTUXHCA1bLiI6hFsFDuQrl5apMM2nOFJ+iw+rmWaPBRi/4bSpWVDYb2RYTH5crizIlX7P1DrNMA1Bn9dMrCgM5TZAmUpZbPr9u8u3kL1K2mFHWifohfXtOkuQlLkUZg5gpe90QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbIiLhDSOb3ep4comWGnDxc3ZUf6czjFJ/ODm6Tyfi4=;
 b=ikCw8ufFJsmt5GLLMu4yeCNj1IGtRUmj3G4J2OuY7qYC8Su8S0q7mattN3+6+x2wRKWfT2mhgdd8zTfkgCUS/cBa50TNI/jtFHqtKK1Uv7kp9KrJVGapjOgbHNW3HYMUGsHCogysv1K22YQdPuzmkWwwfaSCKgqBQv7wItofse4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6324.namprd13.prod.outlook.com (2603:10b6:806:397::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 07:04:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 07:04:07 +0000
Date: Wed, 24 May 2023 09:03:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] hv_netvsc: Allocate rx indirection table size dynamically
Message-ID: <ZG2236VbHkOpjau2@corigine.com>
References: <1684907844-23224-1-git-send-email-shradhagupta@linux.microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684907844-23224-1-git-send-email-shradhagupta@linux.microsoft.com>
X-ClientProxiedBy: AM0PR02CA0083.eurprd02.prod.outlook.com
 (2603:10a6:208:154::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aeff96e-e486-4df8-aff4-08db5c25111a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cFcuKYXWJcEj/1RUZ4G6Qpz7mUpQ2AiQ9rThkOiGeL6FOqzp2RPmb2hmZSRDBbme1j13XftdQfZ4rFa2jcCvlQvTcGXtJCB2v1knUzQLYshIW55kyLB78k7+x1B7Rycz/X0hFGYKmwig++//fx2KkHomCamn4ZpUeKhpjUlHADT6zIRFGRP8mOHhwPFKlnl/NnWsF3+PNbX+rXFPZCFEeBtSnEcNkiRitambt5U1TKsJu/ayLksQZyvS51lDByWKYe7OBpcTvIbOJdp6/InUD79soLrEhjQZgrKde/sGWi5q3XiCIqgwXozhrTQzlVP7GSttbGrfn06bRe3wnev6j6fXjxzuzQoS5bG2DdE1VB95NVmfPyl0rL7I0AWjeWTZXCgPwV3F+eWlHd3IrKE339l0TBdM92nrJzmjy2DorCx7aCfzCx4HlJLpIoCvb5UXJINgLaB9TgWKHqaZ9Ag6ckH20UZyMXSZbLTgsvIvW0YYR+mIXFrNhu4xqFvM6MrWsfBNuNG5cK5gv2GSKsHfOAa6ByVncvSvNE4O8doDvyyXG4xhY5R+ppW2cwtG4TXXlnavHFK3Z03bk0vkf0Nr38/bHyt15Y1vB58M4aumHfw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(396003)(376002)(451199021)(38100700002)(66946007)(66556008)(66476007)(6916009)(478600001)(6486002)(6666004)(54906003)(316002)(41300700001)(4326008)(86362001)(8676002)(5660300002)(8936002)(7416002)(44832011)(6512007)(186003)(6506007)(83380400001)(2906002)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BPucOg8INLBhWCX71smmaN7Ei/tcIkWE0pXDLRyhVYaAnn6j2OGkKQVEPtLn?=
 =?us-ascii?Q?jo8Q8IcjdIyJCCG8QDiniScHiI+Red2QKXiD4f2NVPyGjt5ujhXTQZeat5lw?=
 =?us-ascii?Q?SjrlUb7r9v5D/mDxErYoKRMLyqPUFq6eRlMTfH+SEaaJjdXg+lGuDAmjguzl?=
 =?us-ascii?Q?qvIBNsAZkREUmf7NkhJuX5M/FfUNH7Kzr5ifpWQtBYqy8OX7oCbUdDW9wS1O?=
 =?us-ascii?Q?4kcI7E7BrjmJyS9vmM9kchKq/abqBpDIuSDYLrgZsDOdSmPOiaDTJ+vgqOsg?=
 =?us-ascii?Q?i+6hmAjP5uPeRpHgyephqqbwWiNNu1z8CkluIJQa8KJLHeIIbq8TlFPqQ/S4?=
 =?us-ascii?Q?sX5CE97epUWg/h6RIXbh8jbvwdk30nPLOeFa31qwx+vqVOixWj3ZnHlBjtLG?=
 =?us-ascii?Q?zEaD8ZC233+W72crGUQSAggFD1KXPfTknsf9x2DEFKG7kIhN0mMvogDLfjg8?=
 =?us-ascii?Q?64PilqtwvcZzp0E9/KTbjFqzppXBnDpK295ULZ+pkeQrtnsfslYcPTbeCPJx?=
 =?us-ascii?Q?HP+TFE8sTJihiagSprveO3s8iEKdoUkBZKYlUOmYiYuVOnwqYtMpUMnXyUyU?=
 =?us-ascii?Q?7Z67vEqmfsvhyo7arReAIH1DCVTZqmVRRsuIlSqKJrPx0s/1awhrPRdGRQHs?=
 =?us-ascii?Q?O87s6QDAFiuU2/tpC1Hal5jjeITqmNGbu5r4PC7I47/xXFObMM+VPHSH9nAB?=
 =?us-ascii?Q?4Fq7ifTOXwKfIsSADmOa/US6/53sEjFELyhIDwxiYgsPK+ixtLwsfKzRYpii?=
 =?us-ascii?Q?Tz6IJ387/+r6DkfFvMmkX62zN8hh+yHUxVLpsQ6V20EuddNl0WZkJKRroYN0?=
 =?us-ascii?Q?1EOOXZnKsLAXqrkk8LM3X8okz1M3mwajrPFeoovZDudxCp1kgjUP+YJHOF3W?=
 =?us-ascii?Q?hwbVNGYJZPS9OIz+QGYMiIZC8BeInqXEjfuD5eJ9hxgeS49epso5rfTIKg3l?=
 =?us-ascii?Q?urKuV+jL5cVfV4LFbBbt96DAF13s3KtRZ+CcXlbZf+eBfHN+s/qsSR0VeGtP?=
 =?us-ascii?Q?iWnexIktqqJm9+8vU0OTPSeNxbbIZj4nQhS2a+iUMGJ4wsrpLPxEajOCdCxz?=
 =?us-ascii?Q?p/XhWjeosE/p3/Dk13lTaa8WEJxK5+CF0NW3M2ODqb6q0pqXrZRw6v8nkDQ8?=
 =?us-ascii?Q?Yl2AoNwhlS95In7Xv9XWMrjvnlgOxQZYAJWD2TrhT2WI5JMjkKLvijcgYSEM?=
 =?us-ascii?Q?aL+FSWUSD8RFU4ehYm8ziWS32gSwR7jEK1CNV2eFQvd7jEGkf+Uf/NYa03yB?=
 =?us-ascii?Q?JWknh5W6JMxjXGU9lMq2pMN9YpjmQGa8qu1YmwNS6hMcNmHscPCiUgp1Ghwb?=
 =?us-ascii?Q?lwYdBhkaYBD5wXLHUOixMd4q88YPfDYe/2Cb9wYgMEYqFwJFAkddJA1iqfnN?=
 =?us-ascii?Q?Yt0qc8+MHGKqSMzOV9S6ftbY4uyZwtuiEgAtdPmdfj5uZHuSRa884cgTU7FX?=
 =?us-ascii?Q?mCmLByBaVln6+C9jhHZgdmrQVHRBIyV/4savjBl9I2nSnUsUsVFGVYva9TJU?=
 =?us-ascii?Q?q7RtJ3/gczmGuPZZpS7O9fX7vM1n68h6m9SxNA11pye9icNKwAvRq2rMZQrJ?=
 =?us-ascii?Q?GTuoGU3U1rirSw5F1kJBdzLFYPbVYR+rjBNHwRP+0UFMr+jte6ovoeDVC1bl?=
 =?us-ascii?Q?Avpoo64HmKXcZzQCYufyvMOPzO4CxC/QSnt9CVCxZuvbqSDSYKUaTXlGrzP0?=
 =?us-ascii?Q?4CH1FQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aeff96e-e486-4df8-aff4-08db5c25111a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 07:04:07.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPioUT8bZytTPm6LWbKoQuN+ZIXGt1QPUUKcubymVBUXDE/QaCxnIWDEUxWZQYW132W8NPN+wzt/4TY5KVJHUFmGxeWS2mMht19u8yyGIPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6324
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 10:57:24PM -0700, Shradha Gupta wrote:
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>

Hi Shradha,

thanks for your patch.

> @@ -1548,6 +1548,21 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>  	if (ret || rsscap.num_recv_que < 2)
>  		goto out;
>  
> +	if (rsscap.num_indirect_tabent &&
> +		rsscap.num_indirect_tabent <= ITAB_NUM_MAX) {

nit: the line above is not indented correctly,
     it should line up with the inside of the opening parentheses
     on the preceding line.

     Also, I don't think the curly-brackets are needed.

	if (rsscap.num_indirect_tabent &&
	    rsscap.num_indirect_tabent <= ITAB_NUM_MAX) {

> +		ndc->rx_table_sz = rsscap.num_indirect_tabent;
> +	} else {
> +		ndc->rx_table_sz = ITAB_NUM;
> +	}
> +
> +	ndc->rx_table = kzalloc(sizeof(u16) * ndc->rx_table_sz,
> +				GFP_KERNEL);
> +	if (ndc->rx_table) {

More importantly, it looks like the condition is inverted here.
Which seems unlikely to lead to anything good happening.

	if (!ndc->rx_table) {

> +		netdev_err(net, "Error in allocating rx indirection table of size %d\n",
> +				ndc->rx_table_sz);
> +		goto out;
> +	}
> +
>  	/* This guarantees that num_possible_rss_qs <= num_online_cpus */
>  	num_possible_rss_qs = min_t(u32, num_online_cpus(),
>  				    rsscap.num_recv_que);
> @@ -1558,7 +1573,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>  	net_device->num_chn = min(net_device->max_chn, device_info->num_chn);
>  
>  	if (!netif_is_rxfh_configured(net)) {
> -		for (i = 0; i < ITAB_NUM; i++)
> +		for (i = 0; i < ndc->rx_table_sz; i++)
>  			ndc->rx_table[i] = ethtool_rxfh_indir_default(
>  						i, net_device->num_chn);
>  	}

-- 
pw-bot: cr


