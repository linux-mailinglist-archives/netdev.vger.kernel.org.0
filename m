Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3482F8228
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbhAORXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbhAORXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:23:02 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF82CC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 09:22:21 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id g10so8260585wmh.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 09:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J7Xhz9mIVP1g6ig1z/h19oazcKHDjN30pMQ+ge7attQ=;
        b=ClkFH5hsVVm61T5nHhrtyhHFgsrRDBXI8SYU89JYIndkz+Ww3YvFKaohzwMXCVsoZg
         aOc4ci9OTw7Z9Buu72ZSOWw3Hzipl9rh+3q+z5rpTZgxEqR1u6zE6ZvzcFyvoqlyIc3c
         NaCo3tJpJJ/hvkjJeSttGnL1bpwfAbJUaROb1qlrnVNGgYsjhHZf7gy2FwRzuIh/wS5C
         dvQxbUTH2+9pub8tVeg08K3zmBcfkEN2dKnLwX6wcyTMBQuRZa3/Pf+KpEuMIlxRg6te
         1XP/fUK+nVLqMOYzfDIHz2JV49bwVhU31XdBsXaJ3AfgkwT06/QB+kSHadz2T4x0IPIt
         vxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7Xhz9mIVP1g6ig1z/h19oazcKHDjN30pMQ+ge7attQ=;
        b=LHLeB8cx3rJ1xcaVvLaSo9MqcRkXzI8aRQXNmuxBojhEV5mtoatrGgGfDrmCjWYh5I
         ZV4TVMeertAkMS2gFicL5QFNVQ0D6RkBR4V/kplaieAAdLwxa4B2wntJdjgBpk0br6Oq
         mjOYndOLQy+d8cdNXnXBtYx/uBtmMAlqf7XRl75CdL3T64X3HrgFRt/t68MBjuDxVra7
         gjj+qiuYuuYnqHiOJj4bWIxmdSz6JCbPLaYO7otdvPRvOoaP/zJ6Vob7ZFE0f2cjxeP6
         O29ncjzayyuityBfq/b79JRIPZm9/196mXRZ2VEK1R1asaMMg1MOr34BgZuARwuiVgfE
         1QCg==
X-Gm-Message-State: AOAM5308jgj3w7ZpCqWTQTKXlbRrfoNCnIP4kFxB59agWOKKRJDGbAo8
        Dlq92qDW11GropimtHpY9oc=
X-Google-Smtp-Source: ABdhPJzDQxMz5a3vfIZMroc2iRCqv3RrV9CZNHtt5l3nIoSzS41XLO+pxjb/zOUxy0AYxotesZ9gPw==
X-Received: by 2002:a05:600c:313:: with SMTP id q19mr9604270wmd.126.1610731340442;
        Fri, 15 Jan 2021 09:22:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:fca3:feb5:3aa8:7dc5? (p200300ea8f065500fca3feb53aa87dc5.dip0.t-ipconnect.de. [2003:ea:8f06:5500:fca3:feb5:3aa8:7dc5])
        by smtp.googlemail.com with ESMTPSA id v4sm16242023wrw.42.2021.01.15.09.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 09:22:19 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>, Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
References: <20210115134239.126152-1-marex@denx.de> <YAGuA8O0lr19l5lH@lunn.ch>
 <e000a5f4-53bb-a4e4-f032-3dbe394d5ea3@denx.de> <YAG79tfQXTVWtPJX@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
Message-ID: <48be7af4-3233-c3dc-70a1-1197b7ad83d7@gmail.com>
Date:   Fri, 15 Jan 2021 18:22:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAG79tfQXTVWtPJX@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.01.2021 16:59, Andrew Lunn wrote:
> On Fri, Jan 15, 2021 at 04:05:57PM +0100, Marek Vasut wrote:
>> On 1/15/21 4:00 PM, Andrew Lunn wrote:
>>> On Fri, Jan 15, 2021 at 02:42:39PM +0100, Marek Vasut wrote:
>>>> When either the SPI or PAR variant is compiled as module AND the other
>>>> variant is compiled as built-in, the following build error occurs:
>>>>
>>>> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
>>>> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
>>>>
>>>> Fix this by including the ks8851_common.c in both ks8851_spi.c and
>>>> ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
>>>> does not have to be defined again.
>>>
>>> DEBUG should not be defined for production code. So i would remove it
>>> altogether.
>>>
>>> There is kconfig'ury you can use to make them both the same. But i'm
>>> not particularly good with it.
>>
>> We had discussion about this module/builtin topic in ks8851 before, so I was
>> hoping someone might provide a better suggestion.
> 
> Try Arnd Bergmann. He is good with this sort of thing.
> 
>     Andrew
> .
> 
I'd say make ks8851_common.c a separate module. Then, if one of SPI / PAR
is built in, ks8851_common needs to be built in too. To do so you'd have
export all symbols from ks8851_common that you want to use in SPI /PAR.
