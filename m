Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2115DF9BF9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKLVV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:21:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46708 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfKLVV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:21:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id 193so14208108pfc.13
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=56RmInZgI7Bh5RV3HY6BrZUpnFAVvdE9v++wifdVVbQ=;
        b=ZfNUt0qSlG/eNpBtAZ0VTYWsyYp45EI1kg059Eym4v5QX0Rd4eJhUdGDHMn6QKbyy7
         rAEVCINxRbPGFWvH2zmErPehM9LKyDLyBoDAInAHNKT4/quKkG/EtZO/FhCOkM/nDfkP
         OwUp5RB5f4lGpDiCQlYFyWhQBMqbf0YFKIWuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=56RmInZgI7Bh5RV3HY6BrZUpnFAVvdE9v++wifdVVbQ=;
        b=LIev/NDMPWV3oE6zIIm4TyslUSIUSbtTH2dpJ+7dMH9awvP4Yw+OU7o3mk0Fd8S0dt
         m69T0FNdZB1RzWofEx3eM1hFgnALOQqVUT7Y9MuFPiSvSwdpYOcDeHNNSJ4W/0QBi9nZ
         tviLNsyjhQIq0jVnNEQFbmKdi5QY+JOKWHF30+P19gndg7DX+/8qDbQlhhazWaTd4RcS
         a/K4woKQp38pbtBa+CyqPJMiABZleHojR1uoyaRZ5NaTbruUKeVwmGZHMgBG4A0KlvXk
         IPP6LRsj5PWI3RO3hqXk4AEH2GTHmQZzB3/djkNu17pgargti9K9eBSyFYe+Jw6qqyt8
         gZjg==
X-Gm-Message-State: APjAAAXUNNBf1/2skV+qdqJWAQLIZvTMvgPY/QSXTkMq/G3RNQsWwAM5
        3w37nZE7XdSnCGqYKtGqDyWdrw==
X-Google-Smtp-Source: APXvYqzdFzu4zPPFnJ9ABSyKsWziEZi4Dk2O2pVHeNcsXTcPeB3CKkazqUJ/8FJ/XZkexPEBBAMb2g==
X-Received: by 2002:aa7:8d8b:: with SMTP id i11mr11186741pfr.45.1573593716214;
        Tue, 12 Nov 2019 13:21:56 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c21sm19635349pgh.25.2019.11.12.13.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:21:55 -0800 (PST)
Date:   Tue, 12 Nov 2019 13:21:54 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <201911121313.1097D6EE@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 08:17:57AM +0100, Jiri Slaby wrote:
> On 11. 01. 18, 3:02, Kees Cook wrote:
> > From: David Windsor <dave@nullcore.net>
> > 
> > Mark the kmalloc slab caches as entirely whitelisted. These caches
> > are frequently used to fulfill kernel allocations that contain data
> > to be copied to/from userspace. Internal-only uses are also common,
> > but are scattered in the kernel. For now, mark all the kmalloc caches
> > as whitelisted.
> > 
> > This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
> > whitelisting code in the last public patch of grsecurity/PaX based on my
> > understanding of the code. Changes or omissions from the original code are
> > mine and don't reflect the original grsecurity/PaX code.
> > 
> > Signed-off-by: David Windsor <dave@nullcore.net>
> > [kees: merged in moved kmalloc hunks, adjust commit log]
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-xfs@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Acked-by: Christoph Lameter <cl@linux.com>
> > ---
> >  mm/slab.c        |  3 ++-
> >  mm/slab.h        |  3 ++-
> >  mm/slab_common.c | 10 ++++++----
> >  3 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index b9b0df620bb9..dd367fe17a4e 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> ...
> > @@ -1098,7 +1099,8 @@ void __init setup_kmalloc_cache_index_table(void)
> >  static void __init new_kmalloc_cache(int idx, slab_flags_t flags)
> >  {
> >  	kmalloc_caches[idx] = create_kmalloc_cache(kmalloc_info[idx].name,
> > -					kmalloc_info[idx].size, flags);
> > +					kmalloc_info[idx].size, flags, 0,
> > +					kmalloc_info[idx].size);
> >  }
> >  
> >  /*
> > @@ -1139,7 +1141,7 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> >  
> >  			BUG_ON(!n);
> >  			kmalloc_dma_caches[i] = create_kmalloc_cache(n,
> > -				size, SLAB_CACHE_DMA | flags);
> > +				size, SLAB_CACHE_DMA | flags, 0, 0);
> 
> Hi,
> 
> was there any (undocumented) reason NOT to mark DMA caches as usercopy?
> 
> We are seeing this on s390x:
> 
> > usercopy: Kernel memory overwrite attempt detected to SLUB object
> 'dma-kmalloc-1k' (offset 0, size 11)!
> > ------------[ cut here ]------------
> > kernel BUG at mm/usercopy.c:99!

Interesting! I believe the rationale was that if the region is used for
DMA, allowing direct access to it from userspace could be prone to
races.

> See:
> https://bugzilla.suse.com/show_bug.cgi?id=1156053

For context from the bug, the trace is:

(<0000000000386c5a> usercopy_abort+0xa2/0xa8) 
 <000000000036097a> __check_heap_object+0x11a/0x120  
 <0000000000386b3a> __check_object_size+0x18a/0x208  
 <000000000079b4ba> skb_copy_datagram_from_iter+0x62/0x240  
 <000003ff804edd5c> iucv_sock_sendmsg+0x1fc/0x858 Ýaf_iucv¨  
 <0000000000785894> sock_sendmsg+0x54/0x90  
 <0000000000785944> sock_write_iter+0x74/0xa0  
 <000000000038a3f0> new_sync_write+0x110/0x180  
 <000000000038d42e> vfs_write+0xa6/0x1d0  
 <000000000038d748> ksys_write+0x60/0xe8  
 <000000000096a660> system_call+0xdc/0x2e0  

I know Al worked on fixing up usercopy checking for iters. I wonder if
there is redundant checking happening here? i.e. haven't iters already
done object size verifications, so they're not needed during iter copy
helpers?

> This indeed fixes it:
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1290,7 +1290,8 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>                         kmalloc_caches[KMALLOC_DMA][i] =
> create_kmalloc_cache(
>                                 kmalloc_info[i].name[KMALLOC_DMA],
>                                 kmalloc_info[i].size,
> -                               SLAB_CACHE_DMA | flags, 0, 0);
> +                               SLAB_CACHE_DMA | flags, 0,
> +                               kmalloc_info[i].size);
>                 }
>         }
>  #endif

How is iucv the only network protocol that has run into this? Do others
use a bounce buffer?

-- 
Kees Cook
