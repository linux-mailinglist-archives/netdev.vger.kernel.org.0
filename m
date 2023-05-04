Return-Path: <netdev+bounces-303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5853F6F6F61
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A35A0280D7F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B015A935;
	Thu,  4 May 2023 15:48:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6F3FC1E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:48:27 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4778949D4;
	Thu,  4 May 2023 08:48:24 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f315735514so69122235e9.1;
        Thu, 04 May 2023 08:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683215303; x=1685807303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mO/FCTJ0lgmDzfuu+m/nGF6TmLm95y7sMUjn9Rtpsbc=;
        b=IW8KU+aybAdA7IkSMNM+90mqkc3W0LlV/6WZVdi1Ij9oLCE08FNtokKMDzc1ncrLAL
         e9v6oMPVkwsk8ZnkBjP7KJeoH2xnx5GD+ac0+az7WEG38+OUdHn6LSzwQhrc31gZTbPW
         7424WGNFQyfLBkeGK87MdYzTQ8RUrcD70Mz/b97RvPRNISjLmbwmFQOLhZ0m6mDLiI9w
         nDnwbRiTsPG/oMYSH9mh5rd8jCuf0e8GOYVb0OnMmi6iTm11fzASWgtnIc6jrhLqt1CW
         2UpOnOdmDGViLDf8ZuvcbESF1+Y1+rRDV3VUABszQg1EGn6DX/IkpSdrv91deyonsNrU
         zRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683215303; x=1685807303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mO/FCTJ0lgmDzfuu+m/nGF6TmLm95y7sMUjn9Rtpsbc=;
        b=j/qSv+UrVM+1JM6eFoo++/TOtNPiZxqKXHen0isxYuq3ELlSbioZrTPBRY7EfkSthu
         aaR01bmypPj+rZsgPfmRLz5J7Ab82vRho6dJHrUe+wQmfV6pLTx0B47iNKiRdXztP5me
         yKbvkc/dZ/XjCqQ3K2p1k8sfS0lxyLeoq5ql5w3WTfF4gwLvrKF8vfvkg1Ac3XbIsqni
         9iMvFRxhIhbU652FmssaDK+1SNa8i0ZLJ+7GdQm6ABWiPr3HPDugp9kTz8aK70do7maf
         /NgU4sqdDB8ePrSIWG/ui9Egx7FSWIVmj6YJ3TM0s2cqod4mbsbSMonKiAvQSFaCy+mD
         6A9A==
X-Gm-Message-State: AC+VfDy85kBnyL331y5xWjwn0O6rbbUP1axgcH2ukMI7f4+RFxRwI0gc
	pRUaunnLoQn3Nq2r/wct74w=
X-Google-Smtp-Source: ACHHUZ4m5McqqZbS0V5UHgSHzKGW68QxLmqj/OvdzG6ZThD/G2NiJTODGR0yI1G9zuovilw4t9rlww==
X-Received: by 2002:a5d:63cd:0:b0:306:31cb:25fb with SMTP id c13-20020a5d63cd000000b0030631cb25fbmr2559900wrw.17.1683215302436;
        Thu, 04 May 2023 08:48:22 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id i17-20020a5d6311000000b00306ec04f060sm2162821wru.107.2023.05.04.08.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 08:48:21 -0700 (PDT)
Date: Thu, 4 May 2023 16:48:20 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v8 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <c2a6311c-7fdc-4d12-9a3f-d2eed954c468@lucifer.local>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
 <e4c92510-9756-d9a1-0055-4cd64a0c76d9@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4c92510-9756-d9a1-0055-4cd64a0c76d9@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 05:04:34PM +0200, David Hildenbrand wrote:
> [...]
>
> > +static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
> > +{
> > +	struct address_space *mapping;
> > +	unsigned long mapping_flags;
> > +
> > +	/*
> > +	 * If we aren't pinning then no problematic write can occur. A long term
> > +	 * pin is the most egregious case so this is the one we disallow.
> > +	 */
> > +	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
> > +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> > +		return true;
> > +
> > +	/* The folio is pinned, so we can safely access folio fields. */
> > +
> > +	/* Neither of these should be possible, but check to be sure. */
>
> You can easily have anon pages that are at the swapcache at this point
> (especially, because this function is called before our unsharing checks),
> the comment is misleading.

Ack will update.

>
> And there is nothing wrong about pinning an anon page that's still in the
> swapcache. The following folio_test_anon() check will allow them.
>
> The check made sense in page_mapping(), but here it's not required.

Waaaaaaaaaait a second, you were saying before:-

  "Folios in the swap cache return the swap mapping" -- you might disallow
  pinning anonymous pages that are in the swap cache.

  I recall that there are corner cases where we can end up with an anon
  page that's mapped writable but still in the swap cache ... so you'd
  fallback to the GUP slow path (acceptable for these corner cases, I
  guess), however especially the comment is a bit misleading then.

So are we allowing or disallowing pinning anon swap cache pages? :P

I mean slow path would allow them if they are just marked anon so I'm inclined
to allow them.

>
> I do agree regarding folio_test_slab(), though. Should we WARN in case we
> would have one?
>
> if (WARN_ON_ONCE(folio_test_slab(folio)))
> 	return false;
>

God help us if we have a slab page at this point, so agreed worth doing, it
would surely have to arise from some dreadful bug/memory corruption.

> > +	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
> > +		return false;
> > +
> > +	/* hugetlb mappings do not require dirty-tracking. */
> > +	if (folio_test_hugetlb(folio))
> > +		return true;
> > +
> > +	/*
> > +	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
> > +	 * cannot proceed, which means no actions performed under RCU can
> > +	 * proceed either.
> > +	 *
> > +	 * inodes and thus their mappings are freed under RCU, which means the
> > +	 * mapping cannot be freed beneath us and thus we can safely dereference
> > +	 * it.
> > +	 */
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	/*
> > +	 * However, there may be operations which _alter_ the mapping, so ensure
> > +	 * we read it once and only once.
> > +	 */
> > +	mapping = READ_ONCE(folio->mapping);
> > +
> > +	/*
> > +	 * The mapping may have been truncated, in any case we cannot determine
> > +	 * if this mapping is safe - fall back to slow path to determine how to
> > +	 * proceed.
> > +	 */
> > +	if (!mapping)
> > +		return false;
> > +
> > +	/* Anonymous folios are fine, other non-file backed cases are not. */
> > +	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
> > +	if (mapping_flags)
> > +		return mapping_flags == PAGE_MAPPING_ANON;
>
> KSM pages are also (shared) anonymous folios, and that check would fail --
> which is ok (the following unsharing checks rejects long-term pinning them),
> but a bit inconstent with your comment and folio_test_anon().
>
> It would be more consistent (with your comment and also the folio_test_anon
> implementation) to have here:
>
> 	return mapping_flags & PAGE_MAPPING_ANON;
>

I explicitly excluded KSM out of fear that could be some breakage given they're
wrprotect'd + expected to CoW though? But I guess you mean they'd get picked up
by the unshare and so it doesn't matter + we wouldn't want to exclude an
PG_anon_exclusive case?

I'll make the change in any case given the unshare check!

I notice the gup_huge_pgd() doesn't do an unshare but I mean, a PGD-sized huge
page probably isn't going to be CoW'd :P


> > +
> > +	/*
> > +	 * At this point, we know the mapping is non-null and points to an
> > +	 * address_space object. The only remaining whitelisted file system is
> > +	 * shmem.
> > +	 */
> > +	return shmem_mapping(mapping);
> > +}
> > +
>
> In general, LGTM
>
> Acked-by: David Hildenbrand <david@redhat.com>
>

Thanks!

Will respin, addressing your comments and addressing the issue the kernel
bot picked up with placement in the appropriate #ifdef's and send out a v9
shortly.


> --
> Thanks,
>
> David / dhildenb
>

