Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5928D28325B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJEInt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEInt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:43:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E44C0613CE;
        Mon,  5 Oct 2020 01:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RjUOM19f7vxRO65BClQAZjONUGgypXRxz1Pa18sj1Xg=; b=JFlgfoVpMwR2G6r7THJaaTYAEW
        4GI2JI1k/OcS20voEhaT49fApsj7wgWmUUqneZXy9sIdkv/0EnhaNH4v3/s0/GJiq9oBdGL/RzF4x
        si2psPHyMONAG/sAqLCpm2T7ldEZJHe9/6QFGbc3FpTiXhQAc1FT2xAh4lmPx9waBmPhYg5O5jc1Y
        7a3lno5iWO3gicN9kqJ6+/OOIPoZCTAoXVpnjq6LKjEuQ8yztTXbOdX0MftUYg015kxdeBSQAu2p2
        osYFYOC+Byn4eGbMfivuDP1pZumClYHWiDBIxJc6N4J7QcbABZsaHriCnaZQTCGL0mBWxEvwNzamA
        ysxWzBuw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM5t-0000sk-5H; Mon, 05 Oct 2020 08:43:41 +0000
Date:   Mon, 5 Oct 2020 09:43:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     davem@davemloft.net, Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        maximmi@mellanox.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: Re: please revert [PATCH bpf-next v5 03/15] xsk: create and free
 buffer pool independently from umem
Message-ID: <20201005084341.GA3224@infradead.org>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
 <1598603189-32145-4-git-send-email-magnus.karlsson@intel.com>
 <20201005083535.GA512@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005083535.GA512@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 09:35:35AM +0100, Christoph Hellwig wrote:
> Hi Dave,
> 
> please can you rever this?  This is the second xsk patch this year
> that pokes into dma-mapping internals for absolutely not reason.
> 
> And we discussed this in detail the last time around: drivers have
> absolutely no business poking into dma-direct.h and dma-noncoherent.h.
> In fact because people do this crap I have a patch to remove these
> headers that I'm about to queue up, so if this doesn't get reverted
> the linux-next build will break soon.

Looks like it doesn't actually use any functionality and just
pointlessly includes internal headers.  So just removing dma-direct.h,
dma-noncoherent.h and swiotlb.h should do the job as well.

But guys, don't do this.
