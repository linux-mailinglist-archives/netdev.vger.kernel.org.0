Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C562AD6FA
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgKJM7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJM7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 07:59:10 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C63C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 04:59:09 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id za3so17424655ejb.5
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 04:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IPAgQKY4tfB2id72Biq2eXLmHGGp8cZReW6NnKth8jM=;
        b=JmLBHY3iKteIY3hOnkJvMJkgvm7OLKGq2/XxNC+SeeP6bpNK2AgbsqNnXgeCIGoXuJ
         5dUREkJXEXEmeWehyc1c1ncBP/pdoDoWaZzF17RRrEuTx9OlRyb7Sh5fbbqheMzfQEVq
         TsLPmzMw24cyr4VmDKce8qY9DXDUH0jaZG07KS9n7TwZAFYdRNqXYLaclaI/y7WBjs3T
         gXumLx1N4ju/YlksFhI6fYVg6dSDgmU/xvsMJ5VFAJYc/+w2yaesPcUCL2jz1M+ybO8u
         3+YdlgUi7jUJUa4rcwVKOwnJBJfmRgLJWd9J8lMvPKYtbBv25xTXJzJISBxfiDXKcD7a
         qGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IPAgQKY4tfB2id72Biq2eXLmHGGp8cZReW6NnKth8jM=;
        b=PVAxCajbNZQUfJO8Pi14ag71U2u4hzbXjuCfJI0DSi6kGE9XN8OxH8WDlpcaMGwUbA
         m2MAlIKX9vvJAPZHyWTAVZswcKrk5ihq0qogIOPmNKj/0paUnbONTgI764gkMZCpvB6G
         BSEE0bj8Oq+FmoBKeEGeZZgYY7GqC4nThSGuhY43eUkYLGlc72GMzJaeg3A31ggr04PM
         SSF8G1wby+/VbxoenlOoryJNNYm6yfrNwZBdHJdmA+Gqx5WsCMk02uKZ+Ncnxshc3RJa
         BHFk6DhE03ExotOhX+FkNJOtwc0dzqKpVHinF00O18Nqmuok38kbPFYDCmQRRo7RsQfe
         VWhQ==
X-Gm-Message-State: AOAM530ECnElKsL2bWQbHSjIAdh0nvmQ2ew178Wib38erBDjzOXrXLID
        ZtRZBy/LZDlW/anLRC/BJOU=
X-Google-Smtp-Source: ABdhPJwzWC8YaWOv0cj3LdMJfj5C/GxPEi7fketfxGq8xzDALVwGrTSMI9rOIc7QwqHZWW50+H0C5w==
X-Received: by 2002:a17:906:50e:: with SMTP id j14mr11928670eja.403.1605013148491;
        Tue, 10 Nov 2020 04:59:08 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm10333856edw.67.2020.11.10.04.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 04:59:07 -0800 (PST)
Date:   Tue, 10 Nov 2020 14:59:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: tag_dsa: Unify regular and ethertype DSA
 taggers
Message-ID: <20201110125906.djgj2nnzdlnudt3w@skbuf>
References: <20201110091325.21582-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110091325.21582-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 10:13:25AM +0100, Tobias Waldekranz wrote:
> Ethertype DSA encodes exactly the same information in the DSA tag as
> the non-ethertype variety. So refactor out the common parts and reuse
> them for both protocols.
> 
> This is ensures tag parsing and generation as always consistent across
> all mv88e6xxx chips.
> 
> While we are at it, explicitly deal with all possible CPU codes on
> receive, making sure to set offload_fwd_mark as appropriate.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> I've tried to verify all dimensions of this: Rx of TO_CPU and FORWARD,
> Tx of FROM_CPU, both tagged and untagged, from both the first and a
> cascaded chip.
> 
> Tested on:
> 1. 6352+6097F
> 2. 6390X
> 
>  net/dsa/Kconfig    |   6 +
>  net/dsa/Makefile   |   3 +-
>  net/dsa/tag_dsa.c  | 299 ++++++++++++++++++++++++++++++++++++---------
>  net/dsa/tag_edsa.c | 202 ------------------------------
>  4 files changed, 245 insertions(+), 265 deletions(-)
>  delete mode 100644 net/dsa/tag_edsa.c
> 
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index d975614f7dd6..42d8ad84f92f 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -68,14 +68,20 @@ config NET_DSA_TAG_GSWIP
>  	  Say Y or M if you want to enable support for tagging frames for the
>  	  Lantiq / Intel GSWIP switches.
>  
> +config NET_DSA_TAG_DSA_COMMON
> +	tristate
> +	default n

I think that "default n" is implicit and should be omitted.

> +
>  config NET_DSA_TAG_DSA
>  	tristate "Tag driver for Marvell switches using DSA headers"
> +	select NET_DSA_TAG_DSA_COMMON
>  	help
>  	  Say Y or M if you want to enable support for tagging frames for the
>  	  Marvell switches which use DSA headers.
>  
>  config NET_DSA_TAG_EDSA
>  	tristate "Tag driver for Marvell switches using EtherType DSA headers"
> +	select NET_DSA_TAG_DSA_COMMON
>  	help
>  	  Say Y or M if you want to enable support for tagging frames for the
>  	  Marvell switches which use EtherType DSA headers.
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index e25d5457964a..0fb2b75a7ae3 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -7,8 +7,7 @@ dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
>  obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
>  obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
>  obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
> -obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
> -obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
> +obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index 63d690a0fca6..b8ee852a46d8 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -1,7 +1,47 @@
>  // SPDX-License-Identifier: GPL-2.0+
>  /*
> - * net/dsa/tag_dsa.c - (Non-ethertype) DSA tagging
> + * Regular and Ethertype DSA tagging
>   * Copyright (c) 2008-2009 Marvell Semiconductor
> + *
> + * Regular DSA
> + * -----------
> + * For untagged (in 802.1Q terms) packes, the swich will splice in the
> + * tag between the SA and the ethertype of the original packet. Tagged
> + * frames will instead have their outermost .1Q tag converted to a DSA
> + * tag. It expects the same layout when receiving packets from the
> + * CPU.
> + *
> + * Example:
> + *
> + *     .----.----.----.---------
> + * Pu: | DA | SA | ET | Payload ...
> + *     '----'----'----'---------
> + *       6    6    2       N
> + *     .----.----.--------.-----.----.---------
> + * Pt: | DA | SA | 0x8100 | TCI | ET | Payload ...
> + *     '----'----'--------'-----'----'---------
> + *       6    6       2      2    2       N
> + *     .----.----.-----.----.---------
> + * Pd: | DA | SA | DSA | ET | Payload ...
> + *     '----'----'-----'----'---------
> + *       6    6     4    2       N
> + *
> + * No matter if a packet is received untagged (Pu) or tagged (Pt),
> + * they will both have the same layout (Pd) when they are sent to the
> + * CPU. This is done by ignoring 802.3, replacing the ethertype field
> + * with more metadata, among which is a bit to signal if the original
> + * packet was tagged or not.
> + *
> + * Ethertype DSA
> + * -------------
> + * Uses the exact same tag format as regular DSA, but also includes a
> + * proper ethertype field (which the mv88e6xxx driver sets to
> + * ETH_P_EDSA/0xdada) followed by two zero bytes:
> + *
> + * .----.----.--------.--------.-----.----.---------
> + * | DA | SA | 0xdada | 0x0000 | DSA | ET | Payload ...
> + * '----'----'--------'--------'-----'----'---------
> + *   6    6       2        2      4    2       N
>   */
>  
>  #include <linux/etherdevice.h>
> @@ -10,43 +50,79 @@
>  
>  #include "dsa_priv.h"
>  
> -#define DSA_HLEN	4
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA_COMMON)
>  
> -static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
> +#define DSA_HLEN 4
> +
> +/**
> + * enum dsa_cmd - DSA Command
> + * @DSA_CMD_TO_CPU: Set on packets that where trapped or mirrored to

s/where/were/

> + *     the CPU port. This is needed to implement control protocols,
> + *     e.g. STP and LLDP, that must not allow those control packets to
> + *     be switched according to the normal rules.
> + * @DSA_CMD_FROM_CPU: Used by the CPU to send a packet to a specific
> + *     port, ignoring all the barriers that the switch normally
> + *     enforces (VLANs, STP port states etc.). "sudo send packet"
> + * @DSA_CMD_TO_SNIFFER: Set on packets that where mirrored to the CPU
> + *     as a result of matching some user configured ingress or egress
> + *     monitor criteria.
> + * @DSA_CMD_FORWARD: Everything else, i.e. the bulk data traffic.
> + */
> +enum dsa_cmd {
> +	DSA_CMD_TO_CPU     = 0,
> +	DSA_CMD_FROM_CPU   = 1,
> +	DSA_CMD_TO_SNIFFER = 2,
> +	DSA_CMD_FORWARD    = 3
> +};
> +
> +/**
> + * enum dsa_code - TO_CPU Code
> + *
> + * A 3-bit code is used to relay why a particular frame was sent to
> + * the CPU. We only use this to determine if the packet was trapped or
> + * mirrored, i.e. whether the packet has been forwarded by hardware or
> + * not.
> + */
> +enum dsa_code {
> +	DSA_CODE_MGMT_TRAP     = 0,
> +	DSA_CODE_FRAME2REG     = 1,
> +	DSA_CODE_IGMP_MLD_TRAP = 2,
> +	DSA_CODE_POLICY_TRAP   = 3,
> +	DSA_CODE_ARP_MIRROR    = 4,
> +	DSA_CODE_POLICY_MIRROR = 5,
> +	DSA_CODE_RESERVED_6    = 6,
> +	DSA_CODE_RESERVED_7    = 7
> +};
> +
> +static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
> +				   u8 extra)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	u8 *dsa_header;
>  
> -	/*
> -	 * Convert the outermost 802.1q tag to a DSA tag for tagged
> -	 * packets, or insert a DSA tag between the addresses and
> -	 * the ethertype field for untagged packets.
> -	 */
>  	if (skb->protocol == htons(ETH_P_8021Q)) {
> -		/*
> -		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
> -		 */
> -		dsa_header = skb->data + 2 * ETH_ALEN;
> -		dsa_header[0] = 0x60 | dp->ds->index;
> +		if (extra) {
> +			skb_push(skb, extra);
> +			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
> +		}
> +
> +		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
> +		dsa_header = skb->data + 2 * ETH_ALEN + extra;
> +		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;

What is 0x20, BIT(5)? To denote that it's an 802.1Q tagged frame I suppose?
Could it have a macro?

>  		dsa_header[1] = dp->index << 3;
>  
> -		/*
> -		 * Move CFI field from byte 2 to byte 1.
> -		 */
> +		/* Move CFI field from byte 2 to byte 1. */
>  		if (dsa_header[2] & 0x10) {
>  			dsa_header[1] |= 0x01;
>  			dsa_header[2] &= ~0x10;
>  		}
>  	} else {
> -		skb_push(skb, DSA_HLEN);
> -
> -		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
> +		skb_push(skb, DSA_HLEN + extra);
> +		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
>  
> -		/*
> -		 * Construct untagged FROM_CPU DSA tag.
> -		 */
> -		dsa_header = skb->data + 2 * ETH_ALEN;
> -		dsa_header[0] = 0x40 | dp->ds->index;
> +		/* Construct untagged FROM_CPU DSA tag. */
> +		dsa_header = skb->data + 2 * ETH_ALEN + extra;
> +		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
>  		dsa_header[1] = dp->index << 3;
>  		dsa_header[2] = 0x00;
>  		dsa_header[3] = 0x00;
> @@ -55,30 +131,62 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return skb;
>  }
>  
> -static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
> -			       struct packet_type *pt)
> +static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
> +				  u8 extra)
>  {
> +	int source_device, source_port;
> +	enum dsa_code code;
> +	enum dsa_cmd cmd;
>  	u8 *dsa_header;
> -	int source_device;
> -	int source_port;
>  
> -	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
> -		return NULL;
> -
> -	/*
> -	 * The ethertype field is part of the DSA header.
> -	 */
> +	/* The ethertype field is part of the DSA header. */

Could these comment style changes be a separate patch?

>  	dsa_header = skb->data - 2;
>  
> -	/*
> -	 * Check that frame type is either TO_CPU or FORWARD.
> -	 */
> -	if ((dsa_header[0] & 0xc0) != 0x00 && (dsa_header[0] & 0xc0) != 0xc0)
> +	cmd = dsa_header[0] >> 6;
> +	switch (cmd) {
> +	case DSA_CMD_FORWARD:
> +		skb->offload_fwd_mark = 1;
> +		break;
> +
> +	case DSA_CMD_TO_CPU:
> +		code = (dsa_header[1] & 0x6) | ((dsa_header[2] >> 4) & 1);
> +
> +		switch (code) {
> +		case DSA_CODE_FRAME2REG:
> +			/* Remote management frames originate from the
> +			 * switch itself, there is no DSA port for us
> +			 * to ingress it on (the port field is always
> +			 * 0 in these tags).
> +			 */
> +			return NULL;
> +		case DSA_CODE_ARP_MIRROR:
> +		case DSA_CODE_POLICY_MIRROR:
> +			/* Mark mirrored packets to notify any upper
> +			 * device (like a bridge) that forwarding has
> +			 * already been done by hardware.
> +			 */
> +			skb->offload_fwd_mark = 1;
> +			break;
> +		case DSA_CODE_MGMT_TRAP:
> +		case DSA_CODE_IGMP_MLD_TRAP:
> +		case DSA_CODE_POLICY_TRAP:
> +			/* Traps have, by definition, not been
> +			 * forwarded by hardware, so don't mark them.
> +			 */
> +			break;
> +		default:
> +			/* Reserved code, this could be anything. Drop
> +			 * seems like the safest option.
> +			 */
> +			return NULL;
> +		}
> +
> +		break;
> +
> +	default:
>  		return NULL;
> +	}
>  
> -	/*
> -	 * Determine source device and port.
> -	 */
>  	source_device = dsa_header[0] & 0x1f;
>  	source_port = (dsa_header[1] >> 3) & 0x1f;
>  
> @@ -86,16 +194,15 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  	if (!skb->dev)
>  		return NULL;
>  
> -	/*
> -	 * Convert the DSA header to an 802.1q header if the 'tagged'
> -	 * bit in the DSA header is set.  If the 'tagged' bit is clear,
> -	 * delete the DSA header entirely.
> +	/* If the 'tagged' bit is set; convert the DSA tag to a 802.1Q
> +	 * tag, and delete the ethertype (extra) if applicable. If the
> +	 * 'tagged' bit is cleared; delete the DSA tag, and ethertype
> +	 * if applicable.
>  	 */
>  	if (dsa_header[0] & 0x20) {
>  		u8 new_header[4];
>  
> -		/*
> -		 * Insert 802.1q ethertype and copy the VLAN-related
> +		/* Insert 802.1Q ethertype and copy the VLAN-related
>  		 * fields, but clear the bit that will hold CFI (since
>  		 * DSA uses that bit location for another purpose).
>  		 */
> @@ -104,16 +211,13 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  		new_header[2] = dsa_header[2] & ~0x10;
>  		new_header[3] = dsa_header[3];
>  
> -		/*
> -		 * Move CFI bit from its place in the DSA header to
> -		 * its 802.1q-designated place.
> +		/* Move CFI bit from its place in the DSA header to
> +		 * its 802.1Q-designated place.
>  		 */
>  		if (dsa_header[1] & 0x01)
>  			new_header[2] |= 0x10;
>  
> -		/*
> -		 * Update packet checksum if skb is CHECKSUM_COMPLETE.
> -		 */
> +		/* Update packet checksum if skb is CHECKSUM_COMPLETE. */
>  		if (skb->ip_summed == CHECKSUM_COMPLETE) {
>  			__wsum c = skb->csum;
>  			c = csum_add(c, csum_partial(new_header + 2, 2, 0));
> @@ -122,21 +226,39 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  		}
>  
>  		memcpy(dsa_header, new_header, DSA_HLEN);
> +
> +		if (extra)
> +			memmove(skb->data - ETH_HLEN,
> +				skb->data - ETH_HLEN - extra,
> +				2 * ETH_ALEN);
>  	} else {
> -		/*
> -		 * Remove DSA tag and update checksum.
> -		 */
>  		skb_pull_rcsum(skb, DSA_HLEN);
>  		memmove(skb->data - ETH_HLEN,
> -			skb->data - ETH_HLEN - DSA_HLEN,
> +			skb->data - ETH_HLEN - DSA_HLEN - extra,
>  			2 * ETH_ALEN);
>  	}
>  
> -	skb->offload_fwd_mark = 1;
> -
>  	return skb;
>  }
>  
> +#endif	/* CONFIG_NET_DSA_TAG_DSA_COMMON */
> +
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
> +
> +static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	return dsa_xmit_ll(skb, dev, 0);
> +}
> +
> +static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
> +			       struct packet_type *pt)
> +{
> +	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
> +		return NULL;
> +
> +	return dsa_rcv_ll(skb, dev, 0);
> +}
> +
>  static const struct dsa_device_ops dsa_netdev_ops = {
>  	.name	= "dsa",
>  	.proto	= DSA_TAG_PROTO_DSA,
> @@ -145,7 +267,62 @@ static const struct dsa_device_ops dsa_netdev_ops = {
>  	.overhead = DSA_HLEN,
>  };
>  
> -MODULE_LICENSE("GPL");
> +DSA_TAG_DRIVER(dsa_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_DSA);
> +#endif	/* CONFIG_NET_DSA_TAG_DSA */
> +
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_EDSA)
>  
> -module_dsa_tag_driver(dsa_netdev_ops);
> +#define EDSA_HLEN 8
> +
> +static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	u8 *edsa_header;
> +
> +	skb = dsa_xmit_ll(skb, dev, EDSA_HLEN - DSA_HLEN);
> +	if (!skb)
> +		return NULL;
> +
> +	edsa_header = skb->data + 2 * ETH_ALEN;
> +	edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
> +	edsa_header[1] = ETH_P_EDSA & 0xff;
> +	edsa_header[2] = 0x00;
> +	edsa_header[3] = 0x00;
> +	return skb;
> +}
> +
> +static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
> +				struct packet_type *pt)
> +{
> +	if (unlikely(!pskb_may_pull(skb, EDSA_HLEN)))
> +		return NULL;
> +
> +	skb_pull_rcsum(skb, EDSA_HLEN - DSA_HLEN);
> +
> +	return dsa_rcv_ll(skb, dev, EDSA_HLEN - DSA_HLEN);
> +}
> +
> +static const struct dsa_device_ops edsa_netdev_ops = {
> +	.name	= "edsa",
> +	.proto	= DSA_TAG_PROTO_EDSA,
> +	.xmit	= edsa_xmit,
> +	.rcv	= edsa_rcv,
> +	.overhead = EDSA_HLEN,

Could you reindent these to be aligned?

> +};
> +
> +DSA_TAG_DRIVER(edsa_netdev_ops);
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_EDSA);
> +#endif	/* CONFIG_NET_DSA_TAG_EDSA */
> +
> +static struct dsa_tag_driver *dsa_tag_drivers[] = {
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
> +	&DSA_TAG_DRIVER_NAME(dsa_netdev_ops),
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_EDSA)
> +	&DSA_TAG_DRIVER_NAME(edsa_netdev_ops),
> +#endif
> +};
> +
> +module_dsa_tag_drivers(dsa_tag_drivers);
> +
> +MODULE_LICENSE("GPL");
