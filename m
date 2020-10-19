Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D4329254E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgJSKRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJSKRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:17:24 -0400
X-Greylist: delayed 2707 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Oct 2020 03:17:24 PDT
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036EFC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 03:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/f+WMQsaAl/rOsA9iD3d5O3q4AU22NiqeEsNv5VXEco=; b=trorw5B7N3qtHLCshLL1NOyjz7
        9l+VTcHMd3VYwxgxo+9+Rf5bNUs/GQ69v2Mvrvd2vaetcKGCN+sHDp7QBiIqMG73q0wtrfs1SXHAT
        2HFIxhyg0fXUIZ0jSMiq1VtIWXQbH4LS5B5mpsjh3m49OlnUvBp06t2g1u1bbR6xvx8NhEegGjIrb
        Nnx3RSYEJdVEngxHDHK139CrBTM+M30HXyQJTcWq9tVmnmkJ+X5QfxCMbpXTf4ZQkfxh2GeWxNgb2
        eOMb1TGWo7BJq2HaaNrTKZaiPKgTs1tkaoO5YBABD3M0PKvK929ru9p8LU0P1bWZb2ojIZNA7T1rv
        uL5Fg8KQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kURWV-0006zl-0B; Mon, 19 Oct 2020 10:32:11 +0100
Date:   Mon, 19 Oct 2020 10:32:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next,v2 6/9] netfilter: flowtable: use
 dev_fill_forward_path() to obtain egress device
Message-ID: <20201019093208.GE169425@azazel.net>
References: <20201015163038.26992-1-pablo@netfilter.org>
 <20201015163038.26992-7-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20201015163038.26992-7-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-10-15, at 18:30:35 +0200, Pablo Neira Ayuso wrote:
> The egress device in the tuple is obtained from route. Use
> dev_fill_forward_path() instead to provide the real ingress device for
                                                      ^^^^^^^

Should this be "egress"?

> this flow whenever this is available.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: no changes.
>
>  include/net/netfilter/nf_flow_table.h |  4 ++++
>  net/netfilter/nf_flow_table_core.c    |  1 +
>  net/netfilter/nf_flow_table_ip.c      | 25 +++++++++++++++++++++++--
>  net/netfilter/nft_flow_offload.c      |  1 +
>  4 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index ecb84d4358cc..fe225e881cc7 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -117,6 +117,7 @@ struct flow_offload_tuple {
>  	u8				dir;
>  	enum flow_offload_xmit_type	xmit_type:8;
>  	u16				mtu;
> +	u32				oifidx;
>
>  	struct dst_entry		*dst_cache;
>  };
> @@ -164,6 +165,9 @@ struct nf_flow_route {
>  		struct {
>  			u32		ifindex;
>  		} in;
> +		struct {
> +			u32		ifindex;
> +		} out;
>  		struct dst_entry	*dst;
>  	} tuple[FLOW_OFFLOAD_DIR_MAX];
>  };
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 66abc7f287a3..99f01f08c550 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -94,6 +94,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  	}
>
>  	flow_tuple->iifidx = route->tuple[dir].in.ifindex;
> +	flow_tuple->oifidx = route->tuple[dir].out.ifindex;
>
>  	if (dst_xfrm(dst))
>  		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index e215c79e6777..92f444db8d9f 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -228,6 +228,15 @@ static int nf_flow_offload_dst_check(struct dst_entry *dst)
>  	return 0;
>  }
>
> +static struct net_device *nf_flow_outdev_lookup(struct net *net, int oifidx,
> +						struct net_device *dev)
> +{
> +	if (oifidx == dev->ifindex)
> +		return dev;
> +
> +	return dev_get_by_index_rcu(net, oifidx);
> +}
> +
>  static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
>  				      const struct nf_hook_state *state,
>  				      struct dst_entry *dst)
> @@ -267,7 +276,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  	dir = tuplehash->tuple.dir;
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
> -	outdev = rt->dst.dev;
>
>  	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
>  		return NF_ACCEPT;
> @@ -286,6 +294,13 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  		return NF_ACCEPT;
>  	}
>
> +	outdev = nf_flow_outdev_lookup(state->net, tuplehash->tuple.oifidx,
> +				       rt->dst.dev);
> +	if (!outdev) {
> +		flow_offload_teardown(flow);
> +		return NF_ACCEPT;
> +	}
> +
>  	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
>  		return NF_DROP;
>
> @@ -517,7 +532,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	dir = tuplehash->tuple.dir;
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
> -	outdev = rt->dst.dev;
>
>  	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
>  		return NF_ACCEPT;
> @@ -533,6 +547,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  		return NF_ACCEPT;
>  	}
>
> +	outdev = nf_flow_outdev_lookup(state->net, tuplehash->tuple.oifidx,
> +				       rt->dst.dev);
> +	if (!outdev) {
> +		flow_offload_teardown(flow);
> +		return NF_ACCEPT;
> +	}
> +
>  	if (skb_try_make_writable(skb, sizeof(*ip6h)))
>  		return NF_DROP;
>
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 4b476b0a3c88..6a6633e2ceeb 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -84,6 +84,7 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
>  	}
>
>  	route->tuple[!dir].in.ifindex = info.iifindex;
> +	route->tuple[dir].out.ifindex = info.iifindex;
>
>  	return 0;
>  }
> --
> 2.20.1

J.

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+NXRcACgkQonv1GCHZ
79d5Nwv/eVcBMt2cCtGVuctPkGeWbUmU4lwB5FxO2mjdx4Kh8OR3kc1KXPHSXONY
OkCdAvSMEcLbxbTnyPIenHvxQP3JJcpjCu6kpUEbaNSSAalo1DWtQX5l+T/vW1z9
pOvzQrI7iSYw/3MsQr2R7c1mcvIfT5GXr+TEz84OVqAqw4X9O0H95DlrKhMrQa/L
T9Yvqg288OY8srwzNPbr7bSDtrZIwz7hSh7FB2w0ImA4F/ffRMhXIJ+nL4UnniwT
hPrTtSqargUVfi5xM7sxrjubmZtn7fDe1J//Om4kyJ/YPFrVrW7O9r1diVEl9ioE
x1eecMTWE3/PD7Hu45p5EQtLH0w73JXFZ4gWtNwNbtof+8rNNhmlegelxEunLadh
CuqzVGmwWo5PPEU6g2nJxQO2NyaGov66CXFn/fsN5H8KxqIo97AHX2qMw/NA2jlk
9Ia3dkU3ANuH6OXwBOndzc/Ou9Ybd9FHtgU9N/vKuXjmR2tLaIDhMXc/y0kIQ1Go
W1z/MyHV
=xcam
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
