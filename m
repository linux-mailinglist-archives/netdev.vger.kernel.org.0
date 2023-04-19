Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A47D6E8116
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjDSSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 14:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDSSP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 14:15:58 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5DC138
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 11:15:56 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy21so445824ejb.9
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 11:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681928154; x=1684520154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=esiPK9DOoOxmSsGp8xH/u27tyE12UW1WkHZ4H94B0xY=;
        b=YihQkCvFfADVncYbOvPiIAw9pLC3QgdYKEeQ7Cdw/ID/5H/p1z9meFL7KkMi0DFty7
         bD5S94VhXn0qqoG9MyXJFj7IXXa+8EKZpbehtSlYoNWEjZx8dPQWdxRRtUIqgS2xa9dR
         VddS5shFXzcLwSIO68iR41xAoOm/GZOTSGZGVd//e1y+y/WnAIDZN92byMyWPr9wro+y
         BDK2eCnwljv2dknW3+yaT09h5DKfFfRurQ7fOrHOuFl4uny4YM0YOZ/+dtEa2n5prPlH
         gfGnTsmxEk84EgIYeowWl3bFN+4CQGRVB6HCK0qfLPLf4/2kfWOQMR0ORA6JJGRpOnar
         /ynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681928154; x=1684520154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=esiPK9DOoOxmSsGp8xH/u27tyE12UW1WkHZ4H94B0xY=;
        b=dME9kexH6b42dw8+ELtJii3veSdLOeRQ/3DRVM1aG7riZyeSLA7DV50dHkXxV3NKcv
         Q8dCTBn3GO32BN5FWpiYXZvcr+odISGmt5vwWKb09NPdFlvwbFei+IQUfAW9GXT3ZDGj
         MbZKLp5/biMbka9TUFxao3I7FQ4Aeyb/qTWKA74nqtsapm74ee+ikNM9shnomZAQDfZv
         P0ETjUe1fhi4riE+m6t5yN8wBcHNiGc8Dm3VS7NIRToeKElf/qCm76PsywoRuuUgzMWQ
         uTGgz4hAKizY8ZVRaxRkiQAoQR64A7Nr9LvtHJUh/lI48x5yQEz137r4Fh5Sgdh0pEKH
         x0dw==
X-Gm-Message-State: AAQBX9e3vhBeeODP07oIlCBPlY07t6jiIhgumBQxxuRn9ihg/wRtoSYP
        JIFOz34UpY2HijIwjRgsspv8xg==
X-Google-Smtp-Source: AKy350Y/8wwRwMoz77KnSJWjuwQc9IeVQEIuJKccmMCfmKt/uFmgZkrLYNXYmcC02HOUWjVB6gjDQQ==
X-Received: by 2002:a17:906:1083:b0:94e:c40b:71e3 with SMTP id u3-20020a170906108300b0094ec40b71e3mr3732741eju.5.1681928154513;
        Wed, 19 Apr 2023 11:15:54 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:b7d8:d88b:1fac:c802? ([2a02:810d:15c0:828:b7d8:d88b:1fac:c802])
        by smtp.gmail.com with ESMTPSA id f10-20020a1709064dca00b0094f2dca017fsm6264601ejw.50.2023.04.19.11.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 11:15:53 -0700 (PDT)
Message-ID: <23aa09ae-4112-fd69-065a-ec9dd8ec2bd7@linaro.org>
Date:   Wed, 19 Apr 2023 20:15:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [net-next PATCH v7 13/16] ARM: dts: qcom: ipq8064-rb3011: Add
 Switch LED for each port
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
 <20230417151738.19426-14-ansuelsmth@gmail.com>
 <289b7604-d32d-49d9-8f06-87147d6fd473@linaro.org>
 <643ffce4.050a0220.73dcc.1bec@mx.google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <643ffce4.050a0220.73dcc.1bec@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 16:38, Christian Marangi wrote:
> On Wed, Apr 19, 2023 at 02:53:45PM +0200, Krzysztof Kozlowski wrote:
>> On 17/04/2023 17:17, Christian Marangi wrote:
>>> Add Switch LED for each port for MikroTik RB3011UiAS-RM.
>>>
>>> MikroTik RB3011UiAS-RM is a 10 port device with 2 qca8337 switch chips
>>> connected.
>>>
>>> It was discovered that in the hardware design all 3 Switch LED trace of
>>> the related port is connected to the same LED. This was discovered by
>>> setting to 'always on' the related led in the switch regs and noticing
>>> that all 3 LED for the specific port (for example for port 1) cause the
>>> connected LED for port 1 to turn on. As an extra test we tried enabling
>>> 2 different LED for the port resulting in the LED turned off only if
>>> every led in the reg was off.
>>>
>>> Aside from this funny and strange hardware implementation, the device
>>> itself have one green LED for each port, resulting in 10 green LED one
>>> for each of the 10 supported port.
>>>
>>> Cc: Jonathan McDowell <noodles@earth.li>
>>> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
>>> ---
>>>  arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 120 ++++++++++++++++++++++
>>
>> Please do not send the DTS patches to the net-next, but to the Qualcomm
>> SoC maintainers. The DTS must not be mixed with driver code.
>>
> 
> Hi,
> 
> sorry for the mess, it was asked to give an user of the LED feature for
> qca8k so I was a bit confused on where to include it and at the end I
> decided to put it in this series.
> 
> What was the correct way? 2 different series and reference the DT one in
> the net-next? (or not targetting net-next at all?)

Send a separate patchset and provide a lore URL to it in the bindings
(or vice versa).

Best regards,
Krzysztof

