Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C48856B7
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbfHHAFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:05:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36681 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbfHHAFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:05:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so42995726pfl.3
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 17:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5rNLUcyU+g8cIHRhCVxOiEzBg5fOWUyZNgUAXG+TC6M=;
        b=rVjnwp/5mTAWFNgoUEhkYc7GXD6gczuDvo2A+mYcln4aP993nkH/3fv+uWt95j0YKL
         Ptqi0tweakRfWAq45bPC5QzfXFmAJbFEyuIOZd220W9t7VzccC/sjpT2UzxEnrRPHVha
         9m80DzYDOPxemQXJDmpWe8h66+zXUWoWeFl+zLAxxfM3UCvTyvhD20Y7G4w4Wz89fh9i
         aXerq2pe8xtjU/5siWnRGpkmxcjx/lvfA5Q9xN7+YlquOQj0PkHapwZtQzTPZUXBbeDJ
         vWSaBavXM5kftWgaJ6BuRjKaYS7pDEwwYcVzjmIGlrxapwOrCVvFatA4jzQCPknWfcuF
         4LnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5rNLUcyU+g8cIHRhCVxOiEzBg5fOWUyZNgUAXG+TC6M=;
        b=nFNM8iMf/yptmH1pAGrQm9Zqi+De1CM2h85ALhwravD4KbvhU3ZzzzItP4KAJSRxER
         AsFi/CgrfLW2unrA5m/st0nZd7elqbkbkhh6Qu5XZfEqjxK2t4ZTjiLUpvK4khb+rXjX
         pcrmfAH/EADXVHjgc9usJI0k++l7MESqHDATwW60GB7BLrHDT7UxNxJ3BLigh8HSNLft
         2w7NLcJD2m9t44b+NUz2fATToBnjK5uUXdf9IHOHyeMMrOizTs2Sn1CR5qdrKsFP5kqO
         UfxUvvt5ROLYfyRSkJPHmBVBl6My3rscUaOQFQG3oeik0FhdOl5jiue6ledGnWebT/ct
         8jhA==
X-Gm-Message-State: APjAAAUfmcqjR/FmfXcW76hwpFupmxcZXRjBIKy8sJfjIa3Y4BQL0+xf
        yNwsP58IWqvrux8DquCUiZbXhA==
X-Google-Smtp-Source: APXvYqxJMwvJpKM6qKh1GcP1on/3/77uccJwJ6rwh+7OCow1cJPsjp+WsZNFH+Kx+27piRZSzXrMVw==
X-Received: by 2002:a17:90a:8a15:: with SMTP id w21mr1027328pjn.134.1565222734806;
        Wed, 07 Aug 2019 17:05:34 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id i124sm171749195pfe.61.2019.08.07.17.05.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 17:05:34 -0700 (PDT)
Date:   Wed, 7 Aug 2019 17:05:33 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Message-ID: <20190808000533.GA2820@mini-arch>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
 <9bd56e49-c38d-e1c4-1ff3-8250531d0d48@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd56e49-c38d-e1c4-1ff3-8250531d0d48@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07, Yonghong Song wrote:
> 
> 
> On 8/7/19 8:47 AM, Stanislav Fomichev wrote:
> > Add new helper bpf_sk_storage_clone which optionally clones sk storage
> > and call it from bpf_sk_storage_clone. Reuse the gap in
> > bpf_sk_storage_elem to store clone/non-clone flag.
> > 
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> 
> I tried to see whether I can find any missing race conditions in
> the code but I failed. So except a minor comments below,
Thanks for a review!

> Acked-by: Yonghong Song <yhs@fb.com>
> 
> > ---
> >   include/net/bpf_sk_storage.h |  10 ++++
> >   include/uapi/linux/bpf.h     |   1 +
> >   net/core/bpf_sk_storage.c    | 102 +++++++++++++++++++++++++++++++++--
> >   net/core/sock.c              |   9 ++--
> >   4 files changed, 115 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
> > index b9dcb02e756b..8e4f831d2e52 100644
> > --- a/include/net/bpf_sk_storage.h
> > +++ b/include/net/bpf_sk_storage.h
> > @@ -10,4 +10,14 @@ void bpf_sk_storage_free(struct sock *sk);
> >   extern const struct bpf_func_proto bpf_sk_storage_get_proto;
> >   extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
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
> >   #endif /* _BPF_SK_STORAGE_H */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4393bd4b2419..00459ca4c8cf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2931,6 +2931,7 @@ enum bpf_func_id {
> >   
> >   /* BPF_FUNC_sk_storage_get flags */
> >   #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
> > +#define BPF_SK_STORAGE_GET_F_CLONE	(1ULL << 1)
> >   
> >   /* Mode for BPF_FUNC_skb_adjust_room helper. */
> >   enum bpf_adj_room_mode {
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index 94c7f77ecb6b..b6dea67965bc 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -12,6 +12,9 @@
> >   
> >   static atomic_t cache_idx;
> >   
> > +#define BPF_SK_STORAGE_GET_F_MASK	(BPF_SK_STORAGE_GET_F_CREATE | \
> > +					 BPF_SK_STORAGE_GET_F_CLONE)
> > +
> >   struct bucket {
> >   	struct hlist_head list;
> >   	raw_spinlock_t lock;
> > @@ -66,7 +69,8 @@ struct bpf_sk_storage_elem {
> >   	struct hlist_node snode;	/* Linked to bpf_sk_storage */
> >   	struct bpf_sk_storage __rcu *sk_storage;
> >   	struct rcu_head rcu;
> > -	/* 8 bytes hole */
> > +	u8 clone:1;
> > +	/* 7 bytes hole */
> >   	/* The data is stored in aother cacheline to minimize
> >   	 * the number of cachelines access during a cache hit.
> >   	 */
> > @@ -509,7 +513,7 @@ static int sk_storage_delete(struct sock *sk, struct bpf_map *map)
> >   	return 0;
> >   }
> >   
> > -/* Called by __sk_destruct() */
> > +/* Called by __sk_destruct() & bpf_sk_storage_clone() */
> >   void bpf_sk_storage_free(struct sock *sk)
> >   {
> >   	struct bpf_sk_storage_elem *selem;
> > @@ -739,19 +743,106 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
> >   	return err;
> >   }
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
> > +		__selem_link_sk(new_sk_storage, copy_selem);
> > +		raw_spin_unlock_bh(&new_sk_storage->lock);
> 
> Considering in this particular case, new socket is not visible to 
> outside world yet (both kernel and user space), map_delete/map_update
> operations are not applicable in this situation, so
> the above raw_spin_lock_bh() probably not needed.
I agree, it's doing nothing, but __selem_link_sk has the following comment:
/* sk_storage->lock must be held and sk_storage->list cannot be empty */

Just wanted to keep that invariant for this call site as well (in case
we add some lockdep enforcement or smth else). WDYT?

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
> >   BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
> >   	   void *, value, u64, flags)
> >   {
> >   	struct bpf_sk_storage_data *sdata;
> >   
> > -	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
> > +	if (flags & ~BPF_SK_STORAGE_GET_F_MASK)
> > +		return (unsigned long)NULL;
> > +
> > +	if ((flags & BPF_SK_STORAGE_GET_F_CLONE) &&
> > +	    !(flags & BPF_SK_STORAGE_GET_F_CREATE))
> >   		return (unsigned long)NULL;
> >   
> >   	sdata = sk_storage_lookup(sk, map, true);
> >   	if (sdata)
> >   		return (unsigned long)sdata->data;
> >   
> > -	if (flags == BPF_SK_STORAGE_GET_F_CREATE &&
> > +	if ((flags & BPF_SK_STORAGE_GET_F_CREATE) &&
> >   	    /* Cannot add new elem to a going away sk.
> >   	     * Otherwise, the new elem may become a leak
> >   	     * (and also other memory issues during map
> > @@ -762,6 +853,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
> >   		/* sk must be a fullsock (guaranteed by verifier),
> >   		 * so sock_gen_put() is unnecessary.
> >   		 */
> > +		if (!IS_ERR(sdata))
> > +			SELEM(sdata)->clone =
> > +				!!(flags & BPF_SK_STORAGE_GET_F_CLONE);
> >   		sock_put(sk);
> >   		return IS_ERR(sdata) ?
> >   			(unsigned long)NULL : (unsigned long)sdata->data;
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index d57b0cc995a0..f5e801a9cea4 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1851,9 +1851,12 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
> >   			goto out;
> >   		}
> >   		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
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
> >   		newsk->sk_err	   = 0;
> >   		newsk->sk_err_soft = 0;
> > 
