Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684A020BA7B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgFZUo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:44:58 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:50376 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFZUo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:44:58 -0400
Received: (qmail 90924 invoked by uid 89); 26 Jun 2020 20:44:53 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 26 Jun 2020 20:44:53 -0000
Date:   Fri, 26 Jun 2020 13:44:48 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        hch@lst.de, davem@davemloft.net, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, maximmi@mellanox.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
Message-ID: <20200626204448.bxvr35qaxkfj6chs@bsd-mbp>
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200626134358.90122-1-bjorn.topel@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 03:43:58PM +0200, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> When the AF_XDP buffer allocation API was introduced it had an
> optimization, "cheap_dma". The idea was that when the umem was DMA
> mapped, the pool also checked whether the mapping required a
> synchronization (CPU to device, and vice versa). If not, it would be
> marked as "cheap_dma" and the synchronization would be elided.
> 
> In [1] Christoph points out that the optimization above breaks the DMA
> API abstraction, and should be removed. Further, Christoph points out
> that optimizations like this should be done within the DMA mapping
> core, and not elsewhere.
> 
> Unfortunately this has implications for the packet rate
> performance. The AF_XDP rxdrop scenario shows a 9% decrease in packets
> per second.
> 
> [1] https://lore.kernel.org/netdev/20200626074725.GA21790@lst.de/
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
