Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E25682CC2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjAaMk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjAaMk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:40:26 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AEF3AA9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:40:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m14so13607925wrg.13
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=km5bb+J2n8O2YGZgnVojQpP73/T1V6fvTyMDCssAh/Y=;
        b=evrjlELfBbDKVmmpYnV1gLNYkAtwsJZ5TwEcGsLVrsGBuV7xHO2nQXaB5p2FpknLaU
         ANTU+bkLM0a0XxgBxdcsyMbCFMwt61DxN1cgtPST1NmkJcEx/KL+b4cYlWFhYAjvgi7j
         0ehnfnJRi04fe+TdbllnZNxYxS98WLT9urj6BD2cNFD/zHyPh4DL2NkT8dtL6tBgv8Sb
         Caa1Ocu1U8Ur9/tzZAWC9zttXyPjL6z4XaQfrSjTfQz5fPb/tTpQYul7dHj0rQs5vh5B
         wGH6XcMac7vjml+JDQHP1yCbv50SK3Y0NWtvJsbWKa1dOGolOo0DKyn7u25g3G5p/UGT
         im4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=km5bb+J2n8O2YGZgnVojQpP73/T1V6fvTyMDCssAh/Y=;
        b=xjNAd6OAueq4uNriFJzCeOW/vqRu709NlInJzSBYrdkRaTSAxcRY5J4aa88NQJaDCN
         qn9FFgieoO/QGqsohrCQ2aweyg35kXD7JnfUHRD/N6Bd8nSaZIt5YTiTmMv3oISeqotL
         8XVktZT9WJGSuPXMDRbwcdyHQy08GLOSd7eBwhOsvw+Yn/EzZSKqgzgmZNwf8aEs4fyU
         VDn/F6hv2VPmFrUZIh09V7K76fxosRDcXgboiHmArqDYDLPRRtTx1qqh7T/a8yCzwjYU
         9A9AYoBV7QtmvV8dnoWhgGHWEwJS38YG1JaYZN6pCt9fOaLFGRteMr2QFccOw3kpFLIf
         4zzg==
X-Gm-Message-State: AFqh2krjU6yY//9RqjhGLBP/UzxGzVPD3HtWnzM82cm0hPY3xb8s1rne
        5HJ98Te+32ddsXUH7JPhqVxqsw==
X-Google-Smtp-Source: AMrXdXsK9hPuDm5YrvFlpCBOEcv36CNjIasOgd5xdB/1AiWzSTRRRNDTXialllYdQYIdLgfjcACl5A==
X-Received: by 2002:adf:e9d2:0:b0:2bd:dca8:a4b with SMTP id l18-20020adfe9d2000000b002bddca80a4bmr45525489wrn.63.1675168823731;
        Tue, 31 Jan 2023 04:40:23 -0800 (PST)
Received: from [192.168.0.30] (cpc76484-cwma10-2-0-cust274.7-3.cable.virginm.net. [82.31.201.19])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d4c8e000000b002bfc2d0eff0sm14538379wrs.47.2023.01.31.04.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 04:40:23 -0800 (PST)
Message-ID: <bc54d9ea-aaa5-eea6-a954-807b3451d070@linaro.org>
Date:   Tue, 31 Jan 2023 12:40:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net-next] net: ipa: use dev PM wakeirq handling
Content-Language: en-GB, en-US
To:     Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org
References: <20230127202758.2913612-1-caleb.connolly@linaro.org>
 <8deaed16-385b-6108-e971-0168df2b3c2f@linaro.org>
From:   Caleb Connolly <caleb.connolly@linaro.org>
Organization: Linaro
In-Reply-To: <8deaed16-385b-6108-e971-0168df2b3c2f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/23 13:47, Alex Elder wrote:
> On 1/27/23 2:27 PM, Caleb Connolly wrote:
>> Replace the enable_irq_wake() call with one to dev_pm_set_wake_irq()
>> instead. This will let the dev PM framework automatically manage the
>> the wakeup capability of the ipa IRQ and ensure that userspace requests
>> to enable/disable wakeup for the IPA via sysfs are respected.
>>
>> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> 
> Looks OK to me.  Can you say something about how you
> tested this, and what the result was?  Thanks.

Ah yeah. This was tested on the SDM845 (IPA 3.5.1) based SHIFT6mq in the 
UK with an EE SIM card.

All network connections were disabled except for mobile data which was 
configured using ModemManager. Then I set up a basic TCP server using 
netcat on a public IP address and connected to it from the device.

It is then possible to validate that the wakeirq fires and the interrupt 
is handled correctly by putting the device into s2idle sleep (echo mem > 
/sys/power/state) and typing some data into the server terminal.

Then I disabled the wakeup as follows and repeated the test to ensure 
that the device would no longer wake up on incoming data, and that the 
data was received when the device resumes.

echo disabled > /sys/devices/platform/soc\@0/1e40000.ipa/power/wakeup

> 
>                      -Alex
> 
>> ---
>>   drivers/net/ipa/ipa_interrupt.c | 10 ++++------
>>   1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_interrupt.c 
>> b/drivers/net/ipa/ipa_interrupt.c
>> index c19cd27ac852..9a1153e80a3a 100644
>> --- a/drivers/net/ipa/ipa_interrupt.c
>> +++ b/drivers/net/ipa/ipa_interrupt.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/types.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/pm_runtime.h>
>> +#include <linux/pm_wakeirq.h>
>>   #include "ipa.h"
>>   #include "ipa_reg.h"
>> @@ -269,9 +270,9 @@ struct ipa_interrupt *ipa_interrupt_config(struct 
>> ipa *ipa)
>>           goto err_kfree;
>>       }
>> -    ret = enable_irq_wake(irq);
>> +    ret = dev_pm_set_wake_irq(dev, irq);
>>       if (ret) {
>> -        dev_err(dev, "error %d enabling wakeup for \"ipa\" IRQ\n", ret);
>> +        dev_err(dev, "error %d registering \"ipa\" IRQ as wakeirq\n", 
>> ret);
>>           goto err_free_irq;
>>       }
>> @@ -289,11 +290,8 @@ struct ipa_interrupt *ipa_interrupt_config(struct 
>> ipa *ipa)
>>   void ipa_interrupt_deconfig(struct ipa_interrupt *interrupt)
>>   {
>>       struct device *dev = &interrupt->ipa->pdev->dev;
>> -    int ret;
>> -    ret = disable_irq_wake(interrupt->irq);
>> -    if (ret)
>> -        dev_err(dev, "error %d disabling \"ipa\" IRQ wakeup\n", ret);
>> +    dev_pm_clear_wake_irq(dev);
>>       free_irq(interrupt->irq, interrupt);
>>       kfree(interrupt);
>>   }
> 

-- 
--
Kind Regards,
Caleb (they/them)
