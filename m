Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC902A3D6E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgKCHRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgKCHRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:17:50 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF34C0617A6;
        Mon,  2 Nov 2020 23:17:50 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t11so17075382edj.13;
        Mon, 02 Nov 2020 23:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sOrF5iWjGjOzJ1bbgB7wrTZUY6Er8KaofzgtHlCj1a0=;
        b=Gu4XTBa07Sguxh94nqgkLzd7ozNIPwzQwjjlAIWmOEq8nApZCuAXI39gEfJYKxEFTq
         1Ge4fhVxlm+DYOkqxxAkb4Lo4Z2LQ+jqRABLaPDUhF7fgTF+x1hZIksP1sHVeX4lzAdj
         ttCm39GOONS2Nb5NveKRhmOPTvS8dk7o2XscQJjov8qUd0KFNmHAVtgersd+CC4XBigS
         QXv1PZ8BTYt2/h3I1UH0P6wegPVTiiGWWlRrforvDlaG6uCZrFA9WaAgeNBdD+Fz7Cd9
         Mw7VoskiXwRBH9TU+JNNqQ99wMR3IIDE1EN32KuWKzCLtz3FlvtX8BEjMpkVQqimrgpA
         +1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sOrF5iWjGjOzJ1bbgB7wrTZUY6Er8KaofzgtHlCj1a0=;
        b=bB31SUYXJn7Dd/PUfChPPzmO2LHo4JE56RyWM+SIoZYJ5BFn7JvMp8Xb6JUHUh0rCc
         zu2T/HssyIpzGp1h+jZE0CZ+YlG9eNxZQ4Q/QNK2BYkz61ZvlHCAMnLTJ2IPV6n9efMi
         h5IcYv/rKfAnK1y7etwZGSmGitp8ROPzD1AmiLMuF+4pfVQLmlz5sCIi6ne6g/3DX7sx
         F13buFdMu3IQrdqzNN9rmzDRDup+LvVwp3RjrDumb2c1EOZS2G3CHqU+3iHCnvA4S8bH
         pdk39RrZ0VCViMd/SgOo/XtYj3+arD8Y1xx3T5MJBpMr1VdPiWBVQbUy7d243EwW/Nrv
         2CAA==
X-Gm-Message-State: AOAM530qy10IW/Wn/FQ/l8W5a/5LkRQE+47U6bEkeef6b17o6hpa3zPk
        TNbARobQ2sRiTosEp+7gSxo=
X-Google-Smtp-Source: ABdhPJwEYf7p2R4I9Sp6MVwGjitY5/+WrVY7LzBa7Ch9I/HHrqaNgp9EIS4u7M5n4eeLzY42kimKEQ==
X-Received: by 2002:a05:6402:1d13:: with SMTP id dg19mr20755551edb.217.1604387868615;
        Mon, 02 Nov 2020 23:17:48 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id a10sm377628edn.77.2020.11.02.23.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:17:48 -0800 (PST)
Date:   Tue, 3 Nov 2020 09:17:45 +0200
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
Subject: Re: [PATCH net-next v8 1/8] net: dsa: Add tag handling for
 Hirschmann Hellcreek switches
Message-ID: <20201103071745.upspd7trljbrvonv@skbuf>
References: <20201103071101.3222-1-kurt@linutronix.de>
 <20201103071101.3222-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103071101.3222-2-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 08:10:54AM +0100, Kurt Kanzenbach wrote:
> The Hirschmann Hellcreek TSN switches have a special tagging protocol for frames
> exchanged between the CPU port and the master interface. The format is a one
> byte trailer indicating the destination or origin port.
> 
> It's quite similar to the Micrel KSZ tagging. That's why the implementation is
> based on that code.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
> diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
> new file mode 100644
> index 000000000000..2061de06eafb
> --- /dev/null
> +++ b/net/dsa/tag_hellcreek.c
> @@ -0,0 +1,66 @@
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

You probably don't need these includes any longer, but you don't have to
resend this series just to remove them, you could do that afterwards.

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
> +	u8 *tag;
> +
> +	/* Tag encoding */
> +	tag  = skb_put(skb, HELLCREEK_TAG_LEN);
> +	*tag = BIT(dp->index);
> +
> +	return skb;
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
> +	.tail_tag = true,
> +};
> +
> +MODULE_LICENSE("Dual MIT/GPL");
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_HELLCREEK);
> +
> +module_dsa_tag_driver(hellcreek_netdev_ops);
> -- 
> 2.20.1
> 

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
