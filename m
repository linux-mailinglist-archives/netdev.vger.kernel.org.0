Return-Path: <netdev+bounces-288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECB76F6E91
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A2A1C21155
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10A779DF;
	Thu,  4 May 2023 15:04:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EFD79D8
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:04:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD08E73
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683212680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKpeHZVSxx8CJs7gUO4c0bM4YS+xQ3y47FDdrxUz/84=;
	b=L/bRfY/sbJ6YBeBTI0+WDtbXv64p4oWv1Le1GJ4IP4fGxF5gbirvOiUSray5KPJ1Z7GjLh
	dso3Ej5bQv1816p4IjBTnmLAYw3uIkROx+EJ5TMKzFM77X1bphe5OFnkh3RlpvCdub0Jx3
	zzCAOUeVzhKs6jIh/rR13titLJxbhDk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-YFDdEXHuNAOl_mdUgUfGug-1; Thu, 04 May 2023 11:04:39 -0400
X-MC-Unique: YFDdEXHuNAOl_mdUgUfGug-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-306489b7585so228328f8f.3
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 08:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683212678; x=1685804678;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qKpeHZVSxx8CJs7gUO4c0bM4YS+xQ3y47FDdrxUz/84=;
        b=WK91u/JNAdebvzFXYSLhmMXGMw9irXHYNUnYWRghkFTQHsP76StSP6naUo9KJmsILd
         WzA5Ebw3K5pf7L3/tFwAAY/6loiJyTLIhR26Ovrnv4PHNUy3ddqv/aPTLI1y4AoXrrjQ
         3tCGLPtMe+TRUTktyNp4DUk0hKWeXagrigNZLILoxmoTECrnQfmm7vp1g2MhTljC5Kis
         2Z94exLUXTCzTv6KFAz1jNhbZEMBbtSBQscFH7B6aEOrmBC9fcUF6GJbWZiBuIEwI3Id
         e3/7foaegp4nuXpoCagcn0cuOh1/JuI7pH/Ou7gSRGDyZNOVqADZCFtRR6ZwPPH5cMGD
         la1w==
X-Gm-Message-State: AC+VfDzc09quKnWDExj5wuqCpYbBxAHiFDgbSWOpAeQrA5lHgDdnkpTd
	MiPGgjjVQaNXHLyt3tSQK9NFvokelUKQbovF5+AXgm9SXA4QDOfFd1BAzwqxQVf+32Y5DhLToVG
	Nm66TqZKF2ldzyZz9
X-Received: by 2002:adf:fe0f:0:b0:2f8:e190:e719 with SMTP id n15-20020adffe0f000000b002f8e190e719mr3103312wrr.65.1683212677669;
        Thu, 04 May 2023 08:04:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6rxT0rJtp8bOBHaHErNHhzE0fosUbvHA3tSGtLLdRYz110diw12mrtbe5YpgvE/16tzPAhoQ==
X-Received: by 2002:adf:fe0f:0:b0:2f8:e190:e719 with SMTP id n15-20020adffe0f000000b002f8e190e719mr3103257wrr.65.1683212676920;
        Thu, 04 May 2023 08:04:36 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id w12-20020a5d680c000000b0030630120e56sm10437110wru.57.2023.05.04.08.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 08:04:36 -0700 (PDT)
Message-ID: <e4c92510-9756-d9a1-0055-4cd64a0c76d9@redhat.com>
Date: Thu, 4 May 2023 17:04:34 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To: Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
 Matthew Wilcox <willy@infradead.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Leon Romanovsky <leon@kernel.org>, Christian Benvenuti <benve@cisco.com>,
 Nelson Escobar <neescoba@cisco.com>, Bernard Metzler <bmt@zurich.ibm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 Bjorn Topel <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Christian Brauner <brauner@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
 bpf@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, "Kirill A . Shutemov" <kirill@shutemov.name>,
 Pavel Begunkov <asml.silence@gmail.com>, Mika Penttila
 <mpenttil@redhat.com>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v8 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
In-Reply-To: <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[...]

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

You can easily have anon pages that are at the swapcache at this point 
(especially, because this function is called before our unsharing 
checks), the comment is misleading.

And there is nothing wrong about pinning an anon page that's still in 
the swapcache. The following folio_test_anon() check will allow them.

The check made sense in page_mapping(), but here it's not required.

I do agree regarding folio_test_slab(), though. Should we WARN in case 
we would have one?

if (WARN_ON_ONCE(folio_test_slab(folio)))
	return false;

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

KSM pages are also (shared) anonymous folios, and that check would fail 
-- which is ok (the following unsharing checks rejects long-term pinning 
them), but a bit inconstent with your comment and folio_test_anon().

It would be more consistent (with your comment and also the 
folio_test_anon implementation) to have here:

	return mapping_flags & PAGE_MAPPING_ANON;

> +
> +	/*
> +	 * At this point, we know the mapping is non-null and points to an
> +	 * address_space object. The only remaining whitelisted file system is
> +	 * shmem.
> +	 */
> +	return shmem_mapping(mapping);
> +}
> +

In general, LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


