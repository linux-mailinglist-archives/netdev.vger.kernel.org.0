Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FA75ECECF
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiI0UlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiI0UlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:41:03 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E72DF85A4;
        Tue, 27 Sep 2022 13:41:02 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dv25so23089059ejb.12;
        Tue, 27 Sep 2022 13:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=erSZq+ttTs2w72LdoF4lUIQ5z3RURjxVVFpi+g7c2Js=;
        b=K5xbQNotsqpY3vXiZMgt/d/uysRXJFTFm5TKdF3Z45RUpsrR9d0zMwbKh+mmqVjGRI
         ukh3bY6qc6DyrtmodpDwGxdbakCyWwFkaWuXO8YXuFy8XOv3aR/570ZaiiVf8MFShXPc
         IiA9fuHljs9gkqm1dXADLkqQkJRy+5jriTWGj5lPEYwTDzZ9TEd3X7uN3i4meX68jpm1
         nAR7rLVHkBMUCszkyT3ZuuiytVTXpGvdiOWqslfXpjS7vvUMGeySuK5Y4XZO93HI1gpX
         62C0DUIUJzWBEs6hokXwhmZu79FKmObTxIIU0owMJpqd52QTKz/9NvH0ao3aUbktEPB/
         6YEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=erSZq+ttTs2w72LdoF4lUIQ5z3RURjxVVFpi+g7c2Js=;
        b=RXlbDryGeX2CVDh91SJwHGREGegULBv+6BORO181ZeK1Y2oLO/e9HH1Drsxo7+kJmM
         uo5YoSiPWN4W+Ep40nogOrUeQXzGqjoPFdFZ+6P7xZ2hvThs9Qum2Z63M4Eg0OLZ4qZu
         c7yn/JKke/caxnTQzEKvp9djKPpx90CLVYqRIj3ohjx0WPcdgMF3qy86acSt3CZmoTmC
         u2x2ZbCz8Y3wcVbq6XqAjQYQehJ6oVWnhexPFvE/wMC/g4tHkW0713fw4DHxUvH0JQ/h
         J6kCZE8eJlN8+75TbqXU9IcnavC1FsG4Ku7/TRE0jN5lmN6hlY1C6T8TCt+PLksTIz9b
         NISQ==
X-Gm-Message-State: ACrzQf2FzTPyGFOsBgDUm6z3MQDTGz2Rw7klvh/mQs9hfbNDyZj8/sma
        yrg3DpppuRjT2d1ZnM3VOWs=
X-Google-Smtp-Source: AMsMyM4+go5mJgyTgdgKDtx9FSOzH2w9Cl6hPGVWZMHmWqa/kWoEs29UR5Y1re1Oe8BkleX6JSpd/w==
X-Received: by 2002:a17:907:3f0b:b0:781:e783:2773 with SMTP id hq11-20020a1709073f0b00b00781e7832773mr23507732ejc.610.1664311260452;
        Tue, 27 Sep 2022 13:41:00 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q3-20020a170906144300b0077d37a5d401sm1280606ejc.33.2022.09.27.13.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 13:40:59 -0700 (PDT)
Date:   Tue, 27 Sep 2022 23:40:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 13/14] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <20220927204056.xuc7h3xhb2f5znpy@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-14-colin.foster@in-advantage.com>
 <20220926002928.2744638-14-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926002928.2744638-14-colin.foster@in-advantage.com>
 <20220926002928.2744638-14-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 05:29:27PM -0700, Colin Foster wrote:
> Add control of an external VSC7512 chip.
> 
> Currently the four copper phy ports are fully functional. Communication to
> external phys is also functional, but the SGMII / QSGMII interfaces are
> currently non-functional.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3
>     * Remove additional entry in vsc7512_port_modes array
>     * Add MFD_OCELOT namespace import, which is needed for
>       vsc7512_*_io_res

and which hopefully will no longer be

> diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
> new file mode 100644
> index 000000000000..fb9dbb31fea1
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Copyright 2021-2022 Innovative Advantage Inc.
> + */
> +
> +#include <linux/mfd/ocelot.h>
> +#include <linux/phylink.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <soc/mscc/ocelot.h>
> +#include <soc/mscc/vsc7514_regs.h>
> +#include "felix.h"
> +
> +#define VSC7512_NUM_PORTS		11

Is there a difference in port count between VSC7512 and VSC7514? Nope.
Could you please give naming preference to "vsc7514" for things that are
identical?

> +
> +#define OCELOT_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
> +					 OCELOT_PORT_MODE_QSGMII)
> +
> +static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_SERDES,
> +	OCELOT_PORT_MODE_SERDES,
> +	OCELOT_PORT_MODE_SERDES,
> +	OCELOT_PORT_MODE_SERDES,
> +	OCELOT_PORT_MODE_SERDES,
> +	OCELOT_PORT_MODE_SERDES,
> +	OCELOT_PORT_MODE_SGMII,
> +};
> +
> +static const u32 *vsc7512_regmap[TARGET_MAX] = {
> +	[ANA] = vsc7514_ana_regmap,
> +	[QS] = vsc7514_qs_regmap,
> +	[QSYS] = vsc7514_qsys_regmap,
> +	[REW] = vsc7514_rew_regmap,
> +	[SYS] = vsc7514_sys_regmap,
> +	[S0] = vsc7514_vcap_regmap,
> +	[S1] = vsc7514_vcap_regmap,
> +	[S2] = vsc7514_vcap_regmap,
> +	[PTP] = vsc7514_ptp_regmap,
> +	[DEV_GMII] = vsc7514_dev_gmii_regmap,
> +};

Isn't this precisely the same as ocelot_regmap from
drivers/net/ethernet/mscc/ocelot_vsc7514.c?

> +
> +static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
> +					unsigned long *supported,
> +					struct phylink_link_state *state)
> +{
> +	struct felix *felix = ocelot_to_felix(ocelot);
> +	struct dsa_switch *ds = felix->ds;
> +	struct dsa_port *dp;
> +
> +	dp = dsa_to_port(ds, port);
> +
> +	phylink_generic_validate(&dp->pl_config, supported, state);

It would be good to transition everybody to phylink_generic_validate(),
now that Sean Anderson's PHY rate matching work was accepted. I haven't
found the time to test this on a LS1028A-QDS board, but I hope I will
soon.

> +}
> +
> +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> +					     const char *name)
> +{
> +	/* In the ocelot-mfd configuration, regmaps are attached to the device
> +	 * by name alone, so dev_get_regmap will return the requested regmap
> +	 * without the need to fully define the resource
> +	 */
> +	return dev_get_regmap(ocelot->dev->parent, name);

As discussed: nope.

> +}
> +
> +static const struct ocelot_ops ocelot_ext_ops = {
> +	.reset		= ocelot_reset,
> +	.wm_enc		= ocelot_wm_enc,
> +	.wm_dec		= ocelot_wm_dec,
> +	.wm_stat	= ocelot_wm_stat,
> +	.port_to_netdev	= felix_port_to_netdev,
> +	.netdev_to_port	= felix_netdev_to_port,
> +};
> +
> +static const struct felix_info vsc7512_info = {
> +	.target_io_res			= vsc7512_target_io_res,
> +	.port_io_res			= vsc7512_port_io_res,
> +	.regfields			= vsc7514_regfields,
> +	.map				= vsc7512_regmap,
> +	.ops				= &ocelot_ext_ops,
> +	.stats_layout			= vsc7514_stats_layout,
> +	.vcap				= vsc7514_vcap_props,
> +	.num_mact_rows			= 1024,
> +	.num_ports			= VSC7512_NUM_PORTS,
> +	.num_tx_queues			= OCELOT_NUM_TC,
> +	.phylink_validate		= ocelot_ext_phylink_validate,
> +	.port_modes			= vsc7512_port_modes,
> +	.init_regmap			= ocelot_ext_regmap_init,
> +};
> +
> +static int ocelot_ext_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct dsa_switch *ds;
> +	struct ocelot *ocelot;
> +	struct felix *felix;
> +	int err;
> +
> +	felix = kzalloc(sizeof(*felix), GFP_KERNEL);
> +	if (!felix)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, felix);
> +
> +	ocelot = &felix->ocelot;
> +	ocelot->dev = dev;
> +
> +	ocelot->num_flooding_pgids = 1;
> +
> +	felix->info = &vsc7512_info;
> +
> +	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
> +	if (!ds) {
> +		err = -ENOMEM;
> +		dev_err_probe(dev, err, "Failed to allocate DSA switch\n");
> +		goto err_free_felix;
> +	}
> +
> +	ds->dev = dev;
> +	ds->num_ports = felix->info->num_ports;
> +	ds->num_tx_queues = felix->info->num_tx_queues;
> +
> +	ds->ops = &felix_switch_ops;
> +	ds->priv = ocelot;
> +	felix->ds = ds;
> +	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
> +
> +	err = dsa_register_switch(ds);
> +	if (err) {
> +		dev_err_probe(dev, err, "Failed to register DSA switch\n");
> +		goto err_free_ds;
> +	}
> +
> +	return 0;
> +
> +err_free_ds:
> +	kfree(ds);
> +err_free_felix:
> +	kfree(felix);
> +	return err;
> +}
> +
> +static int ocelot_ext_remove(struct platform_device *pdev)
> +{
> +	struct felix *felix = dev_get_drvdata(&pdev->dev);
> +
> +	if (!felix)
> +		return 0;
> +
> +	dsa_unregister_switch(felix->ds);
> +
> +	kfree(felix->ds);
> +	kfree(felix);
> +
> +	dev_set_drvdata(&pdev->dev, NULL);

The pattern was changed again, so can you please delete this line now,
to be in sync with the other drivers?
https://patchwork.kernel.org/project/netdevbpf/patch/20220921140524.3831101-12-yangyingliang@huawei.com/

> +
> +	return 0;
> +}
> +
> +static void ocelot_ext_shutdown(struct platform_device *pdev)
> +{
> +	struct felix *felix = dev_get_drvdata(&pdev->dev);
> +
> +	if (!felix)
> +		return;
> +
> +	dsa_switch_shutdown(felix->ds);
> +
> +	dev_set_drvdata(&pdev->dev, NULL);
> +}
> +
> +static const struct of_device_id ocelot_ext_switch_of_match[] = {
> +	{ .compatible = "mscc,vsc7512-switch" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
> +
> +static struct platform_driver ocelot_ext_switch_driver = {
> +	.driver = {
> +		.name = "ocelot-switch",
> +		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
> +	},
> +	.probe = ocelot_ext_probe,
> +	.remove = ocelot_ext_remove,
> +	.shutdown = ocelot_ext_shutdown,
> +};
> +module_platform_driver(ocelot_ext_switch_driver);
> +
> +MODULE_DESCRIPTION("External Ocelot Switch driver");
> +MODULE_LICENSE("GPL");
> +MODULE_IMPORT_NS(MFD_OCELOT);
> -- 
> 2.25.1
> 

