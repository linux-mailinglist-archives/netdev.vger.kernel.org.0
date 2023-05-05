Return-Path: <netdev+bounces-640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0246F8C3C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3350A1C21A31
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 22:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213E8101E1;
	Fri,  5 May 2023 22:08:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DC4C8C5;
	Fri,  5 May 2023 22:08:11 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A945599;
	Fri,  5 May 2023 15:08:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f4000ec6ecso23411115e9.0;
        Fri, 05 May 2023 15:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683324479; x=1685916479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hTk40pEIa6sggozNPGL/VTk1LAwsz/xKnNcnmk0Uw40=;
        b=qUXPIJOEcmVya4t4Z8BVExBOKsEpEyw/+X5BvfMyQWS4PlaTFXXK19eB3j72mNNlXx
         5KwlgukleyM6txF/8ewbTiGaIVAL0aS5iPiL2DguJHX1EKvTqQeBFw9kNcGNauP4Rmnq
         N53ZSsL+dWBOp24Ek5DYYwdR+UEXfMDCZWNDAvOZAZHqaeE4rpT6pLpAIKnPiKqG8wEN
         /tUv8TLuf2pvomk+ViSv52atgQ6+iy8lhTHOt6WBz7zIPkomsTHnPv5yCkfCgX1fE956
         foFDLn8x4GwP8/4sRIH7I2dBPzR4l0uV0HdkxC8YxRxom0JmqU7dC872WFhKm6lwVuYL
         umag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683324479; x=1685916479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTk40pEIa6sggozNPGL/VTk1LAwsz/xKnNcnmk0Uw40=;
        b=Wh2R/Eer+dPWFZP/yTT/NU3V4rnFcqVkn0P9OA/iuAV+8YfJY+sSIvZ70Yrefc3b6G
         G29ePhymbo1LMPSRdVtH6HkL4DMyLoStMP4ylG8xiF0GQKHKmamy2YEjTtCKmEYMBsW1
         FqjwVRcadby1eP7qOK+qr+xmtcMH0Wr4MEpwo39962g/YVCRlgK0dsNRNyFuorLh83eR
         jqsl4nvf3Pg72N/O+/IMbm1tFdf6VdKHXFNDPgxsK4vXu4LTMQAvBnxa5ZRJ0Wwjrb8J
         O8atZGBL6n7Ar28uolEapDpLBLHh5T4f6Nl6a/waLXwW5SeLNYGxF6esdxjt55FfzK2J
         oVVg==
X-Gm-Message-State: AC+VfDx7LSA4WMNcMeUNRAzNwBf0p9wz2yA1SFjEzJsEpyFfwMVMmnrg
	EgsdW0r4+SpwVP/FsIhiGpE=
X-Google-Smtp-Source: ACHHUZ4mH83mCyTOoGWHtxkKNT6uM9KmncozyTwpylz+11m1DNl/kRNCToS5r+sQq24bid7g2GcEDw==
X-Received: by 2002:a05:600c:218f:b0:3f0:a0bb:58ef with SMTP id e15-20020a05600c218f00b003f0a0bb58efmr2184588wme.25.1683324479379;
        Fri, 05 May 2023 15:07:59 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id a20-20020a1cf014000000b003f173c566b5sm9137978wmb.5.2023.05.05.15.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 15:07:58 -0700 (PDT)
Date: Fri, 5 May 2023 23:07:57 +0100
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
Message-ID: <52ac98ca-378e-452c-9dbf-93ea39bb5583@lucifer.local>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
 <e4c92510-9756-d9a1-0055-4cd64a0c76d9@redhat.com>
 <c2a6311c-7fdc-4d12-9a3f-d2eed954c468@lucifer.local>
 <ae9a1134-4f5b-4c26-6822-adff838c8702@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae9a1134-4f5b-4c26-6822-adff838c8702@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 04:17:38PM +0200, David Hildenbrand wrote:
> > > And there is nothing wrong about pinning an anon page that's still in the
> > > swapcache. The following folio_test_anon() check will allow them.
> > >
> > > The check made sense in page_mapping(), but here it's not required.
> >
> > Waaaaaaaaaait a second, you were saying before:-
> >
> >    "Folios in the swap cache return the swap mapping" -- you might disallow
> >    pinning anonymous pages that are in the swap cache.
> >
> >    I recall that there are corner cases where we can end up with an anon
> >    page that's mapped writable but still in the swap cache ... so you'd
> >    fallback to the GUP slow path (acceptable for these corner cases, I
> >    guess), however especially the comment is a bit misleading then.
> >
> > So are we allowing or disallowing pinning anon swap cache pages? :P
>
> If we have an exclusive anon page that's still in the swap cache, sure! :)
>
> I think there are ways that can be done, and nothing would actually break.
> (I even wrote selftests in the cow selftests for that to amke sure it works
> as expected)
>
> >
> > I mean slow path would allow them if they are just marked anon so I'm inclined
> > to allow them.
>
> Exactly my reasoning.
>
> The less checks the better (especially if ordinary GUP just allows for
> pinning it) :)

Yeah a lot of my decision making on this has been trying to be conservative
about what we filter for but you get this weird inversion whereby if you're
too conservative about what you allow, you are actually being more
outlandish about what you disallow and vice-versa.

>
> >
> > >
> > > I do agree regarding folio_test_slab(), though. Should we WARN in case we
> > > would have one?
> > >
> > > if (WARN_ON_ONCE(folio_test_slab(folio)))
> > > 	return false;
> > >
> >
> > God help us if we have a slab page at this point, so agreed worth doing, it
> > would surely have to arise from some dreadful bug/memory corruption.
> >
>
> Or some nasty race condition that we managed to ignore with rechecking if
> the PTEs/PMDs changed :)

Well that should be sorted now :)

>
> > > > +	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
> > > > +		return false;
> > > > +
> > > > +	/* hugetlb mappings do not require dirty-tracking. */
> > > > +	if (folio_test_hugetlb(folio))
> > > > +		return true;
> > > > +
> > > > +	/*
> > > > +	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
> > > > +	 * cannot proceed, which means no actions performed under RCU can
> > > > +	 * proceed either.
> > > > +	 *
> > > > +	 * inodes and thus their mappings are freed under RCU, which means the
> > > > +	 * mapping cannot be freed beneath us and thus we can safely dereference
> > > > +	 * it.
> > > > +	 */
> > > > +	lockdep_assert_irqs_disabled();
> > > > +
> > > > +	/*
> > > > +	 * However, there may be operations which _alter_ the mapping, so ensure
> > > > +	 * we read it once and only once.
> > > > +	 */
> > > > +	mapping = READ_ONCE(folio->mapping);
> > > > +
> > > > +	/*
> > > > +	 * The mapping may have been truncated, in any case we cannot determine
> > > > +	 * if this mapping is safe - fall back to slow path to determine how to
> > > > +	 * proceed.
> > > > +	 */
> > > > +	if (!mapping)
> > > > +		return false;
> > > > +
> > > > +	/* Anonymous folios are fine, other non-file backed cases are not. */
> > > > +	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
> > > > +	if (mapping_flags)
> > > > +		return mapping_flags == PAGE_MAPPING_ANON;
> > >
> > > KSM pages are also (shared) anonymous folios, and that check would fail --
> > > which is ok (the following unsharing checks rejects long-term pinning them),
> > > but a bit inconstent with your comment and folio_test_anon().
> > >
> > > It would be more consistent (with your comment and also the folio_test_anon
> > > implementation) to have here:
> > >
> > > 	return mapping_flags & PAGE_MAPPING_ANON;
> > >
> >
> > I explicitly excluded KSM out of fear that could be some breakage given they're
> > wrprotect'd + expected to CoW though? But I guess you mean they'd get picked up
> > by the unshare and so it doesn't matter + we wouldn't want to exclude an
> > PG_anon_exclusive case?
>
> Yes, unsharing handles that in the ordinary GUP and GUP-fast case. And
> unsharing is neither GUP-fast nor even longterm specific (for anon pages).
>
> Reason I'm brining this up is that I think it's best if we let
> folio_fast_pin_allowed() just check for what's absolutely GUP-fast specific.

Ack, indeed it's a separate thing, see above for the contradictory nature
of wanting to be cautious but then accidentally making your change _more
radical_ than you intended...!

>
> >
> > I'll make the change in any case given the unshare check!
> >
> > I notice the gup_huge_pgd() doesn't do an unshare but I mean, a PGD-sized huge
> > page probably isn't going to be CoW'd :P
>
> I spotted exactly the same thing and wondered about that (after all I added
> all that unsharing logic ... so I should know). I'm sure there must be a
> reason I didn't add it ;)
>
> ... probably we should just add it even though it might essentially be dead
> code for now (at least the cow selftests would try with each and every
> hugetlb size and eventually reveal the problem on whatever arch ends up
> using that code ... ).
>
> Do you want to send a patch to add unsharing to gup_huge_pgd() as well?
>

Sure will do!

> --
> Thanks,
>
> David / dhildenb
>

