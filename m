Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A03438DFC
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 06:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhJYEJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 00:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhJYEJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 00:09:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B8EC061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 21:06:45 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id v8so9459973pfu.11
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 21:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GymdKRroj1FAVlvaBNMo/zyk//kRVKqXRyIxvDsJaxY=;
        b=fO1R4TDsZdENrfZIVPu0+QxqHXMxKBUcBlvCiKIcNjvXvqbwmxikdqNec7EBpoNqj9
         ivabdW4JegH1h6QNHNPAOPnO2hLfJQHEAKII3mbL1doNirNOc5msZZuX781LqbEIV1Nh
         ZfzQ1SqCxnxly350lWfo9DQGkI/bVzHQrkA9hDLdUIuRIZF7kDsmNXjQe2XvbI6yKeCI
         rz9dC61huSkYKafxQlvDGvirdLpD8SPalKayh/K3fR1T1VTH0wWYuEx6/2/mIwj/r4i0
         roTu0GR12QLQFBfZ1xTYi/XEDn5NbGMhs7m8bgTC4b2djamos/wmAzbINfxuqy9dpWt+
         itkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GymdKRroj1FAVlvaBNMo/zyk//kRVKqXRyIxvDsJaxY=;
        b=Gki9wPCez0z6Qoqc5PVN/Euu+74qRR5eSXxgiJSMNXkJ/8PXwgI1oIM1bcqOnx0oYP
         Q3lLYDgrLhZ4c8wEEKTSqzRry5PspFchsVUA+m/GZHvA1+pz2LCbLFKr2h20fuPewztF
         z+oeXOo/kyLlqJF2ls4Vegui3mSHAw+OE2a+bmi6+DOFHDVdqjrwaEnt1T2cgbM1RsT9
         3AdMfw4T/LDgklrbCrK1EAVsivh8Cp4EAV4Q07GLZjQd1kSvlxMkG59/bwaVYQ8RV6bv
         9bz7ZbfXA9EOW/Mc7Di4aULAO7sGCZ/nNhz8KGHn6zyiyFcGsZ83kgm8ONTLqMapyndd
         dCtw==
X-Gm-Message-State: AOAM530qW3owRe/tcChRdvMXgsj8kJtYWIdDkt0HdZiemZ9TzoDzi+Ue
        JhYGP1JOae5iNqigOEdCcoRndVhD6gc=
X-Google-Smtp-Source: ABdhPJyR+vaWx/gqQ3Zodo/vxWs7Nc2/CFrwMIfI9H1uhXAiGYIMBzGyIjGH6rFLuhHTZFxM/7Zm6A==
X-Received: by 2002:a62:e90d:0:b0:44d:35a1:e5a0 with SMTP id j13-20020a62e90d000000b0044d35a1e5a0mr16034543pfh.54.1635134804891;
        Sun, 24 Oct 2021 21:06:44 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i2sm20880230pjt.19.2021.10.24.21.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 21:06:44 -0700 (PDT)
Date:   Mon, 25 Oct 2021 12:06:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Xiumei Mu <xmu@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com
Subject: Re: [PATCH net] wireguard: remove peer cache in netns_pre_exit
Message-ID: <YXYtTs/04zZ1SU6f@Laptop-X1>
References: <20210901122904.9094-1-liuhangbin@gmail.com>
 <YS+GX/Y85bch4gMU@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YS+GX/Y85bch4gMU@zx2c4.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

Do you have a schedule to post this patch to upstream?

Thanks
Hangbin
On Wed, Sep 01, 2021 at 03:55:43PM +0200, Jason A. Donenfeld wrote:
> 
> From f9984a41eeaebfdcef5aba8a71966b77ba0de8c0 Mon Sep 17 00:00:00 2001
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Wed, 1 Sep 2021 14:53:39 +0200
> Subject: [PATCH] wireguard: device: reset peer src endpoint when netns exits
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Each peer's endpoint contains a dst_cache entry that takes a reference
> to another netdev. When the containing namespace exits, we take down the
> socket and prevent future sockets from being created (by setting
> creating_net to NULL), which removes that potential reference on the
> netns. However, it doesn't release references to the netns that a netdev
> cached in dst_cache might be taking, so the netns still might fail to
> exit. Since the socket is gimped anyway, we can simply clear all the
> dst_caches (by way of clearing the endpoint src), which will release all
> references.
> 
> However, the current dst_cache_reset function only releases those
> references lazily. But it turns out that all of our usages of
> wg_socket_clear_peer_endpoint_src are called from contexts that are not
> exactly high-speed or bottle-necked. For example, when there's
> connection difficulty, or when userspace is reconfiguring the interface.
> And in particular for this patch, when the netns is exiting. So for
> those cases, it makes more sense to call dst_release immediately. For
> that, we add a small helper function to dst_cache.
> 
> This patch also adds a test to netns.sh from Hangbin Liu to ensure this
> doesn't regress.
> 
> Test-by: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Fixes: 900575aa33a3 ("wireguard: device: avoid circular netns references")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/net/wireguard/device.c             |  3 +++
>  drivers/net/wireguard/socket.c             |  2 +-
>  include/net/dst_cache.h                    | 11 ++++++++++
>  net/core/dst_cache.c                       | 19 +++++++++++++++++
>  tools/testing/selftests/wireguard/netns.sh | 24 +++++++++++++++++++++-
>  5 files changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
> index 551ddaaaf540..77e64ea6be67 100644
> --- a/drivers/net/wireguard/device.c
> +++ b/drivers/net/wireguard/device.c
> @@ -398,6 +398,7 @@ static struct rtnl_link_ops link_ops __read_mostly = {
>  static void wg_netns_pre_exit(struct net *net)
>  {
>  	struct wg_device *wg;
> +	struct wg_peer *peer;
>  
>  	rtnl_lock();
>  	list_for_each_entry(wg, &device_list, device_list) {
> @@ -407,6 +408,8 @@ static void wg_netns_pre_exit(struct net *net)
>  			mutex_lock(&wg->device_update_lock);
>  			rcu_assign_pointer(wg->creating_net, NULL);
>  			wg_socket_reinit(wg, NULL, NULL);
> +			list_for_each_entry(peer, &wg->peer_list, peer_list)
> +				wg_socket_clear_peer_endpoint_src(peer);
>  			mutex_unlock(&wg->device_update_lock);
>  		}
>  	}
> diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
> index 8c496b747108..6f07b949cb81 100644
> --- a/drivers/net/wireguard/socket.c
> +++ b/drivers/net/wireguard/socket.c
> @@ -308,7 +308,7 @@ void wg_socket_clear_peer_endpoint_src(struct wg_peer *peer)
>  {
>  	write_lock_bh(&peer->endpoint_lock);
>  	memset(&peer->endpoint.src6, 0, sizeof(peer->endpoint.src6));
> -	dst_cache_reset(&peer->endpoint_cache);
> +	dst_cache_reset_now(&peer->endpoint_cache);
>  	write_unlock_bh(&peer->endpoint_lock);
>  }
>  
> diff --git a/include/net/dst_cache.h b/include/net/dst_cache.h
> index 67634675e919..df6622a5fe98 100644
> --- a/include/net/dst_cache.h
> +++ b/include/net/dst_cache.h
> @@ -79,6 +79,17 @@ static inline void dst_cache_reset(struct dst_cache *dst_cache)
>  	dst_cache->reset_ts = jiffies;
>  }
>  
> +/**
> + *	dst_cache_reset_now - invalidate the cache contents immediately
> + *	@dst_cache: the cache
> + *
> + *	The caller must be sure there are no concurrent users, as this frees
> + *	all dst_cache users immediately, rather than waiting for the next
> + *	per-cpu usage like dst_cache_reset does. Most callers should use the
> + *	higher speed lazily-freed dst_cache_reset function instead.
> + */
> +void dst_cache_reset_now(struct dst_cache *dst_cache);
> +
>  /**
>   *	dst_cache_init - initialize the cache, allocating the required storage
>   *	@dst_cache: the cache
> diff --git a/net/core/dst_cache.c b/net/core/dst_cache.c
> index be74ab4551c2..0ccfd5fa5cb9 100644
> --- a/net/core/dst_cache.c
> +++ b/net/core/dst_cache.c
> @@ -162,3 +162,22 @@ void dst_cache_destroy(struct dst_cache *dst_cache)
>  	free_percpu(dst_cache->cache);
>  }
>  EXPORT_SYMBOL_GPL(dst_cache_destroy);
> +
> +void dst_cache_reset_now(struct dst_cache *dst_cache)
> +{
> +	int i;
> +
> +	if (!dst_cache->cache)
> +		return;
> +
> +	dst_cache->reset_ts = jiffies;
> +	for_each_possible_cpu(i) {
> +		struct dst_cache_pcpu *idst = per_cpu_ptr(dst_cache->cache, i);
> +		struct dst_entry *dst = idst->dst;
> +
> +		idst->cookie = 0;
> +		idst->dst = NULL;
> +		dst_release(dst);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dst_cache_reset_now);
> diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
> index 2e5c1630885e..8a9461aa0878 100755
> --- a/tools/testing/selftests/wireguard/netns.sh
> +++ b/tools/testing/selftests/wireguard/netns.sh
> @@ -613,6 +613,28 @@ ip0 link set wg0 up
>  kill $ncat_pid
>  ip0 link del wg0
>  
> +# Ensure that dst_cache references don't outlive netns lifetime
> +ip1 link add dev wg0 type wireguard
> +ip2 link add dev wg0 type wireguard
> +configure_peers
> +ip1 link add veth1 type veth peer name veth2
> +ip1 link set veth2 netns $netns2
> +ip1 addr add fd00:aa::1/64 dev veth1
> +ip2 addr add fd00:aa::2/64 dev veth2
> +ip1 link set veth1 up
> +ip2 link set veth2 up
> +waitiface $netns1 veth1
> +waitiface $netns2 veth2
> +ip1 -6 route add default dev veth1 via fd00:aa::2
> +ip2 -6 route add default dev veth2 via fd00:aa::1
> +n1 wg set wg0 peer "$pub2" endpoint [fd00:aa::2]:2
> +n2 wg set wg0 peer "$pub1" endpoint [fd00:aa::1]:1
> +n1 ping6 -c 1 fd00::2
> +pp ip netns delete $netns1
> +pp ip netns delete $netns2
> +pp ip netns add $netns1
> +pp ip netns add $netns2
> +
>  # Ensure there aren't circular reference loops
>  ip1 link add wg1 type wireguard
>  ip2 link add wg2 type wireguard
> @@ -631,7 +653,7 @@ while read -t 0.1 -r line 2>/dev/null || [[ $? -ne 142 ]]; do
>  done < /dev/kmsg
>  alldeleted=1
>  for object in "${!objects[@]}"; do
> -	if [[ ${objects["$object"]} != *createddestroyed ]]; then
> +	if [[ ${objects["$object"]} != *createddestroyed && ${objects["$object"]} != *createdcreateddestroyeddestroyed ]]; then
>  		echo "Error: $object: merely ${objects["$object"]}" >&3
>  		alldeleted=0
>  	fi
> -- 
> 2.32.0
