Return-Path: <netdev+bounces-3226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9557061D3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C406F281459
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07891AD2E;
	Wed, 17 May 2023 07:55:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD56AD23;
	Wed, 17 May 2023 07:55:32 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3E31701;
	Wed, 17 May 2023 00:55:30 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-307c040797bso230304f8f.3;
        Wed, 17 May 2023 00:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684310129; x=1686902129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3/kfc+tiJ0ZCBOb1GVRxtYgE5lDPgEU5sGHiw/RjZPo=;
        b=UV9FWfS8aIvYMGLcPcpiWcUdl75X59NHVstTUgr95d6jmEJGTvmJYksKT9XVbcSz0R
         /uqtlt+EidplmbyZ2bX7/b6E3nTsXJpK97L9rApchZ0lF3T5y9vldo06p44O0HeSnFuq
         ccgs3QBBJEDmceq6i+YH2t1CFNLUL5N8H4w8ZN8tQl7h1zFBX/tF8MwHfn40MmBFRr62
         3dZfQIDLSb3oRoNjfpdbTw52pmWThAAIAxgDegm26qYqZO/3etNtu3SaO5NKSKsj4ROX
         3OBTGc1PooOgO1kuA6mIZf+6ZED7DiGxUZxFmPlUjvOvLjM6M4n/KmN93/gTjqLSQD8t
         EwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684310129; x=1686902129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/kfc+tiJ0ZCBOb1GVRxtYgE5lDPgEU5sGHiw/RjZPo=;
        b=eiLq9wFoisV2RNtxEabW5YZB1VWuuCxgrGUj924m4IJKOrVmmW9IWUyolHuA47RSC+
         f8oa8hbJXxpcSloe2ed7r69HW57Nhw5BOsOWt4Ym2OEwrzf8jUQfBPBFnoEjmNYn4Dn2
         xSZzwb3vEz+CF1qA9uZbIZmVCV4ti6SCKIeYJcgczp35md/pa1xRZCaHHsQFKDoNEVPL
         WUZTW+iq1fGbZtxr8qZAc+LaVQIzn0ZDs6cg3WvUEV3hqZk6zym2O0o9z+i9ko0g8P9n
         MiN8xD9wv6xLPqHo90KtXmQQLZIwcrFSAdxlw0AEuLfuzEBMAtCxe76qdvURMTPFOdWb
         Pkow==
X-Gm-Message-State: AC+VfDxIacZA5tKNaMGLeXmYzHwgn87yENjUIe/GGbyE3nkr9vEbWvxM
	g58EbkvBOkfSztGeLPvslPE=
X-Google-Smtp-Source: ACHHUZ7ZXduP0XJibx9YnkNGpPiAha7x3In1oyBZXq6dDd4yPqz/WqdMaDLUZ1dKYA2W1fWzJ30ksQ==
X-Received: by 2002:adf:e8c4:0:b0:309:3698:8006 with SMTP id k4-20020adfe8c4000000b0030936988006mr3101357wrn.34.1684310128765;
        Wed, 17 May 2023 00:55:28 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id t2-20020a5d5342000000b00307972e46fasm1844942wrv.107.2023.05.17.00.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 00:55:27 -0700 (PDT)
Date: Wed, 17 May 2023 08:55:27 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
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
Message-ID: <503e92f9-fbc2-422b-b0d4-f4cabe3f6802@lucifer.local>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
 <ZGIhwZl2FbLodLrc@nvidia.com>
 <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
 <20230517072920.bfs7gfo4whdmi6ay@quack3>
 <d17c0fce-679b-4f5d-9a7c-6ff7e28ad4b2@lucifer.local>
 <ZGSFptUyOko+184t@infradead.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGSFptUyOko+184t@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 12:43:34AM -0700, Christoph Hellwig wrote:
> On Wed, May 17, 2023 at 08:40:26AM +0100, Lorenzo Stoakes wrote:
> > > I'm not sure what you mean by "total flexibility" here. In my opinion it is
> > > also about how HW performs checksumming etc.
> >
> > I mean to say *_ops allow a lot of flexibility in how things are
> > handled. Certainly checksumming is a great example but in theory an
> > arbitrary filesystem could be doing, well, anything and always assuming
> > that only userland mappings should be modifying the underlying data.
>
> File systems need a wait to track when a page is dirtied so that it can
> be written back.  Not much to do with flexbility.

I'll try to take this in good faith because... yeah. I do get that, I mean
I literally created a repro for this situation and referenced in the commit
msg and comments this precise problem in my patch series that
addresses... this problem :P

Perhaps I'm not being clear but it was simply my intent to highlight that
yes this is the primary problem but ALSO GUP writing to ostensibly 'clean'
pages 'behind the back' of a fs is _also_ a problem.

Not least for checksumming (e.g. assume hw-reported checksum for a block ==
checksum derived from page cache) but, because VFS allows a great deal of
flexibility in how filesystems are implemented, perhaps in other respects
we haven't considered.

So I just wanted to highlight (happy to be corrected if I'm wrong) that the
PRIMARY problem is the dirty tracking breaking, but also strikes me that
arbitrary writes to 'clean' pages in the background is one too.

