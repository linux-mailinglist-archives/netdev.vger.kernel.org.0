Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A77150ECD
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgBCRll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:41:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgBCRll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 12:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m5X7HEtnOnQXbN/sddNWpeOVFq9PT+3WrfrbyQzTz3g=; b=N95/11YsOrwnHffWbeoB4BWA+u
        hqp995pRji8gqPPrZYbqJL5zhdfvxVSic0OOcMqULsBeX6tGPtfU3KtjW1tRTB6XpRs+HyEBNJzD4
        8DBu76kx5P4mUsBN6q0OMKp9Hg9WEI1xxxkaNSLQ3936nEYmpAicjUQiBHztOgAoUV1rEuzlnXfIO
        jTnnMUjjtZbqJgcDBxZHgqP58s/4x1/ameMy2ZHWrRGmG5z7dBe2eKS0sB/OD2oPon2CmCEh3DeBx
        9jRDnQwVxjGLB/f1Pg5JlX/gHdtK1CACCetBB7Q8XzvfBgg5HzV+bwT+rbaDYQK3/K43/9xHpN3kR
        bMEJTLcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyfj4-0002Pi-8T; Mon, 03 Feb 2020 17:41:34 +0000
Date:   Mon, 3 Feb 2020 09:41:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
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
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <20200203174134.GC30011@infradead.org>
References: <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
 <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
 <202002010952.ACDA7A81@keescook>
 <CAG48ez2ms+TDEXQdDONuQ1GG0K20E69nV1r_yjKxxYjYKv1VCg@mail.gmail.com>
 <20200203074644.GD8731@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203074644.GD8731@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 02, 2020 at 11:46:44PM -0800, Matthew Wilcox wrote:
> > gives the hardware access to completely unrelated memory.) Instead,
> > they get pages from the page allocator, and these pages may e.g. be
> > allocated from the DMA, DMA32 or NORMAL zones depending on the
> > restrictions imposed by hardware. So I think the usercopy restriction
> > only affects a few oddball drivers (like this s390 stuff), which is
> > why you're not seeing more bug reports caused by this.
> 
> Getting pages from the page allocator is true for dma_alloc_coherent()
> and friends.

dma_alloc_coherent also has a few other memory sources than the page
allocator..

> But it's not true for streaming DMA mappings (dma_map_*)
> for which the memory usually comes from kmalloc().  If this is something
> we want to fix (and I have an awful feeling we're going to regret it
> if we say "no, we trust the hardware"), we're going to have to come up
> with a new memory allocation API for these cases.  Or bounce bugger the
> memory for devices we don't trust.

There aren't too many places that use slab allocations for streaming
mappings, and then do usercopies into them.  But I vaguely remember
some usb code getting the annotations for that a while ago.

But if you don't trust your hardware you will need to use IOMMUs and
page aligned memory, or IOMMUs plus bounce buffering for the kmalloc
allocations (we've recently grown code to do that for the intel-iommu
driver, which needs to be lifted into the generic IOMMU code).
