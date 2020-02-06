Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA9A154F2D
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 00:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgBFXFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 18:05:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40505 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgBFXFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 18:05:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so634959wmi.5;
        Thu, 06 Feb 2020 15:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ami2hxXB5JmpdB3plbUF7Q0OnVlJKfYsRMoJO0yAKHw=;
        b=h7XFAFWk1Ab2fpnR3MhZ5UYyj4vFb9Fz2M4BCPwBZkSinKWu30iiU6HCmKLIttLub7
         5vMZ6ebx4CijeHEJG9jhMLNY8yWCxNGJLlZ9g1zh70ZZ9gSxx8lVSDCine3EE19V0VpR
         ZaLVXWeBr+U6NbhDhD28zfa8imFUqA/BfLBWimZGtVKElNbMSAsZ/bIFyKlhRXe88Q5H
         5wbHfn0FxR+aRVgq6QdKs7hmF6XPUar6b1WxV/MLW2CZwrg0d9lWBjajZ2Z/9ZLTX6DW
         rjGqMqZmJ4dZ4cBPN9EklULYD8E/ZZ+bO/XABt/cNZXnNIqKVJTDsHxXAe4I+t39QLRl
         Rl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ami2hxXB5JmpdB3plbUF7Q0OnVlJKfYsRMoJO0yAKHw=;
        b=I+XBIk2XnWWPCGkoyG6M5UVlSGL6vO1UcG8swvJT2IeZzq4KfBIC5WThGN/qPWg6xS
         m7VGU6QNBLfE3MjdmMIHnOAyKw3E1WPADqrkzC8zETPZdDWDhRv+gs0D3LZGjFSBEgdb
         VTB8igbST/ZcjboVkvKGvQg8ZwJna3q9CQ8cGtrB6N/QlurxjaNah4N5mUbCk01RSyM8
         RWl40xOzBsz6rFZuKzT+4YS+RfSKhKom1My+PEmc1ZnOzmOQ94t4i+PUitH2QHjzBcxx
         us/5+rgPNBC1zCyJOW2Q4OEWoCVk2jxKK8U0AK+HJiXcxqtEoue0s+wZTGe4gCrzxroq
         R3bw==
X-Gm-Message-State: APjAAAWPYMRE/CnQBW3cz5/MpNe9Ic1cNQHUQGxA8gHplX7/L6+VBdqh
        c6Z+PonuETqJPZrv40MqizkaXlFQ
X-Google-Smtp-Source: APXvYqypIuaQlNpOIH+F8nt0TwfdiPQ5j4GH0rfvL7KL+avChAzHGUXoKm7U1qsoSbQzSM1mk6UWmw==
X-Received: by 2002:a1c:7205:: with SMTP id n5mr135250wmc.9.1581030307138;
        Thu, 06 Feb 2020 15:05:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:ccdf:10a:e87a:1f49? (p200300EA8F296000CCDF010AE87A1F49.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ccdf:10a:e87a:1f49])
        by smtp.googlemail.com with ESMTPSA id x14sm1035234wmj.42.2020.02.06.15.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 15:05:06 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <47b9b462-6649-39a7-809f-613ce832bd5c@ti.com>
 <59ce70e0-4404-cade-208d-d089ed238f30@gmail.com>
 <8fa98423-9c3c-62c9-1e5a-29b2eef555e3@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a0f1dfca-53c1-85be-c28c-73840c4f05fd@gmail.com>
Date:   Fri, 7 Feb 2020 00:04:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <8fa98423-9c3c-62c9-1e5a-29b2eef555e3@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.02.2020 23:36, Dan Murphy wrote:
> Heiner
> 
> On 2/6/20 4:28 PM, Heiner Kallweit wrote:
>> On 06.02.2020 23:13, Dan Murphy wrote:
>>> Heiner
>>>
>>> On 2/5/20 3:16 PM, Heiner Kallweit wrote:
>>>> On 04.02.2020 19:13, Dan Murphy wrote:
>>>>> Set the speed optimization bit on the DP83867 PHY.
>>>>> This feature can also be strapped on the 64 pin PHY devices
>>>>> but the 48 pin devices do not have the strap pin available to enable
>>>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>>>
>>>>> With this bit set the PHY will auto negotiate and report the link
>>>>> parameters in the PHYSTS register.  This register provides a single
>>>>> location within the register set for quick access to commonly accessed
>>>>> information.
>>>>>
>>>>> In this case when auto negotiation is on the PHY core reads the bits
>>>>> that have been configured or if auto negotiation is off the PHY core
>>>>> reads the BMCR register and sets the phydev parameters accordingly.
>>>>>
>>>>> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
>>>>> 4-wire cable.  If this should occur the PHYSTS register contains the
>>>>> current negotiated speed and duplex mode.
>>>>>
>>>>> In overriding the genphy_read_status the dp83867_read_status will do a
>>>>> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
>>>>> register is read and the phydev speed and duplex mode settings are
>>>>> updated.
>>>>>
>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>> ---
>>>>> v2 - Updated read status to call genphy_read_status first, added link_change
>>>>> callback to notify of speed change and use phy_set_bits - https://lore.kernel.org/patchwork/patch/1188348/
>>>>>
>>>> As stated in the first review, it would be appreciated if you implement
>>>> also the downshift tunable. This could be a separate patch in this series.
>>>> Most of the implementation would be boilerplate code.
>>>
>>> I looked at this today and there are no registers that allow tuning the downshift attempts.  There is only a RO register that tells you how many attempts it took to achieve a link.  So at the very least we could put in the get_tunable but there will be no set.
>>>
>> The get operation for the downshift tunable should return after how many failed
>> attempts the PHY starts a downshift. This doesn't match with your description of
>> this register, so yes: Implementing the tunable for this PHY doesn't make sense.
> True.  This register is only going to return 1,2,4 and 8.  And it is defaulted to 4 attempts.
>>
>> However this register may be useful in the link_change_notify() callback to
>> figure out whether a downshift happened, to trigger the info message you had in
>> your first version.
> 
> Thats a good idea but.. The register is defaulted to always report 4 attempts were made. It never reports 0 attempts so we would never know the truth behind the reporting.  Kinda like matching the speeds.
> 

I just had a brief look at the datasheet here: http://www.ti.com/lit/ds/symlink/dp83867ir.pdf
It says: The number of failed link attempts before falling back to 100-M operation is configurable. (p.45)
Description of SPEED_OPT_ATTEMPT_CNT in CFG2 says "select attempt count", so it sounds like it's
an RW register. It's marked as RO however, maybe it's a typo in the datasheet.
Did you test whether register is writable?
Last but not least this register is exactly what's needed for the downshift tunable.

Checking whether a downshift occurred should be possible by reading SPEED_OPT_EVENT_INT in ISR.
In interrupt mode however this may require a custom interrupt handler (implementation of
handle_interrupt callback).

Alternatively you could check SPEED_OPT_STATUS in PHYSTS. It says "valid only during aneg"
but that sounds a little bit weird. Would need to be tested whether bit remains set after
downshifted aneg is finished.

> Dan
> 
Heiner
