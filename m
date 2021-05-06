Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4630375D02
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhEFVyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhEFVyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 17:54:37 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84ECC061574;
        Thu,  6 May 2021 14:53:38 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n2so7163381wrm.0;
        Thu, 06 May 2021 14:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ehzMC3baDkP+yU9cvxxvTEPGYM2hhUOxxcM3hdvysfQ=;
        b=O8fOTg6dQISM5IB3x5hG/4Ine6HRgFqc+NBNViVxZ43acOatagnfhGfS558F1a0+OR
         o2KqG/rq33CaR04gu4YlrviliC2BiWzJcF2bwcAh9zGYdx9cXswU+1f6L3F1sTfNZ7y8
         I6JTenvJNTZ3JN/ASPkxtN17EYDXW8ljGJK7icLWTc8cmomvl1Rni08L0b6QcTzcJUtL
         R5ioemMnUDYssVXI5rl06+90nH5mopZh3ma6qJ5K/ARMKvRbcJVKiS2pYoK6RDpFrK6i
         ikTQ45dJf6cn51hVetLv119JCN+IJ71kTmZ2fUA87LCfwjihT5o622DM5Zs/54qluQSO
         vbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ehzMC3baDkP+yU9cvxxvTEPGYM2hhUOxxcM3hdvysfQ=;
        b=MwMyw8ncMH0fr2OtNUe5fNd5ZRjrHHkF3YG0LkSMdVeZaocQ3fAFB+OdEdnqelNu2L
         bD/l0gM5OBsiiGstXLT/8hj+koXYRRRAfWtM/dFhUEgdJ/Zk+QCFTje2sssc5Y0O8Tid
         MgxisTQ2qz76HR/92FSbpjsZuKL5xGQWzzK0Epm7pspJ30zQnbU+WXnVYdhr5eSIz1+9
         1eLySB9GgBpuFdbtW4ynjLCdIv5WmAaZd4uuceH8W+1MbYUYA2QvyI2INlcHMI56G78b
         5EVa4TrFM974EpoFYDFbWKmIqZZJZk+xkR2/JSllsV280TUyhSwJRHWCjbX9xRbSWgc6
         PbZA==
X-Gm-Message-State: AOAM530LTx5Gd4mWMW1dd0vSxkpm7ZWaVWTNihxjaDLl2xYsTvEQyjUB
        uu8XgSdaKxUFXfahflSLELU=
X-Google-Smtp-Source: ABdhPJxbyUBN+2bcDAAjZ8tiJSW+nRnLSqUlAXqZmoWd7Hvg/o3j8V3cRAnJpHby/P3r7OChV+iTaQ==
X-Received: by 2002:a5d:6687:: with SMTP id l7mr8153408wru.235.1620338017483;
        Thu, 06 May 2021 14:53:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id c5sm6089071wrs.73.2021.05.06.14.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 14:53:36 -0700 (PDT)
Date:   Thu, 6 May 2021 23:53:36 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 13/20] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJRlYAOtFHaaIguW@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-13-ansuelsmth@gmail.com>
 <20210506111033.w4v4jj3amwhyj4r3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506111033.w4v4jj3amwhyj4r3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 02:10:33PM +0300, Vladimir Oltean wrote:
> On Wed, May 05, 2021 at 12:29:07AM +0200, Ansuel Smith wrote:
> > The legacy qsdk code used a different delay instead of the max value.
> > Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
> > using the standard rx/tx-internal-delay-ps ethernet binding and apply
> > qsdk values by default. The connected gmac doesn't add any delay so no
> > additional delay is added to tx/rx.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++--
> >  drivers/net/dsa/qca8k.h | 11 +++++----
> >  2 files changed, 55 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 22334d416f53..cb9b44769e92 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -779,6 +779,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
> >  	return 0;
> >  }
> >  
> > +static int
> > +qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
> > +{
> > +	struct device_node *ports, *port;
> > +	u32 val;
> > +
> > +	ports = of_get_child_by_name(priv->dev->of_node, "ports");
> 
> Consider falling back to searching for the "ethernet-ports" name too,
> DSA should now support both.
>

The function qca8k_setup_mdio_bus also checks for ports node. Should I
also there the fallback correct?

> > +	if (!ports)
> > +		return -EINVAL;
> > +
> > +	/* Assume only one port with rgmii-id mode */
> > +	for_each_available_child_of_node(ports, port) {
> > +		if (!of_property_match_string(port, "phy-mode", "rgmii-id"))
> > +			continue;
> > +
> > +		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
> > +			val = 2;
> > +
> > +		if (val > QCA8K_MAX_DELAY) {
> > +			dev_err(priv->dev, "rgmii rx delay is limited to more than 3ps, setting to the max value");
> > +			priv->rgmii_rx_delay = 3;
> 
> ?!
> 3 picoseconds is not a lot of clock skew for a 125/25/2.5 MHz clock. 3 nanoseconds maybe?
> 
> > +		} else {
> > +			priv->rgmii_rx_delay = val;
> > +		}
> > +
> > +		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
> > +			val = 1;
> > +
> > +		if (val > QCA8K_MAX_DELAY) {
> > +			dev_err(priv->dev, "rgmii tx delay is limited to more than 3ps, setting to the max value");
> > +			priv->rgmii_tx_delay = 3;
> > +		} else {
> > +			priv->rgmii_rx_delay = val;
> > +		}
> > +	}
> > +
> > +	of_node_put(ports);
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  qca8k_setup(struct dsa_switch *ds)
> >  {
> > @@ -808,6 +849,10 @@ qca8k_setup(struct dsa_switch *ds)
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = qca8k_setup_of_rgmii_delay(priv);
> > +	if (ret)
> > +		return ret;
> > +
> >  	/* Enable CPU Port */
> >  	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
> >  			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> > @@ -1018,8 +1063,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  		 */
> >  		qca8k_write(priv, reg,
> >  			    QCA8K_PORT_PAD_RGMII_EN |
> > -			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> > -			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> > +			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
> > +			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
> > +			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
> > +			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> >  		/* QCA8337 requires to set rgmii rx delay */
> >  		if (data->id == QCA8K_ID_QCA8337)
> >  			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index 0b503f78bf92..80830bb42736 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -36,12 +36,11 @@
> >  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
> >  #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
> >  #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> > -#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		\
> > -						((0x8 + (x & 0x3)) << 22)
> > -#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
> > -						((0x10 + (x & 0x3)) << 20)
> > -#define   QCA8K_MAX_DELAY				3
> > +#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
> > +#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
> > +#define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
> >  #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
> > +#define   QCA8K_MAX_DELAY				3
> >  #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
> >  #define QCA8K_REG_PWS					0x010
> >  #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
> > @@ -251,6 +250,8 @@ struct qca8k_match_data {
> >  
> >  struct qca8k_priv {
> >  	u8 switch_revision;
> > +	u8 rgmii_tx_delay;
> > +	u8 rgmii_rx_delay;
> >  	struct regmap *regmap;
> >  	struct mii_bus *bus;
> >  	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
> > -- 
> > 2.30.2
> > 
