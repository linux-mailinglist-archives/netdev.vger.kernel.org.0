Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99D32F188E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbhAKOoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbhAKOoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:44:02 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13234C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:43:22 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t30so66485wrb.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=edyYwtut5XbV5n36PQbahY3u31HbfFcCdVLuEPU9Pcw=;
        b=FVY6CsNb9LhFXtnpfw6Aif2FSCujZ0pI0VAXQwU/1Bl1/gq+qScPznuCXUE3jiLXj/
         K2dpJW8aj6t1TyfNFaVcNorBy07JGAyvLZLFnOJbyOrNueLWyha48qIVg3YrOy5yWiWs
         gA5ABb4oK4R9W/40FAp2yB0CpRvjkrLeCqHkw3wMtpWA1grWLCFCJ9FA2ADBgp8pJhlo
         +YN+DR/vhoSh3L53ogzVK7MhbmQ/g8eyrAtCCTzrl2IyJkMpD9n1MoAK+Y0OeTHSNmli
         elXl3zze/tE8ui35Q616F5nHxM4N9clAwwfSC33iveVojpkGw4JXMz9VXkdgMbEICD4w
         OxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=edyYwtut5XbV5n36PQbahY3u31HbfFcCdVLuEPU9Pcw=;
        b=J2HElKjXtDlQPHht+rI9WZdm8te1xURc9ymL4E63QZcc/f6o3eTkQoeSNm3PxPOhiO
         JJ8z9zi+CEDZeA7nZ1uxjZnWuTCZB0JdfUcZNuxwYMypWuDqzgdc0hKQ8EDD4wsQ1v8b
         cy6S3kLeKN5Yq2jwXlAQ5R6MMDjs3uEbL2Vk7DFmvUpvQFQ/nuK3K3quz8JUHZF4XCMj
         dx8X9MaL84oIVOBsv0uywf5VR/b2q1/DYRaIkpEyT1jkSeUYUNGQ96tAtzQeMWyOivbr
         dYn5GDQoSfAbePEYEkvmpBVIighnvB0/FxjrHdP9ZFHe79NGrRw97XyAKWBc/rUGevXa
         Fw7Q==
X-Gm-Message-State: AOAM530RBNNnJH/OIFMqtFu+7ibaKabA4ifVOEsOP9DoWC4/MWrPWumd
        sJzsriN3a1mCQed7e3O+26s=
X-Google-Smtp-Source: ABdhPJxWc2VLVZfwe4T2/R1ZSQNxAmWZdO4cfpHbHlHPyGhQ3xzOQGMgqDCaw4jvRQDhJtNjpgNXjw==
X-Received: by 2002:adf:e60f:: with SMTP id p15mr16376678wrm.60.1610376200841;
        Mon, 11 Jan 2021 06:43:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:70c5:7cc:8644:5b6d? (p200300ea8f06550070c507cc86445b6d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:70c5:7cc:8644:5b6d])
        by smtp.googlemail.com with ESMTPSA id v189sm14097wmg.14.2021.01.11.06.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 06:43:20 -0800 (PST)
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Lukas Wunner <lukas@wunner.de>
References: <20210111125337.36513-1-marex@denx.de>
 <a8eb8186-cde4-19ab-5b3c-e885e11106cf@gmail.com>
 <8c46baf2-28c9-190a-090c-c2980842b78e@denx.de>
 <aeb906d3-be61-c3cd-4ec0-88e66f384369@gmail.com>
 <177a7c60-2c3a-3242-7999-12ad4fec78b3@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the internal
 PHY
Message-ID: <d20d2e2e-9745-4f75-3179-f68e1efcf29b@gmail.com>
Date:   Mon, 11 Jan 2021 15:43:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <177a7c60-2c3a-3242-7999-12ad4fec78b3@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.2021 15:10, Marek Vasut wrote:
> On 1/11/21 2:50 PM, Heiner Kallweit wrote:
>> On 11.01.2021 14:38, Marek Vasut wrote:
>>> On 1/11/21 2:26 PM, Heiner Kallweit wrote:
>>> [...]
>>>
>>>> LGTM. When having a brief look at the driver I stumbled across two things:
>>>>
>>>> 1. Do MAC/PHY support any pause mode? Then a call to
>>>>      phy_support_(a)sym_pause() would be missing.
>>>
>>> https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8851-16MLL-Single-Port-Ethernet-MAC-Controller-with-8-Bit-or-16-Bit-Non-PCI-Interface-DS00002357B.pdf
>>> page 64
>>>
>>> https://www.mouser.com/datasheet/2/268/ksz8851-16mll_ds-776208.pdf
>>> page 65
>>>
>>> The later is more complete.
>>>
>>> Apparently it does support pause.
> 
> Based on the datasheet, does it support sym or asym pause ?
> 

According to the description of flow control on p.23 it can support asym pause.
However on the MAC side flow control doesn't seem to be always active, it's
controlled by these two bits:

p.49, TXCR, bit 3
p.50, RXCR1, bit 10

Default seems to be that flow control is disabled.

>>>> 2. Don't have the datasheet, but IRQ_LCI seems to be the link change
>>>>      interrupt. So far it's ignored by the driver. You could configure
>>>>      it and use phy_mac_interrupt() to operate the internal PHY in
>>>>      interrupt mode.
>>>
>>> That's only for link state change, shouldn't the PHY interrupt trigger on other things as well ?
>>
>> No, it's sufficient if the interrupt can signal link state change.
>> In r8169 I have exactly that case.
> 
> I'll do that in a subsequent patch, once I verify it works as it should.

