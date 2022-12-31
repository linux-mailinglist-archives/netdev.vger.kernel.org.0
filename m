Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFF165A600
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 18:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiLaRyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 12:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLaRyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 12:54:20 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A534EDF3
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 09:54:19 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ja17so17570844wmb.3
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 09:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bstpBOOSd0DT3nc8s3SZIuNiRah6+MZ2rvRQNSJbqJs=;
        b=ajFc5K3t88by6XJm6IH40aReNT+PHPOtEzGSUV0Qh7eZbArNm55/uu+j5nOgxIaIVr
         lbYtsJSU68UMSqc8OXyI7KGEE5dGjh8u2TZwdpzyFjT+YbkpdflzCwm5ipJM00+uJre/
         y6oQpwlzYu1OHWWYiBuhm6NkyIc4hG+4xceEJVANqiuYkw+t75G5DbhV5guK/HfuLGjM
         IP+clM91zaYEVr6GomSGwAqNkXM/tkAclArOntJ7KwuObuBFEZrQLQPIa4p+Wsgmjvjb
         hgjKgep4bZNMxUPq5710YGkvdbmTKkeb5u+2dqTfEAFnHcBgSKCbMiQlVqtWrOhmZ412
         5/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bstpBOOSd0DT3nc8s3SZIuNiRah6+MZ2rvRQNSJbqJs=;
        b=K4iUs1O/7FiIzGfpMZNTdl+6r3qTaR0XxSYPSshZEUu51LGAm5WIzZpckfdTuJI2bb
         bBRAUMeHuQdWgS72vpvKQcDgg/wYL2zRATuIlWr92NsktxpBOcZuUctsLX7Irq1fTWZk
         QcLrinIFVVXuBookC/YbUI2LCErYbNCsEVlTImqi6JmiKMcJ51yzCU9tLCOjcxGO5esF
         fMdKPLzaFdhoTn9OCZBj9WSUQQ/9sYeOZ9umSwN3ngOYxPaoq3o1SLAsSkKkJe+tTCQU
         wvBU7mIZ7j52LL+xaNH/FUvfMlQB2V2mPtpimyecl6dKT8oT1Qb8l2hlVBamTpEj8bho
         Fegw==
X-Gm-Message-State: AFqh2krBrY7sc4N0ejymmOpySBC3AU3jy46XPc/LFO/QB0sowc4avUUr
        0bb9KbjXpEy+NcwWyvkZJwebiA==
X-Google-Smtp-Source: AMrXdXv1/1nMohXx+41x9jHD9YLT8il4N6q53avu52Mp+hqW9IBxXFQvYiGvRzCDmk04HbGlKX8yHQ==
X-Received: by 2002:a05:600c:1da3:b0:3d0:965f:63ed with SMTP id p35-20020a05600c1da300b003d0965f63edmr25492302wms.23.1672509258225;
        Sat, 31 Dec 2022 09:54:18 -0800 (PST)
Received: from [192.168.1.25] (host-92-24-101-87.as13285.net. [92.24.101.87])
        by smtp.gmail.com with ESMTPSA id o6-20020adfa106000000b002423620d356sm24249945wro.35.2022.12.31.09.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Dec 2022 09:54:17 -0800 (PST)
Message-ID: <de723e81-f3ba-19f3-827f-28134e904c97@linaro.org>
Date:   Sat, 31 Dec 2022 17:56:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH net-next 3/6] net: ipa: enable IPA interrupt handlers
 separate from registration
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221230232230.2348757-1-elder@linaro.org>
 <20221230232230.2348757-4-elder@linaro.org>
Content-Language: en-US
From:   Caleb Connolly <caleb.connolly@linaro.org>
In-Reply-To: <20221230232230.2348757-4-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/12/2022 23:22, Alex Elder wrote:
> Expose ipa_interrupt_enable() and have functions that register
> IPA interrupt handlers enable them directly, rather than having the
> registration process do that.  Do the same for disabling IPA
> interrupt handlers.

Hi,
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>   drivers/net/ipa/ipa_interrupt.c |  8 ++------
>   drivers/net/ipa/ipa_interrupt.h | 14 ++++++++++++++
>   drivers/net/ipa/ipa_power.c     |  6 +++++-
>   drivers/net/ipa/ipa_uc.c        |  4 ++++
>   4 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
> index 7b7388c14806f..87f4b94d02a3f 100644
> --- a/drivers/net/ipa/ipa_interrupt.c
> +++ b/drivers/net/ipa/ipa_interrupt.c
> @@ -135,7 +135,7 @@ static void ipa_interrupt_enabled_update(struct ipa *ipa)
>   }
>   
>   /* Enable an IPA interrupt type */
> -static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
> +void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
>   {
>   	/* Update the IPA interrupt mask to enable it */
>   	ipa->interrupt->enabled |= BIT(ipa_irq);
> @@ -143,7 +143,7 @@ static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
>   }
>   
>   /* Disable an IPA interrupt type */
> -static void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
> +void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
>   {
>   	/* Update the IPA interrupt mask to disable it */
>   	ipa->interrupt->enabled &= ~BIT(ipa_irq);
> @@ -232,8 +232,6 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
>   		return;
>   
>   	interrupt->handler[ipa_irq] = handler;
> -
> -	ipa_interrupt_enable(interrupt->ipa, ipa_irq);
>   }
>   
>   /* Remove the handler for an IPA interrupt type */
> @@ -243,8 +241,6 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
>   	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
>   		return;
>   
> -	ipa_interrupt_disable(interrupt->ipa, ipa_irq);
> -
>   	interrupt->handler[ipa_irq] = NULL;
>   }
>   
> diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
> index f31fd9965fdc6..5f7d2e90ea337 100644
> --- a/drivers/net/ipa/ipa_interrupt.h
> +++ b/drivers/net/ipa/ipa_interrupt.h
> @@ -85,6 +85,20 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
>    */
>   void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
>   
> +/**
> + * ipa_interrupt_enable() - Enable an IPA interrupt type
> + * @ipa:	IPA pointer
> + * @ipa_irq:	IPA interrupt ID
> + */
> +void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq);

I think you forgot a forward declaration for enum ipa_irq_id

Kind Regards,
Caleb
> +
> +/**
> + * ipa_interrupt_disable() - Disable an IPA interrupt type
> + * @ipa:	IPA pointer
> + * @ipa_irq:	IPA interrupt ID
> + */
> +void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
> +
>   /**
>    * ipa_interrupt_config() - Configure the IPA interrupt framework
>    * @ipa:	IPA pointer
> diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
> index 8420f93128a26..9148d606d5fc2 100644
> --- a/drivers/net/ipa/ipa_power.c
> +++ b/drivers/net/ipa/ipa_power.c
> @@ -337,10 +337,13 @@ int ipa_power_setup(struct ipa *ipa)
>   
>   	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
>   			  ipa_suspend_handler);
> +	ipa_interrupt_enable(ipa, IPA_IRQ_TX_SUSPEND);
>   
>   	ret = device_init_wakeup(&ipa->pdev->dev, true);
> -	if (ret)
> +	if (ret) {
> +		ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
>   		ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
> +	}
>   
>   	return ret;
>   }
> @@ -348,6 +351,7 @@ int ipa_power_setup(struct ipa *ipa)
>   void ipa_power_teardown(struct ipa *ipa)
>   {
>   	(void)device_init_wakeup(&ipa->pdev->dev, false);
> +	ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
>   	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
>   }
>   
> diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
> index 0a890b44c09e1..af541758d047f 100644
> --- a/drivers/net/ipa/ipa_uc.c
> +++ b/drivers/net/ipa/ipa_uc.c
> @@ -187,7 +187,9 @@ void ipa_uc_config(struct ipa *ipa)
>   	ipa->uc_powered = false;
>   	ipa->uc_loaded = false;
>   	ipa_interrupt_add(interrupt, IPA_IRQ_UC_0, ipa_uc_interrupt_handler);
> +	ipa_interrupt_enable(ipa, IPA_IRQ_UC_0);
>   	ipa_interrupt_add(interrupt, IPA_IRQ_UC_1, ipa_uc_interrupt_handler);
> +	ipa_interrupt_enable(ipa, IPA_IRQ_UC_1);
>   }
>   
>   /* Inverse of ipa_uc_config() */
> @@ -195,7 +197,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
>   {
>   	struct device *dev = &ipa->pdev->dev;
>   
> +	ipa_interrupt_disable(ipa, IPA_IRQ_UC_1);
>   	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
> +	ipa_interrupt_disable(ipa, IPA_IRQ_UC_0);
>   	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
>   	if (ipa->uc_loaded)
>   		ipa_power_retention(ipa, false);
