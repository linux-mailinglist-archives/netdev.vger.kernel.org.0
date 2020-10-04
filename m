Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E3282A82
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgJDL4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgJDL4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:56:53 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C075AC0613CE;
        Sun,  4 Oct 2020 04:56:52 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so6532588wrx.7;
        Sun, 04 Oct 2020 04:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hm2u6dVzCEbaPEQN7US7z9QgRtqrnuoagqwI7dCPKCA=;
        b=E7fWMRTl27Q5U4lZmChv32ZRURaC85tV6q0X+hdlcGln3AH1bo7C4bx/yL/nrsKKvJ
         /2bhxSDxbuwLwffBioW/u5xFuEES0lylr7v+s8s06ZAcJOpiByXxmhh1GeGQw2EZT+MQ
         mtrckWAwDepg3RagFWJY2SU6qfDNcQsjeFGeWhle16WWF6Fqs5jPyUuM2pPRdPFSc8B3
         6lYSLQ6DAbqSiNoS3ZtWb2+zks7k+1WdjbBHBbZKKkkCnbhEsA3XPVr0uxYr/FWy6lRQ
         /VwixTmmB7+13dOKRCmKKP1Wq5TCyHvUPUJZNZCcnaRTYG24TI+x1W9yz4t7znum8IzA
         1QQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hm2u6dVzCEbaPEQN7US7z9QgRtqrnuoagqwI7dCPKCA=;
        b=jri4bRJy2lb53pq+qRMyDZQQQC/wkKWiV4g5O7ZgIUr1g9SJ6BBRU5uwnjgNlfrNdB
         5gY5xZAQKzbhgS5NvXXEYT2anecKoiPCjEcRya558dzwRwL70s1Ai2TmyZOoKTlZ2vzu
         K1lcgP+eh6liVa9LO2GlKV352Xj8KsSOGxtxoTdDys6DgUZ9k2u+FH37n5E2ayy2IHXp
         PwO4VWWYoWQnzWkEdhwsFR1s12Xel9AePSxKhYgqIGNUD8WJInYT53YMZpuFK32gQrD/
         J0Sook/p/ogabeOODAz0++GW7rDVf9kNJQKLCB6RMWkHYgZ8/64vHtGjkgp4H5VKU8mc
         r5Mw==
X-Gm-Message-State: AOAM5300bNCFaCZ6rF/8uOHhCJZG7atPRXPzVUaheVxn1nqG4cHmWa8y
        MGPxgo6xoAb0LpzFhUI9SF8=
X-Google-Smtp-Source: ABdhPJw0ZJr5Yr2iUoOp4r9rDAemr7gWikE36hqZ+XC7cnDlq2S48wOcf7QQelplI0RbNAf75O/c2Q==
X-Received: by 2002:a5d:49d2:: with SMTP id t18mr11763077wrs.99.1601812611205;
        Sun, 04 Oct 2020 04:56:51 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id x6sm1255383wmb.17.2020.10.04.04.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 04:56:50 -0700 (PDT)
Date:   Sun, 4 Oct 2020 14:56:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 1/7] net: dsa: Add tag handling for
 Hirschmann Hellcreek switches
Message-ID: <20201004115649.i5w7r4djxwpnjx5w@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004112911.25085-2-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 01:29:05PM +0200, Kurt Kanzenbach wrote:
> The Hirschmann Hellcreek TSN switches have a special tagging protocol for frames
> exchanged between the CPU port and the master interface. The format is a one
> byte trailer indicating the destination or origin port.
> 
> It's quite similar to the Micrel KSZ tagging. That's why the implementation is
> based on that code.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  include/net/dsa.h       |   2 +
>  net/dsa/Kconfig         |   6 +++
>  net/dsa/Makefile        |   1 +
>  net/dsa/tag_hellcreek.c | 101 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 110 insertions(+)
>  create mode 100644 net/dsa/tag_hellcreek.c
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 8b0696e08cac..ee24476a1a4c 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -45,6 +45,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_OCELOT_VALUE		15
>  #define DSA_TAG_PROTO_AR9331_VALUE		16
>  #define DSA_TAG_PROTO_RTL4_A_VALUE		17
> +#define DSA_TAG_PROTO_HELLCREEK_VALUE		18
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -65,6 +66,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
>  	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
>  	DSA_TAG_PROTO_RTL4_A		= DSA_TAG_PROTO_RTL4_A_VALUE,
> +	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
>  };
>  
>  struct packet_type;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 1f9b9b11008c..d975614f7dd6 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -56,6 +56,12 @@ config NET_DSA_TAG_BRCM_PREPEND
>  	  Broadcom switches which places the tag before the Ethernet header
>  	  (prepended).
>  
> +config NET_DSA_TAG_HELLCREEK
> +	tristate "Tag driver for Hirschmann Hellcreek TSN switches"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames
> +	  for the Hirschmann Hellcreek TSN switches.
> +
>  config NET_DSA_TAG_GSWIP
>  	tristate "Tag driver for Lantiq / Intel GSWIP switches"
>  	help
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 4f47b2025ff5..e25d5457964a 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
>  obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
> +obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
> diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
> new file mode 100644
> index 000000000000..0895eda94bb5
> --- /dev/null
> +++ b/net/dsa/tag_hellcreek.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * net/dsa/tag_hellcreek.c - Hirschmann Hellcreek switch tag format handling
> + *
> + * Copyright (C) 2019,2020 Linutronix GmbH
> + * Author Kurt Kanzenbach <kurt@linutronix.de>
> + *
> + * Based on tag_ksz.c.
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <net/dsa.h>
> +
> +#include "dsa_priv.h"
> +
> +#define HELLCREEK_TAG_LEN	1
> +
> +static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
> +				      struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct sk_buff *nskb;
> +	int padlen;
> +	u8 *tag;
> +
> +	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
> +
> +	if (skb_tailroom(skb) >= padlen + HELLCREEK_TAG_LEN) {
> +		/* Let dsa_slave_xmit() free skb */
> +		if (__skb_put_padto(skb, skb->len + padlen, false))
> +			return NULL;
> +
> +		nskb = skb;
> +	} else {
> +		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
> +				 padlen + HELLCREEK_TAG_LEN, GFP_ATOMIC);
> +		if (!nskb)
> +			return NULL;
> +		skb_reserve(nskb, NET_IP_ALIGN);
> +
> +		skb_reset_mac_header(nskb);
> +		skb_set_network_header(nskb,
> +				       skb_network_header(skb) - skb->head);
> +		skb_set_transport_header(nskb,
> +					 skb_transport_header(skb) - skb->head);
> +		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
> +
> +		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
> +		 * skb
> +		 */
> +		if (skb_put_padto(nskb, nskb->len + padlen))
> +			return NULL;
> +
> +		consume_skb(skb);
> +	}
> +
> +	if (!nskb)
> +		return NULL;
> +
> +	/* Tag encoding */
> +	tag  = skb_put(nskb, HELLCREEK_TAG_LEN);
> +	*tag = BIT(dp->index);
> +
> +	return nskb;
> +}
> +
> +static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
> +				     struct net_device *dev,
> +				     struct packet_type *pt)
> +{
> +	/* Tag decoding */
> +	u8 *tag = skb_tail_pointer(skb) - HELLCREEK_TAG_LEN;
> +	unsigned int port = tag[0] & 0x03;
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> +	if (!skb->dev) {
> +		netdev_warn(dev, "Failed to get source port: %d\n", port);
> +		return NULL;
> +	}
> +
> +	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
> +
> +	skb->offload_fwd_mark = true;
> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops hellcreek_netdev_ops = {
> +	.name	  = "hellcreek",
> +	.proto	  = DSA_TAG_PROTO_HELLCREEK,
> +	.xmit	  = hellcreek_xmit,
> +	.rcv	  = hellcreek_rcv,
> +	.overhead = HELLCREEK_TAG_LEN,

After the changes in "Generic adjustment for flow dissector in DSA":
https://patchwork.ozlabs.org/project/netdev/list/?series=204347&state=*
you might want to set ".tail_tag = true" (see patch 07/15), either now
or later.

Either way,

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +};
> +
> +MODULE_LICENSE("Dual MIT/GPL");
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_HELLCREEK);
> +
> +module_dsa_tag_driver(hellcreek_netdev_ops);
> -- 
> 2.20.1
> 
