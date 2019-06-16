Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C6847451
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 13:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfFPLFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 07:05:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34533 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfFPLFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 07:05:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id k11so6874531wrl.1;
        Sun, 16 Jun 2019 04:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jYpdMxao6pliYnnD2x77IZriJWD7lFq0HxazhfUGYeM=;
        b=UwFN84U/ghpHYCjJsDjNhvd0IG6uo6P/Ch88x8naJcdJ3LA2P+oVvUyG2OddL1IfWo
         Txz07ZLzHPkSr8t6uXZYv+JBxeYlPaL1q6TjnJV5i5NsIHi8otj703Hw439tfzCJmkx9
         bhtZwyBGnDAfKH75NBMd9QFWoSzIRXN7SWKl/tUPS9VsqMtLYoA7ZItlJ0Qe6h6Gc1H4
         qSmX/Z0FQ6FbVAP6j62fzdvl7Kx7qsJb3yVW+gAouv+ZrB1JfGLTsGPbBCjmTDsQIrUA
         xMoN/N5HJ9atne/L4VNVvkuBNudrkBYAjRmGwG1yPEPswZ9FqVwy4LkjPSgvi+gf6yz3
         NADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jYpdMxao6pliYnnD2x77IZriJWD7lFq0HxazhfUGYeM=;
        b=lCkodrDnkkHPukFIS10M/Eurgv0/7N8VoVtSqzsrefH0yvnsKI+2Rl09pGzUDVb8aY
         HSkwK3MKOAlCcmrxNudkzGhoXV2Zr56ZBQSMCcMtq7nwd4YNz/MdcEBXPK5o5U6zbEDI
         BCbNZuj2Xj2VjmJzX6qU8Zml97e9fm+d5B49Jcab8vWmMYk3+icd6RxyXk0kdGlTU0AO
         ALHkAp95kg8p3+pWRPFEIqtmCg3p5xUvK+YgQzq28patVR4rvuE93LB4OGXxIPe8ofUM
         T09fJxIa/ZS99yYhAbMljGI7R/6flyI+rfQpme2gQqhhkTu9KIGOqKzFfLRicwOC5K0y
         7TlQ==
X-Gm-Message-State: APjAAAX3GI5qsQMufFR+iHfvagd8h9zhO9Gis6vpd9130J45vVgdHw0K
        l8QJXpVJVrsKLheMsJy7wwQ=
X-Google-Smtp-Source: APXvYqzzqx42PAT4ueneqpG+etvE0yFc0vTzd9YPvagfFq04jv7+a+XjTXMN2fn6y898d3uHmGL14w==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr55684452wro.60.1560683116461;
        Sun, 16 Jun 2019 04:05:16 -0700 (PDT)
Received: from jernej-laptop.localnet (cpe-86-58-52-202.static.triera.net. [86.58.52.202])
        by smtp.gmail.com with ESMTPSA id t1sm8457650wra.74.2019.06.16.04.05.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 04:05:14 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-sunxi@googlegroups.com, megous@megous.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [linux-sunxi] [PATCH v6 5/6] drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
Date:   Sun, 16 Jun 2019 13:05:13 +0200
Message-ID: <1823986.m04BvQ5ALy@jernej-laptop>
In-Reply-To: <20190527162237.18495-6-megous@megous.com>
References: <20190527162237.18495-1-megous@megous.com> <20190527162237.18495-6-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ondrej!

Dne ponedeljek, 27. maj 2019 ob 18:22:36 CEST je megous via linux-sunxi 
napisal(a):
> From: Ondrej Jirman <megous@megous.com>
> 
> Orange Pi 3 board requires enabling a voltage shifting circuit via GPIO
> for the DDC bus to be usable.
> 
> Add support for hdmi-connector node's optional ddc-en-gpios property to
> support this use case.
> 
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 55 +++++++++++++++++++++++++--
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  3 ++
>  2 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c index 39d8509d96a0..59b81ba02d96
> 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> @@ -98,6 +98,30 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct
> drm_device *drm, return crtcs;
>  }
> 
> +static int sun8i_dw_hdmi_find_connector_pdev(struct device *dev,
> +					     struct 
platform_device **pdev_out)
> +{
> +	struct platform_device *pdev;
> +	struct device_node *remote;
> +
> +	remote = of_graph_get_remote_node(dev->of_node, 1, -1);
> +	if (!remote)
> +		return -ENODEV;
> +
> +	if (!of_device_is_compatible(remote, "hdmi-connector")) {
> +		of_node_put(remote);
> +		return -ENODEV;
> +	}
> +
> +	pdev = of_find_device_by_node(remote);
> +	of_node_put(remote);
> +	if (!pdev)
> +		return -ENODEV;
> +
> +	*pdev_out = pdev;
> +	return 0;
> +}
> +
>  static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
>  			      void *data)
>  {
> @@ -151,16 +175,29 @@ static int sun8i_dw_hdmi_bind(struct device *dev,
> struct device *master, return PTR_ERR(hdmi->regulator);
>  	}
> 
> +	ret = sun8i_dw_hdmi_find_connector_pdev(dev, &hdmi->connector_pdev);
> +	if (!ret) {
> +		hdmi->ddc_en = gpiod_get_optional(&hdmi->connector_pdev-
>dev,
> +						  "ddc-en", 
GPIOD_OUT_HIGH);
> +		if (IS_ERR(hdmi->ddc_en)) {
> +			platform_device_put(hdmi->connector_pdev);
> +			dev_err(dev, "Couldn't get ddc-en gpio\n");
> +			return PTR_ERR(hdmi->ddc_en);
> +		}
> +	}
> +
>  	ret = regulator_enable(hdmi->regulator);
>  	if (ret) {
>  		dev_err(dev, "Failed to enable regulator\n");
> -		return ret;
> +		goto err_unref_ddc_en;
>  	}
> 
> +	gpiod_set_value(hdmi->ddc_en, 1);

Why don't you do that inside if clause where hdmi->ddc_en is assigned? It's 
not useful otherwise anyway.

Besides, you would then only need to adjust one goto label in error path.

> +
>  	ret = reset_control_deassert(hdmi->rst_ctrl);
>  	if (ret) {
>  		dev_err(dev, "Could not deassert ctrl reset 
control\n");
> -		goto err_disable_regulator;
> +		goto err_disable_ddc_en;
>  	}
> 
>  	ret = clk_prepare_enable(hdmi->clk_tmds);
> @@ -213,8 +250,14 @@ static int sun8i_dw_hdmi_bind(struct device *dev,
> struct device *master, clk_disable_unprepare(hdmi->clk_tmds);
>  err_assert_ctrl_reset:
>  	reset_control_assert(hdmi->rst_ctrl);
> -err_disable_regulator:
> +err_disable_ddc_en:
> +	gpiod_set_value(hdmi->ddc_en, 0);
>  	regulator_disable(hdmi->regulator);
> +err_unref_ddc_en:
> +	if (hdmi->ddc_en)
> +		gpiod_put(hdmi->ddc_en);
> +
> +	platform_device_put(hdmi->connector_pdev);
> 
>  	return ret;
>  }
> @@ -228,7 +271,13 @@ static void sun8i_dw_hdmi_unbind(struct device *dev,
> struct device *master, sun8i_hdmi_phy_remove(hdmi);
>  	clk_disable_unprepare(hdmi->clk_tmds);
>  	reset_control_assert(hdmi->rst_ctrl);
> +	gpiod_set_value(hdmi->ddc_en, 0);
>  	regulator_disable(hdmi->regulator);
> +
> +	if (hdmi->ddc_en)
> +		gpiod_put(hdmi->ddc_en);
> +
> +	platform_device_put(hdmi->connector_pdev);
>  }
> 
>  static const struct component_ops sun8i_dw_hdmi_ops = {
> diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
> b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h index 720c5aa8adc1..dad66b8301c2
> 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
> +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
> @@ -9,6 +9,7 @@
>  #include <drm/bridge/dw_hdmi.h>
>  #include <drm/drm_encoder.h>
>  #include <linux/clk.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/regmap.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/reset.h>
> @@ -190,6 +191,8 @@ struct sun8i_dw_hdmi {
>  	struct regulator		*regulator;
>  	const struct sun8i_dw_hdmi_quirks *quirks;
>  	struct reset_control		*rst_ctrl;
> +	struct platform_device		*connector_pdev;

It seems that connector_pdev is needed only during intialization. Why do you 
store it?

Best regards,
Jernej

> +	struct gpio_desc		*ddc_en;
>  };
> 
>  static inline struct sun8i_dw_hdmi *




