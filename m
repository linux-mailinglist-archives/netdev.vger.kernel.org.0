Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72731267D3A
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 04:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgIMCZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 22:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgIMCZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 22:25:37 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001F9C061574
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:25:34 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a3so13825003oib.4
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p/7BbZO4jP2tfZZY7Neooz0uWfhCr96mkbyx0AZ9AMM=;
        b=R6EDGGBdM37/qbjNhqIeZ+MasGFt17PBkUrJz08abnUq0UXhYMWyPHOW2fbaVoWP0K
         h3Rpjidn432/Mgs50C6EgN+GU6XIwDDOaWvUu2aAhqOCq15JYxAJy3m94TvuapNNnHRQ
         c/HbQq1krrfD/U6U1khIUFhV1W4dXMiZAhKJhy5Pc/jGiKA59cSD6/HaE/vA4Pf/pkz5
         iSpadrPw5WSAXGWXILI0w6vI3Pvr/BNRsyCyIrr/ouOtWcMieffn8VVz7BCPonfuLLiI
         a8R9Tb68u7EQjK+3fwZruT/LoGGhc1fdjTOCv/JaRmB6M4g1alGUnAiwp8qAoEni7Rz2
         CETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p/7BbZO4jP2tfZZY7Neooz0uWfhCr96mkbyx0AZ9AMM=;
        b=MIbqfBhfEHNWHGMUhO1wLlYtIZXVjimbxz31dgUaoPFt8yXMyJ03GxItV8mLMPns6Y
         eRjQ++lhJPY4C6jWL6vgIYb3c7gtXgg/iRdiGJoazelpE/p18ifS08uYsQgu/y3pgHaP
         WMv4Q5U99Vte5dVgjbsFz7ABKOaKmbErSEttr/0kF4Z9ePr1bGYiXYBmKh2RDH1+btKH
         aN0CegvulL3XXcbGH6ocu1eH+pnOCg8NzrLfRF4uJqmX8uLq5RxDBVr1gKzyU4pAD/gt
         pIkgbwR1mjxCYhVR3xVeeh2Sho9ipi2gv7lkKWKHvATrIiutXWsqNjwruX4fXuPEqkZE
         gXXQ==
X-Gm-Message-State: AOAM5324WgcZisDPUF+H27JosW0bbqI5MdITFQVuYpM6jVGY+2yTCYrN
        8+WIO6uBk5fFD/i4jCzw3bL0bQ==
X-Google-Smtp-Source: ABdhPJyE6OEQZXMizfznLM/APL/Le/LALLu/t3wKay0N627tTEC+YOshL63FZMZUbCyfBchzqIkxOQ==
X-Received: by 2002:aca:5752:: with SMTP id l79mr4975154oib.86.1599963933759;
        Sat, 12 Sep 2020 19:25:33 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:8898:14ff:fe6d:34e])
        by smtp.gmail.com with ESMTPSA id i5sm136842otj.19.2020.09.12.19.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 19:25:32 -0700 (PDT)
Date:   Sat, 12 Sep 2020 21:25:30 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/7] net: ipa: verify reference flag values
Message-ID: <20200913022530.GL3715@yoga>
References: <20200912004532.1386-1-elder@linaro.org>
 <20200912004532.1386-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912004532.1386-4-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 11 Sep 19:45 CDT 2020, Alex Elder wrote:

> We take a single IPA clock reference to keep the clock running until
> we get a system suspend operation, and maintain a flag indicating
> whether that reference has been taken.  When a suspend request
> arrives, we drop that reference and clear the flag.
> 
> In most places we simply set or clear the extra-reference flag.
> Instead--primarily to catch coding errors--test the previous value
> of the flag and report an error in the event the previous value is
> unexpected.  And if the clock reference is already taken, don't take
> another.
> 
> In a couple of cases it's pretty clear atomic access is not
> necessary and an error should never be reported.  Report these
> anyway, conveying our surprise with an added exclamation point.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: Updated to operate on a bitmap bit rather than an atomic_t.
> 
>  drivers/net/ipa/ipa_main.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 409375b96eb8f..cfdf60ded86ca 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -83,6 +83,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
>  	/* Take a a single clock reference to prevent suspend.  All
>  	 * endpoints will be resumed as a result.  This reference will
>  	 * be dropped when we get a power management suspend request.
> +	 * The first call activates the clock; ignore any others.
>  	 */
>  	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>  		ipa_clock_get(ipa);
> @@ -502,14 +503,17 @@ static void ipa_resource_deconfig(struct ipa *ipa)
>   */
>  static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
>  {
> +	struct device *dev = &ipa->pdev->dev;
>  	int ret;
>  
>  	/* Get a clock reference to allow initialization.  This reference
>  	 * is held after initialization completes, and won't get dropped
>  	 * unless/until a system suspend request arrives.
>  	 */
> -	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
> -	ipa_clock_get(ipa);
> +	if (!__test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
> +		ipa_clock_get(ipa);
> +	else
> +		dev_err(dev, "suspend clock reference already taken!\n");
>  
>  	ipa_hardware_config(ipa);
>  
> @@ -544,7 +548,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
>  err_hardware_deconfig:
>  	ipa_hardware_deconfig(ipa);
>  	ipa_clock_put(ipa);
> -	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
> +	if (!__test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
> +		dev_err(dev, "suspend clock reference already dropped!\n");
>  
>  	return ret;
>  }
> @@ -562,7 +567,8 @@ static void ipa_deconfig(struct ipa *ipa)
>  	ipa_endpoint_deconfig(ipa);
>  	ipa_hardware_deconfig(ipa);
>  	ipa_clock_put(ipa);
> -	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
> +	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))

Doesn't this imply that we ran with the clocks disabled, which
presumably would have nasty side effects?

This seems like something that is worthy of more than just a simple
printout - which no one will actually read.  If you instead use a
WARN_ON() to highlight this at least some of the test environments out
there will pick it up and report it...

Regards,
Bjorn

> +		dev_err(&ipa->pdev->dev, "no suspend clock reference\n");
>  }
>  
>  static int ipa_firmware_load(struct device *dev)
> @@ -913,7 +919,8 @@ static int ipa_suspend(struct device *dev)
>  	struct ipa *ipa = dev_get_drvdata(dev);
>  
>  	ipa_clock_put(ipa);
> -	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
> +	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
> +		dev_err(dev, "suspend: missing suspend clock reference\n");
>  
>  	return 0;
>  }
> @@ -933,8 +940,10 @@ static int ipa_resume(struct device *dev)
>  	/* This clock reference will keep the IPA out of suspend
>  	 * until we get a power management suspend request.
>  	 */
> -	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
> -	ipa_clock_get(ipa);
> +	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
> +		ipa_clock_get(ipa);
> +	else
> +		dev_err(dev, "resume: duplicate suspend clock reference\n");
>  
>  	return 0;
>  }
> -- 
> 2.20.1
> 
