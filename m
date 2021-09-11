Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181DE40791C
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 17:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhIKPh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 11:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhIKPh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 11:37:58 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFEDC061574;
        Sat, 11 Sep 2021 08:36:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id kt8so10662953ejb.13;
        Sat, 11 Sep 2021 08:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O2mwMwcDOxIsuoRKRHxGfMoBiqzRB2tMT2JxyBpXI8E=;
        b=JD3iHXMfvmJDDnkEEerT/dFmRF/lVdTduHtdmZa/Hvok2l6IKRq4lYhBKqHXpCuZjD
         5J7KvIxKm9JIpJnQrTf5OkcZN0t8+Y8XAChFqV9muQcuyEYOYE/7Ev/9uhi+FTEtSY90
         X7QxyujqcnFsXny4hxByuhFILvcm6EyozXkBZNUPu84mxSQ9lbFzsnWBXzFF/OeJNFkn
         HW0gAHjnO9qlQKyP0f9Xbscw3/Dbz18uN2iSlpgbg0JVl8qwabehIA52WiBudyanHewJ
         RKl2Fm+veCGxdULwvAwv69gNipsLeIJon5jrpnh9TNVTsUsAxElGsN7jB9bRcUABC5kz
         bFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O2mwMwcDOxIsuoRKRHxGfMoBiqzRB2tMT2JxyBpXI8E=;
        b=FXaRORko9MSz+ORG+qmcC3k5NReXmBkbHKkLbxdLwY/PSEB2nag4TGuRvPLxpI2U5b
         k7byj2G4KAgbpImXPN/tJC6XhcZKutqFvrzBwDvENag2s6PHN6ZO2YfR+Zac7ZAttp8E
         lJFrO0gbfOjphL9aqkgUi5KEXpzsDKuFDl7frnK6BlFHIV7Y+c9lhl/e5yfcZbo+m48a
         ZOb/QeTxc80cGA46iPFMx8bKhGSoOIG4zXwL4N6yYnjGToIP3UhOZ+mPNUbrx6vrUNDj
         jO21RoRF/CPIbpX4W7UMJiMh0FuKS9HDrDb4j8HJkBolt0JuAzsn0zzcJb2SPttkp9t4
         5cJA==
X-Gm-Message-State: AOAM5325FuqfFYpqJxUGxvstw6hdrkysn+mu405NO4sw2q1WWGkYZNYY
        jJyh6eROwjODyYw/Fu7IXdDJFZmTmMk=
X-Google-Smtp-Source: ABdhPJxHIgXPrdYGRfWYp4QcOLWdo9ssKSP1ReeEEdb/YbbTR0Tg0YTY/+XewBeK9JbZKPSNFjrUDw==
X-Received: by 2002:a17:906:2f15:: with SMTP id v21mr3340732eji.444.1631374603955;
        Sat, 11 Sep 2021 08:36:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-87-21-249-69.retail.telecomitalia.it. [87.21.249.69])
        by smtp.gmail.com with ESMTPSA id bx11sm916967ejb.107.2021.09.11.08.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:36:43 -0700 (PDT)
Date:   Sat, 11 Sep 2021 17:36:40 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: fix kernel panic with legacy mdio
 mapping
Message-ID: <YTzNCGutVkKZJz3t@Ansuel-xps.localdomain>
References: <20210911150731.16586-1-ansuelsmth@gmail.com>
 <5ec1a416-45e5-4679-9aa4-aa96b7f738b0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ec1a416-45e5-4679-9aa4-aa96b7f738b0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 11, 2021 at 08:31:51AM -0700, Florian Fainelli wrote:
> 
> 
> On 9/11/2021 08:07, Ansuel Smith wrote:
> > When the mdio legacy mapping is used the mii_bus priv registred by DSA
> 
> typo: registered
> 
> > refer to the dsa switch struct instead of the qca8k_priv struct and
> > cause a kernel panic.
> 
> typo: causes
> 
> > Create dedicated function when the internal
> > dedicated mdio driver is used to proprely handle the 2 different
> > implementation.
> 
> typo: properly
> 
> > 
> > Fixes: 759bafb8a322 ("net: dsa: qca8k: add support for internal phy and internal mdio")
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   drivers/net/dsa/qca8k.c | 30 ++++++++++++++++++++++--------
> >   1 file changed, 22 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 1f63f50f73f1..a701323daf72 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -643,10 +643,8 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
> >   }
> >   static int
> > -qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> > +qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
> >   {
> > -	struct qca8k_priv *priv = salve_bus->priv;
> > -	struct mii_bus *bus = priv->bus;
> >   	u16 r1, r2, page;
> >   	u32 val;
> >   	int ret;
> > @@ -682,10 +680,8 @@ qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> >   }
> >   static int
> > -qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
> > +qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
> >   {
> > -	struct qca8k_priv *priv = salve_bus->priv;
> > -	struct mii_bus *bus = priv->bus;
> >   	u16 r1, r2, page;
> >   	u32 val;
> >   	int ret;
> > @@ -726,6 +722,24 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
> >   	return ret;
> >   }
> > +static int
> > +qca8k_internal_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> > +{
> > +	struct qca8k_priv *priv = salve_bus->priv;
> 
> You are only moving code here but while at it, mind fixing that typo?
>

I think I didn't understand what you mean here.
Sure I will fix the typo and sorry about it.
Aside from that anything wrong with the 2 new function or there is a
better fix that I can't think of.

> > +	struct mii_bus *bus = priv->bus;
> > +
> > +	return qca8k_mdio_write(bus, phy, regnum, data);
> > +}
> > +
> > +static int
> > +qca8k_internal_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
> > +{
> > +	struct qca8k_priv *priv = salve_bus->priv;
> > +	struct mii_bus *bus = priv->bus;
> > +
> > +	return qca8k_mdio_read(bus, phy, regnum);
> > +}
> > +
> >   static int
> >   qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
> >   {
> > @@ -775,8 +789,8 @@ qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
> >   	bus->priv = (void *)priv;
> >   	bus->name = "qca8k slave mii";
> > -	bus->read = qca8k_mdio_read;
> > -	bus->write = qca8k_mdio_write;
> > +	bus->read = qca8k_internal_mdio_read;
> > +	bus->write = qca8k_internal_mdio_write;
> >   	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
> >   		 ds->index);
> > 
> 
> -- 
> Florian
