Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F353BE13C
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 04:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhGGCyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 22:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhGGCyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 22:54:13 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9BAC061574;
        Tue,  6 Jul 2021 19:51:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d12so873450pfj.2;
        Tue, 06 Jul 2021 19:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EM+HblrX6Dd6jOO1AOC7ZDRiWs65bn7u74iuMMFxspg=;
        b=Rm5j9oJOIelp9RRap/KFMSuIWI76rb/TMHaQgZ8Qxau1o3tK+/hrL/HQKLkGB1Y3Mw
         2YNG8h14xg6/FFUy0SOBOHIxszutrWWsW8dlKhPUG8rc6t+IE7J5lxnascd/rH+r7X8O
         qB02sWfSTu+shfTkdxGR1LjsxlOuLWIxOUWu9QdrfbgZgobImzvelq437Vbwg9HORaVz
         LUJyxYIMI376VaZBOaEBbsMgRZn1rQSKZRNFntVsUV2LzgLS+HM84vOgwz8bBUSO4oOk
         U0OSDs+urJvak7zVrzo2Q1FXR/UErlpTfWWHWeOPhcnF3xlo8tjFQg9bnIWH2s2EcSiP
         mOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EM+HblrX6Dd6jOO1AOC7ZDRiWs65bn7u74iuMMFxspg=;
        b=aiXtPgjKtm1eVmo4Xj9HU7LyOjZFnP5HizisRsFrRHS+Q0hmrM/Ge0ByVtTTIYQWV9
         rCFRzCwDk6csmegYZW7sz7wxCv+Seua5imjqTWpaouXZjWfFSkvcYLFueEvR+tb2exry
         FZuNPLRWYHMALoA4empvNtPducjyB5k+k0BdB1EZP+nPXWlw2K5vNf4nxoZWjmXp2XMG
         OUNrz+83x+jI1q61MbAOtAMpA/YehWRcmT8m8Sm2hqwN+4baXGy6IecLPr7aG13cxEZw
         MENUYtxQbYGGsrc6bokYHksm6Cvi23z+id6LHcelUecr66vdTdlSvgh6feOsytQ6/mqY
         2w3w==
X-Gm-Message-State: AOAM530TBWBUdrwjp372D4HgmuHJF2zbxXRiTq0+2hahCqgXwjBdUnKw
        ZqI+Jx2i2YEVry43plClqBg=
X-Google-Smtp-Source: ABdhPJyO6LQ48a7OVQNoyOGBRSdFKqbNqtSZOYHdkCK8zTc9l6iyGOOriiEz1Cve9Mb+mExYP13LSw==
X-Received: by 2002:a05:6a00:d5b:b029:315:339c:343f with SMTP id n27-20020a056a000d5bb0290315339c343fmr22856118pfv.67.1625626294113;
        Tue, 06 Jul 2021 19:51:34 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n26sm20184860pgd.15.2021.07.06.19.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 19:51:33 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: skip disabling interrupt when WOL is
 enabled in shutdown
To:     Andrew Lunn <andrew@lunn.ch>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
References: <20210706090209.1897027-1-pei.lee.ling@intel.com>
 <YORXMSmvqwYg7QA9@lunn.ch>
 <CO1PR11MB4771EF640CBB88E9D96693FFD51A9@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YOT75ZvoB0qnsK6W@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc1b6368-356f-0a8f-b461-1ed19a628a3a@gmail.com>
Date:   Tue, 6 Jul 2021 19:51:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOT75ZvoB0qnsK6W@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2021 5:57 PM, Andrew Lunn wrote:
> On Wed, Jul 07, 2021 at 12:36:30AM +0000, Ismail, Mohammad Athari wrote:
>>
>>
>>> -----Original Message-----
>>> From: Andrew Lunn <andrew@lunn.ch>
>>> Sent: Tuesday, July 6, 2021 9:14 PM
>>> To: Ling, Pei Lee <pei.lee.ling@intel.com>
>>> Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
>>> <linux@armlinux.org.uk>; davem@davemloft.net; Jakub Kicinski
>>> <kuba@kernel.org>; Ioana Ciornei <ioana.ciornei@nxp.com>;
>>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Voon, Weifeng
>>> <weifeng.voon@intel.com>; vee.khee.wong@linux.intel.com; Wong, Vee Khee
>>> <vee.khee.wong@intel.com>; Ismail, Mohammad Athari
>>> <mohammad.athari.ismail@intel.com>
>>> Subject: Re: [PATCH net] net: phy: skip disabling interrupt when WOL is enabled
>>> in shutdown
>>>
>>> On Tue, Jul 06, 2021 at 05:02:09PM +0800, Ling Pei Lee wrote:
>>>> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
>>>>
>>>> PHY WOL requires WOL interrupt event to trigger the WOL signal in
>>>> order to wake up the system. Hence, the PHY driver should not disable
>>>> the interrupt during shutdown if PHY WOL is enabled.
>>>
>>> If the device is being used to wake the system up, why is it being shutdown?
>>>
>>
>> Hi Andrew,
>>
> 
>> When the platform goes to S5 state (ex: shutdown -h now), regardless
>> PHY WOL is enabled or not, phy_shutdown() is called. So, for the
>> platform that support WOL from S5, we need to make sure the PHY
>> still can trigger WOL event. Disabling the interrupt through
>> phy_disable_interrupts() in phy_shutdown() will disable WOL
>> interrupt as well and cause the PHY WOL not able to trigger.
> 
> This sounds like a firmware problem. If linux is shutdown, linux is
> not controlling the hardware, the firmware is. So the firmware should
> probably be configuring the PHY after Linux powers off.

There are platforms supporting S5 shutdown that don't run firmware and 
would also expect to be able to be woken-up from an Ethernet 
PHY/Wake-on-LAN scheme.

The problem that is being addressed here is that even if your Ethernet 
driver was playing through properly and attempting not to disable the 
Ethernet PHY in suspend or shutdown callback, that decision would be 
overridden by phy_shutdown() when the MDIO bus' shutdown is called and 
that breaks up that wake-up mode.

> 
> If Linux is suspended, then Linux is still controlling the hardware,
> and it will not shutdown the PHY.


-- 
Florian
