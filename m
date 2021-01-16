Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A21A2F8F75
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 22:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbhAPVm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 16:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbhAPVmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 16:42:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3A0C061573
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 13:41:44 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 6so5517032wri.3
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 13:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xkw2qrV9Srf5DCrjCoLlRVufrp3GB4z0chKSYYBC1gU=;
        b=ixfHUT8O8KIL6qp8E/x5WgomGVSF/aaZf26vXSSwMl+PiUTzKxDF22Iq+echRl5GZE
         fvr1ilEszi8wzJocftsKrXjxNl2DaTwKbYiEIGzZO0hWLUvOiKrZicVM2uVO5ftgioYq
         xgmd+r4IWGMH2LfmqtqM8dS1lpBRG38m3wbIORjGId4/365xTbcUhx0LGQl8icfm8lho
         dOHPBKdYjYfTPad98taJ1uB338JaG2TaBKyTK1I1pzCoytnEXltWb/3WJJbq20w2oXUx
         TOMKK+ze5thMOneZ9EQZM4y+QuDyTGE/K4AoC3v9VYEJl5OOLKQU0A50vY3pmvB5lBJL
         0aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xkw2qrV9Srf5DCrjCoLlRVufrp3GB4z0chKSYYBC1gU=;
        b=FbjuUExnuiWBkkaGaTzLaXDx06tlk+8nLW6STs1bRbhsZl0aLnwegi5sAAWRtfBwAX
         cZVNqdVB/xOfH5sHI0vi3nKNF/0OaNe+cGF+9eUgWhq/QbIzdvHvHo8BGeZ9rQDwgLJ/
         Iwc6l38ec7usvQvnNnqE96Hoozpzr7D7N2WDxUO+cl4kjS/UrLIGMB4SmFaAbtimIAqo
         RA2rkjaLFP9RhlCBGaK0vmwhH/b0G4CoJrRZr4eUfu0sICmympdHRfY37BS9kYwjdnSH
         MC7Ux7icTHIIX8WlsQygTxOF5amJCKz9CLNN/o9RsJYNz98VkJFEkfV7AEZB0CwO/A33
         3nQg==
X-Gm-Message-State: AOAM530CJbHV0xYJcmTe8/r4V1uKrIhy6Q6El0oOfW6FcDZc7gmxQydH
        G6+1UE4ayVqLmx73JjOcvCeWOaPdbqI=
X-Google-Smtp-Source: ABdhPJyxKuDjctRetIE49U7+DkLzriHH/QpkFSoXoSXFmzI9xiM0dh2flcA9bIW51Uf2OhhdexkMpg==
X-Received: by 2002:adf:94c7:: with SMTP id 65mr18808502wrr.423.1610833303348;
        Sat, 16 Jan 2021 13:41:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5d83:6110:837c:5dcc? (p200300ea8f0655005d836110837c5dcc.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5d83:6110:837c:5dcc])
        by smtp.googlemail.com with ESMTPSA id r1sm20737544wrl.95.2021.01.16.13.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 13:41:42 -0800 (PST)
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
To:     Marek Vasut <marex@denx.de>, Lukas Wunner <lukas@wunner.de>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210116164828.40545-1-marex@denx.de>
 <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
 <a660f328-19d9-1e97-3f83-533c1245622e@denx.de>
 <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
 <20210116203945.GA32445@wunner.de>
 <a6d74297-b29e-956e-5861-40cee359e892@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <de224620-474d-0853-4ddc-a2f88f79fbcc@gmail.com>
Date:   Sat, 16 Jan 2021 22:41:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <a6d74297-b29e-956e-5861-40cee359e892@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.01.2021 22:25, Marek Vasut wrote:
> On 1/16/21 9:39 PM, Lukas Wunner wrote:
>> On Sat, Jan 16, 2021 at 08:26:22PM +0100, Arnd Bergmann wrote:
>>> On Sat, Jan 16, 2021 at 6:56 PM Marek Vasut <marex@denx.de> wrote:
>>>> On 1/16/21 6:04 PM, Arnd Bergmann wrote:
>>>>> On Sat, Jan 16, 2021 at 5:48 PM Marek Vasut <marex@denx.de> wrote:
>>>>
>>>>> I don't really like this version, as it does not actually solve the problem of
>>>>> linking the same object file into both vmlinux and a loadable module, which
>>>>> can have all kinds of side-effects besides that link failure you saw.
>>>>>
>>>>> If you want to avoid exporting all those symbols, a simpler hack would
>>>>> be to '#include "ks8851_common.c" from each of the two files, which
>>>>> then always duplicates the contents (even when both are built-in), but
>>>>> at least builds the file the correct way.
>>>>
>>>> That's the same as V1, isn't it ?
>>>
>>> Ah, I had not actually looked at the original submission, but yes, that
>>> was slightly better than v2, provided you make all symbols static to
>>> avoid the new link error.
>>>
>>> I still think that having three modules and exporting the symbols from
>>> the common part as Heiner Kallweit suggested would be the best
>>> way to do it.
>>
>> FWIW I'd prefer V1 (the #include approach) as it allows going back to
>> using static inlines for register access.  That's what we had before
>> 7a552c850c45.
>>
>> It seems unlikely that a system uses both, the parallel *and* the SPI
>> variant of the ks8851.  So the additional memory necessary because of
>> code duplication wouldn't matter in practice.
> 
> I have a board with both options populated on my desk, sorry.

Making the common part a separate module shouldn't be that hard.
AFAICS it would just take:
- export 4 functions from common
- extend Kconfig
- extend Makefile
One similar configuration that comes to my mind and could be used as
template is SPI_FSL_LIB.
