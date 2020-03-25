Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EA919341D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgCYXC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:02:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43223 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgCYXC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:02:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id b2so5557397wrj.10
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 16:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G6hp76k+sJ8OIFLwcZN/syhvrZfA0UKfx17z10q7+R0=;
        b=ueqWHdHT4upcZzDxLP2EdsMLfwt2TrLRM5bGL7hvbKCiy4OOssMazvFbNGAF/kKKot
         ZwxqrucBijqhRcbMThx7qtQCJ7/iyduD7+yxJ7gaty58/NYqRQ1E6ijMIB3JENixxqrz
         YbdFnivAH83CHlaXNFsAkNB/Ksp/QAlkpUMTEe5sHGPY4JV9hL4xNpzJhgyDXVUMgzV6
         ewWfajn+/SAH8Wd5s1Dbbcea241H/JCvt1CTAwU3o5qgwjWNXSD1bh/hUt8aSINWIW1Q
         QsZk04GsdqilhRbBHrArQJrGnndH5NrnFMT+QX02rGW+O6Rr0GrCygZy04D6bLk+XIao
         XDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=G6hp76k+sJ8OIFLwcZN/syhvrZfA0UKfx17z10q7+R0=;
        b=neOz4jWLo7Ve3hAj175/rGcv7Bc0ydswMAc2HaXqxf2kHT7xXC7FYeIpGb5O7S7lg2
         muUySIyzjX4SQ27fTt0XfTFJ4zQIW+M8koyrmUualFhneNxOzyPQTbMYwiypNfAji5rW
         q8NSC1n5V5NGPCT1rqXMPo4AXo2ASPZ2ocx1q/06bbAUv/fMBPdZ0Kj3MB/qKk61x2oq
         DUeaB9fzeajHQKgzSRftwP1iBuN/NVawcDIqpFnp2ndUyuOiPUamkLgLr7og92KY9+lL
         28Jxa7x2wdkQVawVGKqqUaHTaWhn05X0SxOODbCY81VzjF+HAwcZ5ahKNmJ6enNqgjv9
         vqgA==
X-Gm-Message-State: ANhLgQ26JkDt/VdElms1/uA98JM/70Yqge7nre6B1RGmPrFmOUlfl5ZQ
        6kLZaL3bFGePePjDKVl/3s7cyaxK
X-Google-Smtp-Source: ADFU+vsxs3Il0nYt8WpRKugiqdAmXFxqBBD1g0EKIIDKnuBcQdHt8US6BHtLctRCNmqE98VI6UeUhw==
X-Received: by 2002:adf:d84d:: with SMTP id k13mr5825876wrl.298.1585177375283;
        Wed, 25 Mar 2020 16:02:55 -0700 (PDT)
Received: from [10.230.1.220] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id l12sm631476wrt.73.2020.03.25.16.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 16:02:54 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 02/10] net: phy: bcm7xx: Add jumbo frame
 configuration to PHY
To:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        murali.policharla@broadcom.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-3-olteanv@gmail.com>
 <ec070d0f-3712-8663-f39f-124b7f802450@gmail.com>
 <CA+h21hrJyxDX98dzY0TbySKqXvC1+jkNJb0z+17LPOSN8=WeqA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <4db60ac7-9ad5-deb0-5285-11198c9ca4b5@gmail.com>
Date:   Wed, 25 Mar 2020 16:02:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrJyxDX98dzY0TbySKqXvC1+jkNJb0z+17LPOSN8=WeqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 3:45 PM, Vladimir Oltean wrote:
> On Wed, 25 Mar 2020 at 17:44, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 25.03.2020 16:22, Vladimir Oltean wrote:
>>> From: Murali Krishna Policharla <murali.policharla@broadcom.com>
>>>
>>> Add API to configure jumbo frame settings in PHY during initial PHY
>>> configuration.
>>>
>>> Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
>>> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>>  drivers/net/phy/bcm-phy-lib.c | 28 ++++++++++++++++++++++++++++
>>>  drivers/net/phy/bcm-phy-lib.h |  1 +
>>>  drivers/net/phy/bcm7xxx.c     |  4 ++++
>>>  include/linux/brcmphy.h       |  1 +
>>>  4 files changed, 34 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
>>> index e0d3310957ff..a26c80e13b43 100644
>>> --- a/drivers/net/phy/bcm-phy-lib.c
>>> +++ b/drivers/net/phy/bcm-phy-lib.c
>>> @@ -423,6 +423,34 @@ int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev)
>>>  }
>>>  EXPORT_SYMBOL_GPL(bcm_phy_28nm_a0b0_afe_config_init);
>>>
>>> +int bcm_phy_enable_jumbo(struct phy_device *phydev)
>>> +{
>>> +     int val = 0, ret = 0;
>>> +
>>> +     ret = phy_write(phydev, MII_BCM54XX_AUX_CTL,
>>> +                     MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     val = phy_read(phydev, MII_BCM54XX_AUX_CTL);
>>> +
>>> +     /* Enable extended length packet reception */
>>> +     val |= MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN;
>>> +     ret = phy_write(phydev, MII_BCM54XX_AUX_CTL, val);
>>> +
>>
>> There are different helpers already in bcm-phy-lib,
>> e.g. bcm54xx_auxctl_read. Also bcm_phy_write_misc()
>> has has quite something in common with your new function.
>> It would be good if a helper could be used here.
>>
> 
> Thanks Heiner.
> I'm not quite sure the operation is performed correctly though? My
> books are telling me that the "Receive Extended Packet Length" field
> is accessible via the Auxiliary Control Register 0x18 when the shadow
> value is 000, not 111 as this patch is doing. At least for BCM54xxx in
> terms of which the macros are defined. Am I wrong?

I can confirm that for the BCM54810 PHY as well, the extended packet
length is in register 0x18 shadow 0b000.

Murali, which datsheet did you use as a reference? The internal document
for the 28nm EGPHY which is what this driver is supposed to drive is
also indicating the same thing.
-- 
Florian
