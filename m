Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA435C34E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbhDLKDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:03:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:58094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244976AbhDLKCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 06:02:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72338AF1A;
        Mon, 12 Apr 2021 10:01:53 +0000 (UTC)
Subject: Re: [PATCH 1/9] mm/page_alloc: Rename alloced to allocated
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-2-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <e820c36f-dc05-08be-611e-f37123f14b1a@suse.cz>
Date:   Mon, 12 Apr 2021 12:01:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325114228.27719-2-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 12:42 PM, Mel Gorman wrote:
> Review feedback of the bulk allocator twice found problems with "alloced"
> being a counter for pages allocated. The naming was based on the API name
> "alloc" and was based on the idea that verbal communication about malloc
> tends to use the fake word "malloced" instead of the fake word mallocated.
> To be consistent, this preparation patch renames alloced to allocated
> in rmqueue_bulk so the bulk allocator and per-cpu allocator use similar
> names when the bulk allocator is introduced.
> 
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dfa9af064f74..8a3e13277e22 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2908,7 +2908,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>  			unsigned long count, struct list_head *list,
>  			int migratetype, unsigned int alloc_flags)
>  {
> -	int i, alloced = 0;
> +	int i, allocated = 0;
>  
>  	spin_lock(&zone->lock);
>  	for (i = 0; i < count; ++i) {
> @@ -2931,7 +2931,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>  		 * pages are ordered properly.
>  		 */
>  		list_add_tail(&page->lru, list);
> -		alloced++;
> +		allocated++;
>  		if (is_migrate_cma(get_pcppage_migratetype(page)))
>  			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
>  					      -(1 << order));
> @@ -2940,12 +2940,12 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>  	/*
>  	 * i pages were removed from the buddy list even if some leak due
>  	 * to check_pcp_refill failing so adjust NR_FREE_PAGES based
> -	 * on i. Do not confuse with 'alloced' which is the number of
> +	 * on i. Do not confuse with 'allocated' which is the number of
>  	 * pages added to the pcp list.
>  	 */
>  	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
>  	spin_unlock(&zone->lock);
> -	return alloced;
> +	return allocated;
>  }
>  
>  #ifdef CONFIG_NUMA
> 

