Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A463C38F4E3
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhEXVbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhEXVbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 17:31:10 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3468AC061574;
        Mon, 24 May 2021 14:29:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id lg14so43921380ejb.9;
        Mon, 24 May 2021 14:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GGESEf9lmFUkc5YKlk7FkF++EFFft31jeoSxOxrbcKw=;
        b=omwOuiZaKPCvNmAF21d1jlHkDm1lQQNferAh6MUhxOBQcCHit3lBmYoWnD8uMcQwQz
         RSw6iClKhB0+EL3HhXHT0hGNDKBz+gqtJmEFSwlf/x8NEyyAnkedXLepea8wWsQrdl5y
         JYu1NOzOMGAGC5bIj1kLoHYo9y/Yzi/vLBtOGmhA6uAWC51qnb3oqjye+++ivb3+ZT3S
         KgLfHqP3z69Y2ctJTqfW1z1YagBweUhYI9+BC/zicmPbsdWG8gbPQa6oXWzaJFWNUVhZ
         vPcYF4bDn+cR5nZMrQqjwUp6byQxgUTdrV0vn+yihE26RLwSXk8J5p3nq2Nw1H3eJdG2
         7d8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GGESEf9lmFUkc5YKlk7FkF++EFFft31jeoSxOxrbcKw=;
        b=pfYBEeggkbt2Ftrqnh9HNdiWXRIvYVhoqJD9fRGohBHn04VeUKcUm/9h0dS0fNhs5M
         0lDDQqH3SOQKHwWxTOkVzZco9TLHpP0f9bNAWaPZZeuAFdl5YzuNOFrh9WBHwuTtn3Ab
         s4lLqRPkXWwOdvtuAC/PYSsdJhzJE8y9gGbFcE/9nSEM7Vx+JAq04ACMoAfRLHT4Ofng
         X8gKrjQIHjm09HEX4sUSLum5eQYXaQBqkvhPW2dXC/PMSj7g1QZPdCStgYFNSQjT5RHg
         MFneUr/PqHvPucXmVqElisbTmYpivqfpCUo41rlTR76V3TrK0oYyPj5cLpcXLmrGuW4F
         9quA==
X-Gm-Message-State: AOAM533ulB/RvJ3xeVdg4yBjXmxK+jjsQV08ibg4x0OYOjG7vNsDxvSS
        AOn++x55Kt0d5TefTsbZWHw=
X-Google-Smtp-Source: ABdhPJzBlB7+AjBxOni8iMGo5aDsaBt4WqwatKJ8fVg6QFvwc7SaQDmXcbWVYtm6JcNL8oBSPMqkBA==
X-Received: by 2002:a17:907:1c0f:: with SMTP id nc15mr25996434ejc.27.1621891779777;
        Mon, 24 May 2021 14:29:39 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id p13sm8213721ejr.87.2021.05.24.14.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:29:39 -0700 (PDT)
Date:   Tue, 25 May 2021 00:29:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        Marco Wenzel <marco.wenzel@a-eberle.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hsr: fix mac_len checks
Message-ID: <20210524212938.jaepbj5qdl3esd4i@skbuf>
References: <20210524185054.65642-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524185054.65642-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Mon, May 24, 2021 at 01:50:54PM -0500, George McCollister wrote:
> Commit 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr
> in fill_frame_info") added the following which resulted in -EINVAL
> always being returned:
> 	if (skb->mac_len < sizeof(struct hsr_ethhdr))
> 		return -EINVAL;
> 
> mac_len was not being set correctly so this check completely broke
> HSR/PRP since it was always 14, not 20.
> 
> Set mac_len correctly and modify the mac_len checks to test in the
> correct places since sometimes it is legitimately 14.
> 
> Fixes: 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info")
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>

pinging works properly now.

>  net/hsr/hsr_device.c  |  2 ++
>  net/hsr/hsr_forward.c | 30 +++++++++++++++++++++---------
>  net/hsr/hsr_forward.h |  8 ++++----
>  net/hsr/hsr_main.h    |  4 ++--
>  net/hsr/hsr_slave.c   | 11 +++++------
>  5 files changed, 34 insertions(+), 21 deletions(-)
> 
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index bfcdc75fc01e..26c32407f029 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -218,6 +218,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  	if (master) {
>  		skb->dev = master->dev;
>  		skb_reset_mac_header(skb);
> +		skb_reset_mac_len(skb);
>  		hsr_forward_skb(skb, master);
>  	} else {
>  		atomic_long_inc(&dev->tx_dropped);
> @@ -259,6 +260,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
>  		goto out;
>  
>  	skb_reset_mac_header(skb);
> +	skb_reset_mac_len(skb);
>  	skb_reset_network_header(skb);
>  	skb_reset_transport_header(skb);
>  
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index 6852e9bccf5b..ceb8afb2a62f 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -474,8 +474,8 @@ static void handle_std_frame(struct sk_buff *skb,
>  	}
>  }
>  
> -void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
> -			 struct hsr_frame_info *frame)
> +int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
> +			struct hsr_frame_info *frame)
>  {
>  	struct hsr_port *port = frame->port_rcv;
>  	struct hsr_priv *hsr = port->hsr;
> @@ -483,20 +483,26 @@ void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  	/* HSRv0 supervisory frames double as a tag so treat them as tagged. */
>  	if ((!hsr->prot_version && proto == htons(ETH_P_PRP)) ||
>  	    proto == htons(ETH_P_HSR)) {
> +		/* Check if skb contains hsr_ethhdr */
> +		if (skb->mac_len < sizeof(struct hsr_ethhdr))
> +			return -EINVAL;
> +
>  		/* HSR tagged frame :- Data or Supervision */
>  		frame->skb_std = NULL;
>  		frame->skb_prp = NULL;
>  		frame->skb_hsr = skb;
>  		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
> -		return;
> +		return 0;
>  	}
>  
>  	/* Standard frame or PRP from master port */
>  	handle_std_frame(skb, frame);
> +
> +	return 0;
>  }
>  
> -void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
> -			 struct hsr_frame_info *frame)
> +int prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
> +			struct hsr_frame_info *frame)
>  {
>  	/* Supervision frame */
>  	struct prp_rct *rct = skb_get_PRP_rct(skb);
> @@ -507,9 +513,11 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  		frame->skb_std = NULL;
>  		frame->skb_prp = skb;
>  		frame->sequence_nr = prp_get_skb_sequence_nr(rct);
> -		return;
> +		return 0;
>  	}
>  	handle_std_frame(skb, frame);
> +
> +	return 0;
>  }
>  
>  static int fill_frame_info(struct hsr_frame_info *frame,
> @@ -519,9 +527,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
>  	struct hsr_vlan_ethhdr *vlan_hdr;
>  	struct ethhdr *ethhdr;
>  	__be16 proto;
> +	int ret;
>  
> -	/* Check if skb contains hsr_ethhdr */
> -	if (skb->mac_len < sizeof(struct hsr_ethhdr))
> +	/* Check if skb contains ethhdr */
> +	if (skb->mac_len < sizeof(struct ethhdr))
>  		return -EINVAL;
>  
>  	memset(frame, 0, sizeof(*frame));
> @@ -548,7 +557,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
>  
>  	frame->is_from_san = false;
>  	frame->port_rcv = port;
> -	hsr->proto_ops->fill_frame_info(proto, skb, frame);
> +	ret = hsr->proto_ops->fill_frame_info(proto, skb, frame);

Nitpick: hsr uses "res", not "ret".

> +	if (ret)
> +		return ret;
> +
>  	check_local_dest(port->hsr, skb, frame);
>  
>  	return 0;
> diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
> index b6acaafa83fc..206636750b30 100644
> --- a/net/hsr/hsr_forward.h
> +++ b/net/hsr/hsr_forward.h
> @@ -24,8 +24,8 @@ struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
>  				       struct hsr_port *port);
>  bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
>  bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
> -void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
> -			 struct hsr_frame_info *frame);
> -void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
> -			 struct hsr_frame_info *frame);
> +int prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
> +			struct hsr_frame_info *frame);
> +int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
> +			struct hsr_frame_info *frame);
>  #endif /* __HSR_FORWARD_H */
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 8f264672b70b..53d1f7a82463 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -186,8 +186,8 @@ struct hsr_proto_ops {
>  					       struct hsr_port *port);
>  	struct sk_buff * (*create_tagged_frame)(struct hsr_frame_info *frame,
>  						struct hsr_port *port);
> -	void (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
> -				struct hsr_frame_info *frame);
> +	int (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
> +			       struct hsr_frame_info *frame);
>  	bool (*invalid_dan_ingress_frame)(__be16 protocol);
>  	void (*update_san_info)(struct hsr_node *node, bool is_sup);
>  };
> diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
> index c5227d42faf5..b70e6bbf6021 100644
> --- a/net/hsr/hsr_slave.c
> +++ b/net/hsr/hsr_slave.c
> @@ -60,12 +60,11 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
>  		goto finish_pass;
>  
>  	skb_push(skb, ETH_HLEN);
> -
> -	if (skb_mac_header(skb) != skb->data) {
> -		WARN_ONCE(1, "%s:%d: Malformed frame at source port %s)\n",
> -			  __func__, __LINE__, port->dev->name);
> -		goto finish_consume;
> -	}
> +	skb_reset_mac_header(skb);
> +	if ((!hsr->prot_version && protocol == htons(ETH_P_PRP)) ||
> +	    protocol == htons(ETH_P_HSR))
> +		skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
> +	skb_reset_mac_len(skb);
>  
>  	hsr_forward_skb(skb, port);
>  
> -- 
> 2.11.0
> 

I admit that I went through both patches and I still don't understand
what is the code path that the original commit 2e9f60932a2c ("net: hsr:
check skb can contain struct hsr_ethhdr in fill_frame_info") is
protecting against. I ran the C reproducer linked by syzbot too and I
did not reproduce it (I did not compile with the linked clang though).
