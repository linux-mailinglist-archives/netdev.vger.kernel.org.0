Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E014494FD8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbiATOJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:09:45 -0500
Received: from verein.lst.de ([213.95.11.211]:44769 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345355AbiATOJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:09:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0284E68BEB; Thu, 20 Jan 2022 15:09:40 +0100 (CET)
Date:   Thu, 20 Jan 2022 15:09:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Matthew Wilcox <willy@infradead.org>, nvdimm@lists.linux.dev,
        linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Phyr Starter
Message-ID: <20220120140939.GA11707@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com> <CAKMK7uFfpTKQEPpVQxNDi0NeO732PJMfiZ=N6u39bSCFY3d6VQ@mail.gmail.com> <20220111202648.GP2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111202648.GP2328285@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 04:26:48PM -0400, Jason Gunthorpe wrote:
> What I did in RDMA was make an iterator rdma_umem_for_each_dma_block()
> 
> The driver passes in the page size it wants and the iterator breaks up
> the SGL into that size.
> 
> So, eg on a 16k page size system the SGL would be full of 16K stuff,
> but the driver only support 4k and so the iterator hands out 4 pages
> for each SGL entry.
> 
> All the drivers use this to build their DMA lists and tables, it works
> really well.

The block layer also has the equivalent functionality by setting the
virt_boundary value in the queue_limits.  This is needed for NVMe
PRPs and RDMA drivers.
