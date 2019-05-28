Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1EF2CE8C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfE1SWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:22:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42744 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfE1SWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:22:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so21326269wrb.9
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ojRxK9djvYNxFa5zBqX9XaOViJM4soudVbBnnWycGeM=;
        b=dZgXMVa+2LNfjhK6vWZw3DJYefk929bm1NXEARz7Bxkzj8RebwlN25WTMy1O+3lL3a
         gDw9cLiPgTxdiAwijkRs5+V22w6kNa3xfT5DxYvEJQcAS5Lyl66MtK+gvXJElQpr2Zgs
         VDeValB096Kzn9Y+tI1qwCJ4GjgAKiCld2TshWbX8RpkEyJG3rfqqBemQD9Y/YgmX62b
         319MNRc2F9oMfZJ+f2EVQWgXbSk9+NU0xAiJqpibUKcZs7NL0n5zQiWFlpUTz9KK/WFN
         WjUwYxENZ8u6hjW2k3l7TA3sz1o/em++3nosfnuUt7dtjVTLOhANvQvNaO/o1NIPbigt
         oGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ojRxK9djvYNxFa5zBqX9XaOViJM4soudVbBnnWycGeM=;
        b=ayZn5LJARHjJIfV+o7zUbG7NS4yJv9K92cyau+CVDEWnLq9M/HNFveijmZqDkQotfI
         anokrWqJKC6wpZ7X6tV93jx6aUPxO4xMWxsEC6BS2gmvDKSntl/FQfopgITSMhazMUSY
         ofSzAuC6wFw82aTMbIog/a9HGL9PkPXatJHnV3bloQOuK9nptOpww+OYvGf9NTgb1B/o
         oXkAsh/uXt15vW00CmVa3qIGhMnXSgXiszUzTlnawT+rpEgW/yMaTrhoL0pqzrZTxhuS
         qfpvpA+TzcxSPGwZQNskVTKc1qds6m98bDS+JGeiH3TcwRsN+sqWymsROllaO7A2xM9O
         bosQ==
X-Gm-Message-State: APjAAAU2+LxbP+fK5zc0MnHTvGJb+SQDNqbbrN6vtGJBNiLVwJU/lCAH
        edFtR+liZK4dScJ8XDIuX88vhiEi
X-Google-Smtp-Source: APXvYqwqZuEIm449WCMkkStGlKjkRbRBYvGyUTHwh7C+d+5YYn+umIcvH5SpdZ44MqC6pbYJMpxX0g==
X-Received: by 2002:a5d:4682:: with SMTP id u2mr70047865wrq.202.1559067762954;
        Tue, 28 May 2019 11:22:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id o6sm40720520wrh.55.2019.05.28.11.22.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:22:42 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: move handling latched link-down to
 phylib state machine
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <b79f49f8-a42b-11c1-f83e-c198fee49dab@gmail.com>
 <20190528131524.unl7uvgzurcppu7s@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c359e2f4-143c-868a-8383-403280b5a7f4@gmail.com>
Date:   Tue, 28 May 2019 20:22:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528131524.unl7uvgzurcppu7s@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2019 15:15, Russell King - ARM Linux admin wrote:
> On Mon, May 27, 2019 at 08:29:45PM +0200, Heiner Kallweit wrote:
>> Especially with fibre links there may be very short link drops. And if
>> interrupt handling is slow we may miss such a link drop. To deal with
>> this we remove the double link status read from the generic link status
>> read functions, and call the state machine twice instead.
>> The flag for double-reading link status can be set by phy_mac_interrupt
>> from hard irq context, therefore we have to use an atomic operation.
> 
> I came up with a different solution to this - I haven't extensively
> tested it yet though:
> 
>  drivers/net/phy/phy-c45.c    | 12 ------------
>  drivers/net/phy/phy.c        | 29 +++++++++++++++++++----------
>  drivers/net/phy/phy_device.c | 14 --------------
>  3 files changed, 19 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index 9e24d9569424..756d7711cbc5 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -222,18 +222,6 @@ int genphy_c45_read_link(struct phy_device *phydev)
>  		devad = __ffs(mmd_mask);
>  		mmd_mask &= ~BIT(devad);
>  
> -		/* The link state is latched low so that momentary link
> -		 * drops can be detected. Do not double-read the status
> -		 * in polling mode to detect such short link drops.
> -		 */
> -		if (!phy_polling_mode(phydev)) {
> -			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
> -			if (val < 0)
> -				return val;
> -			else if (val & MDIO_STAT1_LSTATUS)
> -				continue;
> -		}
> -
>  		val = phy_read_mmd(phydev, devad, MDIO_STAT1);
>  		if (val < 0)
>  			return val;
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 7b3c5eec0129..2e7f0428e8fa 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -507,20 +507,29 @@ static int phy_config_aneg(struct phy_device *phydev)
>   */
>  static int phy_check_link_status(struct phy_device *phydev)
>  {
> -	int err;
> +	int err, i;
>  
>  	WARN_ON(!mutex_is_locked(&phydev->lock));
>  
> -	err = phy_read_status(phydev);
> -	if (err)
> -		return err;
> +	/* The link state is latched low so that momentary link drops can
> +	 * be detected. If the link has failed, re-read the link status
> +	 * to ensure that we are up to date with the current link state,
> +	 * while notifying that the link status has changed.
> +	 */
> +	for (i = 0; i < 2; i++) {
> +		err = phy_read_status(phydev);
> +		if (err)
> +			return err;
>  
> -	if (phydev->link && phydev->state != PHY_RUNNING) {
> -		phydev->state = PHY_RUNNING;
> -		phy_link_up(phydev);
> -	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
> -		phydev->state = PHY_NOLINK;
> -		phy_link_down(phydev, true);
> +		if (phydev->link && phydev->state != PHY_RUNNING) {
> +			phydev->state = PHY_RUNNING;
> +			phy_link_up(phydev);
> +		} else if (!phydev->link && phydev->state != PHY_NOLINK) {
> +			phydev->state = PHY_NOLINK;
> +			phy_link_down(phydev, true);
> +		}
> +		if (phydev->link)
> +			break;

One drawback of this approach may be that if we have an up-down-up
cycle then callback link_change_notify isn't called for either
transition. In most cases this shouldn't be an issue, but it's not
the expected behavior.

>  	}
>  
>  	return 0;
> [...]
