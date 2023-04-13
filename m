Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5C66E0F91
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjDMOFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjDMOFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:05:06 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39DB19B7;
        Thu, 13 Apr 2023 07:04:51 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id gb12so13363263qtb.6;
        Thu, 13 Apr 2023 07:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394691; x=1683986691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NawhwqeTpbHH9NZVueC607f+P3eR2lIHqHXJApMeoUE=;
        b=E31Mscy3zzm+DMmohqB3G633x/K1cYFdPBNlXFMZSL8BF4rbjEl9heOImx+L8132Gk
         2t4M0+8oUmgmqMyjlR8B5ekq6sLOF5A782LTcE7Pff9bYFJmKZKz+i8uhkA2Ld40DnfO
         7SHYovtdDJ+G5aiQlEtaz7bVuyaXSuoLWFScrIgsVlUpunifiLAVzYYit2Qozuai5KWW
         0Ii1dkeEPJdhIz9sAwN6DSeK2gZ1ral3fXf8V2ACr/zWVhGyIBlpHnYKna6esyR8Q0LN
         xqJ7OMikXxXPCb3wpqpypYOWqWa468Xy504dGsNPCeHpk4hS7XA5sgzpkVtotHPcChN8
         n5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394691; x=1683986691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NawhwqeTpbHH9NZVueC607f+P3eR2lIHqHXJApMeoUE=;
        b=A78g7b7hDcu97Wac130R3w3hhoRqdwEYklEbNCeOwkC8kx4RyYMcivEgpdHaDVERt1
         eNMIzfklsXEUb9luNepPvKVtLN7FUdgfCfDP34H0npfbq1dbgmtjbhNV0VjCMpxFC8D0
         apisRVdI0ABzUcP0yFL+xvIbR1KWzTsPYkN5QaQnP5CMYlF/bZ2GbCoTfC/0k2POMJYK
         PuIBBwXzLMfTGhSkd2skl/nhjMAelNwBahhTAPOkGzfBLhvAfioHBIksJMUrjp1My41A
         jcxspW/d7JgkGj32qMSzvJhgzzTgBfiemiuzUQIlkhDJ4OiMCsFniRDvDi5+a3KXN/vz
         DlIg==
X-Gm-Message-State: AAQBX9fevqkZaa2VAtuOp65TjB8zwU1QLctboV4gSldn47ktKzXtNeCP
        TEtxXfCNKROyCwmhPRRvsZTyQmm6Yv8f1w==
X-Google-Smtp-Source: AKy350arbkApYkL1K/TFNHHma7RYJY4EiMcNJOjiKfGB43WxSYDcmb48Ung3kqgX+Ba2+AKfHBgLeQ==
X-Received: by 2002:a05:622a:1a18:b0:3e1:7bb5:f0c5 with SMTP id f24-20020a05622a1a1800b003e17bb5f0c5mr3164054qtb.58.1681394690852;
        Thu, 13 Apr 2023 07:04:50 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d7-20020ac800c7000000b003e29583cf22sm500347qtg.91.2023.04.13.07.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 07:04:50 -0700 (PDT)
Message-ID: <7ea465d9-95eb-d158-632a-a2aa892fd2bf@gmail.com>
Date:   Thu, 13 Apr 2023 07:04:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 06/16] net: phy: phy_device: Call into the PHY
 driver to set LED brightness
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-7-ansuelsmth@gmail.com>
 <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
 <64380b46.7b0a0220.978a.1eb4@mx.google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <64380b46.7b0a0220.978a.1eb4@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 4:11 PM, Christian Marangi wrote:
> On Thu, Apr 13, 2023 at 06:57:51AM -0700, Florian Fainelli wrote:
>>
>>
>> On 3/27/2023 7:10 AM, Christian Marangi wrote:
>>> From: Andrew Lunn <andrew@lunn.ch>
>>>
>>> Linux LEDs can be software controlled via the brightness file in /sys.
>>> LED drivers need to implement a brightness_set function which the core
>>> will call. Implement an intermediary in phy_device, which will call
>>> into the phy driver if it implements the necessary function.
>>>
>>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>>> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>>> +	int (*led_brightness_set)(struct phy_device *dev,
>>> +				  u32 index, enum led_brightness value);
>>
>> I think I would have made this an u8, 4 billion LEDs, man, that's a lot!
> 
> If andrew is ok we can still consider to reduce it. (but just to joke
> about it... A MAN CAN DREAM OF A FULL HD SCREEN ON THEIR OWN SPECIAL
> PORT)

Humm just thought of something else, is it OK for led_brightness_set and 
led_blink_set to call into functions that might require sleeping (MDIO, 
I2C, SPI, etc.)?
-- 
Florian
