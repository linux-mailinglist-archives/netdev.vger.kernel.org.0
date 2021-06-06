Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEC339CC76
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 05:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhFFD1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 23:27:46 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:39742 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhFFD1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 23:27:45 -0400
Received: by mail-ot1-f54.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so12195343otu.6
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 20:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ni3eGvt+i+5aePMZevK8GoIbwGrBNouUTOTilLJGCcQ=;
        b=LZf9hwtjLmlD/EeoSYDYbj1A9ZyuAdhJaEjcMiUf+pLmtpvxN1dqbojhVk3jwiAB+T
         C3s/rZ/3IRkbA8x2zD4urLBe7zBpASZAnNkF/guex8VaxoqWGd1ijxIhBxeLW4hoiiX9
         f3Neg36W0u6VZgVicl3P951NMdw/+0SnHmokQRFpGQyQwH7JbvB2jjoFLL/UqOHel2Wd
         8n85WNYLu6Ih1fLoV2FzJz9eTL2lw6/Tq7gqdlj8OnFGRpgH0I/xyBObS2ra9sXppGYK
         ffEZOTLB1Sg6wgBhHclUaxFBQF7lYlWD3trE0dyApVz52/uEWr3GiKCIZF3MXwoDM05K
         +RnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ni3eGvt+i+5aePMZevK8GoIbwGrBNouUTOTilLJGCcQ=;
        b=aA2wAtu6oziIxtY5wDNiE4FfQIUFl2mSLeK7IqYqg+ZwsOVsihAAo2xatUpPygy4eY
         DcOwqkCdrHi5AlorY9cR6aeXr2RYEFhHF2+rlMZwEtFLKgV04laJgpa6571AIpHsresg
         Axsth4hB5pWeR8FNDcZyfCWxhJFx331f0TSmoK5BsinL6qmXWyL6VQKVFZ43qO9XQkcy
         qkQVHeav3eSw2xVYRRPQq1ZGfNBgeEUXHdpTRmJ7LAdbskDC1JH4ilW/Wr/35JzhhV3J
         aP0/ntHm3nraHjI7Z7Oc223OR27ROIBcaN3zVJTHRh3got5ULrIKcD57CVxlzGRNIhjB
         Hjzw==
X-Gm-Message-State: AOAM532RB59gLoeB4b/pkPW2R/mqVopb40AFFw4p641+Iy+5emq8Cdsr
        HEVtwetHPddCv4e6Gyb9FS1PTw==
X-Google-Smtp-Source: ABdhPJyRc/QyzvY3Swve80HRZpUbaVQo39xFAvWvcHetsyu19hof3cyxtGdvkdZZlNmzXkkX2BnMdg==
X-Received: by 2002:a9d:704b:: with SMTP id x11mr3397307otj.110.1622949887957;
        Sat, 05 Jun 2021 20:24:47 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id r5sm1539711otp.45.2021.06.05.20.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 20:24:47 -0700 (PDT)
Date:   Sat, 5 Jun 2021 22:24:45 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] net: stmmac: explicitly deassert GMAC_AHB_RESET
Message-ID: <YLw//XARgqNlRoTB@builder.lan>
References: <20210605173546.4102455-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605173546.4102455-1-mnhagan88@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 05 Jun 12:35 CDT 2021, Matthew Hagan wrote:

> We are currently assuming that GMAC_AHB_RESET will already be deasserted
> by the bootloader. However if this has not been done, probing of the GMAC
> will fail. To remedy this we must ensure GMAC_AHB_RESET has been deasserted
> prior to probing.
> 

Sounds good, just some small style comments below.

> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 7 +++++++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
>  include/linux/stmmac.h                                | 1 +
>  3 files changed, 15 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6d41dd6f9f7a..1e28058b65a8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -6840,6 +6840,13 @@ int stmmac_dvr_probe(struct device *device,
>  			reset_control_reset(priv->plat->stmmac_rst);
>  	}
>  
> +	if (priv->plat->stmmac_ahb_rst) {

You don't need this conditional, stmmac_ahb_rst will be NULL if not
specified and you can reset_control_deassert(NULL) without any problems.

> +		ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
> +		if (ret == -ENOTSUPP)
> +			dev_err(priv->device,
> +				"unable to bring out of ahb reset\n");

No need to wrap this line.

> +	}
> +
>  	/* Init MAC and get the capabilities */
>  	ret = stmmac_hw_init(priv);
>  	if (ret)
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 97a1fedcc9ac..d8ae58bdbbe3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -600,6 +600,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>  		goto error_hw_init;
>  	}
>  
> +	plat->stmmac_ahb_rst = devm_reset_control_get_optional_shared(
> +							&pdev->dev, "ahb");
> +	if (IS_ERR(plat->stmmac_ahb_rst)) {
> +		ret = plat->stmmac_ahb_rst;

You need a PTR_ERR() around the plat->stmmac_ahb_rst.

Regards,
Bjorn

> +		goto error_hw_init;
> +	}
> +
>  	return plat;
>  
>  error_hw_init:
> diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
> index e55a4807e3ea..9b6a64f3e3dc 100644
> --- a/include/linux/stmmac.h
> +++ b/include/linux/stmmac.h
> @@ -239,6 +239,7 @@ struct plat_stmmacenet_data {
>  	unsigned int mult_fact_100ns;
>  	s32 ptp_max_adj;
>  	struct reset_control *stmmac_rst;
> +	struct reset_control *stmmac_ahb_rst;
>  	struct stmmac_axi *axi;
>  	int has_gmac4;
>  	bool has_sun8i;
> -- 
> 2.26.3
> 
