Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9646ECF62
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjDXNlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjDXNkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:40:52 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D686902E;
        Mon, 24 Apr 2023 06:40:33 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A7675C0109;
        Mon, 24 Apr 2023 09:40:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Apr 2023 09:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682343631; x=
        1682430031; bh=Ae/BNl3LeeeGteor4m6cLa4HqXB1SG9Nq2ztdS5OqH8=; b=Z
        IEUFOnDXaFpaAbVZW/zEe8y7Z/TuozWTuA3mFbj46/Ot5wmR6YkgHbgZG56Qe3Ja
        91zRF2Y9tzrsHu48HVkhD0ofMy4iuFHuNGFNpHddSyHSz7SzEbKj5QsxdAC/qB+A
        T5vwPSPeLnuhBSbM5ZeXZfcgxO0UW1HiROj+8rwdh2T3gb4CTr1714mKBZoA/RlQ
        5uLbkxe8wYOABGzZofN1kQ4vHVum2IiwDhFe64bjDk89dsaSdGVW3M+gysx/y/aj
        /yAV85ZruGyscTM6RRz9v5IUAIh37rFUJBBSCzBFOoErcMYcjobfwKZVLPcs6IDh
        oe1uQRj3DLmJOXEc2L89w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682343631; x=1682430031; bh=Ae/BNl3LeeeGt
        eor4m6cLa4HqXB1SG9Nq2ztdS5OqH8=; b=gOOdk0uBtKcnNXlTtdMxOXqPxiRJo
        TprOv1B+Vjm071ggSgIPpTomPFhjjWCJ3b95faKZ0ZzQQT7NqWPhWwRBm2trenyd
        slmophLu7fzj2SYyI9b6X/MgKe8lpSBfoAjthMIqa4XewrP6squLQJD2NcNhpgGr
        ceMq9mz6YyLe+sPiJAMlEa0kUmhrAhNrii0+MYEQQfyKWtH4FyIzfeWeCQegdPnh
        CatvVjKKk707PQGAXqIqOlex23j4OnzwbrMzgjDDU+vK6on1/ZbY8LwW8J6UtJmG
        g7Xl3Yb2BHPt6sAEOqtTMT0q7fOglrViLtupF14NahGJILW2V12WoruFA==
X-ME-Sender: <xms:zoZGZMJWEHh-xWSXHgqgWJR8qSmtAqGxIW1pA66PxTh1RamsCD62Fw>
    <xme:zoZGZMJYtUscyz1-oYVGniu6HFZbM9X_wyhmY40ipdYl7nt3C89Xee0Lx5M4Ws8kT
    tWKlkWsTfFOMaVNaLM>
X-ME-Received: <xmr:zoZGZMtuLTBIcVPNeJbbHcmH22HpqB_QNeAz-JgAVJ9vEfQDRDQJaIYP2J0rK92L-SvXDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedutddgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepfdfmihhr
    ihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlsehshhhuthgvmhhovhdrnh
    grmhgvqeenucggtffrrghtthgvrhhnpefhieeghfdtfeehtdeftdehgfehuddtvdeuheet
    tddtheejueekjeegueeivdektdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:zoZGZJb66cZrEaOcrtCgEniVhsaTFRGXGMw7YoiKtOruJ1s28m-FZw>
    <xmx:zoZGZDY6TjvTwCGtb2BC7PwTQL8fRgq7rSJeM8-d1lZ6wkWlREMVbw>
    <xmx:zoZGZFDpSYfJ2B1m-OTha04bM7EYrEQ7v0BmbiFyRjoJaWZufIRVpQ>
    <xmx:z4ZGZJsXMJX1gE76TFCnD77NSSxjjS78xpvd3XUZxV6wS3DHMDmctw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Apr 2023 09:40:29 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id E05E310A0FA; Mon, 24 Apr 2023 16:40:26 +0300 (+03)
Date:   Mon, 24 Apr 2023 16:40:26 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <20230424134026.di6nf2an3a2g63a6@box.shutemov.name>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <20230424120247.k7cjmncmov32yv5r@box.shutemov.name>
 <3273f5f3-65d9-4366-9424-c688264992f9@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3273f5f3-65d9-4366-9424-c688264992f9@lucifer.local>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 01:31:56PM +0100, Lorenzo Stoakes wrote:
> On Mon, Apr 24, 2023 at 03:02:47PM +0300, Kirill A. Shutemov wrote:
> > On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> > > @@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
> > >  	return 0;
> > >  }
> > >
> > > +/*
> > > + * Writing to file-backed mappings using GUP is a fundamentally broken operation
> > > + * as kernel write access to GUP mappings may not adhere to the semantics
> > > + * expected by a file system.
> > > + *
> > > + * In most instances we disallow this broken behaviour, however there are some
> > > + * exceptions to this enforced here.
> > > + */
> > > +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> > > +					  unsigned long gup_flags)
> > > +{
> > > +	struct file *file = vma->vm_file;
> > > +
> > > +	/* If we aren't pinning then no problematic write can occur. */
> > > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > > +		return true;
> > > +
> > > +	/* Special mappings should pose no problem. */
> > > +	if (!file)
> > > +		return true;
> > > +
> > > +	/* Has the caller explicitly indicated this case is acceptable? */
> > > +	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
> > > +		return true;
> > > +
> > > +	/* shmem and hugetlb mappings do not have problematic semantics. */
> > > +	return vma_is_shmem(vma) || is_file_hugepages(file);
> >
> > Can this be generalized to any fs that doesn't have vm_ops->page_mkwrite()?
> >
> 
> Something more general would be preferable, however I believe there were
> concerns broader than write notify, for instance not correctly marking the
> folio dirty after writing to it, though arguably the caller should
> certainly be ensuring that (and in many cases, do).

It doesn't make much sense to me.

Shared writable mapping without page_mkwrite (or pfn_write) will setup
writeable PTE even on read faults[1], so you will not get the page dirty,
unless you scan page table entries for dirty bit.

[1] See logic around vm_page_prot vs. vma_wants_writenotify().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
