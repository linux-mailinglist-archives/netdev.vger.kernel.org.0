Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0F27859B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgIYLPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 07:15:44 -0400
Received: from foss.arm.com ([217.140.110.172]:42402 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIYLPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 07:15:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B1D101E;
        Fri, 25 Sep 2020 04:15:42 -0700 (PDT)
Received: from [10.57.48.76] (unknown [10.57.48.76])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 986323F70D;
        Fri, 25 Sep 2020 04:15:38 -0700 (PDT)
Subject: Re: [PATCH 08/18] dma-mapping: add a new dma_alloc_noncoherent API
To:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20200915155122.1768241-1-hch@lst.de>
 <20200915155122.1768241-9-hch@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <c8ea4023-3e19-d63b-d936-46a04f502a61@arm.com>
Date:   Fri, 25 Sep 2020 12:15:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200915155122.1768241-9-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-15 16:51, Christoph Hellwig wrote:
[...]
> +These APIs allow to allocate pages in the kernel direct mapping that are
> +guaranteed to be DMA addressable.  This means that unlike dma_alloc_coherent,
> +virt_to_page can be called on the resulting address, and the resulting

Nit: if we explicitly describe this as if it's a guarantee that can be 
relied upon...

> +struct page can be used for everything a struct page is suitable for.

[...]
> +This routine allocates a region of <size> bytes of consistent memory.  It
> +returns a pointer to the allocated region (in the processor's virtual address
> +space) or NULL if the allocation failed.  The returned memory may or may not
> +be in the kernels direct mapping.  Drivers must not call virt_to_page on
> +the returned memory region.

...then forbid this document's target audience from relying on it, 
something seems off. At the very least it's unhelpfully unclear :/

Given patch #17, I suspect that the first paragraph is the one that's no 
longer true.

Robin.
