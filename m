Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2245F278DE7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgIYQSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:18:01 -0400
Received: from verein.lst.de ([213.95.11.211]:56719 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgIYQSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 12:18:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 39A7E68AFE; Fri, 25 Sep 2020 18:17:55 +0200 (CEST)
Date:   Fri, 25 Sep 2020 18:17:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-doc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 08/18] dma-mapping: add a new dma_alloc_noncoherent API
Message-ID: <20200925161754.GA18721@lst.de>
References: <20200915155122.1768241-1-hch@lst.de> <20200915155122.1768241-9-hch@lst.de> <c8ea4023-3e19-d63b-d936-46a04f502a61@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8ea4023-3e19-d63b-d936-46a04f502a61@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 12:15:37PM +0100, Robin Murphy wrote:
> On 2020-09-15 16:51, Christoph Hellwig wrote:
> [...]
>> +These APIs allow to allocate pages in the kernel direct mapping that are
>> +guaranteed to be DMA addressable.  This means that unlike dma_alloc_coherent,
>> +virt_to_page can be called on the resulting address, and the resulting
>
> Nit: if we explicitly describe this as if it's a guarantee that can be 
> relied upon...
>
>> +struct page can be used for everything a struct page is suitable for.
>
> [...]
>> +This routine allocates a region of <size> bytes of consistent memory.  It
>> +returns a pointer to the allocated region (in the processor's virtual address
>> +space) or NULL if the allocation failed.  The returned memory may or may not
>> +be in the kernels direct mapping.  Drivers must not call virt_to_page on
>> +the returned memory region.
>
> ...then forbid this document's target audience from relying on it, 
> something seems off. At the very least it's unhelpfully unclear :/
>
> Given patch #17, I suspect that the first paragraph is the one that's no 
> longer true.

Yes.  dma_alloc_pages is the replacement for allocations that need the
direct mapping.  I'll send a patch to document dma_alloc_pages and
fixes this up
