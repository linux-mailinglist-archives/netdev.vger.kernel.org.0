Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBE042810C
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJJMCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhJJMCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:02:41 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59DC061570;
        Sun, 10 Oct 2021 05:00:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ec8so5970106edb.6;
        Sun, 10 Oct 2021 05:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OC3LXIDQ0xL7RmG7Zq5Y5CWUWkhboSrAiUmUoFZBr88=;
        b=X09QsVd7evnWBrjQc5T9NcvkA+pmJk60kaLm6JEWC49z2hjfe3Wk260/J8n3Ji0W4y
         ewiYFO9JBk+Eco6VOLkiTFRmLu6riWdsqgssjyrgrtzxs6016dSIfVlypAn0cwHFqlwp
         ANjo9FpigZ0g61rQRky5b7X0QThzYfSv19+yNaxFDs2D7pckZ36teMMOMBpjfMwq1pf+
         WaaqUQPHDQ9AEPkOOTSWX0zNWTGzv1ZVGapSDkNJDHoyffc8/yFZ1xVnztWTDEGmSkMV
         uI0V0/VJWsVPxAp1fqgxqn5EOj2bvCwcoIHwdwpyn/TXWukoh1Ik6++HttJJ/K45nT9y
         Efwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OC3LXIDQ0xL7RmG7Zq5Y5CWUWkhboSrAiUmUoFZBr88=;
        b=4kPLvQQMRlV0RcnBYvZIpQbXgik2jEs1WpoJC54js3grrHrJ/Uexe2xT8P99tpZDUx
         eZJXUXtoo3zpGN1ZKIjiINtKOVlSu5c++vysV2S4Woo+KXnNcg/IArtN1DbXntL8Yumz
         6LhwK20MmULToVxWEpE3yCDWBWNEl7fyBSPnchUh5houty8JwGqy3ieqcB9EBA8Xw9+1
         npAYXBar+ZwHTWzffTgQqYyJgEWP/X/8ej4WM/D1tYSqUbWtOm+Algo2QjLiWAfDIvjX
         mTMUm4JNcXRq7LdBJyVbfg1UpLPzy0jM9shn9wCO2bmGIZyhjaZbS5oLa+7S1OOdu3FU
         onEg==
X-Gm-Message-State: AOAM530lvkRQ0Ez3zMuqxNiaxtwiiycMbEiA7eQpdYTNSXB3kWhw3Xd0
        h8eKf5j4wNxm/ECUTb8HOEg=
X-Google-Smtp-Source: ABdhPJyNFBoWDLMDsqI13XJLC+4yIsXmeGgvhdK+J+Jk+eacjnkWjoYciJY/3Ho8y82MJIpThMVkBQ==
X-Received: by 2002:a05:6402:3547:: with SMTP id f7mr8470758edd.395.1633867241333;
        Sun, 10 Oct 2021 05:00:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id yz9sm2011464ejb.51.2021.10.10.05.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:00:40 -0700 (PDT)
Date:   Sun, 10 Oct 2021 14:00:38 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH 07/13] net: dsa: qca8k: add support for
 mac6_exchange, sgmii falling edge
Message-ID: <YWLV5mQBtY7bW3cz@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-8-ansuelsmth@gmail.com>
 <20211010114037.2xy65gbdeshpwg2s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010114037.2xy65gbdeshpwg2s@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 02:40:37PM +0300, Vladimir Oltean wrote:
> On Thu, Oct 07, 2021 at 12:35:57AM +0200, Ansuel Smith wrote:
> > Some device set the switch to exchange the mac0 port with mac6 port. Add
> > support for this in the qca8k driver. Also add support for SGMII rx/tx
> > clock falling edge. This is only present for pad0, pad5 and pad6 have
> > these bit reserved from Documentation.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 33 +++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/qca8k.h |  3 +++
> >  2 files changed, 36 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 5bce7ac4dea7..3a040a3ed58e 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -973,6 +973,34 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
> >  	return ret;
> >  }
> >  
> > +static int
> > +qca8k_setup_port0_pad_ctrl_reg(struct qca8k_priv *priv)
> > +{
> > +	struct device_node *node = priv->dev->of_node;
> > +	u32 mask = 0;
> > +	int ret = 0;
> > +
> > +	/* Swap MAC0-MAC6 */
> > +	if (of_property_read_bool(node, "qca,mac6-exchange"))
> > +		mask |= QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG;
> > +
> > +	/* SGMII Clock phase configuration */
> > +	if (of_property_read_bool(node, "qca,sgmii-rxclk-falling-edge"))
> > +		mask |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
> > +
> > +	if (of_property_read_bool(node, "qca,sgmii-txclk-falling-edge"))
> > +		mask |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
> > +
> > +	if (mask)
> > +		ret = qca8k_rmw(priv, QCA8K_REG_PORT0_PAD_CTRL,
> > +				QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG |
> > +				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
> > +				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> > +				mask);
> > +
> > +	return ret;
> > +}
> > +
> >  static int
> >  qca8k_setup(struct dsa_switch *ds)
> >  {
> > @@ -1006,6 +1034,11 @@ qca8k_setup(struct dsa_switch *ds)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/* Configure additional PORT0_PAD_CTRL properties */
> > +	ret = qca8k_setup_port0_pad_ctrl_reg(priv);
> > +	if (ret)
> > +		return ret;
> > +
> >  	/* Enable CPU Port */
> >  	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
> >  			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index fc7db94cc0c9..3fded69a6839 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -35,6 +35,9 @@
> >  #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
> >  #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
> >  #define QCA8K_REG_PORT0_PAD_CTRL			0x004
> > +#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)
> 
> Where can I find more information about this mac0/mac6 exchange? In this
> document for ar8327, bit 31 of PORT0 PAD MODE CTRL is reserved.
> http://www.datasheet.es/PDF/771154/AR8327-pdf.html
>

The documentation for mac06 exchange is in qca8337.
https://github.com/Deoptim/atheros/blob/master/QCA8337-datasheet.pdf
We have this theory that the bit is just reserved in qca8327 due to bad
documentation/qca hiding special stuff. But you could be right and 06
exchange is just not supported on qca8327.
We tought it was like that as many wiki report uncorrect switch in the
devices and by inspecting the real internal photo they were actually
qca8337 instead of qca8327. From initial check it seems that we actually
don't have device with qca8327 and that use mac06 exchange. (We had 8
before and they are all report the wrong switch in the wiki)

> > +#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
> > +#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
> >  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
> >  #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
> >  #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> > -- 
> > 2.32.0
> > 

-- 
	Ansuel
