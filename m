Return-Path: <netdev+bounces-2609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 296C5702B05
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2DF4281276
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE30ABA57;
	Mon, 15 May 2023 11:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC02D8BFC;
	Mon, 15 May 2023 11:03:26 +0000 (UTC)
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C1593;
	Mon, 15 May 2023 04:03:25 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailnew.west.internal (Postfix) with ESMTP id BF1CA2B05E55;
	Mon, 15 May 2023 07:03:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 May 2023 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to; s=fm2; t=1684148600; x=
	1684155800; bh=a/Iydw3E9XYq6OMWXW3TvDHCSGXOvuQLC/4M2+8UgSg=; b=b
	eqhaz6+aC9XTJDJe/wr3N36+Tj3flpCfHvlOf9y8lXsK+262zaCij702Mejo2+QE
	Fd2xpeGSZ+xZXcy4D/O2ys6/yeyG+eg9pe7ttAK7rJ4flep8j0NnEuUu/JpgQ2zq
	+sQYGICk0DOSR7KXB1FGzWMBThhFGROaza2HF5WZTMoyXCpSoGrgyUpv2AwTVyoh
	MPRAEKadMnnI/sj+LbQEWvTyhwhvfq0KMSmbFHooxdpg4bZ6fN05mjKqs5p5+gMe
	sDKrBEwm+QstfKvMpg7xfToq9y+QHBotkJ9i3CoJB7tGWQC23VldSFyJYd2XEL4U
	Gl+2fihoHMbSTuxjVue1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684148600; x=1684155800; bh=a/Iydw3E9XYq6
	OMWXW3TvDHCSGXOvuQLC/4M2+8UgSg=; b=HCOKyUCGguRFf1xsGM0olaZPpyE83
	QUFg57fXwoOwyQLXQfBrzuMoGa6jxavNDy4hgO/KieahDInTa0sH3/uTA04n9PBd
	pOkNlIQsSrzizEIjBJ9OClefL/E9/wJWOs6W/BHwQZEkVPX/yhJWt9zeo1XJL8yO
	Dm7ChPssB/erg2Ti3ewsAZ+Qt8Pig5D5DcQN2IwE1zz0yI1+ld7eJeDoy/HbjJp8
	Fwwn6gnv5N4GzwOjiaZb1+aSt2I9N4jbT6NnDxfZPC4PkwlZwKP41PP0oJSiwruW
	x9dW25YtqwNwMjBly/giIjtuqcpmWp+sz3+M1OpAnT7+WPfc354OTJLVA==
X-ME-Sender: <xms:dhFiZEQbnWm3lInkgea7I7q1loI6EFTX6nzXoxo3EDKGBC7aVf78JQ>
    <xme:dhFiZBzQCYHtsXc_PNzioGz_LirMx3rzOlJKv2j3XQvwtfi9xBh9nIt-NSbn91mDy
    GGmyxgBoYxOaSQmTHg>
X-ME-Received: <xmr:dhFiZB0cV9suhDUtQEAuyjbHbnx9BgFWQsl2ctv7O5xUxZYuVwDGbzehTtid6zfg5GjMnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehjedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepfdfmihhr
    ihhllhcutecurdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgeqnecuggftrfgrthhtvghrnhepgfdtveeugeethfffffeklefgkeelgfekfedt
    heeileetuefhkeefleduvddtkeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:dhFiZIBy-PxGx3tPTgENuB_FWVbnaUYJARgJaIETejlMMBmS1qqMqg>
    <xmx:dhFiZNiE67YhRxNXKSa-apUdVunXaJs_KQHgaZXyYup4bktoBVqs2w>
    <xmx:dhFiZEo8qMND9yszOfCAsL6QVxCoJx9tsBa5wX9U-MgZ4JdFPa9D8Q>
    <xmx:eBFiZLGG797U78ccFpNj3KjzIqU78oAjziYTSAnozz3GqFRyt5wx050guAM>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 May 2023 07:03:17 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 55AD0103956; Mon, 15 May 2023 14:03:15 +0300 (+03)
Date: Mon, 15 May 2023 14:03:15 +0300
From: "Kirill A . Shutemov" <kirill@shutemov.name>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,	Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,	linux-fsdevel@vger.kernel.org,
 linux-perf-users@vger.kernel.org,	netdev@vger.kernel.org,
 bpf@vger.kernel.org,	Oleg Nesterov <oleg@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>,	John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>,	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,	Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>,	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
References: <cover.1683235180.git.lstoakes@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683235180.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 10:27:50PM +0100, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.

Okay, problem is clear and the patchset look good to me. But I'm worried
breaking existing users.

Do we expect the change to be visible to real world users? If yes, are we
okay to break them?

One thing that came to mind is KVM with "qemu -object memory-backend-file,share=on..."
It is mostly used for pmem emulation.

Do we have plan B?

Just a random/crazy/broken idea:

 - Allow folio_mkclean() (and folio_clear_dirty_for_io()) to fail,
   indicating that the page cannot be cleared because it is pinned;

 - Introduce a new vm_operations_struct::mkclean() that would be called by
   page_vma_mkclean_one() before clearing the range and can fail;

 - On GUP, create an in-kernel fake VMA that represents the file, but with
   custom vm_ops. The VMA registered in rmap to get notified on
   folio_mkclean() and fail it because of GUP.

 - folio_clear_dirty_for_io() callers will handle the new failure as
   indication that the page can be written back but will stay dirty and
   fs-specific data that is associated with the page writeback cannot be
   freed.

I'm sure the idea is broken on many levels (I have never looked closely at
the writeback path). But maybe it is good enough as conversation started?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

