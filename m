Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77402E7B2B
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgL3Qy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgL3Qy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:54:29 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA611C061799;
        Wed, 30 Dec 2020 08:53:48 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m5so17902224wrx.9;
        Wed, 30 Dec 2020 08:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4+FCAThIBIBFdy0r2/jkB586OQFEipavyVIcBnethw0=;
        b=mqmIhO72s60cwuD0oDiVpSfkhde9VyeMYqzZmMbbb+eDtuKVl/3X7LzWlOXpy67/6y
         9m7M9SFoPODnL++6qWDJ8hm6XIkOSRcXc3uNN/LLcjoVJLfPC+gsWlJc+0yeYCxia8R3
         0tIY/fZqTj5I0BX5K+sW15CMR+re1GoqtfZv6B6wdx5nIxgXBCa+vn5QGyPNJjM40ejv
         10z8bASFSoEt9jCBr3v6yNjCktAcZOE7JWFg/a0BkKfRpOSFRq+6J2QJ0wz42Ar8j4d1
         lfbXl9ynI3fLR1HbBJpfuEcbPYwtQ5g2ejz1ErOzvcKp7lW3YRMEwiO22QhQFvouJoDo
         4Cyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4+FCAThIBIBFdy0r2/jkB586OQFEipavyVIcBnethw0=;
        b=Yr+VODHoAvQx9lWRSOVu2tV2OxipWNenaqWry9b3c4xclpupvhBnLh0ebvs58frRh9
         2O0gJptEZ3uynPfC7lBS8ymbI4rESDq4k7PUqQ0q0oou9hDy5P8TCSmYOMHfi6iiUQN3
         FIgZjMzuLRZN+cE+85mVt/V9/XQ9+cMpsKAQHPxJLexfW7iOufMwSPw7JMprDERHZ4LF
         m+zY+aX8y6EgVXD/sL7r+QKPaiffC4/Ogy++8HS5QLTt/oLXGO3QNzSyp87DPpGXxfpt
         Lb3PpR3ofT+ITKDxN4Msu2hiDaxqigIwwb7cPuENxHKgTpZBBgyX/yOEFTHOtPLTG28F
         TsCQ==
X-Gm-Message-State: AOAM531xNk4oHeonpei4BtFMViy41U9BRsu34tvltHhWsuE+BbA/p3bo
        bKV1w9SDEO5Wix/vY7liIyae9I6z3RY=
X-Google-Smtp-Source: ABdhPJwSv/9ZnH6VH/dRJu04QXa1elZhFfM8JLE/J/KanLfYdg9OIb2EZRcVl2bWtJz5DcDUUvS2mA==
X-Received: by 2002:adf:fdce:: with SMTP id i14mr61682832wrs.58.1609347227453;
        Wed, 30 Dec 2020 08:53:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a1e5:2a55:c7d0:ad89? (p200300ea8f065500a1e52a55c7d0ad89.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a1e5:2a55:c7d0:ad89])
        by smtp.googlemail.com with ESMTPSA id l5sm65692614wrv.44.2020.12.30.08.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 08:53:46 -0800 (PST)
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     Florian Fainelli <f.fainelli@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marc Zyngier <maz@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
 <a64312eb-8b4c-d6d4-5624-98f55e33e0b7@gmail.com>
 <CALW65jbV-RwbmmiGjfq8P-ZcApOW0YyN6Ez5FvhhP4dgaA+VjQ@mail.gmail.com>
 <fa7951e1-4a98-8488-d724-3eda9b97e376@gmail.com>
 <546a8430-8865-1be8-4561-6681c7fa8ef8@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <11ca856b-1d0f-06ed-cf73-58fb9b757928@gmail.com>
Date:   Wed, 30 Dec 2020 17:53:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <546a8430-8865-1be8-4561-6681c7fa8ef8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.12.2020 17:15, Florian Fainelli wrote:
> 
> 
> On 12/30/2020 1:12 AM, Heiner Kallweit wrote:
>> On 30.12.2020 10:07, DENG Qingfang wrote:
>>> Hi Heiner,
>>> Thanks for your reply.
>>>
>>> On Wed, Dec 30, 2020 at 3:39 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>> I don't think that's the best option.
>>>
>>> I'm well aware of that.
>>>
>>>> You may want to add a PHY driver for your chip. Supposedly it
>>>> supports at least PHY suspend/resume. You can use the RTL8366RB
>>>> PHY driver as template.
>>>
>>> There's no MediaTek PHY driver yet. Do we really need a new one just
>>> for the interrupts?
>>>
>> Not only for the interrupts. The genphy driver e.g. doesn't support
>> PHY suspend/resume. And the PHY driver needs basically no code,
>> just set the proper callbacks.
> 
> That statement about not supporting suspend/resume is not exactly true,
> the generic "1g" PHY driver only implements suspend/resume through the
> use of the standard BMCR power down bit, but not anything more
> complicated than that.
> 
Oh, right. Somehow I had in the back of my mind that the genphy driver
has no suspend/resume callbacks set.

> Interrupt handling within the PHY itself is not defined by the existing
> standard registers and will typically not reside in a standard register
> space either, so just for that reason you do need a custom PHY driver.
> There are other advantages if you need to expose additional PHY features
> down the road like PHY counters, energy detection, automatic power down etc.
> 
> I don't believe we will see discrete/standalone Mediatek PHY chips, but
> if that happens, then you would already have a framework for supporting
> them.
> 

