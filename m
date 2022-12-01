Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D594063E698
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiLAAjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiLAAja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:39:30 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ACA59FF7;
        Wed, 30 Nov 2022 16:39:29 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n21so530825ejb.9;
        Wed, 30 Nov 2022 16:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AvArBu1DPNvNzji5b58oDkG6GF5iLdW358GxqM3w4sk=;
        b=Grlblsdt0axOJjOsRDpPb48xcEc3yzTZjOJhQp57PVZfX46XnIuLoU9IDE9UHEXORz
         OuNBZ+TIsa6Pi7htJ7T37vuBFnbA8hmD72U2XBz+Zy5rGZAE+1+VmGRArI9pJl4pYdSU
         XGzFuqdMCl7b8/crSEQ5ityIYKBnDxG/rfOtTPzoEsuPj2MCVG1wZDbgHZ2YqMrk6IHP
         nv7nTBMTzfKhirt2Vc17m8kS/g0rysquN0sjhTBQ5OdydLMGXst02+dqTKWQIm+veyWV
         d9CL1TIQXaIZc+Y8k8ATTJf9JdmaUklIML9+U0YyYXFhBd8HMfushAOKiFwmLY5C9SZG
         Dayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvArBu1DPNvNzji5b58oDkG6GF5iLdW358GxqM3w4sk=;
        b=aVw42ELxqPH3Q163hl4E3CEiobq+xd9VjsS5aVIxsYJRibIdn3bIGrXuG5XwFMA+Dn
         KPm1vCwfY44llt3UR4jWtaN52cJPlkvdBZOEm5yYtRXgXiAWpoK/0waIMTo74PfY2sRB
         skoezHmYn1celG/d+Pd0i3vFuPjEkcZOemtnEVeqd84sHczZHdpPFaNlB0S6hOG2U2cw
         2SeBgEY9Yytotmnccar+jmZG+IpIo5Cm/gPxsJJ5FZf5fdM4xeEL+kMem0/12yjXHu2r
         vAf6DoSvuqi0v76jn1CI/By81L3vFDMy/c4SAIO5T+RU7Oc+zXlNK0jtq5rgeOMf16Au
         RZQQ==
X-Gm-Message-State: ANoB5pnSsFix4cpLJGlYIfTlYCLVOUqz8Ci3OYf1w2sSgLUSOH+I8ZGO
        dlYnn9u4xJA8aN3ouQlmw/Y=
X-Google-Smtp-Source: AA0mqf4Dm3NdcwH/SS3vVTaNOK06oJvcnYHwWBFYdU6rT5ReZ4MbhZS4bjLIPXtJYh5nTdaHblDtVw==
X-Received: by 2002:a17:906:2804:b0:78d:e7c0:a2b with SMTP id r4-20020a170906280400b0078de7c00a2bmr55034751ejc.273.1669855167642;
        Wed, 30 Nov 2022 16:39:27 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id d18-20020a05640208d200b0046150ee13besm1128630edz.65.2022.11.30.16.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 16:39:27 -0800 (PST)
Date:   Thu, 1 Dec 2022 02:39:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Message-ID: <20221201003924.rxtratph4ezu65dm@skbuf>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-3-arun.ramadoss@microchip.com>
 <20221128103227.23171-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128103227.23171-3-arun.ramadoss@microchip.com>
 <20221128103227.23171-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 04:02:17PM +0530, Arun Ramadoss wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 5a6bfd42c6f9..cd20f39a565f 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -103,6 +103,10 @@ struct ksz_port {
>  	struct ksz_device *ksz_dev;
>  	struct ksz_irq pirq;
>  	u8 num;
> +#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
> +	u8 hwts_tx_en;

Variable named "en" (enable) which takes the values 0 or 2? Not good.
Also, why is the type not enum hwtstamp_tx_types, but u8? Can't you name
this "enum hwtstamp_tx_types tx_type"?

> +	bool hwts_rx_en;
> +#endif
>  };
>  
>  struct ksz_device {
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index c737635ca266..a41418c6adf6 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -36,15 +36,88 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
>  			      SOF_TIMESTAMPING_RX_HARDWARE |
>  			      SOF_TIMESTAMPING_RAW_HARDWARE;
>  
> -	ts->tx_types = BIT(HWTSTAMP_TX_OFF);
> +	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
>  
> -	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
> +	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
>  
>  	ts->phc_index = ptp_clock_index(ptp_data->clock);
>  
>  	return 0;
>  }
>  
> +int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct hwtstamp_config config;
> +
> +	config.flags = 0;
> +
> +	config.tx_type = dev->ports[port].hwts_tx_en;
> +
> +	if (dev->ports[port].hwts_rx_en)
> +		config.rx_filter = HWTSTAMP_FILTER_ALL;
> +	else
> +		config.rx_filter = HWTSTAMP_FILTER_NONE;
> +
> +	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
> +		-EFAULT : 0;
> +}
> +
> +static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
> +				   struct hwtstamp_config *config)
> +{
> +	struct ksz_port *prt = &dev->ports[port];
> +
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +	case HWTSTAMP_TX_ONESTEP_P2P:
> +		prt->hwts_tx_en = config->tx_type;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config->rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		prt->hwts_rx_en = false;
> +		break;
> +	default:
> +		prt->hwts_rx_en = true;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_ptp_data *ptp_data;
> +	struct hwtstamp_config config;
> +	int ret;
> +
> +	ptp_data = &dev->ptp_data;
> +
> +	mutex_lock(&ptp_data->lock);

I'm not sure that this mutex serves any purpose at all?

One could have argued that concurrent calls to ksz_hwtstamp_get()
shouldn't be able to see incoherent values of prt->hwts_tx_en and of
prt->hwts_rx_en.

But ksz_hwtstamp_get() doesn't acquire this mutex, so that is not true,
this isn't why the mutex is acquired here. I don't know why it is.

> +
> +	ret = copy_from_user(&config, ifr->ifr_data, sizeof(config));
> +	if (ret)
> +		goto error_return;
> +
> +	ret = ksz_set_hwtstamp_config(dev, port, &config);
> +	if (ret)
> +		goto error_return;
> +
> +	ret = copy_to_user(ifr->ifr_data, &config, sizeof(config));
> +
> +error_return:
> +	mutex_unlock(&ptp_data->lock);
> +	return ret;
> +}
