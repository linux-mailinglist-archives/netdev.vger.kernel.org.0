Return-Path: <netdev+bounces-3225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE5A706184
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04C161C20E49
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC30AD27;
	Wed, 17 May 2023 07:43:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA2D8830;
	Wed, 17 May 2023 07:43:42 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AF8DA;
	Wed, 17 May 2023 00:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=epIz9WNLfn/uDEbQVAxaXtzYiN9TCXftS0bKHjTl38Y=; b=tldy3unv0O0ScM26uWYfvGYwqV
	RIUAc42Wa5JqJlmli6hN7aarUI2WLa8u8hlYjNKRB9TsgpEWZlEJCuIEdQvhVYt3TNdVyyJVlbDB3
	McAms7oQTK8UeRCDjBuP4nYMDWDVtNsavChSiigR7jrv2lUpxm7fs3B5Lqi4SjWgiOHdpyXB/o3+3
	z4mOJSgbkesaYtKiPshob4b3L49efh/RSG90s556lsuexl7EQv2MB9M9fSUPoaDBESoJ61XAsivf6
	Vl+rGJ/8ui1Rix5kgi60q3e9OFbxnYhc7eh7WfFfgtOiNvtETDLHKi9n6MN9b3LYRm9xWn47Y5JFU
	OhncL+Qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pzBos-008iVo-1m;
	Wed, 17 May 2023 07:43:34 +0000
Date: Wed, 17 May 2023 00:43:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <ZGSFptUyOko+184t@infradead.org>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
 <ZGIhwZl2FbLodLrc@nvidia.com>
 <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
 <20230517072920.bfs7gfo4whdmi6ay@quack3>
 <d17c0fce-679b-4f5d-9a7c-6ff7e28ad4b2@lucifer.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d17c0fce-679b-4f5d-9a7c-6ff7e28ad4b2@lucifer.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 08:40:26AM +0100, Lorenzo Stoakes wrote:
> > I'm not sure what you mean by "total flexibility" here. In my opinion it is
> > also about how HW performs checksumming etc.
> 
> I mean to say *_ops allow a lot of flexibility in how things are
> handled. Certainly checksumming is a great example but in theory an
> arbitrary filesystem could be doing, well, anything and always assuming
> that only userland mappings should be modifying the underlying data.

File systems need a wait to track when a page is dirtied so that it can
be written back.  Not much to do with flexbility.

