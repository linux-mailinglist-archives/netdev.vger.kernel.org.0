Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06A74A53A3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiBAAB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiBAAB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:01:57 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C64FC06173B
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 16:01:57 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id t199so13413471oie.10
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 16:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+K0sdjVgE8b9JIGeLK3zlSmhetjfYt5wptsU1dduQWU=;
        b=vMrk+bnZ3dHQtvC3W1oFNPjflb9kzhUMAjufeAZHnmI7Vu88S7YF2E87jHe2UZioQG
         +1Uq7x27YbAYEQx0kOQ2AoCRXUd0saUKkNoUQKgBEoICHSt74sgMlyR2gIli/sTnhfkK
         yn/n2XfTovcIfL5IY51W3xI6IYeYMnuq2slatW0xeBYGxO0LN2IxYbKLQJxx3jsYFwvD
         ImAWteHOjgYyw0eSevIgYFoZ+4CZB/mznEkRYASUCcBpiDb+x6CWi/EXCIt3p8o3CzEl
         9WM+v6aCSfXChHlK0xD/G6h9OwxM57RN90jo9ESdQpNredzL65By4Q1WgDJEc/7Hp8OL
         bjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+K0sdjVgE8b9JIGeLK3zlSmhetjfYt5wptsU1dduQWU=;
        b=Ivfa/xxLENBrm9H6t+5u1BMvfYt44zwwD/x38e6NxOOFM0l79LbZnjn8hZq4rqsCum
         wxB64kk/fuuoFHf7EY7xhODLVrtoL3oBmjqPbJCzRNJ7vxxAjy0YzYrCIB+5OlJv5jEf
         VLa+9PdZTXs+PnArvJzFs802sNz7jv5a0E072COTa0wMvJ3drWHfJ+8Z5wwDbNXubIym
         hTK27wnedHFgp9kYqT/8XIMYJhxmE16rUD9iMhZoCspuypNghT13wkTmrr0M1uMeOcyU
         1rGp+7XBfVOxTMF0Ks5RZusei36UxkbXuLQM1+gvUVyYTGr/HGV6jWLLmFfuK+uPqBf5
         pDzQ==
X-Gm-Message-State: AOAM533rgYC9LPYS4U5b4RgGsuqxEIAddzZcqbHnxgEVu6nISoWa0CN8
        NL6P/nhFkRhJ6YGEMZCzHK1AHg==
X-Google-Smtp-Source: ABdhPJzO24VPxQcjAKmUBB3MG9Mw6uIY2nODDpPG6z75wv77dxIhSjmAeC92adM94ApCurJYxwtqQQ==
X-Received: by 2002:aca:5c04:: with SMTP id q4mr8221769oib.142.1643673716339;
        Mon, 31 Jan 2022 16:01:56 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id n4sm12533610otq.63.2022.01.31.16.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 16:01:55 -0800 (PST)
Date:   Mon, 31 Jan 2022 18:01:53 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 7/8] clk: qcom: gcc-sm8150: use runtime PM for the clock
 controller
Message-ID: <Yfh4cahRIdkY4KWg@builder.lan>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-8-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126221725.710167-8-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 26 Jan 16:17 CST 2022, Bhupesh Sharma wrote:

> On sm8150 emac clk registers are powered up by the GDSC power
> domain. Use runtime PM calls to make sure that required power domain is
> powered on while we access clock controller's registers.
> 

Typically the GCC registers need only "cx" enabled for us to much around
with its registers and I don't see you add any references to additional
resources, so can you please elaborate on how this affects the state of
the system to enable you to operate the emac registers?

Regards,
Bjorn

> Cc: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  drivers/clk/qcom/gcc-sm8150.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
> index ada755ad55f7..2e71afed81fd 100644
> --- a/drivers/clk/qcom/gcc-sm8150.c
> +++ b/drivers/clk/qcom/gcc-sm8150.c
> @@ -5,6 +5,7 @@
>  #include <linux/bitops.h>
>  #include <linux/err.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> @@ -3792,19 +3793,41 @@ static const struct of_device_id gcc_sm8150_match_table[] = {
>  };
>  MODULE_DEVICE_TABLE(of, gcc_sm8150_match_table);
>  
> +static void gcc_sm8150_pm_runtime_disable(void *data)
> +{
> +	pm_runtime_disable(data);
> +}
> +
>  static int gcc_sm8150_probe(struct platform_device *pdev)
>  {
>  	struct regmap *regmap;
> +	int ret;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = devm_add_action_or_reset(&pdev->dev, gcc_sm8150_pm_runtime_disable, &pdev->dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret)
> +		return ret;
>  
>  	regmap = qcom_cc_map(pdev, &gcc_sm8150_desc);
> -	if (IS_ERR(regmap))
> +	if (IS_ERR(regmap)) {
> +		pm_runtime_put(&pdev->dev);
>  		return PTR_ERR(regmap);
> +	}
>  
>  	/* Disable the GPLL0 active input to NPU and GPU via MISC registers */
>  	regmap_update_bits(regmap, 0x4d110, 0x3, 0x3);
>  	regmap_update_bits(regmap, 0x71028, 0x3, 0x3);
>  
> -	return qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
> +	ret = qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
> +
> +	pm_runtime_put(&pdev->dev);
> +
> +	return ret;
>  }
>  
>  static struct platform_driver gcc_sm8150_driver = {
> -- 
> 2.34.1
> 
