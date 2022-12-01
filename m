Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C58363E6B8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiLAAxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLAAw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:52:59 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AA610BE;
        Wed, 30 Nov 2022 16:52:58 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ud5so623032ejc.4;
        Wed, 30 Nov 2022 16:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPAL+qEpybMK4gfRSDNZ/UBJjmcxXUSe2Ph04k04WIQ=;
        b=i1dlhWy9+GVO4JnGeCB/BanMnidxHyipiPNGdCbKOW2Z/6pPYBAwWnt6rez2QStMd7
         iq5hlwhdnJI/2XQwvRCszjjAFj8P5+uMTusnDR0fhwMFWtvIZih22zuvcQpAJhGlRiQX
         xPEzADssos1w8P3mPwZQPhvSj5PMVi6ei5u3ZIBOLLlNr/w8lD42/pk7vZWi/TnPODjb
         +GBnOB+kl3P0F6iuwMF2SjnhvBTVM913XdJQP8kEESqGy5GNYhAiV1ypcJG95BKSenQi
         2sl5kzaOup0naBUaf3E3Q1TqRrjFH3eQ4hInaDEFL42DfibSaRsYzjMzWXk6y7ek6Wwd
         lHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZPAL+qEpybMK4gfRSDNZ/UBJjmcxXUSe2Ph04k04WIQ=;
        b=IbSLszFqzcO9rxPItPg2XJt7E/frVokxTVzPhQxYW/soyLkAAxOQbO9DWc4214cp/6
         4b0P0zD4Wm4/JfdFYeVcP0H/cplT5j98EDqBH/aEOU3UnxNXyfdYNTrlrFawbnyed2Zp
         DXY2j1R0c3OkeRCVcF/zPuxNEbMloKcX4mhOObBlqOpv474Eqiopax7UvcFRVHcEg38j
         nChGwEhDusGfPbeI9mYKvX6BWxrUbuXOcgS28tUZ0Gi770wxUGsXD22pv7siEjp640ru
         E0zjPifo6U34tHT4KbKlLnm1CKlFI4U/8SJfAei5BpZL4nbD6x0LSB4POsIaDKl+mHW5
         aEdA==
X-Gm-Message-State: ANoB5pkFkHakJYXs0IHTaPAG3PE8OwI+kpdqdaZr5/G6Ty4KxiuP/0VQ
        p+HgZ7nenrr7/ffrouwHuzU=
X-Google-Smtp-Source: AA0mqf7mNFLsTDtQkPZEhfPSuoiCvjyoSviXSHqAwhU5aUgTWTYVQB49I+T9PMyjIDMT/u9TxtoIkw==
X-Received: by 2002:a17:906:3e13:b0:78d:502c:aeb5 with SMTP id k19-20020a1709063e1300b0078d502caeb5mr38614715eji.88.1669855976965;
        Wed, 30 Nov 2022 16:52:56 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id p23-20020aa7d317000000b00461cdda400esm1179973edq.4.2022.11.30.16.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 16:52:56 -0800 (PST)
Date:   Thu, 1 Dec 2022 02:52:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v1 03/12] net: dsa: microchip: ptp: add 4 bytes
 in tail tag when ptp enabled
Message-ID: <20221201005254.lcwwtscmdu6scnpv@skbuf>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-4-arun.ramadoss@microchip.com>
 <20221128103227.23171-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128103227.23171-4-arun.ramadoss@microchip.com>
 <20221128103227.23171-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 04:02:18PM +0530, Arun Ramadoss wrote:
> If PTP is enabled in the hardware, then 4 bytes are added in the tail
> tag. When PTP is enabled and 4 bytes are not added then messages are
> corrupted.

Comment in the code please. Also, please spell it out explicitly that
the tail tag size changes for all TX packets, PTP or not, if PTP
timestamping is enabled. Your phrasing can be unclear and the reader may
think that only PTP packets require a larger tail tag.

> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index cd20f39a565f..4c5b35a7883c 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -105,7 +105,6 @@ struct ksz_port {
>  	u8 num;
>  #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
>  	u8 hwts_tx_en;
> -	bool hwts_rx_en;

>  #endif
>  };
>  
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index a41418c6adf6..184aa57a8489 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -54,7 +66,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
>  
>  	config.tx_type = dev->ports[port].hwts_tx_en;
>  
> -	if (dev->ports[port].hwts_rx_en)
> +	if (tagger_data->hwtstamp_get_state(ds))

Let's be clear, hwtstamp_get_state() deals with TX timestamping, and
config.rx_filter deals with RX timestamping. Don't mix the two.
Using custom programs like testptp, you can enable RX timestamping but
not TX timestamping, or the other way around. You don't want the driver
to get confused.

>  		config.rx_filter = HWTSTAMP_FILTER_ALL;

Can the switch provide RX timestamps for all kinds of Ethernet packets,
not just PTP? If not, then report just what it can timestamp.

>  	else
>  		config.rx_filter = HWTSTAMP_FILTER_NONE;
>  int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 0f6ae143afc9..828af38f0598 100644
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
> @@ -16,9 +17,66 @@
>  #define LAN937X_NAME "lan937x"
>  
>  /* Typically only one byte is used for tail tag. */
> +#define KSZ_PTP_TAG_LEN			4
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

As discussed, I don't really think there exists a case for hwtstamp_get_state().
Don't abuse the tagger-owned storage.

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
> +
> +static void ksz_disconnect(struct dsa_switch *ds)
> +{
> +	struct ksz_tagger_private *priv = ds->tagger_data;
> +
> +	kfree(priv);
> +	ds->tagger_data = NULL;
> +}
> +
> +static int ksz_connect(struct dsa_switch *ds)
> +{
> +	struct ksz_tagger_data *tagger_data;
> +	struct ksz_tagger_private *priv;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	/* Export functions for switch driver use */
> +	tagger_data = &priv->data;
> +	tagger_data->hwtstamp_get_state = ksz_hwtstamp_get_state;
> +	tagger_data->hwtstamp_set_state = ksz_hwtstamp_set_state;
> +	ds->tagger_data = priv;
> +
> +	return 0;
> +}
> +
>  static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
>  				      struct net_device *dev,
>  				      unsigned int port, unsigned int len)
> @@ -91,10 +149,11 @@ DSA_TAG_DRIVER(ksz8795_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
>  
>  /*
> - * For Ingress (Host -> KSZ9477), 2 bytes are added before FCS.
> + * For Ingress (Host -> KSZ9477), 2/6 bytes are added before FCS.
>   * ---------------------------------------------------------------------------
> - * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
>   * ---------------------------------------------------------------------------
> + * ts   : time stamp (Present only if PTP is enabled in the Hardware)
>   * tag0 : Prioritization (not used now)
>   * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x10=port5)
>   *
> @@ -113,6 +172,19 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
>  #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
>  #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
>  
> +/* Time stamp tag is only inserted if PTP is enabled in hardware. */

Stronger. Time stamp tag *needs* to be inserted if PTP is enabled in hardware.
Regardless of whether this is a PTP frame or not.

I think you don't think this is confusing. But it is confusing.
2 years from now, when this patch gets submitted again for being merged,
I don't want to ask the same questions again.

> +static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
> +{
> +	struct ksz_tagger_private *priv;
> +
> +	priv = ksz_tagger_private(dp->ds);
> +
> +	if (!test_bit(KSZ_HWTS_EN, &priv->state))
> +		return;
> +
> +	put_unaligned_be32(0, skb_put(skb, KSZ_PTP_TAG_LEN));
> +}
