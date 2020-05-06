Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A151C662A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgEFC76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 22:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgEFC76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 22:59:58 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB57C061A0F;
        Tue,  5 May 2020 19:59:57 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 72so241358otu.1;
        Tue, 05 May 2020 19:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R8OfJcL03ZVKKC+qkqVrMfny/dWWpOW7UltiZCGWxj0=;
        b=SiNzSu2XJ+DTcUckHlKOf2fY4CoLS/4ZMWbNOffh1x0Il1O/NmXUlQkSmu2V11wz1F
         cahO/IhAmZNlt4n2t2GwAk4Gd1jqmPKjwPiSdT6TfkJK5UCYGPqUgOAICq++uUbhVIEc
         OmkVK8BRx1p7MvST1mUzjMX/WQdZNObuhgCm1ynkujQQlVPsI0on9Q0UDaZh8zR/Ph7l
         6/x7Dx7P2N1aMjyy5C4Dj2IjX92qtNPfjFj5ElOV9IKRadFcYzIA5Cbp8bbOttZ0pS2Z
         aAu/3CCOP/GkxRxSxPY7XirMu8PwjMdGbh9EagPDZMbWkkYP/iKi7aqLWNqjNoD+EmF7
         UzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R8OfJcL03ZVKKC+qkqVrMfny/dWWpOW7UltiZCGWxj0=;
        b=ts9MDZKiobDGQm6bDii+VvFCTrElJil6KLKw6rdvPgdvgUVZa6peaPd29PKn/Vs133
         r51rbyiZZmc8QO6KqV3kgaSk+lWejjisH0txIyS0n9QG35fz/0UAC1eQa7bZ62jvrdby
         IXZtoqF8EiU0P5oGUuVeMACtUbl0GGuENFqI4tbHn065Rf4kfm3dH9v/JG3lamKo70y9
         kg7d+sMM46G/h/bWbd1CAV2Yt1tyFVgc37SxEP4eVAAUJ28rIdhgQk9EjItqeErIBCau
         e+khB5G/z4crLhSrqVCrzCwvB1gD6pSnEqzL3F3eQwup09bP4xOigybBrVzYgr5VZcLg
         eELA==
X-Gm-Message-State: AGi0PuZc4gPdRqYv/UnLbfkx2cPBLEcPeZzZaf9sBfL8n/UV6o9R4you
        kD49ukCO2dWJ+DEDiwevex0=
X-Google-Smtp-Source: APiQypIAyAyQ1jlj+HEDPTj1EThQG4vTHZGBN0E4XP3OcY6QQWCaPMoxHGyDBCNi2JAe9RN546uykg==
X-Received: by 2002:a05:6830:1c65:: with SMTP id s5mr4901124otg.60.1588733997134;
        Tue, 05 May 2020 19:59:57 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id m12sm141386oov.41.2020.05.05.19.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 19:59:56 -0700 (PDT)
Date:   Tue, 5 May 2020 19:59:55 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: bareudp: avoid uninitialized variable warning
Message-ID: <20200506025955.GA433288@ubuntu-s3-xlarge-x86>
References: <20200505172232.1034560-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505172232.1034560-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 07:22:14PM +0200, Arnd Bergmann wrote:
> clang points out that building without IPv6 would lead to returning
> an uninitialized variable if a packet with family!=AF_INET is
> passed into bareudp_udp_encap_recv():
> 
> drivers/net/bareudp.c:139:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (family == AF_INET)
>             ^~~~~~~~~~~~~~~~~
> drivers/net/bareudp.c:146:15: note: uninitialized use occurs here
>         if (unlikely(err)) {
>                      ^~~
> include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
>  # define unlikely(x)    __builtin_expect(!!(x), 0)
>                                             ^
> drivers/net/bareudp.c:139:2: note: remove the 'if' if its condition is always true
>         if (family == AF_INET)
>         ^~~~~~~~~~~~~~~~~~~~~~
> 
> This cannot happen in practice, so change the condition in a way that
> gcc sees the IPv4 case as unconditionally true here.
> For consistency, change all the similar constructs in this file the
> same way, using "if(IS_ENABLED())" instead of #if IS_ENABLED()".
> 
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/bareudp.c    | 18 ++++--------------
>  include/net/udp_tunnel.h |  2 --
>  2 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index cc0703c3d57f..efd1a1d1f35e 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -136,25 +136,21 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>  	oiph = skb_network_header(skb);
>  	skb_reset_network_header(skb);
>  
> -	if (family == AF_INET)
> +	if (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
>  		err = IP_ECN_decapsulate(oiph, skb);
> -#if IS_ENABLED(CONFIG_IPV6)
>  	else
>  		err = IP6_ECN_decapsulate(oiph, skb);
> -#endif
>  
>  	if (unlikely(err)) {
>  		if (log_ecn_error) {
> -			if  (family == AF_INET)
> +			if  (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
>  				net_info_ratelimited("non-ECT from %pI4 "
>  						     "with TOS=%#x\n",
>  						     &((struct iphdr *)oiph)->saddr,
>  						     ((struct iphdr *)oiph)->tos);
> -#if IS_ENABLED(CONFIG_IPV6)
>  			else
>  				net_info_ratelimited("non-ECT from %pI6\n",
>  						     &((struct ipv6hdr *)oiph)->saddr);
> -#endif
>  		}
>  		if (err > 1) {
>  			++bareudp->dev->stats.rx_frame_errors;
> @@ -350,7 +346,6 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>  	return err;
>  }
>  
> -#if IS_ENABLED(CONFIG_IPV6)
>  static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>  			     struct bareudp_dev *bareudp,
>  			     const struct ip_tunnel_info *info)
> @@ -411,7 +406,6 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>  	dst_release(dst);
>  	return err;
>  }
> -#endif
>  
>  static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
> @@ -435,11 +429,9 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
>  	}
>  
>  	rcu_read_lock();
> -#if IS_ENABLED(CONFIG_IPV6)
> -	if (info->mode & IP_TUNNEL_INFO_IPV6)
> +	if (IS_ENABLED(CONFIG_IPV6) && info->mode & IP_TUNNEL_INFO_IPV6)
>  		err = bareudp6_xmit_skb(skb, dev, bareudp, info);
>  	else
> -#endif
>  		err = bareudp_xmit_skb(skb, dev, bareudp, info);
>  
>  	rcu_read_unlock();
> @@ -467,7 +459,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
>  
>  	use_cache = ip_tunnel_dst_cache_usable(skb, info);
>  
> -	if (ip_tunnel_info_af(info) == AF_INET) {
> +	if (!IS_ENABLED(CONFIG_IPV6) || ip_tunnel_info_af(info) == AF_INET) {
>  		struct rtable *rt;
>  		__be32 saddr;
>  
> @@ -478,7 +470,6 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
>  
>  		ip_rt_put(rt);
>  		info->key.u.ipv4.src = saddr;
> -#if IS_ENABLED(CONFIG_IPV6)
>  	} else if (ip_tunnel_info_af(info) == AF_INET6) {
>  		struct dst_entry *dst;
>  		struct in6_addr saddr;
> @@ -492,7 +483,6 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
>  
>  		dst_release(dst);
>  		info->key.u.ipv6.src = saddr;
> -#endif
>  	} else {
>  		return -EINVAL;
>  	}
> diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
> index 4b1f95e08307..e7312ceb2794 100644
> --- a/include/net/udp_tunnel.h
> +++ b/include/net/udp_tunnel.h
> @@ -143,14 +143,12 @@ void udp_tunnel_xmit_skb(struct rtable *rt, struct sock *sk, struct sk_buff *skb
>  			 __be16 df, __be16 src_port, __be16 dst_port,
>  			 bool xnet, bool nocheck);
>  
> -#if IS_ENABLED(CONFIG_IPV6)
>  int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
>  			 struct sk_buff *skb,
>  			 struct net_device *dev, struct in6_addr *saddr,
>  			 struct in6_addr *daddr,
>  			 __u8 prio, __u8 ttl, __be32 label,
>  			 __be16 src_port, __be16 dst_port, bool nocheck);
> -#endif
>  
>  void udp_tunnel_sock_release(struct socket *sock);
>  
> -- 
> 2.26.0
> 
