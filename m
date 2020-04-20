Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E5D1B1364
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgDTRnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgDTRnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:43:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDE6C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:43:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 7so217034pjo.0
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UbWvOzsjdwKmCuURzqakr712Hwz970Vkw5PGIrntIJg=;
        b=jQBTeSx5RVM7KT1U22GJEb3DH2uZPfcy8Q8n8Z4yMQbR4xX77sT7UNorH68BHXQklv
         iqyP+lyhtbiw1Z8E6mrIAOVUfrKDbExPTw1eCNreicq7+fmKaKDC0t3L5Z68emnhhiQY
         F68qqIHfXsfIWhK8AMTQ6lJSl/wFSmFVqe+Fs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UbWvOzsjdwKmCuURzqakr712Hwz970Vkw5PGIrntIJg=;
        b=fKv9yn4Sc6HE1DsXVpQhfno1YP7OJh/moAj2pi6FPtaa6Wj0kKAPm7qUfoTP1Lmjtt
         W6t1CUAcgxPQhH8oTQI0Puaucq+4E5oDuDJcyKbJt5pB4fcUC1xvz6nAx6NjdNZ62ZG2
         tV5vnYibJB0B7HFV7hTm3IQKyVxAPbBoD6ltQOgAM9x8N5DHgcSHCsB7sR+9cwBPzHgv
         yKxCgeeRgWdpKtAV8kWe0gh0PMS9j2u6wF4lCjD/j9YAqnifR6mj/y4ypiwu8EqUQkGs
         zwJzkvIpT+i6xJfT2Tkhk6IOVgz284GDrH7rODMwT68+mhGhiHDDbXdwZ+4C8MhZZaBR
         dqYw==
X-Gm-Message-State: AGi0PuZQM9o6SL7h0uUGPnH4Um8EIyaFQRpgLnuANf0FAYQUEdL9ZQGv
        MizNRHpjlhm0wRUopHw4tDmO8w==
X-Google-Smtp-Source: APiQypLBX8wx/oUkDoqkb/2Bm8ippA2jak1OrscI29iIv8/MVYRimaZ8XN8jTccr1R5iuIwy3W5LTA==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr18181334plk.100.1587404619781;
        Mon, 20 Apr 2020 10:43:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v26sm106522pff.45.2020.04.20.10.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 10:43:38 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:43:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
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
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202004201043.538A7B3F2@keescook>
References: <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
 <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
 <7d810f6d-8085-ea2f-7805-47ba3842dc50@suse.cz>
 <548e6212-7b3c-5925-19f2-699af451fd16@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548e6212-7b3c-5925-19f2-699af451fd16@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 09:53:20AM +0200, Jiri Slaby wrote:
> On 07. 04. 20, 10:00, Vlastimil Babka wrote:
> > From d5190e4e871689a530da3c3fd327be45a88f006a Mon Sep 17 00:00:00 2001
> > From: Vlastimil Babka <vbabka@suse.cz>
> > Date: Tue, 7 Apr 2020 09:58:00 +0200
> > Subject: [PATCH] usercopy: Mark dma-kmalloc caches as usercopy caches
> > 
> > We have seen a "usercopy: Kernel memory overwrite attempt detected to SLUB
> > object 'dma-kmalloc-1 k' (offset 0, size 11)!" error on s390x, as IUCV uses
> > kmalloc() with __GFP_DMA because of memory address restrictions.
> > The issue has been discussed [2] and it has been noted that if all the kmalloc
> > caches are marked as usercopy, there's little reason not to mark dma-kmalloc
> > caches too. The 'dma' part merely means that __GFP_DMA is used to restrict
> > memory address range.
> > 
> > As Jann Horn put it [3]:
> > 
> > "I think dma-kmalloc slabs should be handled the same way as normal
> > kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
> > just normal kernel memory - even if it might later be used for DMA -,
> > and it should be perfectly fine to copy_from_user() into such
> > allocations at that point, and to copy_to_user() out of them at the
> > end. If you look at the places where such allocations are created, you
> > can see things like kmemdup(), memcpy() and so on - all normal
> > operations that shouldn't conceptually be different from usercopy in
> > any relevant way."
> > 
> > Thus this patch marks the dma-kmalloc-* caches as usercopy.
> > 
> > [1] https://bugzilla.suse.com/show_bug.cgi?id=1156053
> > [2] https://lore.kernel.org/kernel-hardening/bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz/
> > [3] https://lore.kernel.org/kernel-hardening/CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com/
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Friendly ping.
> 
> Acked-by: Jiri Slaby <jslaby@suse.cz>

Should this go via -mm?

-Kees

> 
> > ---
> >  mm/slab_common.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 5282f881d2f5..ae9486160594 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1303,7 +1303,8 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> >  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
> >  				kmalloc_info[i].name[KMALLOC_DMA],
> >  				kmalloc_info[i].size,
> > -				SLAB_CACHE_DMA | flags, 0, 0);
> > +				SLAB_CACHE_DMA | flags, 0,
> > +				kmalloc_info[i].size);
> >  		}
> >  	}
> >  #endif
> > 
> 
> thanks,
> -- 
> js
> suse labs

-- 
Kees Cook
