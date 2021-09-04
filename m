Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06F400A8F
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhIDIoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 04:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhIDIoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 04:44:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D1BC061575
        for <netdev@vger.kernel.org>; Sat,  4 Sep 2021 01:43:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v123so1364534pfb.11
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 01:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MyZDsyRp8d7Nz/bpQylF+ViUcJxOfrCc2VN9A8K9j44=;
        b=VfGyNHiQt7CEfxMb907l+bs/Lf0V2asD7g5ugz5FxImufjiA0P52dnovdg+2UOALYU
         rty6SmFDzLQ2dof9nCrqV0X8Anl3p9CbPp/WgxSBQR13x4hJSsLJZDufyVf5Ce4kcbC7
         H7uFKpYcbUXNvTKaN3IB+CmStG1cWO+ymcVs/doz+ujVB3Q/w5oL30uu9wj2T+PGf6uR
         NpIEIEp6d3wt+QhUy/T+8mD9vIs0GS7dOsormAn2aDlmjUq/WE8XGtUiuXkDpbe5CBCr
         MZEknnWFhL/NnoiXvap9OlQMamy1DFbW0H3S9ACWpb7Tmd/suTwPgieYCjiT0EpvwGJG
         /+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MyZDsyRp8d7Nz/bpQylF+ViUcJxOfrCc2VN9A8K9j44=;
        b=jfTKeWHkljWIrkcIFF27dIv3z9CBkjDgWqwtdW+ocKuceFaC70zxU+/sinrvJqMg+T
         kNw2J0SbCa0jOsfLyr1x7nPqQsJwJCEXWgbbD4COD6QivIw5PnBWSFAudg0f/pXqJFrn
         8DGseAODYOvxWuJ8VO9Fv8K1WWBhXZB0WthkzK4FI0EaFH4kE7F2SHbje7IPH2lLlCwy
         8GygCdNegvV7FHIrbnCWGiP/CRVhz1L3QrO8iG+0NscRJHAQLKJjytI2v5fOD1MYv+C6
         AU3TnmENQmAF3bVF3nOqEYYh90Ca3qB9VXyVNCnjqLWIeaVNu6w5+TtOVS0JxBlazaso
         8FcQ==
X-Gm-Message-State: AOAM533R4izt1MdQrpB62usrFQ18ev9hdLkVtYTyL5FZLzACx/ZkqGYO
        4gY8wB9W3PDuvxE7G0J6VR0=
X-Google-Smtp-Source: ABdhPJzT+8yvMGoTBH9a/TuyQ2UQRWeaXd9y0g5hD5S9N9ci4edgz5Ml7WjKJwzsDLs4ngUU0NKaJA==
X-Received: by 2002:a65:44c6:: with SMTP id g6mr2759899pgs.442.1630744995027;
        Sat, 04 Sep 2021 01:43:15 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y8sm1723365pfe.162.2021.09.04.01.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 01:43:14 -0700 (PDT)
Date:   Sat, 4 Sep 2021 16:43:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Xiumei Mu <xmu@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com
Subject: Re: [PATCH net] wireguard: remove peer cache in netns_pre_exit
Message-ID: <YTMxnfkJVA8b6lAV@Laptop-X1>
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

On Wed, Sep 01, 2021 at 03:55:43PM +0200, Jason A. Donenfeld wrote:
> Hi Hangbin,
> 
> Thanks for the patch and especially for the test. While I see that
> you've pointed to a real problem, I don't think that this particular way
> of fixing it is correct, because it will cause issues for userspace that
> expects to be able to read back the list of peers for, for example,
> keeping track of the latest endpoint addresses or rx/tx transfer
> quantities.
> 
> I think the real solution here is to simply clear the endpoint src cache
> and consequently the dst_cache. This is slightly complicated by the fact
> that dst_cache releases dsts lazily, so I needed to add a little utility
> function for that, but that was pretty easy to do.
> 
> Can you take a look at the below patch and let me know if it works for
> you and passes other testing you and Toke might be doing with it? (Also,
> please CC the wireguard mailing list in addition to netdev next time?)
> If the patch looks good to you and works well, I'll include it in the
> next series of wireguard patches I send back out to netdev. I'm back
> from travels next week and will begin working on the next series then.

Hi Jason,

I tested your patch on both physical and virtual machines. All works fine.

So please feel free to add

Tested-by: Hangbin Liu <liuhangbin@gmail.com>

Thanks
Hangbin
> 
> Regards,
> Jason
> 
> ---------8<-------------8<-----------------
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
