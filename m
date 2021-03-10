Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32462336808
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhCJXrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233695AbhCJXrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2E364FC8;
        Wed, 10 Mar 2021 23:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615420024;
        bh=rn7Xr3yIxnnV9BAoPugT+l22JqgQDqgLjIf7EbU0AGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=euJqPDQ6UAmWIcW6l+ea4stipU1fQr9d9CgnEN9dfMnNUzReFQNJqHfdSn3MeVW5B
         Sq+ohg7MQwVwNrtnNsrQQSs1wF2o7qSJEqO9jlcFfRfKPIsgJFBDs3ZTHCmjx+2a4r
         CRVra3d/lUX6k0zAfa0yX0mZoiStN2Qj5KuotG5o=
Date:   Wed, 10 Mar 2021 15:47:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-Id: <20210310154704.9389055d0be891a0c3549cc2@linux-foundation.org>
In-Reply-To: <20210310104618.22750-1-mgorman@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 10:46:13 +0000 Mel Gorman <mgorman@techsingularity.net> wrote:

> This series introduces a bulk order-0 page allocator with sunrpc and
> the network page pool being the first users.

<scratches head>

Right now, the [0/n] doesn't even tell us that it's a performance
patchset!

The whole point of this patchset appears to appear in the final paragraph
of the final patch's changelog.

: For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
: redirecting xdp_frame packets into a veth, that does XDP_PASS to create
: an SKB from the xdp_frame, which then cannot return the page to the
: page_pool.  In this case, we saw[1] an improvement of 18.8% from using
: the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).

Much more detail on the overall objective and the observed results,
please?

Also, that workload looks awfully corner-casey.  How beneficial is this
work for more general and widely-used operations?

> The implementation is not
> particularly efficient and the intention is to iron out what the semantics
> of the API should have for users. Once the semantics are ironed out, it can
> be made more efficient.

And some guesstimates about how much benefit remains to be realized
would be helpful.

