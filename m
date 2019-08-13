Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9252D8AE7F
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 07:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfHMFFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 01:05:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44343 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfHMFFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 01:05:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id c81so1874730pfc.11
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 22:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hV1nzPljKHS8Eqj97nrEIUm4rdTAQpj3PuNpJgSJpTA=;
        b=pcaYxF4HTnyu/dRoW10lPfLikWqaxz6GS/re9CstJWHynOfz9NJfBkNUPiliyrUgxp
         2RJTywOghiPbAN2JfAaYwnxKmvDI1/oQBqQKIdqzm+L153VbHyj9uO2fwqbVu1aZc8T4
         kq4LlhwsOcF42xVpK7mpe1vxdGE0Or5DZCid0hHymy0yeIH2rk9At4ZgKctKltup6bgR
         9RHLWlGuF96wF1OAG0ia9ATkgB7HiEZOBOF/ouaySKt66MiTpn9iAU9Z4HZ9Agqwo9jU
         XGZlvgpkktXiHTovbBVw01hZUIHXIRgzRWiFZ/PbOlEHYUJWC9LkufXpFeTk6JQXpqUf
         Jyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hV1nzPljKHS8Eqj97nrEIUm4rdTAQpj3PuNpJgSJpTA=;
        b=W+Eaica88CSvG1yJTwXeWMgt8UvAqQZ65xRt8rdkKmFRbOJDbPVVIaK6d0B3KD8c5M
         d0+LzeLZ3dPIfAb1Wpn57eF1v8X2bN3N9lUgU+I5fsewjGm8uZ2kHVxOpDtSgXvWayAC
         OZmsc05T7sWkdCthOWJTm8AnUbdsy3I6aUPaMhEbRF73Y5C8LydnFdOMmcjhTQZsdx+n
         BCcw722FmM2RLIIfRuzXG+Wh+iGu4vP+oR6UnYR6I0IVbq+GO/1aTGNVim5HaMg5JDWb
         /b9ooiTplJ9JlLNttR1zrXJ6C5LW8KppAiJUYL6vnHC1QzeaLUzvQi439qZRkHjPrUxh
         oYVA==
X-Gm-Message-State: APjAAAV5ReF1P9aa4cV8Xniz3r3V6Ju16o0CesC41cFECeAduiNAb2hZ
        yhfnywMdB1+lq2X3w4lC/mcx9w==
X-Google-Smtp-Source: APXvYqwAsr4wCydVC0lLRr2n1lQoWXvGfBp4mhYifgdIixqLSHTAYMoKh5ifCFhVr8x5oHdbYSWZ3Q==
X-Received: by 2002:a17:90a:e392:: with SMTP id b18mr324831pjz.140.1565672748103;
        Mon, 12 Aug 2019 22:05:48 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id u7sm107077050pfm.96.2019.08.12.22.05.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 22:05:47 -0700 (PDT)
Date:   Mon, 12 Aug 2019 22:05:46 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
Message-ID: <20190813050546.GG2820@mini-arch>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-3-sdf@google.com>
 <20190813014753.vftgwwzqxzx2pawg@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813014753.vftgwwzqxzx2pawg@kafai-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/13, Martin Lau wrote:
> On Fri, Aug 09, 2019 at 09:10:36AM -0700, Stanislav Fomichev wrote:
> > Add new helper bpf_sk_storage_clone which optionally clones sk storage
> > and call it from sk_clone_lock.
> Thanks for v2.  Sorry for the delay.  I am traveling.
No worries, take your time, if you're OOO feel free to do another
round when you get back, not urgent.

> > 
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/net/bpf_sk_storage.h |  10 ++++
> >  include/uapi/linux/bpf.h     |   3 ++
> >  net/core/bpf_sk_storage.c    | 100 +++++++++++++++++++++++++++++++++--
> >  net/core/sock.c              |   9 ++--
> >  4 files changed, 116 insertions(+), 6 deletions(-)
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
> > index 4393bd4b2419..0ef594ac3899 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -337,6 +337,9 @@ enum bpf_attach_type {
> >  #define BPF_F_RDONLY_PROG	(1U << 7)
> >  #define BPF_F_WRONLY_PROG	(1U << 8)
> >  
> > +/* Clone map from listener for newly accepted socket */
> > +#define BPF_F_CLONE		(1U << 9)
> > +
> >  /* flags for BPF_PROG_QUERY */
> >  #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
> >  
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index 94c7f77ecb6b..584e08ee0ca3 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -12,6 +12,9 @@
> >  
> >  static atomic_t cache_idx;
> >  
> > +#define SK_STORAGE_CREATE_FLAG_MASK					\
> > +	(BPF_F_NO_PREALLOC | BPF_F_CLONE)
> > +
> >  struct bucket {
> >  	struct hlist_head list;
> >  	raw_spinlock_t lock;
> > @@ -209,7 +212,6 @@ static void selem_unlink_sk(struct bpf_sk_storage_elem *selem)
> >  		kfree_rcu(sk_storage, rcu);
> >  }
> >  
> > -/* sk_storage->lock must be held and sk_storage->list cannot be empty */
> >  static void __selem_link_sk(struct bpf_sk_storage *sk_storage,
> >  			    struct bpf_sk_storage_elem *selem)
> >  {
> > @@ -509,7 +511,7 @@ static int sk_storage_delete(struct sock *sk, struct bpf_map *map)
> >  	return 0;
> >  }
> >  
> > -/* Called by __sk_destruct() */
> > +/* Called by __sk_destruct() & bpf_sk_storage_clone() */
> >  void bpf_sk_storage_free(struct sock *sk)
> >  {
> >  	struct bpf_sk_storage_elem *selem;
> > @@ -557,6 +559,11 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
> >  
> >  	smap = (struct bpf_sk_storage_map *)map;
> >  
> > +	/* Note that this map might be concurrently cloned from
> > +	 * bpf_sk_storage_clone. Wait for any existing bpf_sk_storage_clone
> > +	 * RCU read section to finish before proceeding. New RCU
> > +	 * read sections should be prevented via bpf_map_inc_not_zero.
> > +	 */
> Thanks!
> 
> >  	synchronize_rcu();
> >  
> >  	/* bpf prog and the userspace can no longer access this map
> > @@ -601,7 +608,8 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
> >  
> >  static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
> >  {
> > -	if (attr->map_flags != BPF_F_NO_PREALLOC || attr->max_entries ||
> > +	if (attr->map_flags & ~SK_STORAGE_CREATE_FLAG_MASK ||
> > +	    attr->max_entries ||
> I think "!(attr->map_flags & BPF_F_NO_PREALLOC)" should also be needed.
Makes sense, we always want to have BPF_F_NO_PREALLOC set. Will add,
thanks!

> >  	    attr->key_size != sizeof(int) || !attr->value_size ||
> >  	    /* Enforce BTF for userspace sk dumping */
> >  	    !attr->btf_key_type_id || !attr->btf_value_type_id)
> > @@ -739,6 +747,92 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
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
> > +		return NULL;
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
> > +		struct bpf_sk_storage_elem *copy_selem;
> > +		struct bpf_sk_storage_map *smap;
> > +		struct bpf_map *map;
> > +		int refold;
> > +
> > +		smap = rcu_dereference(SDATA(selem)->smap);
> > +		if (!(smap->map.map_flags & BPF_F_CLONE))
> > +			continue;
> > +
> > +		map = bpf_map_inc_not_zero(&smap->map, false);
> > +		if (IS_ERR(map))
> > +			continue;
> > +
> > +		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
> > +		if (!copy_selem) {
> > +			ret = -ENOMEM;
> > +			bpf_map_put(map);
> > +			goto err;
> > +		}
> > +
> > +		if (new_sk_storage) {
> > +			selem_link_map(smap, copy_selem);
> > +			__selem_link_sk(new_sk_storage, copy_selem);
> > +		} else {
> > +			ret = sk_storage_alloc(newsk, smap, copy_selem);
> > +			if (ret) {
> > +				kfree(copy_selem);
> > +				atomic_sub(smap->elem_size,
> > +					   &newsk->sk_omem_alloc);
> > +				bpf_map_put(map);
> > +				goto err;
> > +			}
> > +
> > +			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
> > +		}
> > +		bpf_map_put(map);
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
> The later sk_free_unlock_clone(newsk) should eventually call
> bpf_sk_storage_free(newsk) also?
Hm, good point, I can drop it from here and rely on
sk_free_unlock_clone to call __sk_destruct/bpf_sk_storage_free.
That probably deserves a comment though :-)

> Others LGTM.
Thank you for a review!

> > +	return ret;
> > +}
> > +
> >  BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
> >  	   void *, value, u64, flags)
> >  {
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
> > 2.23.0.rc1.153.gdeed80330f-goog
> > 
