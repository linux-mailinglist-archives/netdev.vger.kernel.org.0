Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3A6EC6D5
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 09:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjDXHPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 03:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDXHPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 03:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ED11AD
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC8AA61E5F
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84422C433EF;
        Mon, 24 Apr 2023 07:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682320545;
        bh=Iud1hUs7ubsgo5WQDp0+63EJtaeCnmW4v/a1jdpI0Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFvdsbnu6YP/dbYyV+jsxaTXDq4TmSpCrEyYzWA8a0qBb7RkLNKxhqA+SmVQ2wlxD
         PJ5OYv5UXTxP4b9LuNkMUcW3HJ0kwQZ7ngqmB0NREwwvpKId+6NvBkbULJj+hdT4qm
         BkaWbH/nJaQihQJCP9xVWa/JLcvIXVrVDFoPGCM+UMnomTUbpQsX5pGlTdxHeBplvu
         +3ttJcsDnZHJU8FP5LR0KIxCszSXbUbKOAW3okxLQCct/HjywoJm9lnjk+/bC0syTh
         1TAhi0dCGbQtllCRXov/7qHO4zax3bplyRrVwvcHdi6+fhYPT0buSjW2ooaTicsU4j
         Df2JdRFunbAaA==
Date:   Mon, 24 Apr 2023 10:15:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Palash Oswal <oswalpalash@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net] sit: update dev->needed_headroom in
 ipip6_tunnel_bind_dev()
Message-ID: <20230424071541.GA10583@unreal>
References: <20230424003414.630339-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424003414.630339-1-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 05:34:14PM -0700, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When a tunnel device is bound with the underlying device, its
> dev->needed_headroom needs to be updated properly. IPv4 tunnels
> already do the same in ip_tunnel_bind_dev().
> 
> Note, this is targeting for -net and -table, so I'd keep the fix
> small. We can refactor and reuse ip_tunnel_bind_dev() for -net-next.

I suggest to put these two lines under --- trailer. There is a little
value of this information in git history.

> 
> Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
> Reported-by: Palash Oswal <oswalpalash@gmail.com>
> Link: https://lore.kernel.org/netdev/CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com/
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/ipv6/sit.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 70d81bba5093..3a8f04ba4947 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1096,11 +1096,12 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
>  static void ipip6_tunnel_bind_dev(struct net_device *dev)
>  {
>  	struct net_device *tdev = NULL;
> -	struct ip_tunnel *tunnel;
> +	struct ip_tunnel *tunnel = netdev_priv(dev);
>  	const struct iphdr *iph;
>  	struct flowi4 fl4;
> +	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
> +	int hlen = LL_MAX_HEADER;

Please continue to use reversed Christmas tree in declaration of
variables.

Thanks

>  
> -	tunnel = netdev_priv(dev);
>  	iph = &tunnel->parms.iph;
>  
>  	if (iph->daddr) {
> @@ -1123,14 +1124,15 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
>  		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
>  
>  	if (tdev && !netif_is_l3_master(tdev)) {
> -		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
>  		int mtu;
>  
>  		mtu = tdev->mtu - t_hlen;
>  		if (mtu < IPV6_MIN_MTU)
>  			mtu = IPV6_MIN_MTU;
>  		WRITE_ONCE(dev->mtu, mtu);
> +		hlen = tdev->hard_header_len + tdev->needed_headroom;
>  	}
> +	dev->needed_headroom = t_hlen + hlen;
>  }
>  
>  static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
> -- 
> 2.34.1
> 
