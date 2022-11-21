Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6863308F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 00:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiKUXNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 18:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKUXNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 18:13:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A69EC5B4B;
        Mon, 21 Nov 2022 15:13:19 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b8so7557431edf.11;
        Mon, 21 Nov 2022 15:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CykOkRemH/roTrEIIffpSd1XkgWDGuppCGGueEqDGWA=;
        b=Gl/mJ8k/quImoueaUH5m15K6zL72j8qZnR8RITM7cVRVHdDKquqr9v53+7/R0mfgCL
         GTNM9czrgtrTWvGqSxlsH2gC85cRnfDxcydg/PAD4FasG362FCGCI/AwL69+PhifMetP
         PMsqaYeAXfmPrNHdPvaXaN9Y3xWi6mw4KlAaOsW6bHHa+wPPmnT18Jg1BMPvFzTQDF/O
         l0Pn7zWhhZUTn8Ym1AKVGwnNT8PrCnExgmhv4PPEgEOIl4l22v5B2E+/pTQjJCWVjnsY
         AkE3megsMez9ZLU1jj88ptl1y91+PYWVmxTc0hkPjpl0b5D+39KFee0MMJ3vHq61FRuk
         AeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CykOkRemH/roTrEIIffpSd1XkgWDGuppCGGueEqDGWA=;
        b=bDdEo8bPQMeUK9dlUgQag0lTyc/krZXyhdt9sQh+8DFvlFxxMx3KQxszMiV5DG/Uq1
         rY8SbEq6hsc331gmTN6gLOk2K4qHRIDaFd9FDXAb+xTTQMwj/+SRaJBIY+/ueDk9jS7t
         CBsHXUt7yy34qdfvVqPa7v1KLL6LgK/ROBloDh56dZ9uhu1fwXJJ25ZHM7XXDooxDJNA
         OXxSRdJGPo5uEPc4Z7oWLqmoGMqq6+cIDW/9B52llN8ZMAXNWG+EaltAlod+lrXISZs8
         8oMRK3iMPMF2l8LY3pgBN9fmuNLF+xvZwxIiybVRwic16TdwTvSLfeniXQ1ENUi+bEFI
         7IPg==
X-Gm-Message-State: ANoB5plq1S/bSbaNiTE+Zah/GrtnyPF0P09PvI9HniSYu7ltqOZ0pGpr
        JmztmeRt+uxll2T6IpRaibE=
X-Google-Smtp-Source: AA0mqf7RNtVsQTUm67vGiEsV810K/fF5msaUubevLSO1lOQ5+z/pycPv+VYaMLel0DdcZJJcEqCu7w==
X-Received: by 2002:a05:6402:4286:b0:458:7489:34ea with SMTP id g6-20020a056402428600b00458748934eamr4813395edc.264.1669072397786;
        Mon, 21 Nov 2022 15:13:17 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id fi13-20020a056402550d00b004580862ffdbsm5702696edb.59.2022.11.21.15.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 15:13:17 -0800 (PST)
Date:   Tue, 22 Nov 2022 01:13:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Message-ID: <20221121231314.kabhej6ae6bl3qtj@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:11:45PM +0530, Arun Ramadoss wrote:
> +static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
> +{
> +	u16 data = 0;
> +
> +	/* Enable PTP mode */
> +	if (enable)
> +		data = PTP_ENABLE;
> +
> +	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE, data);
> +}
> +
> +static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
> +				   struct hwtstamp_config *config)
> +{
> +	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
> +	struct ksz_port *prt = &dev->ports[port];
> +	bool rx_on;
> +
> +	/* reserved for future extensions */
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +	case HWTSTAMP_TX_ONESTEP_P2P:
> +		prt->hwts_tx_en = config->tx_type;
> +		break;
> +	case HWTSTAMP_TX_ON:
> +		if (!is_lan937x(dev))
> +			return -ERANGE;
> +
> +		prt->hwts_tx_en = config->tx_type;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config->rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		rx_on = false;
> +		break;
> +	default:
> +		rx_on = true;
> +		break;
> +	}
> +
> +	if (rx_on != tagger_data->hwtstamp_get_state(dev->ds)) {
> +		int ret;
> +
> +		tagger_data->hwtstamp_set_state(dev->ds, false);
> +
> +		ret = ksz_ptp_enable_mode(dev, rx_on);
> +		if (ret)
> +			return ret;
> +
> +		if (rx_on)
> +			tagger_data->hwtstamp_set_state(dev->ds, true);
> +	}

What's your excuse which such a horrible code pattern? What will happen
so bad with the packet if it's flagged with a TX timestamp request in
KSZ_SKB_CB(skb) at the same time as REG_PTP_MSG_CONF1 is written to?

Also, doesn't dev->ports[port].hwts_tx_en serve as a guard against
flagging packets for TX timestamps when you shouldn't?

> +
> +	return 0;
> +}
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 37db5156f9a3..6a909a300c13 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -4,6 +4,7 @@
>   * Copyright (c) 2017 Microchip Technology
>   */
>  
> +#include <linux/dsa/ksz_common.h>
>  #include <linux/etherdevice.h>
>  #include <linux/list.h>
>  #include <net/dsa.h>
> @@ -18,6 +19,62 @@
>  #define KSZ_EGRESS_TAG_LEN		1
>  #define KSZ_INGRESS_TAG_LEN		1
>  
> +#define KSZ_HWTS_EN  0
> +
> +struct ksz_tagger_private {
> +	struct ksz_tagger_data data; /* Must be first */
> +	unsigned long state;
> +};
> +
> +static struct ksz_tagger_private *
> +ksz_tagger_private(struct dsa_switch *ds)
> +{
> +	return ds->tagger_data;
> +}
> +
> +static bool ksz_hwtstamp_get_state(struct dsa_switch *ds)
> +{
> +	struct ksz_tagger_private *priv = ksz_tagger_private(ds);
> +
> +	return test_bit(KSZ_HWTS_EN, &priv->state);
> +}
> +
> +static void ksz_hwtstamp_set_state(struct dsa_switch *ds, bool on)
> +{
> +	struct ksz_tagger_private *priv = ksz_tagger_private(ds);
> +
> +	if (on)
> +		set_bit(KSZ_HWTS_EN, &priv->state);
> +	else
> +		clear_bit(KSZ_HWTS_EN, &priv->state);
> +}
