Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A043D5291
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 23:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfJLVWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 17:22:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54538 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbfJLVWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 17:22:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so13512778wmp.4
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 14:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gjdrRj2efL1OdKcL6BwhpIdX199hvt6YilPIai0sy14=;
        b=f2LQgf3kx62fh7+TZUFeNr7nABBstpcW8csJHUPR/Rpm3jzmXpfR8UUxhbuMOdtdUN
         eNYlVXPFJZXP6o64Utsk+H2iv/74QPczfU/zWNozoL3THb9jmL0sIjLAn++D76lE+fqo
         7FpCZNRM9gNgjTrQKz2us0RQEMosr6mrQkjEHKGwHwKGAngOB3hsy9HoJppnU4DwWYSC
         PDTkULK542WxczNoAtHfeptn+UvHpVKqtf7su9f9NKBwjEHUCf5dWoWNUhy5FsCVZjTv
         WwwKnj/vE5GxJqzF867tYmwaZsAyF+mqsc6NUVaY3LQj8n35aPo3omsGE+c9zh/rbbQr
         309Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gjdrRj2efL1OdKcL6BwhpIdX199hvt6YilPIai0sy14=;
        b=ss4dxIj9ECe+CMJczA7hhlgOhVtNV/mkdqxZ7uIp6guPznSnTxwPnGp5TX9IMF1MI+
         zM1ZOMvSpC+z4k56gGOzsX2GwLur7fHkaPEZtOxtme6ju3ExDA3o8kXOCdKiZW3RgO95
         AiQnPcC5m/LX2x1q3lnK1tLmffhe1JkBuIknrWfrn4UVZZfs+gS/zLuDjd0JOAFy24Q5
         JSOmk0BOzB8VZNFDJNVJnGjF0oMeQzlRnQO0BW3KHVjorhUohqg9LZdanVWy0Lb9cdr/
         vOgGwCPYTf9F6L3+1yFVFIwaO80pgFsmR3l4uKdAJlnNQlHqizGJVKV0xvI+on0zCyc9
         mNBQ==
X-Gm-Message-State: APjAAAXalW/GyWlpSCtwVVIQS8ntNoR2G8R2nelJG8PC938oxoGD40KR
        yaR3OlbElQdyu4BxipcHRwY=
X-Google-Smtp-Source: APXvYqyeiQcpmqiGIcnbnufZ1h//nuEwqwYYhH0mrgkjGxeN3ci0Co7oMnllhkN38GRBKqk24WyT3Q==
X-Received: by 2002:a7b:cab1:: with SMTP id r17mr8312588wml.106.1570915336275;
        Sat, 12 Oct 2019 14:22:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:e99d:61ad:136:d387? (p200300EA8F266400E99D61AD0136D387.dip0.t-ipconnect.de. [2003:ea:8f26:6400:e99d:61ad:136:d387])
        by smtp.googlemail.com with ESMTPSA id m62sm11055056wmm.35.2019.10.12.14.22.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 14:22:15 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191010194622.28742-1-marex@denx.de>
 <84cb8eca-2eea-6f54-16c7-fa7b95655e2e@gmail.com>
Message-ID: <42abfa5c-1e84-63c7-1f3d-4816d232dc98@gmail.com>
Date:   Sat, 12 Oct 2019 23:22:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <84cb8eca-2eea-6f54-16c7-fa7b95655e2e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.10.2019 22:58, Heiner Kallweit wrote:
> On 10.10.2019 21:46, Marek Vasut wrote:
>> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
>> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
>> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
>> is wrong, since the KSZ8051 configures registers of the PHY which are
>> not present on the simplified KSZ87xx switch PHYs and misconfigures
>> other registers of the KSZ87xx switch PHYs.
>>
>> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
>> KSZ87xx switch by checking the Basic Status register Bit 0, which is
>> read-only and indicates presence of the Extended Capability Registers.
>> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
>>
>> This patch implements simple check for the presence of this bit for
>> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
>> PHY driver instance.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: George McCollister <george.mccollister@gmail.com>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Cc: Tristram Ha <Tristram.Ha@microchip.com>
>> Cc: Woojung Huh <woojung.huh@microchip.com>
>> ---
>> NOTE: It was also suggested to populate phydev->dev_flags to discern
>>       the PHY from the switch, this does not work for setups where
>>       the switch is used as a PHY without a DSA driver. Checking the
>>       BMSR Bit 0 for Extended Capability Register works for both DSA
>>       and non-DSA usecase.
>> V2: Move phy_id check into ksz8051_match_phy_device() and
>>     ksz8795_match_phy_device() and drop phy_id{,_mask} from the
>>     ksphy_driver[] list to avoid matching on other PHY IDs.
>> ---
>>  drivers/net/phy/micrel.c | 40 ++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 36 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>> index 2fea5541c35a..028a4a177790 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -341,6 +341,25 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
>>  	return genphy_config_aneg(phydev);
>>  }
>>  
>> +static int ksz8051_match_phy_device(struct phy_device *phydev)
>> +{
>> +	int ret;
>> +
>> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
>> +		return 0;
>> +
>> +	ret = phy_read(phydev, MII_BMSR);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
>> +	 * exact PHY ID. However, they can be told apart by the extended
>> +	 * capability registers presence. The KSZ8051 PHY has them while
>> +	 * the switch does not.
>> +	 */
>> +	return ret & BMSR_ERCAP;
>> +}
>> +
>>  static int ksz8081_config_init(struct phy_device *phydev)
>>  {
>>  	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
>> @@ -364,6 +383,21 @@ static int ksz8061_config_init(struct phy_device *phydev)
>>  	return kszphy_config_init(phydev);
>>  }
>>  
>> +static int ksz8795_match_phy_device(struct phy_device *phydev)
>> +{
>> +	int ret;
>> +
>> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8795)
>> +		return 0;
>> +
>> +	ret = phy_read(phydev, MII_BMSR);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* See comment in ksz8051_match_phy_device() for details. */
>> +	return !(ret & BMSR_ERCAP);
>> +}
>> +
>>  static int ksz9021_load_values_from_of(struct phy_device *phydev,
>>  				       const struct device_node *of_node,
>>  				       u16 reg,
>> @@ -1017,8 +1051,6 @@ static struct phy_driver ksphy_driver[] = {
>>  	.suspend	= genphy_suspend,
>>  	.resume		= genphy_resume,
>>  }, {
>> -	.phy_id		= PHY_ID_KSZ8051,
>> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>>  	.name		= "Micrel KSZ8051",
>>  	/* PHY_BASIC_FEATURES */
>>  	.driver_data	= &ksz8051_type,
>> @@ -1029,6 +1061,7 @@ static struct phy_driver ksphy_driver[] = {
>>  	.get_sset_count = kszphy_get_sset_count,
>>  	.get_strings	= kszphy_get_strings,
>>  	.get_stats	= kszphy_get_stats,
>> +	.match_phy_device = ksz8051_match_phy_device,
>>  	.suspend	= genphy_suspend,
>>  	.resume		= genphy_resume,
>>  }, {
>> @@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[] = {
>>  	.suspend	= genphy_suspend,
>>  	.resume		= genphy_resume,
>>  }, {
>> -	.phy_id		= PHY_ID_KSZ8795,
>> -	.phy_id_mask	= MICREL_PHY_ID_MASK,
>>  	.name		= "Micrel KSZ8795",
>>  	/* PHY_BASIC_FEATURES */
>>  	.config_init	= kszphy_config_init,
>>  	.config_aneg	= ksz8873mll_config_aneg,
>>  	.read_status	= ksz8873mll_read_status,
>> +	.match_phy_device = ksz8795_match_phy_device,
>>  	.suspend	= genphy_suspend,
>>  	.resume		= genphy_resume,
>>  }, {
>>
> 
> Patch needs to be annotated as "net-next".
> See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> 
Except you consider this a fix, then it would require a Fixes tag and
should be annotated "net". The question is:
Do KSZ87xx switches misbehave currently?

> Apart from that:
> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
> 

