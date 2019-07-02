Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993F75C979
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfGBGoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:44:05 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34189 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfGBGoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 02:44:05 -0400
Received: by mail-io1-f65.google.com with SMTP id k8so34624577iot.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 23:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XnaWd9P9xKybW0lXkt79Iun5uzyN370d1KKFn14u8pU=;
        b=WRys2EvSKJfQDwTCYG+P7QnksaGqhATBxeEhJj8d3MZe0mKBEB7pE9/WxiA3x4z4bc
         X6EvE9Q/tvimkyF1/0lXAId9x6WuKfW9YRRFLqpTjVI+LpnCmZyvLLAbrUqzFW+f8p5g
         wbWbMZMx4P+XIDJ4xlnKH6eXl/os3wp5PpBQNIxNhMSslT3lV8TPQHGi2Zonz+mlufg6
         4QDpvbOwxKjTA9/JPfcG8tc8FFSUuYFDv53jum5mIoQR36ZVP9X6FmF/yjPytmQnHZ2E
         +/htcwo9DZQVMg7eSh8/WaGyoHLtdfPADQ4cyudwJ+3x5UnRcKRSOJT6ndq8RGWTHD3Y
         6Cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XnaWd9P9xKybW0lXkt79Iun5uzyN370d1KKFn14u8pU=;
        b=Fh4zHKwoZ5hkHx1S+DCM1ZyMWv6HzDneaWU0KHHYwlf0z+J7BxoDBBRmfCznMC+Aro
         mmv3WGEQf4axclUtZd0LajpHZOEvVs/E+l5ASJc+QXJjw0IVDXdhSpj08agMScfbGcgd
         u+SqUzzSCWdOA4z3k/KYyawSW+MKQtCxlOFi1uJxQgIDAuaum+GwEdWaG2R//dIx8i0d
         Dk5kh4qHlz0ycQ8s/Ftf3A2XJwTs4JQIeM8cddNAUhq/QU8pF7LgYr1j+qPpW4DAX1G+
         xFz2awipT4z8srJg+70o5597a2IIQ7HcJ+kKcu/Dyy5uzIxT0byZaQR3hpBUob5Eee0+
         msMA==
X-Gm-Message-State: APjAAAWGgWJVH3QaU6pVU0u9oPmJayBa75s+L1vbsy8EZth8Yk+U5aPq
        aSY8FbEWVD4jq80a/eItn3B762LHkgw0D4UFHaEQMw==
X-Google-Smtp-Source: APXvYqwSRYk/6MNpauII6NxLVu48MJXQ1Z2SV6sf8Ubr37AzxK35/nHXsW2GbkiEnJkfl71BlOxRi7SBYVhoBqy/rEo=
X-Received: by 2002:a02:7087:: with SMTP id f129mr34565969jac.38.1562049844133;
 Mon, 01 Jul 2019 23:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d028b30588fed102@google.com> <000000000000db481c058c462e4c@google.com>
In-Reply-To: <000000000000db481c058c462e4c@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 2 Jul 2019 08:43:51 +0200
Message-ID: <CACT4Y+axVLwc4b8hyQswuFJNwkFB45Zs7XDfi6O3CE0pG=5edA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in xfrm_hash_rebuild
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:38 AM Hillf Danton <hdanton@sina.com> wrote:
>
>
> On Wed, 26 Jun 2019 20:59:05 -0700 (PDT)
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10f017c3a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0165480d4ef07360eeda
> > compiler:       clang version 9.0.0 (/home/glider/llvm/clang 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf37c3a00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in __write_once_size  include/linux/compiler.h:221 [inline]
> > BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:748 [inline]
> > BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455  [inline]
> > BUG: KASAN: use-after-free in xfrm_hash_rebuild+0xa0d/0x1000  net/xfrm/xfrm_policy.c:1318
> > Write of size 8 at addr ffff888095e79c00 by task kworker/1:3/8066
> >
> > CPU: 1 PID: 8066 Comm: kworker/1:3 Not tainted 5.2.0-rc6+ #7
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: events xfrm_hash_rebuild
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
> >   print_address_description+0x6d/0x310 mm/kasan/report.c:188
> >   __kasan_report+0x14b/0x1c0 mm/kasan/report.c:317
> >   kasan_report+0x26/0x50 mm/kasan/common.c:614
> >   __asan_report_store8_noabort+0x17/0x20 mm/kasan/generic_report.c:137
> >   __write_once_size include/linux/compiler.h:221 [inline]
> >   __hlist_del include/linux/list.h:748 [inline]
> >   hlist_del_rcu include/linux/rculist.h:455 [inline]
> >   xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
> >   process_one_work+0x814/0x1130 kernel/workqueue.c:2269
> >   worker_thread+0xc01/0x1640 kernel/workqueue.c:2415
> >   kthread+0x325/0x350 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> >
> > Allocated by task 8064:
> >   save_stack mm/kasan/common.c:71 [inline]
> >   set_track mm/kasan/common.c:79 [inline]
> >   __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:489
> >   kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
> >   __do_kmalloc mm/slab.c:3660 [inline]
> >   __kmalloc+0x23c/0x310 mm/slab.c:3669
> >   kmalloc include/linux/slab.h:552 [inline]
> >   kzalloc include/linux/slab.h:742 [inline]
> >   xfrm_hash_alloc+0x38/0xe0 net/xfrm/xfrm_hash.c:21
> >   xfrm_policy_init net/xfrm/xfrm_policy.c:4036 [inline]
> >   xfrm_net_init+0x269/0xd60 net/xfrm/xfrm_policy.c:4120
> >   ops_init+0x336/0x420 net/core/net_namespace.c:130
> >   setup_net+0x212/0x690 net/core/net_namespace.c:316
> >   copy_net_ns+0x224/0x380 net/core/net_namespace.c:439
> >   create_new_namespaces+0x4ec/0x700 kernel/nsproxy.c:103
> >   unshare_nsproxy_namespaces+0x12a/0x190 kernel/nsproxy.c:202
> >   ksys_unshare+0x540/0xac0 kernel/fork.c:2692
> >   __do_sys_unshare kernel/fork.c:2760 [inline]
> >   __se_sys_unshare kernel/fork.c:2758 [inline]
> >   __x64_sys_unshare+0x38/0x40 kernel/fork.c:2758
> >   do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:301
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Freed by task 17:
> >   save_stack mm/kasan/common.c:71 [inline]
> >   set_track mm/kasan/common.c:79 [inline]
> >   __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:451
> >   kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
> >   __cache_free mm/slab.c:3432 [inline]
> >   kfree+0xae/0x120 mm/slab.c:3755
> >   xfrm_hash_free+0x38/0xd0 net/xfrm/xfrm_hash.c:35
> >   xfrm_bydst_resize net/xfrm/xfrm_policy.c:602 [inline]
> >   xfrm_hash_resize+0x13f1/0x1840 net/xfrm/xfrm_policy.c:680
> >   process_one_work+0x814/0x1130 kernel/workqueue.c:2269
> >   worker_thread+0xc01/0x1640 kernel/workqueue.c:2415
> >   kthread+0x325/0x350 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> >
> > The buggy address belongs to the object at ffff888095e79c00
> >   which belongs to the cache kmalloc-64 of size 64
> > The buggy address is located 0 bytes inside of
> >   64-byte region [ffff888095e79c00, ffff888095e79c40)
> > The buggy address belongs to the page:
> > page:ffffea0002579e40 refcount:1 mapcount:0 mapping:ffff8880aa400340
> > index:0x0
> > flags: 0x1fffc0000000200(slab)
> > raw: 01fffc0000000200 ffffea0002540888 ffffea0002907548 ffff8880aa400340
> > raw: 0000000000000000 ffff888095e79000 0000000100000020 0000000000000000
> > page dumped because: kasan: bad access detected
> >
> > Memory state around the buggy address:
> >   ffff888095e79b00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >   ffff888095e79b80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> > > ffff888095e79c00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >                     ^
> >   ffff888095e79c80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >   ffff888095e79d00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> > ==================================================================
> >
>
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1203,6 +1203,11 @@ xfrm_policy_inexact_insert(struct xfrm_policy *policy, u8 dir, int excl)
>         return delpol;
>  }
>
> +static inline bool xfrm_policy_node_hashed(struct hlist_node *node)
> +{
> +       return node->pprev && node->pprev != LIST_POISON2;

Is it right to open code LIST_POISON2 use here? As far as I see all
current uses of LIST_POISON2 are encapsulated in list functions.

> +}
> +
>  static void xfrm_hash_rebuild(struct work_struct *work)
>  {
>         struct net *net = container_of(work, struct net,
> @@ -1315,7 +1320,9 @@ static void xfrm_hash_rebuild(struct work_struct *work)
>                 chain = policy_hash_bysel(net, &policy->selector,
>                                           policy->family, dir);
>
> -               hlist_del_rcu(&policy->bydst);
> +               /* check bydst still hashed in case that policy survived bydst resize */
> +               if (xfrm_policy_node_hashed(&policy->bydst))
> +                       hlist_del_rcu(&policy->bydst);
>
>                 if (!chain) {
>                         void *p = xfrm_policy_inexact_insert(policy, dir, 0);
> --
