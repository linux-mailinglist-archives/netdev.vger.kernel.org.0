Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4082CF91E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 04:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgLEDHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 22:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLEDHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 22:07:31 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00DFC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 19:06:50 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id p126so8556056oif.7
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 19:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xgeA+4/SFeZ/dnoYiCZ3vHNAo1zcqJEb7gFEm6pm+uw=;
        b=ZV+kq0+Rm88lF0ZX7tR49NDDZIwtnyFJtau8IpekY8CZ6PQk9Ug7HT55oDufkknpym
         m1W26k5yERLPkbtkzupxw2RDOh4wMtQMM7SKZyM/YqRrqwWJDqPHn6lF38lGIqoebIcC
         a4/fmiL3RuhdXIQ0MCINbyWK+ws1KV3Vwdv1PL6lWysfoULOGloHIVaK5RXGiJ9fN8Oz
         HT6BsLPUybniywx90bqYkrrnAjaE/4OSKGMhU0crc3h4f58zj3gf+Eeg7hQV3Pm0DRaa
         CNcGsgE3W2a9cRNs103Rdalr4Ir5SN8/ySmlX5FXiJjO5APL5yhsaZZkkjHppzs52Nsp
         8X1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xgeA+4/SFeZ/dnoYiCZ3vHNAo1zcqJEb7gFEm6pm+uw=;
        b=pAUE+Wu2o7j8OgQMHMu0YVjBTC9ka6hZCWI89N2jQAwdpUbPFo8mwuyggucvtJ+QYK
         SVb8XqrIHFEX2czsO3cY5vVqtPk2pUGYMVi9Xizl+bGy/+f6AQyJp0F2TowUt+mL0+Fz
         ejopyDkWY5Wx0XuOvaKkcqdRlVE4xRI5oDvIwlnzigUgYQ8pVRmPjGZSo5sjLXGwgtNM
         bSxH80ZDzn84vIyQvBdbHIA4ofGWnfrGlgO51W0O9Le/161iLwNmMc9zXqT4tliXHgOv
         4O3qQel1uvLfa/kitTGq9Ql6IPjnat785sBpIL+yKVyDAHGGMCYgQV4QO/Qxgs92b2aQ
         luoQ==
X-Gm-Message-State: AOAM531tCsXb0Z1k/tx/INL5uwRezPz5aZwV3btNxfGNBFPbx/yLxyaN
        7793E1vb1ztzuqn4vYljZRKewKBfHU0=
X-Google-Smtp-Source: ABdhPJzbAwGtvVmGFq42wjuL8ec1sW25lVKBEujWWZH3es/GpBTRkz4oPIp7YUXjC0um9lNSktwpDQ==
X-Received: by 2002:aca:b9c4:: with SMTP id j187mr5339183oif.157.1607137608944;
        Fri, 04 Dec 2020 19:06:48 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:6542:25bf:78ae:318e? ([2600:1700:dfe0:49f0:6542:25bf:78ae:318e])
        by smtp.gmail.com with ESMTPSA id f67sm1074529otb.60.2020.12.04.19.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 19:06:48 -0800 (PST)
Subject: Re: net: macb: fail when there's no PHY
To:     Grant Edwards <grant.b.edwards@gmail.com>, netdev@vger.kernel.org
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com> <rq9nih$egv$1@ciao.gmane.io>
 <b842bb79-85c8-3da7-ec89-01dbbab447f5@gmail.com> <rqeslr$qo6$1@ciao.gmane.io>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0740c897-4db9-47f7-3ac9-e9428e634589@gmail.com>
Date:   Fri, 4 Dec 2020 19:06:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <rqeslr$qo6$1@ciao.gmane.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2020 6:52 PM, Grant Edwards wrote:
> On 2020-12-04, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> On 12/2/2020 7:54 PM, Grant Edwards wrote:
>>> On 2020-12-03, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>
>>>> You would have to have a local hack that intercepts the macb_ioctl()
>>>> and instead of calling phylink_mii_ioctl() it would have to
>>>> implement a custom ioctl() that does what
>>>> drivers/net/phy/phy.c::phy_mii_ioctl does except the mdiobus should
>>>> be pointed to the MACB MDIO bus instance and not be derived from the
>>>> phy_device instance (because that one points to the fixed PHY).
>>>
>>> So I can avoid my local hack to macb_main.c by doing a doing a local
>>> hack to macb_main.c?
>>
>> There is value in having the macb driver support the scheme that was
>> just described which is to support a fixed PHY as far as the MAC link
>> parameters go, and also support registering the MACB internal MDIO bus
>> to interface with other devices. People using DSA would typically fall
>> under that category.
> 
> My hack does support both a fixed PHY as far as the MAC link
> parameters go and allows interfacing with other devices via the mdio
> bus, so I assume you're saying that there's value in doing that in the
> "standard" way instead of the way I invented 10 years ago.

All I was doing was explaining how this can be done today, in a way that
is useful to you and other people. You want to keep doing things your
own way, go ahead.

> 
> That would certainly be true if we were talking about something to be
> incorporated "upstream", but like you said: it would be a local
> hack. I see no intrinsic value in changing to the "standard" DSA
> scheme. Switching to a different API would actually create additional
> cost above and beyond the cost of writing and testing the new local
> hack, since all of the applications which need to access the mdio bus
> would also have to change.

I was not trying to convince you to switch to DSA, and if this is an
area of technical debt that has a low cost for your platform compared to
others, so be it. What could have been useful was to support the
standard fixed PHY plus the internal MDIO bus.

> 
> If I could avoid the local hack completely by using a standard,
> existing feature and API, then I could make an arguement for modifying
> the applications. But proposing the writing of a new, more comlex
> local hack and modifying the applications just so that we can feel
> good about using a standard API would be laughed at.

Only you can be the judge of that, I have no visibility into what
constitutes an acceptable change and what does not.

> 
>> [...]
>>
>> I don't have a dog in the fight, but dealing myself with cute little
>> hacks in our downstream Linux kernel, the better it fits with useful
>> functionality to other people, the better.
> 
> I don't see why it makes any difference how well suited a local hack
> is to people who will never see it or use it. It would seem to me that
> the the most important attribute of a local hack would be simplicity
> and ease of understanding.  My hack is 7 lines of code and one line of
> a static structure declaration and initializer, all
> enabled/disabled/controlled by a single preprocessor symbol.

A change can be 7 lines of code and be broken any time you update to a
newer version of the kernel, and that is probably even truer in your
case since you have such a big difference between 2.6.x and 5.4 that
anything in between could have been rewritten a dozen time.

Over the course of the past 6 years, we have managed to get our
downstream kernel from ~1300 patches downstream to only about 65 as of
5.10, but it took 6 years and counting and we only targeted LTS kernels.
Maybe I am overly sensitive to how maintainable a change is, who knows.
-- 
Florian
