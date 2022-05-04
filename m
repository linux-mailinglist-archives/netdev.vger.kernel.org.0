Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F62B51A4D4
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353031AbiEDQEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353029AbiEDQEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:04:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB10140B9;
        Wed,  4 May 2022 09:00:44 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kq17so3775424ejb.4;
        Wed, 04 May 2022 09:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7awA0bhXiTCjNunFCEETGG9Bcn0OfJeCoWQDr77CgaE=;
        b=cR4//CFn8Wr1Xk8QUiZX8GfoexjW2U1QZBi6tvrogakwmt1uM2On/aG4K9WFfIW5kl
         YbmxNJmRsY2EQmf0axm9Nz4cYttnk0DmrbFaDfq15mIQg63RckyifFXR5KHHt+2CdWPV
         XZYQRUOm0FiMgdq/p6vsLE/UulQ69eRkuX4V8icVtDV19PChozGd49EFqd/xgf9PL5v8
         3MXip7ypAcbLGdM/Ka1BtQHH3oXl7Efl0y0zX/GXbCjZkr/E3hH+U4Z97NkWKtABNlp2
         +l6cmEbVE4BAZpf14+XWP5atmxkjtpQ6S8m3fB+yCXR0LZ7JFTlgMOFqi7qpnlPVwYDD
         7pDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7awA0bhXiTCjNunFCEETGG9Bcn0OfJeCoWQDr77CgaE=;
        b=tlw4YOSadE1jgBKb2P0yvt2R31zNEIIKUMFOml3W9DQ+C+giPq8jIeqHpYX3nznBXH
         laTG433Z6hkMpZXmQ1UkL+7r7KhdpbijnRHdG6xSR0VqkeUisqeohEr04jKWepb1Nb2j
         5vL9ADPMKBtGsWs+a9JSok/4aIljGGpZ06qXzuiT/qLr+ORjJDYz+rcDkSD5gbRa24ab
         8fqSy8xX4vIJ6FYU6AzDHm7KzwGLOhghlvhBeQu9KKVW1XTOSwpX/1EJ/8aiDLlh4Uh0
         jrqmrDt8f+U0dl17uHVyg0Ouex/zayV3LIsWt2DznafeBS9kQR+w9ysF21/DZt3UFz3q
         nWAw==
X-Gm-Message-State: AOAM533Yi+11uJ6ROPAxO3n4kPgvQNh4AO3hCsSVoaJUnTQgzFZYIS/P
        MeVdb1oNOAZQHky5OXvhwGU=
X-Google-Smtp-Source: ABdhPJyi3Y8DqVoQchdj1SwKFvmJF7/Po25n8HfLgMwVB7ETed37aAeeRuO979lJNWezFUiddA7Ngw==
X-Received: by 2002:a17:906:7d5:b0:6f3:a6a5:28c6 with SMTP id m21-20020a17090607d500b006f3a6a528c6mr21028462ejc.11.1651680042820;
        Wed, 04 May 2022 09:00:42 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id g3-20020a50ee03000000b0042617ba63acsm9417754eds.54.2022.05.04.09.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:00:42 -0700 (PDT)
Date:   Wed, 4 May 2022 19:00:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220504160039.5viu3cqd5zbmo6n2@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
 <20220504093000.132579-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504093000.132579-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 11:29:50AM +0200, Clément Léger wrote:
> The switch that is present on the Renesas RZ/N1 SoC uses a specific
> VLAN value followed by 6 bytes which contains forwarding configuration.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  include/net/dsa.h        |   2 +
>  net/dsa/Kconfig          |   7 +++
>  net/dsa/Makefile         |   1 +
>  net/dsa/tag_rzn1_a5psw.c | 114 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 124 insertions(+)
>  create mode 100644 net/dsa/tag_rzn1_a5psw.c
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index d9da32aacbf1..9aaaa7deb102 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -53,6 +53,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_SJA1110_VALUE		23
>  #define DSA_TAG_PROTO_RTL8_4_VALUE		24
>  #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
> +#define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -81,6 +82,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
>  	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
>  	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
> +	DSA_TAG_PROTO_RZN1_A5PSW	= DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
>  };
>  
>  struct dsa_switch;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 8cb87b5067ee..e22f33d7cf60 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -132,6 +132,13 @@ config NET_DSA_TAG_RTL8_4
>  	  Say Y or M if you want to enable support for tagging frames for Realtek
>  	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
>  
> +config NET_DSA_TAG_RZN1_A5PSW
> +	tristate "Tag driver for Renesas RZ/N1 A5PSW switch"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for
> +	  Renesas RZ/N1 embedded switch that uses a 8 byte tag located after

"an" 8 byte tag

> +	  destination MAC address.
> +
>  config NET_DSA_TAG_LAN9303
>  	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
>  	help
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 9f75820e7c98..af28c24ead18 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
>  obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
> +obj-$(CONFIG_NET_DSA_TAG_RZN1_A5PSW) += tag_rzn1_a5psw.o
>  obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
>  obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
>  obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
> diff --git a/net/dsa/tag_rzn1_a5psw.c b/net/dsa/tag_rzn1_a5psw.c
> new file mode 100644
> index 000000000000..87177682eb54
> --- /dev/null
> +++ b/net/dsa/tag_rzn1_a5psw.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Schneider Electric
> + *
> + * Clément Léger <clement.leger@bootlin.com>
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/etherdevice.h>
> +#include <net/dsa.h>
> +
> +#include "dsa_priv.h"
> +
> +/* To define the outgoing port and to discover the incoming port a TAG is
> + * inserted after Src MAC :
> + *
> + *       Dest MAC       Src MAC           TAG         Type
> + * ...| 1 2 3 4 5 6 | 1 2 3 4 5 6 | 1 2 3 4 5 6 7 8 | 1 2 |...
> + *                                |<--------------->|
> + *
> + * See struct a5psw_tag for layout
> + */
> +
> +#define A5PSW_TAG_VALUE			0xE001

Maybe an ETH_P_DSA_A5PSW definition in include/uapi/linux/if_ether.h
would be appropriate? I'm not sure.

> +#define A5PSW_TAG_LEN			8
> +#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
> +/* This is both used for xmit tag and rcv tagging */
> +#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
> +
> +struct a5psw_tag {
> +	__be16 ctrl_tag;
> +	__be16 ctrl_data;
> +	__be16 ctrl_data2_hi;
> +	__be16 ctrl_data2_lo;
> +};
> +
> +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct a5psw_tag *ptag;
> +	u32 data2_val;
> +
> +	BUILD_BUG_ON(sizeof(*ptag) != A5PSW_TAG_LEN);
> +
> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise they will be discarded when
> +	 * they enter the switch port logic. When tagging is enabled, we need
> +	 * to make sure that packets are at least 70 bytes (including FCS and
> +	 * tag).
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + ETH_FCS_LEN + A5PSW_TAG_LEN, false))
> +		return NULL;

I'm confused by the inclusion of the FCS length in this calculation,
since the FCS space isn't present in the skb buffer as far as I know?

"64 bytes including FCS" means "60 bytes excluding FCS".
And ETH_ZLEN is 60...

And I'm also not sure how we got to the number 70? A5PSW_TAG_LEN is 8.
If we add it to 60 we get 68. If we add it to 64 we get 72?

> +
> +	/* provide 'A5PSW_TAG_LEN' bytes additional space */
> +	skb_push(skb, A5PSW_TAG_LEN);
> +
> +	/* make room between MACs and Ether-Type to insert tag */
> +	dsa_alloc_etype_header(skb, A5PSW_TAG_LEN);
> +
> +	ptag = dsa_etype_header_pos_tx(skb);
> +
> +	data2_val = FIELD_PREP(A5PSW_CTRL_DATA_PORT, BIT(dp->index));
> +	ptag->ctrl_tag = htons(A5PSW_TAG_VALUE);
> +	ptag->ctrl_data = htons(A5PSW_CTRL_DATA_FORCE_FORWARD);
> +	ptag->ctrl_data2_lo = htons(data2_val);
> +	ptag->ctrl_data2_hi = 0;
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *a5psw_tag_rcv(struct sk_buff *skb,
> +				     struct net_device *dev)
> +{
> +	struct a5psw_tag *tag;
> +	int port;
> +
> +	if (unlikely(!pskb_may_pull(skb, A5PSW_TAG_LEN))) {
> +		dev_warn_ratelimited(&dev->dev,
> +				     "Dropping packet, cannot pull\n");
> +		return NULL;
> +	}
> +
> +	tag = dsa_etype_header_pos_rx(skb);
> +
> +	if (tag->ctrl_tag != htons(A5PSW_TAG_VALUE)) {
> +		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid TAG marker\n");
> +		return NULL;
> +	}
> +
> +	port = FIELD_GET(A5PSW_CTRL_DATA_PORT, ntohs(tag->ctrl_data));
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> +	if (!skb->dev)
> +		return NULL;
> +
> +	skb_pull_rcsum(skb, A5PSW_TAG_LEN);
> +	dsa_strip_etype_header(skb, A5PSW_TAG_LEN);
> +
> +	dsa_default_offload_fwd_mark(skb);
> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops a5psw_netdev_ops = {
> +	.name	= "a5psw",
> +	.proto	= DSA_TAG_PROTO_RZN1_A5PSW,
> +	.xmit	= a5psw_tag_xmit,
> +	.rcv	= a5psw_tag_rcv,
> +	.needed_headroom = A5PSW_TAG_LEN,
> +};
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_A5PSW);
> +module_dsa_tag_driver(a5psw_netdev_ops);
> -- 
> 2.34.1
> 

