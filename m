Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE40866E6CC
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjAQTRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjAQTO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:14:28 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180E245BD0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:29:32 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id s26so7464389ioa.11
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HMrtgJKnhI/ormXYVzNRS9Z9VZtZsmZGqwovaZxKdJk=;
        b=F1g9pCETcINCyq9BnkNwEQ+FQjR8rVy6NdTK/2N5Ndo8DW3JIHQ9bkJ2oWf7SJVb/m
         tC0Hidb/eYR4Lq5Zdb8RRQaVYOCpqZLJHHAA3lqm8TwbuOcHPfwN3P4QZn3sS/W7IdU8
         aIhVWQiC4yp9GyCmFrzI14JiW4DDlhVgbgzlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMrtgJKnhI/ormXYVzNRS9Z9VZtZsmZGqwovaZxKdJk=;
        b=OSaRTK5VD2TOhGtQYlBCySYskSST3JQKSdHobxEpg0gRvoy54os0bFhGAT7PQm1CLc
         g6jUoMZ+XfUXSdal0sLxPoXpH0QLj+5pmHfnsEA0kg/rN2f8m62X5CSpZGW8kRbLAFv7
         lS92igEEw3B/jFyB6XZUGdCL206ynF6iLk2tVyWa/r7rRCp1tw7iWthFnmgEaWqrh7zh
         dM2AI4DGFYcOYnn1DfV73F8mz+Dw+X+JKGShbK5qxCHKbYi9YSB8z8psVYFpYL2FkhVJ
         Zasr/14VimLwIX+rX6UuVHp1gMZyEiwoAq45SAagJFNxL4lJuVX7IVAkS2smOOWHw9y2
         cIiw==
X-Gm-Message-State: AFqh2kp1HXtY5PATlsGwUggSvgR76g6KZCpLhXQp1tX+xU5qkDjD/8YR
        zA5gHvma9+DlZjlJRwzniPp47g==
X-Google-Smtp-Source: AMrXdXu+pHjdhDHGFvzPVh2j5Re+r4zGqvcFxNOffXgJooCvcZsXZMq1XEOz7inHCmgRkGN0d31Snw==
X-Received: by 2002:a5d:805a:0:b0:6bc:d714:520f with SMTP id b26-20020a5d805a000000b006bcd714520fmr3087300ior.15.1673980171994;
        Tue, 17 Jan 2023 10:29:31 -0800 (PST)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id 2-20020a921302000000b0030db0074f0asm6753856ilt.65.2023.01.17.10.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 10:29:31 -0800 (PST)
Message-ID: <a0b67646-c30d-c697-d291-61af4c8ec473@ieee.org>
Date:   Tue, 17 Jan 2023 12:29:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: ipa: disable ipa interrupt during suspend
Content-Language: en-US
To:     Caleb Connolly <caleb.connolly@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alex Elder <elder@linaro.org>, netdev@vger.kernel.org
References: <20230115175925.465918-1-caleb.connolly@linaro.org>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20230115175925.465918-1-caleb.connolly@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/23 11:59 AM, Caleb Connolly wrote:
> The IPA interrupt can fire when pm_runtime is disabled due to it racing
> with the PM suspend/resume code. This causes a splat in the interrupt
> handler when it tries to call pm_runtime_get().
> 
> Explicitly disable the interrupt in our ->suspend callback, and
> re-enable it in ->resume to avoid this. If there is an interrupt pending
> it will be handled after resuming. The interrupt is a wake_irq, as a
> result even when disabled if it fires it will cause the system to wake
> from suspend as well as cancel any suspend transition that may be in
> progress. If there is an interrupt pending, the ipa_isr_thread handler
> will be called after resuming.

Looks good to me.  Thanks!

Reviewed-by: Alex Elder <elder@linaro.org>

> 
> Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> ---
>   drivers/net/ipa/ipa_interrupt.c | 10 ++++++++++
>   drivers/net/ipa/ipa_interrupt.h | 16 ++++++++++++++++
>   drivers/net/ipa/ipa_power.c     | 17 +++++++++++++++++
>   3 files changed, 43 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
> index d458a35839cc..c1b3977e1ae4 100644
> --- a/drivers/net/ipa/ipa_interrupt.c
> +++ b/drivers/net/ipa/ipa_interrupt.c
> @@ -127,6 +127,16 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
>   	return IRQ_HANDLED;
>   }
>   
> +void ipa_interrupt_irq_disable(struct ipa *ipa)
> +{
> +	disable_irq(ipa->interrupt->irq);
> +}
> +
> +void ipa_interrupt_irq_enable(struct ipa *ipa)
> +{
> +	enable_irq(ipa->interrupt->irq);
> +}
> +
>   /* Common function used to enable/disable TX_SUSPEND for an endpoint */
>   static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
>   					  u32 endpoint_id, bool enable)
> diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
> index f31fd9965fdc..8a1bd5b89393 100644
> --- a/drivers/net/ipa/ipa_interrupt.h
> +++ b/drivers/net/ipa/ipa_interrupt.h
> @@ -85,6 +85,22 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
>    */
>   void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
>   
> +/**
> + * ipa_interrupt_irq_enable() - Enable IPA interrupts
> + * @ipa:	IPA pointer
> + *
> + * This enables the IPA interrupt line
> + */
> +void ipa_interrupt_irq_enable(struct ipa *ipa);
> +
> +/**
> + * ipa_interrupt_irq_disable() - Disable IPA interrupts
> + * @ipa:	IPA pointer
> + *
> + * This disables the IPA interrupt line
> + */
> +void ipa_interrupt_irq_disable(struct ipa *ipa);
> +
>   /**
>    * ipa_interrupt_config() - Configure the IPA interrupt framework
>    * @ipa:	IPA pointer
> diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
> index 8420f93128a2..8057be8cda80 100644
> --- a/drivers/net/ipa/ipa_power.c
> +++ b/drivers/net/ipa/ipa_power.c
> @@ -181,6 +181,17 @@ static int ipa_suspend(struct device *dev)
>   
>   	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
>   
> +	/* Increment the disable depth to ensure that the IRQ won't
> +	 * be re-enabled until the matching _enable call in
> +	 * ipa_resume(). We do this to ensure that the interrupt
> +	 * handler won't run whilst PM runtime is disabled.
> +	 *
> +	 * Note that disabling the IRQ is NOT the same as disabling
> +	 * irq wake. If wakeup is enabled for the IPA then the IRQ
> +	 * will still cause the system to wake up, see irq_set_irq_wake().
> +	 */
> +	ipa_interrupt_irq_disable(ipa);
> +
>   	return pm_runtime_force_suspend(dev);
>   }
>   
> @@ -193,6 +204,12 @@ static int ipa_resume(struct device *dev)
>   
>   	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
>   
> +	/* Now that PM runtime is enabled again it's safe
> +	 * to turn the IRQ back on and process any data
> +	 * that was received during suspend.
> +	 */
> +	ipa_interrupt_irq_enable(ipa);
> +
>   	return ret;
>   }
>   

