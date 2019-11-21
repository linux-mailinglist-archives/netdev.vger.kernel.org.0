Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8300B105BF0
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfKUV15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:27:57 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46518 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUV14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:27:56 -0500
Received: by mail-qt1-f196.google.com with SMTP id r20so5325690qtp.13
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EOsLDEZ2mm6+AifANcRXdQzqnW0qpK8hxE5Na7rSj0A=;
        b=avEYS4TuxC686DAIAnDh2UNafxa6OMm0iz4jAzXtKpEikdD1x7YtbaD5k3SCjNbmIe
         leW5P64TOMajhWA82sMcN4kWVGZd8rqMVca1Yko/Kt09OjE0FQE3bBVzF2N30EgtWZIy
         Y2Xk7nO4nNkwHaIkZRdMe5NhELWCDT6Bqmw0fi5lIhE8nxIpWtTCa0j4D2dC4mptR8he
         uWIj/FCBbPt/zLJ6O5h7tG/Nv9vnfY3VlC1/cJCNA39jGoFR/8iEwFz8DVew7HOCfmVS
         5urR9UKMqd+bYAXVVb57u6mCVZxq+lTf0MDp3oE5rvN5W/19aIlcocof+0rftTfihQTm
         J9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EOsLDEZ2mm6+AifANcRXdQzqnW0qpK8hxE5Na7rSj0A=;
        b=TXqgZzXoFzZlWUgo+vIq3JS39rwDLnZ30DZHU8EDokjdp3gxKyR8i4oLFe5ZFVcdWR
         1gf2n7YOaoqNeoBzsOyuNsimfmRGp7CG+86JFlhTMQ04JhRSGCCNWtZ3fHoft5j4mdiG
         Vz8u4KSQ6Hcjjy6fRpz8dJkBbFrpLJpoCgmgFY52tRNH29OZnSX75fBfOOsliIJ1AoG0
         iH3Wg8d8cUgpyjINTroqxPNhsdBUTBsICh7BhOEYX7l+GqVs+57rYDgo0PXJQTTfGZ0z
         xoHK17NHH26RS6NXRmvr+ee+dY8gLUVIBwtopWU7XQFe2ZGT4InuRaUERGgMf3R5fJZw
         8UBg==
X-Gm-Message-State: APjAAAUy4XmoBnfEcnshTMYbmemmHOoXlsVJ4AJrvM7hZwseehLFczFj
        ZFTEEeiBqJA98OJmkJq0KEWPO9X2UH8SM1aGlOBRaQ==
X-Google-Smtp-Source: APXvYqyXKAhmTcwdqwKUxKu9GOOueMK/oZIZMhwZDved/K/OJrCS0abMv8+60myguX/jL+2yXh5WGOMpKGiraACBciU=
X-Received: by 2002:ac8:3711:: with SMTP id o17mr11079716qtb.159.1574371674869;
 Thu, 21 Nov 2019 13:27:54 -0800 (PST)
MIME-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com> <20191119193036.92831-6-brianvv@google.com>
 <ef4f39b8-e105-c72b-36cd-5552363f4311@fb.com>
In-Reply-To: <ef4f39b8-e105-c72b-36cd-5552363f4311@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 21 Nov 2019 13:27:43 -0800
Message-ID: <CAMzD94T-vMoTTx1-i01TsXjNE5-DOYf8VVtwJqLMK5z4GVXG+g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/9] bpf: add batch ops to all htab bpf map
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 10:27 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/19/19 11:30 AM, Brian Vazquez wrote:
> > From: Yonghong Song <yhs@fb.com>
> >
> > htab can't use generic batch support due some problematic behaviours
> > inherent to the data structre, i.e. while iterating the bpf map  a
> > concurrent program might delete the next entry that batch was about to
> > use, in that case there's no easy solution to retrieve the next entry,
> > the issue has been discussed multiple times (see [1] and [2]).
> >
> > The only way hmap can be traversed without the problem previously
> > exposed is by making sure that the map is traversing entire buckets.
> > This commit implements those strict requirements for hmap, the
> > implementation follows the same interaction that generic support with
> > some exceptions:
> >
> >   - If keys/values buffer are not big enough to traverse a bucket,
> >     ENOSPC will be returned.
> >   - out_batch contains the value of the next bucket in the iteration, not
> >     the next key, but this is transparent for the user since the user
> >     should never use out_batch for other than bpf batch syscalls.
> >
> > Note that only lookup and lookup_and_delete batch ops require the hmap
> > specific implementation, update/delete batch ops can be the generic
> > ones.
> >
> > [1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
> > [2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > ---
> >   kernel/bpf/hashtab.c | 244 +++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 244 insertions(+)
> >
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index 22066a62c8c97..3402174b292ea 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -17,6 +17,17 @@
> >       (BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |    \
> >        BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
> >
> > +#define BATCH_OPS(_name)                     \
> > +     .map_lookup_batch =                     \
> > +     _name##_map_lookup_batch,               \
> > +     .map_lookup_and_delete_batch =          \
> > +     _name##_map_lookup_and_delete_batch,    \
> > +     .map_update_batch =                     \
> > +     generic_map_update_batch,               \
> > +     .map_delete_batch =                     \
> > +     generic_map_delete_batch
> > +
> > +
> >   struct bucket {
> >       struct hlist_nulls_head head;
> >       raw_spinlock_t lock;
> > @@ -1232,6 +1243,235 @@ static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
> >       rcu_read_unlock();
> >   }
> >
> > +static int
> > +__htab_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                                const union bpf_attr *attr,
> > +                                union bpf_attr __user *uattr,
> > +                                bool do_delete, bool is_lru_map,
> > +                                bool is_percpu)
> > +{
> > +     struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> > +     u32 bucket_cnt, total, key_size, value_size, roundup_key_size;
> > +     void *keys = NULL, *values = NULL, *value, *dst_key, *dst_val;
> > +     void __user *ukeys, *uvalues, *ubatch;
> > +     u64 elem_map_flags, map_flags;
> > +     struct hlist_nulls_head *head;
> > +     struct hlist_nulls_node *n;
> > +     u32 batch, max_count, size;
> > +     unsigned long flags;
> > +     struct htab_elem *l;
> > +     struct bucket *b;
> > +     int ret = 0;
> > +
> > +     max_count = attr->batch.count;
> > +     if (!max_count)
> > +             return 0;
> > +
> > +     elem_map_flags = attr->batch.elem_flags;
> > +     if ((elem_map_flags & ~BPF_F_LOCK) ||
> > +         ((elem_map_flags & BPF_F_LOCK) && !map_value_has_spin_lock(map)))
> > +             return -EINVAL;
> > +
> > +     map_flags = attr->batch.flags;
> > +     if (map_flags)
> > +             return -EINVAL;
> > +
> > +     batch = 0;
> > +     ubatch = u64_to_user_ptr(attr->batch.in_batch);
> > +     if (ubatch && copy_from_user(&batch, ubatch, sizeof(batch)))
> > +             return -EFAULT;
> > +
> > +     if (batch >= htab->n_buckets)
> > +             return -ENOENT;
> > +
> > +     /* We cannot do copy_from_user or copy_to_user inside
> > +      * the rcu_read_lock. Allocate enough space here.
> > +      */
> > +     key_size = htab->map.key_size;
> > +     roundup_key_size = round_up(htab->map.key_size, 8);
> > +     value_size = htab->map.value_size;
> > +     size = round_up(value_size, 8);
> > +     if (is_percpu)
> > +             value_size = size * num_possible_cpus();
> > +     keys = kvmalloc(key_size * max_count, GFP_USER | __GFP_NOWARN);
> > +     values = kvmalloc(value_size * max_count, GFP_USER | __GFP_NOWARN);
> > +     if (!keys || !values) {
> > +             ret = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     dst_key = keys;
> > +     dst_val = values;
> > +     total = 0;
> > +
> > +     preempt_disable();
> > +     this_cpu_inc(bpf_prog_active);
> > +     rcu_read_lock();
> > +
> > +again:
> > +     b = &htab->buckets[batch];
> > +     head = &b->head;
> > +     raw_spin_lock_irqsave(&b->lock, flags);
>
> Brian, you have some early comments whether we could
> remove locks for lookup only. Do you still think this
> is needed?

Yes I was thinking that for some applications that have control when
they delete and lookup, the bucket lock could be avoided, but at this
point I'd prefer to always grab it, to try to be as consistent as
possible. Something that we might add later is to check the first
entry (without grabbing the lock)  to see if is a null_elem and the
bucket is empty, and based on the answer skip it or grab the lock, but
this would be racy.

>
> If this is still desired, the below is a possible approach:
>   - lock will be used when delete is also needed.
>   - we still do a preliminary counting to get bucket_cnt,
>     but for lookup, it may not guarantee that all elements
>     in the bucket will be copied since there could be
>     parallel update which may add more elements to the bucket.
> This probably should be okay.
> If needed, later on, we can add a flag to permit locking.
>
> > +
> > +     bucket_cnt = 0;
> > +     hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
> > +             bucket_cnt++;
> > +
> > +     if (bucket_cnt > (max_count - total)) {
> > +             if (total == 0)
> > +                     ret = -ENOSPC;
> > +             goto after_loop;
> > +     }
> > +
> > +     hlist_nulls_for_each_entry_rcu(l, n, head, hash_node) {
> > +             memcpy(dst_key, l->key, key_size);
> > +
> > +             if (is_percpu) {
> > +                     int off = 0, cpu;
> > +                     void __percpu *pptr;
> > +
> > +                     pptr = htab_elem_get_ptr(l, map->key_size);
> > +                     for_each_possible_cpu(cpu) {
> > +                             bpf_long_memcpy(dst_val + off,
> > +                                             per_cpu_ptr(pptr, cpu), size);
> > +                             off += size;
> > +                     }
> > +             } else {
> > +                     value = l->key + roundup_key_size;
> > +                     if (elem_map_flags & BPF_F_LOCK)
> > +                             copy_map_value_locked(map, dst_val, value,
> > +                                                   true);
> > +                     else
> > +                             copy_map_value(map, dst_val, value);
> > +                     check_and_init_map_lock(map, dst_val);
> > +             }
>
> It is possible we can move the below do_delete loop body here.
> We need to change hlist_nulls_for_each_entry_rcu to
> hlist_nulls_for_each_entry_safe.
> Once you have next patch, we can ask some RCU experts to help
> ensure implementation correctness.

Sounds good, will work on it and send next version soon.

>
> > +             dst_key += key_size;
> > +             dst_val += value_size;
> > +             total++;
> > +     }
> > +
> > +     if (do_delete) {
> > +             hlist_nulls_for_each_entry_rcu(l, n, head, hash_node) {
> > +                     hlist_nulls_del_rcu(&l->hash_node);
> > +                     if (is_lru_map)
> > +                             bpf_lru_push_free(&htab->lru, &l->lru_node);
> > +                     else
> > +                             free_htab_elem(htab, l);
> > +             }
> > +     }
> > +
> > +     batch++;
> > +     if (batch >= htab->n_buckets) {
> > +             ret = -ENOENT;
> > +             goto after_loop;
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&b->lock, flags);
> > +     goto again;
> > +
> > +after_loop:
> > +     raw_spin_unlock_irqrestore(&b->lock, flags);
> > +
> > +     rcu_read_unlock();
> > +     this_cpu_dec(bpf_prog_active);
> > +     preempt_enable();
> > +
> > +     if (ret && ret != -ENOENT)
> > +             goto out;
> > +
> > +     /* copy data back to user */
> > +     ukeys = u64_to_user_ptr(attr->batch.keys);
> > +     uvalues = u64_to_user_ptr(attr->batch.values);
> > +     ubatch = u64_to_user_ptr(attr->batch.out_batch);
> > +     if (copy_to_user(ubatch, &batch, sizeof(batch)) ||
> > +         copy_to_user(ukeys, keys, total * key_size) ||
> > +         copy_to_user(uvalues, values, total * value_size) ||
> > +         put_user(total, &uattr->batch.count))
> > +             ret = -EFAULT;
> > +
> > +out:
> > +     kvfree(keys);
> > +     kvfree(values);
> > +     return ret;
> > +}
> > +
> > +static int
> > +htab_percpu_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
> > +                          union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
> > +                                               false, true);
> > +}
> > +
> > +static int
> > +htab_percpu_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                                     const union bpf_attr *attr,
> > +                                     union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
> > +                                               false, true);
> > +}
> > +
> > +static int
> > +htab_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
> > +                   union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
> > +                                               false, false);
> > +}
> > +
> > +static int
> > +htab_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                              const union bpf_attr *attr,
> > +                              union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
> > +                                               false, false);
> > +}
> > +
> > +static int
> > +htab_map_delete_batch(struct bpf_map *map,
> > +                   const union bpf_attr *attr,
> > +                   union bpf_attr __user *uattr)
> > +{
> > +     return generic_map_delete_batch(map, attr, uattr);
> > +}
> > +
> > +static int
> > +htab_lru_percpu_map_lookup_batch(struct bpf_map *map,
> > +                              const union bpf_attr *attr,
> > +                              union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
> > +                                               true, true);
> > +}
> > +
> > +static int
> > +htab_lru_percpu_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                                         const union bpf_attr *attr,
> > +                                         union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
> > +                                               true, true);
> > +}
> > +
> > +static int
> > +htab_lru_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
> > +                       union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
> > +                                               true, false);
> > +}
> > +
> > +static int
> > +htab_lru_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                                  const union bpf_attr *attr,
> > +                                  union bpf_attr __user *uattr)
> > +{
> > +     return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
> > +                                               true, false);
> > +}
> > +
> >   const struct bpf_map_ops htab_map_ops = {
> >       .map_alloc_check = htab_map_alloc_check,
> >       .map_alloc = htab_map_alloc,
> > @@ -1242,6 +1482,7 @@ const struct bpf_map_ops htab_map_ops = {
> >       .map_delete_elem = htab_map_delete_elem,
> >       .map_gen_lookup = htab_map_gen_lookup,
> >       .map_seq_show_elem = htab_map_seq_show_elem,
> > +     BATCH_OPS(htab),
> >   };
> >
> >   const struct bpf_map_ops htab_lru_map_ops = {
> > @@ -1255,6 +1496,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
> >       .map_delete_elem = htab_lru_map_delete_elem,
> >       .map_gen_lookup = htab_lru_map_gen_lookup,
> >       .map_seq_show_elem = htab_map_seq_show_elem,
> > +     BATCH_OPS(htab_lru),
> >   };
> >
> >   /* Called from eBPF program */
> > @@ -1368,6 +1610,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
> >       .map_update_elem = htab_percpu_map_update_elem,
> >       .map_delete_elem = htab_map_delete_elem,
> >       .map_seq_show_elem = htab_percpu_map_seq_show_elem,
> > +     BATCH_OPS(htab_percpu),
> >   };
> >
> >   const struct bpf_map_ops htab_lru_percpu_map_ops = {
> > @@ -1379,6 +1622,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
> >       .map_update_elem = htab_lru_percpu_map_update_elem,
> >       .map_delete_elem = htab_lru_map_delete_elem,
> >       .map_seq_show_elem = htab_percpu_map_seq_show_elem,
> > +     BATCH_OPS(htab_lru_percpu),
> >   };
> >
> >   static int fd_htab_map_alloc_check(union bpf_attr *attr)
> >
