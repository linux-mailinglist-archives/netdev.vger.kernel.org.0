Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21350363B82
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhDSGfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:35:15 -0400
Received: from verein.lst.de ([213.95.11.211]:45258 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229840AbhDSGfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:35:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A92C068B05; Mon, 19 Apr 2021 08:34:41 +0200 (CEST)
Date:   Mon, 19 Apr 2021 08:34:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210419063441.GA18787@lst.de>
References: <20210411114307.5087f958@carbon> <20210411103318.GC2531743@casper.infradead.org> <20210412011532.GG2531743@casper.infradead.org> <20210414101044.19da09df@carbon> <20210414115052.GS2531743@casper.infradead.org> <20210414211322.3799afd4@carbon> <20210414213556.GY2531743@casper.infradead.org> <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com> <20210415200832.32796445@carbon> <20210416152755.GL2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416152755.GL2531743@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 04:27:55PM +0100, Matthew Wilcox wrote:
> On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> > See below patch.  Where I swap32 the dma address to satisfy
> > page->compound having bit zero cleared. (It is the simplest fix I could
> > come up with).
> 
> I think this is slightly simpler, and as a bonus code that assumes the
> old layout won't compile.

So, why do we even do this crappy overlay of a dma address?  This just
all seems like a giant hack.  Random subsystems should not just steal
a few struct page fields as that just turns into the desasters like the
one we've seen here or probably something worse next time.
