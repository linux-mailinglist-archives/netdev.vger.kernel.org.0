Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD83C4011DF
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 00:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbhIEVqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 17:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238283AbhIEVqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 17:46:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367B0C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 14:45:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id m28so9540061lfj.6
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 14:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uzTT7u+8B9a7HCpw6zkqtD67jmDiWWQ49J2sucyVY1I=;
        b=hUvI8Du+fKz7GqA4mjeJ5YzFKl8EsVv64QKKRqS+gAQ+2vAJ+9HRYV9bDNHc5ID0XT
         zUy0/XcmSku5OQI55ScUF9TAp/Gn5pJjm4v6m3BemCInWa3O0/ILrVA1oLkbG79hObmw
         LEtEGTyXLi2ZTRE7SATO/zRzI3k9dXJMW0nmhSOqw5K4kNauEOa8QzE52rmNq25prhkc
         9svp1gI9etD+x8dnPcaKjE2XxJP3IwcW7f40aJPmn7fRpj04R4RnDV6DoTOZ7zoJ8FZ4
         /q/dd+jQMVwKWhxstVscMI4d8DPgoWlEt2eM0DDDGcJcWHmfHP5e5pD2O1zVdhpwojfl
         yDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uzTT7u+8B9a7HCpw6zkqtD67jmDiWWQ49J2sucyVY1I=;
        b=W/dbSaZOWFTQ9QkZw5oJTdHI/IPshNspSsFZxBxoPmofFKm5+/E1CKfpPxfx5DMXcL
         eoapPyXAvhqBPyUQFkSk4sMoJFWjHSEKXMgiHRQAkkdCXnQ9Pzr8klfC5jPhhLqPgHLm
         ymLZZDf3XZ8oYaDdu8mXCBM6Awymn5bmQNcLVa5a3PzOIboAG3Oh84bpe/QjI+T7HMfd
         ID86J7TCcTsApO0ar7EwS3tnSnGztN2v3KjVl87ajBhPmmPAdTxe9bcPUa2Z0BKwFb4u
         mdKUi1eksQsjNy0+Oyez5PRevRf4bgNPmHLNC728eYSdcW6Y25m4Y8+Xpx0Un/hZtf68
         lINw==
X-Gm-Message-State: AOAM532qpAptsnNJgezlTIDH4CeS5tUEHb1zRYb/RaMKojbCP+W9JrJ7
        mkkZJbbGM1onCKyFVT5rRsY=
X-Google-Smtp-Source: ABdhPJzE2EDFNV+/AnUoiaumSz1H44rRefHEOBRWDB0qGiCS6fcd6A5zHnVdGWgpTPfCoCVNg4YWVQ==
X-Received: by 2002:a05:6512:228f:: with SMTP id f15mr7188273lfu.253.1630878308875;
        Sun, 05 Sep 2021 14:45:08 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id n3sm570294lft.63.2021.09.05.14.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 14:45:08 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
To:     Florian Fainelli <f.fainelli@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rafal@milecki.pl
References: <20210905172328.26281-1-zajec5@gmail.com>
 <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
 <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <40577a0e-27ce-01c3-2520-ff28885ab031@gmail.com>
Date:   Sun, 5 Sep 2021 23:45:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.09.2021 23:04, Florian Fainelli wrote:
> On 9/5/2021 11:10 AM, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net.git (refs/heads/master):
>>
>> On Sun,  5 Sep 2021 19:23:28 +0200 you wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> Broadcom's b53 switches have one IMP (Inband Management Port) that needs
>>> to be programmed using its own designed register. IMP port may be
>>> different than CPU port - especially on devices with multiple CPU ports.
>>>
>>> For that reason it's required to explicitly note IMP port index and
>>> check for it when choosing a register to use.
>>>
>>> [...]
>>
>> Here is the summary with links:
>>    - net: dsa: b53: Fix IMP port setup on BCM5301x
>>      https://git.kernel.org/netdev/net/c/63f8428b4077
>>
>> You are awesome, thank you!
>> -- 
>> Deet-doot-dot, I am a bot.
>> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> David, can you please wait more than 1h 47 minutes before applying a patch to give a review? This is absolutely not the way this should have been fixed because it adds to the driver's port information burden rather than not.
> 
> This is not the first time this has happened, and this is really really starting to annoy the crap out of me. While I am appreciative of your responsiveness in applying patches, I am definitively not when it comes to not allowing a proper review to happen. So please, I am begging you, wait at least 12h, ideally 24h before applying a patch. You have patchwork, you have responsive maintainers, so nothing will get dropped on the floor.

I was also surprised a bit with that quick apply. I prefer to have my
code reviewed properly.

I'm OK with a revert and working on a better fix (or change for
net-next) if that is a valid option. I can also work on fixing that fix
as I surely don't mean to leave code as is when maintainer isn't happy
about it.
