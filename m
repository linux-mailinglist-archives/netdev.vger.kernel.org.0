Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA3839A97
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 05:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbfFHD6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 23:58:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42546 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730511AbfFHD6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 23:58:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so2222656pff.9;
        Fri, 07 Jun 2019 20:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fziyOYCqjT7fiG1AuUBfjRWNM48seuBbeA8taNMmYUk=;
        b=qOUE2uXa1VMion/KZecvIZSBy8dixzT30ge1HZQym3SHc5ot5vWgyKK7mn450Fs9Gs
         JTNzlTiJj6p6U55Www7Bd1P8J6LFcfdMlYW5Gf23aeuQUVWMilTu2ZMcKyzb861pRfea
         GPv0872/HdD0zxSLh2+BGx+WIY+b+HwpUX1A91XCuXiFFKD9+oM/QphOCuJrZ0NNzSSw
         QfZv8YG6FJdd793vVhzv5h3jghZYfyFa2u43ZDfbvzrm348p3w0xyoZf6wmY0qrrEpY8
         dU7Nmf+lOwMwa42LZbSI7gFQVq8N0tIlHDqGpq3KlcFK/LgJL86f8eaUa+n7QTNIqtlV
         /9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fziyOYCqjT7fiG1AuUBfjRWNM48seuBbeA8taNMmYUk=;
        b=HkvYQiYM7UdJ42zSZ2WH8ja+n4D3gkyUTccsFrE6HeAwOcbqzJs46s4ej8OK4WxIsZ
         71X9Jk3uBViivgTs0SXu4xbsinHvesmzbq3isKJtcHkk8hilG1c8qWpFjiO6DKoB0nOk
         vs/cVhW3PKSq0ldo6fJyez6M69vuPrcG66h+ArtJBmjm9o1XQPbpB5iPXWRzKv6Xj5ce
         HF4y6aIQOn3Ud+tQtDgYwZFbOQjpp7jUQk7AYPqZLF5wu+ijaNTQ10RkhGBa+7KMdfrG
         va1YrOOcXsZGhvQyzQkPIGhOnZ7nILX/Z5bRTE/vTpevyxqxnc53ISAm8B9dC/bFzICQ
         otMA==
X-Gm-Message-State: APjAAAXXgE0ODbHSDggrBIapDeOl3J3QeiPdjZHwOneLXXtCvXoUi89w
        EK1f6JYjl/EhbjZfZA3OoWo=
X-Google-Smtp-Source: APXvYqxbq79wxjg0Q0GtXkmmFjwcS3QXRNzqJCp3l4sbg0fTFlomAj5yvwwHJSjyWGl9bAc50ExdNQ==
X-Received: by 2002:a63:f957:: with SMTP id q23mr5962170pgk.326.1559966287262;
        Fri, 07 Jun 2019 20:58:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id y5sm3623505pgv.12.2019.06.07.20.58.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 20:58:06 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] net: stmmac: Convert to phylink
To:     Jose Abreu <Jose.Abreu@synopsys.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <cover.1559741195.git.joabreu@synopsys.com>
 <2528141fcc644205dc1c0a0f2640da1a0e7d5935.1559741195.git.joabreu@synopsys.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <34db7462-4f5a-155a-d230-e4c90cee1ce3@gmail.com>
Date:   Fri, 7 Jun 2019 20:58:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <2528141fcc644205dc1c0a0f2640da1a0e7d5935.1559741195.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/6/2019 4:26 AM, Jose Abreu wrote:
> Convert stmmac driver to phylink.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
[snip]

			     interface);
> -	}
> +	if (node) {
> +		ret = phylink_of_phy_connect(priv->phylink, node, 0);
> +	} else {
> +		int addr = priv->plat->phy_addr;
> +		struct phy_device *phydev;
>  
> -	if (IS_ERR_OR_NULL(phydev)) {
> -		netdev_err(priv->dev, "Could not attach to PHY\n");
> -		if (!phydev)
> +		phydev = mdiobus_get_phy(priv->mii, addr);
> +		if (!phydev) {
> +			netdev_err(priv->dev, "no phy at addr %d\n", addr);
>  			return -ENODEV;
> +		}

I am not exactly sure removing this is strictly equivalent here, but the
diff makes it hard to review.

For the sake of reviewing the code, could you structure the patches like
you did with an intermediate step being:

- prepare for PHYLINK (patch #1)
- add support for PHYLINK (parts of this patch) but without plugging it
into the probe/connect path just yet
- get rid of all PHYLIB related code (parts of this patch), which would
be a new patch #3

AFAIR, there are several cases that stmmac supports today:

- fixed PHY (covered by PHYLINK)
- PHY designated via phy-handle (covered by PHYLINK)
- PHY address via platform data (not covered by PHYLINK unless we add
support for that), with no Device Tree node
- when a MDIO bus Device Tree node is present, register the stmmac MDIO
bus (which you don't change).

I believe I have convinced myself that the third case is covered with
the change above :)

This looks great, thanks!
-- 
Florian
