Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAD66C404C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCVCXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCVCW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084C5126
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59A9DB816ED
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8539C433D2;
        Wed, 22 Mar 2023 02:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679451774;
        bh=1if7DUbGyPDpCVZKeJHyrgnUuRA2KO1WpcSUFZ8uqZU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FsRCkMSWwD9+YYU3ggUZHCisjy0D/71RpkWX+cPSqeGSFh38VLQC7Ik+1K1FV75e2
         SQxQ3/ogZjdZk9JiroSk++kuezkw/rcOkbLBqFlGrZ3l6ovaTxJnaF7nxaCZhPoFF7
         TRbHUhyh8wIn+rce/f9l7330IuDMSWlM1Z6Fk2YY6vNICZOkl7fAz4K19Q3blD0n5z
         CWoJpJR29womytS+yteYgxTpq8ZNBF+VeiOSLbtnzjMeor6nQ5s3m42/GAio2j5KXT
         ICqmHPDAt8Xk1UUqnulojbeBpNhb2ww2wxNid0OKnjH1hID7EcpCZr1VQ7MTWcMV49
         C2BAoUZY7R8yQ==
Message-ID: <1d6392a2-ae42-ef7f-30b1-bd5d28b1a586@kernel.org>
Date:   Tue, 21 Mar 2023 20:22:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v1 net-next 1/2] ipv6: Remove in6addr_any alternatives.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20230322012204.33157-1-kuniyu@amazon.com>
 <20230322012204.33157-2-kuniyu@amazon.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230322012204.33157-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 7:22 PM, Kuniyuki Iwashima wrote:
> Some code defines the IPv6 wildcard address as a local variable.
> Let's use in6addr_any instead.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
>  include/net/ip6_fib.h                                 |  9 +++------
>  include/trace/events/fib.h                            |  5 ++---
>  include/trace/events/fib6.h                           |  5 +----
>  net/ethtool/ioctl.c                                   |  9 ++++-----
>  net/ipv4/inet_hashtables.c                            | 11 ++++-------
>  6 files changed, 16 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index a108e73c9f66..6a88f6b02678 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -98,7 +98,6 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
>  #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
>  	else if (ip_version == 6) {
>  		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
> -		struct in6_addr zerov6 = {};
>  
>  		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
>  				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
> @@ -106,8 +105,8 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
>  				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
>  		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
>  		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
> -		if (!memcmp(&tun_attr->dst_ip.v6, &zerov6, sizeof(zerov6)) ||
> -		    !memcmp(&tun_attr->src_ip.v6, &zerov6, sizeof(zerov6)))
> +		if (!memcmp(&tun_attr->dst_ip.v6, &in6addr_any, sizeof(in6addr_any)) ||
> +		    !memcmp(&tun_attr->src_ip.v6, &in6addr_any, sizeof(in6addr_any)))

I think ipv6_addr_any can be used here.

>  			return 0;
>  	}
>  #endif
>


> @@ -3233,20 +3232,20 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>  
>  		v6_spec = &fs->h_u.tcp_ip6_spec;
>  		v6_m_spec = &fs->m_u.tcp_ip6_spec;
> -		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
> +		if (memcmp(v6_m_spec->ip6src, &in6addr_any, sizeof(in6addr_any))) {
>  			memcpy(&match->key.ipv6.src, v6_spec->ip6src,
>  			       sizeof(match->key.ipv6.src));
>  			memcpy(&match->mask.ipv6.src, v6_m_spec->ip6src,
>  			       sizeof(match->mask.ipv6.src));
>  		}
> -		if (memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
> +		if (memcmp(v6_m_spec->ip6dst, &in6addr_any, sizeof(in6addr_any))) {
>  			memcpy(&match->key.ipv6.dst, v6_spec->ip6dst,
>  			       sizeof(match->key.ipv6.dst));
>  			memcpy(&match->mask.ipv6.dst, v6_m_spec->ip6dst,
>  			       sizeof(match->mask.ipv6.dst));
>  		}
> -		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr)) ||
> -		    memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
> +		if (memcmp(v6_m_spec->ip6src, &in6addr_any, sizeof(in6addr_any)) ||
> +		    memcmp(v6_m_spec->ip6dst, &in6addr_any, sizeof(in6addr_any))) {

and this group as well.

>  			match->dissector.used_keys |=
>  				BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
>  			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV6_ADDRS] =
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 6edae3886885..74caaa0c148b 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -826,13 +826,11 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
>  				      unsigned short port, int l3mdev, const struct sock *sk)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> -	struct in6_addr addr_any = {};
> -
>  	if (sk->sk_family != tb->family) {
>  		if (sk->sk_family == AF_INET)
>  			return net_eq(ib2_net(tb), net) && tb->port == port &&
>  				tb->l3mdev == l3mdev &&
> -				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> +				ipv6_addr_equal(&tb->v6_rcv_saddr, &in6addr_any);
>  
>  		return false;
>  	}
> @@ -840,7 +838,7 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
>  	if (sk->sk_family == AF_INET6)
>  		return net_eq(ib2_net(tb), net) && tb->port == port &&
>  			tb->l3mdev == l3mdev &&
> -			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> +			ipv6_addr_equal(&tb->v6_rcv_saddr, &in6addr_any);
>  	else
>  #endif
>  		return net_eq(ib2_net(tb), net) && tb->port == port &&

and these 2.


