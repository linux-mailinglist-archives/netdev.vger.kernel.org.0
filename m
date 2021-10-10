Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C557B42811F
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhJJMMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhJJMMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:12:02 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2E8C061570;
        Sun, 10 Oct 2021 05:10:04 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w14so3985500edv.11;
        Sun, 10 Oct 2021 05:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H9e0/TxDJIMjv6xwdB3s7OsMNpGirdwfD7lFQSj1KJE=;
        b=QEqGFFL6EclOivUIxM4LylbXAXIo/L4M5XoSsvcD79WQWm3V4NzjEeUsFEKUpXfu5a
         DfHhEGex6SN/PR6UYU8N6TOKUNxAOvj7hLDBAw6kYfn/PKxVKcs/19iRdTey+W+CPMAp
         Gox23kMtzUvYFU7pXYCONzF2rAs6gcI9kgsC5+PG5WXWX5Qa8sptUbF0PxK49lucNRD0
         7NpyVjbVBIOWRk8re4PbeLWgd4RxmRv//weBRqkXxSoqE9ASCfpEec8DMCBHweAOtFzB
         1+fDqnRtp1qZSBNxEfpaDZyvv6op7JLuaQ30NkzDEEGv1qaK/X8Pk/Jo25QbTJXEQKNf
         LIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H9e0/TxDJIMjv6xwdB3s7OsMNpGirdwfD7lFQSj1KJE=;
        b=Joc9FdxQHomt7Puw48BCfOd5ym8r7x7ieRrWXSJA7k5JKk0A4A9tzlgaCNcgyB5yk6
         kZ7qStLos2u212S++tYkXN0whSxFhyr10MkIY4558NIA1jdQ8LG9RdJTcVeBwP4NfFKe
         KrMtdl8/bnQlkdjO7WZ7mLyDDbNjJwXFir6DfPXkepLsHnSru7DZJgPZxFd96MMDcZXM
         3EUM4/skLHyiQZO633VJAJP/tRiw/v4bTXswcWA7dgnXlWLwwh9adP8jgfzCO0jDjUTd
         Pf9LTeKe7seUs8vANqy3DDuN0eVGaBiqQNX4Z9PqJK2xCltJfTwwDQdyRn6dmeHC+Um1
         H8Dw==
X-Gm-Message-State: AOAM533s7/QLt9f9dZ/qM38unH2e/zWqCnXA9ebE3hx+V/zeWP6FY1h4
        ILfYh0kHYI+AiKpqcBM0ZFc=
X-Google-Smtp-Source: ABdhPJxDjUQlqBq0GeM0B1uaxjzokp98/TvHdc+DD4dN3LtJh2UZluts1lc/Z8HhWgYbcxgUDOhOgQ==
X-Received: by 2002:a05:6402:35cb:: with SMTP id z11mr33460318edc.342.1633867802657;
        Sun, 10 Oct 2021 05:10:02 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id k23sm2458603edv.22.2021.10.10.05.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:10:02 -0700 (PDT)
Date:   Sun, 10 Oct 2021 14:10:00 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v4 02/13] net: dsa: qca8k: add support for sgmii
 falling edge
Message-ID: <YWLYGJjmjo/aHlae@Ansuel-xps.localdomain>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-3-ansuelsmth@gmail.com>
 <20211010120526.xzd7m3ug4plvwcjw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010120526.xzd7m3ug4plvwcjw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 03:05:26PM +0300, Vladimir Oltean wrote:
> On Sun, Oct 10, 2021 at 01:15:45PM +0200, Ansuel Smith wrote:
> > Add support for this in the qca8k driver. Also add support for SGMII
> > rx/tx clock falling edge. This is only present for pad0, pad5 and
> > pad6 have these bit reserved from Documentation. Add a comment that this
> > is hardcoded to PAD0 as qca8327/28/34/37 have an unique sgmii line and
> > setting falling in port0 applies to both configuration with sgmii used
> > for port0 or port6.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 25 +++++++++++++++++++++++++
> >  drivers/net/dsa/qca8k.h |  3 +++
> >  2 files changed, 28 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index a892b897cd0d..3e4a12d6d61c 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1172,6 +1172,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  			 const struct phylink_link_state *state)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> > +	struct dsa_port *dp;
> >  	u32 reg, val;
> >  	int ret;
> >  
> > @@ -1240,6 +1241,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  		break;
> >  	case PHY_INTERFACE_MODE_SGMII:
> >  	case PHY_INTERFACE_MODE_1000BASEX:
> > +		dp = dsa_to_port(ds, port);
> > +
> >  		/* Enable SGMII on the port */
> >  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> >  
> > @@ -1274,6 +1277,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  		}
> >  
> >  		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
> > +
> > +		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
> > +		 * falling edge is set writing in the PORT0 PAD reg
> > +		 */
> > +		if (priv->switch_id == QCA8K_ID_QCA8327 ||
> > +		    priv->switch_id == QCA8K_ID_QCA8337)
> > +			reg = QCA8K_REG_PORT0_PAD_CTRL;
> > +
> > +		val = 0;
> > +
> > +		/* SGMII Clock phase configuration */
> > +		if (of_property_read_bool(dp->dn, "qca,sgmii-rxclk-falling-edge"))
> 
> I would strongly recommend that you stop accessing dp->dn and add your
> own device tree parsing function during probe time. It is also a runtime
> invariant, there is no reason to read the device tree during each mac_config.
>

What would be the correct way to pass all these data? Put all of them in
qca8k_priv? Do we have a cleaner solution? 

> > +			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
> > +
> > +		if (of_property_read_bool(dp->dn, "qca,sgmii-txclk-falling-edge"))
> > +			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
> > +
> > +		if (val)
> > +			ret = qca8k_rmw(priv, reg,
> > +					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
> > +					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> > +					val);
> >  		break;
> >  	default:
> >  		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
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
> QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG is not used in this patch.
> 
> > +#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
> > +#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
> >  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
> >  #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
> >  #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> > -- 
> > 2.32.0
> > 
> 

-- 
	Ansuel
