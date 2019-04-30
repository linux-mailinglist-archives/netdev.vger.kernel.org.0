Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0C5EE37
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 03:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfD3BPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 21:15:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41867 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfD3BPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 21:15:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id f6so6016453pgs.8;
        Mon, 29 Apr 2019 18:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SJR2bqkaxTTZSrKOHpSh+1p44wBNtrD7UfXsdGZTi18=;
        b=Beo9N4BnADPEIi1HCq2wYdn1zIeVDJ3/QVI/sXM9MMdHg3gbLEcbjGN5TkdrROcUjp
         2k6eD077b1qkMhFqNmXw9W///FgszQerwO0FdCGil81+Hq+3NPWRAbSwpl442P1grv7B
         zkEZ1dyXBmPOQ/uUZJNlXyl46YgLZ6yQ+dWE41Wy2j6wzBVmUF5A53rGKsow5TZ4SuMj
         NEg7txBctaUiZccU+Ws+MrlVVDjBfL+d6SEA9L5ZxakCLCct2HLEVVpwQanIWwe1vCnV
         kMOONxVns9HwJbJuW1m3X9tyDBVtSktUD3I8GZEMi1YlVNn7efCJP/6XuAu4uQ5sWA7Q
         M4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SJR2bqkaxTTZSrKOHpSh+1p44wBNtrD7UfXsdGZTi18=;
        b=W9TkX9AQW4jh4oTSilB7Z3LqN/YelBK3tVPaK3VDE+HISn5yJ6XA4OlVdV2qziUIAR
         NhgYyQ3NiAcgixCHKsUYilhJoe0nI1HWZ2SKhBg9Q5hkOGCqr8+3QwUmxBHt5FptktMv
         xtpQVzX7HB4de8il1pqjiJkv0VyV1IfxHCfvZxrkcvbiTz7GIHIEg0pytTZ5kUe+5grE
         PDmRxQV+g4duQApk/kUhaEWnpWtRvRKTdQB6D7xZbkMsDZYcUMBYsZdG7OCiGlfFmo8e
         NX5XYhLs7JMecpajuIBa4W1p0oHuTFzn8+7iKdHcx8Bkyq/Ynw6mFKniCDaNJsdZsPul
         tgpQ==
X-Gm-Message-State: APjAAAXjW1PvcBz3GJHsacyPqJfTC4anBKrUA7vmwfsRFoAAVjQjgMU4
        eGpFeF4gwoQF7/fMpLVFi6s=
X-Google-Smtp-Source: APXvYqw2SGm3BTsHdsLohh4J1ZBkW4UbLNOORIYOQLS5NYLqdt5q+xmynXGiVI/jcMkGrP88+BivMg==
X-Received: by 2002:aa7:8b4c:: with SMTP id i12mr14401909pfd.189.1556586932334;
        Mon, 29 Apr 2019 18:15:32 -0700 (PDT)
Received: from [192.168.1.70] (c-24-6-192-50.hsd1.ca.comcast.net. [24.6.192.50])
        by smtp.gmail.com with ESMTPSA id q80sm64336468pfa.66.2019.04.29.18.15.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 18:15:31 -0700 (PDT)
Subject: Re: [PATCH] of_net: add mtd-mac-address support to
 of_get_mac_address()
To:     Rob Herring <robh@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
References: <1555445100-30936-1-git-send-email-ynezz@true.cz>
 <d29bcf08-9299-8f2c-00bc-791b60658581@gmail.com>
 <93770c6a-5f99-38f6-276b-316c00176cac@gmail.com>
 <20190430004845.GA29722@bogus>
From:   Frank Rowand <frowand.list@gmail.com>
Message-ID: <91fc37e6-aacd-cb67-cf7e-2415a59375a4@gmail.com>
Date:   Mon, 29 Apr 2019 18:15:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430004845.GA29722@bogus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/19 5:48 PM, Rob Herring wrote:
> On Tue, Apr 16, 2019 at 08:01:56PM -0700, Frank Rowand wrote:
>> Hi Rob,
>>
>> On 4/16/19 5:29 PM, Florian Fainelli wrote:
>>>
>>>
>>> On 16/04/2019 13:05, Petr Štetiar wrote:
>>>> From: John Crispin <john@phrozen.org>
>>>>
>>>> Many embedded devices have information such as MAC addresses stored
>>>> inside MTD devices. This patch allows us to add a property inside a node
>>>> describing a network interface. The new property points at a MTD
>>>> partition with an offset where the MAC address can be found.
>>>>
>>>> This patch has originated in OpenWrt some time ago, so in order to
>>>> consider usefulness of this patch, here are some real-world numbers
>>>> which hopefully speak for themselves:
>>>>
>>>>   * mtd-mac-address                used 497 times in 357 device tree files
>>>>   * mtd-mac-address-increment      used  74 times in  58 device tree files
>>>>   * mtd-mac-address-increment-byte used   1 time  in   1 device tree file
>>>>
>>>> Signed-off-by: John Crispin <john@phrozen.org>
>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>> [cleanup of the patch for upstream submission]
>>>> Signed-off-by: Petr Štetiar <ynezz@true.cz>
>>>> ---
>>>
>>> [snip]
>>>
>>>> +static const void *of_get_mac_address_mtd(struct device_node *np)
>>>> +{
>>>> +#ifdef CONFIG_MTD
>>>> +    void *addr;
>>>> +    size_t retlen;
>>>> +    int size, ret;
>>>> +    u8 mac[ETH_ALEN];
>>>> +    phandle phandle;
>>>> +    const char *part;
>>>> +    const __be32 *list;
>>>> +    struct mtd_info *mtd;
>>>> +    struct property *prop;
>>>> +    u32 mac_inc = 0;
>>>> +    u32 inc_idx = ETH_ALEN-1;
>>>> +    struct device_node *mtd_np = NULL;
>>>
>>> Reverse christmas tree would look a bit nicer here.
>>
>> Do we a variable declaration format preference for drivers/of/*?
> 
> We'd better get one. It's all the rage.
> 
> How about fallen Christmas tree:
> 
> 	int a;
> 	bool fallen;
> 	char christmas_tree;
> 	int for_our;
> 	int dt;

Nice!  That is actually the most aesthetically pleasing method I have
seen.  :-)

In the future I will tell people to ignore devicetree review comments
that espouse a declaration religion.  As long as the declarations are
within reason (and sort of follow whatever style is present elsewhere
in the same file).

> 
> Rob
> 

