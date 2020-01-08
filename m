Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E321337F4
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 01:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgAHAdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 19:33:13 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35160 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHAdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 19:33:13 -0500
Received: by mail-lj1-f196.google.com with SMTP id j1so1513463lja.2;
        Tue, 07 Jan 2020 16:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Psvm9LJ7IluzH0skOPU3QbG029tkF0t15sChZCq5Co=;
        b=liz5nlX/0WhjXeVkxHfg2p5/bPmAyZtTYgLd1Ue5kc1Khtd4kFwydm0LJmLxyP/ga2
         BC//476fvHjd3rW7zMWjfWXHk9JDrjMvJY2uULaDwkpSA9ouD2191wsPM5ybIxKPy9vd
         hmq+qK9MSikKS322F/di6+Tq7ECTo2ljtM8sTJu3NJ4WdSmQ2cLQldqfP/+40JEnILG0
         XWqxhNHiZR23AytiNO//Aaw4P0nYOqKoDPfzQB7qtbF5+1nrhFHz+S8qzkIRPe6D8J/a
         fyE8nYc/0lQjvi+rfLrPRAP5g0kyvuxOpE49dE3NNYxb/dRzCZJ9qaSVSOjNsEI6wI5s
         hKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Psvm9LJ7IluzH0skOPU3QbG029tkF0t15sChZCq5Co=;
        b=nXs4fPWtwF1QffXcGsxjHXWxnX2zoH3pXf4raPguNoTdBN4oq9v1wLAvHWGH0POMcI
         eT/lhxCr8BW9TSYsQN2WBasGHfQIlslTkIJlA2rQ8eMSFd97A2idwFJrB31ZHqzb7TPG
         NQ7it/ho7U70GCMKRft9EVXiDDelf2ZmZmkOHVDlqsdHGkmVqjjKXuDoOBnLYjNRGi+9
         26nXlxDyJ/AkIdcJRS3VQ+egBs10ZNXz4dzZcUiwGcvk9DrQFkeYlK3Y802pIcBtRvoB
         gYkdgiGz9nRZypJmOFvkLKnU8c6oQ1QxKdmRbArzNmVy9SA3FsPnTjfgrApjFXcXUXQa
         BcgQ==
X-Gm-Message-State: APjAAAV5YW+fOdy/knhRTG/aEI4zytklh5YUkMwlr5jLFpRIfaywvLGf
        ulcwtv4+JlEOZ3QcYIhjK+ymtV6nj0VQ7cEplO0=
X-Google-Smtp-Source: APXvYqxDmVIVb2/2b9j3QpddNsdJNbyxqujhgTR1axhpW6MEh40gig3MFCHC7uRGEccswHf7qfPP5XRj5FDprHcPv3g=
X-Received: by 2002:a2e:93d5:: with SMTP id p21mr1325892ljh.50.1578443589704;
 Tue, 07 Jan 2020 16:33:09 -0800 (PST)
MIME-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com> <20191211223344.165549-7-brianvv@google.com>
 <a33dab7b-0f46-c29f-0db1-a5539c433b3d@fb.com> <CABCgpaVC-gCf58VmCx2XwwHoZ2FXHmtBfqzqJoPeeg2Q=DvRzg@mail.gmail.com>
 <8ba54068-0a0f-479e-e4d7-42bfb7f8ed55@fb.com>
In-Reply-To: <8ba54068-0a0f-479e-e4d7-42bfb7f8ed55@fb.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Tue, 7 Jan 2020 18:32:58 -0600
Message-ID: <CABCgpaV-7x1aBjd+NguOD5tqAaZigHjvSsirTFu_oT+7o8WtLQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: add batch ops to all htab bpf map
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv@google.com>,
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

On Tue, Jan 7, 2020 at 12:18 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/6/20 11:02 PM, Brian Vazquez wrote:
> > On Fri, Dec 13, 2019 at 12:58 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 12/11/19 2:33 PM, Brian Vazquez wrote:
> >>> From: Yonghong Song <yhs@fb.com>
> >>>
> >>> htab can't use generic batch support due some problematic behaviours
> >>> inherent to the data structre, i.e. while iterating the bpf map  a
> >>> concurrent program might delete the next entry that batch was about to
> >>> use, in that case there's no easy solution to retrieve the next entry,
> >>> the issue has been discussed multiple times (see [1] and [2]).
> >>>
> >>> The only way hmap can be traversed without the problem previously
> >>> exposed is by making sure that the map is traversing entire buckets.
> >>> This commit implements those strict requirements for hmap, the
> >>> implementation follows the same interaction that generic support with
> >>> some exceptions:
> >>>
> >>>    - If keys/values buffer are not big enough to traverse a bucket,
> >>>      ENOSPC will be returned.
> >>>    - out_batch contains the value of the next bucket in the iteration, not
> >>>      the next key, but this is transparent for the user since the user
> >>>      should never use out_batch for other than bpf batch syscalls.
> >>>
> >>> Note that only lookup and lookup_and_delete batch ops require the hmap
> >>> specific implementation, update/delete batch ops can be the generic
> >>> ones.
> >>>
> >>> [1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
> >>> [2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
> >>>
> >>> Signed-off-by: Yonghong Song <yhs@fb.com>
> >>> Signed-off-by: Brian Vazquez <brianvv@google.com>
> >>> ---
> >>>    kernel/bpf/hashtab.c | 242 +++++++++++++++++++++++++++++++++++++++++++
> >>>    1 file changed, 242 insertions(+)
> >>>
> >>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> >>> index 22066a62c8c97..fac107bdaf9ec 100644
> >>> --- a/kernel/bpf/hashtab.c
> >>> +++ b/kernel/bpf/hashtab.c
> >>> @@ -17,6 +17,17 @@
> >>>        (BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |    \
> >>>         BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
> >>>
> >>> +#define BATCH_OPS(_name)                     \
> >>> +     .map_lookup_batch =                     \
> >>> +     _name##_map_lookup_batch,               \
> >>> +     .map_lookup_and_delete_batch =          \
> >>> +     _name##_map_lookup_and_delete_batch,    \
> >>> +     .map_update_batch =                     \
> >>> +     generic_map_update_batch,               \
> >>> +     .map_delete_batch =                     \
> >>> +     generic_map_delete_batch
> >>> +
> >>> +
> >>>    struct bucket {
> >>>        struct hlist_nulls_head head;
> >>>        raw_spinlock_t lock;
> >>> @@ -1232,6 +1243,233 @@ static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
> >>>        rcu_read_unlock();
> >>>    }
> >>>
> >>> +static int
> >>> +__htab_map_lookup_and_delete_batch(struct bpf_map *map,
> >>> +                                const union bpf_attr *attr,
> >>> +                                union bpf_attr __user *uattr,
> >>> +                                bool do_delete, bool is_lru_map,
> >>> +                                bool is_percpu)
> >>> +{
> >>> +     struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> >>> +     u32 bucket_cnt, total, key_size, value_size, roundup_key_size;
> >>> +     void *keys = NULL, *values = NULL, *value, *dst_key, *dst_val;
> >>> +     void __user *uvalues = u64_to_user_ptr(attr->batch.values);
> >>> +     void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
> >>> +     void *ubatch = u64_to_user_ptr(attr->batch.in_batch);
> >>> +     u64 elem_map_flags, map_flags;
> >>> +     struct hlist_nulls_head *head;
> >>> +     u32 batch, max_count, size;
> >>> +     struct hlist_nulls_node *n;
> >>> +     unsigned long flags;
> >>> +     struct htab_elem *l;
> >>> +     struct bucket *b;
> >>> +     int ret = 0;
> >>> +
> >>> +     max_count = attr->batch.count;
> >>> +     if (!max_count)
> >>> +             return 0;
> >>> +
> >>> +     elem_map_flags = attr->batch.elem_flags;
> >>> +     if ((elem_map_flags & ~BPF_F_LOCK) ||
> >>> +         ((elem_map_flags & BPF_F_LOCK) && !map_value_has_spin_lock(map)))
> >>> +             return -EINVAL;
> >>> +
> >>> +     map_flags = attr->batch.flags;
> >>> +     if (map_flags)
> >>> +             return -EINVAL;
> >>> +
> >>> +     batch = 0;
> >>> +     if (ubatch && copy_from_user(&batch, ubatch, sizeof(batch)))
> >>> +             return -EFAULT;
> >>> +
> >>> +     if (batch >= htab->n_buckets)
> >>> +             return -ENOENT;
> >>> +
> >>> +     /* We cannot do copy_from_user or copy_to_user inside
> >>> +      * the rcu_read_lock. Allocate enough space here.
> >>> +      */
> >>> +     key_size = htab->map.key_size;
> >>> +     roundup_key_size = round_up(htab->map.key_size, 8);
> >>> +     value_size = htab->map.value_size;
> >>> +     size = round_up(value_size, 8);
> >>> +     if (is_percpu)
> >>> +             value_size = size * num_possible_cpus();
> >>> +     keys = kvmalloc(key_size, GFP_USER | __GFP_NOWARN);
> >>> +     values = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
> >>> +     if (!keys || !values) {
> >>> +             ret = -ENOMEM;
> >>> +             goto out;
> >>> +     }
> >>> +
> >>> +     dst_key = keys;
> >>> +     dst_val = values;
> >>> +     total = 0;
> >>> +
> >>> +     preempt_disable();
> >>> +     this_cpu_inc(bpf_prog_active);
> >>> +     rcu_read_lock();
> >>> +
> >>> +again:
> >>> +     b = &htab->buckets[batch];
> >>> +     head = &b->head;
> >>> +     raw_spin_lock_irqsave(&b->lock, flags);
> >>> +
> >>> +     bucket_cnt = 0;
> >>> +     hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
> >>> +             bucket_cnt++;
> >>> +
> >>> +     if (bucket_cnt > (max_count - total)) {
> >>> +             if (total == 0)
> >>> +                     ret = -ENOSPC;
> >>> +             goto after_loop;
> >>> +     }
> >>> +
> >>> +     hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >>> +             memcpy(dst_key, l->key, key_size);
> >>> +
> >>> +             if (is_percpu) {
> >>> +                     int off = 0, cpu;
> >>> +                     void __percpu *pptr;
> >>> +
> >>> +                     pptr = htab_elem_get_ptr(l, map->key_size);
> >>> +                     for_each_possible_cpu(cpu) {
> >>> +                             bpf_long_memcpy(dst_val + off,
> >>> +                                             per_cpu_ptr(pptr, cpu), size);
> >>> +                             off += size;
> >>> +                     }
> >>> +             } else {
> >>> +                     value = l->key + roundup_key_size;
> >>> +                     if (elem_map_flags & BPF_F_LOCK)
> >>> +                             copy_map_value_locked(map, dst_val, value,
> >>> +                                                   true);
> >>> +                     else
> >>> +                             copy_map_value(map, dst_val, value);
> >>> +                     check_and_init_map_lock(map, dst_val);
> >>> +             }
> >>> +             if (do_delete) {
> >>> +                     hlist_nulls_del_rcu(&l->hash_node);
> >>> +                     if (is_lru_map)
> >>> +                             bpf_lru_push_free(&htab->lru, &l->lru_node);
> >>> +                     else
> >>> +                             free_htab_elem(htab, l);
> >>> +             }
> >>> +             if (copy_to_user(ukeys + total * key_size, keys, key_size) ||
> >>> +                copy_to_user(uvalues + total * value_size, values,
> >>> +                value_size)) {
> >>
> >> We cannot do copy_to_user inside atomic region where irq is disabled
> >> with raw_spin_lock_irqsave(). We could do the following:
> >>      . we kalloc memory before preempt_disable() with the current count
> >>        of bucket size.
> >>      . inside the raw_spin_lock_irqsave() region, we can do copy to kernel
> >>        memory.
> >>      . inside the raw_spin_lock_irqsave() region, if the bucket size
> >>        changes, we can have a few retries to increase allocation size
> >>        before giving up.
> >> Do you think this may work?
> >
> > Yes, it does.
> >
> > What should be the initial value for the allocated memory
> > max_entries/2? Do you see any issue if we just kalloc the entire
> > buffer?
>
> Allocating max_entries/2 or entire buffer risks allocating too much
> memory from the system, which may not be a good thing in a production
> system. That is why I proposed to allocate memory at bucket level.
> For a reasonable balanced hash table, this should not cause large
> memory pressure on the host. What do you think?

Sounds reasonable, I'll do that! Thanks for the feedback!
>
> >
> >>
> >>> +                     ret = -EFAULT;
> >>> +                     goto after_loop;
> >>> +             }
> >>> +             total++;
> >>> +     }
> >>> +
> >>> +     batch++;
> >>> +     if (batch >= htab->n_buckets) {
> >>> +             ret = -ENOENT;
> >>> +             goto after_loop;
> >>> +     }
> >>> +
> >>> +     raw_spin_unlock_irqrestore(&b->lock, flags);
> >>> +     goto again;
> >>> +
> >>> +after_loop:
> >>> +     raw_spin_unlock_irqrestore(&b->lock, flags);
> >>> +
> >>> +     rcu_read_unlock();
> >>> +     this_cpu_dec(bpf_prog_active);
> >>> +     preempt_enable();
> >>> +
> >>> +     if (ret && ret != -ENOENT)
> >>> +             goto out;
> >>> +
> >>> +     /* copy data back to user */
> >>> +     ubatch = u64_to_user_ptr(attr->batch.out_batch);
> >>> +     if (copy_to_user(ubatch, &batch, sizeof(batch)) ||
> >>> +         put_user(total, &uattr->batch.count))
> >>> +             ret = -EFAULT;
> >>> +
> >>> +out:
> >>> +     kvfree(keys);
> >>> +     kvfree(values);
> >>> +     return ret;
> >>> +}
> >>> +
> >> [...]
