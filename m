Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE4A55352A
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352156AbiFUPES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352152AbiFUPES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:04:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC32193CC;
        Tue, 21 Jun 2022 08:04:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q9so19356653wrd.8;
        Tue, 21 Jun 2022 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=yi8KGNVnRWVNZALBVc9FWLAz6Ghaa+l0izDAbcV65+U=;
        b=kj2fdsLo9Bu9eNHHPnC5TWWWpBVAUpYPYdb8e64O1IDyHpdS6BL6qACbcd9BMrGpmH
         Dz4DJEjgeEQ58KoXVVm7so5iCKxu63DX400hCcvRHzIi6tqG/ifqqGgKtu0DNfw1Peh0
         kWMSiudAF1tVY8EDtf1ApQmsJkSxwXvapfFe/6gTvHaqsTTcoUgG2whIefxtFRL3G6ff
         T9i736RsQfZTfchOCu7DRPCX7wRA6LL/Jkqpgt313kNvgYBLFdJFyg901lN6a0qBLVuo
         mYjC3F7E2gKR+CFfnzgP8JPAhJg85jnhRdk0wea1Kt4+zhSjfJOYtUNTIZlocMxWSYxZ
         WNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=yi8KGNVnRWVNZALBVc9FWLAz6Ghaa+l0izDAbcV65+U=;
        b=NZAEjBXNG0a6xXbl+5UsP23s+NtsmNqaMPJaJK9OtAymzSWv8SFGzC1nKlnRKeQbta
         RzQKKMEDnKAsHnPk1ZZH2smqo9B0lbFCBC7dpaOnczQnZ2T9Evw2vZHoyLwjqtvt0v+g
         JPAOKQN/HrhIaTp8HrLt/VRsTP8Am23UzXJD+WWy3OdsYR/xF8G0n6FTzrn57X59wGYH
         hOCNOOJXf+VewM+HEIuWGU2cxkqHbDOLEvX8UuaAIwMT03TmfeDrsCGJoqYrtF/IVVys
         HMNcaY4owwXRLMubgLwmjvCrRShMsDeYkQj3zTJuos2uttqIp9yjSVFGnRxHlyHV8GLs
         oaJw==
X-Gm-Message-State: AJIora++Ppt/KQ2LU8N6fLnIKzohoAG6N62Er3xC1HNtaU3PpX1LktWg
        0n7vqJRFoKQ7gzdQnAu34o4=
X-Google-Smtp-Source: AGRyM1sTDNqmK6D2Q/+FbmMDPWeH/f60prdPT3TRnPIIkQ+2IdjMM+IiMlLy+T4/ERQFIHE5AiAMOw==
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id p12-20020a5d59ac000000b002185b7e1c1cmr29080476wrr.621.1655823855502;
        Tue, 21 Jun 2022 08:04:15 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id u16-20020adfed50000000b0021b89f8662esm8768746wro.13.2022.06.21.08.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 08:04:15 -0700 (PDT)
Message-ID: <62b1ddef.1c69fb81.955cc.19dd@mx.google.com>
X-Google-Original-Message-ID: <YrHd7fy5ie24gmlv@Ansuel-xps.>
Date:   Tue, 21 Jun 2022 17:04:13 +0200
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
 <62b1db04.1c69fb81.a2134.1b01@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b1db04.1c69fb81.a2134.1b01@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 04:51:46PM +0200, Christian Marangi wrote:
> On Mon, Jun 20, 2022 at 09:56:19PM -0700, Jakub Kicinski wrote:
> > On Sat, 18 Jun 2022 09:26:50 +0200 Christian Marangi wrote:
> > > It was discovered that the Documentation lacks of a fundamental detail
> > > on how to correctly change the MAX_FRAME_SIZE of the switch.
> > > 
> > > In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
> > > switch panics and cease to send any packet. This cause the mgmt ethernet
> > > system to not receive any packet (the slow fallback still works) and
> > > makes the device not reachable. To recover from this a switch reset is
> > > required.
> > > 
> > > To correctly handle this, turn off the cpu ports before changing the
> > > MAX_FRAME_SIZE and turn on again after the value is applied.
> > > 
> > > Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> >  
> > It reads like this patch should be backported to 5.10 and 5.15 stable
> > branches. While patches 1 and 2 are cleanups. In which case you should
> > reports just patch 3 against net/master first, we'll send it to Linus at
> > the end of the week and then you can send the cleanups on top for -next.
> >
> 
> Ok will split this series.
> 
> > One extra question below.
> > 
> > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > index eaaf80f96fa9..0b92b9d5954a 100644
> > > --- a/drivers/net/dsa/qca8k.c
> > > +++ b/drivers/net/dsa/qca8k.c
> > > @@ -2334,6 +2334,7 @@ static int
> > >  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > >  {
> > >  	struct qca8k_priv *priv = ds->priv;
> > > +	int ret;
> > >  
> > >  	/* We have only have a general MTU setting.
> > >  	 * DSA always set the CPU port's MTU to the largest MTU of the slave
> > > @@ -2344,10 +2345,29 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > >  	if (!dsa_is_cpu_port(ds, port))
> > >  		return 0;
> > >  
> > > +	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
> > > +	 * the switch panics.
> > > +	 * Turn off both cpu ports before applying the new value to prevent
> > > +	 * this.
> > > +	 */
> > > +	if (priv->port_enabled_map & BIT(0))
> > > +		qca8k_port_set_status(priv, 0, 0);
> > > +
> > > +	if (priv->port_enabled_map & BIT(6))
> > > +		qca8k_port_set_status(priv, 6, 0);
> > > +
> > >  	/* Include L2 header / FCS length */
> > > -	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> > > -				  QCA8K_MAX_FRAME_SIZE_MASK,
> > > -				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
> > > +	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> > 
> > Why care about the return code of this regmap access but not the ones
> > inside the *port_set_status() calls?
> > 
> 
> No reason just following old bad behaviour done in other function where
> qca8k_port_set_status is used. Will send v2 with the error handled.
>

Actually now that i checked, the qca8k_port_set_status is void... So it
would require an additional change to that function. Will make it part
of the net-next series...

> > > +				 QCA8K_MAX_FRAME_SIZE_MASK,
> > > +				 new_mtu + ETH_HLEN + ETH_FCS_LEN);
> > > +
> > > +	if (priv->port_enabled_map & BIT(0))
> > > +		qca8k_port_set_status(priv, 0, 1);
> > > +
> > > +	if (priv->port_enabled_map & BIT(6))
> > > +		qca8k_port_set_status(priv, 6, 1);
> > > +
> > > +	return ret;
> > >  }
> > >  
> > >  static int
> 
> -- 
> 	Ansuel

-- 
	Ansuel
