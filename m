Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE53E21D344
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgGMJ5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGMJ5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 05:57:05 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DABAC061755;
        Mon, 13 Jul 2020 02:57:05 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g20so12830676edm.4;
        Mon, 13 Jul 2020 02:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IHDr0i61dEoNYKywbfuNQGC80X6fvMrVj0nQHT1B3yg=;
        b=MY5MgBgM36eM7b6yMUFVGlvsd5bQyyY0x8WiP0Aep7LsrPlBxfPIq9y/LWat9D0qEF
         JD72EuJtd769vPzvKb49qoJtbNvgS3tS5tyAjtVSC9UUsxa2TqnIseNjM3ss8ec9E+EB
         /6qRS0gYOaoiKlAgrn5mncuwrf5oIMi6k2Yv2xYr+FOkPuNkyNd04xwPB+2Wjc4BnGYM
         hTEC1XQyvBtQsLOXyopDryYCL74eANzMGTRhn1XTKyXID+5xRooqkV/FxaBAaQmAKSaN
         JLgPJFBiWIN64qTNndqX2ub7YdXfUCT6IrGoQj6mPiZsPCfGiLbUFgx0mL4QxUVi5B9G
         YINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IHDr0i61dEoNYKywbfuNQGC80X6fvMrVj0nQHT1B3yg=;
        b=MBDWTqsbxLBA44hELWxAWxWNBWdSJhN9y9cXqQfSakcV7R4RK5tMaOzBnux+7u6+W9
         ZQkPIC3Q1PEc8I8hEAVX2VSw/N0AG80xNiexAl0h7HVC1ehSNI9ypeNcSyCxMG1CX70R
         2d+I7W4DCxrnbszUNMr0Ucu4YNm4L84lPjuvxzb6VwJLzZ4bs4NkgLSz+n1j9YQs2xtx
         g2MsDlmhxGpR6odbHUDixgeDDwOYsipQmlNVd/2qnQKG9HH2ucMM1UuixfW5e+IR+YPj
         l6OnehXrDJbuBJ9C3bYDsVWqI8Kbc7uja0wiAOL196wfVbr+QejGLDyyR/3xhh8XVgV7
         O0YA==
X-Gm-Message-State: AOAM531f/zC+HBhXalOCUKKONsZh9KghmjCTuaJ/6yGUVaMcctEXBmif
        uvs0J/OW0W+zvvEiJsXE6yY=
X-Google-Smtp-Source: ABdhPJx4U5zrZdkrnu3uPQOmvb9QcnJoKcxVSKHsLwlIz0ko4Y4Y3kJIM198WtyhH+jBJbqVBDEr8A==
X-Received: by 2002:aa7:d8cf:: with SMTP id k15mr87604422eds.250.1594634223347;
        Mon, 13 Jul 2020 02:57:03 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id be2sm10942773edb.92.2020.07.13.02.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 02:57:02 -0700 (PDT)
Date:   Mon, 13 Jul 2020 12:57:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware
 timestamping
Message-ID: <20200713095700.rd4u4t6thkzfnlll@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-5-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710113611.3398-5-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Fri, Jul 10, 2020 at 01:36:07PM +0200, Kurt Kanzenbach wrote:
> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> 
> The switch has the ability to take hardware generated time stamps per port for
> PTPv2 event messages in Rx and Tx direction. That is useful for achieving needed
> time synchronization precision for TSN devices/switches. So add support for it.
> 
> There are two directions:
> 
>  * RX
> 
>    The switch has a single register per port to capture a timestamp. That
>    mechanism is not used due to correlation problems. If the software processing
>    is too slow and a PTPv2 event message is received before the previous one has
>    been processed, false timestamps will be captured. Therefore, the switch can
>    do "inline" timestamping which means it can insert the nanoseconds part of
>    the timestamp directly into the PTPv2 event message. The reserved field (4
>    bytes) is leveraged for that. This might not be in accordance with (older)
>    PTP standards, but is the only way to get reliable results.
> 
>  * TX
> 
>    In Tx direction there is no correlation problem, because the software and the
>    driver has to ensure that only one event message is "on the fly". However,
>    the switch provides also a mechanism to check whether a timestamp is
>    lost. That can only happen when a timestamp is read and at this point another
>    message is timestamped. So, that lost bit is checked just in case to indicate
>    to the user that the driver or the software is somewhat buggy.
> 
> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/hirschmann/Makefile           |   1 +
>  drivers/net/dsa/hirschmann/hellcreek.c        |  15 +
>  drivers/net/dsa/hirschmann/hellcreek.h        |  25 +
>  .../net/dsa/hirschmann/hellcreek_hwtstamp.c   | 498 ++++++++++++++++++
>  .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |  58 ++
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  48 +-
>  drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   4 +
>  7 files changed, 635 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
> 
> diff --git a/drivers/net/dsa/hirschmann/Makefile b/drivers/net/dsa/hirschmann/Makefile
> index 39de02a03640..f4075c2998b5 100644
> --- a/drivers/net/dsa/hirschmann/Makefile
> +++ b/drivers/net/dsa/hirschmann/Makefile
> @@ -2,3 +2,4 @@
>  obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+= hellcreek_sw.o
>  hellcreek_sw-objs := hellcreek.o
>  hellcreek_sw-objs += hellcreek_ptp.o
> +hellcreek_sw-objs += hellcreek_hwtstamp.o
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index 9901d6435d97..3941a9a3252d 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -26,6 +26,7 @@
>  
>  #include "hellcreek.h"
>  #include "hellcreek_ptp.h"
> +#include "hellcreek_hwtstamp.h"
>  
>  static const struct hellcreek_counter hellcreek_counter[] = {
>  	{ 0x00, "RxFiltered", },
> @@ -1103,6 +1104,11 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
>  	.port_bridge_leave   = hellcreek_port_bridge_leave,
>  	.port_stp_state_set  = hellcreek_port_stp_state_set,
>  	.phylink_validate    = hellcreek_phylink_validate,
> +	.port_hwtstamp_set   = hellcreek_port_hwtstamp_set,
> +	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
> +	.port_txtstamp	     = hellcreek_port_txtstamp,
> +	.port_rxtstamp	     = hellcreek_port_rxtstamp,
> +	.get_ts_info	     = hellcreek_get_ts_info,
>  };
>  
>  static int hellcreek_probe(struct platform_device *pdev)
> @@ -1202,10 +1208,18 @@ static int hellcreek_probe(struct platform_device *pdev)
>  		goto err_ptp_setup;
>  	}
>  
> +	ret = hellcreek_hwtstamp_setup(hellcreek);
> +	if (ret) {
> +		dev_err(dev, "Failed to setup hardware timestamping!\n");
> +		goto err_tstamp_setup;
> +	}
> +
>  	platform_set_drvdata(pdev, hellcreek);
>  
>  	return 0;
>  
> +err_tstamp_setup:
> +	hellcreek_ptp_free(hellcreek);
>  err_ptp_setup:
>  	dsa_unregister_switch(hellcreek->ds);
>  
> @@ -1216,6 +1230,7 @@ static int hellcreek_remove(struct platform_device *pdev)
>  {
>  	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
>  
> +	hellcreek_hwtstamp_free(hellcreek);
>  	hellcreek_ptp_free(hellcreek);
>  	dsa_unregister_switch(hellcreek->ds);
>  	platform_set_drvdata(pdev, NULL);
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
> index 2d4422fd2567..1d3de72a48a5 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.h
> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
> @@ -212,11 +212,36 @@ struct hellcreek_counter {
>  
>  struct hellcreek;
>  
> +/* State flags for hellcreek_port_hwtstamp::state */
> +enum {
> +	HELLCREEK_HWTSTAMP_ENABLED,
> +	HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
> +};
> +
> +/* A structure to hold hardware timestamping information per port */
> +struct hellcreek_port_hwtstamp {
> +	/* Timestamping state */
> +	unsigned long state;
> +
> +	/* Resources for receive timestamping */
> +	struct sk_buff_head rx_queue; /* For synchronization messages */
> +
> +	/* Resources for transmit timestamping */
> +	unsigned long tx_tstamp_start;
> +	struct sk_buff *tx_skb;
> +
> +	/* Current timestamp configuration */
> +	struct hwtstamp_config tstamp_config;
> +};
> +
>  struct hellcreek_port {
>  	struct hellcreek *hellcreek;
>  	int port;
>  	u16 ptcfg;		/* ptcfg shadow */
>  	u64 *counter_values;
> +
> +	/* Per-port timestamping resources */
> +	struct hellcreek_port_hwtstamp port_hwtstamp;
>  };
>  
>  struct hellcreek_fdb_entry {
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
> new file mode 100644
> index 000000000000..dc0ab75d099b
> --- /dev/null
> +++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
> @@ -0,0 +1,498 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * DSA driver for:
> + * Hirschmann Hellcreek TSN switch.
> + *
> + * Copyright (C) 2019,2020 Hochschule Offenburg
> + * Copyright (C) 2019,2020 Linutronix GmbH
> + * Authors: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> + *	    Kurt Kanzenbach <kurt@linutronix.de>
> + */
> +
> +#include <linux/ptp_classify.h>
> +
> +#include "hellcreek.h"
> +#include "hellcreek_hwtstamp.h"
> +#include "hellcreek_ptp.h"
> +
> +int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
> +			  struct ethtool_ts_info *info)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +
> +	info->phc_index = hellcreek->ptp_clock ?
> +		ptp_clock_index(hellcreek->ptp_clock) : -1;
> +	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
> +		SOF_TIMESTAMPING_RX_HARDWARE |
> +		SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +	/* enabled tx timestamping */
> +	info->tx_types = BIT(HWTSTAMP_TX_ON);
> +
> +	/* L2 & L4 PTPv2 event rx messages are timestamped */
> +	info->rx_filters = BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
> +
> +	return 0;
> +}
> +
> +/* Enabling/disabling TX and RX HW timestamping for different PTP messages is
> + * not available in the switch. Thus, this function only serves as a check if
> + * the user requested what is actually available or not
> + */
> +static int hellcreek_set_hwtstamp_config(struct hellcreek *hellcreek, int port,
> +					 struct hwtstamp_config *config)
> +{
> +	struct hellcreek_port_hwtstamp *ps =
> +		&hellcreek->ports[port].port_hwtstamp;
> +	bool tx_tstamp_enable = false;
> +	bool rx_tstamp_enable = false;
> +
> +	/* Interaction with the timestamp hardware is prevented here.  It is
> +	 * enabled when this config function ends successfully
> +	 */
> +	clear_bit_unlock(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
> +
> +	/* Reserved for future extensions */
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_ON:
> +		tx_tstamp_enable = true;
> +		break;
> +
> +	/* TX HW timestamping can't be disabled on the switch */
> +	case HWTSTAMP_TX_OFF:
> +		config->tx_type = HWTSTAMP_TX_ON;
> +		break;
> +
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config->rx_filter) {
> +	/* RX HW timestamping can't be disabled on the switch */
> +	case HWTSTAMP_FILTER_NONE:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> +		break;
> +
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> +		rx_tstamp_enable = true;
> +		break;
> +
> +	/* RX HW timestamping can't be enabled for all messages on the switch */
> +	case HWTSTAMP_FILTER_ALL:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> +		break;
> +
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	if (!tx_tstamp_enable)
> +		return -ERANGE;
> +
> +	if (!rx_tstamp_enable)
> +		return -ERANGE;
> +
> +	/* If this point is reached, then the requested hwtstamp config is
> +	 * compatible with the hwtstamp offered by the switch.  Therefore,
> +	 * enable the interaction with the HW timestamping
> +	 */
> +	set_bit(HELLCREEK_HWTSTAMP_ENABLED, &ps->state);
> +
> +	return 0;
> +}
> +
> +int hellcreek_port_hwtstamp_set(struct dsa_switch *ds, int port,
> +				struct ifreq *ifr)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port_hwtstamp *ps;
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	ps = &hellcreek->ports[port].port_hwtstamp;
> +
> +	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +		return -EFAULT;
> +
> +	err = hellcreek_set_hwtstamp_config(hellcreek, port, &config);
> +	if (err)
> +		return err;
> +
> +	/* Save the chosen configuration to be returned later */
> +	memcpy(&ps->tstamp_config, &config, sizeof(config));
> +
> +	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
> +		-EFAULT : 0;
> +}
> +
> +int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
> +				struct ifreq *ifr)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port_hwtstamp *ps;
> +	struct hwtstamp_config *config;
> +
> +	ps = &hellcreek->ports[port].port_hwtstamp;
> +	config = &ps->tstamp_config;
> +
> +	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ?
> +		-EFAULT : 0;
> +}
> +
> +/* Get a pointer to the PTP header in this skb */
> +static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)

Maybe this and the function from mv88e6xxx could share the same
implementation somehow.

> +{
> +	u8 *data = skb_mac_header(skb);
> +	unsigned int offset = 0;
> +
> +	if (type & PTP_CLASS_VLAN)
> +		offset += VLAN_HLEN;
> +
> +	switch (type & PTP_CLASS_PMASK) {
> +	case PTP_CLASS_IPV4:
> +		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
> +		break;
> +	case PTP_CLASS_IPV6:
> +		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
> +		break;
> +	case PTP_CLASS_L2:
> +		offset += ETH_HLEN;
> +		break;
> +	default:
> +		return NULL;
> +	}
> +
> +	/* Ensure that the entire header is present in this packet. */
> +	if (skb->len + ETH_HLEN < offset + 34)
> +		return NULL;
> +
> +	return data + offset;
> +}
> +
> +/* Returns a pointer to the PTP header if the caller should time stamp, or NULL
> + * if the caller should not.
> + */
> +static u8 *hellcreek_should_tstamp(struct hellcreek *hellcreek, int port,
> +				   struct sk_buff *skb, unsigned int type)
> +{
> +	struct hellcreek_port_hwtstamp *ps =
> +		&hellcreek->ports[port].port_hwtstamp;
> +	u8 *hdr;
> +
> +	hdr = parse_ptp_header(skb, type);
> +	if (!hdr)
> +		return NULL;
> +
> +	if (!test_bit(HELLCREEK_HWTSTAMP_ENABLED, &ps->state))
> +		return NULL;
> +
> +	return hdr;
> +}
> +
> +static u64 hellcreek_get_reserved_field(u8 *ptp_hdr)
> +{
> +	__be32 *ts;
> +
> +	/* length is checked by parse_ptp_header() */
> +	ts = (__force __be32 *)&ptp_hdr[16];
> +
> +	return be32_to_cpup(ts);
> +}
> +
> +static int hellcreek_ptp_hwtstamp_available(struct hellcreek *hellcreek,
> +					    unsigned int ts_reg)
> +{
> +	u16 status;
> +
> +	status = hellcreek_ptp_read(hellcreek, ts_reg);
> +
> +	if (status & PR_TS_STATUS_TS_LOST)
> +		dev_err(hellcreek->dev,
> +			"Tx time stamp lost! This should never happen!\n");
> +
> +	/* If hwtstamp is not available, this means the previous hwtstamp was
> +	 * successfully read, and the one we need is not yet available
> +	 */
> +	return (status & PR_TS_STATUS_TS_AVAIL) ? 1 : 0;
> +}
> +
> +/* Get nanoseconds timestamp from timestamping unit */
> +static u64 hellcreek_ptp_hwtstamp_read(struct hellcreek *hellcreek,
> +				       unsigned int ts_reg)
> +{
> +	u16 nsl, nsh;
> +
> +	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
> +	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
> +	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
> +	nsh = hellcreek_ptp_read(hellcreek, ts_reg);
> +	nsl = hellcreek_ptp_read(hellcreek, ts_reg);
> +
> +	return (u64)nsl | ((u64)nsh << 16);
> +}
> +
> +static int hellcreek_txtstamp_work(struct hellcreek *hellcreek,
> +				   struct hellcreek_port_hwtstamp *ps, int port)
> +{
> +	struct skb_shared_hwtstamps shhwtstamps;
> +	unsigned int status_reg, data_reg;
> +	struct sk_buff *tmp_skb;
> +	int ts_status;
> +	u64 ns = 0;
> +
> +	if (!ps->tx_skb)
> +		return 0;
> +
> +	switch (port) {
> +	case 2:
> +		status_reg = PR_TS_TX_P1_STATUS_C;
> +		data_reg   = PR_TS_TX_P1_DATA_C;
> +		break;
> +	case 3:
> +		status_reg = PR_TS_TX_P2_STATUS_C;
> +		data_reg   = PR_TS_TX_P2_DATA_C;
> +		break;
> +	default:
> +		dev_err(hellcreek->dev, "Wrong port for timestamping!\n");
> +		return 0;
> +	}
> +
> +	ts_status = hellcreek_ptp_hwtstamp_available(hellcreek, status_reg);
> +
> +	/* Not available yet? */
> +	if (ts_status == 0) {
> +		/* Check whether the operation of reading the tx timestamp has
> +		 * exceeded its allowed period
> +		 */
> +		if (time_is_before_jiffies(ps->tx_tstamp_start +
> +					   TX_TSTAMP_TIMEOUT)) {
> +			dev_err(hellcreek->dev,
> +				"Timeout while waiting for Tx timestamp!\n");
> +			goto free_and_clear_skb;
> +		}
> +
> +		/* The timestamp should be available quickly, while getting it
> +		 * in high priority. Restart the work
> +		 */
> +		return 1;
> +	}
> +
> +	spin_lock(&hellcreek->ptp_lock);
> +	ns  = hellcreek_ptp_hwtstamp_read(hellcreek, data_reg);
> +	ns += hellcreek_ptp_gettime_seconds(hellcreek, ns);
> +	spin_unlock(&hellcreek->ptp_lock);
> +
> +	/* Now we have the timestamp in nanoseconds, store it in the correct
> +	 * structure in order to send it to the user
> +	 */
> +	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +	shhwtstamps.hwtstamp = ns_to_ktime(ns);
> +
> +	tmp_skb = ps->tx_skb;
> +	ps->tx_skb = NULL;
> +
> +	/* skb_complete_tx_timestamp() frees up the client to make another
> +	 * timestampable transmit.  We have to be ready for it by clearing the
> +	 * ps->tx_skb "flag" beforehand
> +	 */
> +	clear_bit_unlock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
> +
> +	/* Deliver a clone of the original outgoing tx_skb with tx hwtstamp */
> +	skb_complete_tx_timestamp(tmp_skb, &shhwtstamps);
> +
> +	return 0;
> +
> +free_and_clear_skb:
> +	dev_kfree_skb_any(ps->tx_skb);
> +	ps->tx_skb = NULL;
> +	clear_bit_unlock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
> +
> +	return 0;
> +}
> +
> +static void hellcreek_get_rxts(struct hellcreek *hellcreek,
> +			       struct hellcreek_port_hwtstamp *ps,
> +			       struct sk_buff *skb, struct sk_buff_head *rxq,
> +			       int port)
> +{
> +	struct skb_shared_hwtstamps *shwt;
> +	struct sk_buff_head received;
> +	unsigned long flags;
> +
> +	/* The latched timestamp belongs to one of the received frames. */
> +	__skb_queue_head_init(&received);
> +
> +	/* Lock & disable interrupts */
> +	spin_lock_irqsave(&rxq->lock, flags);
> +
> +	/* Add the reception queue "rxq" to the "received" queue an reintialize
> +	 * "rxq".  From now on, we deal with "received" not with "rxq"
> +	 */
> +	skb_queue_splice_tail_init(rxq, &received);
> +
> +	spin_unlock_irqrestore(&rxq->lock, flags);
> +
> +	for (; skb; skb = __skb_dequeue(&received)) {
> +		unsigned int type;
> +		u8 *hdr;
> +		u64 ns;
> +
> +		/* Get nanoseconds from ptp packet */
> +		type = SKB_PTP_TYPE(skb);
> +		hdr  = parse_ptp_header(skb, type);
> +		ns   = hellcreek_get_reserved_field(hdr);
> +
> +		/* Add seconds part */
> +		spin_lock(&hellcreek->ptp_lock);
> +		ns += hellcreek_ptp_gettime_seconds(hellcreek, ns);
> +		spin_unlock(&hellcreek->ptp_lock);
> +
> +		/* Save time stamp */
> +		shwt = skb_hwtstamps(skb);
> +		memset(shwt, 0, sizeof(*shwt));
> +		shwt->hwtstamp = ns_to_ktime(ns);
> +		netif_rx_ni(skb);
> +	}
> +}
> +
> +static void hellcreek_rxtstamp_work(struct hellcreek *hellcreek,
> +				    struct hellcreek_port_hwtstamp *ps,
> +				    int port)
> +{
> +	struct sk_buff *skb;
> +
> +	skb = skb_dequeue(&ps->rx_queue);
> +	if (skb)
> +		hellcreek_get_rxts(hellcreek, ps, skb, &ps->rx_queue, port);
> +}
> +
> +long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp)
> +{
> +	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
> +	struct dsa_switch *ds = hellcreek->ds;
> +	struct hellcreek_port_hwtstamp *ps;
> +	int i, restart = 0;
> +
> +	for (i = 2; i < ds->num_ports; i++) {
> +		ps = &hellcreek->ports[i].port_hwtstamp;
> +
> +		if (test_bit(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS, &ps->state))
> +			restart |= hellcreek_txtstamp_work(hellcreek, ps, i);
> +
> +		hellcreek_rxtstamp_work(hellcreek, ps, i);
> +	}
> +
> +	return restart ? 1 : -1;
> +}
> +
> +bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
> +			     struct sk_buff *clone, unsigned int type)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port_hwtstamp *ps;
> +	u8 *hdr;
> +
> +	ps = &hellcreek->ports[port].port_hwtstamp;
> +
> +	/* Check if the driver is expected to do HW timestamping */
> +	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
> +		return false;
> +

I would like to get some clarification on whether "SKBTX_IN_PROGRESS"
should be set in shtx->tx_flags or not. On one hand, it's asking for
trouble, on the other hand, it's kind of required for proper compliance
to API pre-SO_TIMESTAMPING...

> +	/* Make sure the message is a PTP message that needs to be timestamped
> +	 * and the interaction with the HW timestamping is enabled. If not, stop
> +	 * here
> +	 */
> +	hdr = hellcreek_should_tstamp(hellcreek, port, clone, type);
> +	if (!hdr)
> +		return false;
> +
> +	if (test_and_set_bit_lock(HELLCREEK_HWTSTAMP_TX_IN_PROGRESS,
> +				  &ps->state))
> +		return false;
> +
> +	ps->tx_skb = clone;
> +
> +	/* store the number of ticks occurred since system start-up till this
> +	 * moment
> +	 */
> +	ps->tx_tstamp_start = jiffies;
> +
> +	ptp_schedule_worker(hellcreek->ptp_clock, 0);
> +
> +	return true;
> +}
> +
> +bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
> +			     struct sk_buff *skb, unsigned int type)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port_hwtstamp *ps;
> +	u8 *hdr;
> +
> +	ps = &hellcreek->ports[port].port_hwtstamp;
> +
> +	/* This check only fails if the user did not initialize hardware
> +	 * timestamping beforehand.
> +	 */
> +	if (ps->tstamp_config.rx_filter != HWTSTAMP_FILTER_PTP_V2_EVENT)
> +		return false;
> +
> +	/* Make sure the message is a PTP message that needs to be timestamped
> +	 * and the interaction with the HW timestamping is enabled. If not, stop
> +	 * here
> +	 */
> +	hdr = hellcreek_should_tstamp(hellcreek, port, skb, type);
> +	if (!hdr)
> +		return false;
> +
> +	SKB_PTP_TYPE(skb) = type;
> +
> +	skb_queue_tail(&ps->rx_queue, skb);
> +
> +	ptp_schedule_worker(hellcreek->ptp_clock, 0);
> +
> +	return true;
> +}
> +
> +static void hellcreek_hwtstamp_port_setup(struct hellcreek *hellcreek, int port)
> +{
> +	struct hellcreek_port_hwtstamp *ps =
> +		&hellcreek->ports[port].port_hwtstamp;
> +
> +	skb_queue_head_init(&ps->rx_queue);
> +}
> +
> +int hellcreek_hwtstamp_setup(struct hellcreek *hellcreek)
> +{
> +	int i;
> +
> +	/* Initialize timestamping ports. */
> +	for (i = 2; i < NUM_PORTS; ++i)
> +		hellcreek_hwtstamp_port_setup(hellcreek, i);
> +

Would something like this work better instead?

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_user_port(ds, port))
			continue;

		hellcreek_hwtstamp_port_setup(hellcreek, port);
	}

It is easier to follow for the non-expert reviewer (the information that
port 0 is CPU and port 1 is "tunnel port" is not immediately findable)
and (I don't know if this is going to be true or not) in the long term,
you'd need to do less driver rework when this switch IP is instantiated
in other chips that will have a different port layout.

> +	/* Select the synchronized clock as the source timekeeper for the
> +	 * timestamps and enable inline timestamping.
> +	 */
> +	hellcreek_ptp_write(hellcreek, PR_SETTINGS_C_TS_SRC_TK_MASK |
> +			    PR_SETTINGS_C_RES3TS,
> +			    PR_SETTINGS_C);
> +
> +	return 0;
> +}
> +
> +void hellcreek_hwtstamp_free(struct hellcreek *hellcreek)
> +{
> +	/* Nothing todo */
> +}
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
> new file mode 100644
> index 000000000000..c0745ffa1ebb
> --- /dev/null
> +++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
> @@ -0,0 +1,58 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * DSA driver for:
> + * Hirschmann Hellcreek TSN switch.
> + *
> + * Copyright (C) 2019,2020 Hochschule Offenburg
> + * Copyright (C) 2019,2020 Linutronix GmbH
> + * Authors: Kurt Kanzenbach <kurt@linutronix.de>
> + *	    Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> + */
> +
> +#ifndef _HELLCREEK_HWTSTAMP_H_
> +#define _HELLCREEK_HWTSTAMP_H_
> +
> +#include <net/dsa.h>
> +#include "hellcreek.h"
> +
> +/* Timestamp Register */
> +#define PR_TS_RX_P1_STATUS_C	(0x1d * 2)
> +#define PR_TS_RX_P1_DATA_C	(0x1e * 2)
> +#define PR_TS_TX_P1_STATUS_C	(0x1f * 2)
> +#define PR_TS_TX_P1_DATA_C	(0x20 * 2)
> +#define PR_TS_RX_P2_STATUS_C	(0x25 * 2)
> +#define PR_TS_RX_P2_DATA_C	(0x26 * 2)
> +#define PR_TS_TX_P2_STATUS_C	(0x27 * 2)
> +#define PR_TS_TX_P2_DATA_C	(0x28 * 2)
> +
> +#define PR_TS_STATUS_TS_AVAIL	BIT(2)
> +#define PR_TS_STATUS_TS_LOST	BIT(3)
> +
> +#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
> +

Since mv88e6xxx also uses this, maybe we could consider adding it to
DSA_SKB_CB.

> +/* TX_TSTAMP_TIMEOUT: This limits the time spent polling for a TX
> + * timestamp. When working properly, hardware will produce a timestamp
> + * within 1ms. Software may enounter delays, so the timeout is set
> + * accordingly.
> + */
> +#define TX_TSTAMP_TIMEOUT	msecs_to_jiffies(40)
> +
> +int hellcreek_port_hwtstamp_set(struct dsa_switch *ds, int port,
> +				struct ifreq *ifr);
> +int hellcreek_port_hwtstamp_get(struct dsa_switch *ds, int port,
> +				struct ifreq *ifr);
> +
> +bool hellcreek_port_rxtstamp(struct dsa_switch *ds, int port,
> +			     struct sk_buff *clone, unsigned int type);
> +bool hellcreek_port_txtstamp(struct dsa_switch *ds, int port,
> +			     struct sk_buff *clone, unsigned int type);
> +
> +int hellcreek_get_ts_info(struct dsa_switch *ds, int port,
> +			  struct ethtool_ts_info *info);
> +
> +long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp);
> +
> +int hellcreek_hwtstamp_setup(struct hellcreek *chip);
> +void hellcreek_hwtstamp_free(struct hellcreek *chip);
> +
> +#endif /* _HELLCREEK_HWTSTAMP_H_ */
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> index c606a26a130e..8c2cef2b60fb 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> @@ -12,14 +12,15 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include "hellcreek.h"
>  #include "hellcreek_ptp.h"
> +#include "hellcreek_hwtstamp.h"
>  
> -static u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
> +u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
>  {
>  	return readw(hellcreek->ptp_base + offset);
>  }
>  
> -static void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
> -				unsigned int offset)
> +void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
> +			 unsigned int offset)
>  {
>  	writew(data, hellcreek->ptp_base + offset);
>  }
> @@ -61,6 +62,24 @@ static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
>  	return ns;
>  }
>  
> +/* Retrieve the seconds parts in nanoseconds for a packet timestamped with @ns.
> + * There has to be a check whether an overflow occurred between the packet
> + * arrival and now. If so use the correct seconds (-1) for calculating the
> + * packet arrival time.
> + */
> +u64 hellcreek_ptp_gettime_seconds(struct hellcreek *hellcreek, u64 ns)
> +{
> +	u64 s;
> +
> +	__hellcreek_ptp_gettime(hellcreek);
> +	if (hellcreek->last_ts > ns)
> +		s = hellcreek->seconds * NSEC_PER_SEC;
> +	else
> +		s = (hellcreek->seconds - 1) * NSEC_PER_SEC;
> +
> +	return s;
> +}
> +
>  static int hellcreek_ptp_gettime(struct ptp_clock_info *ptp,
>  				 struct timespec64 *ts)
>  {
> @@ -238,17 +257,18 @@ int hellcreek_ptp_setup(struct hellcreek *hellcreek)
>  	 * accumulator_overflow_rate shall not exceed 62.5 MHz (which adjusts
>  	 * the nominal frequency by 6.25%)
>  	 */
> -	hellcreek->ptp_clock_info.max_adj   = 62500000;
> -	hellcreek->ptp_clock_info.n_alarm   = 0;
> -	hellcreek->ptp_clock_info.n_pins    = 0;
> -	hellcreek->ptp_clock_info.n_ext_ts  = 0;
> -	hellcreek->ptp_clock_info.n_per_out = 0;
> -	hellcreek->ptp_clock_info.pps	    = 0;
> -	hellcreek->ptp_clock_info.adjfine   = hellcreek_ptp_adjfine;
> -	hellcreek->ptp_clock_info.adjtime   = hellcreek_ptp_adjtime;
> -	hellcreek->ptp_clock_info.gettime64 = hellcreek_ptp_gettime;
> -	hellcreek->ptp_clock_info.settime64 = hellcreek_ptp_settime;
> -	hellcreek->ptp_clock_info.enable    = hellcreek_ptp_enable;
> +	hellcreek->ptp_clock_info.max_adj     = 62500000;
> +	hellcreek->ptp_clock_info.n_alarm     = 0;
> +	hellcreek->ptp_clock_info.n_pins      = 0;
> +	hellcreek->ptp_clock_info.n_ext_ts    = 0;
> +	hellcreek->ptp_clock_info.n_per_out   = 0;
> +	hellcreek->ptp_clock_info.pps	      = 0;
> +	hellcreek->ptp_clock_info.adjfine     = hellcreek_ptp_adjfine;
> +	hellcreek->ptp_clock_info.adjtime     = hellcreek_ptp_adjtime;
> +	hellcreek->ptp_clock_info.gettime64   = hellcreek_ptp_gettime;
> +	hellcreek->ptp_clock_info.settime64   = hellcreek_ptp_settime;
> +	hellcreek->ptp_clock_info.enable      = hellcreek_ptp_enable;
> +	hellcreek->ptp_clock_info.do_aux_work = hellcreek_hwtstamp_work;
>  

Could you minimize the diff here by indenting these assignments properly
in the first place, to avoid reindenting them later? It's hard to follow
what changed. There are also some tabs vs spaces inconsistencies.

>  	hellcreek->ptp_clock = ptp_clock_register(&hellcreek->ptp_clock_info,
>  						  hellcreek->dev);
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.h b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
> index 2dd8aaa532d0..e0eca1f4a494 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.h
> +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
> @@ -59,6 +59,10 @@
>  
>  int hellcreek_ptp_setup(struct hellcreek *hellcreek);
>  void hellcreek_ptp_free(struct hellcreek *hellcreek);
> +u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset);
> +void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
> +			 unsigned int offset);
> +u64 hellcreek_ptp_gettime_seconds(struct hellcreek *hellcreek, u64 ns);
>  
>  #define ptp_to_hellcreek(ptp)					\
>  	container_of(ptp, struct hellcreek, ptp_clock_info)
> -- 
> 2.20.1
> 

Thanks,
-Vladimir
