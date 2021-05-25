Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A871338F83D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhEYChI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhEYChH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:37:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DA2C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:35:38 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id i5so21575514pgm.0
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MPtMdNslJQXFqhEewp8iNBf+OizIJhjUdYwFEDl/8Lc=;
        b=FE1SqbZIlLBVVkhH3vsc4zqKqAVEgHA9Eh8u5AQoHWkU5ZihixQssstGWLPB/1cO6H
         9kZMd16jVVfnviTYadXgUWKUR2qx+aE347SHmaF+brxlRv3iZRxNz/yl8CKlJB+/CeLC
         KYULjnelqs043ibv4DyMzm0D32KqkKI7daGhYpI5GwcZVt3JaNxQTjhJfi0B2Mp60E4o
         vN/rBjmhLbwYhFF2zxBRn+6koXlBG1Duj3MYSTQ/ZpmRNVjB6mCEzBlt2JA9D5T7YGHr
         zGYau1WVBEwZ/CIPgklnVWSL0xbfsCtCmT9BaijriOlVp3YvjqpRAlte9nlv13iJTvCn
         Eukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MPtMdNslJQXFqhEewp8iNBf+OizIJhjUdYwFEDl/8Lc=;
        b=c4eRHRiiYnO4AlpxmnDVGFaBOsQu5+7YO+/zEjE0A0MfJw/EPUna2AYxn03NfNPSZy
         GvEd6s2oGl8k/NuKTcNPVIrTQN4BIEcfi/f9kipXGGekjOW2GHWddKF1Ckmo3wC0v7Hn
         I5zEdIgbvrz3/CigbEbLytgDdyFPltlNPEfdVc8441zTOVAbBYIdXG45HoR7jfveK0uU
         1ahrFuUSj7+kymUBfKD/4pzVbszzAS0aDceEcaGJV2sDt36mat4fqYJQv2U/Mw0iS80S
         lG0Uq4LL4/mjZ5Fhkad5dw/lkja4FHlu7EhHKczSBckCHxX3P+yP/BjTuM5URw+JgNyS
         SbZg==
X-Gm-Message-State: AOAM533ZQD3ThE7VLHUIiUIufIGH5l7mGmF7Wi6c43W7H+b4N3dsOgoC
        aGr+pN3/Q2DhoJciUNziaA0=
X-Google-Smtp-Source: ABdhPJwpq99kbKzfg+sjpXCDjpRSw49QcqjQMjgY5K88onafQ4Fwi/cCjQWU/8Q2omV8LXPU9KcMvA==
X-Received: by 2002:a62:3782:0:b029:2de:903d:8640 with SMTP id e124-20020a6237820000b02902de903d8640mr28262279pfa.40.1621910137312;
        Mon, 24 May 2021 19:35:37 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a26sm12010227pff.149.2021.05.24.19.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:35:36 -0700 (PDT)
Subject: Re: [PATCH net-next 12/13] net: dsa: sja1105: expose the SGMII PCS as
 an mdio_device
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-13-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5c287794-1f47-ad79-0a60-2eeec8469a5f@gmail.com>
Date:   Mon, 24 May 2021 19:35:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-13-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1110 has up to 4 PCSes for SGMII/2500base-x, and they have a
> different access procedure compared to the SJA1105. Since both have a
> register layout reminiscent of clause 45, the chosen abstraction to hide
> this difference away was to implement an internal MDIO bus for the PCS,
> and to use a high-level set of procedures called sja1105_pcs_read and
> sja1105_pcs_write.
> 
> Since we touch all PCS accessors again, now it is a good time to check
> for error codes from the hardware access as well. We can't propagate the
> errors very far due to phylink returning void for mac_config and
> mac_link_up, but at least we print them to the console.
> 
> The SGMII PCS of the SJA1110 is not functional at this point, it needs a
> different initialization sequence compared to SJA1105. That will be done
> by the next patch.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[snip]

> +
> +int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
> +{
> +	struct sja1105_mdio_private *mdio_priv = bus->priv;
> +	struct sja1105_private *priv = mdio_priv->priv;
> +	const struct sja1105_regs *regs = priv->info->regs;
> +	int offset, bank;
> +	u64 addr;
> +	u32 tmp;
> +	u16 mmd;
> +	int rc;
> +
> +	if (!(reg & MII_ADDR_C45))
> +		return -EINVAL;
> +
> +	/* This addressing scheme reserves register 0xff for the bank address
> +	 * register, so that can never be addressed.
> +	 */
> +	if (WARN_ON(offset == 0xff))
> +		return -ENODEV;

offset is not initialized here, did you mean to do this after it gets
initialized? And likewise in sja1110_pcs_mdio_write()?
-- 
Florian
