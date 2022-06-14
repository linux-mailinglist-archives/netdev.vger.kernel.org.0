Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF1D54B2DA
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbiFNONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiFNONA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:13:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 401EA201B6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 07:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655215978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVA+0zOn3k1i+mUsNlM5vgs0tjCwTF8wmn3X2biGO4w=;
        b=CwrcrbeMiIevh4oq99lrTAzDmOsN8eliMdwdBqELXRu6XkeTuxUHkYhludU1DB74EPo6tY
        ouy+eAgpbIQv0Yw5qP+eoOAf4LUnueGUSSW9tU2LSLcArDfJffDXXUw8zIbdlYAEX+QYOv
        t58qZrwjWlNN5GLHk5A59K4X6jZU4fw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-kcG3i4qNPeSgS1WsZjG3xw-1; Tue, 14 Jun 2022 10:12:57 -0400
X-MC-Unique: kcG3i4qNPeSgS1WsZjG3xw-1
Received: by mail-wm1-f70.google.com with SMTP id i131-20020a1c3b89000000b0039c9a08c52bso1369647wma.4
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 07:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NVA+0zOn3k1i+mUsNlM5vgs0tjCwTF8wmn3X2biGO4w=;
        b=N6MsBK6f5GidhyLNSF/mO1W0hed6feyMCCjQQyiAFENJlAE8cdbDISlBA9tzQVcyAY
         GvTWmO8fXXZZnfFqIQhn+9GIhQmJilcodCKhx3DpnTYwbHkBmNDGuHBHIG7NsUymQRbT
         RKTPgs5Gscvmld7nd5SVRzwNN11C8fFy0uR6yWxbwRPx1RCXCrc7NtqWGCRBzS9+NTGT
         u1wx6ZiO9NRbmNk392EBo6pmI5iL4UJEWK82Y4abtobCBl6wOQ9O4KV1isCbJ1koaMMq
         k51QixE90Ls4s7vOYh/vAPBbctz6pOJlJK25X2OwRET/yh+0osh3GbMMPfv0j5SGEp3i
         ryNA==
X-Gm-Message-State: AJIora8KwfDFmpwlTWZsd6Uup75cnBA71IBoz8O3ae3NgdJG6Pqxwkus
        SyNTO5/Eo1gio2/FVK8yIEj1C/lmG3Z2Nl9twhgSoW4NRy1ualtnlajbT6WMF7a4LjHxyNYFJhk
        hNhUqY9PEFyNlVoPD
X-Received: by 2002:adf:d1ef:0:b0:215:89b0:9add with SMTP id g15-20020adfd1ef000000b0021589b09addmr5045686wrd.279.1655215975682;
        Tue, 14 Jun 2022 07:12:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t4kiwYw7t+K0p7l2wCDaEF1auUQ/A+sVrJTwSFnUJkXmIbgldT2Pwvu3vkEIqE49PWDxcXuQ==
X-Received: by 2002:adf:d1ef:0:b0:215:89b0:9add with SMTP id g15-20020adfd1ef000000b0021589b09addmr5045663wrd.279.1655215975374;
        Tue, 14 Jun 2022 07:12:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id c6-20020a5d4146000000b00213ba3384aesm12680182wrq.35.2022.06.14.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:12:55 -0700 (PDT)
Message-ID: <0789de291023a1664d2b198075af6ce6a9245c6e.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net: Add bhash2 hashbucket locks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kafai@fb.com,
        kuba@kernel.org, davem@davemloft.net
Date:   Tue, 14 Jun 2022 16:12:53 +0200
In-Reply-To: <5b6a4415-c4f-254c-3c54-7fa0dfde32e9@linux.intel.com>
References: <20220611021646.1578080-1-joannelkoong@gmail.com>
         <20220611021646.1578080-3-joannelkoong@gmail.com>
         <5b6a4415-c4f-254c-3c54-7fa0dfde32e9@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-13 at 15:12 -0700, Mat Martineau wrote:
> On Fri, 10 Jun 2022, Joanne Koong wrote:
> 
> > Currently, the bhash2 hashbucket uses its corresponding bhash
> > hashbucket's lock for serializing concurrent accesses. There,
> > however, can be the case where the bhash2 hashbucket is accessed
> > concurrently by multiple processes that hash to different bhash
> > hashbuckets but to the same bhash2 hashbucket.
> > 
> > As such, each bhash2 hashbucket will need to have its own lock
> > instead of using its corresponding bhash hashbucket's lock.
> > 
> > Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> > include/net/inet_hashtables.h   |  25 +++----
> > net/dccp/proto.c                |   3 +-
> > net/ipv4/inet_connection_sock.c |  60 +++++++++-------
> > net/ipv4/inet_hashtables.c      | 119 +++++++++++++++-----------------
> > net/ipv4/tcp.c                  |   7 +-
> > 5 files changed, 107 insertions(+), 107 deletions(-)
> > 
> > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > index 2c331ce6ca73..c5b112f0938b 100644
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -124,15 +124,6 @@ struct inet_bind_hashbucket {
> > 	struct hlist_head	chain;
> > };
> > 
> > -/* This is synchronized using the inet_bind_hashbucket's spinlock.
> > - * Instead of having separate spinlocks, the inet_bind2_hashbucket can share
> > - * the inet_bind_hashbucket's given that in every case where the bhash2 table
> > - * is useful, a lookup in the bhash table also occurs.
> > - */
> > -struct inet_bind2_hashbucket {
> > -	struct hlist_head	chain;
> > -};
> > -
> > /* Sockets can be hashed in established or listening table.
> >  * We must use different 'nulls' end-of-chain value for all hash buckets :
> >  * A socket might transition from ESTABLISH to LISTEN state without
> > @@ -169,7 +160,7 @@ struct inet_hashinfo {
> > 	 * conflicts.
> > 	 */
> > 	struct kmem_cache		*bind2_bucket_cachep;
> > -	struct inet_bind2_hashbucket	*bhash2;
> > +	struct inet_bind_hashbucket	*bhash2;
> > 	unsigned int			bhash_size;
> > 
> > 	/* The 2nd listener table hashed by local port and address */
> > @@ -240,7 +231,7 @@ static inline bool check_bind_bucket_match(struct inet_bind_bucket *tb,
> > 
> > struct inet_bind2_bucket *
> > inet_bind2_bucket_create(struct kmem_cache *cachep, struct net *net,
> > -			 struct inet_bind2_hashbucket *head,
> > +			 struct inet_bind_hashbucket *head,
> > 			 const unsigned short port, int l3mdev,
> > 			 const struct sock *sk);
> > 
> > @@ -248,12 +239,12 @@ void inet_bind2_bucket_destroy(struct kmem_cache *cachep,
> > 			       struct inet_bind2_bucket *tb);
> > 
> > struct inet_bind2_bucket *
> > -inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
> > +inet_bind2_bucket_find(struct inet_bind_hashbucket *head,
> > +		       struct inet_hashinfo *hinfo, struct net *net,
> > 		       const unsigned short port, int l3mdev,
> > -		       struct sock *sk,
> > -		       struct inet_bind2_hashbucket **head);
> > +		       struct sock *sk);
> > 
> > -bool check_bind2_bucket_match_nulladdr(struct inet_bind2_bucket *tb,
> > +bool check_bind2_bucket_match_addr_any(struct inet_bind2_bucket *tb,
> > 				       struct net *net,
> > 				       const unsigned short port,
> > 				       int l3mdev,
> > @@ -265,6 +256,10 @@ static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
> > 	return (lport + net_hash_mix(net)) & (bhash_size - 1);
> > }
> > 
> > +struct inet_bind_hashbucket *
> > +inet_bhashfn_portaddr(struct inet_hashinfo *hinfo, const struct sock *sk,
> > +		      const struct net *net, unsigned short port);
> > +
> > void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> > 		    struct inet_bind2_bucket *tb2, const unsigned short snum);
> > 
> > diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> > index 2e78458900f2..f4f2ad5f9c08 100644
> > --- a/net/dccp/proto.c
> > +++ b/net/dccp/proto.c
> > @@ -1182,7 +1182,7 @@ static int __init dccp_init(void)
> > 		goto out_free_dccp_locks;
> > 	}
> > 
> > -	dccp_hashinfo.bhash2 = (struct inet_bind2_hashbucket *)
> > +	dccp_hashinfo.bhash2 = (struct inet_bind_hashbucket *)
> > 		__get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
> > 
> > 	if (!dccp_hashinfo.bhash2) {
> > @@ -1193,6 +1193,7 @@ static int __init dccp_init(void)
> > 	for (i = 0; i < dccp_hashinfo.bhash_size; i++) {
> > 		spin_lock_init(&dccp_hashinfo.bhash[i].lock);
> > 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash[i].chain);
> > +		spin_lock_init(&dccp_hashinfo.bhash2[i].lock);
> > 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
> > 	}
> > 
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index c0b7e6c21360..24a42e4d8234 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -131,14 +131,14 @@ static bool use_bhash2_on_bind(const struct sock *sk)
> > 	return sk->sk_rcv_saddr != htonl(INADDR_ANY);
> > }
> > 
> > -static u32 get_bhash2_nulladdr_hash(const struct sock *sk, struct net *net,
> > +static u32 get_bhash2_addr_any_hash(const struct sock *sk, struct net *net,
> > 				    int port)
> > {
> > #if IS_ENABLED(CONFIG_IPV6)
> > -	struct in6_addr nulladdr = {};
> > +	struct in6_addr addr_any = {};
> > 
> > 	if (sk->sk_family == AF_INET6)
> > -		return ipv6_portaddr_hash(net, &nulladdr, port);
> > +		return ipv6_portaddr_hash(net, &addr_any, port);
> > #endif
> > 	return ipv4_portaddr_hash(net, 0, port);
> > }
> > @@ -204,18 +204,18 @@ static bool check_bhash2_conflict(const struct sock *sk,
> > 	return false;
> > }
> > 
> > -/* This should be called only when the corresponding inet_bind_bucket spinlock
> > - * is held
> > - */
> > +/* This should be called only when the tb and tb2 hashbuckets' locks are held */
> > static int inet_csk_bind_conflict(const struct sock *sk, int port,
> > 				  struct inet_bind_bucket *tb,
> > 				  struct inet_bind2_bucket *tb2, /* may be null */
> > +				  struct inet_bind_hashbucket *head_tb2,
> > 				  bool relax, bool reuseport_ok)
> > {
> > 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> > 	kuid_t uid = sock_i_uid((struct sock *)sk);
> > 	struct sock_reuseport *reuseport_cb;
> > -	struct inet_bind2_hashbucket *head2;
> > +	struct inet_bind_hashbucket *head_addr_any;
> > +	bool addr_any_conflict = false;
> > 	bool reuseport_cb_ok;
> > 	struct sock *sk2;
> > 	struct net *net;
> > @@ -254,33 +254,39 @@ static int inet_csk_bind_conflict(const struct sock *sk, int port,
> > 	/* check there's no conflict with an existing IPV6_ADDR_ANY (if ipv6) or
> > 	 * INADDR_ANY (if ipv4) socket.
> > 	 */
> > -	hash = get_bhash2_nulladdr_hash(sk, net, port);
> > -	head2 = &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> > +	hash = get_bhash2_addr_any_hash(sk, net, port);
> > +	head_addr_any = &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> > 
> > 	l3mdev = inet_sk_bound_l3mdev(sk);
> > -	inet_bind_bucket_for_each(tb2, &head2->chain)
> > -		if (check_bind2_bucket_match_nulladdr(tb2, net, port, l3mdev, sk))
> > +
> > +	if (head_addr_any != head_tb2)
> > +		spin_lock_bh(&head_addr_any->lock);
> 
> Hi Joanne -
> 
> syzkaller is consistently hitting a warning here (about 10x per minute):
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.19.0-rc1-00382-g78347e8e15bf #1 Not tainted
> --------------------------------------------
> sshd/352 is trying to acquire lock:
> ffffc90000968640 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
> ffffc90000968640 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: inet_csk_bind_conflict+0x4c4/0x8e0 net/ipv4/inet_connection_sock.c:263
> 
> but task is already holding lock:
> ffffc90000883d28 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
> ffffc90000883d28 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: inet_csk_get_port+0x528/0xea0 net/ipv4/inet_connection_sock.c:497
> 
> other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&tcp_hashinfo.bhash2[i].lock);
>    lock(&tcp_hashinfo.bhash2[i].lock);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation

This looks like a real deadlock scenario.

One dumb way of solving it would be always acquiring the bhash2 lock
for head_addr_any and for port/addr, in a fixed order - e.g. lower hash
first.

Anyway this fix looks not trivial. I'm wondering if we should consider
a revert of the feature until a better/more robust design is ready?

Thanks

Paolo

