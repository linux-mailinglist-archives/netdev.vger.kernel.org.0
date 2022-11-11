Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56B562659B
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 00:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiKKXhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 18:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKKXhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 18:37:19 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B21E659F;
        Fri, 11 Nov 2022 15:37:18 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 13so15934656ejn.3;
        Fri, 11 Nov 2022 15:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G9Y9yhSdHqOUHPRZdNpL0kiXERp5PNpZLc2HB4kOxrc=;
        b=aqP76dtcskDMwQA5tvXiugSOQqfKBh/XATREu+VTrhMifbT9FEn0XJckUW907StA4f
         hMUscUjWOPbXHLl/TyceCeC3ZzHr76gha2EfrLluOmaQQnFZLJl2uOlszSIqAN4GyKZS
         jSqSQyzYAocBH/pXiMdePvzGhSjZqUdTeG3NokR2KKOkk8L9+UGb9t/a7/ksG/ZynKsK
         ywCtu4Kk3+lfV+9uwco70eCO5pJsWfMDBVa5l+HindU2jFnVgmxfiuS4Hk+03kGHOxzU
         9uXc8LzjmYR7emWvNAM9xcBQ1hDfsN7OT8HvR48s5hqis4IojJpUhpedwpDubRANNNst
         hYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9Y9yhSdHqOUHPRZdNpL0kiXERp5PNpZLc2HB4kOxrc=;
        b=nzAUh9y1fya4gvZWmF0sOgaRFlAzj/nG0fBwuew2KpLwRy3ouio1qONeX5rmgd6MfU
         A7B5NibphDilW1Z1FC2s8/NYW+Os3ALXcTaCgResf1+6K6eqGXH8iTLfY9iBm2O/acOW
         dLwBpooHzWRs+e+2+3uRYxKeqqXkXCmUuMtad6RXLn2lmXc7rRwBYKY2BnvO/rhnH4dr
         bG4/JQCFa515vjdA42ndHD33FexBEAHGQatOMG+oGMcmaboUNMFtjcAF5W+sTXUOjSs8
         ZV2F4xXSqQAh/aY0cujSn0ozgcKqxQCQYRIOuiV+lIelaLzfaQVYw2eNz8W+dMcPKNwj
         1ssA==
X-Gm-Message-State: ANoB5pnEqmuA54hSxDIJRj41CQo0iuPAcW0a9r+ijfY1FLB3k0c4HaH6
        6/3th19iL32mdG/XkuWPuNU=
X-Google-Smtp-Source: AA0mqf5B7O94sHIfSfMhUCdqVkBIdtPjB7iO/h/cK9IbhkzrR6HnFAN2vQmsfDoM7AMPswD8FLabLg==
X-Received: by 2002:a17:907:119a:b0:7ad:b45d:810c with SMTP id uz26-20020a170907119a00b007adb45d810cmr3791515ejb.181.1668209836544;
        Fri, 11 Nov 2022 15:37:16 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id j17-20020aa7c411000000b00459148fbb3csm1611313edq.86.2022.11.11.15.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 15:37:16 -0800 (PST)
Date:   Sat, 12 Nov 2022 01:37:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221111233714.pmbc5qvq3g3hemhr@skbuf>
References: <20221110212212.96825-1-nbd@nbd.name>
 <20221110212212.96825-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110212212.96825-2-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 10:22:08PM +0100, Felix Fietkau wrote:
> If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
> port netdev, assume that it carries the port number and that there is no DSA
> tag present in the skb data.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---

Doesn't look bad to me, but...

>  net/core/flow_dissector.c |  4 +++-
>  net/dsa/dsa.c             | 19 ++++++++++++++++++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 25cd35f5922e..1f476abc25e1 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -972,11 +972,13 @@ bool __skb_flow_dissect(const struct net *net,
>  		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
>  			     proto == htons(ETH_P_XDSA))) {
>  			const struct dsa_device_ops *ops;
> +			struct metadata_dst *md_dst = skb_metadata_dst(skb);
>  			int offset = 0;
>  
>  			ops = skb->dev->dsa_ptr->tag_ops;
>  			/* Only DSA header taggers break flow dissection */
> -			if (ops->needed_headroom) {
> +			if (ops->needed_headroom &&
> +			    (!md_dst || md_dst->type != METADATA_HW_PORT_MUX)) {
>  				if (ops->flow_dissect)
>  					ops->flow_dissect(skb, &proto, &offset);
>  				else
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 64b14f655b23..0b67622cf905 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -11,6 +11,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/sysfs.h>
>  #include <linux/ptp_classify.h>
> +#include <net/dst_metadata.h>
>  
>  #include "dsa_priv.h"
>  
> @@ -216,6 +217,7 @@ static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
>  static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>  			  struct packet_type *pt, struct net_device *unused)
>  {
> +	struct metadata_dst *md_dst = skb_metadata_dst(skb);
>  	struct dsa_port *cpu_dp = dev->dsa_ptr;
>  	struct sk_buff *nskb = NULL;
>  	struct dsa_slave_priv *p;
> @@ -229,7 +231,22 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>  	if (!skb)
>  		return 0;
>  
> -	nskb = cpu_dp->rcv(skb, dev);
> +	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
> +		unsigned int port = md_dst->u.port_info.port_id;
> +
> +		skb_dst_set(skb, NULL);

If you insist on not using the refcounting feature and free your
metadata_dst in the master's remove() function, that's going to
invalidate absolutely any point I'm trying to make. Normally I'd leave
you alone, however I really don't like that this is also forcing DSA to
not use the refcount, and therefore, that it's forcing any other driver
to do the same as mtk_eth_soc. Not sure how that's gonna scale in the
hypothetical future when there will be a DSA master which can offload
RX DSA tags, *and* the switch can change tagging protocols dynamically
(which will force the master to allocate/free its metadata dst's at
runtime too). I guess that will be for me to figure out, which I don't
like.

Jakub, what do you think? Refcounting or no refcounting?

> +		if (!skb_has_extensions(skb))
> +			skb->slow_gro = 0;
> +
> +		skb->dev = dsa_master_find_slave(dev, 0, port);
> +		if (likely(skb->dev)) {
> +			dsa_default_offload_fwd_mark(skb);
> +			nskb = skb;
> +		}
> +	} else {
> +		nskb = cpu_dp->rcv(skb, dev);
> +	}
> +
>  	if (!nskb) {
>  		kfree_skb(skb);
>  		return 0;
> -- 
> 2.38.1
> 
