Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C5E37330C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhEEA1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:27:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhEEA1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:27:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5NO-002Yq5-Nq; Wed, 05 May 2021 02:26:54 +0200
Date:   Wed, 5 May 2021 02:26:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 04/20] net: dsa: qca8k: handle
 qca8k_set_page errors
Message-ID: <YJHmTsPVAmyIdFSj@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-4-ansuelsmth@gmail.com>
 <YJHmAxsyh08CnPHA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHmAxsyh08CnPHA@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -161,14 +169,19 @@ static void
> >  qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> >  {
> >  	u16 r1, r2, page;
> > +	int ret;
> >  
> >  	qca8k_split_addr(reg, &r1, &r2, &page);
> >  
> >  	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> >  
> > -	qca8k_set_page(priv->bus, page);
> > +	ret = qca8k_set_page(priv->bus, page);
> > +	if (ret < 0)
> > +		goto exit;
> > +
> >  	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
> >  
> > +exit:
> >  	mutex_unlock(&priv->bus->mdio_lock);
> 
> Maybe make this function also return the error? 

Ah, sorry, a later patch does exactly that.

    Andrew
