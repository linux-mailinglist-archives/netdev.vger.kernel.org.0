Return-Path: <netdev+bounces-2613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CB7702B3A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 880F51C20AC0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9BBC12B;
	Mon, 15 May 2023 11:16:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6009F1C13;
	Mon, 15 May 2023 11:16:27 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7551725;
	Mon, 15 May 2023 04:16:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-965e4be7541so2192559866b.1;
        Mon, 15 May 2023 04:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684149384; x=1686741384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=knPSlIoi8JJlfvyB9MqyozwzNx+4xRNl0fuueJdn78w=;
        b=TDrCEU8FuW3hDweQ5bwdycEiJjcobOp3IpmpMjXkU7AaTDL+TdsNmJoEXoMEQMruop
         GIScUD01CMAgF/1mC0SD1gv77x0WiGT8QjnQz3Ma4Wy//I36ne/NL9Vd6iTB4U/wlThq
         8bcQj7xmcYxzSNb8+GF2+O52JpZVE3ZVfzvvS9BdKzWQ/h6Hi1zStdC9/TvhYq1OvFiZ
         yiDCT/F8jkXfyg5LlWU+wYh3CYKCnwZ0lwdXgeg2isHG83ddUTkj5mfHqhUVBQxKGfCR
         yBPB/bdHdisdWue0ctSmOENHVHpaiuH7A0vEFCI7gdMD9Hhe0ViXPRv77UOveUz2UpaD
         egdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684149384; x=1686741384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knPSlIoi8JJlfvyB9MqyozwzNx+4xRNl0fuueJdn78w=;
        b=YOZPGPHbI3+bc1mWlznQm85z5ZBg6mNgZtk75WKVHb6y1cFRPyD02mt1nunikmi9Qb
         Cu2Faa1TjOonCkL2ZXpIrv0b9xHd5s1dJOsWhgMFXwSAEhEhNj6x6dUnbDhHyGklw3vY
         bKiJWXwYbTQYRTz9mmEMri6GFwyjx2kOP3Pr1eUAO3CwT6xsGss3GSbVN+trZsja1S3H
         F+9blB7rXOLGh0aqMVyL+jMf3yebULx8e+2N4wKL5pBJNkx0n9yhTa2PO3Q06P6Y9Gef
         BRgCEPESzvdHYH1nuvAWz+zWe/mfmHsq+IdmJoB/8Ac4lhx3Yfype/4ag/GoRpmGvj6b
         vTPg==
X-Gm-Message-State: AC+VfDwhWweuxnl3W1sSZgth6W5xyqjq7IvMR9ZFrFKdSrExAZ1gkTBB
	Uh73sSk7rDiuPmkODXy8zgY=
X-Google-Smtp-Source: ACHHUZ7WHM6iw+dCrh6+o/s11/K9CwCF/i+8iSZDcuGO4RTTrbL4NWF45E3g1pqnoenQBo6gAyOXSw==
X-Received: by 2002:a17:906:9c83:b0:94f:449e:75db with SMTP id fj3-20020a1709069c8300b0094f449e75dbmr32016828ejc.52.1684149383725;
        Mon, 15 May 2023 04:16:23 -0700 (PDT)
Received: from localhost ([31.94.21.70])
        by smtp.gmail.com with ESMTPSA id wi21-20020a170906fd5500b0094edbe5c7ddsm9460583ejb.38.2023.05.15.04.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 04:16:22 -0700 (PDT)
Date: Mon, 15 May 2023 12:16:21 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: "Kirill A . Shutemov" <kirill@shutemov.name>
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
Message-ID: <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 02:03:15PM +0300, Kirill A . Shutemov wrote:
> On Thu, May 04, 2023 at 10:27:50PM +0100, Lorenzo Stoakes wrote:
> > Writing to file-backed mappings which require folio dirty tracking using
> > GUP is a fundamentally broken operation, as kernel write access to GUP
> > mappings do not adhere to the semantics expected by a file system.
> >
> > A GUP caller uses the direct mapping to access the folio, which does not
> > cause write notify to trigger, nor does it enforce that the caller marks
> > the folio dirty.
>
> Okay, problem is clear and the patchset look good to me. But I'm worried
> breaking existing users.
>
> Do we expect the change to be visible to real world users? If yes, are we
> okay to break them?

The general consensus at the moment is that there is no entirely reasonable
usage of this case and you're already running the riks of a kernel oops if
you do this, so it's already broken.

>
> One thing that came to mind is KVM with "qemu -object memory-backend-file,share=on..."
> It is mostly used for pmem emulation.
>
> Do we have plan B?

Yes, we can make it opt-in or opt-out via a FOLL_FLAG. This would be easy
to implement in the event of any issues arising.

>
> Just a random/crazy/broken idea:
>
>  - Allow folio_mkclean() (and folio_clear_dirty_for_io()) to fail,
>    indicating that the page cannot be cleared because it is pinned;
>
>  - Introduce a new vm_operations_struct::mkclean() that would be called by
>    page_vma_mkclean_one() before clearing the range and can fail;
>
>  - On GUP, create an in-kernel fake VMA that represents the file, but with
>    custom vm_ops. The VMA registered in rmap to get notified on
>    folio_mkclean() and fail it because of GUP.
>
>  - folio_clear_dirty_for_io() callers will handle the new failure as
>    indication that the page can be written back but will stay dirty and
>    fs-specific data that is associated with the page writeback cannot be
>    freed.
>
> I'm sure the idea is broken on many levels (I have never looked closely at
> the writeback path). But maybe it is good enough as conversation started?
>

Yeah there are definitely a few ideas down this road that might be
possible, I am not sure how a filesystem can be expected to cope or this to
be reasonably used without dirty/writeback though because you'll just not
track anything or I guess you mean the mapping would be read-only but
somehow stay dirty?

I also had ideas along these lines of e.g. having a special vmalloc mode
which mimics the correct wrprotect settings + does the right thing, but of
course that does nothing to help DMA writing to a GUP-pinned page.

Though if the issue is at the point of the kernel marking the page dirty
unexpectedly, perhaps we can just invoke the mkwrite() _there_ before
marking dirty?

There are probably some sycnhronisation issues there too.

Jason will have some thoughts on this I'm sure. I guess the key question
here is - is it actually feasible for this to work at all? Once we
establish that, the rest are details :)

> --
>   Kiryl Shutsemau / Kirill A. Shutemov

