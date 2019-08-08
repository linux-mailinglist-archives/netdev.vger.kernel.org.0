Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED21865BC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389777AbfHHP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:28:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42408 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbfHHP2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 11:28:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so44240690pgb.9
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 08:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=utJWuWxfDp9ua5XumByBys8UZrFgh1w22LZS9xGgft0=;
        b=gNhhbKGptYxJiV8nv+PwZ3LmMXSAAAKCbVBAwGcEYy3Ljf7Iz91lwtJ3otISgSQKtq
         69aVvxuO1Rxha7cbW7qjEL8nIOMxreugPIwYgH9JEWdVzna4kI5/WZZPX9DrxzmUYy5S
         +Nzaf2O2D7Zv10i2A3LMoy56RWprtpy4Psww1ZHu/zUQqMj6WKOn2fV8TZuYFe38m9Pw
         m8nbadKEqrMs/64A4oApXfS0sGTLAJE/yh9pl/MOeWKvA08kWe+qsN4WWhGUUPutfNfI
         Z/7+drJcLdhROZiGOKSRW4HJ/fi7MxPIjihidEXRW0NCdRYWiDP1KpcazZrvkg/V0Rne
         GNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=utJWuWxfDp9ua5XumByBys8UZrFgh1w22LZS9xGgft0=;
        b=XJZDUfAH7zkXBDeatmHZJNlHpMKQpOHOI6govyDxt1s2T3UgS9j1aTgTqLglnlGVxw
         kEuYzDIebmzWYHtF5/1tplX9mGf0dHJS2T3drndbKZYY556yU8foC0Nl0aaH/xti8fM2
         dX9ck+j8BCJtvOq+YL7hYU1MsdIR2oQ6nb4rD2tVCohCazhdq1ppcvsBMjCnEyPY7tpT
         HXnPYDShIq7fCUVzHIiRzaNJ9+3d9+uUnk0ptBSpTMRqX9XjF1e0yJCx6F6T7qLeN7D7
         ANYneILi3oAIzxSPiGKHSpxQzXxAqKWRL/uNi/7zhaVrWwYc9aD5WIzIspkniBHaijJE
         WidQ==
X-Gm-Message-State: APjAAAWBrbGM9e1YAQMmCQSxT68FWYXemgf32jCYUoX4eC9yJHk2qYgJ
        9GOUhQ1wzeAfODGI4oRMutZ9qA==
X-Google-Smtp-Source: APXvYqwj9ppAnE+z/2UQ/r0ivgWFgYub68BSRT/i731mai1cNLIMRCsWMGiXSONU1zgDYlEUt5HgdA==
X-Received: by 2002:a63:6c7:: with SMTP id 190mr13150393pgg.7.1565278112226;
        Thu, 08 Aug 2019 08:28:32 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id l25sm114899839pff.143.2019.08.08.08.28.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 08:28:31 -0700 (PDT)
Date:   Thu, 8 Aug 2019 08:28:30 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Message-ID: <20190808152830.GC2820@mini-arch>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
 <20190808063936.3p4ahtdkw35rrzqu@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808063936.3p4ahtdkw35rrzqu@kafai-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08, Martin Lau wrote:
> On Wed, Aug 07, 2019 at 08:47:18AM -0700, Stanislav Fomichev wrote:
> > Add new helper bpf_sk_storage_clone which optionally clones sk storage
> > and call it from bpf_sk_storage_clone. Reuse the gap in
> > bpf_sk_storage_elem to store clone/non-clone flag.
> > 
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/net/bpf_sk_storage.h |  10 ++++
> >  include/uapi/linux/bpf.h     |   1 +
> >  net/core/bpf_sk_storage.c    | 102 +++++++++++++++++++++++++++++++++--
> >  net/core/sock.c              |   9 ++--
> >  4 files changed, 115 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
> > index b9dcb02e756b..8e4f831d2e52 100644
> > --- a/include/net/bpf_sk_storage.h
> > +++ b/include/net/bpf_sk_storage.h
> > @@ -10,4 +10,14 @@ void bpf_sk_storage_free(struct sock *sk);
> >  extern const struct bpf_func_proto bpf_sk_storage_get_proto;
> >  extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
> >  
> > +#ifdef CONFIG_BPF_SYSCALL
> > +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk);
> > +#else
> > +static inline int bpf_sk_storage_clone(const struct sock *sk,
> > +				       struct sock *newsk)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  #endif /* _BPF_SK_STORAGE_H */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4393bd4b2419..00459ca4c8cf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2931,6 +2931,7 @@ enum bpf_func_id {
> >  
> >  /* BPF_FUNC_sk_storage_get flags */
> >  #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
> > +#define BPF_SK_STORAGE_GET_F_CLONE	(1ULL << 1)
> It is only used in bpf_sk_storage_get().
> What if the elem is created from bpf_fd_sk_storage_update_elem()
> i.e. from the syscall API ?
> 
> What may be the use case for a map to have both CLONE and non-CLONE
> elements?  If it is not the case, would it be better to add
> BPF_F_CLONE to bpf_attr->map_flags?
I didn't think about putting it on the map itself since the API
is on a per-element, but it does make sense. I can't come up
with a use-case for a per-element selective clone/non-clone.
Thanks, will move to the map itself.

> >  
> >  /* Mode for BPF_FUNC_skb_adjust_room helper. */
> >  enum bpf_adj_room_mode {
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index 94c7f77ecb6b..b6dea67965bc 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -12,6 +12,9 @@
> >  
> >  static atomic_t cache_idx;
> >  
> > +#define BPF_SK_STORAGE_GET_F_MASK	(BPF_SK_STORAGE_GET_F_CREATE | \
> > +					 BPF_SK_STORAGE_GET_F_CLONE)
> > +
> >  struct bucket {
> >  	struct hlist_head list;
> >  	raw_spinlock_t lock;
> > @@ -66,7 +69,8 @@ struct bpf_sk_storage_elem {
> >  	struct hlist_node snode;	/* Linked to bpf_sk_storage */
> >  	struct bpf_sk_storage __rcu *sk_storage;
> >  	struct rcu_head rcu;
> > -	/* 8 bytes hole */
> > +	u8 clone:1;
> > +	/* 7 bytes hole */
> >  	/* The data is stored in aother cacheline to minimize
> >  	 * the number of cachelines access during a cache hit.
> >  	 */
> > @@ -509,7 +513,7 @@ static int sk_storage_delete(struct sock *sk, struct bpf_map *map)
> >  	return 0;
> >  }
> >  
> > -/* Called by __sk_destruct() */
> > +/* Called by __sk_destruct() & bpf_sk_storage_clone() */
> >  void bpf_sk_storage_free(struct sock *sk)
> >  {
> >  	struct bpf_sk_storage_elem *selem;
> > @@ -739,19 +743,106 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
> >  	return err;
> >  }
> >  
> > +static struct bpf_sk_storage_elem *
> > +bpf_sk_storage_clone_elem(struct sock *newsk,
> > +			  struct bpf_sk_storage_map *smap,
> > +			  struct bpf_sk_storage_elem *selem)
> > +{
> > +	struct bpf_sk_storage_elem *copy_selem;
> > +
> > +	copy_selem = selem_alloc(smap, newsk, NULL, true);
> > +	if (!copy_selem)
> > +		return ERR_PTR(-ENOMEM);
> nit.
> may be just return NULL as selem_alloc() does.
Sounds good.

> > +
> > +	if (map_value_has_spin_lock(&smap->map))
> > +		copy_map_value_locked(&smap->map, SDATA(copy_selem)->data,
> > +				      SDATA(selem)->data, true);
> > +	else
> > +		copy_map_value(&smap->map, SDATA(copy_selem)->data,
> > +			       SDATA(selem)->data);
> > +
> > +	return copy_selem;
> > +}
> > +
> > +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
> > +{
> > +	struct bpf_sk_storage *new_sk_storage = NULL;
> > +	struct bpf_sk_storage *sk_storage;
> > +	struct bpf_sk_storage_elem *selem;
> > +	int ret;
> > +
> > +	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> > +
> > +	rcu_read_lock();
> > +	sk_storage = rcu_dereference(sk->sk_bpf_storage);
> > +
> > +	if (!sk_storage || hlist_empty(&sk_storage->list))
> > +		goto out;
> > +
> > +	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
> > +		struct bpf_sk_storage_map *smap;
> > +		struct bpf_sk_storage_elem *copy_selem;
> > +
> > +		if (!selem->clone)
> > +			continue;
> > +
> > +		smap = rcu_dereference(SDATA(selem)->smap);
> > +		if (!smap)
> smap should not be NULL.
I see; you never set it back to NULL and we are guaranteed that the
map is still around due to rcu. Removed.

> > +			continue;
> > +
> > +		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
> > +		if (IS_ERR(copy_selem)) {
> > +			ret = PTR_ERR(copy_selem);
> > +			goto err;
> > +		}
> > +
> > +		if (!new_sk_storage) {
> > +			ret = sk_storage_alloc(newsk, smap, copy_selem);
> > +			if (ret) {
> > +				kfree(copy_selem);
> > +				atomic_sub(smap->elem_size,
> > +					   &newsk->sk_omem_alloc);
> > +				goto err;
> > +			}
> > +
> > +			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
> > +			continue;
> > +		}
> > +
> > +		raw_spin_lock_bh(&new_sk_storage->lock);
> > +		selem_link_map(smap, copy_selem);
> Unlike the existing selem-update use-cases in bpf_sk_storage.c,
> the smap->map.refcnt has not been held here.  Reading the smap
> is fine.  However, adding a new selem to a deleting smap is an issue.
> Hence, I think bpf_map_inc_not_zero() should be done first.
In this case, I should probably do it after smap = rcu_deref()?

> > +		__selem_link_sk(new_sk_storage, copy_selem);
> > +		raw_spin_unlock_bh(&new_sk_storage->lock);
> > +	}
> > +
> > +out:
> > +	rcu_read_unlock();
> > +	return 0;
> > +
> > +err:
> > +	rcu_read_unlock();
> > +
> > +	bpf_sk_storage_free(newsk);
> > +	return ret;
> > +}
> > +
> >  BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
> >  	   void *, value, u64, flags)
> >  {
> >  	struct bpf_sk_storage_data *sdata;
> >  
> > -	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
> > +	if (flags & ~BPF_SK_STORAGE_GET_F_MASK)
> > +		return (unsigned long)NULL;
> > +
> > +	if ((flags & BPF_SK_STORAGE_GET_F_CLONE) &&
> > +	    !(flags & BPF_SK_STORAGE_GET_F_CREATE))
> >  		return (unsigned long)NULL;
> >  
> >  	sdata = sk_storage_lookup(sk, map, true);
> >  	if (sdata)
> >  		return (unsigned long)sdata->data;
> >  
> > -	if (flags == BPF_SK_STORAGE_GET_F_CREATE &&
> > +	if ((flags & BPF_SK_STORAGE_GET_F_CREATE) &&
> >  	    /* Cannot add new elem to a going away sk.
> >  	     * Otherwise, the new elem may become a leak
> >  	     * (and also other memory issues during map
> > @@ -762,6 +853,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
> >  		/* sk must be a fullsock (guaranteed by verifier),
> >  		 * so sock_gen_put() is unnecessary.
> >  		 */
> > +		if (!IS_ERR(sdata))
> > +			SELEM(sdata)->clone =
> > +				!!(flags & BPF_SK_STORAGE_GET_F_CLONE);
> >  		sock_put(sk);
> >  		return IS_ERR(sdata) ?
> >  			(unsigned long)NULL : (unsigned long)sdata->data;
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index d57b0cc995a0..f5e801a9cea4 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1851,9 +1851,12 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
> >  			goto out;
> >  		}
> >  		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
> > -#ifdef CONFIG_BPF_SYSCALL
> > -		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> > -#endif
> > +
> > +		if (bpf_sk_storage_clone(sk, newsk)) {
> > +			sk_free_unlock_clone(newsk);
> > +			newsk = NULL;
> > +			goto out;
> > +		}
> >  
> >  		newsk->sk_err	   = 0;
> >  		newsk->sk_err_soft = 0;
> > -- 
> > 2.22.0.770.g0f2c4a37fd-goog
> > 
