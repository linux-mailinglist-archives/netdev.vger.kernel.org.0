Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA25016C0
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbiDNPL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351976AbiDNObn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:31:43 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4174A65791;
        Thu, 14 Apr 2022 07:22:47 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 11so1544440edw.0;
        Thu, 14 Apr 2022 07:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=heFvQj/KQfWX07hpf8N3+R5HqEpO3+LdKhdpVRJ7JZI=;
        b=ASJIKR8m9z8Fgz72CC4XRZxSdGIq6DqcPkicQX3+RMrUNV7Y2SBiUqmP6YAMhsO1fY
         z67pYMaMjTFRVghbDwaa8APeNtysZk1TITSRUrHUwlCdspqtBtnW4Dk050TzjiD7voNN
         NO+ECT3apjW1Bgyfoc/0YkIu6OSgMWGUQyi+wmPeqHIaLUuJN/mIZ7FKx09QgeVUZ3tH
         vnb4o8jm6UTooeOQLn07r3eJ+qQzde+DKFSGt+KDUeTmlXVvA2pon2aM8MbMUcuukblb
         uBjmC9/GXYcvHPmlSft8HQNRu1OF96+4/b2xtG42Wzpj9FmzeIW8dW72wuxk95INqzyt
         XRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=heFvQj/KQfWX07hpf8N3+R5HqEpO3+LdKhdpVRJ7JZI=;
        b=g6IExwmF4z0V5Kp+9T/zwgITQhTiO+qoDneDYoBrSqiTNacVS9CRM9cF5x7JX/Hr7L
         EWCuOZOCp85+7DQJu7ofSuijUTR2DX/HJEqnNBRropeuULwvJqJNEPtF3SL3rvV+QDcJ
         ehEFlvr4WO50h7kDBe8OZC8V3gAZrE8n3A/K9pGFAuea3ypcwx6PEBcozgeTwgtUz6Bu
         WB2swx2h2InqU3IU+tGJm+sgbJf64q9y0Wrx32cbn0OCEekbbOfjdwi/TWuGbLF00glk
         7WIeErK5ug2UnbD5SZ7zpXsE68PO6UMQ7l5KdUk1YPqfVLLUCrsJbHuQcqr7NxTMda4N
         eu1Q==
X-Gm-Message-State: AOAM5322F1B4BFOLTj3A7RAMxq43vx/PbfdrM0JCY9V2NjZ6hgHj4gte
        XEuzTmt76Uj1CUOJq/XuMHU=
X-Google-Smtp-Source: ABdhPJyFJG/Cc77Ap69mBJ+oiJ+sHo8gzYk+1SALroyx1j6aYEH+EjU3gSz7w37Oitf/S0uYdDyZ/A==
X-Received: by 2002:a50:d592:0:b0:41d:6bae:bd36 with SMTP id v18-20020a50d592000000b0041d6baebd36mr3214981edi.221.1649946165346;
        Thu, 14 Apr 2022 07:22:45 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id i20-20020aa7c714000000b0041fbd14c34bsm1061468edq.4.2022.04.14.07.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:22:44 -0700 (PDT)
Date:   Thu, 14 Apr 2022 17:22:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220414142242.vsvv3vxexc7i3ukm@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:40PM +0200, Clément Léger wrote:
> The switch that is present on the Renesas RZ/N1 SoC uses a specific
> VLAN value followed by 6 bytes which contains forwarding configuration.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  net/dsa/Kconfig          |   8 +++
>  net/dsa/Makefile         |   1 +
>  net/dsa/tag_rzn1_a5psw.c | 112 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 121 insertions(+)
>  create mode 100644 net/dsa/tag_rzn1_a5psw.c
> 
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 8cb87b5067ee..e5b17108fa22 100644
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
> +	  destination MAC address.
> +
>  config NET_DSA_TAG_LAN9303
>  	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
>  	help
> @@ -159,4 +166,5 @@ config NET_DSA_TAG_XRS700X
>  	  Say Y or M if you want to enable support for tagging frames for
>  	  Arrow SpeedChips XRS700x switches that use a single byte tag trailer.
>  
> +

Stray change.

>  endif
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
> index 000000000000..7818c1c0fca2
> --- /dev/null
> +++ b/net/dsa/tag_rzn1_a5psw.c
> @@ -0,0 +1,112 @@
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
> +#define A5PSW_TAG_LEN			8
> +#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
> +/* This is both used for xmit tag and rcv tagging */
> +#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
> +
> +struct a5psw_tag {

This needs to be packed.

> +	u16 ctrl_tag;
> +	u16 ctrl_data;

These need to be __be16.

> +	u32 ctrl_data2;

This needs to be __be32.

> +};
> +
> +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct a5psw_tag *ptag, tag = {0};
> +	struct dsa_port *dp = dsa_slave_to_port(dev);

Please keep variable declarations sorted in decreasing order of line
length (applies throughout the patch series, I won't repeat this comment).

> +	u32 data2_val;
> +
> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise they will be discarded when
> +	 * they enter the switch port logic. When tagging is enabled, we need
> +	 * to make sure that packets are at least 68 bytes (including FCS and
> +	 * tag).
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + sizeof(tag), false))
> +		return NULL;
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
> +	tag.ctrl_tag = htons(A5PSW_TAG_VALUE);
> +	tag.ctrl_data = htons(A5PSW_CTRL_DATA_FORCE_FORWARD);
> +	tag.ctrl_data2 = htonl(data2_val);
> +
> +	memcpy(ptag, &tag, sizeof(struct a5psw_tag));

sizeof(tag), to be consistent with the other use of sizeof() above?
Although, hmm, I think you could get away with editing "ptag" in place.

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

