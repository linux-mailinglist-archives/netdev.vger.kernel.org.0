Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5385E27177A
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 21:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgITTXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 15:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITTXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 15:23:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DFEC061755;
        Sun, 20 Sep 2020 12:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M9C+xMteCLmxjuhFVA61FIZoHdpfMD5Lc3Ug+y14apc=; b=TU8gswjuXpvm/MyBSJB1vaOTwg
        7CcQFeWPYOwW6PYXhvCpp0vzvWldb70TKuwk6v9nWcowTGn2VYxRj0sbzAeS1dOPc7tVJZV69Nc6Y
        Oye5Ac32YDMVeUtWbcgDk6Lqhz34cgGhYuiR2uTx7CyOyrh4ejW/zOiv0nLMgTDXz/4QksW+LarsO
        UKo48ovg6z43+egEg49LBUL7Qb1BK2+QYQXYWWRv+ZaoBr++1zvkvXaDBQNH/ENPEz9dpyIhUnPg/
        RMo/EthNeTct23dRta9OEBgDELlkG8IIvv6XkLyXzRfFWLEelnomJhQf946LaXKaS04BIvNdWa7Hj
        bCj2UmxA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK4vL-0001qh-MM; Sun, 20 Sep 2020 19:22:59 +0000
Date:   Sun, 20 Sep 2020 20:22:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920192259.GU32101@casper.infradead.org>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
 <20200920180742.GN3421308@ZenIV.linux.org.uk>
 <20200920190159.GT32101@casper.infradead.org>
 <20200920191031.GQ3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920191031.GQ3421308@ZenIV.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 08:10:31PM +0100, Al Viro wrote:
> IMO it's much saner to mark those and refuse to touch them from io_uring...

Simpler solution is to remove io_uring from the 32-bit syscall list.
If you're a 32-bit process, you don't get to use io_uring.  Would
any real users actually care about that?
