Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEB2341A16
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCSKcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:32:12 -0400
Received: from mx.i2x.nl ([5.2.79.48]:54082 "EHLO mx.i2x.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhCSKbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 06:31:50 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Mar 2021 06:31:50 EDT
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id 24E975FB12;
        Fri, 19 Mar 2021 11:25:56 +0100 (CET)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="D239ADue";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id D3ED5B17AE5;
        Fri, 19 Mar 2021 11:25:55 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D3ED5B17AE5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1616149555;
        bh=ANu+7V/Eez3ob22Ix7TLB1GB0Pyn7ZUcUF5mBZmRflI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D239ADueBEbxTpKgW1tWeevvifzhBeWXZ5vjOLSY8JL5A0XJ1wCmT3k2GUXoVF53a
         x/kw+7T8XYClp3mFpP+XlaidYpYe8DDTxyh4qcunpyuH4OmMWq4Mevj7NrjB5X1ONF
         PKYymWJtuoleV7AQwDUxid1li/+OqEnnZgdzkiphRJlEwWS9LoKtEf2RaXCjGbX6ec
         B+oeuoisuWZY9SnmDn4KaOeEZMoofRttBj3AenQnApJ/4I/JKR6t60Atka/jajh8Sx
         UYHYspNbDT+LkTRHdne2mrf8RR6ME7nrSXCinCm/9yneoqA4TAGy/Aaik2VG3+/wD6
         7lgVOaVhYqRtQ==
Received: from 2a02-a453-deab-1-caf8-57c0-c865-5881.fixed6.kpn.net
 (2a02-a453-deab-1-caf8-57c0-c865-5881.fixed6.kpn.net
 [2a02:a453:deab:1:caf8:57c0:c865:5881]) by www.vdorst.com (Horde Framework)
 with HTTPS; Fri, 19 Mar 2021 10:25:55 +0000
Date:   Fri, 19 Mar 2021 10:25:55 +0000
Message-ID: <20210319102555.Horde.jeA-oYm4tfkVqKj-gnqxRoo@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        sander@svanheule.net, tsbogend@alpha.franken.de, john@phrozen.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net,v2] net: dsa: mt7530: setup core clock even in
 TRGMII mode
References: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
 <20210312080703.63281-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210312080703.63281-1-ilya.lipnitskiy@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>:

> A recent change to MIPS ralink reset logic made it so mt7530 actually
> resets the switch on platforms such as mt7621 (where bit 2 is the reset
> line for the switch). That exposed an issue where the switch would not
> function properly in TRGMII mode after a reset.
>
> Reconfigure core clock in TRGMII mode to fix the issue.
>
> Tested on Ubiquiti ER-X (MT7621) with TRGMII mode enabled.
>
> Fixes: 3f9ef7785a9c ("MIPS: ralink: manage low reset lines")
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 52 +++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index f06f5fa2f898..9871d7cff93a 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -436,34 +436,32 @@ mt7530_pad_clk_setup(struct dsa_switch *ds,  
> phy_interface_t interface)
>  			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
>
>  	/* Setup core clock for MT7530 */
> -	if (!trgint) {
> -		/* Disable MT7530 core clock */
> -		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
> -
> -		/* Disable PLL, since phy_device has not yet been created
> -		 * provided for phy_[read,write]_mmd_indirect is called, we
> -		 * provide our own core_write_mmd_indirect to complete this
> -		 * function.
> -		 */
> -		core_write_mmd_indirect(priv,
> -					CORE_GSWPLL_GRP1,
> -					MDIO_MMD_VEND2,
> -					0);
> -
> -		/* Set core clock into 500Mhz */
> -		core_write(priv, CORE_GSWPLL_GRP2,
> -			   RG_GSWPLL_POSDIV_500M(1) |
> -			   RG_GSWPLL_FBKDIV_500M(25));
> +	/* Disable MT7530 core clock */
> +	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
>
> -		/* Enable PLL */
> -		core_write(priv, CORE_GSWPLL_GRP1,
> -			   RG_GSWPLL_EN_PRE |
> -			   RG_GSWPLL_POSDIV_200M(2) |
> -			   RG_GSWPLL_FBKDIV_200M(32));
> -
> -		/* Enable MT7530 core clock */
> -		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
> -	}
> +	/* Disable PLL, since phy_device has not yet been created
> +	 * provided for phy_[read,write]_mmd_indirect is called, we
> +	 * provide our own core_write_mmd_indirect to complete this
> +	 * function.
> +	 */
> +	core_write_mmd_indirect(priv,
> +				CORE_GSWPLL_GRP1,
> +				MDIO_MMD_VEND2,
> +				0);
> +
> +	/* Set core clock into 500Mhz */
> +	core_write(priv, CORE_GSWPLL_GRP2,
> +		   RG_GSWPLL_POSDIV_500M(1) |
> +		   RG_GSWPLL_FBKDIV_500M(25));
> +
> +	/* Enable PLL */
> +	core_write(priv, CORE_GSWPLL_GRP1,
> +		   RG_GSWPLL_EN_PRE |
> +		   RG_GSWPLL_POSDIV_200M(2) |
> +		   RG_GSWPLL_FBKDIV_200M(32));
> +
> +	/* Enable MT7530 core clock */
> +	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
>
>  	/* Setup the MT7530 TRGMII Tx Clock */
>  	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
> --
> 2.30.2

Hi Ilya,

Thanks for fixing this issue.

I remember that Frank also had an issue with TRGMII on his MT7623 ARM board.
I never found why it did not work but this may be also fix his issue  
on the MT7623 devices.

Added Frank to CC.

Tested on Ubiquiti ER-X-SFP (MT7621) with and without TRGMII mode enabled.

Tested-by: René van Dorst <opensource@vdorst.com>

Greats,

René

