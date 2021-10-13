Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287DD42CE16
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhJMWck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhJMWc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:32:27 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733EAC061760
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:30:23 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 5so1481438iov.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=om6YOAVXXWpB6pamQ8y6RrCPxfc0rizkjCSIZ1ulw8E=;
        b=bYpWdpaYWHfAhRSUkjygoKHcJwEaIv1sy/9yFdtQoABkWP8ycvOH7K+UMuPLilCLti
         +TMj8j6e2LM9B71rN24A/Nrt79t47E/Fq5emPVOnvZLOjMMe1vqtSMcRpJ50bOJMjYsi
         exk21WUyGGPxU40EJrFCzeTiW6nBsECCqu19U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=om6YOAVXXWpB6pamQ8y6RrCPxfc0rizkjCSIZ1ulw8E=;
        b=sXMARvwWJPDacaGxRSFk6Qmk+n1+YKcunPV0+v7Z0yd+LpH67vRqZ8ZzJ2xhwS+a7j
         uKSNFK4YYsU90Z735CaAQW/pXR/ofxCP4LCotcV4Wpeq29rBk3kRvkjNURRa4XgvYy1h
         JaKa4FHZGsSVm1KhYNqZtMdnHfWGVXeiputqUyUwwSaW4yHol+kIDQDBatXXaszUT2zu
         8G0Au1fnQauqtlVHGbx/njnvi8SnEjlQAF56Mtv+hpr16JmlTlnxmc/5g09GjCeEZwou
         Me2lDckD4BtcX+Rj/tFOpsD1fbv5zpSSPoJVRrYKFWzk8kt35biE/Gv3jGfGvIcCyDhi
         T7mw==
X-Gm-Message-State: AOAM530Hlu/4erYdgpdKWl+vf0b+5DUBu0erW4mIGs0kzSXvRoNfoOL6
        NDCEYbh1zvMVHOJ4JfGRygwxrA==
X-Google-Smtp-Source: ABdhPJzo2X0W2dXjdDTKMeIpBZWC4q+tny5IBNeFHVv7ZaK9cd4OcRVkUVdtLdVF2fypJXMSaUwIhA==
X-Received: by 2002:a02:cb94:: with SMTP id u20mr1453463jap.134.1634164222871;
        Wed, 13 Oct 2021 15:30:22 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i2sm378141ilv.63.2021.10.13.15.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:30:21 -0700 (PDT)
Subject: Re: [RFC PATCH 11/17] net: ipa: Add support for IPA v2.x endpoints
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-12-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <3f6c17a8-b901-c64f-2fbb-48faabccd255@ieee.org>
Date:   Wed, 13 Oct 2021 17:30:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-12-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> IPA v2.x endpoints are the same as the endpoints on later versions. The
> only big change was the addition of the "skip_config" flag. The only
> other change is the backlog limit, which is a fixed number for IPA v2.6L

Not much to say here.  Your patches are reasonably small, which
makes them easier to review (thank you).

					-Alex

> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>   drivers/net/ipa/ipa_endpoint.c | 65 ++++++++++++++++++++++------------
>   1 file changed, 43 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 7d3ab61cd890..024cf3a0ded0 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -360,8 +360,10 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
>   {
>   	u32 endpoint_id;
>   
> -	/* DELAY mode doesn't work correctly on IPA v4.2 */
> -	if (ipa->version == IPA_VERSION_4_2)
> +	/* DELAY mode doesn't work correctly on IPA v4.2
> +	 * Pausing is not supported on IPA v2.6L
> +	 */
> +	if (ipa->version == IPA_VERSION_4_2 || ipa->version <= IPA_VERSION_2_6L)
>   		return;
>   
>   	for (endpoint_id = 0; endpoint_id < IPA_ENDPOINT_MAX; endpoint_id++) {
> @@ -383,6 +385,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
>   {
>   	u32 initialized = ipa->initialized;
>   	struct ipa_trans *trans;
> +	u32 value = 0, value_mask = ~0;
>   	u32 count;
>   
>   	/* We need one command per modem TX endpoint.  We can get an upper
> @@ -398,6 +401,11 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
>   		return -EBUSY;
>   	}
>   
> +	if (ipa->version <= IPA_VERSION_2_6L) {
> +		value = aggr_force_close_fmask(true);
> +		value_mask = aggr_force_close_fmask(true);
> +	}
> +
>   	while (initialized) {
>   		u32 endpoint_id = __ffs(initialized);
>   		struct ipa_endpoint *endpoint;
> @@ -416,7 +424,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
>   		 * means status is disabled on the endpoint, and as a
>   		 * result all other fields in the register are ignored.
>   		 */
> -		ipa_cmd_register_write_add(trans, offset, 0, ~0, false);
> +		ipa_cmd_register_write_add(trans, offset, value, value_mask, false);
>   	}
>   
>   	ipa_cmd_pipeline_clear_add(trans);
> @@ -1531,8 +1539,10 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
>   	ipa_endpoint_init_mode(endpoint);
>   	ipa_endpoint_init_aggr(endpoint);
>   	ipa_endpoint_init_deaggr(endpoint);
> -	ipa_endpoint_init_rsrc_grp(endpoint);
> -	ipa_endpoint_init_seq(endpoint);
> +	if (endpoint->ipa->version > IPA_VERSION_2_6L) {
> +		ipa_endpoint_init_rsrc_grp(endpoint);
> +		ipa_endpoint_init_seq(endpoint);
> +	}
>   	ipa_endpoint_status(endpoint);
>   }
>   
> @@ -1592,7 +1602,6 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
>   {
>   	struct device *dev = &endpoint->ipa->pdev->dev;
>   	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
> -	bool stop_channel;
>   	int ret;
>   
>   	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
> @@ -1613,7 +1622,6 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
>   {
>   	struct device *dev = &endpoint->ipa->pdev->dev;
>   	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
> -	bool start_channel;
>   	int ret;
>   
>   	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
> @@ -1750,23 +1758,33 @@ int ipa_endpoint_config(struct ipa *ipa)
>   	/* Find out about the endpoints supplied by the hardware, and ensure
>   	 * the highest one doesn't exceed the number we support.
>   	 */
> -	val = ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
> -
> -	/* Our RX is an IPA producer */
> -	rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
> -	max = rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
> -	if (max > IPA_ENDPOINT_MAX) {
> -		dev_err(dev, "too many endpoints (%u > %u)\n",
> -			max, IPA_ENDPOINT_MAX);
> -		return -EINVAL;
> -	}
> -	rx_mask = GENMASK(max - 1, rx_base);
> +	if (ipa->version <= IPA_VERSION_2_6L) {
> +		// FIXME Not used anywhere?
> +		if (ipa->version == IPA_VERSION_2_6L)
> +			val = ioread32(ipa->reg_virt +
> +					IPA_REG_V2_ENABLED_PIPES_OFFSET);
> +		/* IPA v2.6L supports 20 pipes */
> +		ipa->available = ipa->filter_map;
> +		return 0;
> +	} else {
> +		val = ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
> +
> +		/* Our RX is an IPA producer */
> +		rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
> +		max = rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
> +		if (max > IPA_ENDPOINT_MAX) {
> +			dev_err(dev, "too many endpoints (%u > %u)\n",
> +					max, IPA_ENDPOINT_MAX);
> +			return -EINVAL;
> +		}
> +		rx_mask = GENMASK(max - 1, rx_base);
>   
> -	/* Our TX is an IPA consumer */
> -	max = u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
> -	tx_mask = GENMASK(max - 1, 0);
> +		/* Our TX is an IPA consumer */
> +		max = u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
> +		tx_mask = GENMASK(max - 1, 0);
>   
> -	ipa->available = rx_mask | tx_mask;
> +		ipa->available = rx_mask | tx_mask;
> +	}
>   
>   	/* Check for initialized endpoints not supported by the hardware */
>   	if (ipa->initialized & ~ipa->available) {
> @@ -1865,6 +1883,9 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
>   			filter_map |= BIT(data->endpoint_id);
>   	}
>   
> +	if (ipa->version <= IPA_VERSION_2_6L)
> +		filter_map = 0x1fffff;
> +
>   	if (!ipa_filter_map_valid(ipa, filter_map))
>   		goto err_endpoint_exit;
>   
> 

