Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0221E4011A9
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 23:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhIEVFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 17:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbhIEVFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 17:05:13 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4166AC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 14:04:09 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id p17so2979405qvo.8
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OH16u8lqIoOs6IBmDVCBjsxYmVyEjaXGe8M6wXeXqQo=;
        b=SX5o+ECjbvk6u36MZDFAIlwsL7IMMua+eW749WiwvRwPhgYVfb68eE2RvzCYOMtuB2
         wPbmX7LSUd52da429Lo/zfp0Qs4sUnvOKyVKRLfe6XVADVhIDpIGFDK/fG7KGJ3ozBhm
         K6/VAJrEsbPjAh9PohTeAZj6mSPvX9XzoWzgIHLWNWJYgWUMyb+NZRq0EVVoje+oPcqC
         wZQnjTGGEFBCPuItWOsOtPV/pFOv5/4+NlXkI72FSw/6HiOSxCPmudVsF/Cq4eWUyhKo
         0KLwjyq9UA6NQxykAC0Fo4wHNfbhWYzzuIbMn7jvbQ5FtZNiOl3Twggazyo5V53uJr2x
         wvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OH16u8lqIoOs6IBmDVCBjsxYmVyEjaXGe8M6wXeXqQo=;
        b=mfVmpxnjHqb7tgyOlz8veKmqedmmK55SXl213lT2NIPsgx/ToNl3udpHk6CmAdYVbG
         MONuFXFC7TC/D17tLK+zRp65m9gDQ6DqQqcqOSai72mwZyUiE0tIlGFpdOxdqP09V49T
         aYGP/NiBoOwSAJhq9yLQ9EloNrwjn7UNfhyBf9bU1kovoI7pMgISA/49bUMv2JwIgJtx
         WPBMmpkoGcP8aTpJ/75fZ94B9kqOVfz3AmuYsXH6fNK89beMm2ehFFmmj6OyzhkwxBR2
         Hyrfh5kxtw+DVxg47T1a+i2tVV5zpxzohZVpHOknU2ewyRW36Js5rPPHMlRhKGrUgEjQ
         xB6A==
X-Gm-Message-State: AOAM531i2mSGLq/LiciGkdMQZOl5A5It7w+lW95tnPhEuKn1ms1h7w99
        R4TGgH8N/m6hUfTH8qxduuC3lYTdU0E=
X-Google-Smtp-Source: ABdhPJxNquDpjQplqzUOT/fGvSYF104Z2WpsRWWO+ga/kDToTDpgpbdyxE1j5pAoY133kmgRC1sH7Q==
X-Received: by 2002:a0c:9a08:: with SMTP id p8mr9220970qvd.2.1630875848384;
        Sun, 05 Sep 2021 14:04:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:5d95:1dc7:eeeb:985e? ([2600:1700:dfe0:49f0:5d95:1dc7:eeeb:985e])
        by smtp.gmail.com with ESMTPSA id b19sm4863657qkc.7.2021.09.05.14.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 14:04:07 -0700 (PDT)
Message-ID: <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
Date:   Sun, 5 Sep 2021 14:04:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rafal@milecki.pl
References: <20210905172328.26281-1-zajec5@gmail.com>
 <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2021 11:10 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Sun,  5 Sep 2021 19:23:28 +0200 you wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Broadcom's b53 switches have one IMP (Inband Management Port) that needs
>> to be programmed using its own designed register. IMP port may be
>> different than CPU port - especially on devices with multiple CPU ports.
>>
>> For that reason it's required to explicitly note IMP port index and
>> check for it when choosing a register to use.
>>
>> [...]
> 
> Here is the summary with links:
>    - net: dsa: b53: Fix IMP port setup on BCM5301x
>      https://git.kernel.org/netdev/net/c/63f8428b4077
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

David, can you please wait more than 1h 47 minutes before applying a 
patch to give a review? This is absolutely not the way this should have 
been fixed because it adds to the driver's port information burden 
rather than not.

This is not the first time this has happened, and this is really really 
starting to annoy the crap out of me. While I am appreciative of your 
responsiveness in applying patches, I am definitively not when it comes 
to not allowing a proper review to happen. So please, I am begging you, 
wait at least 12h, ideally 24h before applying a patch. You have 
patchwork, you have responsive maintainers, so nothing will get dropped 
on the floor.

Thank you

PS: for some reason Rafal's email address got turned into: "Rafał 
Miłecki <zajec5@gmail.com>"@ci.codeaurora.org. You might want to look 
into that as well.
-- 
Florian
