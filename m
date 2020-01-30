Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA25414E316
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgA3TXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:23:41 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38449 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgA3TXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 14:23:41 -0500
Received: by mail-pj1-f67.google.com with SMTP id j17so1765881pjz.3
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 11:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=STfgILZYJSeHL29PKr26PXRGNaaOXbLTCRy3jhx8noU=;
        b=jqYeVsahhF99yBrSGAvuHdMSc2W97p/s3hZt9gt9YFSuOjK3g3byaqJC2nQE+QDIfI
         Z8NqxNikaMbSwQW2aQmx4Z02ThbSexr8D1XYxdrnXThBpe0rcHGSppH4YG+Li4+wqP63
         2itQvwz4W2zBZh2IImAm5jdwB75aiWKl25l50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=STfgILZYJSeHL29PKr26PXRGNaaOXbLTCRy3jhx8noU=;
        b=lmgWUuVxXR9jJlYWJAjXV1yk+evZs4geuZoKFXsAtOEeJikoP4BwLBMMN3qXA1fy16
         FHX1OWKsk941rVg32+aFQ91o3J+LrhlIFZsknwl9r6RQfGC0IoPJ5kMWGJCKIGWJsVEi
         N1FPL7S3cbVQcLVMmiu0Q33dGPUX/Mjff5ePrnGKKM2q/QAhJQqpDUyOaMKxr3mPfxBZ
         OueD2m9e1ySxWO7V+XXymcOZv5XfNJ4eCHhPLnc2/8w50Ye/mnCOyBKWYPHj3PcOsP6X
         Q9FWuX3Y8LvIHVeaVZXQNRD4/V6tmeLaxrymDsk0PcumwBWWNtb+8WAglCOX6JogNWyy
         30eg==
X-Gm-Message-State: APjAAAXnGxfxz2Z8ao/JgMKU9hw4cZCHn+UqWUDgq2GdQdSaM0hDJVlZ
        w+be3oCUyvndYGqdszuy81VZHA==
X-Google-Smtp-Source: APXvYqw7tzrE450ZfccVZjN7IiTuW4qM2cwf555Gxth2MtTA6Fx8D7q2y+CnyzGujglJaRni3OFJmQ==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr7802031pjk.134.1580412220763;
        Thu, 30 Jan 2020 11:23:40 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b185sm7608776pfa.102.2020.01.30.11.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 11:23:39 -0800 (PST)
Date:   Thu, 30 Jan 2020 11:23:38 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
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
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <202001300945.7D465B5F5@keescook>
References: <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 06:19:56PM +0100, Christian Borntraeger wrote:
> On 29.01.20 18:09, Christoph Hellwig wrote:
> > On Wed, Jan 29, 2020 at 06:07:14PM +0100, Christian Borntraeger wrote:
> >>> DMA can be done to NORMAL memory as well.
> >>
> >> Exactly. 
> >> I think iucv uses GFP_DMA because z/VM needs those buffers to reside below 2GB (which is ZONA_DMA for s390).
> > 
> > The normal way to allocate memory with addressing limits would be to
> > use dma_alloc_coherent and friends.  Any chance to switch iucv over to
> > that?  Or is there no device associated with it?
> 
> There is not necessarily a device for that. It is a hypervisor interface (an
> instruction that is interpreted by z/VM). We do have the netiucv driver that
> creates a virtual nic, but there is also AF_IUCV which works without a device.
> 
> But back to the original question: If we mark kmalloc caches as usercopy caches,
> we should do the same for DMA kmalloc caches. As outlined by Christoph, this has
> nothing to do with device DMA.

Hm, looks like it's allocated from the low 16MB. Seems like poor naming!
:) There seems to be a LOT of stuff using GFP_DMA, and it seems unlikely
those are all expecting low addresses?

Since this has only been a problem on s390, should just s390 gain the
weakening of the usercopy restriction?  Something like:


diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1907cb2903c7..c5bbc141f20b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1303,7 +1303,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
 			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
 				kmalloc_info[i].name[KMALLOC_DMA],
 				kmalloc_info[i].size,
-				SLAB_CACHE_DMA | flags, 0, 0);
+				SLAB_CACHE_DMA | flags, 0,
+				IS_ENABLED(CONFIG_S390) ?
+					kmalloc_info[i].size : 0);
 		}
 	}
 #endif



-- 
Kees Cook
