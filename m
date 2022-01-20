Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9561494FE4
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345192AbiATOM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:12:27 -0500
Received: from verein.lst.de ([213.95.11.211]:44803 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345116AbiATOM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:12:26 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B904E68C4E; Thu, 20 Jan 2022 15:12:20 +0100 (CET)
Date:   Thu, 20 Jan 2022 15:12:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120141219.GB11707@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 12:17:18AM -0800, John Hubbard wrote:
> Zooming in on the pinning aspect for a moment: last time I attempted to
> convert O_DIRECT callers from gup to pup, I recall wanting very much to
> record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
> or some non-FOLL_PIN method. Because at the end of the IO, it is not
> easy to disentangle which pages require put_page() and which require
> unpin_user_page*().

I don't think that is a problem.  Pinning only need to happen for
ITER_IOVEC, and the only non-user pages there is the ZERO_PAGE added
for padding that can be special cased.
