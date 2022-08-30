Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4575A6B19
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiH3Rqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiH3RqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:46:11 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BC71123BA
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:42:43 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id m2so12772438lfp.11
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=SPZErG0x+ZK9rrrlDxAhzzz1P40khYHpqEnMJdQIlpg=;
        b=Aeqk+pzLRJaZsQn/A3FQazeivNuwBJxb8TF5Dp3xsGry52OQSdmFztXUGSPNe+oMhh
         Pjq7WcNiMWl+8Xqs6Orbdwo3D01TkCcpIE5RTOHeV05baWAt7zvHrZyLHp6iMw0MUkoc
         5no4iwEuob+B6MwYsgtITrLzj5M4Z7AqrtnEjq3EoXAUINQmSBvoqoL5b04NUz2AjDGP
         F78srdz2j1DFeVBCacA/NK+MojyHiBtXIB7DERihsg1k9XVfLaQyyr4wWxbtLZ8asWhD
         asOHGIaz7n54Il1Ua11ALAG1JHECzl71RqjUaPbw6ngvXB6SaZCQ3QZNy2upeIsB46OS
         xb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=SPZErG0x+ZK9rrrlDxAhzzz1P40khYHpqEnMJdQIlpg=;
        b=KLzNBar/EunlRFcYzDD8e19qj7JBlHWSJDHFMG4ySTZ3ndjqhVsnEyEF59LAXhIq1h
         CpyiM9mqy6DeG2shAAr54WrA1RCgBL4sk50osTd79f+TAj1++VNHO//O20j1uU3OjmAB
         foydtdbcR2+8gZceMehrOtFPdDPDJDY6xSscag8AD4DoXY8AqD4sqgqwWiSAKEUH5js8
         eFOgjJheFO8FFs5G4P0NJLaFVb+Gol/LX4IMm0x8uqC62QWqN004Be1HXiDpGXzguhcG
         ilsKaD1pHRORVP42JdcseLAdVDP5RjQiiQ8/xkVpe6U7B0Mr298VNDg4Rox0r4poiVQY
         +dxw==
X-Gm-Message-State: ACgBeo1WhhwKH85fIqNVPzLNR2ZZeD+czlhb+w1UsdhBdNBDkiAuU67H
        VDGo7hC6szlaXIDazOyH4CfEDA==
X-Google-Smtp-Source: AA6agR5THj416qIImWZcu8phGsY2vckuwc//b2D6s0MX0BNveAAKVZsHiaMQrYU2U1lbgc6BqylnRQ==
X-Received: by 2002:a05:6512:138e:b0:47f:77cc:327a with SMTP id p14-20020a056512138e00b0047f77cc327amr8388674lfa.277.1661881359035;
        Tue, 30 Aug 2022 10:42:39 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id h5-20020a2ea485000000b0025e6a3556ffsm1846822lji.22.2022.08.30.10.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 10:42:38 -0700 (PDT)
Message-ID: <f91703eb-fa93-317a-246f-7e083372818b@linaro.org>
Date:   Tue, 30 Aug 2022 20:42:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v4 7/7] net: pse-pd: add regulator based PSE
 driver
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
 <20220828063021.3963761-8-o.rempel@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220828063021.3963761-8-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/08/2022 09:30, Oleksij Rempel wrote:
> Add generic, regulator based PSE driver to support simple Power Sourcing
> Equipment without automatic classification support.
> 
> This driver was tested on 10Bast-T1L switch with regulator based PoDL PSE.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v4:
> - rename to pse_regulator
> changes v2:
> - add regulator_enable test to the probe
> - migrate to the new PSE ethtool API
> ---
>  drivers/net/pse-pd/Kconfig         |  11 +++
>  drivers/net/pse-pd/Makefile        |   2 +
>  drivers/net/pse-pd/pse_regulator.c | 148 +++++++++++++++++++++++++++++
>  3 files changed, 161 insertions(+)
>  create mode 100644 drivers/net/pse-pd/pse_regulator.c
> 
> diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
> index 49c7f0bcff526..73d163704068a 100644
> --- a/drivers/net/pse-pd/Kconfig
> +++ b/drivers/net/pse-pd/Kconfig
> @@ -9,3 +9,14 @@ menuconfig PSE_CONTROLLER
>  	  Generic Power Sourcing Equipment Controller support.
>  
>  	  If unsure, say no.
> +
> +if PSE_CONTROLLER
> +
> +config PSE_REGULATOR
> +	tristate "Regulator based PSE controller"
> +	help
> +	  This module provides support for simple regulator based Ethernet Power
> +	  Sourcing Equipment without automatic classification support. For
> +	  example for basic implementation of PoDL (802.3bu) specification.
> +
> +endif
> diff --git a/drivers/net/pse-pd/Makefile b/drivers/net/pse-pd/Makefile
> index cfa780c7801dd..1b8aa4c70f0b9 100644
> --- a/drivers/net/pse-pd/Makefile
> +++ b/drivers/net/pse-pd/Makefile
> @@ -2,3 +2,5 @@
>  # Makefile for Linux PSE drivers
>  
>  obj-$(CONFIG_PSE_CONTROLLER) += pse_core.o
> +
> +obj-$(CONFIG_PSE_REGULATOR) += pse_regulator.o
> diff --git a/drivers/net/pse-pd/pse_regulator.c b/drivers/net/pse-pd/pse_regulator.c
> new file mode 100644
> index 0000000000000..46ea5b8215dcd
> --- /dev/null
> +++ b/drivers/net/pse-pd/pse_regulator.c
> @@ -0,0 +1,148 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Driver for the regulator based Ethernet Power Sourcing Equipment, without
> +// auto classification support.
> +//
> +// Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
> +//
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pse-pd/pse.h>
> +#include <linux/regulator/consumer.h>
> +
> +struct pse_reg_priv {
> +	struct pse_controller_dev pcdev;
> +	struct regulator *ps; /*power source */
> +	enum ethtool_podl_pse_admin_state admin_state;
> +};
> +
> +static struct pse_reg_priv *to_pse_reg(struct pse_controller_dev *pcdev)
> +{
> +	return container_of(pcdev, struct pse_reg_priv, pcdev);
> +}
> +
> +static int
> +pse_reg_ethtool_set_config(struct pse_controller_dev *pcdev, unsigned long id,
> +			   struct netlink_ext_ack *extack,
> +			   const struct pse_control_config *config)
> +{
> +	struct pse_reg_priv *priv = to_pse_reg(pcdev);
> +	int ret;
> +
> +	if (priv->admin_state == config->admin_cotrol)
> +		return 0;
> +
> +	switch (config->admin_cotrol) {
> +	case ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED:
> +		ret = regulator_enable(priv->ps);
> +		break;
> +	case ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED:
> +		ret = regulator_disable(priv->ps);
> +		break;
> +	default:
> +		dev_err(pcdev->dev, "Unknown admin state %i\n",
> +			config->admin_cotrol);
> +		ret = -ENOTSUPP;
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	priv->admin_state = config->admin_cotrol;
> +
> +	return 0;
> +}
> +
> +static int
> +pse_reg_ethtool_get_status(struct pse_controller_dev *pcdev, unsigned long id,
> +			   struct netlink_ext_ack *extack,
> +			   struct pse_control_status *status)
> +{
> +	struct pse_reg_priv *priv = to_pse_reg(pcdev);
> +	int ret;
> +
> +	ret = regulator_is_enabled(priv->ps);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!ret)
> +		status->podl_pw_status = ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED;
> +	else
> +		status->podl_pw_status =
> +			ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING;
> +
> +	status->podl_admin_state = priv->admin_state;
> +
> +	return 0;
> +}
> +
> +static const struct pse_controller_ops pse_reg_ops = {
> +	.ethtool_get_status = pse_reg_ethtool_get_status,
> +	.ethtool_set_config = pse_reg_ethtool_set_config,
> +};
> +
> +static int
> +pse_reg_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct pse_reg_priv *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENOENT;
> +
> +	priv->ps = devm_regulator_get_exclusive(dev, "pse");
> +	if (IS_ERR(priv->ps)) {
> +		dev_err(dev, "failed to get PSE regulator (%pe)\n", priv->ps);

return dev_err_probe().

> +		return PTR_ERR(priv->ps);
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	ret = regulator_is_enabled(priv->ps);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret)
> +		priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED;
> +	else
> +		priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED;
> +
> +	priv->pcdev.owner = THIS_MODULE;
> +	priv->pcdev.ops = &pse_reg_ops;
> +	priv->pcdev.dev = dev;
> +	ret = devm_pse_controller_register(dev, &priv->pcdev);
> +	if (ret) {
> +		dev_err(dev, "failed to register PSE controller (%pe)\n",
> +			ERR_PTR(ret));

return dev_err_probe()

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id pse_reg_of_match[] = {
> +	{ .compatible = "podl-pse-regulator", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, pse_reg_of_match);
> +
> +static struct platform_driver pse_reg_driver = {
> +	.probe		= pse_reg_probe,
> +	.driver		= {
> +		.name		= "PSE regulator",
> +		.of_match_table = of_match_ptr(pse_reg_of_match),

You need to compile test it... No of_match_ptr() or add maybe_unused to
the table.

Best regards,
Krzysztof
