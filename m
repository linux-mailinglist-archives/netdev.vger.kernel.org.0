Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D60494FC3
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbiATODp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:03:45 -0500
Received: from verein.lst.de ([213.95.11.211]:44751 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235542AbiATODo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:03:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A34668BEB; Thu, 20 Jan 2022 15:03:40 +0100 (CET)
Date:   Thu, 20 Jan 2022 15:03:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120140340.GC11223@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com> <Yd0IeK5s/E0fuWqn@casper.infradead.org> <20220111150142.GL2328285@nvidia.com> <Yd3Nle3YN063ZFVY@casper.infradead.org> <20220111202159.GO2328285@nvidia.com> <Yd311C45gpQ3LqaW@casper.infradead.org> <20220111225306.GR2328285@nvidia.com> <Yd8fz4bY/aMMk24h@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8fz4bY/aMMk24h@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 06:37:03PM +0000, Matthew Wilcox wrote:
> But let's go further than that (which only brings us to 32 bytes per
> range).  For the systems you care about which use an identity mapping,
> and have sizeof(dma_addr_t) == sizeof(phys_addr_t), we can simply
> point the dma_range pointer to the same memory as the phyr.  We just
> have to not free it too early.  That gets us down to 16 bytes per range,
> a saving of 33%.

Even without an IOMMU the dma_addr_t can have offsets vs the actual
physical address.  Not on x86 except for a weirdo SOC, but just about
everywhere else.
