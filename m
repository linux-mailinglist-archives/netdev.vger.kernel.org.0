Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE682BBA26
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgKTX1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgKTX1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:27:47 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE485C0613CF;
        Fri, 20 Nov 2020 15:27:46 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cf17so7641807edb.2;
        Fri, 20 Nov 2020 15:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZWHu6K6eIbfVz7o/Qn5M1Z0BkYZs45FikhVIVbaDmHg=;
        b=toL7e2+fVyjtUOxZJBZkrYjtaJ8WLxenvWyFWxMMdNRcmvBMxvX1CSHg7A6mylfZzE
         akJwYFU4Ghmpsd43X+ov7RAHupUl5VltafGs4FpD13MMTkkVnPIDfARuQq9CKnWk/TWk
         cB0KBJHTbTS+CEsTxs4Q8nV9dJb0AyFWWQsdqG7LRjV590ObVkDPLNXN8hldGSiIzedo
         KpK6tY0VVdcaSvIBBTJZzMzfNEPa0YF3rW98PC4yUB28iQxbvZLj9RH7J6d8xNq7vuzZ
         /XOjmERczQXlXRSF0n3n08eNzZrq2UgA5zmM8wwmM9RFgGH963KS97eGdci5wk9lOhs5
         v34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZWHu6K6eIbfVz7o/Qn5M1Z0BkYZs45FikhVIVbaDmHg=;
        b=HJ4A8F94j7imS+ZU15RRPMX0lThXOQe55Njx18eGYCjZsb2rXAcFD0xksyoKcJjH3E
         vdqTCl2WleuQvSj4uHr2GTWWZa4U5mOs05V+OXWzFIRBSO2Pxnwj0Tg5hJ3cYQq6UGVq
         E5pdZ1QOmFOnWPGZ/GGrhu/ZcN3smgaPz0GeRvX1zmHm1KkCMoXjlmH9nUp05Qdn95fI
         lQhMzD8TdEsQbC/srRzAgdh6AdFXDfo3aEkzZuRv7yPDWwSzlQLwBm9PCCuLmww0Oc2C
         ixfmhdVLxZRzlpatDgl3g9vq6wB5OH0x7h6/rNI0RtcM8f0CMM9mvfrBr1leNVElVnQx
         JX5w==
X-Gm-Message-State: AOAM53139j75tAxz7PF3JzqvgGxxVYOHHLCOBJXT5zOCnF2FMN/wTvst
        w0SqifauP9/Sul8X8bSIEZ8=
X-Google-Smtp-Source: ABdhPJyeve3i+YaNN5lcw9znh7snQzWVytSvS9vubjqMXUTSvCEgvWC+t/K58JW61Cpi2ds12cLdfg==
X-Received: by 2002:aa7:ca57:: with SMTP id j23mr14107834edt.292.1605914865588;
        Fri, 20 Nov 2020 15:27:45 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f19sm1646746ejk.116.2020.11.20.15.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 15:27:44 -0800 (PST)
Date:   Sat, 21 Nov 2020 01:27:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 09/12] net: dsa: microchip: ksz9477: initial
 hardware time stamping support
Message-ID: <20201120232742.hhmmf3ok6a7xnoqw@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-10-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-10-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:10PM +0100, Christian Eggers wrote:
> Add control routines required for TX hardware time stamping.
> 
> The KSZ9563 only supports one step time stamping
> (HWTSTAMP_TX_ONESTEP_P2P), which requires linuxptp-2.0 or later.
> 
> Currently, only P2P delay measurement is supported. See patchwork
> discussion and comments in ksz9477_ptp_init() for details:
> https://patchwork.ozlabs.org/project/netdev/patch/20201019172435.4416-8-ceggers@arri.de/
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +static int ksz9477_set_hwtstamp_config(struct ksz_device *dev, int port,
> +				       struct hwtstamp_config *config)
> +{
> +	struct ksz_port *prt = &dev->ports[port];
> +
> +	/* reserved for future extensions */
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +		prt->hwts_tx_en = false;
> +		break;
> +	case HWTSTAMP_TX_ONESTEP_P2P:
> +		prt->hwts_tx_en = true;
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
> +	case HWTSTAMP_FILTER_ALL:

Putting anything in the same "case" statement as "default" is useless.

> +	default:
> +		config->rx_filter = HWTSTAMP_FILTER_NONE;
> +		return -ERANGE;
> +	}
> +
> +	return 0;
> +}
