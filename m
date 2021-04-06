Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96A355B71
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbhDFScc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238552AbhDFSc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:32:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC0EC06174A;
        Tue,  6 Apr 2021 11:32:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so10157121pjb.0;
        Tue, 06 Apr 2021 11:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UmWt6M/ZRKwEOfngrjw52Zw14aH1E2PhPy2y2RZ2aS8=;
        b=SBTt7uAOa5BGcK7O7k8HpzXJRcBP50VHH37Ij3iS6VEEju7Fj9ciVCfVQxtbvQaYRg
         11b98f9pbevxQpijAeIhIWh+Toit7Owp9f1Ox0DQgCPhPmjR2v13Xh5Q2UrdvOf4KF1d
         U/Cq+WC9QBgh6rEbGLAI6oXwOPcn9iyeOmVqyt0R8q+v2Co599eR3V4d9naySKBGgclQ
         xJV12jW0fegPNJ9jM84V8KPRHS8l1gKxqS0Y1P/h0BBAxiEwiCBhej58Iw/W6d6Wvi1T
         SHlNW6kcArGpzMfggLgtSyTKcE7h324NbhiyI1uOrfd5zE9aftWX1GQpgCrBsZEPVbv6
         6M3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UmWt6M/ZRKwEOfngrjw52Zw14aH1E2PhPy2y2RZ2aS8=;
        b=ThvGPZ7uVt4ZHtQD1JiKzkWqCVPXN1503fqB1NeZRfFxh5rhoEjEHn8/cUfL+oSV6m
         SOKKE9QH+UXhyj98PYa37nr1kL5NCiISSFtaO7j/rxeB6xCwhff1ifqRydNIGhncWTxx
         IpE1G6MgTy60567sdwvGGTRmZ9PXWuVqKLSauvyi9cIzcfzdJnl6tbR8KyCEEpIrO3lA
         BwUqd9uEtGdFM01eC8nX5VrHmwfOOEfuW3QDweQvk9chg9fPzFRbHLAu/sH0qBofuHYs
         fkhfFUN06EXLbpZdDF+4IV1m/NvfdVQ36Db937o8NfbCcCD+/ez+Yd93++jSoFzxN+06
         m/xg==
X-Gm-Message-State: AOAM532HnbJZ1d59J07WAedGLigz8ii4O1WDN3CCTsPfR7a3akbt0gyr
        Rju//ONLZISTyMFKiEaVg/fkOs6R7Tw=
X-Google-Smtp-Source: ABdhPJxAutyGTBgI08EPJYXoqutLphoYTshQcgBVmJm3dyg5M0XQ6tqkElS1pg8BW42jRMHVCuInnw==
X-Received: by 2002:a17:90a:a47:: with SMTP id o65mr5798881pjo.179.1617733940866;
        Tue, 06 Apr 2021 11:32:20 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o13sm19746658pgv.40.2021.04.06.11.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 11:32:20 -0700 (PDT)
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
To:     Heiner Kallweit <hkallweit1@gmail.com>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1ceca7ac-ed6f-de73-6afb-34fd0a7e5db3@gmail.com>
Date:   Tue, 6 Apr 2021 11:32:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <b34ccbf5-18eb-681b-3336-4c93325c2a43@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2021 4:42 AM, Heiner Kallweit wrote:
> 
> Waiting for ANEG_COMPLETE to be set wouldn't be a good option. Aneg may never
> complete for different reasons, e.g. no physical link. And even if we use a
> timeout this may add unwanted delays.
> 
>> Do you have any other insights that can help me further locate the issue? Thanks.
>>
> 
> I think current MAC/PHY PM handling isn't perfect. Often we have the following
> scenario:
> 
> *suspend*
> 1. PHY is suspended (mdio_bus_phy_suspend)
> 2. MAC suspend callback (typically involving phy_stop())
> 
> *resume*
> 1. MAC resume callback (typically involving phy_start())
> 2. PHY is resumed (mdio_bus_phy_resume), incl. calling phy_init_hw()
> 
> Calling phy_init_hw() after phy_start() doesn't look right.
> It seems to work in most cases, but there's a certain risk
> that phy_init_hw() overwrites something, e.g. the advertised
> modes.
> I think we have two valid scenarios:
> 
> 1. phylib PM callbacks are used, then the MAC driver shouldn't
>    touch the PHY in its PM callbacks, especially not call
>    phy_stop/phy_start.
> 
> 2. MAC PM callbacks take care also of the PHY. Then I think we would
>    need a flag at the phy_device telling it to make the PHY PM
>    callbacks a no-op.

Maybe part of the problem is that the FEC is calling phy_{stop,start} in
its suspend/resume callbacks instead of phy_{suspend,resume} which would
play nice and tell the MDIO bus PM callbacks that the PHY has already
been suspended.

I am also suspicious about whether Wake-on-LAN actually works with the
FEC, you cannot wake from LAN if the PHY is stopped and powered down.
-- 
Florian
