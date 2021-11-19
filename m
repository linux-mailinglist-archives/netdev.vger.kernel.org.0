Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34D8456749
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhKSBMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhKSBMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:12:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464DCC061574;
        Thu, 18 Nov 2021 17:09:04 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v1so1914998edx.2;
        Thu, 18 Nov 2021 17:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=+QcEnVKfz83L6ScBQU6S8AjkwZ6gVb3PhX35pSjHG1U=;
        b=UrjeEpyXnLQ/Z0y6dk8OiNShcdVbA4MsUSRkpPXIWGjUhOTtrvLGxzI2zeoV1jc8h9
         EfokZ/58jlkydtbtHsOhsLRyH5Cq+73BsC92GvKEuhV0QoVDdYjWyJu4+4UNmFauiPln
         vHpugz38vgv6QrUiGVKlc58yX7nYx2r5VV0Irybuy0SNeNaNGXufirXwztIfzQIFf8R5
         N3nwsI7DqnyhEUabNfECthqM7tg1GH4QKop/SlZ4HfCitm5+8P/3nE0KZcIPoo4guPkh
         VgrFUNO62+qdtE7/hWNriQEjzcuP+OtDv/iX69GNmYHzHVnTfLE4XNeZWcES67Gxx61k
         LsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=+QcEnVKfz83L6ScBQU6S8AjkwZ6gVb3PhX35pSjHG1U=;
        b=6azfdiW51sHY+Hv0DgUc5QO1yJ2eWduAdUimI1O6Uv6b/WxoDOTyZ3129wqtfSbbHK
         +Qp8LFz8RRFnCixOwbxwJgQ5IyuFI85AVlyhpWPO4u3Y+F9YT1i2EqHO4AF6pUfI858T
         +EUV9C1q5/O4nbcvLfhWWz50OJHHFBBajPmYkFcLaMFSol7oQMBOpXM3EDPNaubiOXTr
         DnXMGhZ4gbULmuz/JRBAiTf2srFm7NntfiiKYBBdvAvnryK4tXIlvHvrnT1DqdC4h2D2
         C5BbIlyoSmzMuh/TJBEZY5EAfce8di35/IgviNJSer876vT/DFaa/thRkKRbXQIa9wiO
         BuZQ==
X-Gm-Message-State: AOAM531CAXKE53cCEZWGeuckRmd6aiL7EqV9+BOilXtH5t4jUpyrweUq
        g57eQGn2LoGgMN9qzZBHenU=
X-Google-Smtp-Source: ABdhPJyBP7Mjbcfp4vR65aJX20DDTgAJYa/yuucq7smi69q/G7w4/QqEyAqIFemd3vmbXW+5HLCLtQ==
X-Received: by 2002:a17:906:52d8:: with SMTP id w24mr2546959ejn.296.1637284142685;
        Thu, 18 Nov 2021 17:09:02 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id mp9sm516083ejc.106.2021.11.18.17.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:09:02 -0800 (PST)
Message-ID: <6196f92e.1c69fb81.5e6a3.271b@mx.google.com>
X-Google-Original-Message-ID: <YZb5K1YiCNR2lGZy@Ansuel-xps.>
Date:   Fri, 19 Nov 2021 02:08:59 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 05/19] net: dsa: qca8k: move read switch id
 function in qca8k_setup
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-6-ansuelsmth@gmail.com>
 <20211119010305.4atvwt6zn3dorq2p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119010305.4atvwt6zn3dorq2p@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:03:05AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 17, 2021 at 10:04:37PM +0100, Ansuel Smith wrote:
> > Move read_switch_id function in qca8k_setup in preparation for regmap
> > conversion. Sw probe should NOT contain function that depends on reading
> > from switch regs.
> 
> It shouldn't? Why? We have plenty of switch drivers that use regmap in
> the probe function.
>

The initial idea was to make a shared probe function. (when the ipq40xx
code will be proposed)
Currently the regmap is init in the setup function so we can both 
move the switch id to setup or move regmap to probe.
What should be better in your opinion?

> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 71 ++++++++++++++++++++---------------------
> >  1 file changed, 35 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 19331edf1fd4..be98d11b17ec 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1073,6 +1073,36 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
> >  	return 0;
> >  }
> >  
> > +static int qca8k_read_switch_id(struct qca8k_priv *priv)
> > +{
> > +	const struct qca8k_match_data *data;
> > +	u32 val;
> > +	u8 id;
> > +	int ret;
> > +
> > +	/* get the switches ID from the compatible */
> > +	data = of_device_get_match_data(priv->dev);
> > +	if (!data)
> > +		return -ENODEV;
> > +
> > +	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
> > +	if (ret < 0)
> > +		return -ENODEV;
> > +
> > +	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
> > +	if (id != data->id) {
> > +		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
> > +		return -ENODEV;
> > +	}
> > +
> > +	priv->switch_id = id;
> > +
> > +	/* Save revision to communicate to the internal PHY driver */
> > +	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  qca8k_setup(struct dsa_switch *ds)
> >  {
> > @@ -1080,6 +1110,11 @@ qca8k_setup(struct dsa_switch *ds)
> >  	int cpu_port, ret, i;
> >  	u32 mask;
> >  
> > +	/* Check the detected switch id */
> > +	ret = qca8k_read_switch_id(priv);
> > +	if (ret)
> > +		return ret;
> > +
> >  	cpu_port = qca8k_find_cpu_port(ds);
> >  	if (cpu_port < 0) {
> >  		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
> > @@ -2023,41 +2058,10 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> >  	.get_phy_flags		= qca8k_get_phy_flags,
> >  };
> >  
> > -static int qca8k_read_switch_id(struct qca8k_priv *priv)
> > -{
> > -	const struct qca8k_match_data *data;
> > -	u32 val;
> > -	u8 id;
> > -	int ret;
> > -
> > -	/* get the switches ID from the compatible */
> > -	data = of_device_get_match_data(priv->dev);
> > -	if (!data)
> > -		return -ENODEV;
> > -
> > -	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
> > -	if (ret < 0)
> > -		return -ENODEV;
> > -
> > -	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
> > -	if (id != data->id) {
> > -		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
> > -		return -ENODEV;
> > -	}
> > -
> > -	priv->switch_id = id;
> > -
> > -	/* Save revision to communicate to the internal PHY driver */
> > -	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
> > -
> > -	return 0;
> > -}
> > -
> >  static int
> >  qca8k_sw_probe(struct mdio_device *mdiodev)
> >  {
> >  	struct qca8k_priv *priv;
> > -	int ret;
> >  
> >  	/* allocate the private data struct so that we can probe the switches
> >  	 * ID register
> > @@ -2083,11 +2087,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
> >  		gpiod_set_value_cansleep(priv->reset_gpio, 0);
> >  	}
> >  
> > -	/* Check the detected switch id */
> > -	ret = qca8k_read_switch_id(priv);
> > -	if (ret)
> > -		return ret;
> > -
> >  	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
> >  	if (!priv->ds)
> >  		return -ENOMEM;
> > -- 
> > 2.32.0
> > 
> 

-- 
	Ansuel
