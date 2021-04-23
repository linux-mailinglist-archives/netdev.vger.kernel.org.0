Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989FE368AE8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhDWCDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWCDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:03:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE38C061574;
        Thu, 22 Apr 2021 19:02:40 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j14-20020a17090a694eb0290152d92c205dso406537pjm.0;
        Thu, 22 Apr 2021 19:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MIgdRjUh37KQpO3V53b3PzVFuP1EGMTOBO5R7sQ4s44=;
        b=jrOv5SVRGoXakdq5c6ty45y4EMN+/UQPhG1Gz0G0uHim0lhaW6TVYc+N/V6OELfCSJ
         Gtem1rEE/vMqX+otWKg3aum4dLnzqh0SN0lAXGGiYZBf5ASYhuanqtiN4n//2FFjNbtu
         Z4ZBwkuZfBBIDBRF9/8pfBwhDMIx805YYBYxW7h8AqLgbUF6h07mNXnZj2eUNsxdhh/O
         yw0m7eDOa/UH2BBY+dnxB7hs1mIdAU/DmTOYvgxSuFv2jDVoib0RujAadNf9OmvDyOtH
         m9BoutcM6/yU0Z3tVIoi+xazORaq9E7bLoZpp01q3tJAL2dhDXDuHeE//xTDDP+DcgK1
         X/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIgdRjUh37KQpO3V53b3PzVFuP1EGMTOBO5R7sQ4s44=;
        b=RG27h3jeaKlfNswbytL15g482UeXC/9DY8zfT//S3j1tiACgbI8suBqiO9aAK+BA3o
         vUc22F0e8Jhm7GWTYGsz2OwyKsMxmqvveJtuI/wYiEiQQbedM8SZorRbOSs/j9slRUZo
         OuxfMnWeUPCJ5/RfTNE3nqEV1v8I75ZVMenOnTnEVValzWX4pKbRhAiyGvCtQ99dpwqa
         JrW8HEfNC2dRuQCrrCfP9oI2jqSUULf6vLT9klObVdCdCpN1YC9aSgGIF9ek4TEV9g9i
         KWqmyxmRjk2DylCkdnvIKQGEpmV/W/sZBspb1HWXhIPDPV/dBF8MSaueY+Bw0SOjPOne
         k9vA==
X-Gm-Message-State: AOAM530Xs0+9dSusea+Ilm2BcwZecYqhORpG10INHN7INcpOXdETn4aS
        +y1gWxwuDW7239LkNrCxlkWmTWgfBVA=
X-Google-Smtp-Source: ABdhPJw3K2W9fZBiaJg/10xJwsrXtpI/hNtnoTOa/fhFPBkVQWTCVUSsAeImRQQJDBRcqr/DRCCsag==
X-Received: by 2002:a17:902:bd4a:b029:ec:7b39:9738 with SMTP id b10-20020a170902bd4ab02900ec7b399738mr1718439plx.59.1619143360004;
        Thu, 22 Apr 2021 19:02:40 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cv12sm3118503pjb.35.2021.04.22.19.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 19:02:39 -0700 (PDT)
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
Date:   Thu, 22 Apr 2021 19:02:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423014741.11858-12-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> qca8k require special debug value based on the switch revision.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 193c269d8ed3..12d2c97d1417 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -909,7 +909,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  {
>  	const struct qca8k_match_data *data;
>  	struct qca8k_priv *priv = ds->priv;
> -	u32 reg, val;
> +	u32 phy, reg, val;
>  
>  	/* get the switches ID from the compatible */
>  	data = of_device_get_match_data(priv->dev);
> @@ -928,7 +928,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	case 3:
>  	case 4:
>  	case 5:
> -		/* Internal PHY, nothing to do */
> +		/* Internal PHY, apply revision fixup */
> +		phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> +		switch (priv->switch_revision) {
> +		case 1:
> +			/* For 100M waveform */
> +			qca8k_phy_dbg_write(priv, phy, 0, 0x02ea);
> +			/* Turn on Gigabit clock */
> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x68a0);
> +			break;
> +
> +		case 2:
> +			qca8k_phy_mmd_write(priv, phy, 0x7, 0x3c, 0x0);
> +			fallthrough;
> +		case 4:
> +			qca8k_phy_mmd_write(priv, phy, 0x3, 0x800d, 0x803f);
> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x6860);
> +			qca8k_phy_dbg_write(priv, phy, 0x5, 0x2c46);
> +			qca8k_phy_dbg_write(priv, phy, 0x3c, 0x6000);
> +			break;

This would be better done with a PHY driver that is specific to the
integrated PHY found in these switches, it would provide a nice clean
layer and would allow you to expose additional features like cable
tests, PHY statistics/counters, etc.
-- 
Florian
