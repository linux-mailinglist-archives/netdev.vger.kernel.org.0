Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94182267D3D
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 04:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgIMC1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 22:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgIMC1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 22:27:48 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8380C061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:27:47 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m12so11805021otr.0
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Igw9WuKNupdMlRBuF7Wb0wSgQgABBH00mL0Cq833/Bc=;
        b=SFJuT56E8e6zZbjKtt7eTh+N0YMYw+6/TwRNECa75MahvOcJPcisXUk0HZiUGzgn3/
         wswKBUAF1TZ9lSeZBLY/aBheIoJD92GC44cdnqNZCTCUabMbrfYyz+LAi1OMyxZMxapg
         giB9jnMlmzynzRXNv+ffcdQGiigfgGit+pkT+0IbhNYWNes24oPN4yebpMS2ttjJwWsT
         Ia4x0KgrIzRb/Qk739tJWXTnIWVQ7/9NeH72MyJ8O+gI3YNoEUHhOjL2bzTbDKWvLmWs
         P+RD0jvMkqQPWh98Puo7xYzWOIwwU3Tpmx2HaVze55kmGIS9FJnGEzXA9wG3kHz+ExxN
         NrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Igw9WuKNupdMlRBuF7Wb0wSgQgABBH00mL0Cq833/Bc=;
        b=HsV3QIhgeo2dRCyRZbEJs1ZrVefeebJeHUBCawgrrIWXF9syikzjRlLt8LTtGN49lk
         44J5KKWkK5UjahmYWwt5smDjNpfOxDgEhj1eYujKJeS6oihwyAegP+/L/1537jwj8Bwv
         e5e5pAnB2wwDgBR7eQSw8gUbGOr26hD3YoetydCExk8vxcfKukGFdptTdPrEEytk4Rrd
         pLRZAt0JFhSNP1FRI1kp9cXhpuCe3sy+1EdH7iFZYxG2Ij51GpqX6GXlLZujWvJLTj9k
         fSUT0cadS38CjjF8xMWkqAVx7KZyAoRDNFt3328ZWxNl/iMFwXlR+mzck+Zc+86YdjyY
         ZJfg==
X-Gm-Message-State: AOAM530lMlieQ2X8mXgOJ+TIBd2L/8xJSfqhVNlaWb2/wXRP6ypBd55e
        MHVJKDlZKBBq6PUr38lkFlUCxw==
X-Google-Smtp-Source: ABdhPJwaSucnKopNCny30VU0nqn0HA6gP9/DoknVcDJSR2s/GB83hTk2osL0yioEpe+s10qLqDNrfg==
X-Received: by 2002:a9d:6e12:: with SMTP id e18mr5692740otr.273.1599964067041;
        Sat, 12 Sep 2020 19:27:47 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:8898:14ff:fe6d:34e])
        by smtp.gmail.com with ESMTPSA id i23sm1232459oos.17.2020.09.12.19.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 19:27:46 -0700 (PDT)
Date:   Sat, 12 Sep 2020 21:27:43 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/7] net: ipa: use device_init_wakeup()
Message-ID: <20200913022743.GM3715@yoga>
References: <20200912004532.1386-1-elder@linaro.org>
 <20200912004532.1386-6-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912004532.1386-6-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 11 Sep 19:45 CDT 2020, Alex Elder wrote:

> The call to wakeup_source_register() in ipa_probe() does not do what
> it was intended to do.  Call device_init_wakeup() in ipa_setup()
> instead, to set the IPA device as wakeup-capable and to initially
> enable wakeup capability.
> 
> When we receive a SUSPEND interrupt, call pm_wakeup_dev_event()
> with a zero processing time, to simply call for a resume without
> any other processing.  The ipa_resume() call will take care of
> waking things up again, and will handle receiving the packet.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa.h      |  2 --
>  drivers/net/ipa/ipa_main.c | 43 ++++++++++++++++----------------------
>  2 files changed, 18 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
> index e02fe979b645b..c688155ccf375 100644
> --- a/drivers/net/ipa/ipa.h
> +++ b/drivers/net/ipa/ipa.h
> @@ -114,8 +114,6 @@ struct ipa {
>  	void *zero_virt;
>  	size_t zero_size;
>  
> -	struct wakeup_source *wakeup_source;
> -
>  	/* Bit masks indicating endpoint state */
>  	u32 available;		/* supported by hardware */
>  	u32 filter_map;
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 3b68b53c99015..5e714d9d2e5cb 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -75,18 +75,19 @@
>   * @ipa:	IPA pointer
>   * @irq_id:	IPA interrupt type (unused)
>   *
> - * When in suspended state, the IPA can trigger a resume by sending a SUSPEND
> - * IPA interrupt.
> + * If an RX endpoint is in suspend state, and the IPA has a packet
> + * destined for that endpoint, the IPA generates a SUSPEND interrupt
> + * to inform the AP that it should resume the endpoint.  If we get
> + * one of these interrupts we just resume everything.
>   */
>  static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
>  {
> -	/* Take a a single clock reference to prevent suspend.  All
> -	 * endpoints will be resumed as a result.  This reference will
> -	 * be dropped when we get a power management suspend request.
> -	 * The first call activates the clock; ignore any others.
> +	/* Just report the event, and let system resume handle the rest.
> +	 * More than one endpoint could signal this; if so, ignore
> +	 * all but the first.
>  	 */
>  	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
> -		ipa_clock_get(ipa);
> +		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
>  
>  	/* Acknowledge/clear the suspend interrupt on all endpoints */
>  	ipa_interrupt_suspend_clear_all(ipa->interrupt);
> @@ -107,6 +108,7 @@ int ipa_setup(struct ipa *ipa)
>  {
>  	struct ipa_endpoint *exception_endpoint;
>  	struct ipa_endpoint *command_endpoint;
> +	struct device *dev = &ipa->pdev->dev;
>  	int ret;
>  
>  	/* Setup for IPA v3.5.1 has some slight differences */
> @@ -124,6 +126,10 @@ int ipa_setup(struct ipa *ipa)
>  
>  	ipa_uc_setup(ipa);
>  
> +	ret = device_init_wakeup(dev, true);
> +	if (ret)
> +		goto err_uc_teardown;
> +
>  	ipa_endpoint_setup(ipa);
>  
>  	/* We need to use the AP command TX endpoint to perform other
> @@ -159,7 +165,7 @@ int ipa_setup(struct ipa *ipa)
>  
>  	ipa->setup_complete = true;
>  
> -	dev_info(&ipa->pdev->dev, "IPA driver setup completed successfully\n");
> +	dev_info(dev, "IPA driver setup completed successfully\n");
>  
>  	return 0;
>  
> @@ -174,6 +180,8 @@ int ipa_setup(struct ipa *ipa)
>  	ipa_endpoint_disable_one(command_endpoint);
>  err_endpoint_teardown:
>  	ipa_endpoint_teardown(ipa);
> +	(void)device_init_wakeup(dev, false);
> +err_uc_teardown:
>  	ipa_uc_teardown(ipa);
>  	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
>  	ipa_interrupt_teardown(ipa->interrupt);
> @@ -201,6 +209,7 @@ static void ipa_teardown(struct ipa *ipa)
>  	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
>  	ipa_endpoint_disable_one(command_endpoint);
>  	ipa_endpoint_teardown(ipa);
> +	(void)device_init_wakeup(&ipa->pdev->dev, false);
>  	ipa_uc_teardown(ipa);
>  	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
>  	ipa_interrupt_teardown(ipa->interrupt);
> @@ -715,7 +724,6 @@ static void ipa_validate_build(void)
>   */
>  static int ipa_probe(struct platform_device *pdev)
>  {
> -	struct wakeup_source *wakeup_source;
>  	struct device *dev = &pdev->dev;
>  	const struct ipa_data *data;
>  	struct ipa_clock *clock;
> @@ -764,19 +772,11 @@ static int ipa_probe(struct platform_device *pdev)
>  		goto err_clock_exit;
>  	}
>  
> -	/* Create a wakeup source. */
> -	wakeup_source = wakeup_source_register(dev, "ipa");
> -	if (!wakeup_source) {
> -		/* The most likely reason for failure is memory exhaustion */
> -		ret = -ENOMEM;
> -		goto err_clock_exit;
> -	}
> -
>  	/* Allocate and initialize the IPA structure */
>  	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
>  	if (!ipa) {
>  		ret = -ENOMEM;
> -		goto err_wakeup_source_unregister;
> +		goto err_clock_exit;
>  	}
>  
>  	ipa->pdev = pdev;
> @@ -784,7 +784,6 @@ static int ipa_probe(struct platform_device *pdev)
>  	ipa->modem_rproc = rproc;
>  	ipa->clock = clock;
>  	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
> -	ipa->wakeup_source = wakeup_source;
>  	ipa->version = data->version;
>  
>  	ret = ipa_reg_init(ipa);
> @@ -863,8 +862,6 @@ static int ipa_probe(struct platform_device *pdev)
>  	ipa_reg_exit(ipa);
>  err_kfree_ipa:
>  	kfree(ipa);
> -err_wakeup_source_unregister:
> -	wakeup_source_unregister(wakeup_source);
>  err_clock_exit:
>  	ipa_clock_exit(clock);
>  err_rproc_put:
> @@ -878,11 +875,8 @@ static int ipa_remove(struct platform_device *pdev)
>  	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
>  	struct rproc *rproc = ipa->modem_rproc;
>  	struct ipa_clock *clock = ipa->clock;
> -	struct wakeup_source *wakeup_source;
>  	int ret;
>  
> -	wakeup_source = ipa->wakeup_source;
> -
>  	if (ipa->setup_complete) {
>  		ret = ipa_modem_stop(ipa);
>  		if (ret)
> @@ -899,7 +893,6 @@ static int ipa_remove(struct platform_device *pdev)
>  	ipa_mem_exit(ipa);
>  	ipa_reg_exit(ipa);
>  	kfree(ipa);
> -	wakeup_source_unregister(wakeup_source);
>  	ipa_clock_exit(clock);
>  	rproc_put(rproc);
>  
> -- 
> 2.20.1
> 
