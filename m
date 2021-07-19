Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253D83CD439
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 13:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhGSLRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 07:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232138AbhGSLR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 07:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626695889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pjiBFtBbN3Tpa6+FO6osoKkB4QfSBpg6c+lRQJCM5pw=;
        b=IlrnW24Tfocx6kwP0vYWcarSpzIrFbT02t7HHGAPx6bm4SOHYKJwzm6014tBKf/hOgyK4G
        teWf8PppFYGiLXjhRXKTzQv/Jry3KJKckALN+0cA7uPDqSgynDYplKAi3/q+QwxCPsMaYX
        l0ZpzPvAzoCasyrrg3/z6NX7JtO1PoI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-gcWArlDWPVWqSyfUFO2WGQ-1; Mon, 19 Jul 2021 07:58:08 -0400
X-MC-Unique: gcWArlDWPVWqSyfUFO2WGQ-1
Received: by mail-wr1-f72.google.com with SMTP id i12-20020adffc0c0000b0290140ab4d8389so8722134wrr.10
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 04:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pjiBFtBbN3Tpa6+FO6osoKkB4QfSBpg6c+lRQJCM5pw=;
        b=NwcCsfm972Zi1eWaQ03qGNbNPj58RO+H0tBR7J3aPN5DaFZZGvNnyg7bFVZ4GqGsQA
         q4HiSuePhoy1axLZTOf/WtWlfRFRQGDZS5vnljDmZPJZtLlc0DzcJq+jaO8phkIATsSu
         5xZggeGqB6S6m/GP3TiK+Vhfx+97tJy8femaoD6R9HUHXjXCTHSKZDT1iJDjHHxP6Xao
         AXBpjBOT2rhxa0csGHBjEL01GVl7rOXq5VyFzZ/FCyNCvFe9jZLmvzGSLcKNPX5vEjsH
         T6SeFGNgD6YHNjYeTLQ0Wn3uJpW/3hiVSlx/09FH1qNkrjvwgb0AP0z6ach1i0Aer+iU
         O8Tw==
X-Gm-Message-State: AOAM532xu5vbPlnx/V3wKk0r5jp+Q7pP0/jp5vC5PdZkYazf6yLksRRY
        v4LZ4EmQBoPnsP8qUOvKSxX13KaTD1vRvAoDjRu0uAa/NtLtrVUvSFpj5ZUS+KJe9HQ0AJqV/fX
        YS+WL0oDaN5lYso4I
X-Received: by 2002:a5d:6ac4:: with SMTP id u4mr29212483wrw.166.1626695887137;
        Mon, 19 Jul 2021 04:58:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+OAIWZXBnOoLEaejahoNmZdXq7HnXiPt48QZY8Inz4B2bfDo9yCBx/7ow9p4m2kL0QelGZg==
X-Received: by 2002:a5d:6ac4:: with SMTP id u4mr29212465wrw.166.1626695887015;
        Mon, 19 Jul 2021 04:58:07 -0700 (PDT)
Received: from redhat.com ([2.55.11.37])
        by smtp.gmail.com with ESMTPSA id 129sm16885866wmz.26.2021.07.19.04.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 04:58:05 -0700 (PDT)
Date:   Mon, 19 Jul 2021 07:58:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jasowang@redhat.com,
        nickhu@andestech.com, green.hu@gmail.com, deanbo422@gmail.com,
        akpm@linux-foundation.org, yury.norov@gmail.com,
        andriy.shevchenko@linux.intel.com, ojeda@kernel.org,
        ndesaulniers@gooogle.com, joe@perches.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Subject: Re: [PATCH net-next 1/2] tools: add missing infrastructure for
 building ptr_ring.h
Message-ID: <20210719075748-mutt-send-email-mst@kernel.org>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <1625457455-4667-2-git-send-email-linyunsheng@huawei.com>
 <20210705143144-mutt-send-email-mst@kernel.org>
 <cbc4053e-7eda-4c46-5b98-558c741e45b6@huawei.com>
 <20210717220239-mutt-send-email-mst@kernel.org>
 <5d320b37-18f3-e853-ceb7-21af7ca12763@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d320b37-18f3-e853-ceb7-21af7ca12763@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 09:40:39AM +0800, Yunsheng Lin wrote:
> On 2021/7/18 10:09, Michael S. Tsirkin wrote:
> > On Tue, Jul 06, 2021 at 10:04:02AM +0800, Yunsheng Lin wrote:
> >> On 2021/7/6 2:39, Michael S. Tsirkin wrote:
> >>> On Mon, Jul 05, 2021 at 11:57:34AM +0800, Yunsheng Lin wrote:
> 
> [..]
> 
> >>>> diff --git a/tools/include/asm/processor.h b/tools/include/asm/processor.h
> >>>> new file mode 100644
> >>>> index 0000000..3198ad6
> >>>> --- /dev/null
> >>>> +++ b/tools/include/asm/processor.h
> >>>> @@ -0,0 +1,36 @@
> >>>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>>> +
> >>>> +#ifndef __TOOLS_LINUX_ASM_PROCESSOR_H
> >>>> +#define __TOOLS_LINUX_ASM_PROCESSOR_H
> >>>> +
> >>>> +#include <pthread.h>
> >>>> +
> >>>> +#if defined(__i386__) || defined(__x86_64__)
> >>>> +#include "../../arch/x86/include/asm/vdso/processor.h"
> >>>> +#elif defined(__arm__)
> >>>> +#include "../../arch/arm/include/asm/vdso/processor.h"
> >>>> +#elif defined(__aarch64__)
> >>>> +#include "../../arch/arm64/include/asm/vdso/processor.h"
> >>>> +#elif defined(__powerpc__)
> >>>> +#include "../../arch/powerpc/include/vdso/processor.h"
> >>>> +#elif defined(__s390__)
> >>>> +#include "../../arch/s390/include/vdso/processor.h"
> >>>> +#elif defined(__sh__)
> >>>> +#include "../../arch/sh/include/asm/processor.h"
> >>>> +#elif defined(__sparc__)
> >>>> +#include "../../arch/sparc/include/asm/processor.h"
> >>>> +#elif defined(__alpha__)
> >>>> +#include "../../arch/alpha/include/asm/processor.h"
> >>>> +#elif defined(__mips__)
> >>>> +#include "../../arch/mips/include/asm/vdso/processor.h"
> >>>> +#elif defined(__ia64__)
> >>>> +#include "../../arch/ia64/include/asm/processor.h"
> >>>> +#elif defined(__xtensa__)
> >>>> +#include "../../arch/xtensa/include/asm/processor.h"
> >>>> +#elif defined(__nds32__)
> >>>> +#include "../../arch/nds32/include/asm/processor.h"
> >>>> +#else
> >>>> +#define cpu_relax()	sched_yield()
> >>>
> >>> Does this have a chance to work outside of kernel?
> >>
> >> I am not sure I understand what you meant here.
> >> sched_yield() is a pthread API, so it should work in the
> >> user space.
> >> And it allow the rigntest to compile when it is built on
> >> the arch which is not handled as above.
> > 
> > It might compile but is likely too heavy to behave
> > reasonably.
> > 
> > Also, given you did not actually test it I don't
> > think you should add such arch code.
> > Note you broke at least s390 here:
> > ../../arch/s390/include/vdso/processor.h
> > does not actually exist. Where these headers
> > do exit they tend to include lots of code which won't
> > build out of kernel.
> 
> You are right, it should be in:
> ../../arch/s390/include/asm/vdso/processor.h
> 
> > 
> > All this is just for cpu_relax - open coding that seems way easier.
> 
> Sure.
> 
> As Eugenio has posted a patchset to fix the compilation, which does
> not seems to be merged yet and may have some merging conflicts with
> this patchset, so either wait for the Eugenio' patchset to be merged
> before proceeding with this patchset, or explicitly note the dependency
> of Eugenio' patchset when sending the new version of patchset. I am not
> familiar with the merging flow of virtio to say which way is better, any
> suggestion how to proceed with this patchset?
> 
> 1. https://lkml.org/lkml/2021/7/6/1132
> 
> > 
> > 
> >>>
> >>>> +#endif
> >>>
> >>> did you actually test or even test build all these arches?
> >>> Not sure we need to bother with hacks like these.
> >>
> >> Only x86_64 and arm64 arches have been built and tested.
> > 
> > In that case I think you should not add code that you
> > have not even built let alone tested.
> 
> Ok.
> 
> > 
> > 
> >> This is added referring the tools/include/asm/barrier.h.
> >>
> >>>
> >>>
> >>>> +
> > 
> > .


I will merge Eugenio's patchset soon.

-- 
MST

