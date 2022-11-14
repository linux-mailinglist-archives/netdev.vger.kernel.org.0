Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A4E627D75
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiKNMPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiKNMPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:15:12 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725711AF13;
        Mon, 14 Nov 2022 04:15:11 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 21so17029332edv.3;
        Mon, 14 Nov 2022 04:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R7AibfKdA/kj3rXGnhHOngWCohzwLHEJ9wgvCbDtklY=;
        b=JRlxOk4VrIBjIJXzsPhnbBZqefuozzxJW/lgGqD7Jmot2+7R+93p09KgnsL+LaV7YI
         K8/nHtx+9FQs6oUqxtMy1Oas5SqOULAXD1AtYGeczSzS1tSFRHx7IOUymD9grdmXGkbm
         83t88vm6Ok4O8c5mGMY4PA2bY+qNpj+N7LwnxFuJugYx7bFT+va6kZFM0+HmUJUU2lav
         TrrEytlzWoZKH82h/97/GPL8eysYI/Z9lT9H3xw3pmn47lSzuEXIguCEov/KaPH+0/xz
         o9zY4nKo3p/y7EKTFSOpMuPdAgPw6vkwqr6IVOh4cg1lNDyvs+1tjdrfZScRB3rHuXHH
         0iAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7AibfKdA/kj3rXGnhHOngWCohzwLHEJ9wgvCbDtklY=;
        b=Mcyczm0Kh6r9KcHLoT9ZhqqoF7E5V2XGTGqSdSWiBs555EWWV1+wMFUk+7l1tQ+az0
         vc5gYDDrkfLDHh85+S8mH2QSSg94nJurloom/PU4VCsjwBFwDV8kDrmJW0JSjhucxXji
         woizg/Jx9rsCJfq6lEkJ3GgnqWUgEhaVIiYybqwI+6LHLGVIXXGOn7mLJkTqMWYXz9oG
         Kbj+vXvfCOIEW1aOJPYdYYdttzF2j5HXG950KACjzUNWuGMznALEmbm4/TtczRO/CgX/
         qeyZVZ9DcTOOiFWnRZCBkFk3ieVI/vEnd3NdtSyjVNvzahZVlnrwolsUhEXUva/sFli0
         H+yg==
X-Gm-Message-State: ANoB5plXyxPSaxKbF6p31JAishPtxDUdfqSGj08DoKM5YPjxe2pdsHgH
        0pr6NnZhie7cul3lzkfaShE=
X-Google-Smtp-Source: AA0mqf4Gm6HqGby2BLSDLEV0J5FxxIpb50mEJ3Eu+60VylBmB/nzcX/Ow28dYIC1Qqc9ruW8tSveIA==
X-Received: by 2002:aa7:d38b:0:b0:467:71de:fe10 with SMTP id x11-20020aa7d38b000000b0046771defe10mr9452720edq.63.1668428109729;
        Mon, 14 Nov 2022 04:15:09 -0800 (PST)
Received: from skbuf ([188.27.184.37])
        by smtp.gmail.com with ESMTPSA id ly23-20020a170906af5700b007a0b28c324dsm4077152ejb.126.2022.11.14.04.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 04:15:09 -0800 (PST)
Date:   Mon, 14 Nov 2022 14:15:07 +0200
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
Message-ID: <20221114121507.44bdem4q2pdrkn5r@skbuf>
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

Since you're resending, could you please preserve reverse Christmas tree
variable ordering here?

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
