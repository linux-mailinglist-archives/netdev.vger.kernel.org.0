Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BC06F1C84
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346153AbjD1QWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjD1QWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:22:16 -0400
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3BD212B;
        Fri, 28 Apr 2023 09:22:15 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 2F0942B067C8;
        Fri, 28 Apr 2023 12:22:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 28 Apr 2023 12:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682698930; x=
        1682706130; bh=tc/c0D7U8ETwsNDMrZwM89VUkG6eKTLveO1shy7R8WQ=; b=F
        aVdXUXs7BHEshWDR1t9DmVdcz/a7pXjtXkZcmxd1hjIShFpLYxzLgVLG686+73Qc
        of4PFdV3je6LwtOAkGO/DH5/aykBZPfdEhkPQyIbJrjefzpfbGz7+mqisWeqGInt
        VuXv0cOAyYEsTwzcAmLr3g5K3xSRxE44WibLW0OGFmdddNDY/MH6AXDiMFvcwybp
        PxiKDvDN/GE391o5fHY/4PuDpQexHpH6rqA5/MbNR8i2C1CXq4X14evJP0s+3+A9
        HOVb4HuOLjoYL3Q1IQcw40wv5MAwQ57zWL1ZohtuWMhuZvF6lvcvzUizWsONdMR3
        J17lik8t5icGEyq75tfQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682698930; x=1682706130; bh=tc/c0D7U8ETws
        NDMrZwM89VUkG6eKTLveO1shy7R8WQ=; b=IpTYPQtf6dKxJYY3dT5aWcPMxcIu7
        ke5tWK+NX06E0AtCsk9VIvHMOhC+bDf8Qh9oBl9X7cV3/Yp9wr/SjQpBp/5fe+j/
        iMi57vaAex13P+UMRLDz9su3xcRW++35J26cZut7MZz150tkgG4zVvYOXN3fYzjb
        2HBdwq6aoS4QJDOAVG5MxdJW1VthtPQVFQDzsX6WVC8bF9tdYNbi90Mt1VCzhFbH
        1kYC/PlnThsXUC/buP3VJ/nM9n9eCMv649W5JuuAR8uq4aJ0qO2E9/fr7NcfHLHn
        hgmeswbf4K0ArIj1hsZ3KElrZidZBLRR6X2JElCGP5CWEQ+alZFoiFDzA==
X-ME-Sender: <xms:sfJLZOb9fw4m45lVfCrI5yRA2q4RtVb3jqGw-0KRR__6EVrRDOwMSg>
    <xme:sfJLZBbbmfbG8QRFLjKo2C_nq0ZnYekBAE9Ma7pebGZBGxJr4_vT4rIbNSg0wLOCx
    D-c3KVqSM34iYk4a4I>
X-ME-Received: <xmr:sfJLZI9kAD7zqnXweiEGGcfpxAf0r6nFeJooP7hy89wKKBCyJDAExJZ12_MOhnu68Cvv-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedukedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhi
    rhhilhhlucetucdrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlsehshhhuthgvmhhovh
    drnhgrmhgvqeenucggtffrrghtthgvrhhnpeeufefhveefffeiveekgeffhfejhfeiheei
    ieefgffhveeggfeuvdehvdevudevudenucffohhmrghinhepghhuphdrhhhmnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:sfJLZAq3OrvcGOBtHIlBmHG63fl3BAZG4L58HDxrL1OZ7-JrtyVIfw>
    <xmx:sfJLZJqv7h1_CpWLfAN3tKoyzB62PbRw9aZpL3vtjxDp1fh8a2-f6Q>
    <xmx:sfJLZOS8Qx_FL0NaVuvs-kpBvLoYoc6Iq5VVy6cQPRVe6W7wHLlfRQ>
    <xmx:svJLZMHDrhWXJPioXCYEqZ9t2Z9TtZwIe4rhYdx2KgJl9W-9EZZPORpYF64>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Apr 2023 12:22:08 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 28C2E1041AE; Fri, 28 Apr 2023 19:22:07 +0300 (+03)
Date:   Fri, 28 Apr 2023 19:22:07 +0300
From:   "Kirill A . Shutemov" <kirill@shutemov.name>
To:     David Hildenbrand <david@redhat.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
> On 28.04.23 18:09, Kirill A . Shutemov wrote:
> > On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
> > > On 28.04.23 17:34, David Hildenbrand wrote:
> > > > On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > > > > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > > > > 
> > > > > > > > Security is the primary case where we have historically closed uAPI
> > > > > > > > items.
> > > > > > > 
> > > > > > > As this patch
> > > > > > > 
> > > > > > > 1) Does not tackle GUP-fast
> > > > > > > 2) Does not take care of !FOLL_LONGTERM
> > > > > > > 
> > > > > > > I am not convinced by the security argument in regard to this patch.
> > > > > > > 
> > > > > > > 
> > > > > > > If we want to sells this as a security thing, we have to block it
> > > > > > > *completely* and then CC stable.
> > > > > > 
> > > > > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > > > > something similar as I did in gup_must_unshare():
> > > > > > 
> > > > > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > > > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > > > > 
> > > > > How do we determine it's non-anon in the first place? The check is on the
> > > > > VMA. We could do it by following page tables down to folio and checking
> > > > > folio->mapping for PAGE_MAPPING_ANON I suppose?
> > > > 
> > > > PageAnon(page) can be called from GUP-fast after grabbing a reference.
> > > > See gup_must_unshare().
> > > 
> > > IIRC, PageHuge() can also be called from GUP-fast and could special-case
> > > hugetlb eventually, as it's table while we hold a (temporary) reference.
> > > Shmem might be not so easy ...
> > 
> > page->mapping->a_ops should be enough to whitelist whatever fs you want.
> > 
> 
> The issue is how to stabilize that from GUP-fast, such that we can safely
> dereference the mapping. Any idea?
> 
> At least for anon page I know that page->mapping only gets cleared when
> freeing the page, and we don't dereference the mapping but only check a
> single flag stored alongside the mapping. Therefore, PageAnon() is fine in
> GUP-fast context.

What codepath you are worry about that clears ->mapping on pages with
non-zero refcount?

I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
and fail GUP_fast if it is NULL should be fine, no?

I guess we should consider if the inode can be freed from under us and the
mapping pointer becomes dangling. But I think we should be fine here too:
VMA pins inode and VMA cannot go away from under GUP.

Hm?

(I didn't look close at GUP for a while and my reasoning might be off.)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
