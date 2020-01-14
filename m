Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EC313B623
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 00:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgANXt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 18:49:27 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38640 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgANXt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 18:49:27 -0500
Received: by mail-qt1-f194.google.com with SMTP id c24so3405890qtp.5
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 15:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUjpZG4ixb2Nzy2QAGXjuxzzDZGZeqZ0R8vfzdsVIrE=;
        b=QnbigNuLH3a0/kKJs3InjIxunyDxznnpGBQuLTlkAxiqIhno8r0zrzXw1SsNBnMViL
         32qy6amxa/6ClRbKtB7c2gVaTg5X+zd2X7x0ntAXSKNYPKgJthDWd6AkhnnB5P7bovcF
         TFKPZInBSuud2LmZ3cFUsePj2xZrYEgMQG3Ex+8QGLNayBWiAJ4/9OhdLMN+MAxmBpuj
         i8ALe4sZ7mDBdqB057M6bN3xL5Izkj5Rro9c6jSHzCtXl6lQXrX5R1ED0CRu7NhiSiGw
         ZYNJ4TEe2Oa1gORVufSDoz2dh+FbE6XebbntumUdnovjJ+FlLNi7UE21Mz4eXguLAQkw
         NWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUjpZG4ixb2Nzy2QAGXjuxzzDZGZeqZ0R8vfzdsVIrE=;
        b=fWkIEPd81IPQrhfzleXr6alkvmWDCPpaSmF504aviY8+mpkP+mfQ6aDiq4TWRuIA+E
         T3fsnxO3Z6ta39T2pxwdQfQpScRa2qHGEAG+wTFjihX5l0HTspEcXWSpEc1xVAjbexXE
         0bMhPEcIvA9SO6kuj5UyzBxlxgOA9VyZPbtNf9uFyrsctr9TojPkRXH21zPwjpkiearn
         h3zyxxzjNS2eLc9u6bvLk6AJiT7Aakgap/M6aQDc865/3RGnKb3gE3iZCYKhVZN4qjPI
         /lWpBmGi+KbVF5J3+tlVKjoWnrfF+a08o8Mic6dM1DwtDvbqeTN82W03KDuxh94B6Bbk
         TxAQ==
X-Gm-Message-State: APjAAAWy5Fszv9EqPryZWxvfx2t8lUwUEZzTq2k6bTKEGQaCfMRaQTnV
        bIGTEF+kyy5eZQ1pdqz3zsThCxYCuIPnbEPTgfSdVQ==
X-Google-Smtp-Source: APXvYqz/PlygCtAQxO783xNAdwVYlOnCniP+8dH6TnTrcGApC5pvLZgXt5e41UeswrizGWbuQfzs7deXCoPk9gRE/5E=
X-Received: by 2002:ac8:8d6:: with SMTP id y22mr1037732qth.85.1579045765420;
 Tue, 14 Jan 2020 15:49:25 -0800 (PST)
MIME-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com> <20200114164614.47029-7-brianvv@google.com>
 <df0c1cdc-bfb9-6d56-2573-7c0d37f3ba17@fb.com>
In-Reply-To: <df0c1cdc-bfb9-6d56-2573-7c0d37f3ba17@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 14 Jan 2020 15:49:14 -0800
Message-ID: <CAMzD94SDk=y5=hpcYOUYnKnqpQbFCyNu-FiXatJPisancvr7gw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/9] bpf: add batch ops to all htab bpf map
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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

Hi Yonghong, thanks for reviewing it!

On Tue, Jan 14, 2020 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/14/20 8:46 AM, Brian Vazquez wrote:
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
> > This commits implements BPF_MAP_LOOKUP_BATCH and adds support for new
> > command BPF_MAP_LOOKUP_AND_DELETE_BATCH. Note that for update/delete
> > batch ops it is possible to use the generic implementations.
> >
> > [1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
> > [2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > ---
> >   include/linux/bpf.h      |   3 +
> >   include/uapi/linux/bpf.h |   1 +
> >   kernel/bpf/hashtab.c     | 258 +++++++++++++++++++++++++++++++++++++++
> >   kernel/bpf/syscall.c     |   9 +-
> >   4 files changed, 270 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 05466ad6cf1c5..3517e32149a4f 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -46,6 +46,9 @@ struct bpf_map_ops {
> >       void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
> >       int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
> >                               union bpf_attr __user *uattr);
> > +     int (*map_lookup_and_delete_batch)(struct bpf_map *map,
> > +                                        const union bpf_attr *attr,
> > +                                        union bpf_attr __user *uattr);
> >       int (*map_update_batch)(struct bpf_map *map, const union bpf_attr *attr,
> >                               union bpf_attr __user *uattr);
> >       int (*map_delete_batch)(struct bpf_map *map, const union bpf_attr *attr,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index e8df9ca680e0c..9536729a03d57 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -108,6 +108,7 @@ enum bpf_cmd {
> >       BPF_MAP_FREEZE,
> >       BPF_BTF_GET_NEXT_ID,
> >       BPF_MAP_LOOKUP_BATCH,
> > +     BPF_MAP_LOOKUP_AND_DELETE_BATCH,
> >       BPF_MAP_UPDATE_BATCH,
> >       BPF_MAP_DELETE_BATCH,
> >   };
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index 22066a62c8c97..d9888acfd632b 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -17,6 +17,16 @@
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
> >   struct bucket {
> >       struct hlist_nulls_head head;
> >       raw_spinlock_t lock;
> > @@ -1232,6 +1242,250 @@ static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
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
> > +     void __user *uvalues = u64_to_user_ptr(attr->batch.values);
> > +     void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
> > +     void *ubatch = u64_to_user_ptr(attr->batch.in_batch);
> > +     u32 batch, max_count, size, bucket_size;
> > +     u64 elem_map_flags, map_flags;
> > +     struct hlist_nulls_head *head;
> > +     struct hlist_nulls_node *n;
> > +     unsigned long flags;
> > +     struct htab_elem *l;
> > +     struct bucket *b;
> > +     int ret = 0;
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
> > +     max_count = attr->batch.count;
> > +     if (!max_count)
> > +             return 0;
> > +
> > +     batch = 0;
> > +     if (ubatch && copy_from_user(&batch, ubatch, sizeof(batch)))
> > +             return -EFAULT;
> > +
> > +     if (batch >= htab->n_buckets)
> > +             return -ENOENT;
> > +
> > +     key_size = htab->map.key_size;
> > +     roundup_key_size = round_up(htab->map.key_size, 8);
> > +     value_size = htab->map.value_size;
> > +     size = round_up(value_size, 8);
> > +     if (is_percpu)
> > +             value_size = size * num_possible_cpus();
> > +     total = 0;
> > +     bucket_size = 1;
>
> Have you checked typical hash table linklist length?
While testing with hash tables ranging from 10 to 1000 entries I saw
linked lists of upto 5 entries.
> Maybe initial value bucket_size = 2 is able to cover most common cases?
I think 4-5 is still a reasonable number, what do you think?
>
> > +
> > +alloc:
> > +     /* We cannot do copy_from_user or copy_to_user inside
> > +      * the rcu_read_lock. Allocate enough space here.
> > +      */
> > +     keys = kvmalloc(key_size * bucket_size, GFP_USER | __GFP_NOWARN);
> > +     values = kvmalloc(value_size * bucket_size, GFP_USER | __GFP_NOWARN);
> > +     if (!keys || !values) {
> > +             ret = -ENOMEM;
> > +             goto out;
>
> In this case, we won't copy batch and total to user buffer. Maybe we
> should do that?
Yes, I think last line should be: goto after_loop;
>
>
> > +     }
> > +
> > +again:
> > +     preempt_disable();
> > +     this_cpu_inc(bpf_prog_active);
> > +     rcu_read_lock();
> > +again_nocopy:
> > +     dst_key = keys;
> > +     dst_val = values;
> > +     b = &htab->buckets[batch];
> > +     head = &b->head;
> > +     raw_spin_lock_irqsave(&b->lock, flags);
> > +
> > +     bucket_cnt = 0;
> > +     hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
> > +             bucket_cnt++;
> > +
> > +     if (bucket_cnt > (max_count - total)) {
> > +             if (total == 0)
> > +                     ret = -ENOSPC;
> > +             raw_spin_unlock_irqrestore(&b->lock, flags);
> > +             rcu_read_unlock();
> > +             this_cpu_dec(bpf_prog_active);
> > +             preempt_enable();
> > +             goto after_loop;
> > +     }
> > +
> > +     if (bucket_cnt > bucket_size) {
> > +             bucket_size = bucket_cnt;
> > +             raw_spin_unlock_irqrestore(&b->lock, flags);
> > +             rcu_read_unlock();
> > +             this_cpu_dec(bpf_prog_active);
> > +             preempt_enable();
> > +             kvfree(keys);
> > +             kvfree(values);
> > +             goto alloc;
> > +     }
> > +
> > +     hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
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
> > +             if (do_delete) {
> > +                     hlist_nulls_del_rcu(&l->hash_node);
> > +                     if (is_lru_map)
> > +                             bpf_lru_push_free(&htab->lru, &l->lru_node);
> > +                     else
> > +                             free_htab_elem(htab, l);
> > +             }
> > +             dst_key += key_size;
> > +             dst_val += value_size;
> > +     }
> > +
> > +     raw_spin_unlock_irqrestore(&b->lock, flags);
> > +     /* If we are not copying data, we can go to next bucket and avoid
> > +      * unlocking the rcu.
> > +      */
> > +     if (!bucket_cnt && (batch + 1 < htab->n_buckets)) {
> > +             batch++;
> > +             goto again_nocopy;
> > +     }
> > +
> > +     rcu_read_unlock();
> > +     this_cpu_dec(bpf_prog_active);
> > +     preempt_enable();
> > +     if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
> > +         key_size * bucket_cnt) ||
> > +         copy_to_user(uvalues + total * value_size, values,
> > +         value_size * bucket_cnt))) {
> > +             ret = -EFAULT;
> > +             goto after_loop;
> > +     }
> > +
> > +     total += bucket_cnt;
> > +     batch++;
> > +     if (batch >= htab->n_buckets) {
> > +             ret = -ENOENT;
> > +             goto after_loop;
> > +     }
> > +     goto again;
> > +
> > +after_loop:
> > +     if (ret && (ret != -ENOENT && ret != -EFAULT))
> > +             goto out;
>
> We won't have many error codes reaching here, -ENOENT, -EFAULT, -ENOSPC,
> and possibly -ENOMEM.
> Maybe just
>         if (ret == -EFAULT)
>                 goto out;
>
Yes I think that make senses, I only need to add

if (put_user(0, &uattr->batch.count))
        return -EFAULT;

before traversing the map to make sure that if there is an error,
batch.count doesn't miss report entries since that variable is used as
input/output. Does this make sense?

> > +
> > +     /* copy # of entries and next batch */
> > +     ubatch = u64_to_user_ptr(attr->batch.out_batch);
> > +     if (copy_to_user(ubatch, &batch, sizeof(batch)) ||
> > +         put_user(total, &uattr->batch.count))
> > +             ret = -EFAULT;
> > +
> > +out:
> > +     kvfree(keys);
> > +     kvfree(values);
> > +     return ret;
> > +}
> > +
> [...]
