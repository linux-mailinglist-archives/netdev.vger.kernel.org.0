Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413E76F4A4F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjEBT0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjEBT0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:26:05 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514EC1BD4;
        Tue,  2 May 2023 12:26:01 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f19b9d5358so42459315e9.1;
        Tue, 02 May 2023 12:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683055560; x=1685647560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/AUSUmrI+P7/+99Qu6phENx8nWverUMMhzCM0iScMBs=;
        b=A8IPl7XSjnSBORcWZdF+wrp4liindlsj/EFJuQ667TQjLSd0VNOtM03C+cX2d0Xkx0
         yT3w4a7ZWvvaIHGji/U1kDoPlYYXfz5B0jaVp3duDNcIwp9WOjYLqVhGESANFpy51BnH
         NzB2+W9lOFUoH1Jl07+CYDfTfERa7FYirtn+Bxe+yjV8hV44R+k7O1bN76p641pr2Ymb
         QO15obXh5w8ppB56iyY8Xy3AoJb5X7330ozrt5xVKG1CBvjsUzwkYCvE0rfKnizwDYzu
         sh2VD2syoE3U0pJf/7E8YqKqaj/o3il5kaXtv5UnY051GaeGafOzq6vhQ9KdZVoDfXuw
         YpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683055560; x=1685647560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AUSUmrI+P7/+99Qu6phENx8nWverUMMhzCM0iScMBs=;
        b=MYevraMQh94BBesEJWkzm+EpI7Sx8jYuujJk0i8xFZkpsrGKQW/lXiMON9KJRh4Swf
         L5h0KXeRcRHAw+SaVSPWRfjxJPNOc2PMVoG2L0gXbLltUU6sPeyERKwxuw7ema5bzLkS
         AFA87/Gr8uR/DEhnJvohtEVQnTREeWgG9UCDFYjyHtOgkhktsPf+8omw96XrZ+HYLRDm
         NAEzX24Bwc6IqmrmL+FF2/JZO4nXXKzCwRSsHcIDyI59qONebq4H31zqX0VOHKJQheCj
         cnAnuZQ+Qu5BAp3/H2gHa0bUfaKM9loBWRwZC/RNF1iRn1sARQg0z7ezFIrQquPQ9gJn
         8jzA==
X-Gm-Message-State: AC+VfDxPxNIkJyAcm9APqMr98aqc2LDqu/7AvhywChFH2Kja679NLr7L
        E8mf1qaA/cbycGcMYsI2lNDNeHNEZuFOBQ==
X-Google-Smtp-Source: ACHHUZ6ht0Ch0aOBCvqee5y4/fBW9GOhRmD+e/rpLLfvnS/wbCTyo4hCAQdlm7a2k3NJP1zBT6EnUg==
X-Received: by 2002:a05:600c:2212:b0:3f1:6ebe:d598 with SMTP id z18-20020a05600c221200b003f16ebed598mr12463201wml.7.1683055559416;
        Tue, 02 May 2023 12:25:59 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id 13-20020a05600c230d00b003f31da39b62sm15329343wmo.18.2023.05.02.12.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 12:25:58 -0700 (PDT)
Date:   Tue, 2 May 2023 20:25:57 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
 <ZFFfhhwibxHKwDbZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFFfhhwibxHKwDbZ@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 04:07:50PM -0300, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 07:17:14PM +0100, Lorenzo Stoakes wrote:
>
> > On a specific point - if mapping turns out to be NULL after we confirm
> > stable PTE, I'd be inclined to reject and let the slow path take care of
> > it, would you agree that that's the correct approach?
>
> I think in general if GUP fast detects any kind of race it should bail
> to the slow path.
>
> The races it tries to resolve itself should have really safe and
> obvious solutions.
>
> I think this comment is misleading:
>
> > +	/*
> > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > +	 * to disappear from under us, as well as preventing RCU grace periods
> > +	 * from making progress (i.e. implying rcu_read_lock()).
>
> True, but that is not important here since we are not reading page
> tables
>
> > +	 * This means we can rely on the folio remaining stable for all
> > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > +	 * and those that do not.
>
> Not really clear. We have a valid folio refcount here, that is all.

Some of this is a product of mixed signals from different commenters and
my being perhaps a little _too_ willing to just go with the flow.

With interrupts disabled and IPI blocked, plus the assurances that
interrupts being disabled implied the RCU version of page table
manipulation is also blocked, my understanding was that remapping in this
process to another page could not occur.

Of course the folio is 'stable' in the sense we have a refcount on it, but
it is unlocked so things can change.

I'm guessing the RCU guarantees in the TLB logic are not as solid as IPI,
because in the IPI case it seems to me you couldn't even clear the PTE
entry before getting to the page table case.

Otherwise, I'm a bit uncertain actually as to how we can get to the point
where the folio->mapping is being manipulated. Is this why?

>
> > +	 * We get the added benefit that given inodes, and thus address_space,
> > +	 * objects are RCU freed, we can rely on the mapping remaining stable
> > +	 * here with no risk of a truncation or similar race.
>
> Which is the real point:
>
> 1) GUP-fast disables IRQs which means this is the same context as rcu_read_lock()
> 2) We have a valid ref on the folio due to normal GUP fast operation
>    Thus derefing struct folio is OK
> 3) folio->mapping can be deref'd safely under RCU since mapping is RCU free'd
>    It may be zero if we are racing a page free path
>    Can it be zero for other reasons?

Zero? You mean NULL?

In any case, I will try to clarify these, I do agree the _key_ point is
that we can rely on safely derefing the mapping, at least READ_ONCE()'d, as
use-after-free or dereffing garbage is the fear here.

>
> If it can't be zero for any other reason then go to GUP slow and let
> it sort it out
>
> Otherwise you have to treat NULL as a success.
>

Well that was literally the question :) and I've got somewhat contradictory
feedback. My instinct aligns with yours in that, just fallback to slow
path, so that's what I'll do. But just wanted to confirm.

> Really what you are trying to do here is remove the folio lock which
> would normally protect folio->mapping. Ie this test really boils down
> to just 'folio_get_mapping_a_ops_rcu() == shmem_aops'
>
> The hugetlb test is done on a page flag which should be stable under
> the pageref.
>
> So.. Your function really ought to be doing this logic:
>
>         // Should be impossible for a slab page to be in a VMA
> 	if (unlikely(folio_test_slab(folio)))
> 	   return do gup slow;
>
> 	// Can a present PTE even be a swap cache?
>    	if (unlikely(folio_test_swapcache(folio)))
> 	   return do gup slow;
>
> 	if (folio_test_hugetlb(folio))
> 	   return safe for fast
>
> 	// Safe without the folio lock ?
>    	struct address_space *mapping = READ_ONCE(folio->mapping)
> 	if ((mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_ANON)
> 	   return safe for fast
> 	if ((mapping & PAGE_MAPPING_FLAGS) == 0 && mapping)
> 	   return mapping->a_ops == shmem_aops;
>
>         // Depends on what mapping = NULL means
> 	return do gup slow
>

Yeah this is how I was planning to implement it, or something along these
lines. The only question was whether my own view aligned with others to
avoid more spam :)

The READ_ONCE() approach is precisely how I wanted to do it in thet first
instance, but feared feedback about duplication and wondered if it made
much difference, but now it's clear this is ther ight way.

> Jason
