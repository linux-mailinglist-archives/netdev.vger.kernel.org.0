Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734AC349476
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhCYOqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhCYOqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:46:16 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B342CC06174A;
        Thu, 25 Mar 2021 07:46:15 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id z25so3479640lja.3;
        Thu, 25 Mar 2021 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KQn8joM4dx8C2nV3wXqG+iYWawmBEWT7hNod0GQKY08=;
        b=jTvDWbsLqfxR/OxWUFs6i9J4uo7Axz4h12Jn36EVK5uw1MACgQIYRBiFeuOuH5hKtB
         LbkXfWCPR8UsQcyTDzUS32+eNk5FxpxnvZkMgr9HmQBugfKWGgCZ9ovPb4VeMMfe1SyV
         x7uMxsNMYuQigOQYd7Jkjz95Yztplal3wcVKgUMjveikm5PODzQrRNnlmY7u3L+Z9SFr
         cDsa8919WDFH5VweGKAJsbz8LWpf7u5PIFpGYSo0x2a/bAN8h1gPmWsWfPWUuNYJEoJD
         51Vr21sq6AtT1IvUVpgnuDq2dZPNHw8v0jCirnReGVKZrx/CFERfyJ26XNJPD2KNSzuM
         Lh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KQn8joM4dx8C2nV3wXqG+iYWawmBEWT7hNod0GQKY08=;
        b=EgWbq6zWbyiR+yGhpmV8nnMl7EKC27AD5bM9c4AqpDmEZuTWfbujR7uYyezkR8FGzW
         KGYO5JFVhlbMLaVSA8TksVBo88jjW1F96c1fZqFvBtijZ/0PgRWOQF+Y93ZXGu3azF7v
         /ThPvi/ZogFpkz3UgbT5nVYRT201Gz4VeAyek3HQcqSH5y4OWisLhSXiH+AFkIGR/Zzg
         E0ELe3U0ltYt2wPwyr8p+40ymS+GBxFKehZ5t+i/GtEHFExeG6yk4Tizjyj9YlmrQ9vm
         1QfUDcIyytXd4DYYzOKPNHbOHQaEJR++eVqT24Pm13+ldprBodhrPPspWW15o5GFEH55
         ISSA==
X-Gm-Message-State: AOAM533ZBu4AgBPOOD4h84aPoNNAsivpAvCuYgxUJr8bQRu633dNd9r3
        rcR1qte1FNTDtmOeIR3G9lM=
X-Google-Smtp-Source: ABdhPJxdAQwj7mnJs84MaeDX4KjrKYL/jnVtsFig4m1jqFTktNje2bHBAz4lthjvLJso7xCo7LbPRw==
X-Received: by 2002:a05:651c:2108:: with SMTP id a8mr5866974ljq.329.1616683574122;
        Thu, 25 Mar 2021 07:46:14 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id 197sm779868ljf.70.2021.03.25.07.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:46:13 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 25 Mar 2021 15:46:11 +0100
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/9 v6] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210325144611.GA2582@pc638.lan>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325125001.GW1719932@casper.infradead.org>
 <20210325132556.GS3697@techsingularity.net>
 <20210325140657.GA1908@pc638.lan>
 <20210325142624.GT3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325142624.GT3697@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 02:26:24PM +0000, Mel Gorman wrote:
> On Thu, Mar 25, 2021 at 03:06:57PM +0100, Uladzislau Rezki wrote:
> > > On Thu, Mar 25, 2021 at 12:50:01PM +0000, Matthew Wilcox wrote:
> > > > On Thu, Mar 25, 2021 at 11:42:19AM +0000, Mel Gorman wrote:
> > > > > This series introduces a bulk order-0 page allocator with sunrpc and
> > > > > the network page pool being the first users. The implementation is not
> > > > > efficient as semantics needed to be ironed out first. If no other semantic
> > > > > changes are needed, it can be made more efficient.  Despite that, this
> > > > > is a performance-related for users that require multiple pages for an
> > > > > operation without multiple round-trips to the page allocator. Quoting
> > > > > the last patch for the high-speed networking use-case
> > > > > 
> > > > >             Kernel          XDP stats       CPU     pps           Delta
> > > > >             Baseline        XDP-RX CPU      total   3,771,046       n/a
> > > > >             List            XDP-RX CPU      total   3,940,242    +4.49%
> > > > >             Array           XDP-RX CPU      total   4,249,224   +12.68%
> > > > > 
> > > > > >From the SUNRPC traces of svc_alloc_arg()
> > > > > 
> > > > > 	Single page: 25.007 us per call over 532,571 calls
> > > > > 	Bulk list:    6.258 us per call over 517,034 calls
> > > > > 	Bulk array:   4.590 us per call over 517,442 calls
> > > > > 
> > > > > Both potential users in this series are corner cases (NFS and high-speed
> > > > > networks) so it is unlikely that most users will see any benefit in the
> > > > > short term. Other potential other users are batch allocations for page
> > > > > cache readahead, fault around and SLUB allocations when high-order pages
> > > > > are unavailable. It's unknown how much benefit would be seen by converting
> > > > > multiple page allocation calls to a single batch or what difference it may
> > > > > make to headline performance.
> > > > 
> > > > We have a third user, vmalloc(), with a 16% perf improvement.  I know the
> > > > email says 21% but that includes the 5% improvement from switching to
> > > > kvmalloc() to allocate area->pages.
> > > > 
> > > > https://lore.kernel.org/linux-mm/20210323133948.GA10046@pc638.lan/
> > > > 
> > > 
> > > That's fairly promising. Assuming the bulk allocator gets merged, it would
> > > make sense to add vmalloc on top. That's for bringing it to my attention
> > > because it's far more relevant than my imaginary potential use cases.
> > > 
> > For the vmalloc we should be able to allocating on a specific NUMA node,
> > at least the current interface takes it into account. As far as i see
> > the current interface allocate on a current node:
> > 
> > static inline unsigned long
> > alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
> > {
> >     return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
> > }
> > 
> > Or am i missing something?
> > 
> 
> No, you're not missing anything. Options would be to add a helper similar
> alloc_pages_node or to directly call __alloc_pages_bulk specifying a node
> and using GFP_THISNODE. prepare_alloc_pages() should pick the correct
> zonelist containing only the required node.
> 
IMHO, a helper something like *_node() would be reasonable. I see that many
functions in "mm" have its own variants which explicitly add "_node()" prefix
to signal to users that it is a NUMA aware calls.

As for __alloc_pages_bulk(), i got it.

Thanks!

--
Vlad Rezki
