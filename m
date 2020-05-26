Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037551E27BC
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgEZQzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgEZQzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:55:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13790C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:55:06 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l26so234149wme.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i0BrIkzA9q8i9QNmQzvY9gP1lpuGfJrxZYwvAmWjhTg=;
        b=rMoA3PCJUQ7q+aCaB/CujveFzvQLi0zHDbYZEkCay4FfcH7SGpdNVmKG+DxKks0Zxu
         x6iBm0DO08JRG2pErjhRg+RD2Aac5+7sscDoeeinFA2Fl/24+TetDm08QNz4bUKcy+LE
         cluWWStKSU2T7a/3gYuyi48hxrbbJYvTPbDkfEpyRS0U47VLZU5jvDIrqnMwo01+6TW2
         UZL18t4/PsLStzaB+WOf2ijfj/z+yOdtcP9yCU0hg2NPF7RPsvrbHRMpTAY/yFbMSORD
         Z71KFHBX2IhIRkP03jr6iFiv1CkbrBYe2XueIPZs+Qpp4TskgYHRQ95brL0EFHzQ3/qw
         lVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i0BrIkzA9q8i9QNmQzvY9gP1lpuGfJrxZYwvAmWjhTg=;
        b=OxoeEnuhFIAkavCjwEoph8HEzP6LtvjjITy/5DcuxkMOxFMyox8F2ZAVjRPlRwQYj5
         A8RO5rlapOyqPMTOhwi43fDXAo2wnzoUBd+OdIzMyJzbgE+XZHdzVbrUKQDBFYeWxn5X
         DJ25TbtL7cJcnuiRFSwdsvEQrYq0VIroWbK7Lk/2y0cX1N136oTQxa4l5WKF23q7O6jQ
         uhigBc0K0uzubLvyT7Sbpu+3RtyvIPw8RLO9ULXDqa+ZP8cyH6xkhd3wRqw9HiIAqQU1
         6GrY+xHFUrf8ktiFl3/Xijmts8+h6aN0wNkUaLrd0djpSqcPWb/YRM0yWzRmWrjlggBk
         +cLw==
X-Gm-Message-State: AOAM532gKuq7owWo4PUlYw1fEN8dUWhBBXp3Jc6n/6QxWkQZjjQtzudf
        A6dxYH22CDj311rt75MZDzY=
X-Google-Smtp-Source: ABdhPJzydMyl3wtj9F+bkoBZLZNQBi6xZSJESDsKdZqvQjwq0ezN9LrR4qsZSacpArcHTM2+SK/Wwg==
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr181182wmj.54.1590512104401;
        Tue, 26 May 2020 09:55:04 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k14sm341538wrq.97.2020.05.26.09.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 09:55:03 -0700 (PDT)
Subject: Re: [PATCH net-next] net: mdiobus: add clause 45 mdiobus accessors
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
References: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d338d9e1-3f3e-c6a1-3eea-4614e9c2437e@gmail.com>
Date:   Tue, 26 May 2020 09:55:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 8:29 AM, Russell King wrote:
> There is a recurring pattern throughout some of the PHY code converting
> a devad and regnum to our packed clause 45 representation. Rather than
> having this scattered around the code, let's put a common translation
> function in mdio.h, and provide some register accessors.
> 
> Convert the phylib core, phylink, bcm87xx and cortina to use these.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---

[snip]

> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -428,9 +428,8 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)

This should probably be changed to use u16 regnum in a separate patch.

>  	if (phydev->drv && phydev->drv->read_mmd) {
>  		val = phydev->drv->read_mmd(phydev, devad, regnum);
>  	} else if (phydev->is_c45) {
> -		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> -
> -		val = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, addr);
> +		val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
> +					 devad, regnum);
>  	} else {
>  		struct mii_bus *bus = phydev->mdio.bus;
>  		int phy_addr = phydev->mdio.addr;
> @@ -485,10 +484,8 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)

and likewise.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
