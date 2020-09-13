Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD69B267D40
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 04:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgIMCab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 22:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgIMCaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 22:30:30 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF76C061574
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:30:29 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g10so11747570otq.9
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RyfFJ70RkJHTOwuSGlCdMHJ4aUWr+HPEs+MneGweLn0=;
        b=uTClnRFl+9+ZgioCXvlfQfYpetDGKRgeOfCkc4vQio8mjRr7M+btPQ4dEYUdhURMP9
         vqHc05e/ATHypAyrFISzZRkiQcbjN5CKUK951AG3CKBNj+FzgIBaHN+4QzasHWFsxV6U
         pvSCkmF1+v5UIzz7tdBMLNJVm1DDAkcqReRAzMEzKdCeAr7ZEWoJXhoH0vLRs2T0/xf/
         NsDqStNfnJNbkouHMx/u+3FXfuJLt8bTq+oWWIkgBr663YZDMMQ1L4ESDn5aOkzyF7im
         nKS8R7zCimbl/Qo9rP7ybQrBQN9Np7NdN5cx50yJ/iNBmmoabmikErhyh738sey9jreb
         bs3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RyfFJ70RkJHTOwuSGlCdMHJ4aUWr+HPEs+MneGweLn0=;
        b=sT2O32NacCUCNyRmRWKmB8mb4yPLg44Y1eSvvan6P99YmkGPuQG+GhwmtJvOcwhZYy
         epBMzmpRiGKy14xxOo7cs4KmXpXzUxGrins8hVYKTU81KEzbsQM+uHtvMo4I7b9VyimB
         QV45QXjEvmtPcRaQ7LYYLGCWKtP7hsO5zR9/fivuFkoS8Tliudb4ZHpGSW56dcazRNYL
         NQNNN46YFn0iB8Q+za1fLRfMcsUgug3CdH0or1JOfYsQ31B1jN6j6T4E+50pGjeENiUH
         L3OSlspSvZa8UtV6GLZgslsjy/q8z8g3kPCNdVn09rxwRqZag5/tG9lb8s94HHsOjNsw
         lMmQ==
X-Gm-Message-State: AOAM531LH2I3F+QsfQpb0vshegLrK8PFRZeWNQMuosPoqS5x4XPc7sww
        og64Lx97ac0wDSJQ7QH56vMvkQ==
X-Google-Smtp-Source: ABdhPJwe3Y2+VepqzhmG/T3I/I9H2R9jVyBfe9MN0wYhNUAZLo7SuwtjPVappmkHCr3bRSIHVJVa8g==
X-Received: by 2002:a9d:5eb:: with SMTP id 98mr5693925otd.317.1599964228964;
        Sat, 12 Sep 2020 19:30:28 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:8898:14ff:fe6d:34e])
        by smtp.gmail.com with ESMTPSA id a5sm1172516oti.30.2020.09.12.19.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 19:30:28 -0700 (PDT)
Date:   Sat, 12 Sep 2020 21:30:25 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/7] net: ipa: manage endpoints separate from
 clock
Message-ID: <20200913023025.GN3715@yoga>
References: <20200912004532.1386-1-elder@linaro.org>
 <20200912004532.1386-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912004532.1386-5-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 11 Sep 19:45 CDT 2020, Alex Elder wrote:

> Currently, when (before) the last IPA clock reference is dropped,
> all endpoints are suspended.  And whenever the first IPA clock
> reference is taken, all endpoints are resumed (or started).
> 
> In most cases there's no need to start endpoints when the clock
> starts.  So move the calls to ipa_endpoint_suspend() and
> ipa_endpoint_resume() out of ipa_clock_put() and ipa_clock_get(),
> respectiely.  Instead, only suspend endpoints when handling a system
> suspend, and only resume endpoints when handling a system resume.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_clock.c | 14 ++++----------
>  drivers/net/ipa/ipa_main.c  |  8 ++++++++
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
> index b703866f2e20b..a2c0fde058199 100644
> --- a/drivers/net/ipa/ipa_clock.c
> +++ b/drivers/net/ipa/ipa_clock.c
> @@ -200,9 +200,8 @@ bool ipa_clock_get_additional(struct ipa *ipa)
>  
>  /* Get an IPA clock reference.  If the reference count is non-zero, it is
>   * incremented and return is immediate.  Otherwise it is checked again
> - * under protection of the mutex, and if appropriate the clock (and
> - * interconnects) are enabled suspended endpoints (if any) are resumed
> - * before returning.
> + * under protection of the mutex, and if appropriate the IPA clock
> + * is enabled.
>   *
>   * Incrementing the reference count is intentionally deferred until
>   * after the clock is running and endpoints are resumed.
> @@ -229,17 +228,14 @@ void ipa_clock_get(struct ipa *ipa)
>  		goto out_mutex_unlock;
>  	}
>  
> -	ipa_endpoint_resume(ipa);
> -
>  	refcount_set(&clock->count, 1);
>  
>  out_mutex_unlock:
>  	mutex_unlock(&clock->mutex);
>  }
>  
> -/* Attempt to remove an IPA clock reference.  If this represents the last
> - * reference, suspend endpoints and disable the clock (and interconnects)
> - * under protection of a mutex.
> +/* Attempt to remove an IPA clock reference.  If this represents the
> + * last reference, disable the IPA clock under protection of the mutex.
>   */
>  void ipa_clock_put(struct ipa *ipa)
>  {
> @@ -249,8 +245,6 @@ void ipa_clock_put(struct ipa *ipa)
>  	if (!refcount_dec_and_mutex_lock(&clock->count, &clock->mutex))
>  		return;
>  
> -	ipa_endpoint_suspend(ipa);
> -
>  	ipa_clock_disable(ipa);
>  
>  	mutex_unlock(&clock->mutex);
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index cfdf60ded86ca..3b68b53c99015 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -913,11 +913,15 @@ static int ipa_remove(struct platform_device *pdev)
>   * Return:	Always returns zero
>   *
>   * Called by the PM framework when a system suspend operation is invoked.
> + * Suspends endpoints and releases the clock reference held to keep
> + * the IPA clock running until this point.
>   */
>  static int ipa_suspend(struct device *dev)
>  {
>  	struct ipa *ipa = dev_get_drvdata(dev);
>  
> +	ipa_endpoint_suspend(ipa);
> +
>  	ipa_clock_put(ipa);
>  	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>  		dev_err(dev, "suspend: missing suspend clock reference\n");
> @@ -932,6 +936,8 @@ static int ipa_suspend(struct device *dev)
>   * Return:	Always returns 0
>   *
>   * Called by the PM framework when a system resume operation is invoked.
> + * Takes an IPA clock reference to keep the clock running until suspend,
> + * and resumes endpoints.
>   */
>  static int ipa_resume(struct device *dev)
>  {
> @@ -945,6 +951,8 @@ static int ipa_resume(struct device *dev)
>  	else
>  		dev_err(dev, "resume: duplicate suspend clock reference\n");
>  
> +	ipa_endpoint_resume(ipa);
> +
>  	return 0;
>  }
>  
> -- 
> 2.20.1
> 
