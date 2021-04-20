Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50A36512C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhDTEDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:03:55 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55427 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhDTEDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 00:03:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FPVQt5v9Kz9vDw;
        Tue, 20 Apr 2021 14:03:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1618891401;
        bh=ykDn0c4Pei/ni8JeosESXjK9PStd/mFtGxVh8YrZKPo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WAzcjt4GF5woknj0LOcFLLaZXQt4dxoP7XPsbd7Tfc1ZG1omi42FFMVoV9nSFqQho
         Nm9HeadCpbCSiKDCzKxPEin83TkkOVRNfkkriIZRvLAzVPgdswB9tsavwJleQekRLX
         enavKzaRFnyMjr49Bu8x4BXaAh50ERXzYbqbZnasQSQJjlRWT8GT0o8YyeWj7yNT8H
         SAQkKiu9Z5cM3IrONxJBmovgdEC2V3CpOs3qXHVGyk37PLNqcK3YziP+GQJMOP3Um8
         uEqVHGZl6+7aGF0tu9EUML9m1weR+PZkuPR+Wlqofl74HscYVDBxO8zGG3CBwzRoKJ
         ca8b0iHu4Cymg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, brouer@redhat.com
Cc:     arnd@kernel.org, grygorii.strashko@ti.com, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, linux-kernel@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mips@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org,
        mgorman@suse.de, mcroce@linux.microsoft.com,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        hch@lst.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Change struct page layout for page_pool
In-Reply-To: <20210416230724.2519198-1-willy@infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
Date:   Tue, 20 Apr 2021 14:03:18 +1000
Message-ID: <874kg1d2m1.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Matthew Wilcox (Oracle)" <willy@infradead.org> writes:
> The first patch here fixes two bugs on ppc32, and mips32.  It fixes one
> bug on arc and arm32 (in certain configurations).  It probably makes
> sense to get it in ASAP through the networking tree.  I'd like to see
> testing on those four architectures if possible?

Sorry I don't have easy access to any hardware that fits the bill. At
some point I'll be able to go to the office and setup a machine that (I
think) can test these paths, but I don't have an ETA on that.

You and others seem to have done lots of analysis on this though, so I
think you should merge the fixes without waiting on ppc32 testing.

cheers


>
> The second patch enables new functionality.  It is much less urgent.
> I'd really like to see Mel & Michal's thoughts on it.
>
> I have only compile-tested these patches.
>
> Matthew Wilcox (Oracle) (2):
>   mm: Fix struct page layout on 32-bit systems
>   mm: Indicate pfmemalloc pages in compound_head
>
>  include/linux/mm.h       | 12 +++++++-----
>  include/linux/mm_types.h |  9 ++++-----
>  include/net/page_pool.h  | 12 +++++++++++-
>  net/core/page_pool.c     | 12 +++++++-----
>  4 files changed, 29 insertions(+), 16 deletions(-)
>
> -- 
> 2.30.2
