Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F5D60DA7
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfGEWKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:10:44 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35929 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEWKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:10:44 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so8959863qkl.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 15:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZlXZXANEqyyJDmq5LpFVDNlNq6aG7IsK78skhDQh4Cw=;
        b=tWv5BBHcZ1T8Uzg7q+hgdIMtSB2ueX2Sl6eNsMAp60iULrHW5THDlkQpe+wtnwBQEy
         CldA99gNkB6zvR2OhcIpzWib1oqpLm/qERThqRoevlMrB0X8+dPU7uW+eqHDPbQutjHs
         uZGoN7DIwpD7sR/dVoFfTrsrfhkqBsQJf/YO8r1GEHyb3tDsGKC5DPoJ5dDk/cGXuMlU
         o/tvGgWmJ/wlharwI/b8wrww8HXapXurncE3EBdFQuxfhXZ9KmDGXypcNTVsQoYF2LgD
         dyDiGj8QQbHvPpqJG+i+Jcar97HgFiCfwv5wKZGAAKqemxTTvhXzfdu84xo8w9UZ5xH3
         qvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZlXZXANEqyyJDmq5LpFVDNlNq6aG7IsK78skhDQh4Cw=;
        b=f1X1lKn3s7tAgvor4FfIxEijzfWfYCb1vllWRaUp0wupXhMcybfQ7a27r4Ika2cF1K
         +Fh7VYKbf5ey0RU+aKpyncrndCh4aPsUU83gZwJl/J0cAZvy3ZkWspbV2/Z8tZiruZTb
         Hx+ZTOjpDcUTw4QTPHIQGaGVJJQc4YTUykwxEamvJKNdaQRFaThjjhvTxobaEMlhpY1I
         8mmr8ep+5J9dSKjYRs7DlANLz0k9avaMnCFIYZHWWiT8fSrbb6O+Btg2P7DxYaaIqTk0
         0o/wi8qYYQLCufSgZGAQwzc8vLO8I+KopRS0ItBT1Hm2NHnKDA6mu2+qWYorVnXhfPVW
         wrGA==
X-Gm-Message-State: APjAAAXBE9cz1yUVucJkq6OPlHaos8PBwFeaEbzls4kVJPqLNP5G/8tp
        KXR7jseVn5Fm7Mt7vg3t8IWC5A==
X-Google-Smtp-Source: APXvYqzCGy3CqgrPHG5MpMv4+PZPUvQxRnvb55S8rLjW41ANXxFeoSFHTxrMqzRLH4q4dkIUXv5Nrg==
X-Received: by 2002:a37:f511:: with SMTP id l17mr4497194qkk.99.1562364642980;
        Fri, 05 Jul 2019 15:10:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r5sm4462321qkc.42.2019.07.05.15.10.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 15:10:42 -0700 (PDT)
Date:   Fri, 5 Jul 2019 15:10:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v2 8/8] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190705151038.0581a052@cakuba.netronome.com>
In-Reply-To: <20190705195213.22041-9-antoine.tenart@bootlin.com>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
        <20190705195213.22041-9-antoine.tenart@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 21:52:13 +0200, Antoine Tenart wrote:
> This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
> switch for both PTP 1-step and 2-step modes.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

> @@ -596,11 +606,50 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	dev->stats.tx_packets++;
>  	dev->stats.tx_bytes += skb->len;
> -	dev_kfree_skb_any(skb);
> +
> +	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
> +	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> +		struct ocelot_skb *oskb =
> +			kzalloc(sizeof(struct ocelot_skb), GFP_KERNEL);

I think this is the TX path, you can't use GFP_KERNEL here.

> +
> +		oskb->skb = skb;
> +		oskb->id = port->ts_id % 4;
> +		port->ts_id++;
> +
> +		list_add_tail(&oskb->head, &port->skbs);
> +	} else {
> +		dev_kfree_skb_any(skb);
> +	}
>  
>  	return NETDEV_TX_OK;
>  }

> +static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
> +{
> +	struct ocelot *ocelot = port->ocelot;
> +	struct hwtstamp_config cfg;
> +
> +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +		return -EFAULT;
> +
> +	/* reserved for future extensions */
> +	if (cfg.flags)
> +		return -EINVAL;
> +
> +	/* Tx type sanity check */
> +	switch (cfg.tx_type) {
> +	case HWTSTAMP_TX_ON:
> +		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
> +		break;
> +	case HWTSTAMP_TX_ONESTEP_SYNC:
> +		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
> +		 * need to update the origin time.
> +		 */
> +		port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
> +		break;
> +	case HWTSTAMP_TX_OFF:
> +		port->ptp_cmd = 0;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	mutex_lock(&ocelot->ptp_lock);
> +
> +	switch (cfg.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		break;
> +	case HWTSTAMP_FILTER_ALL:
> +	case HWTSTAMP_FILTER_SOME:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_NTP_ALL:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> +		break;
> +	default:
> +		mutex_unlock(&ocelot->ptp_lock);
> +		return -ERANGE;
> +	}

No device reconfig, so the PTP RX stamping is always enabled?  Perhaps
consider setting 

	ocelot->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT

at probe?

> +	/* Commit back the result & save it */
> +	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
> +	mutex_unlock(&ocelot->ptp_lock);
> +
> +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> +}
> +
> +static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	struct ocelot_port *port = netdev_priv(dev);
> +	struct ocelot *ocelot = port->ocelot;
> +
> +	/* The function is only used for PTP operations for now */
> +	if (!ocelot->ptp)
> +		return -EOPNOTSUPP;
> +
> +	switch (cmd) {
> +	case SIOCSHWTSTAMP:
> +		return ocelot_hwstamp_set(port, ifr);
> +	case SIOCGHWTSTAMP:
> +		return ocelot_hwstamp_get(port, ifr);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static const struct net_device_ops ocelot_port_netdev_ops = {
>  	.ndo_open			= ocelot_port_open,
>  	.ndo_stop			= ocelot_port_stop,
> @@ -933,6 +1073,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
>  	.ndo_set_features		= ocelot_set_features,
>  	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
>  	.ndo_setup_tc			= ocelot_setup_tc,
> +	.ndo_do_ioctl			= ocelot_ioctl,
>  };
>  
>  static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
> @@ -1014,12 +1155,42 @@ static int ocelot_get_sset_count(struct net_device *dev, int sset)
>  	return ocelot->num_stats;
>  }
>  
> +static int ocelot_get_ts_info(struct net_device *dev,
> +			      struct ethtool_ts_info *info)
> +{
> +	struct ocelot_port *ocelot_port = netdev_priv(dev);
> +	struct ocelot *ocelot = ocelot_port->ocelot;
> +	int ret;
> +
> +	if (!ocelot->ptp)
> +		return -EOPNOTSUPP;

Hmm.. why does software timestamping depend on PTP?

> +	ret = ethtool_op_get_ts_info(dev, info);
> +	if (ret)
> +		return ret;
> +
> +	info->phc_index = ocelot->ptp_clock ?
> +			  ptp_clock_index(ocelot->ptp_clock) : -1;
> +	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
> +				 SOF_TIMESTAMPING_RX_SOFTWARE |
> +				 SOF_TIMESTAMPING_SOFTWARE |
> +				 SOF_TIMESTAMPING_TX_HARDWARE |
> +				 SOF_TIMESTAMPING_RX_HARDWARE |
> +				 SOF_TIMESTAMPING_RAW_HARDWARE;
> +	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
> +			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
> +	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
> +
> +	return 0;
> +}
> +
>  static const struct ethtool_ops ocelot_ethtool_ops = {
>  	.get_strings		= ocelot_get_strings,
>  	.get_ethtool_stats	= ocelot_get_ethtool_stats,
>  	.get_sset_count		= ocelot_get_sset_count,
>  	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
>  	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
> +	.get_ts_info		= ocelot_get_ts_info,
>  };
>  
>  static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
