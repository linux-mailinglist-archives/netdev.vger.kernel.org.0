Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC945A107
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhKWLNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:13:07 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43533 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234250AbhKWLNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:13:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E5FF5C023C;
        Tue, 23 Nov 2021 06:09:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Nov 2021 06:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RZZmGZ
        o6hxlB3LWIz7vJN/EDb9BFZamP+Fs++n5u3wo=; b=R4274JmJimsfUCpRNugRxH
        SB07C0o7JuFUF2FKD9j0zb5h3xO9as89+XE+smahMufgwRYP4XK8Nds4/gD0mFIl
        2R2b2RBB1OC6gaRXi0Ah7Cfg3L+ySv0NCEyIhHEXgcfvICFg4hexA1U79MCeECTb
        IaXNbwov9BU1A+Vuza2E99R2hv7bpta99lCV/bv3V0agxwcAzWKGwuuUhacqVWCI
        4aO6fDFjEJTHt9UC44OHK9E9jNUUwXyclemMyFN/8cIqK11pLLex6Rajf1EJ/IrR
        FtaJIJV3CKQKmara3jTeYKbclaosMORmNuXP+avtX9jN0ENwC09okgEpvnexq8xg
        ==
X-ME-Sender: <xms:BsycYSrHtBm1sm4gnAVql8YU4j3HLsCS-xyNKEUkdzHDaEvW080t-g>
    <xme:BsycYQqllqsENG1AleoVBrA0kS9nQmhN1DtWgEZravyEQO_w9l0H35lHE2mDuzwtr
    naw2E0UkKGQQX4>
X-ME-Received: <xmr:BsycYXOZAzB4tKzA79lXme_tPCbryE7kc1IPaQWev72lBNlMu8iDmvu886qweZz99rMOAj9i31Lwd62e0Ng3k0WuJdn6iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BsycYR4UTSI4VBl_tAlHg1pf1DYarPRCO3m0uBW52pUVSsmDia6l2A>
    <xmx:BsycYR5J0KYNgYosvzl0a7Kgywpci_9Jk-iH5u_XCLNVBtqTZNb5rg>
    <xmx:BsycYRiy7hQYQ2JByhx7V447LgNItW5aC2G6x8RRagnLat0fffoAtw>
    <xmx:BsycYU0-iK7e6xVp9qjiV9XMXAGOPEqJWCxt913s5NHZDRmXtA-6Mg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 06:09:57 -0500 (EST)
Date:   Tue, 23 Nov 2021 13:09:54 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: nexthop: fix null pointer dereference when IPv6
 is not enabled
Message-ID: <YZzMAgIKFsCRjgc/@shredder>
References: <20211123102719.3085670-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123102719.3085670-1-razor@blackwall.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:27:19PM +0200, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When we try to add an IPv6 nexthop and IPv6 is not enabled
> (!CONFIG_IPV6) we'll hit a NULL pointer dereference[1] in the error path
> of nh_create_ipv6() due to calling ipv6_stub->fib6_nh_release. The bug
> has been present since the beginning of IPv6 nexthop gateway support.
> Commit 1aefd3de7bc6 ("ipv6: Add fib6_nh_init and release to stubs") tells
> us that only fib6_nh_init has a dummy stub because fib6_nh_release should
> not be called if fib6_nh_init returns an error, but the commit below added
> a call to ipv6_stub->fib6_nh_release in its error path. To fix it return
> the dummy stub's -EAFNOSUPPORT error directly without calling
> ipv6_stub->fib6_nh_release in nh_create_ipv6()'s error path.

[...]

> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index a69a9e76f99f..5dbd4b5505eb 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -2565,11 +2565,15 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>  	/* sets nh_dev if successful */
>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>  				      extack);
> -	if (err)
> +	if (err) {
> +		/* IPv6 is not enabled, don't call fib6_nh_release */
> +		if (err == -EAFNOSUPPORT)
> +			goto out;
>  		ipv6_stub->fib6_nh_release(fib6_nh);

Is the call actually necessary? If fib6_nh_init() failed, then I believe
it should clean up after itself and not rely on fib6_nh_release().

> -	else
> +	} else {
>  		nh->nh_flags = fib6_nh->fib_nh_flags;
> -
> +	}
> +out:
>  	return err;
>  }
>  
> -- 
> 2.31.1
> 
