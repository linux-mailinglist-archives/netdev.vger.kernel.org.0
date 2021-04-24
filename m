Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114EB36A325
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhDXVVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDXVVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:21:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A920C061574;
        Sat, 24 Apr 2021 14:20:22 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n21so2546744eji.1;
        Sat, 24 Apr 2021 14:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tEC5ngR8FTEak8cjrRgfLt6W4tQ4iw0QMQFUDkBo9ws=;
        b=TVc5YhbgCbC+0ifrJKmQ966AsDT668hyl6VQ3s66gXETVrqnAbkg7vHWo18Mgg6Aq7
         bF959gjH7oVKLs2nJB0Jr8P5dqXnUNz/e9rUXeE/hSqs4inI4YlriYQAs1b2oyySsgYr
         LnD+hoVArmGB1yXwNaVoI7VwWqJaeeZsB5FVWP2O4r4grl1GSoGSTy2aBfKawsH6sNdZ
         LBmyRGr7LUJF8MHNjPEveyK2DK+ubzLY+APYCIuLsoJw1cnCdZqaZ1vCNqI6Y/vf7as9
         TqEjTyY0doG8RiXp4w19jRx2fYb0oC9Q8++FKBLSjt9HyQEwHRfZ+qZo5n5ZzhxY2rPx
         71wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tEC5ngR8FTEak8cjrRgfLt6W4tQ4iw0QMQFUDkBo9ws=;
        b=XF0slbwOvd9nUR18TAIlRkTBOipSNUh1Iy2YI0ybSOsXwvM9kVkq09ZHfcmqOJtS97
         PDRZ9weX2IpOegT0K+owAiANEDi8m6vi5+aB33sapEfzk/ujlT9WIMKQYTQo/LI8tgC1
         B9UATRnq40SjDHcKzhq24nAk5kUudkCsLD6/QxRzYCK3321s7ahx9ixHbD87hSLr+ncg
         /N1vwlwOtnA0rB6L7/+TgSJy+zjo85B8yMso2SIZwgOgEE/PoBnlGgXtun0z9nQ9w07S
         H1Mi/z0N3i1/8wbIE1ZCzHyqju1BzdOKgYLB2TDN7MkRj/aG7yBAtPvicorULMM+6I1a
         gFUQ==
X-Gm-Message-State: AOAM530HeSZZnKIJdCc5eYBz1x8ywLydqgQA4PkYii48M3K/hAebyRNL
        fWY3MdEYxQomjF0GJztr/TRc2c17eliyhA==
X-Google-Smtp-Source: ABdhPJwwp/Oni2h3FqCa7W/JSE3FBIZyv6nTdkkq1ZYVHsjRnzliryedqzCRU5IfloCriy3nZHmyMQ==
X-Received: by 2002:a17:906:3952:: with SMTP id g18mr10719501eje.104.1619299220507;
        Sat, 24 Apr 2021 14:20:20 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id d18sm10236939edv.1.2021.04.24.14.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 14:20:20 -0700 (PDT)
Date:   Sat, 24 Apr 2021 23:18:20 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Message-ID: <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
 <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 07:02:37PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> > qca8k require special debug value based on the switch revision.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 193c269d8ed3..12d2c97d1417 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -909,7 +909,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  {
> >  	const struct qca8k_match_data *data;
> >  	struct qca8k_priv *priv = ds->priv;
> > -	u32 reg, val;
> > +	u32 phy, reg, val;
> >  
> >  	/* get the switches ID from the compatible */
> >  	data = of_device_get_match_data(priv->dev);
> > @@ -928,7 +928,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  	case 3:
> >  	case 4:
> >  	case 5:
> > -		/* Internal PHY, nothing to do */
> > +		/* Internal PHY, apply revision fixup */
> > +		phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> > +		switch (priv->switch_revision) {
> > +		case 1:
> > +			/* For 100M waveform */
> > +			qca8k_phy_dbg_write(priv, phy, 0, 0x02ea);
> > +			/* Turn on Gigabit clock */
> > +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x68a0);
> > +			break;
> > +
> > +		case 2:
> > +			qca8k_phy_mmd_write(priv, phy, 0x7, 0x3c, 0x0);
> > +			fallthrough;
> > +		case 4:
> > +			qca8k_phy_mmd_write(priv, phy, 0x3, 0x800d, 0x803f);
> > +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x6860);
> > +			qca8k_phy_dbg_write(priv, phy, 0x5, 0x2c46);
> > +			qca8k_phy_dbg_write(priv, phy, 0x3c, 0x6000);
> > +			break;
> 
> This would be better done with a PHY driver that is specific to the
> integrated PHY found in these switches, it would provide a nice clean
> layer and would allow you to expose additional features like cable
> tests, PHY statistics/counters, etc.

I'm starting to do some work with this and a problem arised. Since these
value are based on the switch revision, how can I access these kind of
data from the phy driver? It's allowed to declare a phy driver in the
dsa directory? (The idea would be to create a qca8k dir with the dsa
driver and the dedicated internal phy driver.) This would facilitate the
use of normal qca8k_read/write (to access the switch revision from the
phy driver) using common function?

> -- 
> Florian
