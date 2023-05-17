Return-Path: <netdev+bounces-3223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4AA706168
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 947C41C20EBD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F32AA95F;
	Wed, 17 May 2023 07:40:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD81AD21;
	Wed, 17 May 2023 07:40:31 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282DEE40;
	Wed, 17 May 2023 00:40:30 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f475366514so2821145e9.2;
        Wed, 17 May 2023 00:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684309228; x=1686901228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+Ld0Ovjdd0x8sc5pvboMnhYHV4AgRb0J8CE6t0hZIM=;
        b=WA4SxHpvGm1ODLM4q/8vfu4vKglP08hu0HlJ/yJJbiD9LBzuIHlUgDdcL3VIMkHk/P
         p2cz2vdAYv4BbiJ0LQb/Dzae+iABrn+JRnv+S8RGWEPseRZq0h7QRvRtmRbcesxue8a/
         BciE7NdBJ4QRsjKDJQE77K2/2QUXnqDpqCLLflQ9zc8BaBcSESiHiDelcdo0LrzKMHaC
         GUMDcQgWV//4Zs7KXkfDnbCoP76vQ+YQT8YhKjLXhfDZACBifHxeO2/8ymyh0cmWzSVD
         rtYLl1O47U9VzqLqtCwhyHFUA2ZAtik0+iGN7RqiL3HAYiJJoJPkrJkPKRposqrQ0oAq
         ri2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684309228; x=1686901228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+Ld0Ovjdd0x8sc5pvboMnhYHV4AgRb0J8CE6t0hZIM=;
        b=QBzK6v89W+4YM359n67GZzi+5YcIKdg7P+DhjZdk6BTwR0TrW1FmmOP0evHZQ+GOF+
         d1GIQP/6NC+glSm7PukqP/G5LTX0bYHVO8f4Mofk5hwC1zTEuc73RJTilFtkf4cyQ7sj
         XMWBqDzCQPeZHW8L0kDqExExznLNDS9LoWfsh5rAwtRgIZ5FF7mgNQmbIMf4kHhjJWNo
         +kmRAOmXUJos7QS/BLTrYCyQmhijGqL+GFBUX8ZNp1w4n6jIRAoIZArrsrdxOssv/cER
         KcGlDUNdAikMEUcszJV6xB0b1x0Z+hEcl4K8JZWotXzl72dlZ+VZo06n6EiKfmsWoxun
         u6IQ==
X-Gm-Message-State: AC+VfDwlygc1sGiQEVkQkU9xynPdCP2yY767H+8AOqjbvnjetIrFM2+T
	N6GNfcPk8CKGwHWMP0oPItc=
X-Google-Smtp-Source: ACHHUZ4QFru10EJHOkrAg2WS7xokWnRh6SsO8/nZ9408Z1x44sx4+q5GoeByQVkYGCmWKPQ44It+Qw==
X-Received: by 2002:a7b:ca51:0:b0:3f4:2148:e8e5 with SMTP id m17-20020a7bca51000000b003f42148e8e5mr24473724wml.1.1684309228284;
        Wed, 17 May 2023 00:40:28 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id f21-20020a7bcc15000000b003f31d44f0cbsm1289563wmh.29.2023.05.17.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 00:40:26 -0700 (PDT)
Date: Wed, 17 May 2023 08:40:26 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <d17c0fce-679b-4f5d-9a7c-6ff7e28ad4b2@lucifer.local>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 09:29:20AM +0200, Jan Kara wrote:
> On Mon 15-05-23 14:07:57, Lorenzo Stoakes wrote:
> > On Mon, May 15, 2023 at 09:12:49AM -0300, Jason Gunthorpe wrote:
> > > On Mon, May 15, 2023 at 12:16:21PM +0100, Lorenzo Stoakes wrote:
> > > > Jason will have some thoughts on this I'm sure. I guess the key question
> > > > here is - is it actually feasible for this to work at all? Once we
> > > > establish that, the rest are details :)
> > >
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
>

Totally understandable. It's unfortunately I feel a case of something we
should simply not have allowed.

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

I mean to say *_ops allow a lot of flexibility in how things are
handled. Certainly checksumming is a great example but in theory an
arbitrary filesystem could be doing, well, anything and always assuming
that only userland mappings should be modifying the underlying data.

>
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

