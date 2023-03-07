Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090106AFBA1
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCHA6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCHA57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:57:59 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EB721961;
        Tue,  7 Mar 2023 16:57:58 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id t15so13880352wrz.7;
        Tue, 07 Mar 2023 16:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678237077;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HS6FPXIvmqqNsIYAM5JYJ/QIONzW3Nl9HxNsbGlenoM=;
        b=XEYOm62uQkBq9a1kTtaYUa/sXQmdDN1evfVVkYdRuHIlDQocAZ/DVDu/t7HoxxJAzU
         sdG/iNf/SqbSE1smhqUQ1e/KdDdMiX5bRgrFL/iRpuVmhAzZ8eO8QrEHRqhJ4X6Zqkg7
         jHtArVRmnWuTOiZWEQEKL+Z+32WIKouf+jG+4l7YrXjStuvpeLHadXReq0IuhYxTgjqw
         URMCAAEe70JWXIfxeUsF+lFjbB3soaxGW2fxNC+OYtbuEt0+ybv+2RpoGMKdvrw5DY8Z
         fxRwqsFh1hy/Kokpd8xvtii6H9uJ3+H7vn0y7IjwKjKMobxdIwpiVRoGGfAsHJb2pJQ+
         7Pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678237077;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HS6FPXIvmqqNsIYAM5JYJ/QIONzW3Nl9HxNsbGlenoM=;
        b=t4CwKAGQyK8ao1Am3y/uaAU3xMked+E4goiyGpdJxLwIsLNq6Fwq9Y3NT80+QuWsxI
         qrO4B2ZSUdFysaH/QWxZYft2HvNOpGcFBAY8WC0alwt2Wa03Ub+vX/17zn6IHcvYaYbd
         slipAGoa+UEKiySLr7iP4lJFwkN/tVFFPvM7/Cf+gozixRodFetJgQNe3ipvrqmt2QQY
         m8jQ2cD0iVE1S2bzeTXPPvtVCnsSfW+Xf51U98T6C1XOfmzUEbkJ84mce669IN9RAdJC
         R6pfs/1n3/ZQRmviHu2rPN54nOxF/PYUbIZTp2cEMEt/sOjvVROTz56GZMiEXzN7ayoq
         +U1A==
X-Gm-Message-State: AO0yUKUoRDsyKxJjTHcuHKiBt65N+IZYIpYVpL1Jbv22OuITKlXyDstK
        4WdYBZ4owPow08O/iG5+pK0=
X-Google-Smtp-Source: AK7set9tO5H/alRCXfzjN/mP1zUeZLrxFfo+KwylfdU81WRcdlFvzou1cKKbs+HkFxOzr2ExWYrOAw==
X-Received: by 2002:adf:f30f:0:b0:2cb:f4:e5a2 with SMTP id i15-20020adff30f000000b002cb00f4e5a2mr12312806wro.14.1678237076605;
        Tue, 07 Mar 2023 16:57:56 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id f2-20020adfdb42000000b002c54fb024b2sm13605789wrj.61.2023.03.07.16.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 16:57:56 -0800 (PST)
Message-ID: <6407dd94.df0a0220.b4618.52e4@mx.google.com>
X-Google-Original-Message-ID: <ZAeTg7Tb41tmut7q@Ansuel-xps.>
Date:   Tue, 7 Mar 2023 20:41:55 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-2-ansuelsmth@gmail.com>
 <b03334df-4389-44b5-ac85-8b0878c64512@lunn.ch>
 <6407c6ea.050a0220.7c931.824f@mx.google.com>
 <d1226e21-8150-4959-95b0-e9df2c460b81@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1226e21-8150-4959-95b0-e9df2c460b81@lunn.ch>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 01:49:55AM +0100, Andrew Lunn wrote:
> On Tue, Mar 07, 2023 at 06:57:10PM +0100, Christian Marangi wrote:
> > On Wed, Mar 08, 2023 at 12:16:13AM +0100, Andrew Lunn wrote:
> > > > +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > > > +{
> > > > +	struct fwnode_handle *ports, *port;
> > > > +	int port_num;
> > > > +	int ret;
> > > > +
> > > > +	ports = device_get_named_child_node(priv->dev, "ports");
> > > > +	if (!ports) {
> > > > +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	fwnode_for_each_child_node(ports, port) {
> > > > +		struct fwnode_handle *phy_node, *reg_port_node = port;
> > > > +
> > > > +		phy_node = fwnode_find_reference(port, "phy-handle", 0);
> > > > +		if (!IS_ERR(phy_node))
> > > > +			reg_port_node = phy_node;
> > > 
> > > I don't understand this bit. Why are you looking at the phy-handle?
> > > 
> > > > +
> > > > +		if (fwnode_property_read_u32(reg_port_node, "reg", &port_num))
> > > > +			continue;
> > > 
> > > I would of expect port, not reg_port_node. I'm missing something
> > > here....
> > > 
> > 
> > It's really not to implement ugly things like "reg - 1"
> > 
> > On qca8k the port index goes from 0 to 6.
> > 0 is cpu port 1
> > 1 is port0 at mdio reg 0
> > 2 is port1 at mdio reg 1
> > ...
> > 6 is cpu port 2
> > 
> > Each port have a phy-handle that refer to a phy node with the correct
> > reg and that reflect the correct port index.
> > 
> > Tell me if this looks wrong, for qca8k we have qca8k_port_to_phy() and
> > at times we introduced the mdio thing to describe the port - 1 directly
> > in DT. If needed I can drop the additional fwnode and use this function
> > but I would love to use what is defined in DT thatn a simple - 1.
> 
> This comes back to the off list discussion earlier today. What you
> actually have here are MAC LEDs, not PHY LEDs. They are implemented in
> the MAC, not the PHY. To the end user, it should not matter, they
> blink when you would expect.
> 
> So your addressing should be based around the MAC port number, not the
> PHY.

Ok will drop this.

> 
> Also, at the moment, all we are adding are a bunch of LEDs. There is
> no link to a netdev at this point. At least, i don't see one. Be once
> we start using ledtrig-netdev we will need that link to a netdev. Take
> a look in my git tree at the last four patch. They add an additional
> call to get the device an LED is attached to.
> 

No currently we have no link for netdev, hence we are setting keep and
not setting a default trigger in DT.
Just checked them, interesting concept, guess we can think of something
also for the interval setting. That would effectively make all the
setting of the trigger set. Just my concern is that they may be too much
specific to netdev trigger and may be problematic for other kind of hw
control. (one main argument that was made for this feature was that some
stuff were too much specific and actually not that generic)

-- 
	Ansuel
