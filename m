Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C441368AD0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhDWB5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWB5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:57:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209EBC061574;
        Thu, 22 Apr 2021 18:56:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso368889pjg.2;
        Thu, 22 Apr 2021 18:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LSOMfPeSpUzi5ELHzJdwqHXiOLp/kpDmUZ5uCPF1cQk=;
        b=c7QqdqQkHZNq8TYrVF1nWAknpQVAq+YCGFW9o0RxXCyHQ4FPVbL+aqY8Zxng5/0HRY
         oRwklVQastwzl3hkoWfMnxh2EVgpGGzUQ48KYIXnsw8mvRJldT8yFTVnB4Lp3+QfI3hS
         jxn+SPmfDRwJu8cjBlAUOFkxnQ9rFY9wA+f2XZzP/htrEFy8UAmU39ZnyYkt7RVtnG8j
         OXl8m1BZl/sq42gfgqjjXXY13YuS/uqBUboUd3mxPSaTIJFqUoB61sQu+saBqWN+hvqR
         xHeUBUOQkWHhhOPjyPPs59UtinlZ+yDrXGWadocs94moLXTe3uYx4nte4kT/EPhUaEtC
         noaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LSOMfPeSpUzi5ELHzJdwqHXiOLp/kpDmUZ5uCPF1cQk=;
        b=OFGhDbGQ0aBr9bRTDeeJGdvLA/vaXRoG5s9rw75JIPcAxLtuMj/YCRUboc1FKt2q7H
         A1bM60XVVA8XS6JaR25r4MlbFrj/IxhkFiI8hgWm7zpQXi4lTAEIvtCCmaqoQhecgU4o
         usWAodKDrg89dzXHn1AAoyBlS5IM+KpPFSXWQPcnZTlxpNfy5ZE3e1cOUqnxgqzImOXw
         R55FtGS5Fx95FuPNY7M2PPr0WaBtAxpaAAJokoio/hr8DSzCATs/x4/665MUpEv008yJ
         qO83Qbu52DFwp7LLEp5N98zBiOaLOYnM4ClJRRI9Db6u5wRBB4OmZ2o1yoAZukR8GK2t
         bA3A==
X-Gm-Message-State: AOAM5306CapVCZ2SsYGw5740DlmFpOLZ6J15TZOHCq+KDen6GszKn1pr
        giNY/7pKyBwSKLO0ZnNW9nxhdxkTRqI=
X-Google-Smtp-Source: ABdhPJwEdQfhdJtDfBA+XCtUBvIPaK5opOPXgWblSo7NPz9jY5JtKonk5YP22iTaKao5Q6RDUALRSg==
X-Received: by 2002:a17:902:a582:b029:ec:d002:623b with SMTP id az2-20020a170902a582b02900ecd002623bmr1743070plb.36.1619142997309;
        Thu, 22 Apr 2021 18:56:37 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z22sm3120235pgf.16.2021.04.22.18.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:56:36 -0700 (PDT)
Subject: Re: [PATCH 03/14] drivers: net: mdio: mdio-ip8064: improve busy wait
 delay
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
 <20210423014741.11858-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3157ddd3-0a93-fe2d-bc99-751708d3b9e9@gmail.com>
Date:   Thu, 22 Apr 2021 18:56:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423014741.11858-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> With the use of the qca8k dsa driver, some problem arised related to
> port status detection. With a load on a specific port (for example a
> simple speed test), the driver starts to bheave in a strange way and

s/bheave/behave/

> garbage data is produced. To address this, enlarge the sleep delay and
> address a bug for the reg offset 31 that require additional delay for
> this specific reg.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/mdio/mdio-ipq8064.c | 36 ++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
> index 1bd18857e1c5..5bd6d0501642 100644
> --- a/drivers/net/mdio/mdio-ipq8064.c
> +++ b/drivers/net/mdio/mdio-ipq8064.c
> @@ -15,25 +15,26 @@
>  #include <linux/mfd/syscon.h>
>  
>  /* MII address register definitions */
> -#define MII_ADDR_REG_ADDR                       0x10
> -#define MII_BUSY                                BIT(0)
> -#define MII_WRITE                               BIT(1)
> -#define MII_CLKRANGE_60_100M                    (0 << 2)
> -#define MII_CLKRANGE_100_150M                   (1 << 2)
> -#define MII_CLKRANGE_20_35M                     (2 << 2)
> -#define MII_CLKRANGE_35_60M                     (3 << 2)
> -#define MII_CLKRANGE_150_250M                   (4 << 2)
> -#define MII_CLKRANGE_250_300M                   (5 << 2)
> +#define MII_ADDR_REG_ADDR			0x10
> +#define MII_BUSY				BIT(0)
> +#define MII_WRITE				BIT(1)
> +#define MII_CLKRANGE(x)				((x) << 2)
> +#define MII_CLKRANGE_60_100M			MII_CLKRANGE(0)
> +#define MII_CLKRANGE_100_150M			MII_CLKRANGE(1)
> +#define MII_CLKRANGE_20_35M			MII_CLKRANGE(2)
> +#define MII_CLKRANGE_35_60M			MII_CLKRANGE(3)
> +#define MII_CLKRANGE_150_250M			MII_CLKRANGE(4)
> +#define MII_CLKRANGE_250_300M			MII_CLKRANGE(5)
>  #define MII_CLKRANGE_MASK			GENMASK(4, 2)
>  #define MII_REG_SHIFT				6
>  #define MII_REG_MASK				GENMASK(10, 6)
>  #define MII_ADDR_SHIFT				11
>  #define MII_ADDR_MASK				GENMASK(15, 11)
>  
> -#define MII_DATA_REG_ADDR                       0x14
> +#define MII_DATA_REG_ADDR			0x14
>  
> -#define MII_MDIO_DELAY_USEC                     (1000)
> -#define MII_MDIO_RETRY_MSEC                     (10)
> +#define MII_MDIO_DELAY_USEC			(1000)
> +#define MII_MDIO_RETRY_MSEC			(10)

These changes are not related to what you are doing and are just
whitespace cleaning, better not to mix them with functional changes.

>  
>  struct ipq8064_mdio {
>  	struct regmap *base; /* NSS_GMAC0_BASE */
> @@ -65,7 +66,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
>  		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
>  
>  	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> -	usleep_range(8, 10);
> +	usleep_range(10, 13);
>  
>  	err = ipq8064_mdio_wait_busy(priv);
>  	if (err)
> @@ -91,7 +92,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
>  		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
>  
>  	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> -	usleep_range(8, 10);
> +
> +	/* For the specific reg 31 extra time is needed or the next
> +	 * read will produce grabage data.

s/grabage/garbage/

> +	 */
> +	if (reg_offset == 31)
> +		usleep_range(30, 43);
> +	else
> +		usleep_range(10, 13);

This is just super weird, presumably register 31 needs to be conditional
to the PHY, or pseudo-PHY being driven here. Not that it would harm, but
waiting an extra 30 to 43 microseconds with a Marvell PHY or Broadcom
PHY or from another vendor would not be necessary.

>  
>  	return ipq8064_mdio_wait_busy(priv);
>  }
> 

-- 
Florian
