Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E68457F794
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiGXXGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGXXGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:06:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1F6E0DA;
        Sun, 24 Jul 2022 16:06:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z15so104908edc.7;
        Sun, 24 Jul 2022 16:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZlVgL9PvHUJsPV9MosF2crMd7iL7RCfuBBeXPJb2B44=;
        b=jIsG4JnoIg5lOo9v4xwX5flTy0BUef0XzH0qh30P3PJWsis3B6O9kHCupm/rypmYuA
         q3GzfCxpa9AoxOOYWL6h+qjLQkZ4Lamt+GWVvZG/rDmWG1rkDTUsm3T93l2FskQbsicc
         RNHycndvwsqsj9jn6+DVOh8nheVuIMf/3tXGUIT3PVN6hw6ieY3j6XIVBXWRgNtyMKnp
         yEG/FfYhYozyvPvaaC9wsePZL+e1TBcR1jwyE/T93nX+tT2NHmQ/gWbY87wFumSTZgmo
         kRbuhQv8Dc/wrm8JU1zXtguI6D3xpTZExL/obLhvL2+Hcbn6hZ9U0CDudy1+hYPOztoy
         Qg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZlVgL9PvHUJsPV9MosF2crMd7iL7RCfuBBeXPJb2B44=;
        b=E+oGXxvglOXFJFwuEY01eWWXSB20IeLCbgnj2wk5o7Lf3yANWQcQlQn7N0rLMZAwdS
         FaLgKsYGMNHfv6L19hN+D9dPWXodDrU4OMq+PMXddk65ZPQk6sFcjvrgIa+ZsO9KYSrh
         N8bv03/1dkNoKCm7kor9V0iVjsyVrPQpP1zJSPiG2ihixm7tkPRPnzW85Rl7mHClSwXG
         VrYfB1JK/HMfFA02FwMWowjAke64TXJ4MDcNF/eteJxRbtszPMRz1FhsGt7koE497lMV
         b9JZOWOSHztvy/qYYn411S/h7PwDUcahapKb2eyKmVvY71/i9lnP2z92AM54vFSZHP9X
         BYdQ==
X-Gm-Message-State: AJIora9sw2+lfHwQlRQWCfnL+LrAH9LdfMD6OqFxkTuk1qdlcumT4yy5
        43IMGVSy6AH7+3LvkoWQO4M=
X-Google-Smtp-Source: AGRyM1stimPkbh9t3UUd79jMR/0DelRFw2x/rZ6+QMUA3bTi08MRP3stSOXuvwtf2jczvcysAxFLgQ==
X-Received: by 2002:a05:6402:51d4:b0:43c:1742:430b with SMTP id r20-20020a05640251d400b0043c1742430bmr165083edd.212.1658703989501;
        Sun, 24 Jul 2022 16:06:29 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id d18-20020aa7d5d2000000b0043a735add09sm6229134eds.21.2022.07.24.16.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:06:28 -0700 (PDT)
Date:   Mon, 25 Jul 2022 02:06:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 01/14] net: dsa: qca8k: cache match data to
 speed up access
Message-ID: <20220724230626.rzynvd2pxdcd2z3r@skbuf>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220724223031.2ceczkbov6bcgrtq@skbuf>
 <62ddce96.1c69fb81.fdc52.a203@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ddce96.1c69fb81.fdc52.a203@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 10:27:13PM +0200, Christian Marangi wrote:
> > > diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> > > index 1cbb05b0323f..212b284f9f73 100644
> > > --- a/drivers/net/dsa/qca/qca8k.c
> > > +++ b/drivers/net/dsa/qca/qca8k.c
> > > @@ -3168,6 +3155,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > +	/* Cache match data in priv struct.
> > > +	 * Match data is already checked in read_switch_id.
> > > +	 */
> > > +	priv->info = of_device_get_match_data(priv->dev);
> > > +
> > 
> > So why don't you set priv->info right before calling qca8k_read_switch_id(),
> > then?
> > 
> 
> The idea was to make the read_switch_id a function to check if the
> switch is compatible... But yhea now that i think about it doesn't
> really make sense.

I am not saying qca8k_read_switch_id() should do anything more than
reading the switch id. I am saying why can't qca8k_read_switch_id()
already find priv->info be pre-populated, just like any other function.
Why don't you set priv->info a lot earlier, see below.

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index fa91517e930b..590ff810c95e 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1892,6 +1892,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	priv->bus = mdiodev->bus;
 	priv->dev = &mdiodev->dev;
+	priv->info = of_device_get_match_data(priv->dev);
 
 	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
 						   GPIOD_ASIS);
@@ -1924,11 +1925,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (ret)
 		return ret;
 
-	/* Cache match data in priv struct.
-	 * Match data is already checked in read_switch_id.
-	 */
-	priv->info = of_device_get_match_data(priv->dev);
-
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index e6294d6a7b8f..8f634edc52c2 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1211,23 +1211,19 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 
 int qca8k_read_switch_id(struct qca8k_priv *priv)
 {
-	const struct qca8k_match_data *data;
 	u32 val;
 	u8 id;
 	int ret;
 
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
-	if (!data)
-		return -ENODEV;
-
 	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
 	if (ret < 0)
 		return -ENODEV;
 
 	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != data->id) {
-		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
+	if (id != priv->info->id) {
+		dev_err(priv->dev,
+			"Switch id detected %x but expected %x",
+			id, priv->info->id);
 		return -ENODEV;
 	}
 

Also note how the "Switch id detected ... but expected ..." message
lacks a trailing \n.

> (Just for reference I just sent v4 as I got a report from kernel test
> bot... it's really just this series with a change in 0002 patch that set
> the struct for ops as a pointer... didn't encounter this with gcc but it
> seems kernel test bot use some special config...)

Yea, I was still kinda reviewing v3... Anyway, now you'll have to wait
for me to finish my v3 feedback on the v4, and then send the v5 after at
least 24 more hours.
