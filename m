Return-Path: <netdev+bounces-2651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 452CF702D94
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002B3281240
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5350EC8E7;
	Mon, 15 May 2023 13:08:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A867C8E2;
	Mon, 15 May 2023 13:08:31 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E64926B0;
	Mon, 15 May 2023 06:08:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3075e802738so11694985f8f.1;
        Mon, 15 May 2023 06:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684156079; x=1686748079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2gFAV1Bt11rr0HeGWTCJG9IDGxOMnHQHXHHbOCPYDo=;
        b=Fb4+g02YBBu38SltuhS+IwpYVzoxe80rT1yHPlTht9o95uLaKhQM6L02U8FIQSzG0u
         F74fhxfxj9aXytF3FtFdEEivo2st0IMgxLRibmpbYacA0zZWuO4fj3Y/9A2Tn78oIvY0
         C18Ml0c4V5ahXxqIhkCUiPcNutxniHakG8FQrBJdJLkk/GUk7OPBmr0muET13IO4vKdc
         v2E4936Adb3bkr5bfETRmIsjKU+IeoFpOqtNr3sLG0IJtBNMYIXtbopzPX+x1mhNuV0l
         7s9GaeOiQuSZ54g+KUPd/b3efDKiKbFOuOxbTCZbYbh4sbs0SxUN3ALJYt6u0HfENSCo
         XHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684156079; x=1686748079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2gFAV1Bt11rr0HeGWTCJG9IDGxOMnHQHXHHbOCPYDo=;
        b=e3FGC8kMaDzgy3p9yWvJFuQPqCrkBzTk77qhtRMz7/AcEzselnEB//cYVFmk3hBbil
         TL//2nbcZzr1h3hldwaEGoOonTuDQ1jyIXIW5nGaV/uthTgcM38xqwD8ouitC/QPS58J
         7weJo8DMx20GFiQiOmIJ4Uh4P8rTWIVqiIVrx3cl6uAafgMYH74lq5+Us2cmrR79FmCA
         DVwewb8q1BF0vmZ64Mq88UNSaKGd/SqBT9bzFwxfn4Dhp+ZXDgEpPOEhVJ6K9DK8TSpc
         hVc6Ebhu2WZEoWAcXQ85jdrXuIyo0ZSyY9Qf2r5IliksGNWRGXYsY7hSEVFJ0cJ7/3Ba
         HzLA==
X-Gm-Message-State: AC+VfDyDTcKuNNHCGqlAyjOi54doki9HD4X/kBjCUlWZ+L8gMsxqKQQT
	vwFEsQTJVRf2k9O9PzH8vUc=
X-Google-Smtp-Source: ACHHUZ65cUXTV46JE+DSVeEZihKZOp7o4pCuhzCZeDl0jKBfbZDdPGdAnhGyJWS4kVWmFwZtM8978g==
X-Received: by 2002:adf:cc90:0:b0:307:8718:7891 with SMTP id p16-20020adfcc90000000b0030787187891mr25640550wrj.54.1684156078532;
        Mon, 15 May 2023 06:07:58 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id e12-20020adfe7cc000000b002c54c9bd71fsm32604261wrn.93.2023.05.15.06.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 06:07:57 -0700 (PDT)
Date: Mon, 15 May 2023 14:07:57 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
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
	Jan Kara <jack@suse.cz>, Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <ad0053a4-fa34-4b95-a262-d27942b168fd@lucifer.local>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
 <ZGIhwZl2FbLodLrc@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGIhwZl2FbLodLrc@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:12:49AM -0300, Jason Gunthorpe wrote:
> On Mon, May 15, 2023 at 12:16:21PM +0100, Lorenzo Stoakes wrote:
> > > One thing that came to mind is KVM with "qemu -object memory-backend-file,share=on..."
> > > It is mostly used for pmem emulation.
> > >
> > > Do we have plan B?
> >
> > Yes, we can make it opt-in or opt-out via a FOLL_FLAG. This would be easy
> > to implement in the event of any issues arising.
>
> I'm becoming less keen on the idea of a per-subsystem opt out. I think
> we should make a kernel wide opt out. I like the idea of using lower
> lockdown levels. Lots of things become unavaiable in the uAPI when the
> lockdown level increases already.

This would be the 'safest' in the sense that a user can't be surprised by
higher lockdown = access modes disallowed, however we'd _definitely_ need
to have an opt-in in that instance so io_uring can make use of this
regardless. That's easy to add however.

If we do go down that road, we can be even stricter/vary what we do at
different levels right?

>
> > Jason will have some thoughts on this I'm sure. I guess the key question
> > here is - is it actually feasible for this to work at all? Once we
> > establish that, the rest are details :)
>
> Surely it is, but like Ted said, the FS folks are not interested and
> they are at least half the solution..

:'(

>
> The FS also has to actively not write out the page while it cannot be
> write protected unless it copies the data to a stable page. The block
> stack needs the source data to be stable to do checksum/parity/etc
> stuff. It is a complicated subject.

Yes my sense was that being able to write arbitrarily to these pages _at
all_ was a big issue, not only the dirty tracking aspect.

I guess at some level letting filesystems have such total flexibility as to
how they implement things leaves us in a difficult position.

>
> Jason

