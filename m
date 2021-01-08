Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91322EF5C9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbhAHQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbhAHQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:32:35 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBE1C061380;
        Fri,  8 Jan 2021 08:31:55 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d26so9553910wrb.12;
        Fri, 08 Jan 2021 08:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xAwtLZwG1n/rtPb+HaOYBF6Ue15E36xJoznb7POJ5y8=;
        b=jxXLuTuB/VqBH6ypeYCHydQ1iQLFOOd4NYMcZFC6gZADVvIVyxdJM80NjGVl7Hm8iJ
         WiymFQ8HZa26ifMg6R/E0jNIU4ywVxgztpg9I4oU02G5uc5frKNQ1PpsCcnHfhR44Neq
         w8VZjOGM92i/Dn0GBowmEHJ0UWg+yxMram6uqB2zJlercuauqbIC+Gs4bormOQHpHbAs
         d2iMojOMC6WApGfVb8j7X7vZk/uiNgVgoH/c21n01PfetXAyTZQHhXXtF/7tpbHZh44k
         x8ZGpibzS+A0pUa4sMgrZ7+7zeZyNDwbmUvLit/2i5SDyDv6+NmQW71GKuyiof1UorrJ
         aoWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xAwtLZwG1n/rtPb+HaOYBF6Ue15E36xJoznb7POJ5y8=;
        b=ZBdjMDlnHJOv2VWK+RE/Hl1gW8ga6dmT8OqQrC5CJ9JGLj6TIsa+Qq0icUDG+gs7Dv
         yihemXtRd+Ch0Piezy6mvo+/lzVFvj4D2i3DS1R1EzyRf6m37HD5aEghhtYf2GgImyvF
         4JniTAPXLdNrCwAf8kQXA63Z77nl6NbziudXkQAnYH3KZHdUkYIBfHi6XwzPZ0xOSnDZ
         ODfgezMjpFFfhxa4BqZ1/cDCJfUGt4nyCrjEjVLGHHFBYIeyZnYNzQas3SMPHVip/9Jh
         pADz2Z1Dh04ITdVJM/JslW0NWRYzyGJ1sXHjq/v8nAhfemSXGZtwn6boEJplqx5wTogv
         8eLA==
X-Gm-Message-State: AOAM533pfoQxDZllzbIBn9VIp+rlYYfPTIpXKVRaToV7JiHTqqIDITIz
        r5yhDrmlbsNSLrJIp1kSLdJu9x9ogrE=
X-Google-Smtp-Source: ABdhPJyM3k6ev7+ZRikg5TVAihgCZLrx3dFotGs+u/Wbz3vKUTOax/uzlpOhj7tBuoeRDqyB3iSfcQ==
X-Received: by 2002:adf:9567:: with SMTP id 94mr4489409wrs.394.1610123513643;
        Fri, 08 Jan 2021 08:31:53 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4? (p200300ea8f0655006dbbaa764e1a5cc4.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4])
        by smtp.googlemail.com with ESMTPSA id u83sm13296286wmu.12.2021.01.08.08.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 08:31:53 -0800 (PST)
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
To:     Claudiu Beznea <claudiu.beznea@microchip.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
Date:   Fri, 8 Jan 2021 17:31:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.01.2021 16:45, Claudiu Beznea wrote:
> KSZ9131 is used in setups with SAMA7G5. SAMA7G5 supports a special
> power saving mode (backup mode) that cuts the power for almost all
> parts of the SoC. The rail powering the ethernet PHY is also cut off.
> When resuming, in case the PHY has been configured on probe with
> slew rate or DLL settings these needs to be restored thus call
> driver's config_init() on resume.
> 
When would the SoC enter this backup mode? And would it suspend the
MDIO bus before cutting power to the PHY?
I'm asking because in mdio_bus_phy_restore() we call phy_init_hw()
already (that calls the driver's config_init).

> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 3fe552675dd2..52d3a0480158 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1077,7 +1077,7 @@ static int kszphy_resume(struct phy_device *phydev)
>  	 */
>  	usleep_range(1000, 2000);
>  
> -	ret = kszphy_config_reset(phydev);
> +	ret = phydev->drv->config_init(phydev);
>  	if (ret)
>  		return ret;
>  
> 

