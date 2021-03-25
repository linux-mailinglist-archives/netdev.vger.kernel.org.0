Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497DE3493A9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhCYOHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhCYOHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:07:02 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB7C06174A;
        Thu, 25 Mar 2021 07:07:02 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id o126so2772010lfa.0;
        Thu, 25 Mar 2021 07:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pdIHv4/PD3czenmhqB9tk+MCiZEZtlstx+3pXZSdYn4=;
        b=F12bWCPR2Sk/Xp80UpS74JjBunFCXBeGVh+ZXV3vONkt0eMBNYFrL/dpr5xerdl9EE
         i2fyMsvej+qJO5pLJx63a4npSLONUy84IQxRp+1zwrY1UBl5ucLfjWLUZt1ysf6PnQ0M
         saJ0XzaKxaeg+gAH/wC0vDOvC1b7wrOCGmURVTMW1ebZj/u0LkyOkF01zvXQLcIjyr95
         ZKtRuwmHtZ0+1LrWaAeEKPLCeCYjHqOdlc3PYGJuvlCqXSp+44+QhvaMe/nTA6dGtBUo
         5XmWXgb4z/0AEQJb212Rbj7z4OXIS1YXKZNOYdjmL/lEw3p8Ww3WIdTX2P+3MMrwh6H4
         mjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pdIHv4/PD3czenmhqB9tk+MCiZEZtlstx+3pXZSdYn4=;
        b=h6imK0qvdjPPzhR3XdfzbUVSaZkKGeRdZFCUlAOyAfB3MMVvbmeh4gUn/n2Pyt88gk
         9yxdyKrcqvMKNCDbhH8NB71ezqPaDoKFJcQZZKsjg2rAaYfCPMSoEleLyRriYWztQbEr
         koDLA3EnJQUoMjhPipCZsGjiK6OoUyYJtCX1B/HQS2yHo+GqL1QM7dgQAJWD1BfIoX0v
         s5/jq51Xi14p7cIKYty39sEHVNf6Xirnx2pQ71FxAGWSxvUxEEkUyn1Xe0SYYTgEkZHG
         k3dprFIzEyajfh7qSN/DYuq3nZQV3DMmQ76ZDcDaxAE4bCN/H0322Sx/185yVLMoPRjP
         eTGA==
X-Gm-Message-State: AOAM532GNtRzphAwI1wY6skBtCbzHyavvgM/4nHKkUHZ8OTORK5XQvY8
        oMLC3FoNBCUvCyqYqKuWNB0=
X-Google-Smtp-Source: ABdhPJxuXe7GPMoX2rzQ9o37NfAMuSKZftGbZ2nH6SMWR56QnP9ZM9G8QG3JrpaL5VlbnllG5eee/g==
X-Received: by 2002:a19:7d7:: with SMTP id 206mr5283288lfh.98.1616681220353;
        Thu, 25 Mar 2021 07:07:00 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id g5sm771424ljj.21.2021.03.25.07.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:06:59 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 25 Mar 2021 15:06:57 +0100
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <20210325140657.GA1908@pc638.lan>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325125001.GW1719932@casper.infradead.org>
 <20210325132556.GS3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325132556.GS3697@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Mar 25, 2021 at 12:50:01PM +0000, Matthew Wilcox wrote:
> > On Thu, Mar 25, 2021 at 11:42:19AM +0000, Mel Gorman wrote:
> > > This series introduces a bulk order-0 page allocator with sunrpc and
> > > the network page pool being the first users. The implementation is not
> > > efficient as semantics needed to be ironed out first. If no other semantic
> > > changes are needed, it can be made more efficient.  Despite that, this
> > > is a performance-related for users that require multiple pages for an
> > > operation without multiple round-trips to the page allocator. Quoting
> > > the last patch for the high-speed networking use-case
> > > 
> > >             Kernel          XDP stats       CPU     pps           Delta
> > >             Baseline        XDP-RX CPU      total   3,771,046       n/a
> > >             List            XDP-RX CPU      total   3,940,242    +4.49%
> > >             Array           XDP-RX CPU      total   4,249,224   +12.68%
> > > 
> > > >From the SUNRPC traces of svc_alloc_arg()
> > > 
> > > 	Single page: 25.007 us per call over 532,571 calls
> > > 	Bulk list:    6.258 us per call over 517,034 calls
> > > 	Bulk array:   4.590 us per call over 517,442 calls
> > > 
> > > Both potential users in this series are corner cases (NFS and high-speed
> > > networks) so it is unlikely that most users will see any benefit in the
> > > short term. Other potential other users are batch allocations for page
> > > cache readahead, fault around and SLUB allocations when high-order pages
> > > are unavailable. It's unknown how much benefit would be seen by converting
> > > multiple page allocation calls to a single batch or what difference it may
> > > make to headline performance.
> > 
> > We have a third user, vmalloc(), with a 16% perf improvement.  I know the
> > email says 21% but that includes the 5% improvement from switching to
> > kvmalloc() to allocate area->pages.
> > 
> > https://lore.kernel.org/linux-mm/20210323133948.GA10046@pc638.lan/
> > 
> 
> That's fairly promising. Assuming the bulk allocator gets merged, it would
> make sense to add vmalloc on top. That's for bringing it to my attention
> because it's far more relevant than my imaginary potential use cases.
> 
For the vmalloc we should be able to allocating on a specific NUMA node,
at least the current interface takes it into account. As far as i see
the current interface allocate on a current node:

static inline unsigned long
alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
{
    return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
}

Or am i missing something?

--
Vlad Rezki
