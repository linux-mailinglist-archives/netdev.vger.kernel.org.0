Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDAC349934
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhCYSJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCYSJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:09:08 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B583C06174A;
        Thu, 25 Mar 2021 11:09:08 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id l18so3449222edc.9;
        Thu, 25 Mar 2021 11:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QkSCPQFeXPyylmo56pnd0Y7oq0+FKHeReHMorAr/nVQ=;
        b=IOZ4zWJHJ59pqf0Z0YMXJ5qCLpApLxy92Bs0NInudYQZuY2OvYGCyTvh6yYYtPpY4e
         AHuWIp3p/wwe+g9a2igcGnxcJaLXtMOZk6zGhu6LHO/BympOI2AJgxRoePfJfSURd2Hq
         Na76cUVW9PAq3RKecTMomPZSfl6+lIIdFtov1V2sxx1g95ip2Tok/6xqnHi0oQj8tJPy
         aVg043xZn09cqHHZvO9dvKoYwGeCX9RLVmFxZ+mbDbBz9T+XVqCs0XKmW6+OqLWn0n6w
         xqxcR/1sEY7vMaXXRuUHYS+Eg7uKYmko0CcnR3Rx7vMGBMR9Jky93Y/+YbgrcQs9ppTu
         H+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QkSCPQFeXPyylmo56pnd0Y7oq0+FKHeReHMorAr/nVQ=;
        b=k+jdriOz+jKKPXbNL1iw+NqQucZz6U+9OQrE3Za65hL3IKXXrInfKBbtV0u91xcKEz
         vhhncaAUojfxZhh4tKmFs4H7A1Zkzsl23ZRl2rEx5UoKzF7o6kFzs1EJZA+voK9opqAg
         aMAtn4/x58TrunWygsInWmlWU4zux06DzJ8foMDMaJgJufjLmv09ktO2P9KFyJ9Z/20A
         ZWTisC6hShM257p2CIp+1chwOtifu7wlDFUsr8VoT8d5SjvpDdSLuSz6aCu96gUB+lFC
         rC5IPBWuFDDzBSoj+PFvrQ1U10c12IxiJ+iEPq8LD2dl4MU9Ob0vCqqMvhUY6RgEp78Q
         lj7w==
X-Gm-Message-State: AOAM533dqcFWDLi4YKpkoFbkncWmKKvDIkS1uV8iej1EPZVPH7ggT4U2
        fKDnee/C0ma9Re8mWOR6lxY=
X-Google-Smtp-Source: ABdhPJxT9M6yMYhq1vt19t4zlzgariVKMULdoL1b0+4I9yNyqmcfyt5JwCqj6k6MLdq21EzvOERiKg==
X-Received: by 2002:aa7:dad7:: with SMTP id x23mr10472177eds.292.1616695746814;
        Thu, 25 Mar 2021 11:09:06 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ym4sm2738417ejb.100.2021.03.25.11.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 11:09:06 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: Let GSWIP automatically set
 the xMII clock
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
References: <20210324193604.1433230-1-martin.blumenstingl@googlemail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a5c0e846-c838-83b8-9c85-34b3f53dc54e@gmail.com>
Date:   Thu, 25 Mar 2021 11:09:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324193604.1433230-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 12:36 PM, Martin Blumenstingl wrote:
> The xMII interface clock depends on the PHY interface (MII, RMII, RGMII)
> as well as the current link speed. Explicitly configure the GSWIP to
> automatically select the appropriate xMII interface clock.
> 
> This fixes an issue seen by some users where ports using an external
> RMII or RGMII PHY were deaf (no RX or TX traffic could be seen). Most
> likely this is due to an "invalid" xMII clock being selected either by
> the bootloader or hardware-defaults.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
> It would be great to have this fix backported to Linux 5.4 and 5.10 to
> get rid of one more blocker which prevents OpenWrt from switching to
> this new in-tree driver.

Given there is a Fixes: tag this should land at some point in the stable
tree auto-selection. Stable fixes for networking patches follows a
slightly different path:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n145

> 
> 
>  drivers/net/dsa/lantiq_gswip.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 52e865a3912c..809dfa3be6bb 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -799,10 +799,15 @@ static int gswip_setup(struct dsa_switch *ds)
>  	/* Configure the MDIO Clock 2.5 MHz */
>  	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
>  
> -	/* Disable the xMII link */
> -	for (i = 0; i < priv->hw_info->max_ports; i++)
> +	for (i = 0; i < priv->hw_info->max_ports; i++) {
> +		/* Disable the xMII link */
>  		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
>  
> +		/* Automatically select the xMII interface clock */
> +		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_RATE_MASK,
> +				   GSWIP_MII_CFG_RATE_AUTO, i);
> +	}
> +
>  	/* enable special tag insertion on cpu port */
>  	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
>  			  GSWIP_FDMA_PCTRLp(cpu_port));
> 

-- 
Florian
