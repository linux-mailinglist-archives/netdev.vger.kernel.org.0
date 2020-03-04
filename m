Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA2F17901A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 13:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbgCDMNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 07:13:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42413 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgCDMNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 07:13:50 -0500
Received: by mail-wr1-f68.google.com with SMTP id v11so152652wrm.9
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 04:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EPKff8UfWxff5ly4Do6x7RUrGHF4m6xZsgQuxBBPqcA=;
        b=JoR8HyV8T3JaLWvCIBNmfFTMjU0L7IPL70DKK0iieMQxypGBlAeEWmCi+1QRilL/pr
         dm6tJ49cqDcFi73OegRfdleSY3Zg1JHl7s692blEwlXBEGLK4zMM8cRZU1g5zB7i7MJ4
         a9B7w/NMN9MPthZKHtU1hB9dcKUMzLhWNRosfFq3Arrb5Z18sqCHzHI3JWjffEam6G8U
         4pw4zpci0aKbTOoTR2aICQlJCRFNdzqYgxjq8ysyCRsmPEHd9kmwdvFmI0Hq8j9UV4k9
         6dZIeRoxRo9xL9Rk3qQ0j4koTbozmaLvQGZKF8cl6gaR+JFEnNISJVfUa3XS/+P1fEu7
         AWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EPKff8UfWxff5ly4Do6x7RUrGHF4m6xZsgQuxBBPqcA=;
        b=svXNfGOhEqYPjQ4awz3HHbLsFuoKTHHLA2rIJAjSdr1iBfSa7vvr1fachnpHSR0jbC
         VkGIfaKeI7mrT9fbDOWuMct+195v69D6v+cAdBkz9l1sRNAzUfgIWVTrxNRZnvMzQpNd
         0Z+s5V4bHiBNTxCH8Qni7iMzxwGKwp1nJHMMR7tVHnsh2OdCH61HPwrM6I2YSC/XcEtL
         roIvvKhBZEepKCEniTO6jhXAdF/Emt6CaRFXtKJBUDhGhNHMKkRADL9/fPWBcCBAz/VY
         WifE1fZyr84wxu6+toExws3kJ6jhfLbqfPDhvNIyNjzE7WdsKtjJspNtXogr7EN4y7IH
         BGeQ==
X-Gm-Message-State: ANhLgQ2Lrag/hk6ga6Szoqwfq9ygK+xXR1uVJWn5T2XPc+x3cObZzsAy
        5K0FqoBGqILugp8/6+xkxNzYpa9r
X-Google-Smtp-Source: ADFU+vvzX5KkMA+llVW2F8Fpfq6Q2VEjKGmYsLjuIn8sodAnE+INyKIAXOdXUuDH0VgqATVXdQYjfA==
X-Received: by 2002:adf:e68b:: with SMTP id r11mr3646940wrm.138.1583324027605;
        Wed, 04 Mar 2020 04:13:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:55c9:a3e2:1ee2:7365? (p200300EA8F29600055C9A3E21EE27365.dip0.t-ipconnect.de. [2003:ea:8f29:6000:55c9:a3e2:1ee2:7365])
        by smtp.googlemail.com with ESMTPSA id 2sm2141187wrf.79.2020.03.04.04.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 04:13:46 -0800 (PST)
Subject: Re: [PATCH net] net: phy: avoid clearing PHY interrupts twice in irq
 handler
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
 <a0b161ebd332c9ea26bb62ccf73d1862@walle.cc>
 <a33c33d6-621a-4139-0e81-eb0d0fd0e095@gmail.com>
Message-ID: <c2928823-da08-0321-6917-1481aab79e09@gmail.com>
Date:   Wed, 4 Mar 2020 13:13:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a33c33d6-621a-4139-0e81-eb0d0fd0e095@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.03.2020 00:20, Heiner Kallweit wrote:
> On 01.03.2020 23:52, Michael Walle wrote:
>> Am 2020-03-01 21:36, schrieb Heiner Kallweit:
>>> On all PHY drivers that implement did_interrupt() reading the interrupt
>>> status bits clears them. This means we may loose an interrupt that
>>> is triggered between calling did_interrupt() and phy_clear_interrupt().
>>> As part of the fix make it a requirement that did_interrupt() clears
>>> the interrupt.
>>
>> Looks good. But how would you use did_interrupt() and handle_interrupt()
>> together? I guess you can't. At least not if handle_interrupt() has
>> to read the pending bits again. So you'd have to handle custom
>> interrupts in did_interrupt(). Any idea how to solve that?
>>
>> [I know, this is only about fixing the lost interrupts.]
>>
> Right, this one is meant for stable to fix the issue with the potentially
> lost interrupts. Based on it I will submit a patch for net-next that
> tackles the issue that did_interrupt() has to read (and therefore clear)
> irq status bits and therefore makes them unusable for handle_interrupt().
> The basic idea is that did_interrupt() is called only if handle_interrupt()
> isn't implemented. handle_interrupt() has to include the did_interrupt
> functionality. It can read the irq status once and store it in a variable
> for later use.
> 
In case you wait for this patch to base further own work on it:
I'm waiting for next merge of net into net-next, because my patch will
apply cleanly only after that. This merge should happen in the next days.

>> -michael
>>
>>>
>>> The Fixes tag refers to the first commit where the patch applies
>>> cleanly.
>>>
>>> Fixes: 49644e68f472 ("net: phy: add callback for custom interrupt
>>> handler to struct phy_driver")
>>> Reported-by: Michael Walle <michael@walle.cc>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> ---
>>>  drivers/net/phy/phy.c | 3 ++-
>>>  include/linux/phy.h   | 1 +
>>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index d76e038cf..16e3fb79e 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -727,7 +727,8 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>>>          phy_trigger_machine(phydev);
>>>      }
>>>
>>> -    if (phy_clear_interrupt(phydev))
>>> +    /* did_interrupt() may have cleared the interrupt already */
>>> +    if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
>>>          goto phy_err;
>>>      return IRQ_HANDLED;
>>>
>>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>>> index 80f8b2158..8b299476b 100644
>>> --- a/include/linux/phy.h
>>> +++ b/include/linux/phy.h
>>> @@ -557,6 +557,7 @@ struct phy_driver {
>>>      /*
>>>       * Checks if the PHY generated an interrupt.
>>>       * For multi-PHY devices with shared PHY interrupt pin
>>> +     * Set interrupt bits have to be cleared.
>>>       */
>>>      int (*did_interrupt)(struct phy_device *phydev);
> 

