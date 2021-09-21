Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86714131F8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhIUKx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhIUKxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 06:53:53 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27344C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 03:52:25 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id b15so61309793lfe.7
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 03:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KKm16cSXV3cl+gR7cQeGHU11Cyw0s2BVuTVz4qETJDo=;
        b=n8QTkwBzkeUnotImNN12+ggbFcMy6PGGEk7uXCUMfXAWpfwSloS6xZcA9ffl+ysksd
         g8mqkW6u5pqLjG5QDRrBaLbnbNpwtigvjsQ5KfoMxUbOGBgyXlw4HDI18ZBaLSP/Mceo
         PRBj3cX+2FoNNJbksPIbeLiy69EmUo1z65coJtpkyA28tMv9jtD42o9uQ5uR4YB6Klcq
         XaEcjgwYbrrI66Jhed2+1gO+XGf+RvZLzAIYvFjxgzJDydCKOyxXkyiqa+iZjhoNkcUd
         8LgusrFjj+M8JMkrjDsJxjm9ShHp8gUT3RP+CqA4dKR3hW0pqph3VRAbdDX8OS2ixfjK
         DgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KKm16cSXV3cl+gR7cQeGHU11Cyw0s2BVuTVz4qETJDo=;
        b=5JHrqJkqP+lMqRd8a8dhtnM3KKQdteKf3qvMKKoRyPhBPl6wjcNScXcTQ7XgiWhldX
         +GUDN0VDnkAUh8Du+A75q08op0zW5Sfp57AF3jTEZUE5vz3gxq6H9mRTJAePJOgDqzLr
         ck4hhhUWQvoiSQNGwTniz6tTPK+z2RgRG35xzlsVe8sjWRLA6JXyBVCjtEeu339B2Lh4
         X/yZwGMVKEwPrrjRqiweK2RJC/JW22LPqfhOl4Q3g1hA0t6mUKfIgMu7YjPQtWGPdTb+
         VwXTXaR12+lZL5WfA433Hz4J5lK11iZtCgA8+BXzebKLIzZpmaXkEqY67wNmxuLZMmEr
         bFwA==
X-Gm-Message-State: AOAM533qFhG/GJuQpH0Zj4Y7yLE02EECD84wDqU26Tw21q2PNiwi4xpl
        yMd0FD+71p8FtOF0wTfC2p0=
X-Google-Smtp-Source: ABdhPJyu/9Mj3xvV9w4TRVouF8j/wq75WiwKZZAD4HCknhfnBwcVHV2mdw7Ev4/6OqZMmg0fEC24Yg==
X-Received: by 2002:ac2:4106:: with SMTP id b6mr22813274lfi.89.1632221543549;
        Tue, 21 Sep 2021 03:52:23 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id e3sm616479ljo.2.2021.09.21.03.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 03:52:23 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
 <20210920180240.tyi6v3e647rx7dkm@skbuf>
 <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
 <20210920181727.al66xrvjmgqwyuz2@skbuf>
 <d2c7a300-656f-ffec-fb14-2b4e99f28081@gmail.com>
 <9a9b648c-2867-bdf8-8f6b-086d459419a8@gmail.com>
Message-ID: <9043d467-bf5d-5800-8c4c-8d9dac636cb2@gmail.com>
Date:   Tue, 21 Sep 2021 12:52:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9a9b648c-2867-bdf8-8f6b-086d459419a8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.09.2021 11:45, Rafał Miłecki wrote:
> On 20.09.2021 20:25, Florian Fainelli wrote:
>> On 9/20/21 11:17 AM, Vladimir Oltean wrote:
>> [snip]
>>>> All I am saying is that there is not really any need to come up with a
>>>> Device Tree-based solution since you can inspect the mdio_device and
>>>> find out whether it is an Ethernet PHY or a MDIO device proper, and that
>>>> ought to cover all cases that I can think of.
>>>
>>> Okay, but where's the problem? I guess we're on the same page, and
>>> you're saying that we should not be calling bcma_mdio_mii_register, and
>>> assigning the result to bgmac->mii_bus, because that makes us call
>>> bcma_phy_connect instead of bgmac_phy_connect_direct. But based on what
>>> condition? Simply if bgmac->phyaddr == BGMAC_PHY_NOREGS?
>>
>> Yes simply that condition, I really believe it ought to be enough for
>> the space these devices are in use.
> 
> I'm afraid I got lost somewhere in this discussion.
> 
> If we don't call bcma_mdio_mii_register() (as suggested in quoted
> e-mail) then MDIO device 0x1e won't get created and "bcm53xx"
> (b53_mdio.c) won't ever load.

I did a quick test and replaced bcma_phy_connect with
bgmac_phy_connect_direct.

That fixes the problem for me.

So I guess we should:
1. Leave the bcma_mdio_mii_register() call
2. Use bcma_phy_connect() only for real PHY device

Correct me if I'm wrong please.
