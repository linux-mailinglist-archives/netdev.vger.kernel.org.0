Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1D318AFD
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBKMks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhBKMhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:37:05 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8236C061574;
        Thu, 11 Feb 2021 04:36:24 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n10so3710402wmq.0;
        Thu, 11 Feb 2021 04:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wvId9QB5MA8DN7Z/Wwn99KHW4uDuXdx8aL5nWnOvqUI=;
        b=KWhn7mo93wQSGNpPerkogAeENqdhj/Jet54/l8HJ9cnyHNJoun/Itg4shkO9w6bbO9
         AYTTuNp8NJbNHMJt0wK2qScEnSjM+rkNgck/SoibYkFKX+yutXwZWpIN7Z3EQaCE6wAh
         xTs36xzMGtlIRCYLZA+ADwd0BBWH3md3eozN/aDxSqfDtKIG7zDLm3dLIJaN5fNunFMm
         66gBFbaXnbHGFsIWEuRiwEjHLbVwuhmfgl2WyP1ld5/DCkMqYhE5sw8klLSZCWsbBl6O
         /T6keqTEASsJ4VKX7Se6Mi/bGFmHsC/fpU3qC/LDtTOOHJJs3K/Ky4Z6G1zUsfSwQCAu
         46eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wvId9QB5MA8DN7Z/Wwn99KHW4uDuXdx8aL5nWnOvqUI=;
        b=t2zqzdBEtNr7WPav7RamrpsK7lIMNZOwgwfSlRiEgmGk3xArCbiQ9wsoa5AAvIY+N7
         yRtuVjV0ushnSzmgJgb5VtF7NhUm49VrNkTrv4MMsfeEoPkFFZm+8s5vi1NvU6dsIPek
         7WjbkH09nua6D1Hte6vAhZSGIvlFkwVCXUrD0GJfnWOWAW3zHlbdip8HYaYzxJ5uORGT
         QKaNLvC1WFfy0tdhHXv3LlToIRu+IvjKOGx6PPR6U17J1LmXAq2RSTZ5zqcmAuIcbQzl
         zkh/uQvMZjx8inH+D78mT7RJ5O/kyWNSpJb+uYRdOjnwYErEFS6LMbTV93Ok1L1xZGnq
         0AwA==
X-Gm-Message-State: AOAM530In2h5mIAYLOA48GgS9sYZLRFFy1R5I245018d1lKnDyUyoqgZ
        NcKGt4a+Zugkzf5ub5MbRqW46A8wlB1tsg==
X-Google-Smtp-Source: ABdhPJx8T464XDkRhixA0ExWSElblHccGwg/e0x7g0npu1eXjQzPj58qbi9uNN18U0FArKY6ORwT0w==
X-Received: by 2002:a1c:6002:: with SMTP id u2mr4868870wmb.83.1613046983117;
        Thu, 11 Feb 2021 04:36:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:60ca:853:df03:450e? (p200300ea8f1fad0060ca0853df03450e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:60ca:853:df03:450e])
        by smtp.googlemail.com with ESMTPSA id u3sm5228983wre.54.2021.02.11.04.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 04:36:22 -0800 (PST)
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        rjw@rjwysocki.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
 <20210114102508.GO1551@shell.armlinux.org.uk>
 <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
 <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com> <20210211121701.GA31708@amd>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <0ac6414e-b785-1f82-94a2-9aa26b357d02@gmail.com>
Date:   Thu, 11 Feb 2021 13:36:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211121701.GA31708@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2021 13:17, Pavel Machek wrote:
> On Thu 2021-01-14 12:05:21, Heiner Kallweit wrote:
>> On 14.01.2021 11:41, Claudiu.Beznea@microchip.com wrote:
>>>
>>>
>>> On 14.01.2021 12:25, Russell King - ARM Linux admin wrote:
>>>>
>>>> As I've said, if phylib/PHY driver is not restoring the state of the
>>>> PHY on resume from suspend-to-ram, then that's an issue with phylib
>>>> and/or the phy driver.
>>>
>>> In the patch I proposed in this thread the restoring is done in PHY driver.
>>> Do you think I should continue the investigation and check if something
>>> should be done from the phylib itself?
>>>
>> It was the right move to approach the PM maintainers to clarify whether
>> the resume PM callback has to assume that power had been cut off and
>> it has to completely reconfigure the device. If they confirm this
>> understanding, then:
> 
> Power to some devices can be cut during s2ram, yes.
> 
Thanks for the confirmation.

>> - the general question remains why there's separate resume and restore
>>   callbacks, and what restore is supposed to do that resume doesn't
>>   have to do
> 
> You'll often have same implementation, yes.
> 

If resume and restore both have to assume that power was cut off,
then they have to fully re-initialize the device. Therefore it's still
not clear to me when you would have differing implementations for both
callbacks.

>> - it should be sufficient to use mdio_bus_phy_restore also as resume
>>   callback (instead of changing each and every PHY driver's resume),
>>   because we can expect that somebody cutting off power to the PHY
>>   properly suspends the MDIO bus before
> 
> If restore works with power cut and power not cut then yes, you should
> get away with that.
> 
> Best regards,
> 								Pavel
> 

Heiner
