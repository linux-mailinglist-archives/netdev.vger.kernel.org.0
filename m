Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0731A3423AA
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 18:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCSRuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 13:50:03 -0400
Received: from outbound-smtp17.blacknight.com ([46.22.139.234]:54469 "EHLO
        outbound-smtp17.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229974AbhCSRt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 13:49:29 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp17.blacknight.com (Postfix) with ESMTPS id BAF9D1C5126
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:49:27 +0000 (GMT)
Received: (qmail 11366 invoked from network); 19 Mar 2021 17:49:27 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 19 Mar 2021 17:49:27 -0000
Date:   Fri, 19 Mar 2021 17:49:26 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm/page_alloc: Move gfp_allowed_mask enforcement to
 prepare_alloc_pages
Message-ID: <20210319174926.GC3697@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
 <20210312154331.32229-2-mgorman@techsingularity.net>
 <2b5b3bea-c247-0564-f2d4-1dad28f176ed@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <2b5b3bea-c247-0564-f2d4-1dad28f176ed@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 05:11:39PM +0100, Vlastimil Babka wrote:
> On 3/12/21 4:43 PM, Mel Gorman wrote:
> > __alloc_pages updates GFP flags to enforce what flags are allowed
> > during a global context such as booting or suspend. This patch moves the
> > enforcement from __alloc_pages to prepare_alloc_pages so the code can be
> > shared between the single page allocator and a new bulk page allocator.
> > 
> > When moving, it is obvious that __alloc_pages() and __alloc_pages
> > use different names for the same variable. This is an unnecessary
> > complication so rename gfp_mask to gfp in prepare_alloc_pages() so the
> > name is consistent.
> > 
> > No functional change.
> 
> Hm, I have some doubts.
> 

And you were right, I'll drop the patch and apply the same mask to the
bulk allocator.

-- 
Mel Gorman
SUSE Labs
