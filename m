Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECE6374B6B
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhEEWn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhEEWnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:43:53 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB733C061763
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 15:42:54 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z14so3102509ioc.12
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 15:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZblBVntBu4kzepDuyzv4aax5GowXgp9n8cFAbEt9+lk=;
        b=RPvCc6nCgTrSqCFNGq+3y5bj0pm32MI/YbgzYBIIkctoLehFvXQWhmU+8J8DzO3fhw
         UPxnd/0z3gJRBg91rPVC8hmoAHJG+MbekynkVTlNpS9Bwr/FqlmHkauGESUxhqcgPKYZ
         y6sRJubTLY8xALkL3lrzJsqKldIxkRNYaNpVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZblBVntBu4kzepDuyzv4aax5GowXgp9n8cFAbEt9+lk=;
        b=AipSd+MdCkBWVFduQCy87Kl7E9ydlTR/g8cLAYIVPUHuXfSZAfILnlhnhjTvNqfMyJ
         qAK48LFz02kSI0mpEEBAc357B6FOGjVzmBVXosnw8oinQj/Q5vcjZ7cAg037VwVr/KUG
         aCMFCC6hcm2S/akEKl4ggX9CWi0TQpUOTwuEwuzpvNbSyGmDJ9QZfuLiSzEYa+UQ5aes
         IM6rWbJSGzZYNtFkg7SlMuzIfG+L8ZLxqqQiuFYF+AxVgwQNEL/R1a1ffptkNYiFVLi9
         s3U74gofRTY7RGZSV1+s2ZZR22fzHG9tbRrPpnz9F+kuGYuB/FRCra/lARispOX5DouJ
         ARxQ==
X-Gm-Message-State: AOAM533TNVatgaw4jtcxEWBuMZgpN9Hj7yMzx9wJw5/tFiveCkuvJf2u
        2lYzebC9KbSmZYRtSQuqXAdlJg==
X-Google-Smtp-Source: ABdhPJx+gXh34O3I38YGi+vI9phwWnXAG24eQWTGziMPVpCIlnkmVpi0glI2gCIYZF6COhQHP6ACaw==
X-Received: by 2002:a6b:7413:: with SMTP id s19mr667141iog.151.1620254574394;
        Wed, 05 May 2021 15:42:54 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o15sm268894ioh.13.2021.05.05.15.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 15:42:53 -0700 (PDT)
Subject: Re: [PATCH v1 4/7] net: ipa: gsi: Use right masks for GSI v1.0
 channels hw param
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-5-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <2b4d50e1-7530-a905-99bc-ce7f4f62344e@ieee.org>
Date:   Wed, 5 May 2021 17:42:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-5-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> In GSI v1.0 the register GSI_HW_PARAM_2_OFFSET has different layout
> so the number of channels and events per EE are, of course, laid out
> in 8 bits each (0-7, 8-15 respectively).

This is actually wrong.  The fields you are fetching here
define the total number of channels (events) supported by
the IPA hardware, not the number of channels (events) per EE.

The fields we want are in the HW_PARAM_2 register, which
is not present until IPA v3.5.1.

As you did with the FLAVOR_0 register in an earlier patch,
I will update the code so the HW_PARAM_2 register is not
read unless it's defined, and will just skip these validity
checks on the endpoint configuration in that case.  We'll
just assume the hardware supports the maximum number of
channels and endpoints supported by the driver if we don't
know otherwise.

					-Alex

> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>   drivers/net/ipa/gsi.c     | 16 +++++++++++++---
>   drivers/net/ipa/gsi_reg.h |  5 +++++
>   2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index b5460cbb085c..3311ffe514c9 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1790,7 +1790,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
>   int gsi_setup(struct gsi *gsi)
>   {
>   	struct device *dev = gsi->dev;
> -	u32 val;
> +	u32 val, mask;
>   	int ret;
>   
>   	/* Here is where we first touch the GSI hardware */
> @@ -1804,7 +1804,12 @@ int gsi_setup(struct gsi *gsi)
>   
>   	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
>   
> -	gsi->channel_count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
> +	if (gsi->version == IPA_VERSION_3_1)
> +		mask = GSIV1_NUM_CH_PER_EE_FMASK;
> +	else
> +		mask = NUM_CH_PER_EE_FMASK;
> +
> +	gsi->channel_count = u32_get_bits(val, mask);
>   	if (!gsi->channel_count) {
>   		dev_err(dev, "GSI reports zero channels supported\n");
>   		return -EINVAL;
> @@ -1816,7 +1821,12 @@ int gsi_setup(struct gsi *gsi)
>   		gsi->channel_count = GSI_CHANNEL_COUNT_MAX;
>   	}
>   
> -	gsi->evt_ring_count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
> +	if (gsi->version == IPA_VERSION_3_1)
> +		mask = GSIV1_NUM_EV_PER_EE_FMASK;
> +	else
> +		mask = NUM_EV_PER_EE_FMASK;
> +
> +	gsi->evt_ring_count = u32_get_bits(val, mask);
>   	if (!gsi->evt_ring_count) {
>   		dev_err(dev, "GSI reports zero event rings supported\n");
>   		return -EINVAL;
> diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
> index 0e138bbd8205..4ba579fa21c2 100644
> --- a/drivers/net/ipa/gsi_reg.h
> +++ b/drivers/net/ipa/gsi_reg.h
> @@ -287,6 +287,11 @@ enum gsi_generic_cmd_opcode {
>   			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
>   #define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
>   			(0x0001f040 + 0x4000 * (ee))
> +
> +/* Fields below are present for IPA v3.1 with GSI version 1 */
> +#define GSIV1_NUM_EV_PER_EE_FMASK	GENMASK(8, 0)
> +#define GSIV1_NUM_CH_PER_EE_FMASK	GENMASK(15, 8)
> +/* Fields below are present for IPA v3.5.1 and above */
>   #define IRAM_SIZE_FMASK			GENMASK(2, 0)
>   #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
>   #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
> 

