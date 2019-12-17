Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526851238C7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLQVlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:41:46 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36365 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfLQVlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:41:46 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so4817748wma.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wSevUZ1HTWvpeHJqJgkVc94Zkc+nnOpyxSg2dlwqu7w=;
        b=PZR+VPGp6U1xOx1+VnO938Iw5GNusaK8kejbaRjJVDEkRWjTZEvGCtqZAneP6GVJcQ
         gCFsDFgFx+KFFLZr5ShPJuTG/ZcT/wMnLA7fO3R8x1B5owFZPqSAKCT4omeYf/fLIkkS
         73zMGGoc2ZwiW/3nBA390Lk/CA62En4fxkvMILMbWkHCD295LVElB4foiplwyiucQbzX
         WJNmepEX5/rQCNnfkGFphICYQTTyypBTEXnYYRLHyOKT2FSBlEQ8q0USGD9As5fmPbJU
         AgxL5CQqBB0GXYXKJ+vHespBqrAE1GuNfionii8reui7ADataO89+o7p8gaWrEjuV1Un
         7PzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wSevUZ1HTWvpeHJqJgkVc94Zkc+nnOpyxSg2dlwqu7w=;
        b=A+YGw6M1m14YbEXN33N46vv3JqQSMAWKbjeZL7gBO0rev2FgKNjnLzZWcmE2WslTKL
         PTc4BDDrTBOCqJ7FcEvtxD7z7aKQtDOS0L4hwaC9KSaULU7MhO1gt9bMglqtJMffZhxd
         fVGgjG6GdVdPlfILx9P7fDIqvQtsLjrOK4Q4p1pnef93zUW9uVvRkp2lS5A0V54zDPt0
         WZukMYJ6tmBg10fZbdk5h1jYvydXnxgHj4o/CbwRS/PDYuVEyQQkQp0ELDo7LMuNUBvW
         1Nz0d2uIHEiuwLuqKLnZ/yusCMSXnjXf20WBKFyhg266eJtMYtE/Tpjpt+TFBkRGr7Ol
         fkiw==
X-Gm-Message-State: APjAAAULObkT3dGP/Tso0N2JoBQ2C4ddtzTLKRaX1RuSG92OkFyy78G6
        p1/g//XRU3tqSEo+UAaOT8pFa8v6
X-Google-Smtp-Source: APXvYqw5/PBRpR510zzBtqMR9bO7dl9T3QTzaFxPrm3FAwbqQ9UYyFt86nuCQh7XVUS9qFaWngLStA==
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr7253334wmc.145.1576618903988;
        Tue, 17 Dec 2019 13:41:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:29f3:c6e3:2b98:f1a3? (p200300EA8F4A630029F3C6E32B98F1A3.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:29f3:c6e3:2b98:f1a3])
        by smtp.googlemail.com with ESMTPSA id h8sm84806wrx.63.2019.12.17.13.41.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2019 13:41:43 -0800 (PST)
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
Date:   Tue, 17 Dec 2019 22:41:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.12.2019 13:53, Russell King wrote:
> phy_error() is called from phy_interrupt() or phy_state_machine(), and
> uses WARN_ON() to print a backtrace. The backtrace is not useful when
> reporting a PHY error.
> 
> However, a system may contain multiple ethernet PHYs, and phy_error()
> gives no clue which one caused the problem.
> 
> Replace WARN_ON() with a call to phydev_err() so that we can see which
> PHY had an error, and also inform the user that we are halting the PHY.
> 
> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> There is another related problem in this area. If an error is detected
> while the PHY is running, phy_error() moves to PHY_HALTED state. If we
> try to take the network device down, then:
> 
> void phy_stop(struct phy_device *phydev)
> {
>         if (!phy_is_started(phydev)) {
>                 WARN(1, "called from state %s\n",
>                      phy_state_to_str(phydev->state));
>                 return;
>         }
> 
> triggers, and we never do any of the phy_stop() cleanup. I'm not sure
> what the best way to solve this is - introducing a PHY_ERROR state may
> be a solution, but I think we want some phy_is_started() sites to
> return true for it and others to return false.
> 
> Heiner - you introduced the above warning, could you look at improving
> this case so we don't print a warning and taint the kernel when taking
> a network device down after phy_error() please?
> 
I think we need both types of information:
- the affected PHY device
- the stack trace to see where the issue was triggered

In general it's not fully clear yet what's the appropriate reaction
after a PHY error. Few reasons for PHY errors I see:
- MDIO bus may not be accessible, e.g. because parent device is in
  power-down mode
- Frequently polling is used to determine end of a MDIO operation.
  If timeout for polling is too low, then we may end up with an
  -ETIMEDOUT.

In case of singular timeouts they may be acceptable or not.
- If we miss a single PHY status poll, then this may be acceptable.
- But if e.g. a relevant setting in config_init fails, then this
  may not be acceptable.

The current behavior has been existing for the last 15 years,
and I'm just aware of one issue with PHY errors. The case I've
seen was triggered by timeouts, and adjusting the timeouts
fixed it: c3b084c24c8a (net: fec: Adjust ENET MDIO timeouts)

> Thanks.
> 
>  drivers/net/phy/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 49300fb59757..06fbca959383 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -663,7 +663,7 @@ void phy_stop_machine(struct phy_device *phydev)
>   */
>  static void phy_error(struct phy_device *phydev)
>  {
> -	WARN_ON(1);
> +	phydev_err(phydev, "Error detected, halting PHY\n");
>  
>  	mutex_lock(&phydev->lock);
>  	phydev->state = PHY_HALTED;
> 

