Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1E31A963
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhBMBPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBMBPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:15:01 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF7FC0613D6;
        Fri, 12 Feb 2021 17:14:20 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id r2so714874plr.10;
        Fri, 12 Feb 2021 17:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2HBbAxna5V9uGOTlhmRj+qlmDACVmhJUS4dQyyTjdMU=;
        b=j21u/66bP1mePuQgGA5mVkz0xvAEG7gpGkowyO5EpoX9/RyRT30epRuAPvQJY0tEht
         Fehh36vpLJy5zk/II070lBce9oOatfKMt7KeJzJ1a54G8OxZnvux3fE+tnxsDDWCTVou
         fji6UnOE6MqwK3K/VkYJpd/gVZauwwZe9kbue9ajrPhgjPJvMqesj3JwmndP4drhQUDp
         ffvrdDfh9OhgWaEFhoKt86k0CnaHm/eTV30vXjD8Kn1Pf8XdhohZqUR0Yk6nw7By4yo1
         p4/QxMnt2HKsYNnfgfmO0mVrb8Kh6Le18V1k1Nn0jLUCoumwetdbzts8wVEey0/GRH3T
         1qSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2HBbAxna5V9uGOTlhmRj+qlmDACVmhJUS4dQyyTjdMU=;
        b=XwEa/65wlcmvLFj5dZocUAz4nuIPGz1URxDp5gwvG1DH7lUZDcfRtsNgotKRQH0U1W
         0ZgH6Jm+BuFFMIZQimg50P0MxKLTVVgbdRQJ8mexdc4a3Yel90SEBvhXkhUsTzfGgV6E
         yovLZ6oKXZh3SHqPQuNvMdITIW7ZEqcRdB1/d3HtgC3hi9Cfdpb3fs5nRYnyYen85heP
         EiVXF2bGglEK+Eb36D71n59Duu8Huk3QUiFdQlH5fdNA8G9AphyiZ7qb0qz1/M+oMx9N
         RSX/drquFXP3crdQsB56WzLBQDe7TM67ild8xGEtzi3Pztcm4V0+OUfIEWsQKBDxTBbt
         nhYw==
X-Gm-Message-State: AOAM53271h6j67NPKy/CllLB4KJ+q1Rluc0MiNomzrwLhjFpcMWxpEIB
        Ey24rmj1TGTAveV1F2Gaqh4=
X-Google-Smtp-Source: ABdhPJyWw5Ur9akQcuECtPVuJNRXShJBswWkBan1tDrHCc/GQkQ6vNBIVU3sd3FrbXXRCCpV8eDd+g==
X-Received: by 2002:a17:90a:7343:: with SMTP id j3mr5092556pjs.169.1613178860435;
        Fri, 12 Feb 2021 17:14:20 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v9sm8787623pju.33.2021.02.12.17.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:14:19 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Fix RXC/TXC auto
 disabling
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-3-f.fainelli@gmail.com>
 <20210213011147.6jedwieopekiwxqd@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <01e62046-7674-bb1d-115f-9044726c0ce7@gmail.com>
Date:   Fri, 12 Feb 2021 17:14:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213011147.6jedwieopekiwxqd@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 5:11 PM, Vladimir Oltean wrote:
> On Fri, Feb 12, 2021 at 12:57:20PM -0800, Florian Fainelli wrote:
>> When support for optionally disabling the TXC was introduced, bit 2 was
>> used to do that operation but the datasheet for 50610M from 2009 does
>> not show bit 2 as being defined. Bit 8 is the one that allows automatic
>> disabling of the RXC/TXC auto disabling during auto power down.
>>
>> Fixes: 52fae0837153 ("tg3 / broadcom: Optionally disable TXC if no link")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  include/linux/brcmphy.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
>> index da7bf9dfef5b..3dd8203cf780 100644
>> --- a/include/linux/brcmphy.h
>> +++ b/include/linux/brcmphy.h
>> @@ -193,7 +193,7 @@
>>  #define BCM54XX_SHD_SCR3		0x05
>>  #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
>>  #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
>> -#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
>> +#define  BCM54XX_SHD_SCR3_TRDDAPD	0x0100
>>  
>>  /* 01010: Auto Power-Down */
>>  #define BCM54XX_SHD_APD			0x0a
>> -- 
>> 2.25.1
>>
> 
> We may have a problem here, with the layout of the Spare Control 3
> register not being as universal as we think.
> 
> Your finding may have been the same as Kevin Lo's from commit
> b0ed0bbfb304 ("net: phy: broadcom: add support for BCM54811 PHY"),
> therefore your change is making BCM54XX_SHD_SCR3_TRDDAPD ==
> BCM54810_SHD_SCR3_TRDDAPD, so currently this if condition is redundant
> and probably something else is wrong too:
> 
> 	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
> 		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
> 		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
> 			val |= BCM54810_SHD_SCR3_TRDDAPD;
> 		else
> 			val |= BCM54XX_SHD_SCR3_TRDDAPD;
> 	}
> 
> I'm not sure what "TRDD" stands for, but my copy of the BCM5464R
> datasheet shows both bits 2 as well as 8 as being reserved. I have
> "CLK125 Output" in bit 0, "DLL Auto Power-Down" in bit 1, "SD/Energy
> Detect Change" in bit 5, "TXC Disable" in bit 6, and that's about it.

Let me go back to the datasheet of all of the PHYs supported by
bcm54xx_adjust_rxrefclk() and make sure we set the right bit.

I also have no idea what TRDD stands for.

> 
> But I think it doesn't matter what BCM5464R has, since this feature is
> gated by PHY_BRCM_DIS_TXCRXC_NOENRGY.
Yes, but it should be working nonetheless.
-- 
Florian
