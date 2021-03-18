Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47768340830
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhCROyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhCROyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:54:09 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF0C06174A;
        Thu, 18 Mar 2021 07:54:08 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso3573624wmi.0;
        Thu, 18 Mar 2021 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zq17IkQsrNUsXP+07sWIsplyG1ml5Si3wFWK55wyySk=;
        b=SGonUtw9DeBOF3DpV5mzN5oCAIHaVF1Q7exYFRQb6rYoHEO2yXEazxv16lDHLi3Mj0
         OWpbv4YkkqLurLcUSWgRNQu43OeiFoNgKukXTFrisi/JnNbok/szDVn8+XsGd6kWsgHx
         Ysn5Seh4jpuRxxPuO9tW16xHE7CuhZmi3dtN7aj5dk2viziMNOBnZ326Kym9h6jnUYTa
         3tv3qSW92ixx/UNR3UFWlCfmYnJ1P/fV78Odl+dtPdQ1PczPyOMvEqXCMYXs9y9TurtN
         AG6mA3RXJ8l7+UoduPCQLqxv3tsVwn7XWuUg4gM1DTj4UVLA1ruEbjyjpMr2is+Diq08
         cW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zq17IkQsrNUsXP+07sWIsplyG1ml5Si3wFWK55wyySk=;
        b=lpfd/GzUQOZeceVuc995W8itkrPgi0aCQZbFIgxmNcmAMbDHI57JORu7Zgpw6wwntv
         oR1jfSpgis/FOpYXDpV9LApFr8oHiGdJRP17gv9cWkKIoV54J+My3wMAtxKsAhR3fDRQ
         hTwjS2o4m6y7hRfwGVUtz7m1tbO2kldMOHdeuR5iokrsHVDdaBVHH5oCzlsmmd3XHTBV
         25cup2n2b/Dai6XAWHipGTpSwcWOhXbFf85AE/cBvwnZOgs+W/UfEyUliLPhM4rWr6ZC
         EUKZXChL4yKOsBboPnj+0bylrMz7CI6j/hxzF8TZOZobuh65hBEA97wZj0lA83Bze602
         7mLQ==
X-Gm-Message-State: AOAM530lJSApqgBXPUBFqtrBQQs+bHpUkBdZxYAnIbyP0goIzhmyJ3MK
        rUmK53M19oMwHrSTbIHQiphryQ80zzjIWQ==
X-Google-Smtp-Source: ABdhPJybQJnLUuV3oTP9I+F7IUOsM2u/fTuFjLfivsRy7gj5PWvpDgLMFxKE/t7YBdNNx3NjrpXfcQ==
X-Received: by 2002:a1c:600a:: with SMTP id u10mr4085992wmb.139.1616079247294;
        Thu, 18 Mar 2021 07:54:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84? (p200300ea8f1fbb008d2c08cc6c7f1a84.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84])
        by smtp.googlemail.com with ESMTPSA id m3sm2177463wme.40.2021.03.18.07.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 07:54:06 -0700 (PDT)
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210318142356.30702-1-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: at803x: remove at803x_aneg_done()
Message-ID: <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
Date:   Thu, 18 Mar 2021 15:54:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318142356.30702-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 15:23, Michael Walle wrote:
> at803x_aneg_done() is pretty much dead code since the patch series
> "net: phy: improve and simplify phylib state machine" [1]. Remove it.
> 

Well, it's not dead, it's resting .. There are few places where
phy_aneg_done() is used. So you would need to explain:
- why these users can't be used with this PHY driver
- or why the aneg_done callback isn't needed here and the
  genphy_aneg_done() fallback is sufficient


> [1] https://lore.kernel.org/netdev/922c223b-7bc0-e0ec-345d-2034b796af91@gmail.com/
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/at803x.c | 31 -------------------------------
>  1 file changed, 31 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index c2aa4c92edde..d7799beb811c 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -751,36 +751,6 @@ static void at803x_link_change_notify(struct phy_device *phydev)
>  	}
>  }
>  
> -static int at803x_aneg_done(struct phy_device *phydev)
> -{
> -	int ccr;
> -
> -	int aneg_done = genphy_aneg_done(phydev);
> -	if (aneg_done != BMSR_ANEGCOMPLETE)
> -		return aneg_done;
> -
> -	/*
> -	 * in SGMII mode, if copper side autoneg is successful,
> -	 * also check SGMII side autoneg result
> -	 */
> -	ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
> -	if ((ccr & AT803X_MODE_CFG_MASK) != AT803X_MODE_CFG_SGMII)
> -		return aneg_done;
> -
> -	/* switch to SGMII/fiber page */
> -	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr & ~AT803X_BT_BX_REG_SEL);
> -
> -	/* check if the SGMII link is OK. */
> -	if (!(phy_read(phydev, AT803X_PSSR) & AT803X_PSSR_MR_AN_COMPLETE)) {
> -		phydev_warn(phydev, "803x_aneg_done: SGMII link is not ok\n");
> -		aneg_done = 0;
> -	}
> -	/* switch back to copper page */
> -	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr | AT803X_BT_BX_REG_SEL);
> -
> -	return aneg_done;
> -}
> -
>  static int at803x_read_status(struct phy_device *phydev)
>  {
>  	int ss, err, old_link = phydev->link;
> @@ -1198,7 +1168,6 @@ static struct phy_driver at803x_driver[] = {
>  	.resume			= at803x_resume,
>  	/* PHY_GBIT_FEATURES */
>  	.read_status		= at803x_read_status,
> -	.aneg_done		= at803x_aneg_done,
>  	.config_intr		= &at803x_config_intr,
>  	.handle_interrupt	= at803x_handle_interrupt,
>  	.get_tunable		= at803x_get_tunable,
> 

