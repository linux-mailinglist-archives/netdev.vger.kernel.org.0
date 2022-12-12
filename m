Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0A64AA16
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 23:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiLLWRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 17:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiLLWRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 17:17:48 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217D112A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 14:17:45 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id tz12so9246042ejc.9
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 14:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Au9qlT6wQS4rSTp9qQXb5lOw+Cmspjxz5l3a10oAZA=;
        b=PpyW9wEWob7ugQ9UfAklrEfAHvcIrGMMREYPmNMD1jCXgLqO6eGte6sC16tGCY0HSF
         RXvXf78UTBEKE8b/Xk/FPOR/3kL5Yi2VJjdm4DZz5pKkjTudL6pw1QQhHDWU4CMfO6xe
         xDgS+fsRDQ1DfdAkuPvuHslrfOy80wV/pRGvKBoG/fL/MjMSTdJtl7SgyqkP9Zd3hU5f
         tfLWhD7tEdOoRPPr+QFWhIZerqtga7FXqvxkVe0LxOW6cgibWxKNefINZvflb3Hz5T99
         YcTkHZVvnWq04MS4aA/D44zByVU5Uk+u/yiPLvbwHzD1fmt+ziZFkfsBiAzYkRunqyRZ
         5D2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Au9qlT6wQS4rSTp9qQXb5lOw+Cmspjxz5l3a10oAZA=;
        b=NBt0RHEgcf+xtV9Cf7pKavnKUdBUKhZoUJkYdkjNjibQzzONw2OECG3sGzpij8q7UZ
         TqqWMTXlJQ/4KFu3Wy/EEQnrPxNZ4As2Ni4HYVsm60hIHqtMiAs/AvQTiaJ8ASX848bH
         72R75A5PE2osR+rxUeImxA2YEsWqhqgQg85RLAhGsX+o9oPRdIo4YjEzsmX8SdnyFEXt
         xPNUuHxAj/BE5J7bJOfrKNU+c8aUmZK7AQtqOIEcGcmrKmstsR5VWuCawM6JTw8BfO1G
         GBWEAM8D/9RRGBCUeUU5WIR/QZBJVG1/D4UXWeoDtxvMJqnrLrcDlMz3deXAOOwPb6gS
         jZcw==
X-Gm-Message-State: ANoB5pmXhE2OcEHEFoPqNsvA5jzSzgduv+3KdymdwpH4Dyc6RyrKTC+1
        bNTHjCIoUXW7QT1mZCX0rck=
X-Google-Smtp-Source: AA0mqf7w6yMdFQn2FNLcEleYP2GiN0F7zO89uBvOFteXk4xW7SY4eBC6UDdXDW9hVdVkIuaRQY7K5w==
X-Received: by 2002:a17:906:f9cc:b0:7c0:ad62:a25f with SMTP id lj12-20020a170906f9cc00b007c0ad62a25fmr12140315ejb.51.1670883464250;
        Mon, 12 Dec 2022 14:17:44 -0800 (PST)
Received: from ?IPV6:2a01:c22:7731:9700:b095:7045:f75f:727d? (dynamic-2a01-0c22-7731-9700-b095-7045-f75f-727d.c22.pool.telefonica.de. [2a01:c22:7731:9700:b095:7045:f75f:727d])
        by smtp.googlemail.com with ESMTPSA id kz21-20020a17090777d500b007c0c91eae04sm3755890ejc.151.2022.12.12.14.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:17:43 -0800 (PST)
Message-ID: <b3ded529-3676-3d7c-4ed8-a94de470b5d7@gmail.com>
Date:   Mon, 12 Dec 2022 23:17:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
 <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
 <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
 <8b38c9f4552346ed84ba204b3e5edd5d@realtek.com>
 <6de467f2-e811-afbb-ab6f-f43f5456a857@gmail.com>
 <3395f909ef24454ca984a1b7977e0af4@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <3395f909ef24454ca984a1b7977e0af4@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.12.2022 15:11, Hau wrote:
>> On 09.12.2022 16:29, Hau wrote:
>>>>
>>>> OK, I think I get a better idea of your setup.
>>>> So it seems RTL8211FS indeed acts as media converter. Link status on
>>>> MDI side of RTL8211FS reflects link status on fiber/serdes side.
>>>> RTL8168H PHY has no idea whether it's connected to RJ45 magnetics or
>>>> to the MDI side of a RTL8211FS.
>>>>
>>>> I think for configuring RTL8211FS you have two options:
>>>> 1. Extend the Realtek PHY driver to support RTL8211FS fiber mode 2.
>>>> Configure RTL8211FS from userspace (phytool, mii-tool, ..). However
>>>> to be able to do this you may need to add a dummy netdevice
>>>>    that RTL8211FS is attached to. When going with this option it may
>>>> be better to avoid phylib taking control of RTL8211FS.
>>>>    This can be done by setting the phy_mask of the bit-banged mii_bus.
>>>
>>> Thanks for your advaice.
>>> Is that possible for us to register a PHY fixup function(phy_register_fixup())
>> to setup rtl8211fs instead of setup it in PHY driver?
>>>
>> From where would you like to register the PHY fixup? r8169 would be the
>> wrong place here.
>> There are very few drivers using a PHY fixup and AFAICS typically PHY drivers
>> apply fixups from the config_init callback.
>> Having said that, if possible I'd recommend to avoid using a PHY fixup.
>>
> Thanks for your prompt reply. I think in next patch I will remove the rtl8211fs phy parameter setting.
> And only keep non speed down patch.
> If there's any possibility I'd like to avoid the non speed down patch.
You would have to think also about the case that a user uses ethtool
to restrict advertisement to 100Mbps, what would break the connection.
r8169 isn't the right place for a workaround for a broken media converter.
The media converter should be fully transparent to r8169.

RTL8211FS should align the advertisement on MDI side with the link
speed on fiber side, based on SGMII in-band information.
If the fiber link is 1Gbps it must not advertise 100Mbps on MDI side.

