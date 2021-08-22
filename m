Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C303F41DE
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 00:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhHVWNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 18:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhHVWNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 18:13:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965ABC061575;
        Sun, 22 Aug 2021 15:13:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id q3so23215622edt.5;
        Sun, 22 Aug 2021 15:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/XQvuZD+5maSCE51QfZzJ2Vc/Zt2chaou4/nvyzXi58=;
        b=ZGyyyPJsXrovBM4jchmttJC1I/sC6mJahtDEpXcWykV8O+3v3StAgepoUTEtGfglJM
         L4l5scS2L5ONPjUOHkgZkSmiN44+LX9YPtaP2jebLiwaMZW0HvJ/ZikForCDICC/hQvd
         hS8KdnJ5AlOyr8f/TcqylMmRbANNRy5fWFYLv3TFs9sPK7FxQ6DTAeeT47XJBXpmd2Oj
         4OhpK4WpExiLHsHvby2CQiRH5vZUE3Uc1buYZSFsS4JLXrzvZzEfNl2/JvMBAHvJs8Hd
         R4Ih1wkuI6/Y+EP1YnZn35tw8jqD6ldZ3KQ92JkoQHIuqLu8ZdFN+sbYmOhAyS2YLTVV
         rBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/XQvuZD+5maSCE51QfZzJ2Vc/Zt2chaou4/nvyzXi58=;
        b=ZvdBsoiQinrPePm8GluEZZZKGzIIk9+4LcqcNVOLleq0UFqEstnaKX4GLhiZMApA4y
         gThe1L3wGzhHn712ciJqSKLGCJss+x8vEOWJ6WyctmoI16PVmkDVorWsP9q5d14R7CJT
         /k78+Yxe1eVrhVdjfOedX+nyzjbxyurehk7QZMr3SRCKHyElcox5BbQqrsdO8dB9/KPl
         Sx7QHgCYEmsBACMtxSjgIiu0vuwtnNLavX4gGxzMJCFMvDecpf4jiCIGAfJWmhkeS/Db
         l6Lw/H4iB/6Tk4pOb5QpPiRdvFXLK23N0Ow8Wq7Jzsfkgq99XsMIyaUbYu92RrTUM9a/
         miBA==
X-Gm-Message-State: AOAM5308Bw1rhCeYI4FwYVcsxxTVTR6994IHGhYb3k8jNCO+QS2XJA0V
        39jUkEN8nnaLDaFSftSvL+g=
X-Google-Smtp-Source: ABdhPJwBvu1w+pQPigP8XBB+bmAjYSDurb/DJ1aD7hb8j8atpCOU5KrErN3TVltX93WtMLVivQYZQg==
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr33691288edc.374.1629670389044;
        Sun, 22 Aug 2021 15:13:09 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id bx14sm3418443edb.93.2021.08.22.15.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 15:13:08 -0700 (PDT)
Date:   Mon, 23 Aug 2021 01:13:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Message-ID: <20210822221307.mh4bggohdvx2yehy@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-4-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:41PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This commit implements a basic version of the 8 byte tag protocol used
> in the Realtek RTL8365MB-VC switch, which carries with it a protocol
> version of 0x04.
> 
> The implementation itself only handles the parsing of the EtherType
> value and Realtek protocol version, together with the source or
> destination port fields. The rest is left unimplemented for now.
> 
> The tag format is described in a confidential document provided to my
> employer - Bang & Olufsen a/s - by Realtek Semiconductor Corp.
> Permission has been granted by Realtek to publish this driver based on
> that material, together with an extract from the document describing the
> tag format and its fields.  It is hoped that this will help future
> implementors who do not have access to the material but who wish to
> extend the functionality of drivers for chips which use this protocol.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  include/net/dsa.h    |   2 +
>  net/dsa/Kconfig      |   6 ++
>  net/dsa/Makefile     |   1 +
>  net/dsa/tag_rtl8_4.c | 178 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 187 insertions(+)
>  create mode 100644 net/dsa/tag_rtl8_4.c
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 0c2cba45fa79..6d8b5a11d99a 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -51,6 +51,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_SEVILLE_VALUE		21
>  #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
>  #define DSA_TAG_PROTO_SJA1110_VALUE		23
> +#define DSA_TAG_PROTO_RTL8_4_VALUE		24
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -77,6 +78,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
>  	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
>  	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
> +	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
>  };
>  
>  struct dsa_switch;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 548285539752..470a2f3e8f75 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -99,6 +99,12 @@ config NET_DSA_TAG_RTL4_A
>  	  Realtek switches with 4 byte protocol A tags, sich as found in
>  	  the Realtek RTL8366RB.
>  
> +config NET_DSA_TAG_RTL8_4
> +	tristate "Tag driver for Realtek 8 byte protocol 4 tags"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for Realtek
> +	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
> +
>  config NET_DSA_TAG_OCELOT
>  	tristate "Tag driver for Ocelot family of switches, using NPI port"
>  	depends on MSCC_OCELOT_SWITCH_LIB || \
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 67ea009f242c..01282817e80e 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
> +obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
>  obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
> diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> new file mode 100644
> index 000000000000..1082bafb6a2e
> --- /dev/null
> +++ b/net/dsa/tag_rtl8_4.c
> @@ -0,0 +1,178 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Handler for Realtek 8 byte switch tags
> + *
> + * Copyright (C) 2021 Alvin Šipraga <alsi@bang-olufsen.dk>
> + *
> + * NOTE: Currently only supports protocol "4" found in the RTL8365MB, hence
> + * named tag_rtl8_4.
> + *
> + * This "proprietary tag" header has the following format:
> + *
> + *  -------------------------------------------
> + *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> + *  -------------------------------------------
> + *     _______________/            \______________________________________
> + *    /                                                                   \
> + *  0                                  7|8                                 15
> + *  |-----------------------------------+-----------------------------------|---
> + *  |                               (16-bit)                                | ^
> + *  |                       Realtek EtherType [0x8899]                      | |
> + *  |-----------------------------------+-----------------------------------| 8
> + *  |              (8-bit)              |              (8-bit)              |
> + *  |          Protocol [0x04]          |              REASON               | b
> + *  |-----------------------------------+-----------------------------------| y
> + *  |   (1)  | (1) | (2) |   (1)  | (3) | (1)  | (1) |    (1)    |   (5)    | t
> + *  | FID_EN |  X  | FID | PRI_EN | PRI | KEEP |  X  | LEARN_DIS |    X     | e
> + *  |-----------------------------------+-----------------------------------| s
> + *  |   (1)  |                       (15-bit)                               | |
> + *  |  ALLOW |                        TX/RX                                 | v
> + *  |-----------------------------------+-----------------------------------|---
> + *
> + * With the following field descriptions:
> + *
> + *    field      | description
> + *   ------------+-------------
> + *    Realtek    | 0x8899: indicates that this is a proprietary Realtek tag;
> + *     EtherType |         note that Realtek uses the same EtherType for
> + *               |         other incompatible tag formats (e.g. tag_rtl4_a.c)
> + *    Protocol   | 0x04: indicates that this tag conforms to this format
> + *    X          | reserved
> + *   ------------+-------------
> + *    REASON     | reason for forwarding packet to CPU
> + *    FID_EN     | 1: packet has an FID
> + *               | 0: no FID
> + *    FID        | FID of packet (if FID_EN=1)
> + *    PRI_EN     | 1: force priority of packet
> + *               | 0: don't force priority
> + *    PRI        | priority of packet (if PRI_EN=1)
> + *    KEEP       | preserve packet VLAN tag format

What does it mean to preserve packet VLAN tag format? Trying to
understand if the sane thing is to clear or set this bit. Does it mean
to strip the VLAN tag on egress if the VLAN is configured as
egress-untagged on the port?

> + *    LEARN_DIS  | don't learn the source MAC address of the packet
> + *    ALLOW      | 1: treat TX/RX field as an allowance port mask, meaning the
> + *               |    packet may only be forwarded to ports specified in the
> + *               |    mask
> + *               | 0: no allowance port mask, TX/RX field is the forwarding
> + *               |    port mask
> + *    TX/RX      | TX (switch->CPU): port number the packet was received on
> + *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
> + *               |                   allowance port mask (if ALLOW=1)
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/bits.h>
> +
> +#include "dsa_priv.h"
> +
> +#define RTL8_4_TAG_LEN			8
> +#define RTL8_4_ETHERTYPE		0x8899
> +/* 0x04 = RTL8365MB DSA protocol
> + */
> +#define RTL8_4_PROTOCOL_RTL8365MB	0x04
> +
> +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	__be16 *p;
> +	u8 *tag;
> +	u16 out;
> +
> +	/* Pad out so that the (stripped) packet is at least 64 bytes long
> +	 * (including FCS), otherwise the switch will drop the packet.
> +	 * Then we need an additional 8 bytes for the Realtek tag.
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + RTL8_4_TAG_LEN, false))
> +		return NULL;
> +
> +	skb_push(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> +	tag = dsa_etype_header_pos_tx(skb);
> +
> +	/* Set Realtek EtherType */
> +	p = (__be16 *)tag;

You would have much fewer (zero) type casts if "tag" was a "__be16 *" in
the first place. Additionally, you would not need "p" and you could work
with tag[0], tag[1], tag[2], tag[3].

> +	*p = htons(RTL8_4_ETHERTYPE);
> +
> +	/* Set Protocol; zero REASON */
> +	p = (__be16 *)(tag + 2);
> +	*p = htons(RTL8_4_PROTOCOL_RTL8365MB << 8);
> +
> +	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP, LEARN_DIS */

Please set LEARN_DIS. DSA has better ways to control what needs to be
learned and what doesn't. Packets injected into a standalone port
surely shouldn't have their MAC SA learned. Grep for "tx_fwd_offload" in
the kernel, see what it takes to transmit a packet with
skb->offload_fwd_mark = true, and you can clear LEARN_DIS and set ALLOW
then.

> +	p = (__be16 *)(tag + 4);
> +	*p = 0;
> +
> +	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
> +	p = (__be16 *)(tag + 6);
> +	out = BIT(dp->index);

Set but unused variable.

> +	*p = htons(~(1 << 15) & BIT(dp->index));

I am deeply confused by this line.

~(1 << 15) is GENMASK(14, 0)
By AND-ing it with BIT(dp->index), what do you gain?

> +
> +	return skb;
> +}
> +
> +static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *dev)
> +{
> +	__be16 *p;
> +	u16 etype;
> +	u8 proto;
> +	u8 *tag;
> +	u8 port;
> +	u16 tmp;
> +
> +	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> +		return NULL;
> +
> +	tag = dsa_etype_header_pos_rx(skb);
> +
> +	/* Parse Realtek EtherType */
> +	p = (__be16 *)tag;

Same comment about it being more productive for "tag" to be "__be16 *".

> +	etype = ntohs(*p);
> +	if (unlikely(etype != RTL8_4_ETHERTYPE)) {
> +		netdev_dbg(dev, "non-realtek ethertype 0x%04x\n", etype);
> +		return NULL;
> +	}
> +
> +	/* Parse Protocol; ignore REASON */
> +	p = (__be16 *)(tag + 2);
> +	tmp = ntohs(*p);
> +	proto = tmp >> 8;
> +	if (unlikely(proto != RTL8_4_PROTOCOL_RTL8365MB)) {
> +		netdev_dbg(dev, "unknown realtek protocol 0x%02x\n", proto);
> +		return NULL;
> +	}
> +
> +	/* Ignore FID_EN, FID, PRI_EN, PRI, KEEP, LEARN_DIS */
> +	p = (__be16 *)(tag + 4);

Delete then?

> +
> +	/* Ignore ALLOW; parse TX (switch->CPU) */
> +	p = (__be16 *)(tag + 6);
> +	tmp = ntohs(*p);
> +	port = tmp & 0xf; /* Port number is the LSB 4 bits */
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> +	if (!skb->dev) {
> +		netdev_dbg(dev, "could not find slave for port %d\n", port);
> +		return NULL;
> +	}
> +
> +	/* Remove tag and recalculate checksum */
> +	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
> +
> +	skb->offload_fwd_mark = 1;

At the very least, please use

	dsa_default_offload_fwd_mark(skb);

which does the right thing when the port is not offloading the bridge.

Also tell us more about REASON and ALLOW. Is there a bit in the RX tag
which denotes that the packet was forwarded only to the host?

> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops rtl8_4_netdev_ops = {
> +	.name = "rtl8_4",
> +	.proto = DSA_TAG_PROTO_RTL8_4,
> +	.xmit = rtl8_4_tag_xmit,
> +	.rcv = rtl8_4_tag_rcv,
> +	.needed_headroom = RTL8_4_TAG_LEN,
> +};
> +module_dsa_tag_driver(rtl8_4_netdev_ops);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
> -- 
> 2.32.0
> 
