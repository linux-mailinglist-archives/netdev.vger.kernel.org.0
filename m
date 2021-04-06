Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789FF355B99
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbhDFSni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhDFSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:43:33 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1604C06174A;
        Tue,  6 Apr 2021 11:43:24 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so1515471wmq.1;
        Tue, 06 Apr 2021 11:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bmJ/NMJPsfNKo4mJ/3aPWwsMGqay1obgGTuBfQrC1A0=;
        b=blORM0ejITE3SmIXDzz6Q0ooiaW1YJ5cdGLw2KlViB3sZ6IKgb53yjOmkal7QPhu71
         +JN5enKCiNbwEHo28HiaEORuXOZ0JLf+5tGdV0GbYZckebybPUF7SLQv+NL6phm92agF
         vgPnUQYS/+ub8Zlno7si6Q1J1sjmJ7IFONQsd2xSSwsW78EbrkysUu0EoaPZreZlSTl6
         /Ver5OJBK0WVqiwBlshRVTkJMN6hEVtP0qMJky3odQq56uCsv1FhNEFPdkWXbLYPfhMJ
         RXjaR55HpCDWghsTyRRoJig5I0euSoz9o+oyTVeanwINj5ppyslFcw66ZW9ffesa/U9B
         I1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmJ/NMJPsfNKo4mJ/3aPWwsMGqay1obgGTuBfQrC1A0=;
        b=T/QFWRx9ZLJjXplwJdQg/QnVui6LyIgZdvqXEbBCY/Q+hNLU3nF8hOuxDj5ZJ1mMGu
         6/9Z2nCmxXmZihQdhdmDe81GxNXREBdjzmlFq4ZbznBMwTMhUAYFGgYbdHdiyXGlOpRA
         FR62bUCe2xazbhhrP/FZbQxps1qDSwHkPikjXo0ngZCzkEnI1U9M6BGhFIPIWJ6RG8m0
         VgJRi2yb9w93SNpjL+joXZKmMQttWlWKwdjvnnQKkIerSvl9a+EXV9mburP1oXnb31we
         6nOGpijq4rVDp4dmzVQyWi6mHHBCk37fx/PeL2Jd49ht0jbG6kSK3f/DFLHzOYoPSACE
         +f4w==
X-Gm-Message-State: AOAM533Gsu0wJH+tTfnyj1cDhS/DLZJxtt3H+pOcnW1l6SyNd9HIQ0+D
        m/e7+Dm1yfPanaXmIlMyx0nS+wQqvFNLBw==
X-Google-Smtp-Source: ABdhPJzUyEhuO4iyKnQ2WTrNcgiidnxSgqyD8mpdDUj7O6hAg9cmOLEORNTX1iFSW5ctEI6+fbNsNA==
X-Received: by 2002:a1c:7ec4:: with SMTP id z187mr5418176wmc.3.1617734603418;
        Tue, 06 Apr 2021 11:43:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:c412:abea:9d68:569f? (p200300ea8f1fbb00c412abea9d68569f.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:c412:abea:9d68:569f])
        by smtp.googlemail.com with ESMTPSA id v14sm33856964wrd.48.2021.04.06.11.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 11:43:22 -0700 (PDT)
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "christian.melki@t2data.com" <christian.melki@t2data.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
 <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
 <ff5719b4-acd7-cd27-2f07-d8150e2690c8@t2data.com>
 <010f896e-befb-4238-5219-01969f3581e3@gmail.com>
 <DB8PR04MB6795CC9AA84D14BA98FB6598E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0e6bd756-f46c-7caf-d45b-a19e7fb80b67@gmail.com>
 <DB8PR04MB6795D52C6FA54D17D43D1E99E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <b34ccbf5-18eb-681b-3336-4c93325c2a43@gmail.com>
 <1ceca7ac-ed6f-de73-6afb-34fd0a7e5db3@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Message-ID: <98f856a8-4c1e-d681-3ea2-0eff6519ccc4@gmail.com>
Date:   Tue, 6 Apr 2021 20:43:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1ceca7ac-ed6f-de73-6afb-34fd0a7e5db3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.04.2021 20:32, Florian Fainelli wrote:
> 
> 
> On 4/6/2021 4:42 AM, Heiner Kallweit wrote:
>>
>> Waiting for ANEG_COMPLETE to be set wouldn't be a good option. Aneg may never
>> complete for different reasons, e.g. no physical link. And even if we use a
>> timeout this may add unwanted delays.
>>
>>> Do you have any other insights that can help me further locate the issue? Thanks.
>>>
>>
>> I think current MAC/PHY PM handling isn't perfect. Often we have the following
>> scenario:
>>
>> *suspend*
>> 1. PHY is suspended (mdio_bus_phy_suspend)
>> 2. MAC suspend callback (typically involving phy_stop())
>>
>> *resume*
>> 1. MAC resume callback (typically involving phy_start())
>> 2. PHY is resumed (mdio_bus_phy_resume), incl. calling phy_init_hw()
>>
>> Calling phy_init_hw() after phy_start() doesn't look right.
>> It seems to work in most cases, but there's a certain risk
>> that phy_init_hw() overwrites something, e.g. the advertised
>> modes.
>> I think we have two valid scenarios:
>>
>> 1. phylib PM callbacks are used, then the MAC driver shouldn't
>>    touch the PHY in its PM callbacks, especially not call
>>    phy_stop/phy_start.
>>
>> 2. MAC PM callbacks take care also of the PHY. Then I think we would
>>    need a flag at the phy_device telling it to make the PHY PM
>>    callbacks a no-op.
> 
> Maybe part of the problem is that the FEC is calling phy_{stop,start} in
> its suspend/resume callbacks instead of phy_{suspend,resume} which would
> play nice and tell the MDIO bus PM callbacks that the PHY has already
> been suspended.
> 
This basically is what I just proposed to test.

> I am also suspicious about whether Wake-on-LAN actually works with the
> FEC, you cannot wake from LAN if the PHY is stopped and powered down.
> 
phy_stop() calls phy_suspend() which checks for WoL. Therefore this
should not be a problem.
