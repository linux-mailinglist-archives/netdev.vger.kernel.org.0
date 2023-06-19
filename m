Return-Path: <netdev+bounces-11973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA16C7358E8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD97F28110C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B4F1119C;
	Mon, 19 Jun 2023 13:47:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8F01118B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 13:47:49 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2107.outbound.protection.outlook.com [40.107.93.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE5DE54;
	Mon, 19 Jun 2023 06:47:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9cUGixCB1C9sbp2mLL6fylgc4Mhpag9XG+Q8BYy+QqZI03MbsJCE4PXC6teGGgmKB+1srdPn7qeKy0ZJ4lamIx1NnOcl+v/6alRdyQcebVr2bMoLe68xrX3Gp+SXZiCNrlz0kppxAhdVGLqQ2aA/7K55kifpzRnEFf2J7VKgGS12eMRBVv9o39Olqnk6yrSVnzzSVYF0KA6EHVgo3EwegsZIpSvJChhwadkT6o00jLWtKtIYebHck8iz+lGR4oCyOPQSQwcldqmsDFVkmx0hpryI2broGdINs4T218WfTzPPQK8al1lnYaF+ril8kUIwi1hvJHvkkiwBX0Dl3r+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XbEPFKGfWrarrs9tUnQw/EEtvwGjUmAlv+f3Fu2R8w=;
 b=J3Dj/Gwt8PrF962BsbtEysvmMDJx+Ae4GyCoiDbV+hsmOKhyQ1qlKF65tazfZFjLg4+rZ2sVqCrYgjHO0ACy1vvzkbEEZMxtt5ohs/4HYCAMcod6fgysCNI466sKCEYwoSw1azwk486+txMfpMSSPcFewigQDhVaQjXIzFXfyUx7dY1/jILAU1mLHLcN0Ca9/tibFaMYxbZaqRn+gqm7aAIPURsD1PxO/IQ3eutQSx6izceabWJveALZiSwfmBFgRakHc67tB7rFc3xfm7lScWSbzxhTstS2mc7cE2HnhL1N2G40O6L6H9OEqUfPEffLedC4Cc+GBb9GsZEczXGOoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XbEPFKGfWrarrs9tUnQw/EEtvwGjUmAlv+f3Fu2R8w=;
 b=SMJPKQaeFICEbR0oAjyffYKU9ZW9TxMZQ2SfJiio7N/8LaNcKcK0Y24nmIgxTWFTUKp4N3rWmGBPzLYb5gr+COwv4Rbdc5HuV2yq0AZm/F3tujCFcHfXJ1WZqmGJ5hUiCTa05xgWgGvRhWSgziReAnEpysRS8hzWycRTr7yYENc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6059.namprd13.prod.outlook.com (2603:10b6:510:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 13:47:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 13:47:44 +0000
Date: Mon, 19 Jun 2023 15:47:37 +0200
From: Simon Horman <simon.horman@corigine.com>
To: carlos.fernandez@technica-engineering.de
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: macsec SCI assignment for ES = 0
Message-ID: <ZJBceYIkbZHnOSF3@corigine.com>
References: <20230616092404.12644-1-carlos.fernandez@technica-engineering.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616092404.12644-1-carlos.fernandez@technica-engineering.de>
X-ClientProxiedBy: AS4P189CA0006.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 580fc22e-b830-4733-4cf9-08db70cbc25f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cOTZBmF8jC/tncnSBisRdrEYJMFvF3ii3tzIUIxThYWw8eG29vBSqS0osT3XTKad3+9PdWa8Zps0jIKF5pKdxFnwwQ24WfPrFKxxyDUbHuQhH1iXIZ+pHHiZV3KmPf2mav4IdldSbtb046oPDPFOeohXkSM3d6xXTn2nRVVl+/QiFfYPTgLUhYRXwGt4yXR5xwZ2d2t/mobbWTUJQxv8mi2/o+NiFBVhsgr0UOBsk0jQH+tG1FhOzgH+IsR7EvwmSHwqTq960lSQTOlOlW97cqWj0hX0O9O8PT8i8JDpp+CaGoiOqm4Qj+C7T89gtIdEi2OdFdNjMmBkFmKDk39uk4rghcDI2iyZzLooUIBVFK+dJeSkOqX+xRs11GMxsrTK/MJJuKh293iroquf4S4elFI7guSvWujQyHgGVthSjG15DlvL+04j+cZSLNkKdciir547zsXxl+8TYHtoX+0cJsUunGMJosxKpI3h/X1iJ5MtWiYF80smL218H4e/MTF4DynEAARHG75BPhLOyrtnJ9aeIl7yhevg4xvgc7KW3z/I1rj5MZtXDIy5Tnf5rpmjItwiJAQ83KSwu/+Rx2pJ5q/sLGmzrDc65A0AhsHA+oU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(136003)(366004)(396003)(451199021)(478600001)(2906002)(6666004)(6486002)(38100700002)(316002)(83380400001)(5660300002)(41300700001)(66946007)(44832011)(66556008)(66476007)(6916009)(6506007)(36756003)(86362001)(2616005)(8676002)(8936002)(186003)(6512007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jL+xH9bM8YM9mooHK002uNTqEqzZBpD2MySB5W7N4wUWlnrybiUv7HJWkJhs?=
 =?us-ascii?Q?dQrQED8jhW1g5Rt4TEjOlyjmM6RVJtioj/b8ITljD3kHi4KGqqYao1Mk1XSV?=
 =?us-ascii?Q?LSbsKEtiGly1UvTwmbi7vV7n2mqcmll27rECtwbPqXC0FEa8BvPEJPM7PAdW?=
 =?us-ascii?Q?aZrYoeaJiHr35jm55zsOLZIXReClrtI4TdV1Rkc68wKQ+BZMUOW+8GmyKmqM?=
 =?us-ascii?Q?1VTYoKT2TC0QJTzVenjrtH6oZ5dh/YQ7RDHKgCMFucsvjOn3lhIkZ64XvG6e?=
 =?us-ascii?Q?LCQ9AcsaKSRjHiWUxQGjMKT0mMbUHzx7gmktH60hLBlsHQarC6QCI8bTPGd3?=
 =?us-ascii?Q?XKl//Y+fEVUehlfg2CQwfZmQLO2nnJfY9UFn3WBu/aFCi8Q41sh+gB76nRpe?=
 =?us-ascii?Q?aB9GM9ge38anXQq15LeSrtcR/fydu9FiRvEwul4PKiXW3JRN9piGaYqmdrN0?=
 =?us-ascii?Q?4Uijs0k22WYkxARBu0lw6uf4LbhTwIuu+88a5rNPeOCvQXWqhGBRWhxQBXEV?=
 =?us-ascii?Q?KfXiFyrmQD9j3oVJToLDjTCwnWnXr9xCI3/emugZjAGp5IXPO/+RpZzbOC8v?=
 =?us-ascii?Q?N/G0iGchB2x8y0qrtU1MuVaIP4s8E4Pvo+UOwgZisk/XxezcD6GzHqh7GtRJ?=
 =?us-ascii?Q?C/gNLzIrAFCVP/5YS4VfSTerrvSr+7NZaJ7mL8lEsxkaLWKlffL6s7b6b/cT?=
 =?us-ascii?Q?yTxFx5Nzew6ShxYmjmFYRwNaqV7XVuyYQoqKO9yvbHYVgMVvqEXVSpAol9Jl?=
 =?us-ascii?Q?XDb/mS8nt/MJqqLVRNMLNVgQyxYqfxpBaUBCRW9u1ks7v2cPt/Rafs9khTdl?=
 =?us-ascii?Q?UKHQyierQjGft852DEIjpDWJVHNHFXQYMnDpU5uzeDFhxFhXqXqIhE+ay/nP?=
 =?us-ascii?Q?wRWEbyT8yX1ruUj+WBKq7FS5ies4Q26k+XtH1GBkcpGstKe0M4s2S1vrUZGm?=
 =?us-ascii?Q?7L/q4aTnybi3r1fqkE6i9v1d6ip+QN5VM66sEmy1+0qiC4o41FzlgyQ4qrgp?=
 =?us-ascii?Q?t0i/mhBvICGCf2XtkamsDCGN/eK9QBBA4b9gG91GNJpxkK8QznqdWR0wmr02?=
 =?us-ascii?Q?gulp8WzrDUYvjvnvyDkxuMBSRJNGPIu47mCzFUira1pNBt9eRcT+rOXNIe1t?=
 =?us-ascii?Q?+FGpKeeXQEFle2qqehvCd9zD6FSF2M+KmaLNi3D0u4qGte4kY9KlOSdAZd7b?=
 =?us-ascii?Q?4xZT3bqHKvQrdedLpDadAmfQm2bfpGBT2MWMwBuZG6TODvWOuhwS2atA7gsd?=
 =?us-ascii?Q?jd8CkYMhCN4VhS7/LhsUOmbsrEf1CJrZIbuq3MI+3HO+R8kc9SpknNTPHew5?=
 =?us-ascii?Q?4mRy0v3CPZT0wniAQceeMUygb+6ayY6kjhN9mKPajEoxMwIBSj9+Vbf7woGx?=
 =?us-ascii?Q?4XhdmKmD2x/TFlbUErkwxZcT0HFUnXrAzc5MshKlAZSkTP48h/pYHjtsDo8w?=
 =?us-ascii?Q?awkuKp82AsEbjFroYeUu2b8nLr5y9mHoVoyDhh2p3zv8E6Yv6PcxEv2t4/l6?=
 =?us-ascii?Q?lPgM7QsOwuxVj0egmypyyw8ik952L8mCieZtseRQI5FiZzgo6jr7W9AUuJmU?=
 =?us-ascii?Q?+NHytCPjj+UZQnDRGKYxPzNyquN8SjHQwjmelk16Ha3JVvO90Sr7XTZWUhGh?=
 =?us-ascii?Q?TF4o5PgseKAp+hsyPjiOkz3JREWC64xPh9M5jK3KRfuRdE1fgA7XsntrL2B/?=
 =?us-ascii?Q?/LMjKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580fc22e-b830-4733-4cf9-08db70cbc25f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 13:47:44.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVwPH1S2sRie9N/UeJYfpvnfS3tg7eNmIDOFoXWRdmQFcYhCtN8Co6Oh4XAOQZASte1Mcw+/JFeswejOXVmDS+PFWJa3hmsV2KUUwrNYL/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:24:04AM +0200, carlos.fernandez@technica-engineering.de wrote:
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> 
> According to 802.1AE standard, when ES and SC flags in TCI are zero, used
> SCI should be the current active SC_RX. Current kernel does not implement
> it and uses the header MAC address.
> 
> Without this patch, when ES = 0 (using a bridge or switch), header MAC
> will not fit the SCI and MACSec frames will be discarted.
> 
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> ---
>  drivers/net/macsec.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 3427993f94f7..ccecb7eb385c 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -256,16 +256,31 @@ static sci_t make_sci(const u8 *addr, __be16 port)
>  	return sci;
>  }
>  
> -static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present)
> +static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present,
> +		struct macsec_rxh_data *rxd)
>  {
> +	struct macsec_dev *macsec_device;
>  	sci_t sci;
>  
> -	if (sci_present)
> +	if (sci_present) {
>  		memcpy(&sci, hdr->secure_channel_id,
> -		       sizeof(hdr->secure_channel_id));
> -	else
> +			sizeof(hdr->secure_channel_id));
> +	} else if (0 == (hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))) {
> +		list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
> +			struct macsec_rx_sc *rx_sc;
> +			struct macsec_secy *secy = &macsec_device->secy;
> +
> +			for_each_rxsc(secy, rx_sc) {
> +				rx_sc = rx_sc ? macsec_rxsc_get(rx_sc) : NULL;
> +				if (rx_sc && rx_sc->active)
> +					return rx_sc->sci;
> +			}
> +			/* If not found, use MAC in hdr as default*/
> +			sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);

Hi Carlos,

sorry for the slow response.
And also for asking about this same topic a second time.

Does the list_for_each_entry_rcu() loop always iterate at least once,
if the else if condition is met?

If not, sci may be uninitialised when returned at the end of this function.

As reported by Smatch:

 .../macsec.c:284 macsec_frame_sci() error: uninitialized symbol 'sci'.

> +		}
> +	} else {
>  		sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
> -
> +	}
>  	return sci;
>  }
>  
> @@ -1150,11 +1165,12 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
>  
>  	macsec_skb_cb(skb)->has_sci = !!(hdr->tci_an & MACSEC_TCI_SC);
>  	macsec_skb_cb(skb)->assoc_num = hdr->tci_an & MACSEC_AN_MASK;
> -	sci = macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci);
>  
>  	rcu_read_lock();
>  	rxd = macsec_data_rcu(skb->dev);
>  
> +	sci = macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci, rxd);
> +
>  	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
>  		struct macsec_rx_sc *sc = find_rx_sc(&macsec->secy, sci);
>  
> -- 
> 2.34.1
> 
> 

