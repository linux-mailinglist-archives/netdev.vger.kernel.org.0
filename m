Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA672632F77
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiKUWBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiKUWBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:01:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC6C4B63;
        Mon, 21 Nov 2022 14:01:28 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z20so16672852edc.13;
        Mon, 21 Nov 2022 14:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aQF3+q5WU7uAYCqoAZJ08bGEXcExgFNn6CLEzUuYyrg=;
        b=JjiVDL3582jO2F6pAIsWhsb8jCcslSt9WsMy28O29xDREBds2C3d2eVVScLG5PwVGY
         MGDiA/a4dIHjDJCbDtd5pIILoqwQI9sy1qW4BkqHVxI90c2FPX+KlMU5AshWziVA9EOx
         D93sjAtdCP691jAKtnS+Ph2VA9hzOLfV692ByV/x1OgY1xNDE6pq6mlotF3F4ZviQPYf
         Vy5T62ZGMcvJsvtez8wHFhVZ3g0pUPN8r6WGMa7gwF91utW6QyPl5Wp5+LmEXyxVZ0ON
         ai9/AsZrsyuonI9eDOwhOvdLOgWMomMFrec2jzhWmY2GhE8ahaWkM39BPrHYKlAhJxNf
         wWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQF3+q5WU7uAYCqoAZJ08bGEXcExgFNn6CLEzUuYyrg=;
        b=1lfIw/MKYgslkHeX16eEBjf+E8DN7tC6zhc6TihykEyhSKenaYkdy2pUKq3Mccqgkg
         bH7Dip4+jkbg0OXPntTLOKxzPFDv7lZvSRtDmbCmxrRrQcXRmn728uUl9GYD9ptVXBRH
         nAr1zXD4z7Gj7PTLIlZQ72PAigREs69ssZC6jf2Yy+BkPWOMFY5zKJ/PCoiUME/uvRUw
         Ff0LpX1swLYxApqjFLRZ5QSdOmmYJFvZ65w7DD+DUeGo4VcXv3O37SvWS33Y9PPIrUng
         kMbpjeH2sMkBjMRYBmM6YcfazcLuCoYisiz655QmzR5UIPcoH4gFwfFVIYzu+zzFwoju
         iSOw==
X-Gm-Message-State: ANoB5plDrrxPzPxFZ/NJ9ZrY5VtkvDkaAa+RD2QqltnTC6SRzRhiE7Bh
        hcUamNM1xlqZ9xP+1iUHr1w=
X-Google-Smtp-Source: AA0mqf7C2s2xr6m1Qy2VHFXinAfioHDNEjk+CDNd+1mR4nrIK233j3SlmbaJyUzOVDsifsQ2R+zmuA==
X-Received: by 2002:aa7:dbca:0:b0:458:3f65:4e42 with SMTP id v10-20020aa7dbca000000b004583f654e42mr18503336edt.39.1669068086977;
        Mon, 21 Nov 2022 14:01:26 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id g18-20020a1709064e5200b0079800b8173asm5368189ejw.158.2022.11.21.14.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 14:01:26 -0800 (PST)
Date:   Tue, 22 Nov 2022 00:01:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [RFC Patch net-next v2 2/8] net: dsa: microchip: adding the
 posix clock support
Message-ID: <20221121220124.nictbhbw44ynnemg@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:11:44PM +0530, Arun Ramadoss wrote:
> @@ -17,10 +18,21 @@ config NET_DSA_MICROCHIP_KSZ9477_I2C
>  config NET_DSA_MICROCHIP_KSZ_SPI
>  	tristate "KSZ series SPI connected switch driver"
>  	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select REGMAP_SPI
>  	help
>  	  Select to enable support for registering switches configured through SPI.
>  
> +config NET_DSA_MICROCHIP_KSZ_PTP
> +	bool "Support for the PTP clock on the KSZ9563/LAN937x Ethernet Switch"
> +	depends on NET_DSA_MICROCHIP_KSZ_COMMON && PTP_1588_CLOCK
> +	help
> +	  This enables support for timestamping & PTP clock manipulation

Please use "and" instead of "&".

> +	  in the KSZ9563/LAN937x Ethernet switch
> +
> +	  Select to enable support for PTP feature for KSZ9563/lan937x series

Please capitalize both KSZ9563 and LAN937X. This help text is the
business card of the feature, you need it to look nice and shiny.

Also, "for PTP feature for ..."? How about "enable PTP hardware
timestamping and clock manipulation support for ..."?

> +	  of switch.

switches

> +
>  config NET_DSA_MICROCHIP_KSZ8863_SMI
>  	tristate "KSZ series SMI connected switch driver"
>  	depends on NET_DSA_MICROCHIP_KSZ_COMMON
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> new file mode 100644
> index 000000000000..cad0c6087419
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -0,0 +1,270 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Microchip LAN937X PTP Implementation
> + * Copyright (C) 2021-2022 Microchip Technology Inc.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/ptp_classify.h>
> +#include <linux/ptp_clock_kernel.h>
> +
> +#include "ksz_common.h"
> +#include "ksz_ptp.h"
> +#include "ksz_ptp_reg.h"
> +
> +#define ptp_caps_to_data(d) \
> +		container_of((d), struct ksz_ptp_data, caps)
> +#define ptp_data_to_ksz_dev(d) \
> +		container_of((d), struct ksz_device, ptp_data)
> +
> +#define MAX_DRIFT_CORR 6250000

KSZ_MAX_DRIFT_CORR maybe? Also maybe a small comment about the
assumptions that were made when it was calculated?

> +
> +#define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
> +#define KSZ_PTP_SUBNS_BITS 32  /* Number of bits in sub-nanoseconds counter */
> +
> +/* The function is return back the capability of timestamping feature when
> + * requested through ethtool -T <interface> utility
> + */
> +int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
> +{
> +	struct ksz_device *dev	= ds->priv;
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +
> +	ts->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
> +			      SOF_TIMESTAMPING_RX_HARDWARE |
> +			      SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +	ts->tx_types = (1 << HWTSTAMP_TX_OFF);
> +
> +	ts->rx_filters = (1 << HWTSTAMP_FILTER_NONE);
> +
> +	ts->phc_index = ptp_clock_index(ptp_data->clock);

Ah, but I don't think the optionality of ptp_data->clock is dealt with
very well here. ptp_data->clock can be NULL, and ethtool -T can still be
run on the interface. That will dereference a NULL pointer in ptp_clock_index().

int ptp_clock_index(struct ptp_clock *ptp)
{
	return ptp->index;
}
EXPORT_SYMBOL(ptp_clock_index);

> +
> +	return 0;
> +}
> +
> +int ksz_ptp_clock_register(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +	int ret;
> +
> +	mutex_init(&ptp_data->lock);
> +
> +	ptp_data->caps = ksz_ptp_caps;
> +
> +	/* Start hardware counter */
> +	ret = ksz_ptp_start_clock(dev);
> +	if (ret)
> +		return ret;
> +
> +	/* Register the PTP Clock */
> +	ptp_data->clock = ptp_clock_register(&ptp_data->caps, dev->dev);
> +	if (IS_ERR_OR_NULL(ptp_data->clock))
> +		return PTR_ERR(ptp_data->clock);
> +
> +	ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_802_1AS, PTP_802_1AS);

A small comment as to what this does? I see in other places you're
generous with comments, like "Register the PTP clock" above the
ptp_clock_register() call.

> +	if (ret)
> +		goto error_unregister_clock;
> +
> +	return 0;
> +
> +error_unregister_clock:
> +	ptp_clock_unregister(ptp_data->clock);
> +	return ret;
> +}
> +
> +MODULE_AUTHOR("Christian Eggers <ceggers@arri.de>");
> +MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
> +MODULE_DESCRIPTION("PTP support for KSZ switch");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> new file mode 100644
> index 000000000000..ac53b0df2733
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -0,0 +1,43 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Microchip LAN937X PTP Implementation
> + * Copyright (C) 2020-2021 Microchip Technology Inc.
> + */
> +
> +#ifndef _NET_DSA_DRIVERS_KSZ_PTP_H
> +#define _NET_DSA_DRIVERS_KSZ_PTP_H
> +
> +#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
> +
> +#endif	/* End of CONFIG_NET_DSA_MICROCHIOP_KSZ_PTP */

MICROCHIP not MICROCHIOP

> +
> +#endif
