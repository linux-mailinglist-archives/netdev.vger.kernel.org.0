Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D6665C40F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbjACQgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjACQgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:36:02 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97EA2736;
        Tue,  3 Jan 2023 08:36:01 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b88so37301662edf.6;
        Tue, 03 Jan 2023 08:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k6KnM2AexIx/moXR1h+Z1J/pTrV7N0AyxhFGGeTojpA=;
        b=CdUn3S0lAp+gxS1ISifnARQJVAbyTwyrWCVcKYraU0Y03WviR8JpYNaHS/BGjQBXEM
         v6i+kLvc1a+NjaMV251TWTC5LUfBVlYliJOckoW1+li1+p12sGcaW3g3V5Lvgz/54B1I
         /BgtededRcCdeVvtBSGzx4s3V839aXPfMkawkZlpk8hGDv0IGygNlscWigFhAFHn9RqW
         DcUFDULq3VZ4pNV+tg/lKl6UyIonmhToL8q3KA1QRogikWqgxA1+X5jncpTtwnxWhYHJ
         xlaWo/iPeBmZ0jA6xJ4wNI7MzaQn39t8eQcspW/7EMIQNl9BibuYyr+dnyrmfEc8TbVO
         BYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6KnM2AexIx/moXR1h+Z1J/pTrV7N0AyxhFGGeTojpA=;
        b=5P6J3SPZjJ/N6atp/t0rX6UGKx5S9sMMZBxCHijsWM1Kps43gyxVnH/s0Iok1uD8vm
         Xj24/YGZNlB94D/EwG/NIplWu8ncie/Fovwt2C1lQIZiz2Fg4w9SENgWSM2sol0druRW
         bKUPgL4TK5KxTcDOnbUGsRc3l6qv4a7VO88VYnhmmLawjJf8EjdjWoPdjD5p5m5ZPshH
         CasaXs0RRV25veHlOSeTEr/kzBQLbxVX7UMC++5NRxUQqS2bXGYyVUWDMyDAEJHC5v83
         +303lM4QgOtha/pqGVNnX9fQPWkTK7bnHGBRD7VS5p4q5yrgj0EQv/SokpEky1DsXf8I
         bKDQ==
X-Gm-Message-State: AFqh2krAE6cDVSSlUCDI97JNlwmqpiyjOJJ19HIP6stCr30XCG9Sd4ph
        mlp6uKIqpVr/XajW7yIs9Fc=
X-Google-Smtp-Source: AMrXdXsZqyEEfUlW0v6MQa9suRQfWk49/GY6SyxDHb7ufCBZNcfOKUx8LcnBYXg4MQcXfWbhrZFfNw==
X-Received: by 2002:a05:6402:e0f:b0:468:58d4:a0f2 with SMTP id h15-20020a0564020e0f00b0046858d4a0f2mr42883513edh.23.1672763760135;
        Tue, 03 Jan 2023 08:36:00 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id bo6-20020a0564020b2600b0048ca2b6c370sm3774717edb.29.2023.01.03.08.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 08:35:59 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:35:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de, jacob.e.keller@intel.com
Subject: Re: [Patch net-next v6 02/13] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Message-ID: <20230103163557.ggwdy3ung6bmtbwd@skbuf>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102050459.31023-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 10:34:48AM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
> the PTP support towards userspace applications such as linuxptp.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
> v1 -> v2
> - Declared the ksz_hwtstamp_get/set to NULL as macro if ptp is not
> enabled
> - Removed mutex lock in hwtstamp_set()
> 
> RFC v2 -> Patch v1
> - moved tagger set and get function to separate patch
> - Removed unnecessary comments
> ---
>  drivers/net/dsa/microchip/ksz_common.c |   3 +
>  drivers/net/dsa/microchip/ksz_common.h |   3 +
>  drivers/net/dsa/microchip/ksz_ptp.c    | 101 +++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_ptp.h    |  11 +++
>  4 files changed, 118 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 3e2ebadeade9..1819f75eb007 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -2977,6 +2977,9 @@ static const struct dsa_switch_ops ksz_switch_ops = {
>  	.get_pause_stats	= ksz_get_pause_stats,
>  	.port_change_mtu	= ksz_change_mtu,
>  	.port_max_mtu		= ksz_max_mtu,
> +	.get_ts_info            = ksz_get_ts_info,
> +	.port_hwtstamp_get      = ksz_hwtstamp_get,
> +	.port_hwtstamp_set      = ksz_hwtstamp_set,

Most of ksz_switch_ops are aligned using tabs, you are introducing these
using spaces.

>  };
>  
>  struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 23ed7fa72a3c..a5ce7ec30ba2 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -102,6 +102,9 @@ struct ksz_port {
>  	struct ksz_device *ksz_dev;
>  	struct ksz_irq pirq;
>  	u8 num;
> +#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
> +	struct hwtstamp_config tstamp_config;
> +#endif
>  };
>  
>  struct ksz_device {
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index fb1efb60ef71..280200b37012 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -24,6 +24,107 @@
>  #define KSZ_PTP_INC_NS 40ULL  /* HW clock is incremented every 40 ns (by 40) */
>  #define KSZ_PTP_SUBNS_BITS 32
>  
> +/* The function is return back the capability of timestamping feature when
> + * requested through ethtool -T <interface> utility
> + */
> +int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
> +{
> +	struct ksz_device *dev	= ds->priv;

There is a tab here between *dev and = which is probably unintended.

> +	struct ksz_ptp_data *ptp_data;
> +
> +	ptp_data = &dev->ptp_data;
> +
> +	if (!ptp_data->clock)
> +		return -ENODEV;
> +
> +	ts->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
> +			      SOF_TIMESTAMPING_RX_HARDWARE |
> +			      SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
> +
> +	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
> +			 BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
> +			 BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
> +			 BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
> +
> +	ts->phc_index = ptp_clock_index(ptp_data->clock);
> +
> +	return 0;
> +}
> +
> +int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct hwtstamp_config *config;
> +	struct ksz_port *prt;
> +
> +	prt = &dev->ports[port];
> +	config = &prt->tstamp_config;
> +
> +	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ?
> +		-EFAULT : 0;
> +}
> +
> +static int ksz_set_hwtstamp_config(struct ksz_device *dev,
> +				   struct hwtstamp_config *config)
> +{
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +	case HWTSTAMP_TX_ONESTEP_P2P:
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config->rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> +		break;
> +	default:
> +		config->rx_filter = HWTSTAMP_FILTER_NONE;
> +		return -ERANGE;
> +	}
> +
> +	return 0;
> +}
> +
> +int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct hwtstamp_config config;
> +	struct ksz_port *prt;
> +	int ret;
> +
> +	prt = &dev->ports[port];
> +
> +	ret = copy_from_user(&config, ifr->ifr_data, sizeof(config));
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz_set_hwtstamp_config(dev, &config);
> +	if (ret)
> +		return ret;
> +
> +	memcpy(&prt->tstamp_config, &config, sizeof(config));
> +
> +	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
> +}
> +
>  static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
>  {
>  	u32 nanoseconds;
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> index 8930047da764..7bb3fde2dd14 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -23,6 +23,11 @@ int ksz_ptp_clock_register(struct dsa_switch *ds);
>  
>  void ksz_ptp_clock_unregister(struct dsa_switch *ds);
>  
> +int ksz_get_ts_info(struct dsa_switch *ds, int port,
> +		    struct ethtool_ts_info *ts);
> +int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
> +int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
> +
>  #else
>  
>  struct ksz_ptp_data {
> @@ -37,6 +42,12 @@ static inline int ksz_ptp_clock_register(struct dsa_switch *ds)
>  
>  static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
>  
> +#define ksz_get_ts_info NULL
> +
> +#define ksz_hwtstamp_get NULL
> +
> +#define ksz_hwtstamp_set NULL
> +
>  #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
>  
>  #endif
> -- 
> 2.36.1
> 
