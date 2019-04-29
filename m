Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91663E94F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfD2Rhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:37:39 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37987 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfD2Rhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 13:37:38 -0400
Received: by mail-yw1-f67.google.com with SMTP id i66so4007214ywe.5;
        Mon, 29 Apr 2019 10:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zEdf9d4KQvbMaZGBunv4+X3eRcRsfOxXcPjEXykTguk=;
        b=QiFVKbifUNyJUfYIRv9SRFfcWdmKzj6RXf604b+L/yfg46/AFGfN4hjbOvLWe3pdz7
         /PtHsRyUYUjMs+mEaOWw6+m1ajTxn20RuRqskQipBHXvfmuM7kHGXn8Q8Huff5PxzOoQ
         MfDKAvqsaLSh4biGXA/2tpdjmHnASzIWyNTKyqpEfAbpcj0NBVNwRh1TvlqMNoJyDNJI
         K25Rs3A3gtiwoZAhUmfW5yxg3lB87w3v2qj9KX0Tz7Im+rmiMALBn1uWokLWdSkbIDLc
         PmcLOzSnsHV0xB80OCTk5Wv8St34qw8SRM4AMYfbUprJrbevrM/6+O6/2PN2VBTMnhmP
         3XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zEdf9d4KQvbMaZGBunv4+X3eRcRsfOxXcPjEXykTguk=;
        b=App/0OOwRY0W9VgD8TYmJyJM5RGKVyANM0MuuGf0DGQG3tCuLrleAEpZm9kMSzeT9C
         i5c+NUBh8m+R13U+vYj2qcq23H196w+ug90IGm6cQaCpU2aCLO6kgEbdvgNbpeaMhmn4
         z/zVvUt4FxZMx5rIHgyu//wgS9yOP87wix9lMfdEKRw3BwHkVQMsdam0/mspvCLeTNfS
         ySYKbA+T7UB3U0nv5llIb48OqaadYKMhMJdfpGKMaALVCz7nEheiiinAjeDJ8unovL7m
         30PaAOrNh9MXz5synYh0eHrFrTdVGBOs5Rp6bcHEeZ/SyZgB1HmPCJ2q7ZrAuf+sXkwe
         XkPA==
X-Gm-Message-State: APjAAAWgakicJLM5rRpc+tiMsYObat67d3/FItzoWv9h1zauqhDLNATn
        xelZHUHCwT+Kf8ZVVWXbBuPfF/sM
X-Google-Smtp-Source: APXvYqzkorFpQo1egvmtFG0eYJXSW3Dxp3JCjKgTxXc5Uxr1j/erUHXDFmVbkWRlXLCVtOz9L0gs/Q==
X-Received: by 2002:a81:2209:: with SMTP id i9mr52212412ywi.293.1556559456818;
        Mon, 29 Apr 2019 10:37:36 -0700 (PDT)
Received: from [10.67.48.227] ([192.19.223.250])
        by smtp.googlemail.com with ESMTPSA id b69sm1376833ywh.18.2019.04.29.10.37.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 10:37:35 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Serge Semin <fancer.lancer@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com>
 <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
Date:   Mon, 29 Apr 2019 10:37:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426233511.qnkgz75ag7axt5lp@mobilestation>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/19 4:35 PM, Serge Semin wrote:
> On Fri, Apr 26, 2019 at 11:46:31PM +0200, Andrew Lunn wrote:
>> On Sat, Apr 27, 2019 at 12:21:12AM +0300, Serge Semin wrote:
>>> It's prone to problems if delay is cleared out for other than RGMII
>>> modes. So lets set/clear the TX-delay in the config register only
>>> if actually RGMII-like interface mode is requested.
>>>
>>> Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
>>>
>>> ---
>>>  drivers/net/phy/realtek.c | 16 ++++++++++++----
>>>  1 file changed, 12 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>>> index ab567a1923ad..a18cb01158f9 100644
>>> --- a/drivers/net/phy/realtek.c
>>> +++ b/drivers/net/phy/realtek.c
>>> @@ -163,16 +163,24 @@ static int rtl8211c_config_init(struct phy_device *phydev)
>>>  static int rtl8211f_config_init(struct phy_device *phydev)
>>>  {
>>>  	int ret;
>>> -	u16 val = 0;
>>> +	u16 val;
>>>  
>>>  	ret = genphy_config_init(phydev);
>>>  	if (ret < 0)
>>>  		return ret;
>>>  
>>> -	/* enable TX-delay for rgmii-id and rgmii-txid, otherwise disable it */
>>> -	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>>> -	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
>>> +	/* enable TX-delay for rgmii-id/rgmii-txid, and disable it for rgmii */
>>> +	switch (phydev->interface) {
>>> +	case PHY_INTERFACE_MODE_RGMII:
>>> +		val = 0;
>>> +		break;
>>> +	case PHY_INTERFACE_MODE_RGMII_ID:
>>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>>>  		val = RTL8211F_TX_DELAY;
>>> +		break;
>>> +	default: /* the rest of the modes imply leaving delay as is. */
>>> +		return 0;
>>> +	}
>>
>> So there is no control of the RX delay?
>>
> 
> As you can see it hasn't been there even before this change. So I suppose
> either the hardware just doesn't support it (although the openly available
> datasheet states that there is an RXD pin) or the original driver developer
> decided to set TX-delay only.
> 
> Just to make sure you understand. I am not working for realtek and don't
> posses any inside info regarding these PHYs. I was working on a project,
> which happened to utilize a rtl8211e PHY. We needed to find a way to
> programmatically change the delays setting. So I searched the Internet
> and found the U-boot rtl8211f driver and freebsd-folks discussion. This
> info has been used to write the config_init method for Linux version of the
> PHY' driver. That's it.
> 
>> That means PHY_INTERFACE_MODE_RGMII_ID and
>> PHY_INTERFACE_MODE_RGMII_RXID are not supported, and you should return
>> -EINVAL.
>>
> 
> Apparently the current config_init method doesn't support RXID setting.
> The patch introduced current function code was submitted by
> Martin Blumenstingl in 2016:
> https://patchwork.kernel.org/patch/9447581/
> and was reviewed by Florian. So we'd better ask him why it was ok to mark
> the RGMII_ID as supported while only TX-delay could be set.
> I also failed to find anything regarding programmatic rtl8211f delays setting
> in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> 
> Anyway lets clarify the situation before to proceed further. You are suggesting
> to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> requested to be enabled for the PHY. It's fair seeing the driver can't fully
> support either of them.

That is how I read Andrew's suggestion and it is reasonable. WRT to the
original changes from Martin, he is probably the one you would want to
add to this conversation in case there are any RX delay control knobs
available, I certainly don't have the datasheet, and Martin's change
looks and looked reasonable, seemingly independent of the direction of
this very conversation we are having.

But what about the rest of the modes like GMII, MII
> and others? 

The delays should be largely irrelevant for GMII and MII, since a) the
PCB is required to have matching length traces, and b) these are not
double data rate interfaces

> Shouldn't we also return an error instead of leaving a default
> delay value?

That seems a bit harsh, those could have been configured by firmware,
whatever before Linux comes up and be correct and valid. We don't know
of a way to configure it, but that does not mean it does not exist and
some software is doing it already.

> 
> The same question can be actually asked regarding the config_init method of
> rtl8211e PHY, which BTW you already tagged as Reviewed-by.
> 
>> This is where we get into interesting backwards compatibility
>> issues. Are there any broken DT blobs with rgmii-id or rgmii-rxid,
>> which will break with such a change?
>>
> 
> Not that I am aware of and which simple grep rtl8211 could find. Do you
> know about one?
> 
> -Sergey
> 
>> 	Andrew


-- 
Florian
