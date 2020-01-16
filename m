Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9183C13FAD0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbgAPUrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:47:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46756 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387797AbgAPUrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 15:47:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so20511374wrl.13
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 12:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jlKWSJ27UlqNSy4Sig0f+4P3fjbKx4bPz40QsMUuAEM=;
        b=ceJcJV0sgbv/o+Ym9g0ftuTNx0/msGdNB1VqVKMkyWDjIOgx+iKlMavlxji3O5Z1oG
         lUxV3HxKErWzkWHfSF9kaPAzWNKc/q79+bnFrknmVLxYEKYeMcxYuibyBaK7xD3tFLuQ
         +W87QYkD1FM6OjnjWF4+sp48zKXHNUb7RV0W/BXyP0MZ9Li+YsyzgRxkxFo7JYd2vb84
         CYHR8fcWMyfMM1SWOXYF4cBTWGGm1j7cdaK+G/WXSph9ImciOstNw2svHCJN/t9zhgFC
         Mh0TC1uBawYyxvZmk4VThlzO0x3yoPLMkvR8VLqXXvjOCLNs46b/iOMtlm79WpNx9gzM
         k66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jlKWSJ27UlqNSy4Sig0f+4P3fjbKx4bPz40QsMUuAEM=;
        b=o1hXwlf2COeJMMfCJIkQXb+xbR1VB6FY1qRmIq9yJs8dCprFx/s6NTyqsJy2uqpphq
         bWPMGCRdjeLZCpmoQ7RDSh99MfyFfVhsMhSTOgodwGFLBN5mjezHGKGijBMieKpDp1NN
         G+ASv6sOLZybHrVAKQ3mfIrG4/+PNgqOZX/C6NV2n75TXgiewEvU9FRYAeoKm9A2bnFk
         dbA5/LmZPm/rOzQ4rhdHuAWSfe3fevGNvlpJJx6MxR5uFPT4JTkwP0vDdANPg6ApNbPX
         KpoRW7o3N40Tt2/KlVt40rkiWqBKxKGImD6NQHzZu7cVeG0uciaVh5JY24ui44sqT7fL
         4unQ==
X-Gm-Message-State: APjAAAWpkupxo52ome8T6usEYG2eUzZkbWXAqTH5ylnvZHDN1DnmMXbE
        22gT1u/bF5+5IGEBLytxYhtVkOzR
X-Google-Smtp-Source: APXvYqwuSSip7gMsVBaNTs/rCVeofb/ZOpMXVmRCVms867HUISbpcnYQi5mQltvqudNcnfkjOMneHw==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr5383388wrx.304.1579207636874;
        Thu, 16 Jan 2020 12:47:16 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id i16sm6619323wmb.36.2020.01.16.12.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 12:47:16 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: don't crash in phy_read/_write_mmd
 without a PHY driver
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>
References: <20200116174628.16821-1-olteanv@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <45b0aaad-839a-95e6-2785-118dd844efbc@gmail.com>
Date:   Thu, 16 Jan 2020 21:47:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200116174628.16821-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.01.2020 18:46, Vladimir Oltean wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> The APIs can be used by Ethernet drivers without actually loading a PHY
> driver. This may become more widespread in the future with 802.3z
> compatible MAC PCS devices being locally driven by the MAC driver when
> configuring for a PHY mode with in-band negotiation.
> 
> Check that drv is not NULL before reading from it.
> 
If there's no dedicated PHY driver, then the genphy driver is bound.
I think therefore we don't face issues with the current code.
But the change looks reasonable.

> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> ---
> If this hasn't been reported by now I assume it wasn't an issue so far.
> So I've targeted the patch for net-next and not provided a Fixes: tag.
> 
>  drivers/net/phy/phy-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 769a076514b0..a4d2d59fceca 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -387,7 +387,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
>  	if (regnum > (u16)~0 || devad > 32)
>  		return -EINVAL;
>  
> -	if (phydev->drv->read_mmd) {
> +	if (phydev->drv && phydev->drv->read_mmd) {
>  		val = phydev->drv->read_mmd(phydev, devad, regnum);
>  	} else if (phydev->is_c45) {
>  		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> @@ -444,7 +444,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
>  	if (regnum > (u16)~0 || devad > 32)
>  		return -EINVAL;
>  
> -	if (phydev->drv->write_mmd) {
> +	if (phydev->drv && phydev->drv->write_mmd) {
>  		ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
>  	} else if (phydev->is_c45) {
>  		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> 

