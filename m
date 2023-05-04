Return-Path: <netdev+bounces-296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 747DA6F6EF1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2BB1C21170
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F888F59;
	Thu,  4 May 2023 15:32:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48EEFC06
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:32:27 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73F81BE4;
	Thu,  4 May 2023 08:32:25 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f315712406so69127605e9.0;
        Thu, 04 May 2023 08:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683214344; x=1685806344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wnn3Z2r+lFHXKksIlWpTLs2B1eO1Er3x3c/HupLr4bc=;
        b=dwnpLfo50BT5hHNk9jnWE38ERO0DRbwYZm/URMIWA6G940My8VvPt4z2D13nRxCa9s
         4OK0d9RICRsztjKVALvBVbiwrgmiSSS3J7dkfJLX8LHaWY1c70EukIWfJR6jti/2VraM
         OYLup3Txmvf0NXrn6z6Hp+Q83mhcXQRPp5NWxBtYfUwDf+iQwNHdOly7CtYiA5qBmvIM
         nBstxCe//cbyChshUFLZ81DXivj5FyEDgcIrkbhc4USdhYJpzYw9Z0KeDAuhU02FjDQC
         EzDWdfyao/2M7ND+BGDgGSZv/Ct2MQ8FyQkO4DTsAspF7kR3tfXu7GHjNL+fUlpuiLsT
         B2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683214344; x=1685806344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wnn3Z2r+lFHXKksIlWpTLs2B1eO1Er3x3c/HupLr4bc=;
        b=ErI1QV8SsGClV2mxM8angL7kusZ8lAxCFJ+LE9i8VKrmLs4W55/5Fm/66GjZA85A5u
         wFxZOu5QKGtxZINi2Jul2B7x7oHFinLPwG5jP3v0Y8XztvZRkknTOXAN7OmIscAo+LQY
         4MD+KxUQ2ks6/kdaV8i480eFCelsJKsWr/JQJcewozaleoBXmOPwnlyGOsOVyyFVey2h
         SA+Ij4LcErwIyHFGkZzeP/BMk6qWwhLLhVHglnw369wq154G16CQ5rHrhrNftexaF4mx
         NGkZdUShwAZHcolBADVf36k4j5b8HrO6wGPcnCAlNp1dD6jQh3kA7QcsUHvkqfvyiXFV
         7+BQ==
X-Gm-Message-State: AC+VfDzeZTpYxwN8OHUT4QMAiPUwAeUskqNx+l67S3z+B4zPKzLtQYBp
	MjF0e3D71PcTj2ldHQpjRIk=
X-Google-Smtp-Source: ACHHUZ47xEIEY6txCFEU4tzKRxuuyjsv54AxD2UyOD7Cffq5V8k8HMVv+/KgOzTuV243U0l/LshP9Q==
X-Received: by 2002:a5d:6547:0:b0:2f6:1a6d:a6c3 with SMTP id z7-20020a5d6547000000b002f61a6da6c3mr2874471wrv.21.1683214344084;
        Thu, 04 May 2023 08:32:24 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id b5-20020a056000054500b002e5ff05765esm37615426wrf.73.2023.05.04.08.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 08:32:23 -0700 (PDT)
Date: Thu, 4 May 2023 16:32:22 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v8 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <f4746d6e-b0c4-421f-b21d-212619ca6803@lucifer.local>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
 <20230502191821.71c86a2c25f19fe342aa72db@linux-foundation.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502191821.71c86a2c25f19fe342aa72db@linux-foundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 07:18:21PM -0700, Andrew Morton wrote:
> On Tue,  2 May 2023 23:51:35 +0100 Lorenzo Stoakes <lstoakes@gmail.com> wrote:
>
> > Writing to file-backed dirty-tracked mappings via GUP is inherently broken
> > as we cannot rule out folios being cleaned and then a GUP user writing to
> > them again and possibly marking them dirty unexpectedly.
> >
> > This is especially egregious for long-term mappings (as indicated by the
> > use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
> > we have already done in the slow path.
> >
> > We have access to less information in the fast path as we cannot examine
> > the VMA containing the mapping, however we can determine whether the folio
> > is anonymous or belonging to a whitelisted filesystem - specifically
> > hugetlb and shmem mappings.
> >
> > We take special care to ensure that both the folio and mapping are safe to
> > access when performing these checks and document folio_fast_pin_allowed()
> > accordingly.
> >
> > It's important to note that there are no APIs allowing users to specify
> > FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
> > always rely on the fact that if we fail to pin on the fast path, the code
> > will fall back to the slow path which can perform the more thorough check.
>
> arm allnoconfig said
>
> mm/gup.c:115:13: warning: 'folio_fast_pin_allowed' defined but not used [-Wunused-function]
>   115 | static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
>
> so I moved the definition inside CONFIG_ARCH_HAS_PTE_SPECIAL.
>
>
>
>  mm/gup.c |  154 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 77 insertions(+), 77 deletions(-)
>
> --- a/mm/gup.c~mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix
> +++ a/mm/gup.c
> @@ -96,83 +96,6 @@ retry:
>  	return folio;
>  }
>
> -/*
> - * Used in the GUP-fast path to determine whether a pin is permitted for a
> - * specific folio.
> - *
> - * This call assumes the caller has pinned the folio, that the lowest page table
> - * level still points to this folio, and that interrupts have been disabled.
> - *
> - * Writing to pinned file-backed dirty tracked folios is inherently problematic
> - * (see comment describing the writable_file_mapping_allowed() function). We
> - * therefore try to avoid the most egregious case of a long-term mapping doing
> - * so.
> - *
> - * This function cannot be as thorough as that one as the VMA is not available
> - * in the fast path, so instead we whitelist known good cases and if in doubt,
> - * fall back to the slow path.
> - */
> -static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
> -{
> -	struct address_space *mapping;
> -	unsigned long mapping_flags;
> -
> -	/*
> -	 * If we aren't pinning then no problematic write can occur. A long term
> -	 * pin is the most egregious case so this is the one we disallow.
> -	 */
> -	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
> -	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> -		return true;
> -
> -	/* The folio is pinned, so we can safely access folio fields. */
> -
> -	/* Neither of these should be possible, but check to be sure. */
> -	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
> -		return false;
> -
> -	/* hugetlb mappings do not require dirty-tracking. */
> -	if (folio_test_hugetlb(folio))
> -		return true;
> -
> -	/*
> -	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
> -	 * cannot proceed, which means no actions performed under RCU can
> -	 * proceed either.
> -	 *
> -	 * inodes and thus their mappings are freed under RCU, which means the
> -	 * mapping cannot be freed beneath us and thus we can safely dereference
> -	 * it.
> -	 */
> -	lockdep_assert_irqs_disabled();
> -
> -	/*
> -	 * However, there may be operations which _alter_ the mapping, so ensure
> -	 * we read it once and only once.
> -	 */
> -	mapping = READ_ONCE(folio->mapping);
> -
> -	/*
> -	 * The mapping may have been truncated, in any case we cannot determine
> -	 * if this mapping is safe - fall back to slow path to determine how to
> -	 * proceed.
> -	 */
> -	if (!mapping)
> -		return false;
> -
> -	/* Anonymous folios are fine, other non-file backed cases are not. */
> -	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
> -	if (mapping_flags)
> -		return mapping_flags == PAGE_MAPPING_ANON;
> -
> -	/*
> -	 * At this point, we know the mapping is non-null and points to an
> -	 * address_space object. The only remaining whitelisted file system is
> -	 * shmem.
> -	 */
> -	return shmem_mapping(mapping);
> -}
> -
>  /**
>   * try_grab_folio() - Attempt to get or pin a folio.
>   * @page:  pointer to page to be grabbed
> @@ -2474,6 +2397,83 @@ static void __maybe_unused undo_dev_page
>
>  #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
>  /*
> + * Used in the GUP-fast path to determine whether a pin is permitted for a
> + * specific folio.
> + *
> + * This call assumes the caller has pinned the folio, that the lowest page table
> + * level still points to this folio, and that interrupts have been disabled.
> + *
> + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> + * (see comment describing the writable_file_mapping_allowed() function). We
> + * therefore try to avoid the most egregious case of a long-term mapping doing
> + * so.
> + *
> + * This function cannot be as thorough as that one as the VMA is not available
> + * in the fast path, so instead we whitelist known good cases and if in doubt,
> + * fall back to the slow path.
> + */
> +static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
> +{
> +	struct address_space *mapping;
> +	unsigned long mapping_flags;
> +
> +	/*
> +	 * If we aren't pinning then no problematic write can occur. A long term
> +	 * pin is the most egregious case so this is the one we disallow.
> +	 */
> +	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
> +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> +		return true;
> +
> +	/* The folio is pinned, so we can safely access folio fields. */
> +
> +	/* Neither of these should be possible, but check to be sure. */
> +	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
> +		return false;
> +
> +	/* hugetlb mappings do not require dirty-tracking. */
> +	if (folio_test_hugetlb(folio))
> +		return true;
> +
> +	/*
> +	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
> +	 * cannot proceed, which means no actions performed under RCU can
> +	 * proceed either.
> +	 *
> +	 * inodes and thus their mappings are freed under RCU, which means the
> +	 * mapping cannot be freed beneath us and thus we can safely dereference
> +	 * it.
> +	 */
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * However, there may be operations which _alter_ the mapping, so ensure
> +	 * we read it once and only once.
> +	 */
> +	mapping = READ_ONCE(folio->mapping);
> +
> +	/*
> +	 * The mapping may have been truncated, in any case we cannot determine
> +	 * if this mapping is safe - fall back to slow path to determine how to
> +	 * proceed.
> +	 */
> +	if (!mapping)
> +		return false;
> +
> +	/* Anonymous folios are fine, other non-file backed cases are not. */
> +	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
> +	if (mapping_flags)
> +		return mapping_flags == PAGE_MAPPING_ANON;
> +
> +	/*
> +	 * At this point, we know the mapping is non-null and points to an
> +	 * address_space object. The only remaining whitelisted file system is
> +	 * shmem.
> +	 */
> +	return shmem_mapping(mapping);
> +}
> +
> +/*
>   * Fast-gup relies on pte change detection to avoid concurrent pgtable
>   * operations.
>   *
> _
>

Ack thanks for this, I think it doesn't quite cover all cases (kernel bot
moaning on -next for mips), needs some more fiddly #ifdef stuff, I will
spin a v9 shortly anyway to fix this up and address a few other minor
things.

