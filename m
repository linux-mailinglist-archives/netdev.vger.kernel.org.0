Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D231957F79B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiGXXNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiGXXNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:13:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8031EE31;
        Sun, 24 Jul 2022 16:13:39 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id os14so17608878ejb.4;
        Sun, 24 Jul 2022 16:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=5CzS61d44y8hwJlcpSSNnrZFIig91RQUy49SDxGyax0=;
        b=CPRERtdyBhx3F1cuPji9vC7GURO381M5Ga5y6mn5EfJyDcN/atyDh+23L4Tz+5IfQn
         qf3xGHsz3RVd6/ukBmqBVlzUeaOd4QbQJj3qzemkg99gLCByKwU/0a4cA8+uhJq3D/V0
         BLm6ezXNAnsIlWtdEHXWPOMg0ot6oh9UrCaGEA5WpIRGQ39CXUIII9hKgnJ9J2aUnV02
         VALcGz9+sm3toImQNvsXWdtVBRAvEcK2Hn/vI0F9MQp2JDrQJfBR4sxw2HQkbv+KgGPT
         VwU1+d1ZCe7NcUZYDR24ORQmcyoqQl+hBKCYJzot+YNiWVZQwk8idMYj161hkIl1bNK5
         6pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=5CzS61d44y8hwJlcpSSNnrZFIig91RQUy49SDxGyax0=;
        b=a+dEVk8TuMnnHMT/m6mTBxKI990wo28JyzEKWBGSFQM/5g9qafK7y0JwzCUQJvtJeB
         PVo+qkfoO3PiY5xtwUEcJqfOdLOyFVAwjdoisRpGseHAo4onhQTnxQKJCUR4LjZ3sJGG
         szQCoulT4qkkkjd5cc41mONNBd9Rotf6hceKAEe5QYDdlmBlcTctgpqVlELgT39z2N8t
         RftZj3vKSM8CRmmCBOIGkGvqYLky+OmbY+K9bAFFW/Zx12U8VKo+X24dpHq/pA8zg24m
         p0/kfkyia9hGN4w0EXgffp2k/vYhKSwOsC+t8utdDaKLzZxpWFUpZfTXW9DNHH0JdaIt
         3u1g==
X-Gm-Message-State: AJIora8AvKNVcUb5VmUd5dqMmIzouWfNWTbcP/NP8oPKW84+bhFqRYar
        wLNSNWmSoVKwQvwlSrPANgw=
X-Google-Smtp-Source: AGRyM1uO+0QozYhA6X54V/O6AnS3arqm7vrdXs+r6HSGzzHnx2gya1By4rzY+YCKOKeJTfA262nWfQ==
X-Received: by 2002:a17:906:478c:b0:72f:3240:f632 with SMTP id cw12-20020a170906478c00b0072f3240f632mr7861697ejc.336.1658704418370;
        Sun, 24 Jul 2022 16:13:38 -0700 (PDT)
Received: from Ansuel-xps. (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.gmail.com with ESMTPSA id q22-20020a170906941600b00722e603c39asm4693953ejx.31.2022.07.24.16.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:13:37 -0700 (PDT)
Message-ID: <62ddd221.1c69fb81.95457.a4ee@mx.google.com>
X-Google-Original-Message-ID: <Yt2urJI0eWQ6+5ty@Ansuel-xps.>
Date:   Sun, 24 Jul 2022 22:42:20 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220724223031.2ceczkbov6bcgrtq@skbuf>
 <62ddce96.1c69fb81.fdc52.a203@mx.google.com>
 <20220724230626.rzynvd2pxdcd2z3r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724230626.rzynvd2pxdcd2z3r@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 02:06:26AM +0300, Vladimir Oltean wrote:
> On Sun, Jul 24, 2022 at 10:27:13PM +0200, Christian Marangi wrote:
> > > > diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> > > > index 1cbb05b0323f..212b284f9f73 100644
> > > > --- a/drivers/net/dsa/qca/qca8k.c
> > > > +++ b/drivers/net/dsa/qca/qca8k.c
> > > > @@ -3168,6 +3155,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
> > > >  	if (ret)
> > > >  		return ret;
> > > >  
> > > > +	/* Cache match data in priv struct.
> > > > +	 * Match data is already checked in read_switch_id.
> > > > +	 */
> > > > +	priv->info = of_device_get_match_data(priv->dev);
> > > > +
> > > 
> > > So why don't you set priv->info right before calling qca8k_read_switch_id(),
> > > then?
> > > 
> > 
> > The idea was to make the read_switch_id a function to check if the
> > switch is compatible... But yhea now that i think about it doesn't
> > really make sense.
> 
> I am not saying qca8k_read_switch_id() should do anything more than
> reading the switch id. I am saying why can't qca8k_read_switch_id()
> already find priv->info be pre-populated, just like any other function.
> Why don't you set priv->info a lot earlier, see below.
>

Sure, it was just a stupid idea to set everything not strictly neeeded
only after verifying that we have a correct switch... But it doesn't
make sense as qca8k_priv is freed anyway if that's the case.

Will do the change in v5.

> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> index fa91517e930b..590ff810c95e 100644
> --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> @@ -1892,6 +1892,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  
>  	priv->bus = mdiodev->bus;
>  	priv->dev = &mdiodev->dev;
> +	priv->info = of_device_get_match_data(priv->dev);
>  
>  	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
>  						   GPIOD_ASIS);
> @@ -1924,11 +1925,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	if (ret)
>  		return ret;
>  
> -	/* Cache match data in priv struct.
> -	 * Match data is already checked in read_switch_id.
> -	 */
> -	priv->info = of_device_get_match_data(priv->dev);
> -
>  	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
>  	if (!priv->ds)
>  		return -ENOMEM;
> diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
> index e6294d6a7b8f..8f634edc52c2 100644
> --- a/drivers/net/dsa/qca/qca8k-common.c
> +++ b/drivers/net/dsa/qca/qca8k-common.c
> @@ -1211,23 +1211,19 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
>  
>  int qca8k_read_switch_id(struct qca8k_priv *priv)
>  {
> -	const struct qca8k_match_data *data;
>  	u32 val;
>  	u8 id;
>  	int ret;
>  
> -	/* get the switches ID from the compatible */
> -	data = of_device_get_match_data(priv->dev);
> -	if (!data)
> -		return -ENODEV;
> -
>  	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
>  	if (ret < 0)
>  		return -ENODEV;
>  
>  	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
> -	if (id != data->id) {
> -		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
> +	if (id != priv->info->id) {
> +		dev_err(priv->dev,
> +			"Switch id detected %x but expected %x",
> +			id, priv->info->id);
>  		return -ENODEV;
>  	}
>  
> 
> Also note how the "Switch id detected ... but expected ..." message
> lacks a trailing \n.
> 

Will fix this when the read_switch_id function is moved to common file.

> > (Just for reference I just sent v4 as I got a report from kernel test
> > bot... it's really just this series with a change in 0002 patch that set
> > the struct for ops as a pointer... didn't encounter this with gcc but it
> > seems kernel test bot use some special config...)
> 
> Yea, I was still kinda reviewing v3... Anyway, now you'll have to wait
> for me to finish my v3 feedback on the v4, and then send the v5 after at
> least 24 more hours.

Sure and sorry for the mess.

-- 
	Ansuel
