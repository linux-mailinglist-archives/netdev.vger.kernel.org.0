Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8465153A9A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 23:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgBEWAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 17:00:36 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37079 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgBEWAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 17:00:36 -0500
Received: by mail-ed1-f66.google.com with SMTP id cy15so3750392edb.4;
        Wed, 05 Feb 2020 14:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8wIftsVgCz6fdI2JAhv8GqzQtsgoTfW+ugvUV+kEXP0=;
        b=e9wvhgZ2Lu7vhYX3+qyJHOemfTThw/6I5YKK+pacS28Fi6B8E4kcf39dGnl5+87C2b
         KkBwRcQBrMB6OTOTCtSWmSbAJXa+4OAuNomI5vW1HdQhbj7OXavIdl9NHX/s49KXSuam
         fNGtkadw7Y1qBOK8EI2fxXOlKvEV6VozTppmHgrNSlh8tFCo4zIRUPc0C2DlxAptV2CV
         DPzmw6JaP++G+r6mZQbyekX0RqE4T12OLbJWCeA980tpbsfwg3XiDhbKhBaIThoiwRru
         znvBFSwr+5LRZxGvLQy9pJ++ickmSfnn3EtjBfhfocsv5UVAVra19CXrzLLRmffeuMVY
         tQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8wIftsVgCz6fdI2JAhv8GqzQtsgoTfW+ugvUV+kEXP0=;
        b=Tpkh2v75Rh31P9cjpHKepeRbT2vY5BzJ9ZDnK5YXs1JBNXJei75zhdnkxm/gGPv4WL
         G8F0TRglPr4sZCOWtftcc3WumPibUnWGbxofD5ZEvPuFYm6oNu1c5Wxbe9QWPBoWml/P
         r9F/VLbzLO33w626up30GoKC0/YBcAX8+gGcQqqlptJdrX5I5GZ4w+tphmx4WcJqmCBO
         0I5deOWJSGXaCJ8fW4JN2Jvim4PQ2w7kVd4Ls1QOtwB3YN+4OYlmP9gvA2joDzrrmKX0
         6qRsY4/iiEfEtAsCAvpXU4df2yKHXWzR5GbySac8wc6DqGaR0ZTmKstVLQfJPF/ZaD3m
         Amow==
X-Gm-Message-State: APjAAAUnGIYTK0opKemut4e1USNOA/5xBdWmgseB2TiKOe3N9M/NqiY7
        IuDNWo9Y6hafFK/nNbXP/h4xu3xp
X-Google-Smtp-Source: APXvYqwcJaLbVrUGQd/C1omfl3D/loYv6PXo/+DxufwG9S5p0fEv/ZVLLiTHJ/VERXi2ApHA+a1EwQ==
X-Received: by 2002:aa7:cfcc:: with SMTP id r12mr254730edy.57.1580940034133;
        Wed, 05 Feb 2020 14:00:34 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d1sm135191ejy.3.2020.02.05.14.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 14:00:33 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
Date:   Wed, 5 Feb 2020 14:00:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/20 1:51 PM, Dan Murphy wrote:
> Heiner
> 
> On 2/5/20 3:16 PM, Heiner Kallweit wrote:
>> On 04.02.2020 19:13, Dan Murphy wrote:
>>> Set the speed optimization bit on the DP83867 PHY.
>>> This feature can also be strapped on the 64 pin PHY devices
>>> but the 48 pin devices do not have the strap pin available to enable
>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>
>>> With this bit set the PHY will auto negotiate and report the link
>>> parameters in the PHYSTS register.  This register provides a single
>>> location within the register set for quick access to commonly accessed
>>> information.
>>>
>>> In this case when auto negotiation is on the PHY core reads the bits
>>> that have been configured or if auto negotiation is off the PHY core
>>> reads the BMCR register and sets the phydev parameters accordingly.
>>>
>>> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to
>>> accomodate a
>>> 4-wire cable.  If this should occur the PHYSTS register contains the
>>> current negotiated speed and duplex mode.
>>>
>>> In overriding the genphy_read_status the dp83867_read_status will do a
>>> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
>>> register is read and the phydev speed and duplex mode settings are
>>> updated.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> ---
>>> v2 - Updated read status to call genphy_read_status first, added
>>> link_change
>>> callback to notify of speed change and use phy_set_bits -
>>> https://lore.kernel.org/patchwork/patch/1188348/
>>>
>> As stated in the first review, it would be appreciated if you implement
>> also the downshift tunable. This could be a separate patch in this
>> series.
>> Most of the implementation would be boilerplate code.
> 
> I just don't have a requirement from our customer to make it adjustable
> so I did not want to add something extra.
> 
> I can add in for v3.
> 
>>
>> And I have to admit that I'm not too happy with the term "speed
>> optimization".
>> This sounds like the PHY has some magic to establish a 1.2Gbps link.
>> Even though the vendor may call it this way in the datasheet, the
>> standard
>> term is "downshift". I'm fine with using "speed optimization" in
>> constants
>> to be in line with the datasheet. Just a comment in the code would be
>> helpful
>> that speed optimization is the vendor's term for downshift.
> 
> Ack.  The data sheet actually says "Speed optimization, also known as
> link downshift"
> 
> So I probably will just rename everything down shift.
> 
>>
>>>   drivers/net/phy/dp83867.c | 55 +++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 55 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>>> index 967f57ed0b65..6f86ca1ebb51 100644
>>> --- a/drivers/net/phy/dp83867.c
>>> +++ b/drivers/net/phy/dp83867.c
>>> @@ -21,6 +21,7 @@
>>>   #define DP83867_DEVADDR        0x1f
>>>     #define MII_DP83867_PHYCTRL    0x10
>>> +#define MII_DP83867_PHYSTS    0x11
>>>   #define MII_DP83867_MICR    0x12
>>>   #define MII_DP83867_ISR        0x13
>>>   #define DP83867_CFG2        0x14
>>> @@ -118,6 +119,15 @@
>>>   #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK    (0x1f << 8)
>>>   #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT    8
>>>   +/* PHY STS bits */
>>> +#define DP83867_PHYSTS_1000            BIT(15)
>>> +#define DP83867_PHYSTS_100            BIT(14)
>>> +#define DP83867_PHYSTS_DUPLEX            BIT(13)
>>> +#define DP83867_PHYSTS_LINK            BIT(10)
>>> +
>>> +/* CFG2 bits */
>>> +#define DP83867_SPEED_OPTIMIZED_EN        (BIT(8) | BIT(9))
>>> +
>>>   /* CFG3 bits */
>>>   #define DP83867_CFG3_INT_OE            BIT(7)
>>>   #define DP83867_CFG3_ROBUST_AUTO_MDIX        BIT(9)
>>> @@ -287,6 +297,43 @@ static int dp83867_config_intr(struct phy_device
>>> *phydev)
>>>       return phy_write(phydev, MII_DP83867_MICR, micr_status);
>>>   }
>>>   +static void dp83867_link_change_notify(struct phy_device *phydev)
>>> +{
>>> +    if (phydev->state != PHY_RUNNING)
>>> +        return;
>>> +
>>> +    if (phydev->speed == SPEED_100 || phydev->speed == SPEED_10)
>>> +        phydev_warn(phydev, "Downshift detected connection is
>>> %iMbps\n",
>>> +                phydev->speed);
>> The link partner may simply not advertise 1Gbps. How do you know that
>> a link speed of e.g. 100Mbps is caused by a downshift?
>> Some PHY's I've seen with this feature have a flag somewhere indicating
>> that downshift occurred. How about the PHY here?
> 
> I don't see a register that gives us that status
> 
> I will ask the hardware team if there is one.
> 
> This is a 1Gbps PHY by default so if a slower connection is established
> due to faulty cabling or LP advertisement then this would be a down
> shift IMO.

With your current link_change_notify function it would not be possible
to know whether the PHY was connected to a link partner that advertised
only 10/100 and so 100 ended up being the link speed, or the link
partner was capable of 10/100/1000 and downshift reduced the link speed.

If you cannot tell the difference from a register, it might be better to
simply omit that function then.
-- 
Florian
