Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989FF267FAD
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 15:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgIMNgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 09:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgIMNgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 09:36:35 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12713C061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 06:36:27 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so15830330iol.10
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 06:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EV2DOP0ScNAYJC3DlvwyXv8gFVS0LLmJt4XZBhvSGBQ=;
        b=nsjWFSDNwgPGY5JxV8N7Ki9ye5VlofZ1n4AVHoRjpGIpr9gEqV5VNCXNkIersSZVeB
         l5weCnNPTO3i/Oby7KwZeslhVvX8QepIJgeTw1Cz3kpVAkTeCsdqdi+YVzMT1Fxlly3F
         xZH7vg6MYuYOFby9rjl4quFwIg24WJaNWcVxv1Ifx7H6ZHICiwdlNjEBg1cteJ5daWNF
         O1FhIEypUSnGMoAVtMbafcK6JQz2jPnn1QPrhmj4csh+ayAHzey4GRTSzVjJhd/udDSB
         fQemPtTx43/cK1Q3ZCtJGSxQ35tsdHeseBCvUxjwvRz1vAG/HrLEneAu+jkL8sCR/4nx
         kEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EV2DOP0ScNAYJC3DlvwyXv8gFVS0LLmJt4XZBhvSGBQ=;
        b=UIAA0jxQ6rdQNwsY2guTYmDPxoeld3VqXIhU+7HmH9bZ3wh9trjMJXd62MH/bMIxrd
         yJ/oB7fH2kJj8X+Oy4tRuTrok64MsZ6FYy53xM/Aigcx+tTKhg2SNiKRV9eXYMiU2YxJ
         vdx2Dm7zhcalMYHStPiDq3BYg/EaKrx2pLbemuRXOkVbwbeD6NgJaXeYkgOUg5+vOVlB
         n3NbkBTP/UmI/0b9fGbsxZ5sbwhFVvE/DMNKnWND9D1XDhNNcRJHxoJMsaem9UjY9wnY
         dgffUQQgseEtZeEzMBRUEDDnreamgrGAIJEOHDCYSOKEw/dIwr6EvU4kBjUvhOlEa2d6
         lFcA==
X-Gm-Message-State: AOAM532cntDI2mzAvSoBvQbnWHKbr3W7pMdSCTpeaAsXNYVb7Yev9lGn
        R1EaDtK7M/tyryte6fUClz2w1A==
X-Google-Smtp-Source: ABdhPJzU6azNfjiNzMhCR+ggeCl7F2nNB7bt8ZalTWnmZag7Ph76Amz+u5EWMZn9e4ytsKvLs7jDVA==
X-Received: by 2002:a5e:8e0a:: with SMTP id a10mr8117820ion.200.1600004186245;
        Sun, 13 Sep 2020 06:36:26 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k16sm4321857ioc.15.2020.09.13.06.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2020 06:36:25 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/7] net: ipa: verify reference flag values
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200912004532.1386-1-elder@linaro.org>
 <20200912004532.1386-4-elder@linaro.org> <20200913022530.GL3715@yoga>
From:   Alex Elder <elder@linaro.org>
Message-ID: <9ff8f11c-c7d8-d0cc-1b7d-97778bfab7b5@linaro.org>
Date:   Sun, 13 Sep 2020 08:36:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200913022530.GL3715@yoga>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/20 9:25 PM, Bjorn Andersson wrote:
> On Fri 11 Sep 19:45 CDT 2020, Alex Elder wrote:
> 
>> We take a single IPA clock reference to keep the clock running until
>> we get a system suspend operation, and maintain a flag indicating
>> whether that reference has been taken.  When a suspend request
>> arrives, we drop that reference and clear the flag.
>>
>> In most places we simply set or clear the extra-reference flag.
>> Instead--primarily to catch coding errors--test the previous value
>> of the flag and report an error in the event the previous value is
>> unexpected.  And if the clock reference is already taken, don't take
>> another.
>>
>> In a couple of cases it's pretty clear atomic access is not
>> necessary and an error should never be reported.  Report these
>> anyway, conveying our surprise with an added exclamation point.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>> v2: Updated to operate on a bitmap bit rather than an atomic_t.
>>
>>  drivers/net/ipa/ipa_main.c | 23 ++++++++++++++++-------
>>  1 file changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
>> index 409375b96eb8f..cfdf60ded86ca 100644
>> --- a/drivers/net/ipa/ipa_main.c
>> +++ b/drivers/net/ipa/ipa_main.c
>> @@ -83,6 +83,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
>>  	/* Take a a single clock reference to prevent suspend.  All
>>  	 * endpoints will be resumed as a result.  This reference will
>>  	 * be dropped when we get a power management suspend request.
>> +	 * The first call activates the clock; ignore any others.
>>  	 */
>>  	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>>  		ipa_clock_get(ipa);
>> @@ -502,14 +503,17 @@ static void ipa_resource_deconfig(struct ipa *ipa)
>>   */
>>  static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
>>  {
>> +	struct device *dev = &ipa->pdev->dev;
>>  	int ret;
>>  
>>  	/* Get a clock reference to allow initialization.  This reference
>>  	 * is held after initialization completes, and won't get dropped
>>  	 * unless/until a system suspend request arrives.
>>  	 */
>> -	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
>> -	ipa_clock_get(ipa);
>> +	if (!__test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>> +		ipa_clock_get(ipa);
>> +	else
>> +		dev_err(dev, "suspend clock reference already taken!\n");
>>  
>>  	ipa_hardware_config(ipa);
>>  
>> @@ -544,7 +548,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
>>  err_hardware_deconfig:
>>  	ipa_hardware_deconfig(ipa);
>>  	ipa_clock_put(ipa);
>> -	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
>> +	if (!__test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>> +		dev_err(dev, "suspend clock reference already dropped!\n");
>>  
>>  	return ret;
>>  }
>> @@ -562,7 +567,8 @@ static void ipa_deconfig(struct ipa *ipa)
>>  	ipa_endpoint_deconfig(ipa);
>>  	ipa_hardware_deconfig(ipa);
>>  	ipa_clock_put(ipa);
>> -	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
>> +	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
> 
> Doesn't this imply that we ran with the clocks disabled, which
> presumably would have nasty side effects?

Yes.  This is one of those that I mentioned "can't happen"
but I added the check anyway.

We call ipa_config() as the last step of ipa_probe().  The inverse
of ipa_config() is ipa_deconfig(), and that is called in two cases:
- If the AP is loading firmware, it does so *after* ipa_config()
  has been called and returned success.  If firmware loading fails,
  ipa_deconfig() is called in the error path to clean up.  If we
  never reached ipa_config() in the probe function, we will never
  call ipa_deconfig() in the error path.
- If ipa_config() fails when called in ipa_probe(), it will clean
  up all changed state and return an error value.  I *assume* that
  if the ->probe function returns an error, the ->remove function
  will never be called.  So again, we will never call ipa_deconfig()
  unless ipa_config() has been called.

That's the reasoning anyway.  That being said, you make a very
good point, in that the whole purpose of checking this at all
is to catch coding errors, and a WARN() call would provide much
better information than just an error message would.

So I will plan to update this in a new version of this patch
(and series).  I'll wait until tonight or tomorrow to see if
there is any other feedback before preparing that.

Thanks a lot.

					-Alex

> This seems like something that is worthy of more than just a simple
> printout - which no one will actually read.  If you instead use a
> WARN_ON() to highlight this at least some of the test environments out
> there will pick it up and report it...
> 
> Regards,
> Bjorn
> 
>> +		dev_err(&ipa->pdev->dev, "no suspend clock reference\n");
>>  }
>>  
>>  static int ipa_firmware_load(struct device *dev)
>> @@ -913,7 +919,8 @@ static int ipa_suspend(struct device *dev)
>>  	struct ipa *ipa = dev_get_drvdata(dev);
>>  
>>  	ipa_clock_put(ipa);
>> -	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
>> +	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>> +		dev_err(dev, "suspend: missing suspend clock reference\n");
>>  
>>  	return 0;
>>  }
>> @@ -933,8 +940,10 @@ static int ipa_resume(struct device *dev)
>>  	/* This clock reference will keep the IPA out of suspend
>>  	 * until we get a power management suspend request.
>>  	 */
>> -	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
>> -	ipa_clock_get(ipa);
>> +	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
>> +		ipa_clock_get(ipa);
>> +	else
>> +		dev_err(dev, "resume: duplicate suspend clock reference\n");
>>  
>>  	return 0;
>>  }
>> -- 
>> 2.20.1
>>

