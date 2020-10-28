Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF73E29D848
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbgJ1WbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387828AbgJ1WbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:31:02 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF400C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:31:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p5so1190535ejj.2
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6a/rtqxIR9X8Q6gTlhMr+Y2aYdl46L9JH2H0LGEUgY=;
        b=lSYtL+odhC9maUHpHBC9gPcKNdzcMZyFIB/C4/F6wegCXt1iFnCpsR01nxzOtyPCvP
         qYSU4gXZTpkVlYioATdRcu85Pv4otiR21UJS9h1ZxhMAmguyFwPVBWvgnQ654oq8r2Ue
         2onXE2s04IathPCQUz7K1Qd1nM2NX4ZCdYs7I68O8WSapzGSx3e+tdBqAf53GUUXinQ0
         8lbcqkKywgh+UVEfqht9h7PfPG3tClaV9EbzEhbaQgDd/BYZJMXsDPv0XIk5FfSt32HS
         Xzy3623P6W+uCGW1TK82mEHK1nZYmA3TlNaQC/dq1QyhgKE5xhMjm68VdgHLFNRdDO9f
         8NRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6a/rtqxIR9X8Q6gTlhMr+Y2aYdl46L9JH2H0LGEUgY=;
        b=tu+IEPPdt/rypNE9CkY5dOyoL/5d4/Q/CxVLUxP135kwKrjxYkiLuefCJB0TlwbTg0
         E/WihYPVq0OpTAzObWkk6N2iVS90IHzQcVUYeATTIitnGH0vZAqXB2sEYdpAs9512k86
         NimkdfgqHL6Al+hkAI+Mh/6vPAjBOiJLTIBMHJKUPCRpBOyrLc8GT8LPDX5n8fQDDqrU
         clUwyFFL1yYoHbpTdVSEcZxakezNCQ8K2av9qTrHrQeApscStQ9A887SLzfZPAryVaeV
         9SGMHn8Taw7Hs3Dje6myGsbCQnkMTdCHP1RNny4HWTTPHyxGk7qbcCjyrAbsWZWfVyvV
         zPpQ==
X-Gm-Message-State: AOAM5315FMjTFnATVZoscseMQekL9lzsAj30o3IXiGHOYx5xo4VojtMd
        l0auo2RDDmgsrmVzlvjJoFVdKv+bKqY=
X-Google-Smtp-Source: ABdhPJxQF0AafqpIJYngZXtq7u/ZD4dXaX76U4AzXyKqKqN/wZUCYQmyQg3Fe9FQk7zYPIa/N0a3Jw==
X-Received: by 2002:aa7:cacb:: with SMTP id l11mr7145688edt.332.1603886716973;
        Wed, 28 Oct 2020 05:05:16 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id i20sm2745836edv.96.2020.10.28.05.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 05:05:16 -0700 (PDT)
Date:   Wed, 28 Oct 2020 14:05:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of packets
 from lag devices
Message-ID: <20201028120515.gf4yco64qlcwoou2@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027105117.23052-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027105117.23052-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:51:17AM +0100, Tobias Waldekranz wrote:
> Packets ingressing on a LAG that egress on the CPU port, which are not
> classified as management, will have a FORWARD tag that does not
> contain the normal source device/port tuple. Instead the trunk bit
> will be set, and the port field holds the LAG id.
> 
> Since the exact source port information is not available in the tag,
> frames are injected directly on the LAG interface and thus do never
> pass through any DSA port interface on ingress.
> 
> Management frames (TO_CPU) are not affected and will pass through the
> DSA port interface as usual.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/dsa.c      | 23 +++++++++++++----------
>  net/dsa/tag_edsa.c | 12 +++++++++++-
>  2 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 2131bf2b3a67..b84e5f0be049 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -220,7 +220,6 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>  	}
>  
>  	skb = nskb;
> -	p = netdev_priv(skb->dev);
>  	skb_push(skb, ETH_HLEN);
>  	skb->pkt_type = PACKET_HOST;
>  	skb->protocol = eth_type_trans(skb, skb->dev);
> @@ -234,17 +233,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>  		skb = nskb;
>  	}
>  
> -	s = this_cpu_ptr(p->stats64);
> -	u64_stats_update_begin(&s->syncp);
> -	s->rx_packets++;
> -	s->rx_bytes += skb->len;
> -	u64_stats_update_end(&s->syncp);
> +	if (dsa_slave_dev_check(skb->dev)) {
> +		p = netdev_priv(skb->dev);
> +		s = this_cpu_ptr(p->stats64);
> +		u64_stats_update_begin(&s->syncp);
> +		s->rx_packets++;
> +		s->rx_bytes += skb->len;
> +		u64_stats_update_end(&s->syncp);
>  
> -	if (dsa_skb_defer_rx_timestamp(p, skb))
> -		return 0;
> -
> -	gro_cells_receive(&p->gcells, skb);
> +		if (dsa_skb_defer_rx_timestamp(p, skb))
> +			return 0;
>  
> +		gro_cells_receive(&p->gcells, skb);
> +	} else {
> +		netif_rx(skb);
> +	}
>  	return 0;
>  }
>  

On one hand, I feel pretty yucky about this change.
On the other hand, I wonder if it might be useful under some conditions
for drivers with DSA_TAG_PROTO_NONE? For example, once the user bridges
all slave interfaces, then that bridge will start being able to send and
receive traffic, despite none of the individual switch ports being able
to do that. Then, you could even go off and bridge a "foreign" interface,
and that would again work properly. That use case is not supported today,
but is very useful.

Thoughts?
