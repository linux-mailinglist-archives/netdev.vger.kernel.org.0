Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D490C3B4589
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 16:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFYOag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 10:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhFYOaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 10:30:35 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F225C061766
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 07:28:13 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id g14so7600703qtv.4
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 07:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ZgLDmf4P91A2RHgxZba0+RJ1N9ppXcf6PPDNksXoJw=;
        b=oB537cv+7rW36nLqzmSKurcx8XeCx4ShtN2KTeKpAFXu3Ce6WvWOu+DaKvJIk+2nnA
         OBiAZXWbhyc+cm0cmprCWN3oDK+44jpDq74w8EIIrtuFA6m4dMkC2vMBuwy3OZOtnP+9
         8oIua2zsmZ4h5osGPMO25wQmXkHc3vg+SI1P/x42tqLR6JKeyVqqPxLW1SVN2OU/67O4
         ZXHJSlqcTUotXHjVT9uOkS2YlfnK5O7j+zRJqdUY4ZN57e2Ws3KGaOGNfiWYBwWIYpKL
         DYxBd80wA+gnnnOK1X+eeKJ7WR9yvkXHZxKAJ67JPWsg2a0zKNhmgV5hKaH9CXlLWHKM
         6GMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ZgLDmf4P91A2RHgxZba0+RJ1N9ppXcf6PPDNksXoJw=;
        b=T36W+UAJexigVOQaT/uZuFBTRVGbAsFuOdpd8qUXmL9cZpoA80NE6rD/PDR9AkD7O3
         Lut+FIJfoVOJn8usRwoHF4nGM+It2uKYG+VYdnCh2vUOA7HJ1eWcmyJWW3vNeTbGI63r
         oTmbxMamSX/+pQasV5kCkcNFh13x7rktK8cYVZBR45A5eaejRmfH6I4eVXIH3ewjw+hI
         Vz3OelZnrxKTNqPsdZvz9Q4UTM8rdv0BdJxlwawZh9qMO0mBHGxQvWoksGuLuNeJCgMd
         0H1R+mXLe+KmgUQR/q0vx16kmORHeDWq1rhTA8laFBA+RHqtwWfvhE24aaIugESe0sFJ
         DHRg==
X-Gm-Message-State: AOAM530RSwkDZ42ehXrGkbnbPFoF4C9+SGcENSbGlqvcpGaHtTMOd2HV
        dVhfMZ6ALPCQqmiYds9P9MDd1YdALWUH1ssOGVWpoQ==
X-Google-Smtp-Source: ABdhPJzYL8s1lJU9KzPzunn0ci7SYPyzALfsn/DFxLj6mqn8o0QuAynGEZnBOhCg11vT14u8xnOJKacmUn3UJ6axiwY=
X-Received: by 2002:ac8:7616:: with SMTP id t22mr9473960qtq.43.1624631292305;
 Fri, 25 Jun 2021 07:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000911d3905b459824c@google.com> <000000000000e56a2605b616b2d9@google.com>
 <YD0UjWjQmYgY4Qgh@nuc10> <CACT4Y+YQzTkk=UPNH5g96e+yPYyaPBemmhqXz5oaWEvW9xb-rQ@mail.gmail.com>
 <YD1RE3O4FBkKK32l@nuc10> <CACT4Y+bvWyipjZ6P6gkno0ZHRWPJ-HFGiT3yECqQU37a0E_tgQ@mail.gmail.com>
 <YG4/PEhZ9CnKo1K3@nuc10> <CAEf4BzbB3r2pOeKBQe2F08g5ojj0RaEHHeg5L6=MVMYy-J5baA@mail.gmail.com>
 <YG9Rz4R5bx+FnkaF@nuc10> <YMYhcMVTxThJYxMo@nuc10> <YNTAqiE7CWJhOK2M@nuc10>
In-Reply-To: <YNTAqiE7CWJhOK2M@nuc10>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 25 Jun 2021 16:28:00 +0200
Message-ID: <CACT4Y+Z4fjZZhCEM8eRRpw3qSpKY+nRoVcjtPQKsM7uYUL7xbQ@mail.gmail.com>
Subject: Re: memory leak in bpf
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzbot+f3694595248708227d35@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 7:28 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
> > > > On Wed, Apr 7, 2021 at 4:24 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
> > > > >
> > > > > On Mon, Mar 01, 2021 at 09:43:00PM +0100, Dmitry Vyukov wrote:
> > > > > > On Mon, Mar 1, 2021 at 9:39 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Mar 01, 2021 at 08:05:42PM +0100, Dmitry Vyukov wrote:
> > > > > > > > On Mon, Mar 1, 2021 at 5:21 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, Dec 09, 2020 at 10:58:10PM -0800, syzbot wrote:
> > > > > > > > > > syzbot has found a reproducer for the following issue on:
> > > > > > > > > >
> > > > > > > > > > HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
> > > > > > > > > > git tree:       upstream
> > > > > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=11facf17500000
> > > > > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
> > > > > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=f3694595248708227d35
> > > > > > > > > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > > > > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159a9613500000
> > > > > > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bf7123500000
> > > > > > > > > >
> > > > > > > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > > > > > > Reported-by: syzbot+f3694595248708227d35@syzkaller.appspotmail.com
> > > > > > > > > >
> > > > > > > > > > Debian GNU/Linux 9 syzkaller ttyS0
> > > > > > > > > > Warning: Permanently added '10.128.0.9' (ECDSA) to the list of known hosts.
> > > > > > > > > > executing program
> > > > > > > > > > executing program
> > > > > > > > > > executing program
> > > > > > > > > > BUG: memory leak
> > > > > > > > > > unreferenced object 0xffff88810efccc80 (size 64):
> > > > > > > > > >   comm "syz-executor334", pid 8460, jiffies 4294945724 (age 13.850s)
> > > > > > > > > >   hex dump (first 32 bytes):
> > > > > > > > > >     c0 cb 14 04 00 ea ff ff c0 c2 11 04 00 ea ff ff  ................
> > > > > > > > > >     c0 56 3f 04 00 ea ff ff 40 18 38 04 00 ea ff ff  .V?.....@.8.....
> > > > > > > > > >   backtrace:
> > > > > > > > > >     [<0000000036ae98a7>] kmalloc_node include/linux/slab.h:575 [inline]
> > > > > > > > > >     [<0000000036ae98a7>] bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:94 [inline]
> > > > > > > > > >     [<0000000036ae98a7>] bpf_ringbuf_alloc kernel/bpf/ringbuf.c:135 [inline]
> > > > > > > > > >     [<0000000036ae98a7>] ringbuf_map_alloc kernel/bpf/ringbuf.c:183 [inline]
> > > > > > > > > >     [<0000000036ae98a7>] ringbuf_map_alloc+0x1be/0x410 kernel/bpf/ringbuf.c:150
> > > > > > > > > >     [<00000000d2cb93ae>] find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
> > > > > > > > > >     [<00000000d2cb93ae>] map_create kernel/bpf/syscall.c:825 [inline]
> > > > > > > > > >     [<00000000d2cb93ae>] __do_sys_bpf+0x7d0/0x30a0 kernel/bpf/syscall.c:4381
> > > > > > > > > >     [<000000008feaf393>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> > > > > > > > > >     [<00000000e1f53cfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > i am pretty sure that this one is a false positive
> > > > > > > > > the problem with reproducer is that it does not terminate all of the
> > > > > > > > > child processes that it spawns
> > > > > > > > >
> > > > > > > > > i confirmed that it is a false positive by tracing __fput() and
> > > > > > > > > bpf_map_release(), i ran reproducer, got kmemleak report, then i
> > > > > > > > > manually killed those running leftover processes from reproducer and
> > > > > > > > > then both functions were executed and memory was freed
> > > > > > > > >
> > > > > > > > > i am marking this one as:
> > > > > > > > > #syz invalid
> > > > > > > >
> > > > > > > > Hi Rustam,
> > > > > > > >
> > > > > > > > Thanks for looking into this.
> > > > > > > >
> > > > > > > > I wonder how/where are these objects referenced? If they are not
> > > > > > > > leaked and referenced somewhere, KMEMLEAK should not report them as
> > > > > > > > leaks.
> > > > > > > > So even if this is a false positive for BPF, this is a true positive
> > > > > > > > bug and something to fix for KMEMLEAK ;)
> > > > > > > > And syzbot will probably re-create this bug report soon as this still
> > > > > > > > happens and is not a one-off thing.
> > > > > > >
> > > > > > > hi Dmitry, i haven't thought of it this way, but i guess you are right,
> > > > > > > it is a kmemleak bug, ideally kmemleak should be aware that there are
> > > > > > > still running processes holding references to bpf fd/anonymous inodes
> > > > > > > which in their turn hold references to allocated bpf maps
> > > > > >
> > > > > > KMEMLEAK scans whole memory, so if there are pointers to the object
> > > > > > anywhere in memory, KMEMLEAK should not report them as leaked. Running
> > > > > > processes have no direct effect on KMEMLEAK logic.
> > > > > > So the question is: where are these pointers to these objects? If we
> > > > > > answer this, we can check how/why KMEMLEAK misses them. Are they
> > > > > > mangled in some way?
> > > > > thank you for your comments, they make sense, and indeed, the pointer
> > > > > gets vmaped.
> > > > > i should have looked into this sooner, becaused syzbot did trigger the
> > > > > issue again, and Andrii had to look into the same bug, sorry about that.
> > > >
> > > > No worries! I actually forgot about this thread :) Let's leave the
> > > > link to my today's investigation ([0]) just for completeness.
> > > >
> > > >   [0] https://lore.kernel.org/bpf/CAEf4BzYk+dqs+jwu6VKXP-RttcTEGFe+ySTGWT9CRNkagDiJVA@mail.gmail.com/
> > > >
> > > > > if i am understanding this correctly here is what the fix should be:
> > > > > ---
> > > > >  kernel/bpf/ringbuf.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > > > > index f25b719ac786..30400e74abe2 100644
> > > > > --- a/kernel/bpf/ringbuf.c
> > > > > +++ b/kernel/bpf/ringbuf.c
> > > > > @@ -8,6 +8,7 @@
> > > > >  #include <linux/vmalloc.h>
> > > > >  #include <linux/wait.h>
> > > > >  #include <linux/poll.h>
> > > > > +#include <linux/kmemleak.h>
> > > > >  #include <uapi/linux/btf.h>
> > > > >
> > > > >  #define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
> > > > > @@ -105,6 +106,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> > > > >         rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> > > > >                   VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> > > > >         if (rb) {
> > > > > +               kmemleak_not_leak((void *) pages);
> > > >
> > > > If that makes kmemleak happy, I have no problems with this. But maybe
> > > > leave some comment explaining why this is needed at all?
> > > >
> > > > And for my understanding, how vmap changes anything? Those pages are
> > > > still referenced from rb, which is referenced from some struct file in
> > > > the system. Sorry if that's a naive question.
> > > >
> > > valid question, it does look like kmemleak should be scanning
> > > vmalloc()/vmap() memory, i will research this further
> >
> > a quick update, i see a problem in kmemleak code, and i have simplified
> > the reproducer by getting rid of a vmap().
> > i will reach out to maintainer and mm and afterwards i will update this
> > bug, cheers!
> >
>
> Andrii, we have discovered that kmemleak scans struct page, but it does
> not scan page contents and this is by design. if we allocate some memory
> with kmalloc(), then allocate page with alloc_page(), and if we put
> kmalloc pointer somewhere inside that page, kmemleak will report kmalloc
> pointer as a false positive.
> we can instruct kmemleak to scan the memory area by calling
> kmemleak_alloc()/kmemleak_free() as shown below. if we don't need that
> memory to be scanned then we can use kmemleak_not_leak().
> if we use the former then i guess we need to be careful since we do not
> want/need to scan the memory that is being used by user-space.

Thanks for your heroic digging and persistence on this issue, Rustam!

> ---
>  kernel/bpf/ringbuf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index 84b3b35fc0d0..cf7ce10b4fb1 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -8,6 +8,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
>  #include <linux/poll.h>
> +#include <linux/kmemleak.h>
>  #include <uapi/linux/btf.h>
>
>  #define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
> @@ -105,6 +106,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
>         rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
>                   VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
>         if (rb) {
> +               kmemleak_alloc(rb, PAGE_SIZE, 1, flags);
>                 rb->pages = pages;
>                 rb->nr_pages = nr_pages;
>                 return rb;
> @@ -184,6 +186,7 @@ static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
>         struct page **pages = rb->pages;
>         int i, nr_pages = rb->nr_pages;
>
> +       kmemleak_free(rb);
>         vunmap(rb);
>         for (i = 0; i < nr_pages; i++)
>                 __free_page(pages[i]);
> --
> 2.30.2
>
