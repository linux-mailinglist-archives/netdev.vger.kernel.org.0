Return-Path: <netdev+bounces-3233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E80706267
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D5412815B3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C55156FE;
	Wed, 17 May 2023 08:10:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27823156FC;
	Wed, 17 May 2023 08:10:24 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DD510EF;
	Wed, 17 May 2023 01:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DTmEEM/+QduNUnxg8gEx0EXzPjAs6x+04O4FYgiiAdQ=; b=RdAX2d2XiqRvKxl2rKOGWzP4uK
	jRMB6DlSpFvBHfPwXiFTnREXMRvZIa5vr9f+gheMapnqq4nwfC2b6p5bhhbus/OlCtASE4Ek2elUO
	8GI3PuGvzy06pzPsguJHueg+BCCz0i6mWoY7F4ScVr8GnLeZ82DnAedMyOfIQs8SFXX6PnA7c5H2G
	hJD8j5BpWjJ5ZQw0C0h1lV0VgyGju5Q0HBaPOZoAtiXKQX/J5THbxD/TLpDfiRnyh8O7Uujygh0YI
	YZJ9K6yRQPpYU2m2mrMqPUp7c1Xe5xU1To/+dbrYoiqE7CO0CMJKS3W3CZzsCiqhHLOU1JmqfXDw1
	5gYHPBMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pzCEj-008nbM-21;
	Wed, 17 May 2023 08:10:17 +0000
Date: Wed, 17 May 2023 01:10:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Kirill A . Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
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
	Oleg Nesterov <oleg@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <ZGSL6Q8K5lh4Pdwp@infradead.org>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
 <ZGIhwZl2FbLodLrc@nvidia.com>
 <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
 <20230517072920.bfs7gfo4whdmi6ay@quack3>
 <d17c0fce-679b-4f5d-9a7c-6ff7e28ad4b2@lucifer.local>
 <ZGSFptUyOko+184t@infradead.org>
 <503e92f9-fbc2-422b-b0d4-f4cabe3f6802@lucifer.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503e92f9-fbc2-422b-b0d4-f4cabe3f6802@lucifer.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 08:55:27AM +0100, Lorenzo Stoakes wrote:
> I'll try to take this in good faith because... yeah. I do get that, I mean
> I literally created a repro for this situation and referenced in the commit
> msg and comments this precise problem in my patch series that
> addresses... this problem :P
> 
> Perhaps I'm not being clear but it was simply my intent to highlight that
> yes this is the primary problem but ALSO GUP writing to ostensibly 'clean'
> pages 'behind the back' of a fs is _also_ a problem.

Yes, it absolutely is a problem if that happens.  But we can just
fix it in the kernel using the:

   lock_page()
   copy data
   set_page_dirty_locked()
   unlock_page();

pattern, and we should have covere every place that did in tree.
But there's no good way to verify it except for regular code audits.

