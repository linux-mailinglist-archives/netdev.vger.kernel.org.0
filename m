Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCAD5A9531
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiIAK5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiIAK5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:57:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417721EAFD
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 03:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662029859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51i11sEBzsSHk6c+w7JC0/rienuf6fXcNzu3mm3/VRo=;
        b=GW38YskPCFvIcdRziFl16uptDSIBqz867cIl2xmPcvO5Q5sZczun3pbmBR8/rWhYiYhnOG
        TqTRXRKrQd7Bbv3snbmn19FUdTmkIU8ok1fY+lpzBK4UD0KfOGSRyLebzABi832UiwRHCO
        36CBOXxtkAQKJ+09qN+Ubi2Hou49Yiw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-Qit6tM4cOf-AhBE-frLu3w-1; Thu, 01 Sep 2022 06:57:38 -0400
X-MC-Unique: Qit6tM4cOf-AhBE-frLu3w-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so13949621qko.18
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 03:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=51i11sEBzsSHk6c+w7JC0/rienuf6fXcNzu3mm3/VRo=;
        b=ptCzrviwWoMHEQY6ruvAPMpK2XzHAVH7tNZ/4BdybjxdRR2xfqNkxvpgPyGPkR3KKh
         8RBmO2dstIeo48LyrAPdPHySqpDLRVTgDAfTPkBDwORCcTGz8ypoPtdJ/asgiFJIFrYH
         6xBgee4uL/irULZUXX9DGPk9utTqf0nDHIVK40LFuyCPAUozx4kHtnvtVEO6QgCbuEx4
         yuo9XuNHHwTk6LtiqnxEnm3/dO4Mv30Atuc8x8MJ5BdF4b1zA/sBj8Rd2KLV0at3KNFT
         TAnh1twhwXfCB5sB3RKa747NKd0PY4HAvqH5vUvsNvPrPDzj6oznXzioLHCujzbbG4c8
         8iIA==
X-Gm-Message-State: ACgBeo28HumbZhNr4HDf2uyQHoeR6qZzT23D9twEzU3SPedeZTQVRMXi
        NrENHhxfXrXJtqtYqc5J1ND4sDaG0h20fJdMrnWR0WLr2vR9UK1z1hyLPQIiU6l4bIau99+opzK
        OqXpCne4V0e/z0hHb
X-Received: by 2002:a05:620a:4614:b0:6bb:8e9c:1720 with SMTP id br20-20020a05620a461400b006bb8e9c1720mr18947946qkb.778.1662029857959;
        Thu, 01 Sep 2022 03:57:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5NsT/90bcSNKDaYPRhZuN9vBrmnMZuP66dG0Iu7S5GMY1OqxJLtjok0Vw/FOSmNXQhRzrWAw==
X-Received: by 2002:a05:620a:4614:b0:6bb:8e9c:1720 with SMTP id br20-20020a05620a461400b006bb8e9c1720mr18947933qkb.778.1662029857674;
        Thu, 01 Sep 2022 03:57:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id y13-20020a05620a44cd00b006bb8b5b79efsm12972356qkp.129.2022.09.01.03.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:57:37 -0700 (PDT)
Message-ID: <f154fcd1d7e9c856c46dbf00ef4998773574a5cc.camel@redhat.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Thu, 01 Sep 2022 12:57:33 +0200
In-Reply-To: <20220830191518.77083-4-kuniyu@amazon.com>
References: <20220830191518.77083-1-kuniyu@amazon.com>
         <20220830191518.77083-4-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-30 at 12:15 -0700, Kuniyuki Iwashima wrote:
> We will soon introduce an optional per-netns ehash.
> 
> This means we cannot use tcp_hashinfo directly in most places.
> 
> Instead, access it via net->ipv4.tcp_death_row->hashinfo.
> 
> The access will be valid only while initialising tcp_hashinfo
> itself and creating/destroying each netns.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  .../chelsio/inline_crypto/chtls/chtls_cm.c    |  5 +-
>  net/core/filter.c                             |  5 +-
>  net/ipv4/esp4.c                               |  3 +-
>  net/ipv4/inet_hashtables.c                    |  2 +-
>  net/ipv4/netfilter/nf_socket_ipv4.c           |  2 +-
>  net/ipv4/netfilter/nf_tproxy_ipv4.c           | 17 +++--
>  net/ipv4/tcp_diag.c                           | 18 +++++-
>  net/ipv4/tcp_ipv4.c                           | 63 +++++++++++--------
>  net/ipv4/tcp_minisocks.c                      |  2 +-
>  net/ipv6/esp6.c                               |  3 +-
>  net/ipv6/inet6_hashtables.c                   |  4 +-
>  net/ipv6/netfilter/nf_socket_ipv6.c           |  2 +-
>  net/ipv6/netfilter/nf_tproxy_ipv6.c           |  5 +-
>  net/ipv6/tcp_ipv6.c                           | 16 ++---
>  net/mptcp/mptcp_diag.c                        |  7 ++-
>  15 files changed, 92 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> index ddfe9208529a..f90bfba4b303 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> @@ -1069,8 +1069,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
>  	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
>  }
>  
> -static void inet_inherit_port(struct inet_hashinfo *hash_info,
> -			      struct sock *lsk, struct sock *newsk)
> +static void inet_inherit_port(struct sock *lsk, struct sock *newsk)
>  {
>  	local_bh_disable();
>  	__inet_inherit_port(lsk, newsk);
> @@ -1240,7 +1239,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
>  						     ipv4.sysctl_tcp_window_scaling),
>  					   tp->window_clamp);
>  	neigh_release(n);
> -	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
> +	inet_inherit_port(lsk, newsk);
>  	csk_set_flag(csk, CSK_CONN_INLINE);
>  	bh_unlock_sock(newsk); /* tcp_create_openreq_child ->sk_clone_lock */

I looks to me that the above chunks are functionally a no-op and I
think that omitting the 2 drivers from the v2:

https://lore.kernel.org/netdev/20220829161920.99409-4-kuniyu@amazon.com/

should break mlx5/nfp inside a netns. I don't understand why including
the above and skipping the latters?!? I guess is a question mostly for
Eric :)

> @@ -1728,6 +1728,7 @@ EXPORT_SYMBOL(tcp_v4_do_rcv);
>  
>  int tcp_v4_early_demux(struct sk_buff *skb)
>  {
> +	struct net *net = dev_net(skb->dev);
>  	const struct iphdr *iph;
>  	const struct tcphdr *th;
>  	struct sock *sk;
> @@ -1744,7 +1745,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
>  	if (th->doff < sizeof(struct tcphdr) / 4)
>  		return 0;
>  
> -	sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
> +	sk = __inet_lookup_established(net, net->ipv4.tcp_death_row->hashinfo,
>  				       iph->saddr, th->source,
>  				       iph->daddr, ntohs(th->dest),
>  				       skb->skb_iif, inet_sdif(skb));

/Me is thinking aloud...

I'm wondering if the above has some measurable negative effect for
large deployments using only the main netns?

Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
>hashinfo already into the working set data for established socket?
Would the above increase the WSS by 2 cache-lines?

Thanks!

Paolo

