Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03583512537
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiD0W0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiD0W0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:26:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5C2E0BA;
        Wed, 27 Apr 2022 15:23:17 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s14so2736158plk.8;
        Wed, 27 Apr 2022 15:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XTJyE0sYRs0q7Hyafv+smNOfRDRJ91ZtPc57S/2FX00=;
        b=WKBWN+MqlogzeqGvoosCx/VjaRp3dIbxJoFo1TmLVIY6GPXMvSn4T/A8T4ggrDmp5e
         aM+FUv4IvEX7hucf0dUFVgHdcDqtyCE3W4LDoKle26cYOheeWbafP8ORSHMvFqJhIzu9
         G+j5NgrcI0tfhMDi3106IXWTAs4i4CWzEDxQ9ZoVA3TB8Is++ML+XVUQR46xsFO5yKiA
         6WSpLIQ3OiauKJDDeeCDrVhelf0OopaFfwiH7lC8F5QCO/mQovdNLeP3lbXXbj/+ZXDy
         SwPJFenhSYPyC+7fwvYXhF01UefZVioXKBXe3sp5C1VNSQdiYMkbDG44b+iBMJFCaVFx
         isVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XTJyE0sYRs0q7Hyafv+smNOfRDRJ91ZtPc57S/2FX00=;
        b=fjXpffp3IP2t8n48z2iLXqrrNARsAddd2NOdKVGNbb1fc72DNcEFf3pDIM0SZnaHxd
         MfSXbVsblPV+GjzcCcL6yjyjm7GAi9c1bbKvC6cjgXZo0fEXghLZ+F8aCYDD0rFYCaU9
         cCV95L78ZJczzQWJcRt1Ar6tAeAQLBe4EbRHmQPe1rs+KKCxAnutGm7Su4R+80yo4ckV
         xeMBtqSDYz/5w9EsH9RUlmrF1QAcdh9Nvz/OHXyeweXGspdN8RLCXUJZhbpLYdDJPeMR
         9RKwXWlyJqc/f9hghh6EIRVr59R3YRhYO3U1lwzsOrzBlUHIsSPyLi7DFcocI/0gWRwT
         xC9Q==
X-Gm-Message-State: AOAM5311uUiLAGyE3lIiC6jWbaLNsJM9Y+rSnqKdkxcbMVC7/da1uZEy
        Axndftqkrl6yjHNWwZ9PY5c=
X-Google-Smtp-Source: ABdhPJw2OSOxSwbkaRMpjS1xPenu5H6z+yMDpucr8+TR+Nkl5nY2aoo8aRXL+bBOCnCOh43DcS/aXw==
X-Received: by 2002:a17:90b:30c4:b0:1d8:3395:a158 with SMTP id hi4-20020a17090b30c400b001d83395a158mr32319597pjb.184.1651098197437;
        Wed, 27 Apr 2022 15:23:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n14-20020a17090ac68e00b001d9e3b0e10fsm5767471pjt.16.2022.04.27.15.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 15:23:17 -0700 (PDT)
Message-ID: <002aafe5-2568-f153-b294-e9367b5b00c9@gmail.com>
Date:   Wed, 27 Apr 2022 15:23:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 3/3] net: phy: micrel: add coma mode GPIO
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220427214406.1348872-1-michael@walle.cc>
 <20220427214406.1348872-4-michael@walle.cc>
 <652a5d64-4f06-7ac8-a792-df0a4b43686f@gmail.com>
 <635fd80542e089722e506bba0ff390ff@walle.cc>
 <cef1c3f7-06e3-f0dd-10ce-513f35fef3d0@gmail.com>
 <c9214b4cdf308b951a2da797898f3dcd@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <c9214b4cdf308b951a2da797898f3dcd@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 15:17, Michael Walle wrote:
> Am 2022-04-28 00:12, schrieb Florian Fainelli:
>> On 4/27/22 15:08, Michael Walle wrote:
>>> Am 2022-04-28 00:06, schrieb Florian Fainelli:
>>>> On 4/27/2022 2:44 PM, Michael Walle wrote:
>>>>> The LAN8814 has a coma mode pin which puts the PHY into isolate and
>>>>> power-dowm mode. Unfortunately, the mode cannot be disabled by a
>>> s/dowm/down/
>>>
>>>>> register. Usually, the input pin has a pull-up and connected to a GPIO
>>>>> which can then be used to disable the mode. Try to get the GPIO and
>>>>> deassert it.
>>>>
>>>> Poor choice of word, how about deep sleep, dormant, super isolate?
>>>
>>> Which one do you mean? Super isolate sounded like broadcom wording ;)
>>
>> Coma is not a great term to use IMHO. Yes Super isolate (tm) is a
>> Broadcom thing, and you can come out of super isolate mode with
>> register writes, so maybe not the best suggestion.
> 
> I didn't come up with that name. It's all in the datasheets and it's
> actually already used grep for "COMA_MODE" in phy/mscc. (Yes on that
> one you can actually disable it with register access..). Even if
> it is not a great name (which I agree), I'd use the same naming as
> the datasheet and esp. the pin name.

OK then, makes sense to use the datasheet name.
-- 
Florian
