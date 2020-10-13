Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F3A28CFF1
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 16:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388479AbgJMONI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 10:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388308AbgJMONI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 10:13:08 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7B0C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 07:13:07 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n15so24270262wrq.2
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 07:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8Lgo+BhNewfrDpcQjXlds1MNXx+/6h/dLhrZxMBOp14=;
        b=W6TUEzwGLZdNXbOOO/wl9Ju1p4P5be+Y0kvAngJjlL77V8v1N9xVqZoZHFhZ0Hkh8U
         cv3vO9ruFuwYKOl7nC8ZhUkV/IxnDrriBCQSAiz5Zxb84yuTe+w4twOWXnzfRuq9kQAO
         ctkxJzBxFz0NHNEvXDazS/4oTk1A0c2eJCf014HyKQ2SAYuZ8Z6oyNhhJrt2nGWc0I3z
         GMPrrLR1OL/1DfWRpAKDJ1wRXBOnpMqPb0PWYogIGoZ5Zmc8qPH+mmidrCdqjQlaYeDw
         1sTkvhXWyLQXxI65B6gs/yWxhFNgK97MLD6SvAgPLUmaMWR4OZreCXez/1Fcl56B8K+8
         2Row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Lgo+BhNewfrDpcQjXlds1MNXx+/6h/dLhrZxMBOp14=;
        b=WBRRUB5VoOrs25vRrEI8IJUJf8cGRRgMew8CTJjEnPDMCEBw+g1usorBDPY2nWeIsm
         VaZ0xIDY9KL/I3wepqiJovFf0ld4SLvas1ff4mDts5th6BniZ9kWbNUrCbbKN1S/KRzM
         MMmopLApE4lpLmcqchYBlpE6UsEyv0k8WvFqGG8Irq2O7sYOW+/aF6ZYJnFW2P1ai3Jt
         bsqz+sv2sQkZbSyVO8OkdITGKI2Hw2RF/V7oxhAOGT0oJhIM2HOn86bpzX6hjEsDtvkL
         rptWYfBnrpVbTcUmSX6YQ7KD9NDjbfDXSKlKt3Lz0we5bf4G+xJ5JD4NTT6CnFdXBxjq
         3EXQ==
X-Gm-Message-State: AOAM533q2hnPiSHIwwtaODjEWAdz5+3sMbUgG/qtx/9P8plYEuwYw6cF
        H88bxJV9JoZc8L/n3GkNGBQSxA==
X-Google-Smtp-Source: ABdhPJx89kX+cXzker6RFVu+teaibI8F7nytLgLkQTLN/3e4QQUZ1hYdBppy8oxO8GLrgiL58G6/QA==
X-Received: by 2002:a5d:5743:: with SMTP id q3mr35570190wrw.167.1602598386301;
        Tue, 13 Oct 2020 07:13:06 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f8sm16290095wrw.85.2020.10.13.07.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 07:13:05 -0700 (PDT)
Date:   Tue, 13 Oct 2020 16:13:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH 08/10] net: mscc: ocelot: register devlink ports
Message-ID: <20201013141302.GA3251@nanopsycho.orion>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
 <20201013134849.395986-9-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013134849.395986-9-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 13, 2020 at 03:48:47PM CEST, vladimir.oltean@nxp.com wrote:
>Add devlink integration into the mscc_ocelot switchdev driver. Only the
>probed interfaces are registered with devlink, because for convenience,
>struct devlink_port was included into struct ocelot_port_private, which
>is only initialized for the ports that are used.
>
>Note that the felix DSA driver is already integrated with devlink by
>default, since that is a thing that the DSA core takes care of.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot.h         |  4 +
> drivers/net/ethernet/mscc/ocelot_net.c     | 92 ++++++++++++++++++++++
> drivers/net/ethernet/mscc/ocelot_vsc7514.c |  7 ++
> include/soc/mscc/ocelot.h                  |  1 +
> 4 files changed, 104 insertions(+)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
>index 8eae68e0fd0b..3fee5f565920 100644
>--- a/drivers/net/ethernet/mscc/ocelot.h
>+++ b/drivers/net/ethernet/mscc/ocelot.h
>@@ -65,6 +65,8 @@ struct ocelot_port_private {
> 	struct phy *serdes;
> 
> 	struct ocelot_port_tc tc;
>+
>+	struct devlink_port devlink_port;
> };
> 
> struct ocelot_dump_ctx {
>@@ -106,6 +108,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
> 
> int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
> 		      struct phy_device *phy);
>+int ocelot_devlink_init(struct ocelot *ocelot);
>+void ocelot_devlink_teardown(struct ocelot *ocelot);
> 
> extern struct notifier_block ocelot_netdevice_nb;
> extern struct notifier_block ocelot_switchdev_nb;
>diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
>index d3c03942546d..a11e5e7a0228 100644
>--- a/drivers/net/ethernet/mscc/ocelot_net.c
>+++ b/drivers/net/ethernet/mscc/ocelot_net.c
>@@ -8,6 +8,98 @@
> #include "ocelot.h"
> #include "ocelot_vcap.h"
> 
>+struct ocelot_devlink_private {
>+	struct ocelot *ocelot;
>+};
>+
>+static const struct devlink_ops ocelot_devlink_ops = {
>+};
>+
>+static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
>+{
>+	struct ocelot_port *ocelot_port = ocelot->ports[port];
>+	struct devlink *dl = ocelot->devlink;
>+	struct devlink_port_attrs attrs = {};
>+	struct ocelot_port_private *priv;
>+	struct devlink_port *dlp;
>+
>+	if (!ocelot_port)
>+		return 0;
>+
>+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
>+	dlp = &priv->devlink_port;
>+
>+	attrs.phys.port_number = port;
>+
>+	if (priv->dev)
>+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>+	else
>+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
>+
>+	devlink_port_attrs_set(dlp, &attrs);
>+
>+	return devlink_port_register(dl, dlp, port);

You are missing devlink_port_type_eth_set()


>+}
>+
>+static void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
>+{
>+	struct ocelot_port *ocelot_port = ocelot->ports[port];
>+	struct ocelot_port_private *priv;
>+	struct devlink_port *dlp;
>+
>+	if (!ocelot_port)
>+		return;
>+
>+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
>+	dlp = &priv->devlink_port;
>+
>+	devlink_port_unregister(dlp);
>+}
>+
>+int ocelot_devlink_init(struct ocelot *ocelot)
>+{
>+	struct ocelot_devlink_private *dl_priv;
>+	int port, err;
>+
>+	ocelot->devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*dl_priv));
>+	if (!ocelot->devlink)
>+		return -ENOMEM;
>+	dl_priv = devlink_priv(ocelot->devlink);
>+	dl_priv->ocelot = ocelot;
>+
>+	err = devlink_register(ocelot->devlink, ocelot->dev);

>+	if (err)
>+		goto free_devlink;
>+
>+	for (port = 0; port < ocelot->num_phys_ports; port++) {
>+		err = ocelot_port_devlink_init(ocelot, port);
>+		if (err) {
>+			while (port-- > 0)
>+				ocelot_port_devlink_teardown(ocelot, port);
>+			goto unregister_devlink;
>+		}
>+	}
>+
>+	return 0;
>+
>+unregister_devlink:
>+	devlink_unregister(ocelot->devlink);
>+free_devlink:
>+	devlink_free(ocelot->devlink);
>+	return err;
>+}
>+
>+void ocelot_devlink_teardown(struct ocelot *ocelot)
>+{
>+	int port;
>+
>+	for (port = 0; port < ocelot->num_phys_ports; port++)
>+		ocelot_port_devlink_teardown(ocelot, port);
>+
>+	devlink_unregister(ocelot->devlink);
>+	devlink_free(ocelot->devlink);
>+}
>+
> int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
> 			       struct flow_cls_offload *f,
> 			       bool ingress)
>diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
>index ea55f4d20ecc..6512ddeafd50 100644
>--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
>+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
>@@ -1292,6 +1292,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> 		}
> 	}
> 
>+	err = ocelot_devlink_init(ocelot);
>+	if (err) {
>+		mscc_ocelot_release_ports(ocelot);
>+		goto out_put_ports;
>+	}
>+
> 	register_netdevice_notifier(&ocelot_netdevice_nb);
> 	register_switchdev_notifier(&ocelot_switchdev_nb);
> 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
>@@ -1307,6 +1313,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
> {
> 	struct ocelot *ocelot = platform_get_drvdata(pdev);
> 
>+	ocelot_devlink_teardown(ocelot);
> 	ocelot_deinit_timestamp(ocelot);
> 	mscc_ocelot_release_ports(ocelot);
> 	ocelot_deinit(ocelot);
>diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
>index c6153c73dbfe..19ce7ea11163 100644
>--- a/include/soc/mscc/ocelot.h
>+++ b/include/soc/mscc/ocelot.h
>@@ -599,6 +599,7 @@ struct ocelot_port {
> 
> struct ocelot {
> 	struct device			*dev;
>+	struct devlink			*devlink;
> 
> 	const struct ocelot_ops		*ops;
> 	struct regmap			*targets[TARGET_MAX];
>-- 
>2.25.1
>
