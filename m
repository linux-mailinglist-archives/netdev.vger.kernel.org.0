Return-Path: <netdev+bounces-12149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A852A7366B6
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6A061C20B9C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E74C144;
	Tue, 20 Jun 2023 08:55:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6C61FDD
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:55:13 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932C510DC
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:55:11 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f90b8ace97so32096825e9.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687251310; x=1689843310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4iS2y1OnqzJKxw2HMxOkBjHX6AOsUPw+JImGbUMIxFg=;
        b=f4JsLlCxHec5vVldrlb1HMkH9i7QC2zxrPMaYwzIjp/HDDLN1HRV4NwopXumEmW9C/
         xOS/eeLg/uR9ir61is14Ve0SJfuJu3t+W7/nMTrKWjCOOAQ96LZwDvQYMZoFe73ImJgd
         clCa7NDVHHM6/RGf2ROZIgO/PGPvjq++0F+F8JSPDFXeLszY/Qnw9cVlr7U8srL2ALFo
         bbMVAkGEwQ6p26WLPXh9kTa8W/qDvZ97c5rEnHDVCJXU55Ud9vmCcss8IGI08NhztPl8
         4xZNHlvQHigdA1YalBiEAd0jW36yzTHjQr9U+aazJzXB3+Qp3L2Sa9ygBtokYzT3u0dS
         TjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687251310; x=1689843310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4iS2y1OnqzJKxw2HMxOkBjHX6AOsUPw+JImGbUMIxFg=;
        b=d1cTSvJY/ofWVZK8Sp8XWLtJD+wH7zJzRLic8oJAdBbowoEIB/WxDhHVHr1ljFeZPu
         /9q7yfSOUaFz67HMZe7LGBuYqqHXQ1b48XcAnMGOWZsviEcDvlIKw9Sa3pRAfRN9krzf
         ea5xPIQ117CVWoCSQbZgVctZ/w3RJtAUHCI1Q7W+DxsYzUCwMUZNb1Ug1HWy3WN+DOYg
         mCmC3SXPsMV/lww7oEvYilZ7UjNmz+oUj0xjA3531SlZLzT6GiwOPwo2bfMnVsVlGrO1
         HQqtkTb8khMPEi2B3OEciUiqjUzGprk0f4kYlkYeHrJ7EI3A0MMMKc9Wr2bwxFk2YpCG
         HL0g==
X-Gm-Message-State: AC+VfDzFRhBRWAUpPdQtJfkQUpVUgjKxHxmsXkMdJz62829t0tQvgSWf
	DiS08zG5YySUr0bSfq5o9iuZbA==
X-Google-Smtp-Source: ACHHUZ5VCu5k4nHF4t4LkDOSbvpBchpWq0tIlTiaANTgj8U6JwAarF7fg48kO+5pn74BlAToa9pfzw==
X-Received: by 2002:a7b:cc99:0:b0:3f9:b88a:f9aa with SMTP id p25-20020a7bcc99000000b003f9b88af9aamr831636wma.11.1687251310048;
        Tue, 20 Jun 2023 01:55:10 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id i2-20020a05600c290200b003f42d8dd7d1sm12932116wmd.7.2023.06.20.01.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 01:55:09 -0700 (PDT)
Message-ID: <1a5c39d8-812f-4a8d-bc65-205695661973@linaro.org>
Date: Tue, 20 Jun 2023 10:55:06 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
To: Conor Dooley <conor.dooley@microchip.com>,
 Guo Samin <samin.guo@starfivetech.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Conor Dooley <conor@kernel.org>,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 netdev@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
 Frank <Frank.Sae@motor-comm.com>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230526090502.29835-1-samin.guo@starfivetech.com>
 <20230526090502.29835-2-samin.guo@starfivetech.com>
 <20230526-glutinous-pristine-fed571235b80@spud>
 <1dbf113c-7592-68bd-6aaf-05ff1d8c538c@starfivetech.com>
 <15eb4ffe-ea12-9a2c-ae9d-c34860384b60@starfivetech.com>
 <20230620-clicker-antivirus-99e24a06954e@wendy>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230620-clicker-antivirus-99e24a06954e@wendy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 20/06/2023 10:26, Conor Dooley wrote:
> Hey,
> 
> On Tue, Jun 20, 2023 at 11:09:52AM +0800, Guo Samin wrote:
>> From: Guo Samin <samin.guo@starfivetech.com>
>>> From: Conor Dooley <conor@kernel.org>
>>>> On Fri, May 26, 2023 at 05:05:01PM +0800, Samin Guo wrote:
>>>>> The motorcomm phy (YT8531) supports the ability to adjust the drive
>>>>> strength of the rx_clk/rx_data, the value range of pad driver
>>>>> strength is 0 to 7.
> 
>>>>> +  motorcomm,rx-clk-driver-strength:
>>>>> +    description: drive strength of rx_clk pad.
>>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>>>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
>>>>
>>>> I think you should use minimum & maximum instead of these listed out
>>>> enums.
> 
>>>  You have also had this comment since v1 & were reminded of it on
>>>> v2 by Krzysztof: "What do the numbers mean? What are the units? mA?"
> 
>>> The good news is that we just got some data about units from Motorcomm. 
>>> Maybe I can post the data show of the unit later after I get the complete data.
> 
>> Sorry, haven't updated in a while.
> 
> NW chief.
> 
>> I just got the detailed data of Driver Strength(DS) from Motorcomm , which applies to both rx_clk and rx_data.
>>
>> |----------------------|
>> |     ds map table     |
>> |----------------------|
>> | DS(3b) | Current (mA)|
>> |--------|-------------|
>> |   000  |     1.20    |
>> |   001  |     2.10    |
>> |   010  |     2.70    |
>> |   011  |     2.91    |
>> |   100  |     3.11    |
>> |   101  |     3.60    |
>> |   110  |     3.97    |
>> |   111  |     4.35    |
>> |--------|-------------|
>>
>> Since these currents are not integer values and have no regularity,

There is no mA unit in DT schema, so I don't see what by "not integer
values". 1200 uA is an integer.

>> it is not very good to use in the drive/dts in my opinion.
> 
> Who says you have to use mA? What about uA?

Yep

> 
>> Therefore, I tend to continue to use DS(0-7) in dts/driver, and adding
>> a description of the current value corresponding to DS in dt-bindings. 
> 
> I think this goes against not putting register values into the dts &
> that the accurate description of the hardware are the currents.

For vendor properties register values are often accepted, but logical
unit is much more readable in the DTS. Also allows further customization
or extending when new variant appears. You cannot do extend a property
easily when it holds a register value, without changing the meaning per
variant.

> 
>> Like This:
>>
>> +  motorcomm,rx-clk-driver-strength:
>> +    description: drive strength of rx_clk pad.
> 
> You need "description: |" to preserve the formatting if you add tables,
> but I don't think that this is a good idea. Put the values in here that
> describe the hardware (IOW the currents) and then you don't need to have
> this table.
> 
>> +      |----------------------|
>> +      | rx_clk ds map table  |
>> +      |----------------------|
>> +      | DS(3b) | Current (mA)|
>> +      |   000  |     1.20    |
>> +      |   001  |     2.10    |
>> +      |   010  |     2.70    |
>> +      |   011  |     2.91    |
>> +      |   100  |     3.11    |
>> +      |   101  |     3.60    |
>> +      |   110  |     3.97    |
>> +      |   111  |     4.35    |
>> +      |--------|-------------|
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
>> +    default: 3
>> +
> 
>> Or use minimum & maximum instead of these listed out enums
> 
> With the actual current values, enum rather than min + max.



Best regards,
Krzysztof


