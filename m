Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24860163C4A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 05:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgBSEzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 23:55:42 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43380 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgBSEzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 23:55:42 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so25599703ljm.10;
        Tue, 18 Feb 2020 20:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YBSVt/C1uERwOBCw6Tfd2ihfw4ttURW20stCOCuUeeY=;
        b=hDiZMLUM827hnvN23kSWhwtokR+qs7BHdQeFo/iXV/Opgeito5PofamrpAHQ7MmvQu
         rJ+9tvLCfZ7bRJvCDAqiCjAJwwP57r4Xt2Ted1hOQpqRUw1s87ObyAu0dxGG14dcZ8o+
         +VbWSlCgdOASpSlFmU7498F4XmInMG4twKZ7GuqqPjUekHPg/RG5xHbAAz+d8EKA+tXg
         g0peKf2VdKHc22b2cFr+H9OAJYX6gDerduPlUWZsv7a8BjgFQkraDPpUQxAg9JPkHs4J
         /PcLcl2e4k2TxSf3DI58ni34oUr4fqNTe8lqIZCP0z/u5BR3tW+QeCkmfEqwrCfWnncv
         7IyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YBSVt/C1uERwOBCw6Tfd2ihfw4ttURW20stCOCuUeeY=;
        b=T4BSb92InAsxpjJusETSxCw2XvJiVU4ef5ocn1y09PpljkkSwylfv7CwBmT3kSgSXt
         rnKOzQLs2zC/rERnHd0PAJq50q095yFD2mnNByk0NwwalJT/zxkqHMS+UARJRYoyZIto
         o13cXPOkrt/wq9Jk7yxNxBD1R7WsD+wQ8DLFJKdFhXknmQvLIw0M/elZVGG2Zn/SAsy9
         68LxLJQxGZgUnmG1k6K2XUoGZlFfQIyOV2ay1axVkzzy9dg309K6NraJ37MPJj61/NRu
         QRf97PoLt+aB8YO8Bmhbr4zn09csJhCrkUUUurw96oatusPsfkpRFgDNFPWgImlNbQ4q
         dN5Q==
X-Gm-Message-State: APjAAAXtoVShzy1YBiP6U0HrFW/oVb2EG18xZYQaxeJaCXUCA1Y4sRF+
        NsbZW74baoYZL2DSZN0c1IVU5iQuoKy8Mjp6xN8Rvw==
X-Google-Smtp-Source: APXvYqwKSLnMPDyiQXuhjfM2GMJ5AmECyzht+ieGjN5O7mUjvLmgkVi4EWU1Fr2we6RSMPyvukVruvmOmgJge7Q4554=
X-Received: by 2002:a2e:a490:: with SMTP id h16mr15019961lji.115.1582088139638;
 Tue, 18 Feb 2020 20:55:39 -0800 (PST)
MIME-Version: 1.0
References: <20200217052336.5556-1-hdanton@sina.com> <dca36c4b-bbf5-b215-faa9-1992240f2b69@fb.com>
 <d7ec13dc-a7e7-9381-9728-9157454cadc9@fb.com>
In-Reply-To: <d7ec13dc-a7e7-9381-9728-9157454cadc9@fb.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Tue, 18 Feb 2020 20:55:28 -0800
Message-ID: <CABCgpaWD8HdD29B5nJqHczoJW2zXVK-So7jdHGQmLgc5OxqUUA@mail.gmail.com>
Subject: Re: possible deadlock in bpf_lru_push_free
To:     Yonghong Song <yhs@fb.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>,
        andriin@fb.com, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 3:56 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 2/18/20 9:44 AM, Yonghong Song wrote:
> >
> >
> > On 2/16/20 9:23 PM, Hillf Danton wrote:
> >>
> >> On Sun, 16 Feb 2020 04:17:09 -0800
> >>> syzbot has found a reproducer for the following crash on:
> >>>
> >>> HEAD commit:    2019fc96 Merge
> >>> git://git.kernel.org/pub/scm/linux/kernel/g..
> >>> git tree:       net
> >>> console output:
> >>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__syzkaller.apps=
pot.com_x_log.txt-3Fx-3D1358bb11e00000&d=3DDwIDAg&c=3D5VD0RTtNlTh3ycd41b3MU=
w&r=3DDA8e1B5r073vIqRrFz7MRA&m=3Dnpe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w=
8&s=3DzrgWcBnddWkMWG2zm-9nC8EwvHMsuqw_-EEXwl23XLg&e=3D
> >>>
> >>> kernel config:
> >>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__syzkaller.apps=
pot.com_x_.config-3Fx-3D735296e4dd620b10&d=3DDwIDAg&c=3D5VD0RTtNlTh3ycd41b3=
MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3Dnpe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR=
1w8&s=3DkbT6Yw89JDoIWSQtlLJ7sjyNoP2Ulud27GNorna1zQk&e=3D
> >>>
> >>> dashboard link:
> >>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__syzkaller.apps=
pot.com_bug-3Fextid-3D122b5421d14e68f29cd1&d=3DDwIDAg&c=3D5VD0RTtNlTh3ycd41=
b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3Dnpe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_=
ZR1w8&s=3DU3pdUmrcroaeNsJ9DgFbTlvftQUCUcJ1CW_0NxS8yGA&e=3D
> >>>
> >>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >>> syz repro:
> >>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__syzkaller.apps=
pot.com_x_repro.syz-3Fx-3D14b67d6ee00000&d=3DDwIDAg&c=3D5VD0RTtNlTh3ycd41b3=
MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3Dnpe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR=
1w8&s=3DTuSfjosRFQW3ArpQwikTtx-dgLLBSMgJfVKtUltqQBM&e=3D
> >>>
> >>>
> >>> IMPORTANT: if you fix the bug, please add the following tag to the
> >>> commit:
> >>> Reported-by: syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com
> >>>
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >>> WARNING: possible circular locking dependency detected
> >>> 5.6.0-rc1-syzkaller #0 Not tainted
> >>> ------------------------------------------------------
> >>> syz-executor.4/13544 is trying to acquire lock:
> >>> ffffe8ffffcba0b8 (&loc_l->lock){....}, at: bpf_common_lru_push_free
> >>> kernel/bpf/bpf_lru_list.c:516 [inline]
> >>> ffffe8ffffcba0b8 (&loc_l->lock){....}, at:
> >>> bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
> >>>
> >>> but task is already holding lock:
> >>> ffff888094985960 (&htab->buckets[i].lock){....}, at:
> >>> __htab_map_lookup_and_delete_batch+0x617/0x1540
> >>> kernel/bpf/hashtab.c:1322
> >>>
> >>> which lock already depends on the new lock.
> >>>
> >>>
> >>> the existing dependency chain (in reverse order) is:
> >>>
> >>> -> #2 (&htab->buckets[i].lock){....}:
> >>>         __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110
> >>> [inline]
> >>>         _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:15=
9
> >>>         htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
> >>>         __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220
> >>> [inline]
> >>>         __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:26=
6
> >>>         bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:340
> >>> [inline]
> >>>         bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline=
]
> >>>         bpf_lru_pop_free+0x87c/0x1670 kernel/bpf/bpf_lru_list.c:499
> >>>         prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
> >>>         __htab_lru_percpu_map_update_elem+0x67e/0xa90
> >>> kernel/bpf/hashtab.c:1069
> >>>         bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
> >>>         bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:=
181
> >>>         generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:131=
9
> >>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
> >>>         __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
> >>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
> >>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
> >>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>>
> >>> -> #1 (&l->lock){....}:
> >>>         __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
> >>>         _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
> >>>         bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325
> >>> [inline]
> >>>         bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline=
]
> >>>         bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499
> >>>         prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
> >>>         __htab_lru_percpu_map_update_elem+0x67e/0xa90
> >>> kernel/bpf/hashtab.c:1069
> >>>         bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
> >>>         bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:=
181
> >>>         generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:131=
9
> >>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
> >>>         __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
> >>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
> >>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
> >>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>>
> >>> -> #0 (&loc_l->lock){....}:
> >>>         check_prev_add kernel/locking/lockdep.c:2475 [inline]
> >>>         check_prevs_add kernel/locking/lockdep.c:2580 [inline]
> >>>         validate_chain kernel/locking/lockdep.c:2970 [inline]
> >>>         __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
> >>>         lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
> >>>         __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110
> >>> [inline]
> >>>         _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:15=
9
> >>>         bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inlin=
e]
> >>>         bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
> >>>         __htab_map_lookup_and_delete_batch+0x8d4/0x1540
> >>> kernel/bpf/hashtab.c:1374
> >>>         htab_lru_map_lookup_and_delete_batch+0x34/0x40
> >>> kernel/bpf/hashtab.c:1491
> >>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
> >>>         __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
> >>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
> >>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
> >>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>>
> >>> other info that might help us debug this:
> >>>
> >>> Chain exists of:
> >>>    &loc_l->lock --> &l->lock --> &htab->buckets[i].lock
> >>>
> >>>   Possible unsafe locking scenario:
> >>>
> >>>         CPU0                    CPU1
> >>>         ----                    ----
> >>>    lock(&htab->buckets[i].lock);
> >>>                                 lock(&l->lock);
> >>>                                 lock(&htab->buckets[i].lock);
> >>>    lock(&loc_l->lock);
> >>>
> >>>   *** DEADLOCK ***
> >>>
> >>> 2 locks held by syz-executor.4/13544:
> >>>   #0: ffffffff89bac240 (rcu_read_lock){....}, at:
> >>> __htab_map_lookup_and_delete_batch+0x54b/0x1540
> >>> kernel/bpf/hashtab.c:1308
> >>>   #1: ffff888094985960 (&htab->buckets[i].lock){....}, at:
> >>> __htab_map_lookup_and_delete_batch+0x617/0x1540
> >>> kernel/bpf/hashtab.c:1322
> >>>
> >>> stack backtrace:
> >>> CPU: 0 PID: 13544 Comm: syz-executor.4 Not tainted
> >>> 5.6.0-rc1-syzkaller #0
> >>> Hardware name: Google Google Compute Engine/Google Compute Engine,
> >>> BIOS Google 01/01/2011
> >>> Call Trace:
> >>>   __dump_stack lib/dump_stack.c:77 [inline]
> >>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
> >>>   print_circular_bug.isra.0.cold+0x163/0x172
> >>> kernel/locking/lockdep.c:1684
> >>>   check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
> >>>   check_prev_add kernel/locking/lockdep.c:2475 [inline]
> >>>   check_prevs_add kernel/locking/lockdep.c:2580 [inline]
> >>>   validate_chain kernel/locking/lockdep.c:2970 [inline]
> >>>   __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
> >>>   lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
> >>>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inlin=
e]
> >>>   _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
> >>>   bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
> >>>   bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
> >>>   __htab_map_lookup_and_delete_batch+0x8d4/0x1540
> >>> kernel/bpf/hashtab.c:1374
> >>>   htab_lru_map_lookup_and_delete_batch+0x34/0x40
> >>> kernel/bpf/hashtab.c:1491
> >>>   bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
> >>>   __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
> >>>   __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
> >>>   __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
> >>>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>
> >> Reclaim hash table elememt outside bucket lock.
> >
> > Thanks for the following patch. Yes, we do have an potential issue
> > with the above deadlock if LRU hash map is not preallocated.
> >
> > I am not a RCU expert, but maybe you could you help clarify
> > one thing below?
> >
> >>
> >> --- a/kernel/bpf/hashtab.c
> >> +++ b/kernel/bpf/hashtab.c
> >> @@ -1259,6 +1259,7 @@ __htab_map_lookup_and_delete_batch(struc
> >>       u64 elem_map_flags, map_flags;
> >>       struct hlist_nulls_head *head;
> >>       struct hlist_nulls_node *n;
> >> +    struct hlist_nulls_node *node_to_free =3D NULL;
> >>       unsigned long flags;
> >>       struct htab_elem *l;
> >>       struct bucket *b;
> >> @@ -1370,9 +1371,10 @@ again_nocopy:
> >>           }
> >>           if (do_delete) {
> >>               hlist_nulls_del_rcu(&l->hash_node);
> >> -            if (is_lru_map)
> >> -                bpf_lru_push_free(&htab->lru, &l->lru_node);
> >> -            else
> >> +            if (is_lru_map) {
> >> +                l->hash_node.next =3D node_to_free;
> >> +                node_to_free =3D &l->hash_node;
> >
> > Here, we change "next" pointer. How does this may impact the existing
> > parallel map lookup which does not need to take bucket pointer?
>
> Thanks for Martin for explanation! I think changing l->hash_node.next is
> unsafe here as another thread may execute on a different cpu and
> traverse the same list. It will see hash_node.next =3D NULL and it is
> unexpected.
>
> How about the following patch?

I think I'm missing some emails here, but overall the patch looks good to m=
e.
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 2d182c4ee9d9..246ef0f2e985 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -56,6 +56,7 @@ struct htab_elem {
>                          union {
>                                  struct bpf_htab *htab;
>                                  struct pcpu_freelist_node fnode;
> +                               struct htab_elem *link;
>                          };
>                  };
>          };
> @@ -1256,6 +1257,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map
> *map,
>          void __user *ukeys =3D u64_to_user_ptr(attr->batch.keys);
>          void *ubatch =3D u64_to_user_ptr(attr->batch.in_batch);
>          u32 batch, max_count, size, bucket_size;
> +       struct htab_elem *node_to_free =3D NULL;
>          u64 elem_map_flags, map_flags;
>          struct hlist_nulls_head *head;
>          struct hlist_nulls_node *n;
> @@ -1370,9 +1372,14 @@ __htab_map_lookup_and_delete_batch(struct bpf_map
> *map,
>                  }
>                  if (do_delete) {
>                          hlist_nulls_del_rcu(&l->hash_node);
> -                       if (is_lru_map)
> -                               bpf_lru_push_free(&htab->lru, &l->lru_nod=
e);
> -                       else
> +                       if (is_lru_map) {
> +                               /* l->hnode overlaps with *
> l->hash_node.pprev
> +                                * in memory. l->hash_node.pprev has been
> +                                * poisoned and nobody should access it.
> +                                */
> +                               l->link =3D node_to_free;
> +                               node_to_free =3D l;
> +                       } else
>                                  free_htab_elem(htab, l);
>                  }
>                  dst_key +=3D key_size;
> @@ -1380,6 +1387,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map
> *map,
>          }
>
>          raw_spin_unlock_irqrestore(&b->lock, flags);
> +
> +       while (node_to_free) {
> +               l =3D node_to_free;
> +               node_to_free =3D node_to_free->link;
> +               bpf_lru_push_free(&htab->lru, &l->lru_node);
> +       }
> +
>          /* If we are not copying data, we can go to next bucket and avoi=
d
>           * unlocking the rcu.
>           */
>
>
