Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F282EB0C4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbhAEQ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbhAEQ7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 11:59:09 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B23EC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 08:58:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q18so36914164wrn.1
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 08:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2ujwZ2yFOZTDSFxo7p2ag4LHaMsUchX9qQ7BvwaG85A=;
        b=UVt4/2IQ3aT0SHPINeJUoh3GTLQvBZ6nxfSukJfgRG4JolpUu2C389MFjC++cdBUbh
         WT2pzQJvOIVL5XK3CyFyiEn2ubMT1gzWovACBU39l9M/hdZeTGtYB2d30iu4c5x7u+Do
         PvezgexZdoNzWsxuqiatCAACkYGbc0nWJQkbwvt/nsQfDAPnpjWHbUcw3Tdq8nSlxbEO
         szxuZjAhsUE+oe7uXeXOmadrHIiMb/UspB4NOn5YjM8LqQHhzcvZL6mm+uVmAYCkBCVw
         I+Y5scY+77SikrHtJO4kYfFDDXDMfVmQroF3AcR26d6DSEa51dLYIGbdnfGF/Xr7e9CZ
         6+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ujwZ2yFOZTDSFxo7p2ag4LHaMsUchX9qQ7BvwaG85A=;
        b=k0RpmPpasTiGxO7XjXwRgJAZMYPbNtEKCDvZExs1SmhVgBiSVj3E5S6J/08P8JMug3
         9/IkvlvqNn/KkRw5mHC4f2awFunHxe9BiTT9Nz8ax083ewsroa8r7IP8FpqTcLcUciWe
         QfssVUPHOiE7nJBmf2BwnNznik9S0Zh7kQyxA7xkBVJ0ItUFqqyrS6HF873HE97mZWux
         H6PhXkDzXhHqOd5tb7E7G7wMA9uD4fe3r+DBGBjkhtcVB1jwrPC5q9LyKCMsGtdNC0Qs
         hBNNNultCZ6YhQ6sHPPc3pfWRO9DwI44YyZzAB2cdC6bfK3+NjZ3E/jrCXClzjhGbOJK
         xOcw==
X-Gm-Message-State: AOAM532PmjSn7r4vzB8D47q0bgyMBJIjHbqpGh8g14DjMF/6Yo00+fTO
        x+7X5w82l3QB+Le5wlvPCtKYLIA4CZ8=
X-Google-Smtp-Source: ABdhPJyAfjMUHHk4A2IlXmJqPTmQMAsperE3W/Pk/8+KNoMUJ2b6Fma8wELaGHT4TkN4TOSkV5fKsA==
X-Received: by 2002:a5d:4e89:: with SMTP id e9mr474328wru.201.1609865907344;
        Tue, 05 Jan 2021 08:58:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:34e8:e6f:b763:bca1? (p200300ea8f06550034e80e6fb763bca1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:34e8:e6f:b763:bca1])
        by smtp.googlemail.com with ESMTPSA id s205sm88489wmf.46.2021.01.05.08.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 08:58:26 -0800 (PST)
Subject: Re: [PATCH] net: phy: Trigger link_change_notify on PHY_HALTED
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
References: <20210105161136.250631-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <06732cde-8614-baa1-891a-b80a35cabcbc@gmail.com>
Date:   Tue, 5 Jan 2021 17:58:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105161136.250631-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.2021 17:11, Marek Vasut wrote:
> In case the PHY transitions to PHY_HALTED state in phy_stop(), the
> link_change_notify callback is not triggered. That's because the
> phydev->state = PHY_HALTED in phy_stop() is assigned first, and
> phy_state_machine() is called afterward. For phy_state_machine(),
> no state transition happens, because old_state = PHY_HALTED and
> phy_dev->state = PHY_HALTED.
> 

There are a few formal issues with this patch:
- It misses a net/net-next annotation. If it's meant to be a fix,
  then the Fixes tag is missing. I just checked the existing
  link_change_notify handlers and nobody is interested in state
  transitions to PHY_HALTED. Therefore I think it's more of an
  improvement. However AFAICS net-next is still closed.

- The maintainers should be in To: and the list(s) on cc.
- Seems that Russell and Jakub are missing as maintainers.


> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 45f75533c47c..fca8c3eebc5d 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1004,6 +1004,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
>  void phy_stop(struct phy_device *phydev)
>  {
>  	struct net_device *dev = phydev->attached_dev;
> +	enum phy_state old_state;
>  
>  	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
>  		WARN(1, "called from state %s\n",
> @@ -1021,8 +1022,17 @@ void phy_stop(struct phy_device *phydev)
>  	if (phydev->sfp_bus)
>  		sfp_upstream_stop(phydev->sfp_bus);
>  
> +	old_state = phydev->state;
>  	phydev->state = PHY_HALTED;
>  
> +	if (old_state != phydev->state) {

This check shouldn't be needed because it shouldn't happen that
phy_stop() is called from status PHY_HALTED. In this case the
WARN() a few lines above would have fired already.

> +		phydev_err(phydev, "PHY state change %s -> %s\n",
> +			   phy_state_to_str(old_state),
> +			   phy_state_to_str(phydev->state));
> +		if (phydev->drv && phydev->drv->link_change_notify)
> +			phydev->drv->link_change_notify(phydev);

Instead of duplicating this code it could be factored out into
a small helper that is used by phy_stop() and phy_state_machine().

> +	}
> +
>  	mutex_unlock(&phydev->lock);
>  
>  	phy_state_machine(&phydev->state_queue.work);
> 

