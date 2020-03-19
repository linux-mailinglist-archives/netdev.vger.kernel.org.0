Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134D018AD54
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 08:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgCSHbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 03:31:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42622 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSHbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 03:31:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id v11so1349440wrm.9
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 00:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m2p6JNj5eh/IxHSDwtrNY7piiLKH5MbMVTK+eXXDELE=;
        b=NNSuT3CXBKD0KmMtdNXa4Xvwj12RxfEPDlL8AotvlMIQR5Wj5qGD69edjFbqzgCjkC
         IuqBDSzZbz7oVDV2ubeNyGt5WLX6umaoQizb/tTf9DHp696YrUv60/zn99yj4Yzty1ac
         EHlh1AdJwZj6bUWxviHFEUbsemAhuo7ZMNMXxP8uG5QT3WUgxU14KcoqctIutJMhDNeO
         RFec0p+r4yPFTPE/FCUCDgRJXFVhvHRCrbTXsbmE6YHENkjJe/6nhu2/0LDhJyjcEeuV
         zyHXeHqYS8GRI5xpOvjuDVK36jJtEEvbT5m4BWLiMdW3dXOU0wRYvl+dxdpGip3SW+CX
         BkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m2p6JNj5eh/IxHSDwtrNY7piiLKH5MbMVTK+eXXDELE=;
        b=JGMVQmtMUSNOSOQcvW/yObAf+K0jsiY/h+2zRzN1axdcT/QhcJa5VYVA8pcx8YucTp
         FimUhiA1YAaquNDRoiITwM7kuGBLts38laxTDuA62x6M26JEzOoGLH3phik3s6M8h7z4
         AJE5mjx+bWfVc2b+P0+ZLKUlHcgK1RJY0X8AG5Ky+WcdlcJnkxpvtsnA4+T7wYyVsLyX
         9oezOB81aJGPnFspZxvzPL5woX0Ye1rZkjutET9ac/TgK/TaUfKZl/HO6uHP+N3VBFn8
         nDaRsCrBfr0548pxdeIjhPAkFqcXMWEo67eqUgfEbU/Xo3v/AYSjTaVx1AUedocbL8an
         y9dA==
X-Gm-Message-State: ANhLgQ1kLy2+/y6HVzMCKnMrc3b9DdKkg9/PtAnhNArmR4dn+y/vx+cM
        LkquCcxgQ3DzErfuZV/isMoaZmQW
X-Google-Smtp-Source: ADFU+vsWneqMfeJtxH0qm6jKXDoJLiJPBR5zzkH3KvFPs4PM9Z8SMM45XksjlNy4rD13ErfE9cnZew==
X-Received: by 2002:adf:bc04:: with SMTP id s4mr2335838wrg.244.1584603068437;
        Thu, 19 Mar 2020 00:31:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:ecff:1b4a:46cb:d5e4? (p200300EA8F296000ECFF1B4A46CBD5E4.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ecff:1b4a:46cb:d5e4])
        by smtp.googlemail.com with ESMTPSA id u1sm2070051wrt.78.2020.03.19.00.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 00:31:07 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
Date:   Thu, 19 Mar 2020 08:30:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200318232159.GA25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.03.2020 00:21, Russell King - ARM Linux admin wrote:
> On Wed, Mar 18, 2020 at 10:29:01PM +0100, Heiner Kallweit wrote:
>> So far PHY drivers have to check whether a downshift occurred to be
>> able to notify the user. To make life of drivers authors a little bit
>> easier move the downshift notification to phylib. phy_check_downshift()
>> compares the highest mutually advertised speed with the actual value
>> of phydev->speed (typically read by the PHY driver from a
>> vendor-specific register) to detect a downshift.
> 
> My personal position on this is that reporting a downshift will be
> sporadic at best, even when the link has negotiated slower.
> 
> The reason for this is that either end can decide to downshift.  If
> the remote partner downshifts, then the local side has no idea that
> a downshift occurred, and can't report that the link was downshifted.
> 
Right, this warning can't cover the case that remote link partner
downshifts. In this case however ethtool et al should show the reduced
link partner advertisement, and therefore provide a hint why speed
is slow.

> So, is it actually useful to report these events?
> 
To provide an example: A user recently complained that r8169 driver
makes problems on his system:
- it takes long time until link comes up
- link is slow
With iperf he then found out that displayed speed is 1Gbps but actual
link speed is 100Mbps. In the end he found that one pin of his network
port was corroded, therefore the downshift.

The phase of blaming the driver could have been skipped if he would
have seen a downshift warning from the very beginning.

>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy-core.c | 33 +++++++++++++++++++++++++++++++++
>>  drivers/net/phy/phy.c      |  1 +
>>  include/linux/phy.h        |  1 +
>>  3 files changed, 35 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index e083e7a76..8e861be73 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -329,6 +329,39 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
>>  }
>>  EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
>>  
>> +/**
>> + * phy_check_downshift - check whether downshift occurred
>> + * @phydev: The phy_device struct
>> + *
>> + * Check whether a downshift to a lower speed occurred. If this should be the
>> + * case warn the user.
>> + */
>> +bool phy_check_downshift(struct phy_device *phydev)
>> +{
>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
>> +	int i, speed = SPEED_UNKNOWN;
>> +
>> +	if (phydev->autoneg == AUTONEG_DISABLE)
>> +		return false;
>> +
>> +	linkmode_and(common, phydev->lp_advertising, phydev->advertising);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(settings); i++)
>> +		if (test_bit(settings[i].bit, common)) {
>> +			speed = settings[i].speed;
>> +			break;
>> +		}
>> +
>> +	if (phydev->speed == speed)
>> +		return false;
>> +
>> +	phydev_warn(phydev, "Downshift occurred from negotiated speed %s to actual speed %s, check cabling!\n",
>> +		    phy_speed_to_str(speed), phy_speed_to_str(phydev->speed));
>> +
>> +	return true;
>> +}
>> +EXPORT_SYMBOL_GPL(phy_check_downshift);
>> +
>>  static int phy_resolve_min_speed(struct phy_device *phydev, bool fdx_only)
>>  {
>>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index d71212a41..067ff5fec 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -507,6 +507,7 @@ static int phy_check_link_status(struct phy_device *phydev)
>>  		return err;
>>  
>>  	if (phydev->link && phydev->state != PHY_RUNNING) {
>> +		phy_check_downshift(phydev);
>>  		phydev->state = PHY_RUNNING;
>>  		phy_link_up(phydev);
>>  	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index cb5a2182b..4962766b2 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -698,6 +698,7 @@ static inline bool phy_is_started(struct phy_device *phydev)
>>  
>>  void phy_resolve_aneg_pause(struct phy_device *phydev);
>>  void phy_resolve_aneg_linkmode(struct phy_device *phydev);
>> +bool phy_check_downshift(struct phy_device *phydev);
>>  
>>  /**
>>   * phy_read - Convenience function for reading a given PHY register
>> -- 
>> 2.25.1
>>
>>
>>
> 

