Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5D32A2DE
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837750AbhCBIdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349064AbhCBCL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:11:27 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49EDC0611C1
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 18:05:17 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id p16so20084932ioj.4
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 18:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F1s7N0juj9yvJxFuLQgWFIr4bGeoT/Cxs7pLQc/V9KA=;
        b=R8ran+vxPbhpy6XZ2hQ4TbmdIAohuiBwl15gR5iYXwk7B8avQbJS370Gey6OKJ5PXh
         Frdq3p8E0MEdpAQcNj+2K39GYpvOY6DsCcevBtVEp5R/IMD7/qsZQfmEA+nlFVC9Qyiy
         AhSVR1NPfFPJo+dc74FueikX/cYz0SLiJK1S4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F1s7N0juj9yvJxFuLQgWFIr4bGeoT/Cxs7pLQc/V9KA=;
        b=HAIPDAwqO30ezX0JKXNkTO5fxfn5FQ/ErDFxHFzSCSACgjfNjdRUBr0Wv3jYBCop/0
         Yvu/mPhmxU6KCWLz7QRR2+xNN3EcwkzpL42BCvsmmpGcGAzTGLid9FxAS7WQSgIphcIL
         FmwZj3Z36sMv9gvdawAF5fMQFtwpbs79cMkogY2rJwTz9l5fo8NHA7lDjPjs/OyWT0Ss
         8vnIKLr7LH8J8oGh11SHk6rccqw/+O/Fj8hS4jNicHxjh9lrTg7IjrmsFJWd/sMpoErZ
         xiV2XPJpG/5BfK5FW/FJTBDfuoY3+1Fgj4Y1DdfFQR4crej2H5wrYvzCt1wTJRnmrgP1
         QskQ==
X-Gm-Message-State: AOAM5318L+kphh2irkV8VaOpdkjaP1wgIjO+qsuEFrD3YtY+ySolPQdP
        jkbLlA+dANbOjGHYR5Qlwpg9lQ==
X-Google-Smtp-Source: ABdhPJxfuF9x4IXqHRKh0yIizTV1EoWuHbxiCdS9p956UncaPEJ/KEOH7JYQR7hTQGxYtatQHocbcw==
X-Received: by 2002:a05:6602:cc:: with SMTP id z12mr15603462ioe.190.1614650717132;
        Mon, 01 Mar 2021 18:05:17 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i12sm9987070ilk.46.2021.03.01.18.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 18:05:16 -0800 (PST)
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
Message-ID: <476ea450-16d6-6a8f-650b-0a9becbebce5@ieee.org>
Date:   Mon, 1 Mar 2021 20:05:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-5-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> In GSI v1.0 the register GSI_HW_PARAM_2_OFFSET has different layout
> so the number of channels and events per EE are, of course, laid out
> in 8 bits each (0-7, 8-15 respectively).
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>  drivers/net/ipa/gsi.c     | 16 +++++++++++++---
>  drivers/net/ipa/gsi_reg.h |  5 +++++
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index b5460cbb085c..3311ffe514c9 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1790,7 +1790,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
>  int gsi_setup(struct gsi *gsi)
>  {
>  	struct device *dev = gsi->dev;
> -	u32 val;
> +	u32 val, mask;
>  	int ret;
>  
>  	/* Here is where we first touch the GSI hardware */
> @@ -1804,7 +1804,12 @@ int gsi_setup(struct gsi *gsi)
>  
>  	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
>  
> -	gsi->channel_count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
> +	if (gsi->version == IPA_VERSION_3_1)
> +		mask = GSIV1_NUM_CH_PER_EE_FMASK;
> +	else
> +		mask = NUM_CH_PER_EE_FMASK;
> +
> +	gsi->channel_count = u32_get_bits(val, mask);

I have a different way of doing this, at least for
encoding, and I'd rather use a similar convention in
this case.  At some point it might become obvious
that "there's got to be a better way" and I might have
to consider something else, but for now I've been
doing what I describe below.

Anyway, what I'd ask for here is to create a a static
inline function in "ipa_reg.h" (or "gsi_reg.h") to
extract these values.  In this case it might look
like this:

static inline u32 num_ev_per_ee_get(enum ipa_version version,
				    u32 val)
{
        if (version == IPA_VERSION_3_0 || version == IPA_VERSION_3_1)
                return u32_get_bits(val, GENMASK(8, 0));

        return u32_get_bits(val, GENMASK(7, 3));
}

(I'm not sure if the above is correct for all versions...)

Then the caller would do:
	gsi->evt_ring_count = num_ev_per_ee_get(ipa->version, val);

I'd want the same general thing for the channel count.

					-Alex

>  	if (!gsi->channel_count) {
>  		dev_err(dev, "GSI reports zero channels supported\n");
>  		return -EINVAL;
> @@ -1816,7 +1821,12 @@ int gsi_setup(struct gsi *gsi)
>  		gsi->channel_count = GSI_CHANNEL_COUNT_MAX;
>  	}
>  
> -	gsi->evt_ring_count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
> +	if (gsi->version == IPA_VERSION_3_1)
> +		mask = GSIV1_NUM_EV_PER_EE_FMASK;
> +	else
> +		mask = NUM_EV_PER_EE_FMASK;
> +
> +	gsi->evt_ring_count = u32_get_bits(val, mask);
>  	if (!gsi->evt_ring_count) {
>  		dev_err(dev, "GSI reports zero event rings supported\n");
>  		return -EINVAL;
> diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
> index 0e138bbd8205..4ba579fa21c2 100644
> --- a/drivers/net/ipa/gsi_reg.h
> +++ b/drivers/net/ipa/gsi_reg.h
> @@ -287,6 +287,11 @@ enum gsi_generic_cmd_opcode {
>  			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
>  #define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
>  			(0x0001f040 + 0x4000 * (ee))
> +
> +/* Fields below are present for IPA v3.1 with GSI version 1 */
> +#define GSIV1_NUM_EV_PER_EE_FMASK	GENMASK(8, 0)
> +#define GSIV1_NUM_CH_PER_EE_FMASK	GENMASK(15, 8)
> +/* Fields below are present for IPA v3.5.1 and above */
>  #define IRAM_SIZE_FMASK			GENMASK(2, 0)
>  #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
>  #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
> 

