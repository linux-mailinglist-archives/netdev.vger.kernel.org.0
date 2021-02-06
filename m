Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5908A312088
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhBFXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBFXyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 18:54:35 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CE9C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 15:53:54 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id w1so18897928ejf.11
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 15:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kbc/ZBv3bpSJxpVzNgah8IZk1Do/cm/rTco4AbV4T80=;
        b=p0C7uGzvg6MEHSVCWXG8lPcNvX8jj10VTMwOzik+RnMlM7Enm/pTZZ7USTe9rpPuJA
         0ANoFwLVyBY3rYhxYEOs4+vRjXRDFVSWk5P+xeWkPiO/CXgz8MKgse2oQvJGFXY44qrP
         ats6UN47u91yS/bBO7P1h0qMOUMM8zS94xtxIIrOXyQsghpL+BvKJ5xwAEb/YgZM4q8k
         fO/JvJXnc8fXG2hxkV86HApfqh/gTHYF2IIwT0dJ1qLUesVqyQoxSDocNUNJc8JDn9RZ
         fiEmujGzJSqq3ETJc2PnFrIpjEFQsWSqucmnlCxAbWgVwXVH/DpeGkGOv1IeJ+Ka1/l1
         Elmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kbc/ZBv3bpSJxpVzNgah8IZk1Do/cm/rTco4AbV4T80=;
        b=MjAav+FtcXJpo+LHOGRGwrXxOeStICgMFRq767me+LAMQc8ah20pvgQKEqqpSoWe5I
         Vmt5qb63KTCi2nBGX7fZMzWHUj3K1DedgjHh3OSmGjhZN7uY4d9NYAh+JbyzrbfkwDrX
         gJu7/fcAzu4jVCWQMKlr+IDFZahHY/9W+XGD4cTg1ol5bR4jX72ozEc7gMRXAMtSuzfC
         dEGveRIflQXSBKM75g/nVsNRrNfJT68eG5+zQweqeoIm9hyN1C3XPR4QWenfECDAR7tS
         iz59VXH0Tncgjl+Iwe5Z2xBuCb+/xF+ssDN/ph7zRKwQR5tlv8tUjZZuDOZASnPByI/b
         5wbg==
X-Gm-Message-State: AOAM531tBl6u5CngQH6N2+c8idp+nyvnptGKGeTEa+Vz0Pcgz7ft5j0F
        xsSO9BzNgjDckJnxS+b7TkY=
X-Google-Smtp-Source: ABdhPJxu6N27eOpQePJVrFwspUW7u2M9EPk8TdHm/TrxdgpXrg8I2H1fYEiBqgRTEfmdpGx0AxzQRQ==
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr10621640ejr.177.1612655631312;
        Sat, 06 Feb 2021 15:53:51 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z65sm6255974ede.80.2021.02.06.15.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 15:53:50 -0800 (PST)
Date:   Sun, 7 Feb 2021 01:53:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: dsa: xrs700x: add HSR offloading
 support
Message-ID: <20210206235349.7ypxtmjvnpxnn5cr@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-5-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204215926.64377-5-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 03:59:26PM -0600, George McCollister wrote:
> +static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
> +			    struct net_device *hsr)
> +{
> +	unsigned int val = XRS_HSR_CFG_HSR_PRP;
> +	struct dsa_port *partner = NULL, *dp;
> +	struct xrs700x *priv = ds->priv;
> +	struct net_device *slave;
> +	enum hsr_version ver;
> +	int ret;
> +
> +	ret = hsr_get_version(hsr, &ver);
> +	if (ret)
> +		return ret;
> +
> +	if (ver == HSR_V1)
> +		val |= XRS_HSR_CFG_HSR;
> +	else if (ver == PRP_V1)
> +		val |= XRS_HSR_CFG_PRP;
> +	else
> +		return -EOPNOTSUPP;
> +
> +	dsa_hsr_foreach_port(dp, ds, hsr) {
> +		partner = dp;
> +	}
> +
> +	/* We can't enable redundancy on the switch until both
> +	 * redundant ports have signed up.
> +	 */
> +	if (!partner)
> +		return 0;
> +
> +	regmap_fields_write(priv->ps_forward, partner->index,
> +			    XRS_PORT_DISABLED);
> +	regmap_fields_write(priv->ps_forward, port, XRS_PORT_DISABLED);
> +
> +	regmap_write(priv->regmap, XRS_HSR_CFG(partner->index),
> +		     val | XRS_HSR_CFG_LANID_A);
> +	regmap_write(priv->regmap, XRS_HSR_CFG(port),
> +		     val | XRS_HSR_CFG_LANID_B);
> +
> +	/* Clear bits for both redundant ports (HSR only) and the CPU port to
> +	 * enable forwarding.
> +	 */
> +	val = GENMASK(ds->num_ports - 1, 0);
> +	if (ver == HSR_V1) {
> +		val &= ~BIT(partner->index);
> +		val &= ~BIT(port);
> +	}
> +	val &= ~BIT(dsa_upstream_port(ds, port));
> +	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
> +	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
> +
> +	regmap_fields_write(priv->ps_forward, partner->index,
> +			    XRS_PORT_FORWARDING);
> +	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> +
> +	slave = dsa_to_port(ds, port)->slave;
> +
> +	slave->features |= NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM |
> +			   NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP;
> +
> +	return 0;
> +}

Is it deliberate that only one slave HSR/PRP port will have the offload
ethtool features set? If yes, then I find that a bit odd from a user
point of view.
