Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDA7355BA7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhDFSrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhDFSrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:47:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54084C06174A;
        Tue,  6 Apr 2021 11:47:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so8120619pjg.5;
        Tue, 06 Apr 2021 11:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z2kgM1PgzZVysRB66hYtbHLBsINqrqoWRT3DjhTS0xY=;
        b=RKtJ0f48IMtHg4M1XKsTMTeF3UH1QQBYLvLiaIY8/nn//dHujezEGqjYUL9C0uXTg5
         vaquq6Fx/bQ8+NXp+JUv3ialZZCzs0kk0KqrMWSVFNE31FSFcNKjmbeQqs29XYLLrIZr
         DJiSk/J3VLIXXanMbOgHaN7IVEyQUS+Ju2ykG7cRcQArFD+OhSgcVWpzPDqPFjzoGhAZ
         /aeXbdmqFSaSd5kU901dCoVNn57N/mPDs9//fDf2h8HB3121jP+8diIucOJ3aApCE7R/
         QvR5tjcmbyOhb1pqkClJ9FcD2Vbos3Dx33euuUW00XB2I4c+lMbI2MJrHrZK6Xo4aRW7
         bQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z2kgM1PgzZVysRB66hYtbHLBsINqrqoWRT3DjhTS0xY=;
        b=BWyzPUKNLU+FN/wPqL+GN+qcLprIMCZHIv9ce3zEN8kmWXX8i83S6cCWEcWbo32Shh
         8jC73PQVjYrEtbdWtQE93PRlccL8MT1WtTp89HJ/C6giG/wIpSrAoO2pOnHBzaE3gLop
         DjVtjydJUYH6QCIBxfklbpj4k30B5018j+ih6ibIGjSZEMHPQILEMlYGGR9yXG63ENiF
         xOWBWTV9qGKb3ot60A1fWBSb6ScR+qng+TNNSs1pvCqrwWEhDdZncSD7XIiS0amymz9I
         7kC5yEe6+asHGOXMloBAZ9xccyRVqHShVfkoH3DVWBhVnyJC0TRDIF7l77NFw1ZDao1t
         HXMA==
X-Gm-Message-State: AOAM530DHoGRxVfPg0sb4DgoNZSjV/tffI+pN6SqpalAYQiDSx9Ogb4i
        V7NxWFjJLHx+dcbSRJhx6ULWFNwNyiE=
X-Google-Smtp-Source: ABdhPJz41rTIAkSvqZqbTCgZC5nQofm7exxiHGdM5suoYT1AwC4VDxOXtDovBfVhNtnnlyJ1WoBWlg==
X-Received: by 2002:a17:902:c408:b029:e7:3242:5690 with SMTP id k8-20020a170902c408b02900e732425690mr30243330plk.85.1617734832728;
        Tue, 06 Apr 2021 11:47:12 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n5sm19781957pfq.44.2021.04.06.11.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 11:47:12 -0700 (PDT)
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
 <1ceca7ac-ed6f-de73-6afb-34fd0a7e5db3@gmail.com>
 <98f856a8-4c1e-d681-3ea2-0eff6519ccc4@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8be0da0b-827a-7dc9-4c00-36348ca67793@gmail.com>
Date:   Tue, 6 Apr 2021 11:47:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <98f856a8-4c1e-d681-3ea2-0eff6519ccc4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2021 11:43 AM, Heiner Kallweit wrote:
> On 06.04.2021 20:32, Florian Fainelli wrote:
>>
>>
>> On 4/6/2021 4:42 AM, Heiner Kallweit wrote:
>>>
>>> Waiting for ANEG_COMPLETE to be set wouldn't be a good option. Aneg may never
>>> complete for different reasons, e.g. no physical link. And even if we use a
>>> timeout this may add unwanted delays.
>>>
>>>> Do you have any other insights that can help me further locate the issue? Thanks.
>>>>
>>>
>>> I think current MAC/PHY PM handling isn't perfect. Often we have the following
>>> scenario:
>>>
>>> *suspend*
>>> 1. PHY is suspended (mdio_bus_phy_suspend)
>>> 2. MAC suspend callback (typically involving phy_stop())
>>>
>>> *resume*
>>> 1. MAC resume callback (typically involving phy_start())
>>> 2. PHY is resumed (mdio_bus_phy_resume), incl. calling phy_init_hw()
>>>
>>> Calling phy_init_hw() after phy_start() doesn't look right.
>>> It seems to work in most cases, but there's a certain risk
>>> that phy_init_hw() overwrites something, e.g. the advertised
>>> modes.
>>> I think we have two valid scenarios:
>>>
>>> 1. phylib PM callbacks are used, then the MAC driver shouldn't
>>>    touch the PHY in its PM callbacks, especially not call
>>>    phy_stop/phy_start.
>>>
>>> 2. MAC PM callbacks take care also of the PHY. Then I think we would
>>>    need a flag at the phy_device telling it to make the PHY PM
>>>    callbacks a no-op.
>>
>> Maybe part of the problem is that the FEC is calling phy_{stop,start} in
>> its suspend/resume callbacks instead of phy_{suspend,resume} which would
>> play nice and tell the MDIO bus PM callbacks that the PHY has already
>> been suspended.
>>
> This basically is what I just proposed to test.

What you suggested to be tested is to let the MDIO bus PM callbacks deal
with suspending the PHY, which is different from having the MAC do it
explicitly, both would be interesting to try out.

> 
>> I am also suspicious about whether Wake-on-LAN actually works with the
>> FEC, you cannot wake from LAN if the PHY is stopped and powered down.
>>
> phy_stop() calls phy_suspend() which checks for WoL. Therefore this
> should not be a problem.

Indeed, and I had missed that phy_suspend() checks netdev->wol_enabled,
thanks for reminding me.
-- 
Florian
