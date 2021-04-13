Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1435DC9E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343598AbhDMKn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241769AbhDMKnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:43:52 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E0FC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 03:43:33 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y2so15509551ybq.13
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wGv8rrwTjZqSPnDwChyx7/B4nbERr+fq/B4Hu4R91LE=;
        b=UIbeO1+tKmTbSRI0uK1UTz+2bBTV865uSLLbX8uMLUDp0mexEXIu2DT3+IeH/+8CKx
         SO29h9p/bYP6b/ZztzFd0Y1LrMRZACyzB1WM67bUJOboReI4aA/rs8jZ+vHZjKcPr0u5
         3T7jcs+d1FLx8FZaVKaroOtPg4X9Q9ayx4CwPuaeXo6aFsHFQKSL0ruwwDhXviTlwLyS
         wVrEpSNZIjBNQzD+OFT2jcohbzRQ+RC4mYY1uhuC7LqA2UIvBZtmB/MuMH64CUVHlxG8
         zN8qW4YeKZP63YZHyS78d58KVTobdPkpMPTZ41vHfUyuRlyOUtcP48yP0phARYsoxKzD
         D3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGv8rrwTjZqSPnDwChyx7/B4nbERr+fq/B4Hu4R91LE=;
        b=AteZBA+oxFFjadi+QBICHGl/lqUs49k7F3YKjxTMlL5wnbYeSsMbW2kqSeKaOHCFks
         JEyZlA9m4LDT5xtQYto8ezcaQYHFlpUgTdPAeYaIWwFpRYnfmZdqOZrpn+E2dj+gbYsM
         ut58vjlIV0Wh/jQqeP97c0pOQ8oEOCUZRYlep8xXZ0Vapv0jS9aIyfL/MKZPlz9t1XQ9
         /gIFs08IrcbCY9dpe3x7CmL700NNMpetieOlufnk1/vfuFggzCbH9e0HPFBKhEk1BnqK
         9ppSOsjX5EbF+8HxaPgJNyf8oiu4S85VQ6ZE/VOY4KWbyxTZjUo5MEyqO2t5uG8W3W0o
         R9Iw==
X-Gm-Message-State: AOAM530/kQiDPlnCEDs26Y0wH3IGEDvlUlMNXMsnrzUYPfPbU3hWUvf8
        w96vK6XFbNR4Cw3cyC2nD+XFsyuy6X6pyyCRevRBYA==
X-Google-Smtp-Source: ABdhPJzihctnzeGGvDPeO8SMm7A1gDxLiNXEeSKOEV2eAUDkYDXGL0DtOSsMvtVgKyR7FAZVtVV4Ffv4+tl7nUaxvqk=
X-Received: by 2002:a5b:e90:: with SMTP id z16mr1408674ybr.303.1618310612030;
 Tue, 13 Apr 2021 03:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
 <78c858ba-a847-884f-80c3-cb1eb84d4113@roeck-us.net> <CANn89i+wQoaiFEe1Qi1k96d-ACLmAtJJQ36bs5Z5knYO1v+rOg@mail.gmail.com>
 <ec5a2822-02b8-22e8-b2e2-23a942506a94@roeck-us.net> <CANn89iKDytTucZfCPKLfiv8FdWYSvs4JzgkN452PrH7qDfPbkg@mail.gmail.com>
In-Reply-To: <CANn89iKDytTucZfCPKLfiv8FdWYSvs4JzgkN452PrH7qDfPbkg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 13 Apr 2021 12:43:20 +0200
Message-ID: <CANn89iKDBFd=HK9j3mDZbKXCi3rpB4kgv_wJ5a2SZvTU-dDgyA@mail.gmail.com>
Subject: Re: Linux 5.12-rc7
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 11:24 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Apr 12, 2021 at 10:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 4/12/21 10:38 AM, Eric Dumazet wrote:
> > [ ... ]
> >
> > > Yes, I think this is the real issue here. This smells like some memory
> > > corruption.
> > >
> > > In my traces, packet is correctly received in AF_PACKET queue.
> > >
> > > I have checked the skb is well formed.
> > >
> > > But the user space seems to never call poll() and recvmsg() on this
> > > af_packet socket.
> > >
> >
> > After sprinkling the kernel with debug messages:
> >
> > 424   00:01:33.674181 sendto(6, "E\0\1H\0\0\0\0@\21y\246\0\0\0\0\377\377\377\377\0D\0C\00148\346\1\1\6\0\246\336\333\v\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0RT\0\
> > 424   00:01:33.693873 close(6)          = 0
> > 424   00:01:33.694652 fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
> > 424   00:01:33.695213 clock_gettime64(CLOCK_MONOTONIC, 0x7be18a18) = -1 EFAULT (Bad address)
> > 424   00:01:33.695889 write(2, "udhcpc: clock_gettime(MONOTONIC) failed\n", 40) = -1 EFAULT (Bad address)
> > 424   00:01:33.697311 exit_group(1)     = ?
> > 424   00:01:33.698346 +++ exited with 1 +++
> >
> > I only see that after adding debug messages in the kernel, so I guess there must be
> > a heisenbug somehere.
> >
> > Anyway, indeed, I see (another kernel debug message):
> >
> > __do_sys_clock_gettime: Returning -EFAULT on address 0x7bacc9a8
> >
> > So udhcpc doesn't even try to read the reply because it crashes after sendto()
> > when trying to read the current time. Unless I am missing something, that means
> > that the problem happens somewhere on the send side.
> >
> > To make things even more interesting, it looks like the failing system call
> > isn't always clock_gettime().
> >
> > Guenter
>
>
> I think GRO fast path has never worked on SUPERH. Probably SUPERH has
> never used a fast NIC (10Gbit+)
>
> The following hack fixes the issue.
>
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..91ba89a645ff91d4cd4f3d8dc8a009bcb67da344
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5916,13 +5916,16 @@ static struct list_head
> *gro_list_prepare(struct napi_struct *napi,
>
>  static void skb_gro_reset_offset(struct sk_buff *skb)
>  {
> +#if !defined(CONFIG_SUPERH)
>         const struct skb_shared_info *pinfo = skb_shinfo(skb);
>         const skb_frag_t *frag0 = &pinfo->frags[0];
> +#endif
>
>         NAPI_GRO_CB(skb)->data_offset = 0;
>         NAPI_GRO_CB(skb)->frag0 = NULL;
>         NAPI_GRO_CB(skb)->frag0_len = 0;
>
> +#if !defined(CONFIG_SUPERH)
>         if (!skb_headlen(skb) && pinfo->nr_frags &&
>             !PageHighMem(skb_frag_page(frag0))) {
>                 NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
> @@ -5930,6 +5933,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
>                                                     skb_frag_size(frag0),
>                                                     skb->end - skb->tail);
>         }
> +#endif
>  }
>
>  static void gro_pull_from_frag0(struct sk_buff *skb, int grow)

OK ... more sh debugging :

diff --git a/arch/sh/mm/alignment.c b/arch/sh/mm/alignment.c
index fb517b82a87b1065cf38c06cb3c178ce86587b00..5d18f9f792991105a8aa05cc6231b7d4532d72c9
100644
--- a/arch/sh/mm/alignment.c
+++ b/arch/sh/mm/alignment.c
@@ -27,7 +27,7 @@ static unsigned long se_multi;
    valid! */
 static int se_usermode = UM_WARN | UM_FIXUP;
 /* 0: no warning 1: print a warning message, disabled by default */
-static int se_kernmode_warn;
+static int se_kernmode_warn = 1;

 core_param(alignment, se_usermode, int, 0600);

@@ -103,7 +103,7 @@ void unaligned_fixups_notify(struct task_struct
*tsk, insn_size_t insn,
                          (void *)instruction_pointer(regs), insn);
        else if (se_kernmode_warn)
                pr_notice_ratelimited("Fixing up unaligned kernel access "
-                         "in \"%s\" pid=%d pc=0x%p ins=0x%04hx\n",
+                         "in \"%s\" pid=%d pc=%px ins=0x%04hx\n",
                          tsk->comm, task_pid_nr(tsk),
                          (void *)instruction_pointer(regs), insn);
 }

I now see something of interest :
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc2e ins=0x6236
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc2e ins=0x6236
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc30 ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc30 ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc3a ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc3a ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc3a ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc3a ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc3a ins=0x6636
Fixing up unaligned kernel access in "udhcpc" pid=91 pc=8c43fc3a ins=0x6636

So basically the frag0 idea only works if drivers respect NET_IP_ALIGN
(So that IP header is 4-byte aligned)

It seems either virtio_net or qemu does not respect the contract.

A possible generic fix  would then be :


diff --git a/net/core/dev.c b/net/core/dev.c
index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..1f79b9aa9a3f2392fddd1401f95ad098b5e03204
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5924,7 +5924,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
        NAPI_GRO_CB(skb)->frag0_len = 0;

        if (!skb_headlen(skb) && pinfo->nr_frags &&
-           !PageHighMem(skb_frag_page(frag0))) {
+           !PageHighMem(skb_frag_page(frag0)) &&
+           (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
                NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
                NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
                                                    skb_frag_size(frag0),
