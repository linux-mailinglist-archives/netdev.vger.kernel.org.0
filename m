Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570936F1D08
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346393AbjD1Q4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345276AbjD1Q4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:56:32 -0400
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3674D2105;
        Fri, 28 Apr 2023 09:56:31 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 2DD4F2B067C8;
        Fri, 28 Apr 2023 12:56:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 28 Apr 2023 12:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682700986; x=
        1682708186; bh=s7h15564+ZYYAViBl9dWz2ps3GNKFkd0Y8UCd24XhUo=; b=D
        vfwva+PpE2bkqM9nBbsEDMmcm+Ci/oC3+gLb+eoYPBK7VnOUX9/Kmy9k+wUZe1XW
        G3dcNldrmryO9QVCThFES79uJfO9C+bIpbYrZXaAYdkIM2PmfIE0Mf0mqQAa9lpw
        rZN2DjLXpP5PN7qI10sAHMTOI3EoqPyeU7S4ZbEXz2PSpkyE1NU3JDXPjjkQ8jbh
        jx+sJYt0PZsoFcmaWNWeLNJ0u/F/y6GBYzgsgyW1x3MjejhKuhud1t9nvJNY0V06
        qIOs9srS4F7Q+AZdC31fpiFPXoyaa0oELF2br+ZenbFfz9UE50sdHNguFuhggzOW
        X7EdbzakUawiLD0a1NefA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682700986; x=1682708186; bh=s7h15564+ZYYA
        ViBl9dWz2ps3GNKFkd0Y8UCd24XhUo=; b=OFPz5iuRb4UIme0+aYtT1+xphj4bH
        9dU1iad7/gmHmWNR9NXxQuLBaCtOBZpIeYnmYm+MiUiXoT3otJ9ksrfZIetJQWEs
        hDia1HDdBOCewAHn55PaJ6UTCgHCUonCb/eUt7p9cziRJnKoZJylGuiF8VNRSHbN
        DDkl7jd+oS6sSONWun3EzscX0BSISEvNwkTvQIajlQKi8ZBQWZL8pNfGEstnB362
        EXgbqaPV6VgjU/JonDgfZLh87CLOOT54JOxXerhJDFjUHfTR/PB7AkQf4u0Wer5N
        6X3OxhlzHxCy7iez7H2rPKNsGjXJ42TJHrK12+RBMpyTOciUkxh4TqmJg==
X-ME-Sender: <xms:uvpLZGsVcwl9ho0Y3pDg1GsMlKGOf_f7QGTn9rlXrkVjSQEeUQmIvg>
    <xme:uvpLZLdc2DtT-V1fbUTfFbdurwp94t1ir7EWN1ELnTbfZLRYapbG_3awUjv8RHO2J
    -J_NwLuV-WNErX35r8>
X-ME-Received: <xmr:uvpLZBw8gACrNLG5IGkf5QycivyLyEKtqyXgUl0blcVuJnw-1V4-UgOxzgJLMt-mv7Y_iQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedukedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhi
    rhhilhhlucetucdrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlsehshhhuthgvmhhovh
    drnhgrmhgvqeenucggtffrrghtthgvrhhnpefgtdevueegtefhffffkeelgfeklefgkeef
    tdehieelteeuhfekfeeluddvtdekveenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:uvpLZBMsTmP3xUIUTTprLhjiJNubviOsniuWF-OA73H4rz4HBh8d-w>
    <xmx:uvpLZG-aqdtB5WWXdt7kyYSH26KEKy-m0I4UrEOdkBor0Ia-LrgXIQ>
    <xmx:uvpLZJUXMQlOrYiXDRS7qpFKiu_2307NdJixlIrQ_9lu383IeUj7tQ>
    <xmx:uvpLZGNsYpdNsn6H2GR8ESkjFziv1dF6sGtZqMLHFU0jP5er23I1g0OTl9w>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Apr 2023 12:56:25 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 8DFEC1041AE; Fri, 28 Apr 2023 19:56:23 +0300 (+03)
Date:   Fri, 28 Apr 2023 19:56:23 +0300
From:   "Kirill A . Shutemov" <kirill@shutemov.name>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <lstoakes@gmail.com>,
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
Message-ID: <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
References: <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 06:51:46PM +0200, David Hildenbrand wrote:
> On 28.04.23 18:39, Peter Xu wrote:
> > On Fri, Apr 28, 2023 at 07:22:07PM +0300, Kirill A . Shutemov wrote:
> > > On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
> > > > On 28.04.23 18:09, Kirill A . Shutemov wrote:
> > > > > On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
> > > > > > On 28.04.23 17:34, David Hildenbrand wrote:
> > > > > > > On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > > > > > > > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > > > > > > > 
> > > > > > > > > > > Security is the primary case where we have historically closed uAPI
> > > > > > > > > > > items.
> > > > > > > > > > 
> > > > > > > > > > As this patch
> > > > > > > > > > 
> > > > > > > > > > 1) Does not tackle GUP-fast
> > > > > > > > > > 2) Does not take care of !FOLL_LONGTERM
> > > > > > > > > > 
> > > > > > > > > > I am not convinced by the security argument in regard to this patch.
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > If we want to sells this as a security thing, we have to block it
> > > > > > > > > > *completely* and then CC stable.
> > > > > > > > > 
> > > > > > > > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > > > > > > > something similar as I did in gup_must_unshare():
> > > > > > > > > 
> > > > > > > > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > > > > > > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > > > > > > > 
> > > > > > > > How do we determine it's non-anon in the first place? The check is on the
> > > > > > > > VMA. We could do it by following page tables down to folio and checking
> > > > > > > > folio->mapping for PAGE_MAPPING_ANON I suppose?
> > > > > > > 
> > > > > > > PageAnon(page) can be called from GUP-fast after grabbing a reference.
> > > > > > > See gup_must_unshare().
> > > > > > 
> > > > > > IIRC, PageHuge() can also be called from GUP-fast and could special-case
> > > > > > hugetlb eventually, as it's table while we hold a (temporary) reference.
> > > > > > Shmem might be not so easy ...
> > > > > 
> > > > > page->mapping->a_ops should be enough to whitelist whatever fs you want.
> > > > > 
> > > > 
> > > > The issue is how to stabilize that from GUP-fast, such that we can safely
> > > > dereference the mapping. Any idea?
> > > > 
> > > > At least for anon page I know that page->mapping only gets cleared when
> > > > freeing the page, and we don't dereference the mapping but only check a
> > > > single flag stored alongside the mapping. Therefore, PageAnon() is fine in
> > > > GUP-fast context.
> > > 
> > > What codepath you are worry about that clears ->mapping on pages with
> > > non-zero refcount?
> > > 
> > > I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
> > > and fail GUP_fast if it is NULL should be fine, no?
> > > 
> > > I guess we should consider if the inode can be freed from under us and the
> > > mapping pointer becomes dangling. But I think we should be fine here too:
> > > VMA pins inode and VMA cannot go away from under GUP.
> > 
> > Can vma still go away if during a fast-gup?
> > 
> 
> So, after we grabbed the page and made sure the the PTE didn't change (IOW,
> the PTE was stable while we processed it), the page can get unmapped (but
> not freed, because we hold a reference) and the VMA can theoretically go
> away (and as far as I understand, nothing stops the file from getting
> deleted, truncated etc).
> 
> So we might be looking at folio->mapping and the VMA is no longer there.
> Maybe even the file is no longer there.

No. VMA cannot get away before PTEs are unmapped and TLB is flushed. And
TLB flushing is serialized against GUP_fast().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
