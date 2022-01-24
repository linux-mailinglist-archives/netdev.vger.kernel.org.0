Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B8C498740
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbiAXRvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:51:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241573AbiAXRvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643046663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XXLqqvkl2WnqmUcF9sdvORyv1rSQivT9oTXnBtAWkms=;
        b=igKjfbeFS/7Om9ZawY5ZxOoNlvyOAuogbQQ+d77vAU+SOTr3vsrJU4r0cHMGn4CoVyyGx8
        59FVZ9Ioj2FaYrvugMGOfCZHytQCWl4AsAJrA54RHzyT6RcvoNi6SNVnV6Ksb6BEiR0yIe
        HE0jqCZ4p+1kL9+AIy6xLH2kHkHF0oc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-T5n1AYEAMLirNItm3b2YHw-1; Mon, 24 Jan 2022 12:51:01 -0500
X-MC-Unique: T5n1AYEAMLirNItm3b2YHw-1
Received: by mail-ej1-f72.google.com with SMTP id h22-20020a1709060f5600b006b11a2d3dcfso2404131ejj.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:51:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XXLqqvkl2WnqmUcF9sdvORyv1rSQivT9oTXnBtAWkms=;
        b=PR9zWALCbX6w8ZU7KJ0XpzlfeFzF5dnJ7VuNAbs9xOzZHByCkfoZqu7RG6ok2ONuVV
         OfNGXrfwRVBlag250EnJVTBS5b49jvyfKYYTOOrzDENwYkXUfA/ls3GMuvirh6LKJg3T
         5hhLfs461WQhtxoSPleVxJj5q2NY4TgHWVxywM3dXrc18rPJL3RLpJY1KffaRDoVVYjs
         fp8Cb9ojNddz3wh6Guu9PMT8vDEbGcvUfVuixfx6M1FbRBcpmDVlAKKmBcbo8Hb/bJdv
         ZisBDQid+gfEt1Vj3YrEEKPF5i8H4RSOFQbSMV5cYHzqEX/6cx7NsiYW1SR+HiX0yUem
         EuPA==
X-Gm-Message-State: AOAM530FFFW2vT6Lnc+6Nz5SWwtzz4d9HwEatoOieZ79vtLtSMBFAqK+
        tBsyU7FPOQxmehRiIEaZ9Ju5yuzQvDYPNyIC2qHpeJXj5fFsbbPYcQiQ7Fp5PMHhOjrQ/4e2+Rc
        3b87EmvHgBoOdQ2c1
X-Received: by 2002:a17:907:2d0c:: with SMTP id gs12mr7135617ejc.165.1643046659500;
        Mon, 24 Jan 2022 09:50:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0qQQWkHXyLNHj6NIOtHYXa1eK6SAY2pgvS4o4LZPiCL9JJ6OVR8m+3n0gl8QXjd1lfyecBw==
X-Received: by 2002:a17:907:2d0c:: with SMTP id gs12mr7135554ejc.165.1643046658452;
        Mon, 24 Jan 2022 09:50:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f3sm5160783eja.139.2022.01.24.09.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:50:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4395D1805FB; Mon, 24 Jan 2022 18:50:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, memxor@gmail.com,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
In-Reply-To: <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 Jan 2022 18:50:57 +0100
Message-ID: <878rv558fy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ snip to focus on the API ]

> +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> +				  struct bpf_fdb_lookup *opt,
> +				  u32 opt__sz)
> +{
> +	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
> +	struct net_bridge_port *port;
> +	struct net_device *dev;
> +	int ret = -ENODEV;
> +
> +	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
> +	if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
> +		return -ENODEV;

Why is the BUILD_BUG_ON needed? Or why is the NF_BPF_FDB_OPTS_SZ
constant even needed?

> +	rcu_read_lock();

This is not needed when the function is only being called from XDP...

> +
> +	dev = dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
> +	if (!dev)
> +		goto out;
> +
> +	if (unlikely(!netif_is_bridge_port(dev)))
> +		goto out;
> +
> +	port = br_port_get_check_rcu(dev);
> +	if (unlikely(!port || !port->br))
> +		goto out;
> +
> +	dev = __br_fdb_find_port(port->br->dev, opt->addr, opt->vid, true);
> +	if (dev)
> +		ret = dev->ifindex;
> +out:
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
>  					     const unsigned char *addr,
>  					     __u16 vid)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2661dda1a92b..64d4f1727da2 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -18,6 +18,7 @@
>  #include <linux/if_vlan.h>
>  #include <linux/rhashtable.h>
>  #include <linux/refcount.h>
> +#include <linux/bpf.h>
>  
>  #define BR_HASH_BITS 8
>  #define BR_HASH_SIZE (1 << BR_HASH_BITS)
> @@ -2094,4 +2095,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
>  void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
>  		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
>  struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *m);
> +
> +#define NF_BPF_FDB_OPTS_SZ	12
> +struct bpf_fdb_lookup {
> +	u8	addr[ETH_ALEN]; /* ETH_ALEN */
> +	u16	vid;
> +	u32	ifindex;
> +};

It seems like addr and ifindex should always be required, right? So why
not make them regular function args? That way the ptr to eth addr could
be a ptr directly to the packet header (saving a memcpy), and the common
case(?) could just pass a NULL opts struct?

> +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> +				  struct bpf_fdb_lookup *opt,
> +				  u32 opt__sz);

It should probably be documented that the return value is an ifindex as
well; I guess one of the drawbacks of kfunc's relative to regular
helpers is that there is no convention for how to document their usage -
maybe we should fix that before we get too many of them? :)

-Toke

