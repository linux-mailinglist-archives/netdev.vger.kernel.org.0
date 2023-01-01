Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F260365AAFA
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 19:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjAAScj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 13:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjAASch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 13:32:37 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D139126E4
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 10:32:31 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id m15so14853724ilq.2
        for <netdev@vger.kernel.org>; Sun, 01 Jan 2023 10:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zV+r8U+uyILbJMrsnc8nz4otj7n7TRZfcA159F36ua8=;
        b=aiOdnmjLVqsJa494JxM/Z8J/2spEVF+y1wt2A6OzAuUccZOkKsyAAwpqxxAxNReF8F
         PpLvjst6s5Hu5V6DloGawRphoxOKOeMeEftlJKALLfENcUsLNTzv1HBNMoDou+WKbP8r
         d0dStqr7e6BwVcKgMDQ7PR32V3/wly+iAWkF07eKcEtKSEfNJ/av5fVyU/7qlLHMw55d
         dwgQo34Ur9NRAzPgJ5Gj2InhtxI37NA6/DVgZY0rcWZMts8WtBG3Yk3OcUhHWTIMqUF2
         aLISP92WT8/+hFmxk/rNdvTSN4wM3rFlp9/S48d7/4Rz/zFpZPDcr4am0tvnfBEK4qCt
         DOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zV+r8U+uyILbJMrsnc8nz4otj7n7TRZfcA159F36ua8=;
        b=KmCuFXF2rR5BAGvsod/y462Egnuai2NuZFC8WaHyiSFnKYYA9Dzymo/1IfRdq/PwpY
         h4tz9J1YkoSX4SWsZdGx77jP4cQE4XlEvALk1gtXqzzJ6rShJQ7RNOYLShrPUgPkztig
         KmdaJXRUxESj2EdVjxcWUj75icc5nXUzuWUlUebviXgLyF98/iEr5mqFyuWG1VxM9BdX
         FKZsoFteLuryw4iogtYq0bWVHvXdwgaThUmjj6/3Pv71QFI2SH+U279IwlUFwfM1F7J8
         EOfibanTG4x/5vQj6DwRozWtvqGEsdXI7Ig6oN1cVJwdAGfrJEnf1RHfLfh51X9ozjeW
         BOcA==
X-Gm-Message-State: AFqh2kpSQDUKapEYsUkjcMWCQMroi4aYxv7BNKXlMLpVQ6mRGOjpSv0n
        YBMrJfDcE1TAsTgr8zeolb58Gg==
X-Google-Smtp-Source: AMrXdXu3PUHcbQ8d34A3Ed8p9psE9dXPNA/g4KLrkXYa48KE1al5SdgEZcdJFfcxboCozxbiYrW4eg==
X-Received: by 2002:a05:6e02:525:b0:30c:2bb4:a2ea with SMTP id h5-20020a056e02052500b0030c2bb4a2eamr7454639ils.13.1672597950897;
        Sun, 01 Jan 2023 10:32:30 -0800 (PST)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id x2-20020a92d642000000b0030c053fb7ccsm5797894ilp.47.2023.01.01.10.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 10:32:30 -0800 (PST)
Message-ID: <c0e789a5-4573-1487-f279-4e2a447e3937@linaro.org>
Date:   Sun, 1 Jan 2023 12:32:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 3/6] net: ipa: enable IPA interrupt handlers
 separate from registration
To:     Caleb Connolly <caleb.connolly@linaro.org>,
        Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221230232230.2348757-1-elder@linaro.org>
 <20221230232230.2348757-4-elder@linaro.org>
 <de723e81-f3ba-19f3-827f-28134e904c97@linaro.org>
Content-Language: en-US
From:   Alex Elder <alex.elder@linaro.org>
In-Reply-To: <de723e81-f3ba-19f3-827f-28134e904c97@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/22 11:56 AM, Caleb Connolly wrote:
> 
> 
> On 30/12/2022 23:22, Alex Elder wrote:
>> Expose ipa_interrupt_enable() and have functions that register
>> IPA interrupt handlers enable them directly, rather than having the
>> registration process do that.  Do the same for disabling IPA
>> interrupt handlers.
> 
> Hi,
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/ipa_interrupt.c |  8 ++------
>>   drivers/net/ipa/ipa_interrupt.h | 14 ++++++++++++++
>>   drivers/net/ipa/ipa_power.c     |  6 +++++-
>>   drivers/net/ipa/ipa_uc.c        |  4 ++++
>>   4 files changed, 25 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_interrupt.c 
>> b/drivers/net/ipa/ipa_interrupt.c
>> index 7b7388c14806f..87f4b94d02a3f 100644
>> --- a/drivers/net/ipa/ipa_interrupt.c
>> +++ b/drivers/net/ipa/ipa_interrupt.c
>> @@ -135,7 +135,7 @@ static void ipa_interrupt_enabled_update(struct 
>> ipa *ipa)
>>   }
>>   /* Enable an IPA interrupt type */
>> -static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id 
>> ipa_irq)
>> +void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
>>   {
>>       /* Update the IPA interrupt mask to enable it */
>>       ipa->interrupt->enabled |= BIT(ipa_irq);
>> @@ -143,7 +143,7 @@ static void ipa_interrupt_enable(struct ipa *ipa, 
>> enum ipa_irq_id ipa_irq)
>>   }
>>   /* Disable an IPA interrupt type */
>> -static void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id 
>> ipa_irq)
>> +void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
>>   {
>>       /* Update the IPA interrupt mask to disable it */
>>       ipa->interrupt->enabled &= ~BIT(ipa_irq);
>> @@ -232,8 +232,6 @@ void ipa_interrupt_add(struct ipa_interrupt 
>> *interrupt,
>>           return;
>>       interrupt->handler[ipa_irq] = handler;
>> -
>> -    ipa_interrupt_enable(interrupt->ipa, ipa_irq);
>>   }
>>   /* Remove the handler for an IPA interrupt type */
>> @@ -243,8 +241,6 @@ ipa_interrupt_remove(struct ipa_interrupt 
>> *interrupt, enum ipa_irq_id ipa_irq)
>>       if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
>>           return;
>> -    ipa_interrupt_disable(interrupt->ipa, ipa_irq);
>> -
>>       interrupt->handler[ipa_irq] = NULL;
>>   }
>> diff --git a/drivers/net/ipa/ipa_interrupt.h 
>> b/drivers/net/ipa/ipa_interrupt.h
>> index f31fd9965fdc6..5f7d2e90ea337 100644
>> --- a/drivers/net/ipa/ipa_interrupt.h
>> +++ b/drivers/net/ipa/ipa_interrupt.h
>> @@ -85,6 +85,20 @@ void ipa_interrupt_suspend_clear_all(struct 
>> ipa_interrupt *interrupt);
>>    */
>>   void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
>> +/**
>> + * ipa_interrupt_enable() - Enable an IPA interrupt type
>> + * @ipa:    IPA pointer
>> + * @ipa_irq:    IPA interrupt ID
>> + */
>> +void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
> 
> I think you forgot a forward declaration for enum ipa_irq_id

Thanks, I'll verify this and will send v2 with a fix once
net-next is open for business again.

					-Alex

> 
> Kind Regards,
> Caleb
>> +
>> +/**
>> + * ipa_interrupt_disable() - Disable an IPA interrupt type
>> + * @ipa:    IPA pointer
>> + * @ipa_irq:    IPA interrupt ID
>> + */
>> +void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
>> +
>>   /**
>>    * ipa_interrupt_config() - Configure the IPA interrupt framework
>>    * @ipa:    IPA pointer
>> diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
>> index 8420f93128a26..9148d606d5fc2 100644
>> --- a/drivers/net/ipa/ipa_power.c
>> +++ b/drivers/net/ipa/ipa_power.c
>> @@ -337,10 +337,13 @@ int ipa_power_setup(struct ipa *ipa)
>>       ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
>>                 ipa_suspend_handler);
>> +    ipa_interrupt_enable(ipa, IPA_IRQ_TX_SUSPEND);
>>       ret = device_init_wakeup(&ipa->pdev->dev, true);
>> -    if (ret)
>> +    if (ret) {
>> +        ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
>>           ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
>> +    }
>>       return ret;
>>   }
>> @@ -348,6 +351,7 @@ int ipa_power_setup(struct ipa *ipa)
>>   void ipa_power_teardown(struct ipa *ipa)
>>   {
>>       (void)device_init_wakeup(&ipa->pdev->dev, false);
>> +    ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
>>       ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
>>   }
>> diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
>> index 0a890b44c09e1..af541758d047f 100644
>> --- a/drivers/net/ipa/ipa_uc.c
>> +++ b/drivers/net/ipa/ipa_uc.c
>> @@ -187,7 +187,9 @@ void ipa_uc_config(struct ipa *ipa)
>>       ipa->uc_powered = false;
>>       ipa->uc_loaded = false;
>>       ipa_interrupt_add(interrupt, IPA_IRQ_UC_0, 
>> ipa_uc_interrupt_handler);
>> +    ipa_interrupt_enable(ipa, IPA_IRQ_UC_0);
>>       ipa_interrupt_add(interrupt, IPA_IRQ_UC_1, 
>> ipa_uc_interrupt_handler);
>> +    ipa_interrupt_enable(ipa, IPA_IRQ_UC_1);
>>   }
>>   /* Inverse of ipa_uc_config() */
>> @@ -195,7 +197,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
>>   {
>>       struct device *dev = &ipa->pdev->dev;
>> +    ipa_interrupt_disable(ipa, IPA_IRQ_UC_1);
>>       ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
>> +    ipa_interrupt_disable(ipa, IPA_IRQ_UC_0);
>>       ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
>>       if (ipa->uc_loaded)
>>           ipa_power_retention(ipa, false);

