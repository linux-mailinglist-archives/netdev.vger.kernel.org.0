Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF675534C9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 16:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbiFUOqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 10:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiFUOqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 10:46:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251EE1CB1E;
        Tue, 21 Jun 2022 07:46:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k22so12845459wrd.6;
        Tue, 21 Jun 2022 07:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=sjG4KBCbJDG4xNZ8mnDMSODfXDWHdcHHaEh+82KTF38=;
        b=U6O5CE9nmtEygth+s2uD7aSc5cuDePKMlz/TTf5mG++s54obcjU1lbKGZ4X5Gy9b3f
         +VhLP5+pz//BqId5yTeVnHQMJPxU5KQ8/NHclEgQrdIHThwppVbYvBWkH9Pcl7EL10WA
         qQORB3t7FKnawtg7dGolh0OkbGrs/okR4EpzK6ZRaDypZlr7O63uL4lLiLCSMrDrIGXV
         lrCjHRhzH34TVh/pa2VanPFay5DKx0CPODUyUvVD81E2rsFrASeUthI4NToAhJvdXQ+q
         IS5jMqrKfHC6P5+iaadDdZ0Bt5zUF8WNTB8A0Z6ttoL8A4ADaeb6W3EXUeZp1662YfJ9
         WElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=sjG4KBCbJDG4xNZ8mnDMSODfXDWHdcHHaEh+82KTF38=;
        b=lawj6vB08v5qijfvjlcLjZcI1CAh/h67H15+3paLHWBkkFPCpwBG5F4nkBr6dyJfjG
         QZcN5cAGUyAZuLXxzGh7e5YnXhNaXQYtLX/lmy+UZunR9DuEIEZBoMDs1Fwhrs+ql7jA
         QRlsvPbdgayhQrq2MsqQBbBhFdt79O2UKTJbY7y9JJlRtYzv8WK6rA5LDgEI8wj/37gd
         t+rOsRzukpxCdGwc1gIE8XaHuBzMA30XFlDtAcQvwWLrKX7j6vqMAyK9C5Dsi020LUnF
         ugMGniOXTHsPVxnyaO4bL8oczj44ZS1VXMyTFMd9FdwbhNtyQacUVIrhmxfyavE5lcNB
         ZSmw==
X-Gm-Message-State: AJIora/Sre7zSE8BTg7vCux8NYAOYJoI8gWub8K3DN5mq6x0kYPAOo+x
        ffftLYyhUDCSD+r96BB+tdc=
X-Google-Smtp-Source: AGRyM1voaebqOwrRsRtdDgRD5skEGDRxbijbMJGO72qFkDSYGaerzvwrlDnipBnG2pGGj7aUaJOxQw==
X-Received: by 2002:a5d:6f19:0:b0:21a:3802:8b5b with SMTP id ay25-20020a5d6f19000000b0021a38028b5bmr25995276wrb.391.1655822768412;
        Tue, 21 Jun 2022 07:46:08 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id eh1-20020a05600c61c100b003973d425a7fsm20804729wmb.41.2022.06.21.07.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 07:46:07 -0700 (PDT)
Message-ID: <62b1d9af.1c69fb81.6ff6b.7b32@mx.google.com>
X-Google-Original-Message-ID: <YrHZrvC1l0O2qMrw@Ansuel-xps.>
Date:   Tue, 21 Jun 2022 16:46:06 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: qca8k: change only max_frame_size of
 mac_frame_size_reg
References: <20220618062300.28541-1-ansuelsmth@gmail.com>
 <20220618062300.28541-2-ansuelsmth@gmail.com>
 <20220621123041.6y7rre26iqhhwdoa@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621123041.6y7rre26iqhhwdoa@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 03:30:41PM +0300, Vladimir Oltean wrote:
> On Sat, Jun 18, 2022 at 08:22:59AM +0200, Christian Marangi wrote:
> > Currently we overwrite the entire MAX_FRAME_SIZE reg instead of tweaking
> > just the MAX_FRAME_SIZE value. Change this and update only the relevant
> > bits.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 8 ++++++--
> >  drivers/net/dsa/qca8k.h | 3 ++-
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 2727d3169c25..eaaf80f96fa9 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -2345,7 +2345,9 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> >  		return 0;
> >  
> >  	/* Include L2 header / FCS length */
> > -	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
> > +	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> > +				  QCA8K_MAX_FRAME_SIZE_MASK,
> > +				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
> >  }
> >  
> >  static int
> > @@ -3015,7 +3017,9 @@ qca8k_setup(struct dsa_switch *ds)
> >  	}
> >  
> >  	/* Setup our port MTUs to match power on defaults */
> > -	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
> > +	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> > +				 QCA8K_MAX_FRAME_SIZE_MASK,
> > +				 ETH_FRAME_LEN + ETH_FCS_LEN);
> >  	if (ret)
> >  		dev_warn(priv->dev, "failed setting MTU settings");
> >  
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index ec58d0e80a70..1d0c383a95e7 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -87,7 +87,8 @@
> >  #define   QCA8K_MDIO_MASTER_MAX_REG			32
> >  #define QCA8K_GOL_MAC_ADDR0				0x60
> >  #define QCA8K_GOL_MAC_ADDR1				0x64
> > -#define QCA8K_MAX_FRAME_SIZE				0x78
> > +#define QCA8K_MAX_FRAME_SIZE_REG			0x78
> > +#define   QCA8K_MAX_FRAME_SIZE_MASK			GENMASK(13, 0)
> 
> What's at bits 14 and beyond? Trying to understand the impact of this change.
>

Most of them are reserved bits (from Documentation).
The few we have Documentation of are debug bits about CRC handling, IPG
and special mode where the MAC send pause frames based on the signal.

It's a cleanup and seems a nice change now that we are touching this
part.

> >  #define QCA8K_REG_PORT_STATUS(_i)			(0x07c + (_i) * 4)
> >  #define   QCA8K_PORT_STATUS_SPEED			GENMASK(1, 0)
> >  #define   QCA8K_PORT_STATUS_SPEED_10			0
> > -- 
> > 2.36.1
> > 

-- 
	Ansuel
