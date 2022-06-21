Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF30E5534F7
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350160AbiFUOvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 10:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbiFUOvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 10:51:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2225275F8;
        Tue, 21 Jun 2022 07:51:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m1so11540183wrb.2;
        Tue, 21 Jun 2022 07:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=WnP5nJaFcki7iz/i8Tn1rgYp9G8/v9elZf7re9PvpmM=;
        b=lq7Qv6UdsrsZzgZLZdC7TA/qQ5UDhHGczlQynxEAysmb6s/TDm7YmD8yUUr80gqBl8
         H5K8nImrsR5OeeqXaxATLupxedhnCE0VeA4SSuE9OCHniey70y83tYTEL45nL1RpPBMA
         aQxgKL6ZK00/VqeUxeYHIMWJ3TNOXWAwEBQBt+3Hgkye/Rh/8no20Lffq8XA/QV5MOAI
         4a4uzKlqzTwEgx4dvx3HUgWajqmcaguNpulDyqWE8NTC7nvjx2KZ8Bvf70Y8MhAAZaQK
         4ifiB3aNQa/wq/q7+7Al4wexMQmc3L/5Ffsuyogmy7WYAP+4uoMFYugDooM9W0+FGfMj
         nEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=WnP5nJaFcki7iz/i8Tn1rgYp9G8/v9elZf7re9PvpmM=;
        b=dChbezP2KDoFIMxz6jbFiQD5qTiGnLw0vZ7wEAyp2rNCMXkTnlMUdZ8hzWgaVMNK6N
         zuZMi4ZFL4z6eXOVScXtgkcMiPInN5OTrIRPXdDBY+ni9MokwqcI4oxORbTtNUAt5l2B
         GwbML7yegAv7MrSX7/hJk9F9MHFn2+coDqdVtm1VgtEYx+9u2ckxedcv4/Y1pIkSiXq/
         cZ4VJ1TpLYIxL6H/bYRo+mNNeKGZTNC9ad3xGppZPzFi8j7MTJ6b9Z718F3+TwouFi81
         PJIVh3XPNOBUJi8bJT9feqRD520+Y/YxFkW+vy7G4Rwrc6nJVPkzIqulGEZVSkAgZ8LE
         Agmw==
X-Gm-Message-State: AJIora9Ciox0+vmmCjruprJV2WJ7mf8lMgfnyBi8FXxxdUPsQ+dCS/4r
        Jh8stZja9DjRyVQbCuKxIA0=
X-Google-Smtp-Source: AGRyM1v9WuMZ2aoRVg8lp7m8bXzkEPXu5zQsjrGG29AsBDsY+XeZLAliYmjnR7JShvdSLThrIIld4Q==
X-Received: by 2002:a05:6000:1a8b:b0:219:af0c:ddf8 with SMTP id f11-20020a0560001a8b00b00219af0cddf8mr28660420wry.142.1655823108733;
        Tue, 21 Jun 2022 07:51:48 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id f8-20020a05600c4e8800b003974b95d897sm25737019wmq.37.2022.06.21.07.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 07:51:48 -0700 (PDT)
Message-ID: <62b1db04.1c69fb81.a2134.1b01@mx.google.com>
X-Google-Original-Message-ID: <YrHbAs12P/xTiQBz@Ansuel-xps.>
Date:   Tue, 21 Jun 2022 16:51:46 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND net-next PATCH 3/3] net: dsa: qca8k: reset cpu port on
 MTU change
References: <20220618072650.3502-1-ansuelsmth@gmail.com>
 <20220618072650.3502-3-ansuelsmth@gmail.com>
 <20220620215619.2209533a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620215619.2209533a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 09:56:19PM -0700, Jakub Kicinski wrote:
> On Sat, 18 Jun 2022 09:26:50 +0200 Christian Marangi wrote:
> > It was discovered that the Documentation lacks of a fundamental detail
> > on how to correctly change the MAX_FRAME_SIZE of the switch.
> > 
> > In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
> > switch panics and cease to send any packet. This cause the mgmt ethernet
> > system to not receive any packet (the slow fallback still works) and
> > makes the device not reachable. To recover from this a switch reset is
> > required.
> > 
> > To correctly handle this, turn off the cpu ports before changing the
> > MAX_FRAME_SIZE and turn on again after the value is applied.
> > 
> > Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
>  
> It reads like this patch should be backported to 5.10 and 5.15 stable
> branches. While patches 1 and 2 are cleanups. In which case you should
> reports just patch 3 against net/master first, we'll send it to Linus at
> the end of the week and then you can send the cleanups on top for -next.
>

Ok will split this series.

> One extra question below.
> 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index eaaf80f96fa9..0b92b9d5954a 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -2334,6 +2334,7 @@ static int
> >  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> > +	int ret;
> >  
> >  	/* We have only have a general MTU setting.
> >  	 * DSA always set the CPU port's MTU to the largest MTU of the slave
> > @@ -2344,10 +2345,29 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> >  	if (!dsa_is_cpu_port(ds, port))
> >  		return 0;
> >  
> > +	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
> > +	 * the switch panics.
> > +	 * Turn off both cpu ports before applying the new value to prevent
> > +	 * this.
> > +	 */
> > +	if (priv->port_enabled_map & BIT(0))
> > +		qca8k_port_set_status(priv, 0, 0);
> > +
> > +	if (priv->port_enabled_map & BIT(6))
> > +		qca8k_port_set_status(priv, 6, 0);
> > +
> >  	/* Include L2 header / FCS length */
> > -	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> > -				  QCA8K_MAX_FRAME_SIZE_MASK,
> > -				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
> > +	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> 
> Why care about the return code of this regmap access but not the ones
> inside the *port_set_status() calls?
> 

No reason just following old bad behaviour done in other function where
qca8k_port_set_status is used. Will send v2 with the error handled.

> > +				 QCA8K_MAX_FRAME_SIZE_MASK,
> > +				 new_mtu + ETH_HLEN + ETH_FCS_LEN);
> > +
> > +	if (priv->port_enabled_map & BIT(0))
> > +		qca8k_port_set_status(priv, 0, 1);
> > +
> > +	if (priv->port_enabled_map & BIT(6))
> > +		qca8k_port_set_status(priv, 6, 1);
> > +
> > +	return ret;
> >  }
> >  
> >  static int

-- 
	Ansuel
