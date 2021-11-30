Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9554634B2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhK3MoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:44:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48741 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233214AbhK3Mnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:43:51 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A2B615C0159;
        Tue, 30 Nov 2021 07:40:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 30 Nov 2021 07:40:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QCHOd9
        2dM869D2T5RL+O+MzCHcXJGkL4GtMjdkZfa8w=; b=FLbT7tqu7kGr0nrd/ValYe
        f+81GPxU397MRe1na/WMmAlq6ygQlbvAp6iO0nkm9YtyJVvIMIClp8cXrW3NZqcp
        SXluX2QA4tETQxPRM/A6n959SLCVf9w4/ZJB1etEoT9uejuCGrdEJV9Jp03IhgcE
        jckKMkcoZK0MvEbdCj1QWCkynG6gsH7JXzp1yxr80r5fakADeWjlRjeWrEuvKfeP
        cs2TCg4O0Nz4jl7AE0v4ekhWznzAiya6YCAzMMHaHB/pUfN+Hh/vAIU3su6+a347
        Ow77N0NchPEQpoqk2Rg+uZUfGHTP/tS4zu6L6hDcXziqiybUTJzOoqugmdErPzTw
        ==
X-ME-Sender: <xms:vhumYWOz7rKe3AMrlEZNoKvlj3z6S45xxQiMihzt6w4oucaQRJGCYA>
    <xme:vhumYU9vBybTCsrun1xMweNfPyKWqn8gj9s2zgszNiTxhB-y5j5Xfz4jqsncc94YH
    d1LPbxZUTN__VI>
X-ME-Received: <xmr:vhumYdS2X_UxQ5GuoSabB9apPKsioYCQ7r6j4k765OffhT2aXu0ZYcsIJgiTgyz7biGpeWD1z0YLRZ4u4yXj8uKTE97dzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedugdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdejuedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vhumYWu8ViBAegOYjaLspTMmoOrWSrZ67vvIZc1Z8bHaw50K0N5-Dw>
    <xmx:vhumYecfHmuQZHYO1EhYRYlGwgVl1aDFW2n6YzDffZee0tfl0476mg>
    <xmx:vhumYa27V-jXsU7W6DTOjXyBcVeaE-SFKBBqKiDEhizewQwFLwN3BA>
    <xmx:vhumYe4JiemFPGhHIgpfb_Z5yXCFrVC6kFhk7MguTloopeY2lODojg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 07:40:29 -0500 (EST)
Date:   Tue, 30 Nov 2021 14:40:26 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH net] net: ipv6: make fib6_nh_init properly clean
 after itself on error
Message-ID: <YaYbusXHbVQUXpmB@shredder>
References: <20211129141151.490533-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129141151.490533-1-razor@blackwall.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 04:11:51PM +0200, Nikolay Aleksandrov wrote:
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 5dbd4b5505eb..a7debafe8b90 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>  	/* sets nh_dev if successful */
>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>  				      extack);
> -	if (err) {
> -		/* IPv6 is not enabled, don't call fib6_nh_release */
> -		if (err == -EAFNOSUPPORT)
> -			goto out;
> -		ipv6_stub->fib6_nh_release(fib6_nh);
> -	} else {
> +	if (!err)
>  		nh->nh_flags = fib6_nh->fib_nh_flags;
> -	}
>  out:
>  	return err;
>  }

This hunk looks good

> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 42d60c76d30a..2107b13cc9ab 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
>  		in6_dev_put(idev);
>  
>  	if (err) {
> -		lwtstate_put(fib6_nh->fib_nh_lws);
> +		/* check if we failed after fib_nh_common_init() was called */
> +		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
> +			fib_nh_common_release(&fib6_nh->nh_common);
>  		fib6_nh->fib_nh_lws = NULL;
>  		dev_put(dev);
>  	}

Likewise

> @@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>  	} else {
>  		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
>  		if (err)
> -			goto out;
> +			goto out_free;
>  
>  		fib6_nh = rt->fib6_nh;
>  
> @@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>  		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
>  			NL_SET_ERR_MSG(extack, "Invalid source address");
>  			err = -EINVAL;
> -			goto out;
> +			goto out_free;
>  		}
>  		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
>  		rt->fib6_prefsrc.plen = 128;
> @@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
>  		rt->fib6_prefsrc.plen = 0;
>  
>  	return rt;
> -out:
> -	fib6_info_release(rt);
> -	return ERR_PTR(err);
> +
>  out_free:
>  	ip_fib_metrics_put(rt->fib6_metrics);
> +	if (rt->nh)
> +		nexthop_put(rt->nh);

Shouldn't this be above ip_fib_metrics_put() given nexthop_get() is
called after ip_fib_metrics_init() ?

Also, shouldn't we call fib6_nh_release() if fib6_nh_init() succeeded
and we failed later?

>  	kfree(rt);
> +out:
>  	return ERR_PTR(err);
>  }
>  
> -- 
> 2.31.1
> 
