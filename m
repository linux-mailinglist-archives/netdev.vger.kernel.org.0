Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279FD3CC739
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 04:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhGRCMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 22:12:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231351AbhGRCMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 22:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626574161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gpM2d5Iuvyh50YGnyAEB1mGNqLkDz1f1Frpy8iBXokw=;
        b=Q8+Pr+1USYC4SWUPvxuW7dULepZC/DGasjIexI3OirO+Aq18CgqxAcetftj3U6vMmB8rhP
        BMMtXHfgnvdb2VnfrRhEvQ9Bj1vj8DgPZHkdfWthXYoGmbAbBcKR4qVCbhrVWxWUl/Qtw0
        GpwcMAQRhuSJxzpzTULT6diFJlwtZlk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-kgO3lY33NqaaYHo65fJWTA-1; Sat, 17 Jul 2021 22:09:19 -0400
X-MC-Unique: kgO3lY33NqaaYHo65fJWTA-1
Received: by mail-wr1-f70.google.com with SMTP id r11-20020a5d52cb0000b02901309f5e7298so7154758wrv.0
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 19:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gpM2d5Iuvyh50YGnyAEB1mGNqLkDz1f1Frpy8iBXokw=;
        b=CzpHK0XKfro92zPgjmJvy5GPQOECyxnDL2JHBojPjfhWNHA/0tEW2xxCn9b6iS8175
         XHaFxpc7h4JqN5hNTa7GDlfQD8uGN2iOa6WgOepOMV7cajFQqm+yeb7k9qGQ3C5EYoci
         lDTJUXmoN41zDBefeG7FK+PCYJaCZcO/nQOKvU+4rx77HTlBvzVI3iz+4IoiwWGMXQpE
         yqtSRdCvNE6HmClUqzx2WMQEQ9FkOYYlmjGPo0n+QkJKtQm+jNCyk5Wk4Y5D+1jkAtEN
         0u1XdO38lx8gBzf6+Gi/cVOJtzC8wkdbKOLbommUMBxE6vByjIDSNhegARKMDs+fD/T0
         65XQ==
X-Gm-Message-State: AOAM533CRe+t9kreOdVriP+nOl1Q6I3Xg+grUekXEDXEE19gUHn40E4S
        6yCg+2O5//bdI+K++dxV5VRUSK081cZbn5+iR1F3xY/c/ad2dUwk131p/jW52BjER7VJeCGZq5s
        qJ+X2Aahu1lTuIi8h
X-Received: by 2002:a05:600c:3541:: with SMTP id i1mr25022300wmq.135.1626574158675;
        Sat, 17 Jul 2021 19:09:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAjXutwxw/shIh8se3On5/NgHRsL0GVBZVfCQw0Xr/xWe4iHnIbPhvf8WMAk9eZvm7QX+O3A==
X-Received: by 2002:a05:600c:3541:: with SMTP id i1mr25022272wmq.135.1626574158446;
        Sat, 17 Jul 2021 19:09:18 -0700 (PDT)
Received: from redhat.com ([2.55.29.175])
        by smtp.gmail.com with ESMTPSA id n7sm14590296wmq.37.2021.07.17.19.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 19:09:17 -0700 (PDT)
Date:   Sat, 17 Jul 2021 22:09:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jasowang@redhat.com,
        nickhu@andestech.com, green.hu@gmail.com, deanbo422@gmail.com,
        akpm@linux-foundation.org, yury.norov@gmail.com,
        andriy.shevchenko@linux.intel.com, ojeda@kernel.org,
        ndesaulniers@gooogle.com, joe@perches.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] tools: add missing infrastructure for
 building ptr_ring.h
Message-ID: <20210717220239-mutt-send-email-mst@kernel.org>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <1625457455-4667-2-git-send-email-linyunsheng@huawei.com>
 <20210705143144-mutt-send-email-mst@kernel.org>
 <cbc4053e-7eda-4c46-5b98-558c741e45b6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc4053e-7eda-4c46-5b98-558c741e45b6@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 10:04:02AM +0800, Yunsheng Lin wrote:
> On 2021/7/6 2:39, Michael S. Tsirkin wrote:
> > On Mon, Jul 05, 2021 at 11:57:34AM +0800, Yunsheng Lin wrote:
> >> In order to build ptr_ring.h in userspace, the cacheline
> >> aligning, cpu_relax() and slab related infrastructure is
> >> needed, so add them in this patch.
> >>
> >> As L1_CACHE_BYTES may be different for different arch, which
> >> is mostly defined in include/generated/autoconf.h, so user may
> >> need to do "make defconfig" before building a tool using the
> >> API in linux/cache.h.
> >>
> >> Also "linux/lockdep.h" is not added in "tools/include" yet,
> >> so remove it in "linux/spinlock.h", and the only place using
> >> "linux/spinlock.h" is tools/testing/radix-tree, removing that
> >> does not break radix-tree testing.
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > 
> > This is hard to review.
> > Try to split this please. Functional changes separate from
> > merely moving code around.
> 
> Sure.
> 
> > 
> > 
> >> ---
> >>  tools/include/asm/cache.h          | 56 ++++++++++++++++++++++++
> >>  tools/include/asm/processor.h      | 36 ++++++++++++++++
> >>  tools/include/generated/autoconf.h |  1 +
> >>  tools/include/linux/align.h        | 15 +++++++
> >>  tools/include/linux/cache.h        | 87 ++++++++++++++++++++++++++++++++++++++
> >>  tools/include/linux/gfp.h          |  4 ++
> >>  tools/include/linux/slab.h         | 46 ++++++++++++++++++++
> >>  tools/include/linux/spinlock.h     |  2 -
> >>  8 files changed, 245 insertions(+), 2 deletions(-)
> >>  create mode 100644 tools/include/asm/cache.h
> >>  create mode 100644 tools/include/asm/processor.h
> >>  create mode 100644 tools/include/generated/autoconf.h
> >>  create mode 100644 tools/include/linux/align.h
> >>  create mode 100644 tools/include/linux/cache.h
> >>  create mode 100644 tools/include/linux/slab.h
> >>
> >> diff --git a/tools/include/asm/cache.h b/tools/include/asm/cache.h
> >> new file mode 100644
> >> index 0000000..071e310
> >> --- /dev/null
> >> +++ b/tools/include/asm/cache.h
> >> @@ -0,0 +1,56 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +
> >> +#ifndef __TOOLS_LINUX_ASM_CACHE_H
> >> +#define __TOOLS_LINUX_ASM_CACHE_H
> >> +
> >> +#include <generated/autoconf.h>
> >> +
> >> +#if defined(__i386__) || defined(__x86_64__)
> >> +#define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
> >> +#elif defined(__arm__)
> >> +#define L1_CACHE_SHIFT	(CONFIG_ARM_L1_CACHE_SHIFT)
> >> +#elif defined(__aarch64__)
> >> +#define L1_CACHE_SHIFT	(6)
> >> +#elif defined(__powerpc__)
> >> +
> >> +/* bytes per L1 cache line */
> >> +#if defined(CONFIG_PPC_8xx)
> >> +#define L1_CACHE_SHIFT	4
> >> +#elif defined(CONFIG_PPC_E500MC)
> >> +#define L1_CACHE_SHIFT	6
> >> +#elif defined(CONFIG_PPC32)
> >> +#if defined(CONFIG_PPC_47x)
> >> +#define L1_CACHE_SHIFT	7
> >> +#else
> >> +#define L1_CACHE_SHIFT	5
> >> +#endif
> >> +#else /* CONFIG_PPC64 */
> >> +#define L1_CACHE_SHIFT	7
> >> +#endif
> >> +
> >> +#elif defined(__sparc__)
> >> +#define L1_CACHE_SHIFT 5
> >> +#elif defined(__alpha__)
> >> +
> >> +#if defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_EV6)
> >> +#define L1_CACHE_SHIFT	6
> >> +#else
> >> +/* Both EV4 and EV5 are write-through, read-allocate,
> >> +   direct-mapped, physical.
> >> +*/
> >> +#define L1_CACHE_SHIFT	5
> >> +#endif
> >> +
> >> +#elif defined(__mips__)
> >> +#define L1_CACHE_SHIFT	CONFIG_MIPS_L1_CACHE_SHIFT
> >> +#elif defined(__ia64__)
> >> +#define L1_CACHE_SHIFT	CONFIG_IA64_L1_CACHE_SHIFT
> >> +#elif defined(__nds32__)
> >> +#define L1_CACHE_SHIFT	5
> >> +#else
> >> +#define L1_CACHE_SHIFT	5
> >> +#endif
> >> +
> >> +#define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
> >> +
> >> +#endif
> >> diff --git a/tools/include/asm/processor.h b/tools/include/asm/processor.h
> >> new file mode 100644
> >> index 0000000..3198ad6
> >> --- /dev/null
> >> +++ b/tools/include/asm/processor.h
> >> @@ -0,0 +1,36 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +
> >> +#ifndef __TOOLS_LINUX_ASM_PROCESSOR_H
> >> +#define __TOOLS_LINUX_ASM_PROCESSOR_H
> >> +
> >> +#include <pthread.h>
> >> +
> >> +#if defined(__i386__) || defined(__x86_64__)
> >> +#include "../../arch/x86/include/asm/vdso/processor.h"
> >> +#elif defined(__arm__)
> >> +#include "../../arch/arm/include/asm/vdso/processor.h"
> >> +#elif defined(__aarch64__)
> >> +#include "../../arch/arm64/include/asm/vdso/processor.h"
> >> +#elif defined(__powerpc__)
> >> +#include "../../arch/powerpc/include/vdso/processor.h"
> >> +#elif defined(__s390__)
> >> +#include "../../arch/s390/include/vdso/processor.h"
> >> +#elif defined(__sh__)
> >> +#include "../../arch/sh/include/asm/processor.h"
> >> +#elif defined(__sparc__)
> >> +#include "../../arch/sparc/include/asm/processor.h"
> >> +#elif defined(__alpha__)
> >> +#include "../../arch/alpha/include/asm/processor.h"
> >> +#elif defined(__mips__)
> >> +#include "../../arch/mips/include/asm/vdso/processor.h"
> >> +#elif defined(__ia64__)
> >> +#include "../../arch/ia64/include/asm/processor.h"
> >> +#elif defined(__xtensa__)
> >> +#include "../../arch/xtensa/include/asm/processor.h"
> >> +#elif defined(__nds32__)
> >> +#include "../../arch/nds32/include/asm/processor.h"
> >> +#else
> >> +#define cpu_relax()	sched_yield()
> > 
> > Does this have a chance to work outside of kernel?
> 
> I am not sure I understand what you meant here.
> sched_yield() is a pthread API, so it should work in the
> user space.
> And it allow the rigntest to compile when it is built on
> the arch which is not handled as above.

It might compile but is likely too heavy to behave
reasonably.

Also, given you did not actually test it I don't
think you should add such arch code.
Note you broke at least s390 here:
../../arch/s390/include/vdso/processor.h
does not actually exist. Where these headers
do exit they tend to include lots of code which won't
build out of kernel.

All this is just for cpu_relax - open coding that seems way easier.


> > 
> >> +#endif
> > 
> > did you actually test or even test build all these arches?
> > Not sure we need to bother with hacks like these.
> 
> Only x86_64 and arm64 arches have been built and tested.

In that case I think you should not add code that you
have not even built let alone tested.


> This is added referring the tools/include/asm/barrier.h.
> 
> > 
> > 
> >> +

