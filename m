Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18105456731
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhKSBGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhKSBGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:06:09 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A2C061574;
        Thu, 18 Nov 2021 17:03:08 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so18742420eda.11;
        Thu, 18 Nov 2021 17:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ml8VTc7JtCneaBcAYwoltpI1fOhCro0Fw7IurLgWZis=;
        b=TTH/KMsIwNISS3mXYuYWFpdqnfp++Chf8ZttvuWykSR6cSlO41PX/tLyusPtsPmSue
         U2KNPSpm1xtWSDi/sQGbn/IiSl631S8vSz43ZRrrPiShoLb70Hr2m7Zfk2mXy+mnlELQ
         OK9jDnakr71/wA+tgjtE4OXB01kvAEVP1B7cogVLJVRSr3hZU6VG9RaD+IAkwp4x7to+
         PpaugMo2Ekn4tSqniyohHB2LnEqmk/KZP7TotF4KudCRF2O0UN/zeFOcj8kQW4Fs5Ars
         8XOs7oJ2AtIGrJBVmsXPv/nNBvL+HeoBpxckkvkwsKB/bt1QE3o2nUjaLkIdpY3HZ+K1
         zQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ml8VTc7JtCneaBcAYwoltpI1fOhCro0Fw7IurLgWZis=;
        b=oojAxwEOSK+NiS2GBxAO8VRlS4Yvbczy/4bBRARClDidGa0cq2dvsvUHozbSjdDbgH
         vGmq+pFaHZsZ226eK75JBoYjD5PAVuaEoDO81NH3FrKILsFrBUHwYLG/dudsAb5QR4Ih
         Lk2rp8Gif4wj7lDGDRzysfJhu1aN+JPMT1dybMrrQEb++bqAu58oBsKmXu5nAyqhmhLr
         bXFZHyVW2omm/S6i1010K4aw1VdsBEI4sxllomWNVVEzwtTfNfnVDKRal60bxs0YZepp
         cIPvaWnlj5bwQDsg0jNtqjjw65vWyQyRlhbajadPKaMr18mNcV6uspyeBwDH0IWNBCjt
         wCnw==
X-Gm-Message-State: AOAM532B23B+zzQhJ/v92dtrwshr7Ta2GW16NEquHJQk430xs5l1codt
        vD+5bbGQt0PG4BSoi6VmsMg=
X-Google-Smtp-Source: ABdhPJzvGVVo4wc/Znfiu28UdnWGChMyyRomOdcsuzLlH3vDrn51Vpzo6DKOtvkKLuehEmnBeGPueQ==
X-Received: by 2002:a50:c212:: with SMTP id n18mr17160482edf.211.1637283787301;
        Thu, 18 Nov 2021 17:03:07 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id e26sm708121edr.82.2021.11.18.17.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:03:07 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:03:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 05/19] net: dsa: qca8k: move read switch id
 function in qca8k_setup
Message-ID: <20211119010305.4atvwt6zn3dorq2p@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-6-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:37PM +0100, Ansuel Smith wrote:
> Move read_switch_id function in qca8k_setup in preparation for regmap
> conversion. Sw probe should NOT contain function that depends on reading
> from switch regs.

It shouldn't? Why? We have plenty of switch drivers that use regmap in
the probe function.

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 71 ++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 19331edf1fd4..be98d11b17ec 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1073,6 +1073,36 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
>  	return 0;
>  }
>  
> +static int qca8k_read_switch_id(struct qca8k_priv *priv)
> +{
> +	const struct qca8k_match_data *data;
> +	u32 val;
> +	u8 id;
> +	int ret;
> +
> +	/* get the switches ID from the compatible */
> +	data = of_device_get_match_data(priv->dev);
> +	if (!data)
> +		return -ENODEV;
> +
> +	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
> +	if (ret < 0)
> +		return -ENODEV;
> +
> +	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
> +	if (id != data->id) {
> +		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
> +		return -ENODEV;
> +	}
> +
> +	priv->switch_id = id;
> +
> +	/* Save revision to communicate to the internal PHY driver */
> +	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
> +
> +	return 0;
> +}
> +
>  static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
> @@ -1080,6 +1110,11 @@ qca8k_setup(struct dsa_switch *ds)
>  	int cpu_port, ret, i;
>  	u32 mask;
>  
> +	/* Check the detected switch id */
> +	ret = qca8k_read_switch_id(priv);
> +	if (ret)
> +		return ret;
> +
>  	cpu_port = qca8k_find_cpu_port(ds);
>  	if (cpu_port < 0) {
>  		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
> @@ -2023,41 +2058,10 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.get_phy_flags		= qca8k_get_phy_flags,
>  };
>  
> -static int qca8k_read_switch_id(struct qca8k_priv *priv)
> -{
> -	const struct qca8k_match_data *data;
> -	u32 val;
> -	u8 id;
> -	int ret;
> -
> -	/* get the switches ID from the compatible */
> -	data = of_device_get_match_data(priv->dev);
> -	if (!data)
> -		return -ENODEV;
> -
> -	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
> -	if (ret < 0)
> -		return -ENODEV;
> -
> -	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
> -	if (id != data->id) {
> -		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
> -		return -ENODEV;
> -	}
> -
> -	priv->switch_id = id;
> -
> -	/* Save revision to communicate to the internal PHY driver */
> -	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
> -
> -	return 0;
> -}
> -
>  static int
>  qca8k_sw_probe(struct mdio_device *mdiodev)
>  {
>  	struct qca8k_priv *priv;
> -	int ret;
>  
>  	/* allocate the private data struct so that we can probe the switches
>  	 * ID register
> @@ -2083,11 +2087,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  		gpiod_set_value_cansleep(priv->reset_gpio, 0);
>  	}
>  
> -	/* Check the detected switch id */
> -	ret = qca8k_read_switch_id(priv);
> -	if (ret)
> -		return ret;
> -
>  	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
>  	if (!priv->ds)
>  		return -ENOMEM;
> -- 
> 2.32.0
> 

