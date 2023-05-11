Return-Path: <netdev+bounces-1737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E0176FF06B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 549BB28150E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68CF218C09;
	Thu, 11 May 2023 11:12:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576D41C778
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:12:26 +0000 (UTC)
Received: from out-11.mta0.migadu.com (out-11.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2043C39
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:12:24 -0700 (PDT)
Message-ID: <e479b601-a242-8ef2-ade4-3fe477a196fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1683803542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpMU1L/ltQCbFZG1aIzs50WiQtXN7XY9mxlobSY1w3s=;
	b=HAmKIeUoXdI6F9R3/45cC+qrpCOLooDdJYtdAIUBehkcjE9whC4A3l3jt4I75H4MTfnUDN
	4F24Pt+OIzhwYGJLxqvYSccS9B/acHzN81rqy4XqqrmLwELF+xHGt3f5znzND5kbe4rhUw
	l8UFnuQTCEzVZqnLctEGvtTHIUWM1VI=
Date: Thu, 11 May 2023 12:12:20 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net-next 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info
 callback
Content-Language: en-US
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>, netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>, Gal Pressman <gal@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Richard Cochran
 <richardcochran@gmail.com>, Jacob Keller <jacob.e.keller@intel.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-10-rrameshbabu@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230510205306.136766-10-rrameshbabu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10/05/2023 21:53, Rahul Rameshbabu wrote:
> Add a function that advertises a maximum offset of zero supported by
> ptp_clock_info .adjphase in the OCP null ptp implementation.
>
> Cc: Richard Cochran <richardcochran@gmail.com> > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>

Neither Jonathan, nor myself are in the actual Cc list.

> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> ---
>   drivers/ptp/ptp_ocp.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index ab8cab4d1560..20a974ced8d6 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -1124,6 +1124,12 @@ ptp_ocp_null_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
>   	return -EOPNOTSUPP;
>   }
>   
> +static s32
> +ptp_ocp_null_getmaxphase(struct ptp_clock_info *ptp_info)
> +{
> +	return 0;
> +}
> +
>   static int
>   ptp_ocp_null_adjphase(struct ptp_clock_info *ptp_info, s32 phase_ns)
>   {
> @@ -1239,6 +1245,7 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
>   	.adjtime	= ptp_ocp_adjtime,
>   	.adjfine	= ptp_ocp_null_adjfine,
>   	.adjphase	= ptp_ocp_null_adjphase,
> +	.getmaxphase	= ptp_ocp_null_getmaxphase,
>   	.enable		= ptp_ocp_enable,
>   	.verify		= ptp_ocp_verify,
>   	.pps		= true,

Acked-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>

