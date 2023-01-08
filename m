Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0563661756
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 18:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjAHRYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 12:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjAHRYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 12:24:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A37BE14;
        Sun,  8 Jan 2023 09:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WNyoZTkoExUmXqvGesIlbw00ZoUJyc/GjFEcWcL7Kds=; b=qUzNX0tRX01ErBEc7fP7m/YKw5
        Vl9A2wqkoOPgdtb/ViHgWzLFySziDrbsGPQEciuxYE+eLJ2KJVrCt0s1tsGMEzTjJ5oBN8T6HAt98
        ZueqRxzfQxwffqrB7FC8wOEqeDDr4yI1l9Y+nDUAJDOKnoK38QQ+lNzRMH67/RDrrUV86MVwShjUh
        +od5SncJtBeR3pIMyQS29S8Pj1NK4eSP6VKZSHR1kC1jvx6WKK3F0UPToatlxbaxBYEibfbmLL6sj
        6tNls6oW09X/F17GUl3TAwy3L5sEH2aauE39Vs8oEPzgJXSsd/t5C0rh+dxSXjRUdZAknWbzX/Vet
        FlfKKoww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pEZPZ-00EZ7r-S9; Sun, 08 Jan 2023 17:24:45 +0000
Date:   Sun, 8 Jan 2023 09:24:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: remove zap_page_range and create zap_vma_pages
Message-ID: <Y7r8XRLIOHADjdrz@infradead.org>
References: <20230104002732.232573-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104002732.232573-1-mike.kravetz@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I would have split this into one patch that adds the new
zap_vma_pages helper, and one to remove zap_page_range to split the
separate changes.

But the overall result looks fine, so feel free to add:

Reviewed-by: Christoph Hellwig <hch@lst.de>

to this or the split patches.
