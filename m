Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C95D2EA129
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbhADXxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbhADXxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:53:24 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E5DC061574;
        Mon,  4 Jan 2021 15:52:42 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r4so786824wmh.5;
        Mon, 04 Jan 2021 15:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BRM9BzjeAFWjl1pR2n3iRc4+aNsc/ikIOGAtDOI9KFA=;
        b=uyQhA1uOBkk/c5MOEmyz2FkFnRLfJTKmkTG0E/ragudWkTP4HSgPz5dImFqveUP9Te
         jAr9RGextMp/o09/zaF3dk5b1dEr86oWR9c7SqEkRn7wKRKwivQcoABFC6xmyF/Lw8Ox
         /b+/YCGEU26cvrXqX/1lBsR6Fjv5GwAeaNKItWgndCVQDv8p76SIYDBTZjsaB+E5yhOQ
         +UW2EbzgzUyi6ilxz0CbqljHHHmLgu265ns4UxsYbwi2CSrznuPxtf9YiZz7Ut5kv743
         JPTMlphevQ2WjRFOYa1/v/gbzoBZGLaQFI3wPcxO0c3lUbqkauW7j7q2JpFJATpSaXGW
         68Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BRM9BzjeAFWjl1pR2n3iRc4+aNsc/ikIOGAtDOI9KFA=;
        b=BxVAYq/6zXFCuykKhLu9IfhNn+c1vH0rykiC5jWKijq6n0PKhyh3sSiV/mWn4bJNg2
         Msd4WjHytFyWSBfpn36I7S5gCy/uQDoFUh+EGVwmW1KI8++aqUwVAc9VlmpIMxU6D4E7
         lK9Yrp3cETbQUxT8rp+p+zoi1LKRLGQG28P8H8vKrfD1Zcdnnu20hE7k+FuFoGUVwPjb
         5JDZM5myQTiq7/Y7fXdD0+BHSH1ONZW98RMc8NFxKL6rGGV/UQCEs1SlmSOO2CavLpD+
         zWnGs4+gTiuk+wMz/+6bFVZ1tuQBoRG2c7qFbxl1fCsUdaih+lArgX1aSDsDsWrkPosU
         lkdA==
X-Gm-Message-State: AOAM531JDGnDKj4JXM716K+IrAkWRhDz5A7Ty2U8aWbOljhXR5pM2aFm
        ALHTJtwgWABW4F55K1ivlJkUYMW2Zqo=
X-Google-Smtp-Source: ABdhPJyrmSsz9yrnAaWAcLqURuJW8dc5qgDZTgNVqd3ZHYzIENPTIrUnKQh7q1wQ5NIksOJDxbjVrg==
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr555559wml.99.1609793329671;
        Mon, 04 Jan 2021 12:48:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:7409:b966:5a79:f8df? (p200300ea8f0655007409b9665a79f8df.dip0.t-ipconnect.de. [2003:ea:8f06:5500:7409:b966:5a79:f8df])
        by smtp.googlemail.com with ESMTPSA id c4sm831916wmf.19.2021.01.04.12.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 12:48:49 -0800 (PST)
Subject: Re: [Aspeed, v1 1/1] net: ftgmac100: Change the order of getting MAC
 address
To:     Hongwei Zhang <hongweiz@ami.com>, linux-aspeed@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
References: <20201221205157.31501-2-hongweiz@ami.com>
 <20210104172807.20986-1-hongweiz@ami.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <398f22ee-62ed-5fd6-1d4d-119c405d7f34@gmail.com>
Date:   Mon, 4 Jan 2021 21:48:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104172807.20986-1-hongweiz@ami.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.01.2021 18:28, Hongwei Zhang wrote:
> 
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Monday, December 28, 2020 5:01 PM
>>
>> On Tue, 22 Dec 2020 22:00:34 +0100 Andrew Lunn wrote:
>>> On Tue, Dec 22, 2020 at 09:46:52PM +0100, Heiner Kallweit wrote:
>>>> On 22.12.2020 21:14, Hongwei Zhang wrote:
>>>>> Dear Reviewer,
>>>>>
>>>>> Use native MAC address is preferred over other choices, thus change the order
>>>>> of reading MAC address, try to read it from MAC chip first, if it's not
>>>>>  availabe, then try to read it from device tree.
>>>>>
>>>>> Hi Heiner,
>>>>>
>>>>>> From:  Heiner Kallweit <hkallweit1@gmail.com>
>>>>>> Sent:  Monday, December 21, 2020 4:37 PM
>>>>>>> Change the order of reading MAC address, try to read it from MAC chip
>>>>>>> first, if it's not availabe, then try to read it from device tree.
>>>>>>>
>>>>>> This commit message leaves a number of questions. It seems the change isn't related at all to the
>>>>>> change that it's supposed to fix.
>>>>>>
>>>>>> - What is the issue that you're trying to fix?
>>>>>> - And what is wrong with the original change?
>>>>>
>>>>> There is no bug or something wrong with the original code. This patch is for
>>>>> improving the code. We thought if the native MAC address is available, then
>>>>> it's preferred over MAC address from dts (assuming both sources are available).
>>>>>
>>>>> One possible scenario, a MAC address is set in dts and the BMC image is
>>>>> compiled and loaded into more than one platform, then the platforms will
>>>>> have network issue due to the same MAC address they read.
>>>>>
>>>>
>>>> Typically the DTS MAC address is overwritten by the boot loader, e.g. uboot.
>>>> And the boot loader can read it from chip registers. There are more drivers
>>>> trying to read the MAC address from DTS first. Eventually, I think, the code
>>>> here will read the same MAC address from chip registers as uboot did before.
> 
> Thanks for your review, Heiner,
> 
> I am working on a platform and want to use the method you said, reading from DTS
> is easy, but overwrite the MAC in DTS with chip MAC address, it will change the
> checksum of the image. Would you please provide an implementation example?
> 
One example is the igb driver. That's the relevant code snippet:

if (eth_platform_get_mac_address(&pdev->dev, hw->mac.addr)) {
	/* copy the MAC address out of the NVM */
	if (hw->mac.ops.read_mac_addr(hw))
		dev_err(&pdev->dev, "NVM Read Error\n");
}

And I'm not sure the image checksum is relevant here. The boot loader
dynamically replaces the MAC address before handing over the DTS to
Linux kernel. At that time an image checksum shouldn't be relevant.
Who would be supposed to check it?

> Thanks!
>>>
>>> Do we need to worry about, the chip contains random junk, which passes
>>> the validitiy test? Before this patch the value from DT would be used,
>>> and the random junk is ignored. Is this change possibly going to cause
>>> a regression?
> 
> Hi Andrew,
> 
> Thanks for your review. Yes, yours is a good point, as my change relies on
> the driver's ability to read correct MAC from the chip, or the check of
> is_valid_ether_addr(), which only checking for zeros and multicasting MAC.
> On the other hand, your concern is still true if no MAC is defined in DTS
> file.
> 
> Thanks!
>>
>> Hongwei, please address Andrew's questions.
>>
>> Once the discussion is over please repost the patches as
>> git-format-patch would generate them. The patch 2/2 of this
>> series is not really a patch, which confuses all patch handling
>> systems.
>>
>> It also appears that 35c54922dc97 ("ARM: dts: tacoma: Add reserved
>> memory for ramoops") does not exist upstream.
>>
> 
> Hi Jakub,
> 
> Thanks for your review; I am quite new to the contribution process. I will resubmit my
> patch with the SHA value issue fixed. Please see my response at above.
> 
> --Hongwei
> 

