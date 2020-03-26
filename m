Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8441941AC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgCZOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:38:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:34003 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgCZOiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585233495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ikoFRY4zy3clfc/3+MWqXP9kGHjepx+evrHQxYHj3Qk=;
        b=WVc13qlSC/lWRbxmt3+5JhDxo2uXAeXIMEmcuwItjVdSZGiNQ6qNDN+x9BH9DWQuBrfilv
        JrJaJn5XdEKoABxIuixLb8PT9YYdq5aUJ8B/A6rAH77PVTEdMXfO24n9SS8zoFd8rp8Y3U
        LsPOSXHFb0iRDSCQEPhPoGooe7u/PAw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-E5H3O6bePOyrsPL3RepdAg-1; Thu, 26 Mar 2020 10:38:10 -0400
X-MC-Unique: E5H3O6bePOyrsPL3RepdAg-1
Received: by mail-wr1-f72.google.com with SMTP id t25so772516wrb.16
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ikoFRY4zy3clfc/3+MWqXP9kGHjepx+evrHQxYHj3Qk=;
        b=t9hdm+lBfvC1sQvcWE0uuVhZJ+Y9xdA2hbP7pyIKaJRjSfuizUiD/D8Xd1MJzG+Sbf
         CM0FzK/F8BkFhJrLcEZZnCNipxtunIAQuYQ4a3oC5jRP1QiKL6QyRVTzQDWKuP3UrmG6
         RPJhRW/CQ2VQSE+4mTx7yuSnhX7w0hKk42NjIcciYvKAf8C7kxJ6rdvowOFJYCQQNHHf
         JnPGWRjmYcOapcfGklUp8t3M+CRNSPhYZJoF5dkh7qFX2No4f0lPZ4J+HFzJRa7qql3J
         IDS5yDDKVKDfz0azrPW7TFH94pF7jCx2wWpKcGpvhDsCfkc9f3hFOA8/MXr6At8GF8C3
         IlPw==
X-Gm-Message-State: ANhLgQ3D2iaeP24TkdoAZ3DAQbjRwV2KRRIi0cylPHdZPHwZ2WS182PU
        ni4EKmjJ/T+mJSl0gwz4pSHLR1a0Oy67KDYvji08u6Dp1lHq+9uu0wZ0FPYODlIw56bvXGc7kUR
        nQ9+ctFz9ItTHSmTz
X-Received: by 2002:a1c:bad5:: with SMTP id k204mr267567wmf.162.1585233489735;
        Thu, 26 Mar 2020 07:38:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuuNHduat6ExWFOUTYbdGH19R8sR18OUUL+T5p2xxSPMOQC1VKJxZRQmuXvB5l1CjSy9MUgNw==
X-Received: by 2002:a1c:bad5:: with SMTP id k204mr267553wmf.162.1585233489495;
        Thu, 26 Mar 2020 07:38:09 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id w9sm4278174wrk.18.2020.03.26.07.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:38:08 -0700 (PDT)
Date:   Thu, 26 Mar 2020 15:38:06 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Simon Chopin <s.chopin@alphalink.fr>
Cc:     netdev@vger.kernel.org, Michal Ostrowski <mostrows@earthlink.net>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
Message-ID: <20200326143806.GA31979@pc-3.home>
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326103230.121447-1-s.chopin@alphalink.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 11:32:30AM +0100, Simon Chopin wrote:
> The PPP subsystem uses the abstractions of channels and units, the
> latter being an aggregate of the former, exported to userspace as a
> single network interface.  As such, it keeps traffic statistics at the
> unit level, but there are no statistics on the individual channels,
> partly because most PPP units only have one channel.
> 
> However, it is sometimes useful to have statistics at the channel level,
> for instance to monitor multilink PPP connections. Such statistics
> already exist for PPPoL2TP via the PPPIOCGL2TPSTATS ioctl, this patch
> introduces a very similar mechanism for PPPoE via a new
> PPPIOCGPPPOESTATS ioctl.
> 
I'd rather recomment _not_ using multilink PPP over PPPoE (or L2TP, or
any form of overlay network). But apart from that, I find the
description misleading. PPPoE is not a PPP channel, it _transports_ a
channel. PPPoE might not even be associated with a channel at all,
like in the PPPOX_RELAY case. In short PPPoE stats aren't channel's
stats. If the objective it to get channels stats, then this needs to be
implemented in ppp_generic.c. If what you really want is PPPoE stats,
then see my comments below.

> @@ -395,6 +405,10 @@ static int pppoe_rcv_core(struct sock *sk, struct sk_buff *skb)
>  			goto abort_kfree;
>  	}
>  
> +	stats = sk_pppox(po)->sk_user_data;
> +	atomic_long_inc(&stats->rx_packets);
> +	atomic_long_add(len, &stats->rx_bytes);
> +
>  	return NET_RX_SUCCESS;
>  
You probably need to add counter(s) for the error paths too.

> @@ -549,6 +563,8 @@ static int pppoe_create(struct net *net, struct socket *sock, int kern)
>  	sk->sk_family		= PF_PPPOX;
>  	sk->sk_protocol		= PX_PROTO_OE;
>  
> +	sk->sk_user_data = kzalloc(sizeof(struct pppoe_stats), GFP_KERNEL);
> +
Missing error check.

But please don't use ->sk_user_data for that. We have enough problems
with this pointer, let's not add users that don't actually need it.
See https://lore.kernel.org/netdev/20180117.142538.1972806008716856078.davem@davemloft.net/
for some details.
You can store the counters inside the socket instead.

> @@ -950,6 +993,8 @@ static int __pppoe_xmit(struct sock *sk, struct sk_buff *skb)
>  			po->pppoe_pa.remote, NULL, data_len);
>  
>  	dev_queue_xmit(skb);
> +	atomic_long_inc(&stats->tx_packets);
> +	atomic_long_add(data_len, &stats->tx_bytes);
>  	return 1;
>  
Again, you probably need to count errors too.

