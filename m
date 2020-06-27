Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADF720BF35
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 09:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgF0HEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 03:04:10 -0400
Received: from verein.lst.de ([213.95.11.211]:53810 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgF0HEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 03:04:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 229C568B02; Sat, 27 Jun 2020 09:04:07 +0200 (CEST)
Date:   Sat, 27 Jun 2020 09:04:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        hch@lst.de, davem@davemloft.net, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, maximmi@mellanox.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
Message-ID: <20200627070406.GB11854@lst.de>
References: <20200626134358.90122-1-bjorn.topel@gmail.com> <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 01:00:19AM +0200, Daniel Borkmann wrote:
> Given there is roughly a ~5 weeks window at max where this removal could
> still be applied in the worst case, could we come up with a fix / proposal
> first that moves this into the DMA mapping core? If there is something that
> can be agreed upon by all parties, then we could avoid re-adding the 9%
> slowdown. :/

I'd rather turn it upside down - this abuse of the internals blocks work
that has basically just missed the previous window and I'm not going
to wait weeks to sort out the API misuse.  But we can add optimizations
back later if we find a sane way.

That being said I really can't see how this would make so much of a
difference.  What architecture and what dma_ops are you using for
those measurements?  What is the workload?
