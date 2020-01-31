Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67D14EC3E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgAaMEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:04:08 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34393 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgAaMEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:04:07 -0500
Received: by mail-ot1-f65.google.com with SMTP id a15so6351681otf.1
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 04:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bPZYbEHgT8QqWy65RuP2LwO/ekDNyecnlbDtriR+rAY=;
        b=InWWajXpKjo8nIUsFLbd3+gXkRiyQwKrsN3SuyxJtIAV+5mvx5jWLI+32kU4GxZqH0
         RL3AB4Duh8Nu54vbn6Muxq8c7ddYI2vv1j7nsgV4hvKBOc2ykYv8yJY6xRCulQ68HJ9n
         iMi+kRfnObu5vSYzqNBr6p9OyWwUMYtfZw8chuNpE5PrP9ihITkeTb6GRpUv11oX15Gx
         hKLXcS74O2uqJiYEjhy6o05QCFBK6KK6y1VA4haWcWqrRWsb+K6OeBV3e3AiqLuW6rBp
         N4hqHrI7+oEEVCExwmrVqpD/5Cb0z1bSEqvHGmen9xNTQ9Sn5kSIhznFRsrTIHBgnN/y
         BP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bPZYbEHgT8QqWy65RuP2LwO/ekDNyecnlbDtriR+rAY=;
        b=NUqa97yMlMahIuATVE86NzNoEkMi91MkiuG5/CQfLJL2BsbWGr/vuw3xnEjqK2Kqcc
         8fQlaC364sz4cL0U87HygbDkOTadblIuMtCOelHpJZQloWlXNId6hCfGym0GTAg7FsEv
         A1AkGHqqhQiwXl9B49vJZ5diLG4Tw2lLHU9Oja5bj8Fb/5UGyOVJA7x2/IABWPAMCp9Z
         ZwgzDvRZy0zZwu9BQjcoo6Abu/tFnUTKS9QkwBWrkp/KkB1bUzVtR7EjSTnCWSQ35Sc8
         Kh/avrYuAc3CuZV05LA8dgWuqWvJyGb0CtFdOAwpzy+njRaGMDp8NZWBfXjZ1ytKTGoB
         3Rug==
X-Gm-Message-State: APjAAAU/q2wX8vC4AfpPOXU+T1izwLN6HB4L/Ar091l1NtIfs2udIyM+
        BQRDFz6i7/BV7W3slsrDY910TB4CkCO2ThrVwykiMA==
X-Google-Smtp-Source: APXvYqxX4kvjJgrVd0xsJAPveBUs527WZZheCaEcNR7VaN+pr2nJJe9jO88RJTZyjdW6BmhGD/zGL14X4MmAFHztlf4=
X-Received: by 2002:a05:6830:22cc:: with SMTP id q12mr7537510otc.110.1580472246617;
 Fri, 31 Jan 2020 04:04:06 -0800 (PST)
MIME-Version: 1.0
References: <201911121313.1097D6EE@keescook> <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz> <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com> <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com> <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org> <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
In-Reply-To: <202001300945.7D465B5F5@keescook>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 31 Jan 2020 13:03:40 +0100
Message-ID: <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches as
 usercopy caches
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>,
        David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 8:23 PM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jan 29, 2020 at 06:19:56PM +0100, Christian Borntraeger wrote:
> > On 29.01.20 18:09, Christoph Hellwig wrote:
> > > On Wed, Jan 29, 2020 at 06:07:14PM +0100, Christian Borntraeger wrote:
> > >>> DMA can be done to NORMAL memory as well.
> > >>
> > >> Exactly.
> > >> I think iucv uses GFP_DMA because z/VM needs those buffers to reside below 2GB (which is ZONA_DMA for s390).
> > >
> > > The normal way to allocate memory with addressing limits would be to
> > > use dma_alloc_coherent and friends.  Any chance to switch iucv over to
> > > that?  Or is there no device associated with it?
> >
> > There is not necessarily a device for that. It is a hypervisor interface (an
> > instruction that is interpreted by z/VM). We do have the netiucv driver that
> > creates a virtual nic, but there is also AF_IUCV which works without a device.
> >
> > But back to the original question: If we mark kmalloc caches as usercopy caches,
> > we should do the same for DMA kmalloc caches. As outlined by Christoph, this has
> > nothing to do with device DMA.
>
> Hm, looks like it's allocated from the low 16MB. Seems like poor naming!

The physical address limit of the DMA zone depends on the architecture
(and the kernel version); e.g. on Linux 4.4 on arm64 (which is used on
the Pixel 2), the DMA zone goes up to 4GiB. Later, arm64 started using
the DMA32 zone for that instead (as was already the case on e.g.
X86-64); but recently (commit 1a8e1cef7603), arm64 started using the
DMA zone again, but now for up to 1GiB. (AFAICS the DMA32 zone can't
be used with kmalloc at all, that only works with the DMA zone.)

> :) There seems to be a LOT of stuff using GFP_DMA, and it seems unlikely
> those are all expecting low addresses?

I think there's a bunch of (especially really old) hardware where the
hardware can only talk to low physical addresses, e.g. stuff that uses
the ISA bus.

However, there aren't *that* many users of GFP_DMA that actually cause
kmalloc allocations with GFP_DMA - many of the users of GFP_DMA
actually just pass that flag to dma_alloc_coherent()/dma_pool_alloc(),
where it is filtered away and the allocation ultimately doesn't go
through the slab allocator AFAICS, or they pass it directly to the
page allocator, where it has no effect on the usercopy stuff. Looking
on my workstation, there are zero objects allocated in dma-kmalloc-*
slabs:

/sys/kernel/slab# for name in dma-kmalloc-*; do echo "$name: $(cat
$name/objects)"; done
dma-kmalloc-128: 0
dma-kmalloc-16: 0
dma-kmalloc-192: 0
dma-kmalloc-1k: 0
dma-kmalloc-256: 0
dma-kmalloc-2k: 0
dma-kmalloc-32: 0
dma-kmalloc-4k: 0
dma-kmalloc-512: 0
dma-kmalloc-64: 0
dma-kmalloc-8: 0
dma-kmalloc-8k: 0
dma-kmalloc-96: 0

On a Pixel 2, there are a whole five objects allocated across the DMA
zone kmalloc caches:

walleye:/sys/kernel/slab # for name in dma-kmalloc-*; do echo "$name:
$(cat $name/objects)"; done
dma-kmalloc-1024: 0
dma-kmalloc-128: 0
dma-kmalloc-2048: 2
dma-kmalloc-256: 0
dma-kmalloc-4096: 3
dma-kmalloc-512: 0
dma-kmalloc-8192: 0

> Since this has only been a problem on s390, should just s390 gain the
> weakening of the usercopy restriction?  Something like:
>
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1907cb2903c7..c5bbc141f20b 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1303,7 +1303,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>                         kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
>                                 kmalloc_info[i].name[KMALLOC_DMA],
>                                 kmalloc_info[i].size,
> -                               SLAB_CACHE_DMA | flags, 0, 0);
> +                               SLAB_CACHE_DMA | flags, 0,
> +                               IS_ENABLED(CONFIG_S390) ?
> +                                       kmalloc_info[i].size : 0);
>                 }
>         }
>  #endif

I think dma-kmalloc slabs should be handled the same way as normal
kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
just normal kernel memory - even if it might later be used for DMA -,
and it should be perfectly fine to copy_from_user() into such
allocations at that point, and to copy_to_user() out of them at the
end. If you look at the places where such allocations are created, you
can see things like kmemdup(), memcpy() and so on - all normal
operations that shouldn't conceptually be different from usercopy in
any relevant way.
