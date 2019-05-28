Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E0B2CF9B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfE1Thf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:37:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43139 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfE1Thf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:37:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id c6so12099826pfa.10
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 12:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=34gZDzfKah76sEKkUnC1QEufZwmGl6FocNsvzbuy5v4=;
        b=csJwU9f8N1XXH3IqlhoSD77sbCcilZccBUyMY1GtVc7w7g03T24yJ7vwfOyV8ZsZuY
         Z0KBwZUSdkaVOIM6wweaK4bokv+s1mQWJ+hOZpQPGuaARv/NFfettYn8NE1kJHxWBKTJ
         q2XHL/XcXnu5X1JJU91wS5pW/cX/qRoSYRzTmSuae0YGfPBoapzLBsypea7jnq/CPuCx
         yaLu9y96Fs0gXz8rH1Cznc9xAWY9yrMmd0zCWa0MOucD0iiRCjwEKwiiDYYvIzm/sHB+
         wJLUKSseY4ixuXD645YbY5/Xwndtk+bGsOENR6xeiSwAY6np/xoxQABmFh5jTb33Gh2+
         4xow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=34gZDzfKah76sEKkUnC1QEufZwmGl6FocNsvzbuy5v4=;
        b=GSSrX6FJiwWZMcyH3QSKWgASlxg9AouEC9IwNMWnp/wTKcaa83MPgZoagxcN9ZZFuc
         aAgmoCqk3elIo2llagfv8T1E6fUkxVS8fpjSoE/TcoR2IRKpN+CCVFt3CdK6OmwJBpHx
         /+zAJ9/4MhyPYFSTzZGGV8+9JyrH+50ILVWTp0zAQluvJncbp33zugAoHKccmsZ9BcBi
         OTzkEzYCpnzfjfNOglx3elKvpIrizFeSJy+l2j8GxrFFCz4xY2nyt/juKKM/vBantXFb
         tGXuadejmP4KLkWUKGluZLVsTE5xpUQmydeZUoLJ0ZE+n9F5S5N7vQAEcHX/4WaZUrqh
         qPRw==
X-Gm-Message-State: APjAAAWNlhmVRm0b+YcjvFkN8mna1h6Yf6Q5uVAVOAkCX+Yc+Q2O9eSA
        +t1TqGDi5ewRnjrb2lqBqHRaqCtP
X-Google-Smtp-Source: APXvYqyw9B9NVVFsee4T0HH4A23fTul9F6jAvLVvfoGUCsqh7mB0KGzk5ekujfk5NLPwiRLqDloPXA==
X-Received: by 2002:aa7:842f:: with SMTP id q15mr146810141pfn.161.1559072253618;
        Tue, 28 May 2019 12:37:33 -0700 (PDT)
Received: from [10.67.49.27] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u123sm21403900pfu.67.2019.05.28.12.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 12:37:32 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: phy: add callback for custom interrupt
 handler to struct phy_driver
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
 <64456292-42c8-c322-93bc-ab88d1f18329@gmail.com>
 <861ebfca-08a2-f60f-2f7a-a2fad4c2f77c@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <4a8eb515-472e-785e-619d-88ed1b2f8aa7@gmail.com>
Date:   Tue, 28 May 2019 12:37:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <861ebfca-08a2-f60f-2f7a-a2fad4c2f77c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/19 12:36 PM, Heiner Kallweit wrote:
> On 27.05.2019 21:25, Florian Fainelli wrote:
>>
>>
>> On 5/27/2019 11:28 AM, Heiner Kallweit wrote:
>>> The phylib interrupt handler handles link change events only currently.
>>> However PHY drivers may want to use other interrupt sources too,
>>> e.g. to report temperature monitoring events. Therefore add a callback
>>> to struct phy_driver allowing PHY drivers to implement a custom
>>> interrupt handler.
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>>> ---
>>>  drivers/net/phy/phy.c | 9 +++++++--
>>>  include/linux/phy.h   | 3 +++
>>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index 20955836c..8030d0a97 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -774,8 +774,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>>>  	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
>>>  		return IRQ_NONE;
>>>  
>>> -	/* reschedule state queue work to run as soon as possible */
>>> -	phy_trigger_machine(phydev);
>>> +	if (phydev->drv->handle_interrupt) {
>>> +		if (phydev->drv->handle_interrupt(phydev))
>>
>> If Russell is okay with such a model where the PHY state machine still
>> manages the interrupts at large, and only calls a specific callback for
>> specific even handling, that's fine. We might have to allow PHY drivers
>> to let them specify what they want to get passed to
>> request_threaded_irq(), or leave it to them to do it.
>>
> This proposed easy model should be able to cover quite some use cases.
> One constraint may be that interrupts are disabled if phylib state
> machine isn't in a started state. Means most likely it's not able to
> cover e.g. the requirement to allow temperature warning interrupts if
> PHY is in state HALTED.
> 

There is possibly an user case where having interrupts might be useful,
imagine your system overheated and you brought down the PHY into
PHY_HALTED stated, you might want to be able to receive thermal trip
point crossing indicating that the low threshold has been crossed, which
means you could resume operating the link again.
-- 
Florian
