Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665173053DD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhA0HCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhA0HAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:00:49 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD26C061574;
        Tue, 26 Jan 2021 23:00:09 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q131so577116pfq.10;
        Tue, 26 Jan 2021 23:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfVtUOVdHzNsaNBZDsKRQ5pCa3prKgwyznfp/Vx4Pk0=;
        b=TGfW5rRNbbytIpi3S+Q7+mjYMd6OMXgnGbfCUTzyrw3FtUZFjQFZ6D38JF4H4UabwW
         Auwaqrb1bzMGvNB+rYpfzw7xOQqLuczhsqTW1LiClxR9hYtFXj+ZZqG98QUyoJixdtHy
         qMNEJhg1uPiFJCkFgKbgbdB0oAAeXGgLpPtar/M5I4a/kymB9fxojFfOUU6j+ptE0hvH
         LnzWuA+WkWzIBB7rj+S4p+lnRknj/IYtFEdH+tbhpvXbuin0fBykAfR0I1h012JmyIv1
         q4JP473OCk995M28iPK7CyxQdwhvw/+V7b64yQh3Ja3msBHvyLxMaackmUved3kkRhks
         LNrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfVtUOVdHzNsaNBZDsKRQ5pCa3prKgwyznfp/Vx4Pk0=;
        b=BlpF6m6NbAYTeWMhrO+5T9gURqor9OsO/uBwoULn/A0G5Woj/916zrfqc/JBfNZfes
         Lixt20+z9kiuIuu2n4hZUlLJXc+X2AFvw/b4QNqfI5Sk1fd7GBSZIe8jTN2jJz8q6pZI
         4iXqDxQxeTr6X2JWXWLy/kmy/QkAcTEmkf2YsTt2vemd0qxmKuLiaA2JcHYc7F5/5R7d
         2KQ2lsQ8NtLAMe/hH+Zvwvb9xh3Zy7XWBv+cDJ9XKZkn98f1rfW1ugo3Iq18/s2GEhPw
         ovOqg7dqMm3yk+lqdYEX/a33+iIwKyxKKI2YHZvttxFFZVMvEYxpzZJP0IQ1VD26+fMs
         2s9A==
X-Gm-Message-State: AOAM531jcMOldpyw88FLOXlDhmY77V6saZf7/rqAdRT/wT0mScG6O6UE
        uV4vSAhrCXX4qH19unITTWfZ3cPwQ/pZblvj7uQ=
X-Google-Smtp-Source: ABdhPJwUB6v5r8kFfQuLM5k7OwgpWFsDXPWOy2alHN9MmNuqQa4M2/XgsmZGOklg9WIxFTkbBgaTzcpUl7/IOCwTTU0=
X-Received: by 2002:a63:2265:: with SMTP id t37mr9725379pgm.336.1611730808252;
 Tue, 26 Jan 2021 23:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com> <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
In-Reply-To: <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 26 Jan 2021 22:59:57 -0800
Message-ID: <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 2:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/22/21 9:54 PM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This borrows the idea from conntrack and will be used for conntrack in
> > ebpf too. Each element in a timeout map has a user-specified timeout
> > in msecs, after it expires it will be automatically removed from the
> > map. Cilium already does the same thing, it uses a regular map or LRU
> > map to track connections and has its own GC in user-space. This does
> > not scale well when we have millions of connections, as each removal
> > needs a syscall. Even if we could batch the operations, it still needs
> > to copy a lot of data between kernel and user space.
> >
> > There are two cases to consider here:
> >
> > 1. When the timeout map is idle, i.e. no one updates or accesses it,
> >     we rely on the delayed work to scan the whole hash table and remove
> >     these expired. The delayed work is scheduled every 1 sec when idle,
> >     which is also what conntrack uses. It is fine to scan the whole
> >     table as we do not actually remove elements during this scan,
> >     instead we simply queue them to the lockless list and defer all the
> >     removals to the next schedule.
> >
> > 2. When the timeout map is actively accessed, we could reach expired
> >     elements before the idle work automatically scans them, we can
> >     simply skip them and schedule the delayed work immediately to do
> >     the actual removals. We have to avoid taking locks on fast path.
> >
> > The timeout of an element can be set or updated via bpf_map_update_elem()
> > and we reuse the upper 32-bit of the 64-bit flag for the timeout value,
> > as there are only a few bits are used currently. Note, a zero timeout
> > means to expire immediately.
> >
> > To avoid adding memory overhead to regular map, we have to reuse some
> > field in struct htab_elem, that is, lru_node. Otherwise we would have
> > to rewrite a lot of code.
> >
> > For now, batch ops is not supported, we can add it later if needed.
>
> Back in earlier conversation [0], I mentioned also LRU map flavors and to look
> into adding a flag, so we wouldn't need new BPF_MAP_TYPE_TIMEOUT_HASH/*LRU types
> that replicate existing types once again just with the timeout in addition, so
> UAPI wise new map type is not great.

Interestingly, Jamal also brought this flag up to me.

The reason why I don't use a flag is that I don't see any other maps need a
timeout. Take the LRU map you mentioned as an example, it evicts elements
based on size, not based on time, I can't think of a case where we need both
time and size based eviction. Another example is array, there is no way to
delete an element from an array, so we can't really expire an element.

Or do you have any use case for a non-regular hash map with timeout?

>
> Given you mention Cilium above, only for kernels where there is no LRU hash map,
> that is < 4.10, we rely on plain hash, everything else LRU + prealloc to mitigate
> ddos by refusing to add new entries when full whereas less active ones will be
> purged instead. Timeout /only/ for plain hash is less useful overall, did you

The difference between LRU and a timeout map is whether we should
drop the least recently used one too when it is full. For conntrack, this is not
a good idea, because when we have a burst of connections, the least recently
used might be just 1-s old, so evicting it out is not a good idea.
With a timeout
map, we just drop all new connection when it is full and wait for some connect
to timeout naturally, aligned with the definition of conntrack.

So it should be a good replacement for LRU map too in terms of conntrack.

> sketch a more generic approach in the meantime that would work for all the htab/lru
> flavors (and ideally as non-delayed_work based)?

If you mean LRU maps may need timeout too, like I explained above, I can't think
of any such use cases.

>
>    [0] https://lore.kernel.org/bpf/20201214201118.148126-1-xiyou.wangcong@gmail.com/
>
> [...]
> > @@ -1012,6 +1081,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >                       copy_map_value_locked(map,
> >                                             l_old->key + round_up(key_size, 8),
> >                                             value, false);
> > +                     if (timeout_map)
> > +                             l_old->expires = msecs_to_expire(timeout);
> >                       return 0;
> >               }
> >               /* fall through, grab the bucket lock and lookup again.
> > @@ -1020,6 +1091,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >                */
> >       }
> >
> > +again:
> >       ret = htab_lock_bucket(htab, b, hash, &flags);
> >       if (ret)
> >               return ret;
> > @@ -1040,26 +1112,41 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >               copy_map_value_locked(map,
> >                                     l_old->key + round_up(key_size, 8),
> >                                     value, false);
> > +             if (timeout_map)
> > +                     l_old->expires = msecs_to_expire(timeout);
> >               ret = 0;
> >               goto err;
> >       }
> >
> >       l_new = alloc_htab_elem(htab, key, value, key_size, hash, false, false,
> > -                             l_old);
> > +                             timeout_map, l_old);
> >       if (IS_ERR(l_new)) {
> > -             /* all pre-allocated elements are in use or memory exhausted */
> >               ret = PTR_ERR(l_new);
> > +             if (ret == -EAGAIN) {
> > +                     htab_unlock_bucket(htab, b, hash, flags);
> > +                     htab_gc_elem(htab, l_old);
> > +                     mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
> > +                     goto again;
>
> Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
> in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?

In this case, the old one is scheduled for removal in GC, we just wait for GC
to finally remove it. It won't stall unless GC itself or the worker scheduler is
wrong, both of which should be kernel bugs.

If we don't do this, users would get a -E2BIG when it is not too big. I don't
know a better way to handle this sad situation, maybe returning -EBUSY
to users and let them call again?

Thanks.
