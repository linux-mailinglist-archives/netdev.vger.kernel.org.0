Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6035F495B25
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349156AbiAUHts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiAUHtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:49:47 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D838C061574;
        Thu, 20 Jan 2022 23:49:47 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id r132-20020a1c448a000000b0034e043aaac7so3184726wma.5;
        Thu, 20 Jan 2022 23:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=QI6F2iecTvvYpPIqk/Jd4Gkn6P4PVe+G1v/Ub6Itxz8=;
        b=qDFMeL+2G0cPGfr34kR41XspC8tW66cJim6ekk+N5OOOaSIOzlupxgongDn2/fCkMJ
         TfYzVzGhWYqNFpNSzsPROYK06q8+Yb4PHUB1aWKwl18AHOwyYgBkRb9J1eVDafkZGOwa
         Fu7j6Yg3TYskvFGULHh10/kke8rrwP4Ocz09L5mlDzhnZ15MjB0QGlad1L2PtwS2704N
         1istH+GjEC3yEiW2yM9x1HbtA2M8vSMNdYiW4TEeqOMccucmEnZLsoyfgdZhWfEan3jo
         k5ULN+8/NayRwIHhrKKe7Hq1mjHcaoqzLhsVoFTxQDmD/KBkj2wJ739RESONpflMd5/U
         /i8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=QI6F2iecTvvYpPIqk/Jd4Gkn6P4PVe+G1v/Ub6Itxz8=;
        b=m9aKu2jUN0SKOCXwDLSNC01qFyBYJWG350DvI0pvy5n/VqZf0rBHTuyllWbTAoE5Fj
         d8+PWMDh68MiCHIaL9yroiKHim7wySoqwEJCyyh3yX8zc8LAr/C7K/OUDXu1FMt+3GGJ
         4iP7Ezg96EjDsZ+3z1rDM0W3bAv0uCQEae+7yLVFD1Qpx1ZFtnKuCmr0uzBR6U1xtE3+
         gESqEKPRq5PaYYMwdAs1WG1OtOuss0/bleSrvFDu/05OP3Ww59hQH2t6XxGVw5zOYXBG
         HmP+JQ3PIk/DNL+VtmZia+1btdcW212sLLZN1IDyIZVLAsLMLiRxC1IkWuWx+N1rBS8y
         22aQ==
X-Gm-Message-State: AOAM531uFZajKUjKmNOwij7ZDpCaHe5xvEfmaypBnLF0a8QSxkPGYMRZ
        0Grm6g+KfD87qMWhT4/qG32uV35Tfow=
X-Google-Smtp-Source: ABdhPJz0BZ4WXYzeGzcZlgzIJ52vB74sU95Z5wo3bgWtdCOSWdzwm0wy55aR6MiS8apD95K1ymGxpQ==
X-Received: by 2002:a05:600c:3502:: with SMTP id h2mr2665530wmq.166.1642751385564;
        Thu, 20 Jan 2022 23:49:45 -0800 (PST)
Received: from ?IPV6:2003:ea:8f08:c900:d807:b6a9:be4b:b7e0? (p200300ea8f08c900d807b6a9be4bb7e0.dip0.t-ipconnect.de. [2003:ea:8f08:c900:d807:b6a9:be4b:b7e0])
        by smtp.googlemail.com with ESMTPSA id f6sm4760090wrj.26.2022.01.20.23.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 23:49:45 -0800 (PST)
Message-ID: <ceead395-a641-7413-8d9f-77879dcaa36e@gmail.com>
Date:   Fri, 21 Jan 2022 08:49:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux@armlinux.org.uk, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
In-Reply-To: <Yelnzrrd0a4Bl5AL@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.01.2022 14:46, Andrew Lunn wrote:
> On Thu, Jan 20, 2022 at 01:19:29PM +0800, Kai-Heng Feng wrote:
>> BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
>> instead of setting another value, keep it untouched and restore the saved
>> value on system resume.
> 
> Please split this patch into two:
> 
> Don't touch the LEDs
> 
> Save and restore the LED configuration over suspend/resume.
> 
>> -static void marvell_config_led(struct phy_device *phydev)
>> +static int marvell_find_led_config(struct phy_device *phydev)
>>  {
>> -	u16 def_config;
>> -	int err;
>> +	int def_config;
>> +
>> +	if (phydev->dev_flags & PHY_USE_FIRMWARE_LED) {
>> +		def_config = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
>> +		return def_config < 0 ? -1 : def_config;
> 
> What about the other two registers which configure the LEDs?
> 
> Since you talked about suspend/resume, does this machine support WoL?
> Is the BIOS configuring LED2 to be used as an interrupt when WoL is
> enabled in the BIOS? Do you need to save/restore that configuration
> over suspend/review? And prevent the driver from changing the
> configuration?
> 
>> +static const struct dmi_system_id platform_flags[] = {
>> +	{
>> +		.matches = {
>> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
>> +		},
>> +		.driver_data = (void *)PHY_USE_FIRMWARE_LED,
>> +	},
> 
> This needs a big fat warning, that it will affect all LEDs for PHYs
> which linux is driving, on that machine. So PHYs on USB dongles, PHYs
> in SFPs, PHYs on plugin PCIe card etc.
> 
> Have you talked with Dells Product Manager and do they understand the
> implications of this? 
> 
>> +	{}
>> +};
>> +
>>  /**
>>   * phy_attach_direct - attach a network device to a given PHY device pointer
>>   * @dev: network device to attach
>> @@ -1363,6 +1379,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>>  	struct mii_bus *bus = phydev->mdio.bus;
>>  	struct device *d = &phydev->mdio.dev;
>>  	struct module *ndev_owner = NULL;
>> +	const struct dmi_system_id *dmi;
>>  	bool using_genphy = false;
>>  	int err;
>>  
>> @@ -1443,6 +1460,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>>  			phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
>>  	}
>>  
>> +	dmi = dmi_first_match(platform_flags);
>> +	if (dmi)
>> +		phydev->dev_flags |= (u32)dmi->driver_data;
> 
> Please us your new flag directly. We don't want this abused to pass
> any old flag to the PHY.
> 
>> +
>>  /**
>>   * struct phy_device - An instance of a PHY
>>   *
>> @@ -663,6 +665,7 @@ struct phy_device {
>>  
>>  	struct phy_led_trigger *led_link_trigger;
>>  #endif
>> +	int led_config;
> 
> You cannot put this here because you don't know how many registers are
> used to hold the configuration. Marvell has 3, other drivers can have
> other numbers. The information needs to be saved into the drivers on
> priv structure.
> 
>>  
>>  	/*
>>  	 * Interrupt number for this PHY
>> @@ -776,6 +779,12 @@ struct phy_driver {
>>  	 */
>>  	int (*config_init)(struct phy_device *phydev);
>>  
>> +	/**
>> +	 * @config_led: Called to config the PHY LED,
>> +	 * Use the resume flag to indicate init or resume
>> +	 */
>> +	void (*config_led)(struct phy_device *phydev, bool resume);
> 
> I don't see any need for this.
> 
>   Andrew

I had a look at the history of LED settings in the Marvell PHY driver:

In marvell_config_aneg() we do
phy_write(phydev, MII_M1111_PHY_LED_CONTROL, MII_M1111_PHY_LED_DIRECT);

This originates from 2007: 76884679c644 ("phylib: Add support for Marvell 88e1111S and 88e1145")
and sets the LED control to the reset default (for no obvious reason).
Especially strange is that this is done in config_aneg.
Only non-LED bit here is bit 11 that forces the interrupt pin to assert.

Simply wrong is that register MII_M1111_PHY_LED_CONTROL (reg 24, page 0)
is written also on other chip versions (like 88E1112) where it's not
defined and marked as reserved.
I think we should remove this code.

Then we set some LED defaults in marvell_config_led().
This also originates from > 10yrs ago:
140bc9290328 ("phylib: Basic support for the M88E1121R Marvell chip")
Again there's no obvious reason.

Last but not least we have a93f7fe13454 ("net: phy: marvell: add new default led configure for m88e151x")
This adds a flag to set the PHY LED mode from hns3 MAC driver.
Intention of this patch is to set the LED mode for specific boards.
The chosen approach doesn't seem to be the best. As it's meant to be
board-specific maybe better the reg-init DT property would have been
used.

I'd say we can remove all LED config code and accept whatever boot
loader or BIOS set.

Heiner

