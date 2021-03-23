Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B71345D06
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCWLfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCWLfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 07:35:25 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E413C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 04:35:25 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b16so23059427eds.7
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 04:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sQQGuMrxUT4EG9O4Nq7yrIVX/jyF//5qTv2rSIOa0yU=;
        b=n/qIwMT+qckxGZdOjQfSQ97SJGe+Cnl9H4MF91dLcRluXLr3gOi1KJp+HOxyfzf34q
         nri1GD8++jkb+Mj7Yk7K4rXS2tZMD9nZHDl3JopDSKpHGL8B0/r3OEGePHQGmqb+xjXj
         Y5t/qsGikBOssTVt6mAbCg4jVP0AJYzxUgXV/JGdqIQ1aYXLfgwp5zr47fLF92h92aRD
         IBCx8u2WgB9YGtagce3IgOkWI3DMbap35HeBfFdsh20IJmp1ph26+EirjfQpFymDBqLb
         +kFI31TS8dMie1J0FVHdCUXbpaIQVOcN0xHjPmKDT3wnlPi4+nE99RK3e6Dkft8Ej4+1
         +0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sQQGuMrxUT4EG9O4Nq7yrIVX/jyF//5qTv2rSIOa0yU=;
        b=Lc3EJrANARGrSNf8hJFANROsy7xqyUUbtvotIbJDfbUomyaVTzhbLF/mQSm1C93Yft
         hy+DSEwzaQ9HsqPLEmSQiOO7IyMTVPNg5WaI2PIcgxDslhmG4Ppg9rvQXxBmjoq33vqO
         0Ya7wJiDDMqsWRJ5dmebtsVtaFlY+ERoXveOssV6Y8RwcSoBf+cGOP2eYhCarl+VEcNZ
         Tvih0qW0XghbQCEPV2Toajey7LZqRx2JbIT7vOC0JGIBI+iIm7LHHFKOKVMMZB/hVNK9
         bUQTEt8Cz34WoAb4AvQyLQTTrnFTyLK6UrjYLX271kMXSvUHJVnABrKfD6G8aE53z2NT
         4Lfg==
X-Gm-Message-State: AOAM53079P8q7X0JXvULsSzay9HGpY+XI0JzyMjC8kImOuMg/sXF1sC/
        yhsr8lDRYq1DB1vLw84L0YE=
X-Google-Smtp-Source: ABdhPJyAUs/Hs2iWFiKugELrNVPLz/xAYS0KlftUTuAQXrsHQNJF02RpA67+5QoR5WLflKmcckkkPg==
X-Received: by 2002:a05:6402:c96:: with SMTP id cm22mr4190624edb.128.1616499323846;
        Tue, 23 Mar 2021 04:35:23 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id gn19sm748411ejc.4.2021.03.23.04.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 04:35:23 -0700 (PDT)
Date:   Tue, 23 Mar 2021 13:35:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210323113522.coidmitlt6e44jjq@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323102326.3677940-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
> All devices are capable of using regular DSA tags. Support for
> Ethertyped DSA tags sort into three categories:
> 
> 1. No support. Older chips fall into this category.
> 
> 2. Full support. Datasheet explicitly supports configuring the CPU
>    port to receive FORWARDs with a DSA tag.
> 
> 3. Undocumented support. Datasheet lists the configuration from
>    category 2 as "reserved for future use", but does empirically
>    behave like a category 2 device.
> 
> Because there are ethernet controllers that do not handle regular DSA
> tags in all cases, it is sometimes preferable to rely on the
> undocumented behavior, as the alternative is a very crippled
> system. But, in those cases, make sure to log the fact that an
> undocumented feature has been enabled.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> In a system using an NXP T1023 SoC connected to a 6390X switch, we
> noticed that TO_CPU frames where not reaching the CPU. This only
> happened on hardware port 8. Looking at the DSA master interface
> (dpaa-ethernet) we could see that an Rx error counter was bumped at
> the same rate. The logs indicated a parser error.
> 
> It just so happens that a TO_CPU coming in on device 0, port 8, will
> result in the first two bytes of the DSA tag being one of:
> 
> 00 40
> 00 44
> 00 46
> 
> My guess is that since these values look like 802.3 length fields, the
> controller's parser will signal an error if the frame length does not
> match what is in the header.

Interesting assumption.
Could you please try this patch out, just for my amusement? It is only
compile-tested.

-----------------------------[ cut here ]-----------------------------
From ab75b63d1bfeccc3032060e6e6dbd2ea8f1d31ed Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 23 Mar 2021 13:03:34 +0200
Subject: [PATCH] fsl/fman: ignore RX parse errors on ports that are DSA
 masters

Tobias reports that when an FMan port receives a Marvell DSA tagged
frame (normal/legacy tag, not EtherType tag) which is a TO_CPU frame
coming in from device 0, port 8, that frame will be dropped.

It appears that the first two bytes of this particular DSA tag (which
overlap with what the FMan parser interprets as an EtherType/Length
field) look like one of the possible values below:

00 40
00 44
00 46

Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 65 ++++++++++---------
 .../net/ethernet/freescale/fman/fman_port.c   |  8 ++-
 .../net/ethernet/freescale/fman/fman_port.h   |  2 +-
 3 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 720dc99bd1fc..069d38cd63c5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -55,6 +55,7 @@
 #include <linux/phy_fixed.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/dsa.h>
 #include <soc/fsl/bman.h>
 #include <soc/fsl/qman.h>
 #include "fman.h"
@@ -2447,34 +2448,6 @@ static inline int dpaa_eth_napi_schedule(struct dpaa_percpu_priv *percpu_priv,
 	return 0;
 }
 
-static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
-					      struct qman_fq *fq,
-					      const struct qm_dqrr_entry *dq,
-					      bool sched_napi)
-{
-	struct dpaa_fq *dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
-	struct dpaa_percpu_priv *percpu_priv;
-	struct net_device *net_dev;
-	struct dpaa_bp *dpaa_bp;
-	struct dpaa_priv *priv;
-
-	net_dev = dpaa_fq->net_dev;
-	priv = netdev_priv(net_dev);
-	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
-	if (!dpaa_bp)
-		return qman_cb_dqrr_consume;
-
-	percpu_priv = this_cpu_ptr(priv->percpu_priv);
-
-	if (dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi))
-		return qman_cb_dqrr_stop;
-
-	dpaa_eth_refill_bpools(priv);
-	dpaa_rx_error(net_dev, priv, percpu_priv, &dq->fd, fq->fqid);
-
-	return qman_cb_dqrr_consume;
-}
-
 static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
 			       struct xdp_frame *xdpf)
 {
@@ -2699,7 +2672,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
 
-	if (unlikely(fd_status & FM_FD_STAT_RX_ERRORS) != 0) {
+	if (!netdev_uses_dsa(net_dev) && unlikely(fd_status & FM_FD_STAT_RX_ERRORS) != 0) {
 		if (net_ratelimit())
 			netif_warn(priv, hw, net_dev, "FD status = 0x%08x\n",
 				   fd_status & FM_FD_STAT_RX_ERRORS);
@@ -2802,6 +2775,37 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	return qman_cb_dqrr_consume;
 }
 
+static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
+					      struct qman_fq *fq,
+					      const struct qm_dqrr_entry *dq,
+					      bool sched_napi)
+{
+	struct dpaa_fq *dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
+	struct dpaa_percpu_priv *percpu_priv;
+	struct net_device *net_dev;
+	struct dpaa_bp *dpaa_bp;
+	struct dpaa_priv *priv;
+
+	net_dev = dpaa_fq->net_dev;
+	if (netdev_uses_dsa(net_dev))
+		return rx_default_dqrr(portal, fq, dq, sched_napi);
+
+	priv = netdev_priv(net_dev);
+	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
+	if (!dpaa_bp)
+		return qman_cb_dqrr_consume;
+
+	percpu_priv = this_cpu_ptr(priv->percpu_priv);
+
+	if (dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi))
+		return qman_cb_dqrr_stop;
+
+	dpaa_eth_refill_bpools(priv);
+	dpaa_rx_error(net_dev, priv, percpu_priv, &dq->fd, fq->fqid);
+
+	return qman_cb_dqrr_consume;
+}
+
 static enum qman_cb_dqrr_result conf_error_dqrr(struct qman_portal *portal,
 						struct qman_fq *fq,
 						const struct qm_dqrr_entry *dq,
@@ -2955,6 +2959,7 @@ static int dpaa_phy_init(struct net_device *net_dev)
 
 static int dpaa_open(struct net_device *net_dev)
 {
+	bool ignore_errors = netdev_uses_dsa(net_dev);
 	struct mac_device *mac_dev;
 	struct dpaa_priv *priv;
 	int err, i;
@@ -2968,7 +2973,7 @@ static int dpaa_open(struct net_device *net_dev)
 		goto phy_init_failed;
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
-		err = fman_port_enable(mac_dev->port[i]);
+		err = fman_port_enable(mac_dev->port[i], ignore_errors);
 		if (err)
 			goto mac_start_failed;
 	}
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0dbc7d..763faec11f5c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -106,6 +106,7 @@
 #define BMI_EBD_EN				0x80000000
 
 #define BMI_PORT_CFG_EN				0x80000000
+#define BMI_PORT_CFG_FDOVR			0x02000000
 
 #define BMI_PORT_STATUS_BSY			0x80000000
 
@@ -1629,7 +1630,7 @@ int fman_port_disable(struct fman_port *port)
 	}
 
 	/* Disable BMI */
-	tmp = ioread32be(bmi_cfg_reg) & ~BMI_PORT_CFG_EN;
+	tmp = ioread32be(bmi_cfg_reg) & ~(BMI_PORT_CFG_EN | BMI_PORT_CFG_FDOVR);
 	iowrite32be(tmp, bmi_cfg_reg);
 
 	/* Wait for graceful stop end */
@@ -1655,6 +1656,7 @@ EXPORT_SYMBOL(fman_port_disable);
 /**
  * fman_port_enable
  * @port:	A pointer to a FM Port module.
+ * @ignore_errors: If set, do not discard frames received with errors.
  *
  * A runtime routine provided to allow disable/enable of port.
  *
@@ -1662,7 +1664,7 @@ EXPORT_SYMBOL(fman_port_disable);
  *
  * Return: 0 on success; Error code otherwise.
  */
-int fman_port_enable(struct fman_port *port)
+int fman_port_enable(struct fman_port *port, bool ignore_errors)
 {
 	u32 __iomem *bmi_cfg_reg;
 	u32 tmp;
@@ -1692,6 +1694,8 @@ int fman_port_enable(struct fman_port *port)
 
 	/* Enable BMI */
 	tmp = ioread32be(bmi_cfg_reg) | BMI_PORT_CFG_EN;
+	if (ignore_errors)
+		tmp |= BMI_PORT_CFG_FDOVR;
 	iowrite32be(tmp, bmi_cfg_reg);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.h b/drivers/net/ethernet/freescale/fman/fman_port.h
index 82f12661a46d..0928361b0e73 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.h
+++ b/drivers/net/ethernet/freescale/fman/fman_port.h
@@ -147,7 +147,7 @@ int fman_port_cfg_buf_prefix_content(struct fman_port *port,
 
 int fman_port_disable(struct fman_port *port);
 
-int fman_port_enable(struct fman_port *port);
+int fman_port_enable(struct fman_port *port, bool ignore_errors);
 
 u32 fman_port_get_qman_channel_id(struct fman_port *port);
 
-----------------------------[ cut here ]-----------------------------

The netdev_uses_dsa thing is a bit trashy, I think that a more polished
version should rather set NETIF_F_RXALL for the DSA master, and have the
dpaa driver act upon that. But first I'm curious if it works.

> 
> As a workaround, switching to EDSA (thereby always having a proper
> EtherType in the frame) solves the issue.

So basically every user needs to change the tag protocol manually to be
able to receive from port 8? Not sure if that's too friendly.

>  drivers/net/dsa/mv88e6xxx/chip.c | 41 +++++++++++++++++++++++++++++---
>  drivers/net/dsa/mv88e6xxx/chip.h |  3 +++
>  2 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 95f07fcd4f85..e7ec883d5f6b 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2531,10 +2531,10 @@ static int mv88e6xxx_setup_port_mode(struct mv88e6xxx_chip *chip, int port)
>  		return mv88e6xxx_set_port_mode_normal(chip, port);
>  
>  	/* Setup CPU port mode depending on its supported tag format */
> -	if (chip->info->tag_protocol == DSA_TAG_PROTO_DSA)
> +	if (chip->tag_protocol == DSA_TAG_PROTO_DSA)
>  		return mv88e6xxx_set_port_mode_dsa(chip, port);
>  
> -	if (chip->info->tag_protocol == DSA_TAG_PROTO_EDSA)
> +	if (chip->tag_protocol == DSA_TAG_PROTO_EDSA)
>  		return mv88e6xxx_set_port_mode_edsa(chip, port);
>  
>  	return -EINVAL;
> @@ -5564,7 +5564,39 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  
> -	return chip->info->tag_protocol;
> +	return chip->tag_protocol;
> +}
> +
> +static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
> +					 enum dsa_tag_protocol proto)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	enum dsa_tag_protocol old_protocol;
> +	int err;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_EDSA:
> +		if (chip->info->tag_protocol != DSA_TAG_PROTO_EDSA)
> +			dev_warn(chip->dev, "Relying on undocumented EDSA tagging behavior\n");
> +
> +		break;
> +	case DSA_TAG_PROTO_DSA:
> +		break;
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	old_protocol = chip->tag_protocol;
> +	chip->tag_protocol = proto;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	err = mv88e6xxx_setup_port_mode(chip, port);
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	if (err)
> +		chip->tag_protocol = old_protocol;
> +
> +	return err;
>  }
>  
>  static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
> @@ -6029,6 +6061,7 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
>  
>  static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
> +	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
>  	.setup			= mv88e6xxx_setup,
>  	.teardown		= mv88e6xxx_teardown,
>  	.phylink_validate	= mv88e6xxx_validate,
> @@ -6209,6 +6242,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>  	if (err)
>  		goto out;
>  
> +	chip->tag_protocol = chip->info->tag_protocol;
> +
>  	mv88e6xxx_phy_init(chip);
>  
>  	if (chip->info->ops->get_eeprom) {
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index bce6e0dc8535..96b775f3fda2 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -261,6 +261,9 @@ struct mv88e6xxx_region_priv {
>  struct mv88e6xxx_chip {
>  	const struct mv88e6xxx_info *info;
>  
> +	/* Currently configured tagging protocol */
> +	enum dsa_tag_protocol tag_protocol;
> +
>  	/* The dsa_switch this private structure is related to */
>  	struct dsa_switch *ds;
>  
> -- 
> 2.25.1
> 
