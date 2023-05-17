Return-Path: <netdev+bounces-3224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A53270617A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4779E2813D1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3960AD23;
	Wed, 17 May 2023 07:42:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C40C8830;
	Wed, 17 May 2023 07:42:33 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478B1BF;
	Wed, 17 May 2023 00:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HPDWw34wuVd8ioS24/GeMKLCeS2AVAgFryvQOngyNIQ=; b=MsacaJGq7G6gp1g2tKwWD9aPxj
	lIWiYSjSeZTbTQc8SB3TDcwvIoK1SbqwWRIlPhC4YSIUXLoxKBxmBJ58tJRS9JpJmnWpamWhDDysS
	V+k9SiF1Gr/FG74fEbS0WLGg5+wM8WHBsWbZPUbLL61ZV6/WLTgCmsVZQ0eHVUJ6f5q8AhU/DBoow
	9bum13Vokx8ry+6dEIpVmJ8nUJYyawYXr4VnZAj+bk7J7JugOSOwIcYMLgnY3TWJ9XtR7iQY9Doiw
	wbuan1SLeZK8/F+6tjRql9ysljB4YE9pY/nSPiZeshU2J/+GFfaBZVfQ90285TEWrjn1EYa4PYQ/M
	3YyGF0Jg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pzBnk-008iGg-1Y;
	Wed, 17 May 2023 07:42:24 +0000
Date: Wed, 17 May 2023 00:42:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <ZGSFYNAauVDsb22o@infradead.org>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
 <ZGIhwZl2FbLodLrc@nvidia.com>
 <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
 <20230517072920.bfs7gfo4whdmi6ay@quack3>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517072920.bfs7gfo4whdmi6ay@quack3>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 09:29:20AM +0200, Jan Kara wrote:
> > > Surely it is, but like Ted said, the FS folks are not interested and
> > > they are at least half the solution..
> > 
> > :'(
> 
> Well, I'd phrase this a bit differently - it is a difficult sell to fs
> maintainers that they should significantly complicate writeback code / VFS
> with bounce page handling etc. for a thing that is not much used corner
> case. So if we can get away with forbiding long-term pins, then that's the
> easiest solution. Dealing with short-term pins is easier as we can just
> wait for unpinning which is implementable in a localized manner.

Full agreement here.  The whole concept of supporting writeback for
long term mappings does not make much sense.

> > > The FS also has to actively not write out the page while it cannot be
> > > write protected unless it copies the data to a stable page. The block
> > > stack needs the source data to be stable to do checksum/parity/etc
> > > stuff. It is a complicated subject.
> > 
> > Yes my sense was that being able to write arbitrarily to these pages _at
> > all_ was a big issue, not only the dirty tracking aspect.
> 
> Yes.
> 
> > I guess at some level letting filesystems have such total flexibility as to
> > how they implement things leaves us in a difficult position.
> 
> I'm not sure what you mean by "total flexibility" here. In my opinion it is
> also about how HW performs checksumming etc.

I have no idea what total flexbility is even supposed to be.

