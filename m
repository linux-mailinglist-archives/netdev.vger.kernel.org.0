Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7785625A39
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 13:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiKKMHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 07:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiKKMGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 07:06:20 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD6C63B86;
        Fri, 11 Nov 2022 04:06:18 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d9so1526279wrm.13;
        Fri, 11 Nov 2022 04:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O8EPpu249C1iS+vS5aAokpcHbI/+UG9o3tliIc+zqVM=;
        b=GbiHFNFeGSSe3fgiRGk3Rqrl9LHCEE4hiGwXnWLl/AZpzQrveRODftlNZCQm5J6uG1
         Wgsf5vogflQjqptn8C2uI8ERsOBtAFmL8STl2hpGE70McvktX42HQiU0FJwhGO4ycb00
         DsIG+FmFVAqrSPTpts03izC3GOLHFx1U7HmxflWqcKjmhdMTK55NTIlBBLwk09yrg6xD
         kPpG9Xw3M+svboxcKhsm3SRpqNUnGCRV8bKv74f2Iyn/PpBKbgakj9ECCWIgA29njKvE
         sDqDvA+lQRouJAFkJF1gwhh31iL2qICsegRv2x7sN2ulUEsZfuZOQKfi/RZ5FSYqXyPZ
         qhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8EPpu249C1iS+vS5aAokpcHbI/+UG9o3tliIc+zqVM=;
        b=fz763mRcZCjC3xun+hkjk+/fLBdAfXZnlHdj0h9ubsJ4BA2wCzTR6+cVXI9KQLkrgi
         FHmPGrIOTnRpvBf77XsXfuOHVSZ84HAgIlYJ1Qj3uYNMtRZU9PsJ9AlAFHHMqTBq6ulD
         RM+6yV5SWd4Ae5Pok8b+8yj0mn58W1Y7Qg6zV84SgKEZhMtCIbODukRuvwdKctgakozr
         bExoJ0E9trE443P53Cyd2OzuGRhhwFEBlkgYwKfCkgSTV9irMsUMRj1uZvlS1Fh7qfEp
         PtBKG2t7YW0sWI/I/oJiPK+w6qgHfcQUIQ2p8t5Uof+D0QLQJeEfnDXK8rzX+vIduxkR
         xpZw==
X-Gm-Message-State: ANoB5plwzKeNHVp8W2X2dKzA5jgepP4UCROAsqtgKGsFZU5RrabHXAYN
        Ue+dD/hXi3M8X6OcYIEl4RIugh+hoVPAxQ==
X-Google-Smtp-Source: AA0mqf6IC1sVUFiFQSqgpy82Q19APC8xlIQUsUe9AIxWLXTCpKzGLVqH+auGI5Q1ZboRXTZKrt//2Q==
X-Received: by 2002:a05:6000:10c4:b0:236:5c22:216c with SMTP id b4-20020a05600010c400b002365c22216cmr1074460wrx.696.1668168376478;
        Fri, 11 Nov 2022 04:06:16 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id az40-20020a05600c602800b003b492753826sm2595359wmb.43.2022.11.11.04.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 04:06:16 -0800 (PST)
Date:   Fri, 11 Nov 2022 14:06:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/12] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221111120613.ll5sywfeo25ub6ja@skbuf>
References: <20221109163426.76164-1-nbd@nbd.name>
 <20221109163426.76164-9-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109163426.76164-9-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:34:22PM +0100, Felix Fietkau wrote:
> If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
> port netdev, assume that it carries the port number and that there is no DSA
> tag present in the skb data.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/core/flow_dissector.c |  4 +++-
>  net/dsa/dsa.c             | 18 +++++++++++++++++-
>  2 files changed, 20 insertions(+), 2 deletions(-)
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
> index 64b14f655b23..a20440e82dec 100644
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
> @@ -229,7 +231,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>  	if (!skb)
>  		return 0;
>  
> -	nskb = cpu_dp->rcv(skb, dev);
> +	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
> +		unsigned int port = md_dst->u.port_info.port_id;
> +
> +		dsa_default_offload_fwd_mark(skb);
> +		skb_dst_set(skb, NULL);
> +		if (!skb_has_extensions(skb))
> +			skb->slow_gro = 0;

Paolo, does this look okay to you, hand rolled in DSA like that?
Do you see a way in which this would be done automatically once the
metadata dst pointer is unset?

> +
> +		skb->dev = dsa_master_find_slave(dev, 0, port);
> +		if (skb->dev)
> +			nskb = skb;
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
