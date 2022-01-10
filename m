Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1128448962C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbiAJKRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiAJKRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:17:15 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01FDC061756;
        Mon, 10 Jan 2022 02:17:13 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id k30so8159713wrd.9;
        Mon, 10 Jan 2022 02:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=3FcTtQ06S7T2cfEJwv9xMGw4WGam5JBDxtl5OgvfscM=;
        b=C2P+0vfJV6BS/a5RxFYfTtpw6G0SwSFoysQUycHErToWSYRJZ3SLx3c8bUCjrrVjSR
         A/0XrrkINRM1AUsZLrGJ3SWlAWbpYS0ofn+8QCdESfF/u48s2uC85epw3Liz8+nGHE5T
         qRNKLRkovGeJdo1eAnIGfFNk2MYNUcBD43kvfGZ2egYCfhwyDwsMjcd9twlh4z1pBUMc
         u1J/5U0+WqDtrHu2NSw1ZubZOyvzsXXqHRigMi0WFOhv7jzuLg3ie8c3aNf85L/Epytf
         Jq32vml36gJ9sy46UW95fzrE2eca9wUOeBM51YeB9lF+xQwbsudXIBRjb5r2imAXePPH
         kICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=3FcTtQ06S7T2cfEJwv9xMGw4WGam5JBDxtl5OgvfscM=;
        b=2wPTScfqWVMvw13imicxFk6onHM4zEdfhHmV4SWflSrI3R0TzaVSE9LvEGKxSXWK9n
         KZNtW+r4MP1P95n7S+R1rtTuuZpayk+ABH4QG1tbm5YAQF4bFh0qo/hGAzrmCqWoWCC+
         36GGhCA9W1SedR5pR2BHwFH74tOv7zuJ8fulSXLika6MRLyzuw7rtvNQBXeMflP4fzr3
         6Iu3LE66DZUwIBACxvvx3fZV0pSzqXVTN+SUu0qOmNwUGcKefFPSiNhg+6Xkv+Y90qYX
         iYfTOFdnorgCs7uaC/EAHBdZdzZpY5QnoOA8jla6OCujT/6xJhTRvcwCW5ImzO+bBCai
         WgSQ==
X-Gm-Message-State: AOAM533g7N/7WNvRcUGSZa8Z83Z0jMjdz3kA9462DbzAfc0jmXo86O5r
        qWq+fbJPRrc1/gGOPrnwKhSE3cNqwng=
X-Google-Smtp-Source: ABdhPJzOuq0rkKvcKTBLBqC+Z9YQIA7RzNEFCcEIMB7xkAcBePZ3V1AGshE0dPoWnBiyiYSZi1EHmg==
X-Received: by 2002:a5d:47ad:: with SMTP id 13mr43313054wrb.268.1641809832395;
        Mon, 10 Jan 2022 02:17:12 -0800 (PST)
Received: from ?IPV6:2003:ea:8f2f:5b00:6811:dbe0:fa81:6cef? (p200300ea8f2f5b006811dbe0fa816cef.dip0.t-ipconnect.de. [2003:ea:8f2f:5b00:6811:dbe0:fa81:6cef])
        by smtp.googlemail.com with ESMTPSA id l10sm6369589wmq.7.2022.01.10.02.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 02:17:11 -0800 (PST)
Message-ID: <95b539d2-f72a-f967-c670-2aa37cb5039b@gmail.com>
Date:   Mon, 10 Jan 2022 11:17:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
 <20220110062117.17540-2-mohammad.athari.ismail@intel.com>
 <1be1444c-b1f7-b7d6-adaa-78960c381161@gmail.com>
 <CO1PR11MB4771E08DD8C8CAE63E7A9A54D5509@CO1PR11MB4771.namprd11.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
 loopback
In-Reply-To: <CO1PR11MB4771E08DD8C8CAE63E7A9A54D5509@CO1PR11MB4771.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.2022 10:36, Ismail, Mohammad Athari wrote:
> 
> 
>> -----Original Message-----
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: Monday, January 10, 2022 4:34 PM
>> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>;
>> Andrew Lunn <andrew@lunn.ch>; David S . Miller <davem@davemloft.net>;
>> Jakub Kicinski <kuba@kernel.org>; Oleksij Rempel <linux@rempel-
>> privat.de>; Russell King <linux@armlinux.org.uk>
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> stable@vger.kernel.org
>> Subject: Re: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
>> loopback
>>
>> On 10.01.2022 07:21, Mohammad Athari Bin Ismail wrote:
>>> Existing genphy_loopback() is not applicable for Marvell PHY. So,
>>> adding Marvell specific PHY loopback operation by only setting(enable)
>>> or
>>> clearing(disable) BMCR_LOOPBACK bit.
>>>
>>> Tested working on Marvell 88E1510.
>>>
>> With this change you'd basically revert the original change and loose its
>> functionality. Did you check the Marvell datasheets?
>> At least for few versions I found that you may have to configure bits 0..2 in
>> MAC Specific Control Register 2 (page 2, register 21) instead of BMCR.
> 
> May I know what datasheet version that has the bits 2:0's detail explanation? The version that I have, bits 2:0 in MAC Specific Control Register 2 shows as Reserved.
> The datasheet I have is "Marvell Alaska 88E1510/88E1518/88E1512/88E1514 Integrated 10/100/1000 Mbps Energy Efficient Ethernet Transceiver Rev. G December 17, 2021"
> 
I checked the 88E6352 switch chip datasheet. The part covering the integrated PHY's lists the mentioned bits
in MAC Specific Control Register 2.

Table 75 in the 88E1510 datasheet says: Loopback speed is determined by Registers 21_2.6,13.
So Marvell PHY's seem to use different bits (although same register) for loopback speed configuration.

> Really appreciate if you could advice on PHY loopback enabling for Marvell 88E1510 because the existing genphy_loopback() function doesn't work for the PHY.
> 
> Thank you.
> 
> -Athari-
> 
>>
>>
>>> Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed
>>> configuration")
>>> Cc: <stable@vger.kernel.org> # 5.15.x
>>> Signed-off-by: Mohammad Athari Bin Ismail
>>> <mohammad.athari.ismail@intel.com>
>>> ---
>>>  drivers/net/phy/marvell.c | 8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
>>> index 4fcfca4e1702..2a73a959b48b 100644
>>> --- a/drivers/net/phy/marvell.c
>>> +++ b/drivers/net/phy/marvell.c
>>> @@ -1932,6 +1932,12 @@ static void marvell_get_stats(struct phy_device
>> *phydev,
>>>  		data[i] = marvell_get_stat(phydev, i);  }
>>>
>>> +static int marvell_loopback(struct phy_device *phydev, bool enable) {
>>> +	return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
>>> +			  enable ? BMCR_LOOPBACK : 0);
>>> +}
>>> +
>>>  static int marvell_vct5_wait_complete(struct phy_device *phydev)  {
>>>  	int i;
>>> @@ -3078,7 +3084,7 @@ static struct phy_driver marvell_drivers[] = {
>>>  		.get_sset_count = marvell_get_sset_count,
>>>  		.get_strings = marvell_get_strings,
>>>  		.get_stats = marvell_get_stats,
>>> -		.set_loopback = genphy_loopback,
>>> +		.set_loopback = marvell_loopback,
>>>  		.get_tunable = m88e1011_get_tunable,
>>>  		.set_tunable = m88e1011_set_tunable,
>>>  		.cable_test_start = marvell_vct7_cable_test_start,
> 

