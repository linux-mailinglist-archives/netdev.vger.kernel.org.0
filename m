Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CF229254F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgJSKR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJSKR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:17:28 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542BEC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 03:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FuEOZSgm5H1L5cztLD6TzgbW6piUBLMuJWFSX1u9BpU=; b=gGKxbZ9IfKQ7ctRX6vg55S8egJ
        wZETWsmuorCbCGLwfe/UK6Tz+ZaJ8kRe5uikBrjNj8+hKuFW8VxnegOpG/3RdaIEEt0FKCi1ZdfpG
        89HqUJn7vyAbp+MbgAGzM9NRZxdXNyJ0fZF8oRHdZ+4H5ctDAutOMRbhRTXtJzjTPA6co70jgN31t
        xmhcMTswZfPbfVR9lDKOorVjHOjfzMf0sJ/EtieI1cMtvyRseJEJ6kITE7Dk2wkd+li7CLcacJC9t
        4nRjzNZORLeDgkGXd6RltChCC5goBnh8UdCAsb5HcvSnPBs+BEApVWsJxX/p4TzEntQokSM2Frj/r
        lZHlTp0w==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kURWk-00070C-Qe; Mon, 19 Oct 2020 10:32:26 +0100
Date:   Mon, 19 Oct 2020 10:32:25 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next,v2 8/9] netfilter: flowtable: bridge port support
Message-ID: <20201019093225.GF169425@azazel.net>
References: <20201015163038.26992-1-pablo@netfilter.org>
 <20201015163038.26992-9-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <20201015163038.26992-9-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-10-15, at 18:30:37 +0200, Pablo Neira Ayuso wrote:
> Update hardware destination address to the master bridge device to
> emulate the forwarding behaviour.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: no changes.
>
>  include/net/netfilter/nf_flow_table.h | 1 +
>  net/netfilter/nf_flow_table_core.c    | 4 ++++
>  net/netfilter/nft_flow_offload.c      | 6 +++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 1b57d1d1270d..4ec3f9bb2f32 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -172,6 +172,7 @@ struct nf_flow_route {
>  			u32		ifindex;
>  			u8		h_source[ETH_ALEN];
>  			u8		h_dest[ETH_ALEN];
> +			enum flow_offload_xmit_type xmit_type;
>  		} out;
>  		struct dst_entry	*dst;
>  	} tuple[FLOW_OFFLOAD_DIR_MAX];
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 725366339b85..e80dcabe3668 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -100,6 +100,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>
>  	if (dst_xfrm(dst))
>  		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
> +	else
> +		flow_tuple->xmit_type = route->tuple[dir].out.xmit_type;
> +
> +	flow_tuple->dst_cache = dst;
>
>  	flow_tuple->dst_cache = dst;

Accidentally duplicated assignment?

> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index d440e436cb16..9efb5d584290 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -54,6 +54,7 @@ struct nft_forward_info {
>  	u32 iifindex;
>  	u8 h_source[ETH_ALEN];
>  	u8 h_dest[ETH_ALEN];
> +	enum flow_offload_xmit_type xmit_type;
>  };
>
>  static int nft_dev_forward_path(struct nf_flow_route *route,
> @@ -83,7 +84,9 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
>  		case DEV_PATH_VLAN:
>  			return -1;
>  		case DEV_PATH_BRIDGE:
> -			return -1;
> +			memcpy(info.h_dest, path->dev->dev_addr, ETH_ALEN);
> +			info.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> +			break;
>  		}
>  	}
>
> @@ -91,6 +94,7 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
>  	memcpy(route->tuple[dir].out.h_dest, info.h_source, ETH_ALEN);
>  	memcpy(route->tuple[dir].out.h_source, info.h_dest, ETH_ALEN);
>  	route->tuple[dir].out.ifindex = info.iifindex;
> +	route->tuple[dir].out.xmit_type = info.xmit_type;
>
>  	return 0;
>  }
> --
> 2.20.1

J.

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+NXSkACgkQonv1GCHZ
79dfdQv/fgPi1Zh25jhaTI8uPjNvAoPCgMHwCFIxq/2EbtUpUK9lTDhmbfNQi5QE
v0JQb0vNdC6jV/bUiTDbgTWtedhESrpxP5pkoc1j8P16R7Rx1PY1b+ZBTXS7nXf7
DXWzBMRSLOrTdSQ2LPLMZRiR88LnkWKqdBVpxney56+A4m6sPQDCoGURLtD42xYe
GgMGncKxcFSbAh7TBgC9+ZZheLukHNh8h9suxaLlFBOGXjebHp1JmS/pKlwsbLoB
5KHir10S+c/kGaXsZcFvWYEp8fQ3EmN0qA4IJe2wq3fCpEJ9frZDRQgDP1QfXO2l
Q5KYDvn5e5tpHzgbpmv2vRJOwz6bW8rln3Gy0dHaiqWuVNcwo7u5EZ//I8eiKm/B
dgcHxrTiD43HKy35+vO60cqgzu5SYQUzmYO8BMXSv/1B7gv6dK2WdB1+F8FjWJuu
9J/d0hZ9pYUoOKhLRvOk90GliixG9wCX66VF9xlfIwTHogazqpAFX52lDq5pzX9e
y9YYWuZh
=UHob
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
