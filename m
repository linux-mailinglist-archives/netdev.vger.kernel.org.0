Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A19448598F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiAETzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243691AbiAETzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:55:09 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4A3C061245;
        Wed,  5 Jan 2022 11:55:09 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso122065pjb.1;
        Wed, 05 Jan 2022 11:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=14FClxpE+aLTMU7fxQEowe4LKw+eJj6sY83c1am50H8=;
        b=dKsIPzkioADZA6A1gsTvJHjR2h1t5+IlrGOqvFHH45WK2ZNbuRS5l6iDoqSiIdf+QR
         1IKTrSDZfYRlprvHnz6Tc7drDKV+qrKBM/xO1ecsKVxBlQFYPRbjRUh1tf/0tchvud5H
         4a4YVKVW9GVEqiPiqXcvfkNdld28VUutSTt762zBmnAlHPFq5Y3YeRCZMI19Jw4WOCW5
         flKkePop55O5WLqKUmuoWL7Ivd5G8VkszYPEzUFHwrorlZkpRFhnMWr7XVEQWdA2SHd4
         iEVgxud7ORwl7OWw9q+MCQaCxdWi+0UMKc9g+Q6/Iyc3SIht3vhu7qB8W0F95d79SQac
         qXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=14FClxpE+aLTMU7fxQEowe4LKw+eJj6sY83c1am50H8=;
        b=CicbYJ7xaPNRvKRDf1Ij95CRmgkLiohFPoACaoDjLQSu7/IDpKZqqVvVsahPvtmZ7A
         KKEnGuTOaK+rwPZ/wiw3Hl2yB4NO7Zi7paFmk4V5qicWf0/lV3Hd7Xmrb8eT4MTg6MT+
         itXhbP49ITZBp/99VIRoEXYJ5TjQ3MlR4bFHES2INLsMit5LOB8Tl+Zwii3gU5whu3oy
         VnhfMrstVDzmty5YyAcUVT0Dh9ryt4AHwia4EW1W3tky181zsVOSZyId75xy6d6m5A/f
         gf2YcfXkg3bvGceuleRPka5QHWkmS1dTsRWn9ZX8pqyxRR6eF4aBAXSTy/+ytlMEK+tb
         3G3w==
X-Gm-Message-State: AOAM533CCQhFWdUFiijZqYOeu/6ohCBknSYiDbn8TVg0eKKLSkh/1AWY
        yLmySgDH1X4IA3iXBCmK/4rRG6fE9cM=
X-Google-Smtp-Source: ABdhPJy+tYy19YRWennySufnX8e+cO2ou1bf8Pta8Z59THaGEM+EyL/EZi0Ebx32lI6G147OlZ3RbQ==
X-Received: by 2002:a17:902:7b96:b0:149:49fc:7de0 with SMTP id w22-20020a1709027b9600b0014949fc7de0mr55032845pll.25.1641412508757;
        Wed, 05 Jan 2022 11:55:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b13sm44084920pfo.37.2022.01.05.11.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 11:55:08 -0800 (PST)
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
To:     Aaron Ma <aaron.ma@canonical.com>,
        Henning Schild <henning.schild@siemens.com>
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
References: <20220105061747.7104-1-aaron.ma@canonical.com>
 <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
 <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
 <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
 <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
 <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
 <20220105093218.283c9538@md1za8fc.ad001.siemens.net>
 <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <32b9e331-2c1d-6a7d-ca38-57cec50b240c@gmail.com>
Date:   Wed, 5 Jan 2022 11:55:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 12:37 AM, Aaron Ma wrote:
> 
> 
> On 1/5/22 16:32, Henning Schild wrote:
>> Am Wed, 5 Jan 2022 16:01:24 +0800
>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>
>>> On 1/5/22 15:55, Henning Schild wrote:
>>>> Am Wed, 5 Jan 2022 15:38:51 +0800
>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>>>   
>>>>> On 1/5/22 15:32, Henning Schild wrote:
>>>>>> Am Wed, 5 Jan 2022 08:23:55 +0100
>>>>>> schrieb Henning Schild <henning.schild@siemens.com>:
>>>>>>      
>>>>>>> Hi Aaron,
>>>>>>>
>>>>>>> if this or something similar goes in, please add another patch to
>>>>>>> remove the left-over defines.
>>>>>>>      
>>>>>
>>>>> Sure, I will do it.
>>>>>  
>>>>>>> Am Wed,  5 Jan 2022 14:17:47 +0800
>>>>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
>>>>>>>     
>>>>>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
>>>>>>>> or USB hub, MAC passthrough address from BIOS should be
>>>>>>>> checked if it had been used to avoid using on other dongles.
>>>>>>>>
>>>>>>>> Currently builtin r8152 on Dock still can't be identified.
>>>>>>>> First detected r8152 will use the MAC passthrough address.
>>>>>>>>
>>>>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>>>>>>>> ---
>>>>>>>>     drivers/net/usb/r8152.c | 10 ++++++++++
>>>>>>>>     1 file changed, 10 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>>>>>>>> index f9877a3e83ac..77f11b3f847b 100644
>>>>>>>> --- a/drivers/net/usb/r8152.c
>>>>>>>> +++ b/drivers/net/usb/r8152.c
>>>>>>>> @@ -1605,6 +1605,7 @@ static int
>>>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
>>>>>>>> *sa) char *mac_obj_name; acpi_object_type mac_obj_type;
>>>>>>>>         int mac_strlen;
>>>>>>>> +    struct net_device *ndev;
>>>>>>>>             if (tp->lenovo_macpassthru) {
>>>>>>>>             mac_obj_name = "\\MACA";
>>>>>>>> @@ -1662,6 +1663,15 @@ static int
>>>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
>>>>>>>> *sa) ret = -EINVAL; goto amacout;
>>>>>>>>         }
>>>>>>>> +    rcu_read_lock();
>>>>>>>> +    for_each_netdev_rcu(&init_net, ndev) {
>>>>>>>> +        if (strncmp(buf, ndev->dev_addr, 6) == 0) {
>>>>>>>> +            rcu_read_unlock();
>>>>>>>> +            goto amacout;
>>>>>>>
>>>>>>> Since the original PCI netdev will always be there, that would
>>>>>>> disable inheritance would it not?
>>>>>>> I guess a strncmp(MODULE_NAME, info->driver, strlen(MODULE_NAME))
>>>>>>> is needed as well.
>>>>>>>      
>>>>>
>>>>> PCI ethernet could be a builtin one on dock since there will be
>>>>> TBT4 dock.
>>>>
>>>> In my X280 there is a PCI device in the laptop, always there. And
>>>> its MAC is the one found in ACPI. Did not try but i think for such
>>>> devices there would never be inheritance even if one wanted and
>>>> used a Lenovo dock that is supposed to do it.
>>>>    
>>>
>>> There will more TBT4 docks in market, the new ethernet is just the
>>> same as PCI device, connected by thunderbolt.
>>>
>>> For exmaple, connect a TBT4 dock which uses i225 pcie base ethernet,
>>> then connect another TBT3 dock which uses r8152.
>>> If skip PCI check, then i225 and r8152 will use the same MAC.
>>
>> In current 5.15 i have that sort of collision already. All r8152s will
>> happily grab the MAC of the I219. In fact i have only ever seen it with
>> one r8152 at a time but while the I219 was actively in use.
>> While this patch will probably solve that, i bet it would defeat MAC
>> pass-thru altogether. Even when turned on in the BIOS.
>> Or does that iterator take "up"/"down" state into consideration? But
>> even if, the I219 could become "up" any time later.
>>
> 
> No, that's different, I219 got MAC from their own space.
> MAC passthrough got MAC from ACPI "\MACA".
> 
>> These collisions are simply bound to happen and probably very hard to
>> avoid once you have set your mind on allowing pass-thru in the first
>> place. Not sure whether that even has potential to disturb network
>> equipment like switches.
>>
> 
> After check MAC address, it will be more safe.

Sorry to just do a drive by review here, but why is passing through the
MAC a kernel problem and not something that you punt to user-space entirely?
-- 
Florian
