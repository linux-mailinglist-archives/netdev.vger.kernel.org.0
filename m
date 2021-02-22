Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3308E322293
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhBVXTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhBVXTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 18:19:16 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B728EC061574;
        Mon, 22 Feb 2021 15:18:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h10so23982201edl.6;
        Mon, 22 Feb 2021 15:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CLjzxwthn46X+TVJE1h6RLs8jKGguZxMox/UnANcpug=;
        b=hDwSFqll/MS51CAJcJfjHTjHrBydNlthl9lBwJtQne+5d52I4mfB+FGh0PWwX2RDY3
         SYokubTAj1Yx/x2ghNeHivVU9dkpLWnMq03IKDwaFyOtW3ZT3RbAMwtBLqDm/a5uicyQ
         LaJ9kbr3c9DGQVJS+aGUYXAtY6DnKYiZPdpUBaOuUhkhipwupNnsfEV2CvWLrn+/hh21
         Uuf0FxaHwInst9lB4LiYTibSmqnZdwwqbM77oO2/3NTtizJP3UBBRqwuNyOai5RIza+6
         WcFBSoVq6EOHVvcKsJXlbOsPsRFc56kZTiawcxUzFr9NCAUsSTGGXPq8HCFa/mT0NA+s
         YAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CLjzxwthn46X+TVJE1h6RLs8jKGguZxMox/UnANcpug=;
        b=UupS6EeT9rj18ie0ZpfMhca6Wy8dFyGA2p0Cjabp+YMi9M+XoZ0WkaP27RdTLZZHmC
         S5T4y+/vB8YfYK0H+/7zGExedWCOIWePkhmF6c9Mt9cIIii7erRdEK7ASSpq2TKQVeRS
         VkZ+R7IzMTOo9EnXjh4c3oa298dacpGkMGq19g3iHOlREDhIDEBQYQXt8yU4x1XfwlDU
         ToMqFrnca1IBT/D8LQeDNQKSA7pheF9wgfXrJSPxPerJArp2sAqi6bblTY52h1iG8fth
         VCuTaiIBVg1qz2LHukaSQpoP4kLyZj+o9RPXdbJanoWWQBsa9t/l/kC89dHwFWqa+2Av
         KPyA==
X-Gm-Message-State: AOAM533CYWKgpeqWdGXVe2M0jpKUDpiTJ1DMhTutMLVuLn3msun3YzU8
        FaYci3ZReiMT97nT8RtILp0=
X-Google-Smtp-Source: ABdhPJxz2ZPkBlSjdnJiRbx7BAeawloPITnNdGNav8BbFMRgAMqkDOwCy7rg7+fRjdMFctxX2IreLA==
X-Received: by 2002:aa7:cd75:: with SMTP id ca21mr3945597edb.199.1614035914328;
        Mon, 22 Feb 2021 15:18:34 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id e18sm11235871eji.111.2021.02.22.15.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 15:18:33 -0800 (PST)
Date:   Tue, 23 Feb 2021 01:18:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] net: dsa: b53: Support setting learning on
 port
Message-ID: <20210222231832.fzrq3y3vbok5byd3@skbuf>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
 <20210222223010.2907234-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222223010.2907234-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 02:30:10PM -0800, Florian Fainelli wrote:
> diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
> index c90985c294a2..b2c539a42154 100644
> --- a/drivers/net/dsa/b53/b53_regs.h
> +++ b/drivers/net/dsa/b53/b53_regs.h
> @@ -115,6 +115,7 @@
>  #define B53_UC_FLOOD_MASK		0x32
>  #define B53_MC_FLOOD_MASK		0x34
>  #define B53_IPMC_FLOOD_MASK		0x36
> +#define B53_DIS_LEARNING		0x3c
>  
>  /*
>   * Override Ports 0-7 State on devices with xMII interfaces (8 bit)
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 3eaedbb12815..5ee8103b8e9c 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -223,23 +223,10 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
>  	reg &= ~P_TXQ_PSM_VDD(port);
>  	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
>  
> -	/* Enable learning */
> -	reg = core_readl(priv, CORE_DIS_LEARN);
> -	reg &= ~BIT(port);
> -	core_writel(priv, reg, CORE_DIS_LEARN);
> -
>  	/* Enable Broadcom tags for that port if requested */
> -	if (priv->brcm_tag_mask & BIT(port)) {
> +	if (priv->brcm_tag_mask & BIT(port))
>  		b53_brcm_hdr_setup(ds, port);
>  
> -		/* Disable learning on ASP port */
> -		if (port == 7) {
> -			reg = core_readl(priv, CORE_DIS_LEARN);
> -			reg |= BIT(port);
> -			core_writel(priv, reg, CORE_DIS_LEARN);
> -		}
> -	}
> -

In sf2, CORE_DIS_LEARN is at address 0xf0, while in b53, B53_DIS_LEARN
is at 0x3c. Are they even configuring the same thing?
