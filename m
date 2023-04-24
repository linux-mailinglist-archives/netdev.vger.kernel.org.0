Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8D06ED447
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjDXSWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjDXSWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:22:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92467123;
        Mon, 24 Apr 2023 11:22:07 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-2fe3fb8e25fso2894026f8f.0;
        Mon, 24 Apr 2023 11:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682360526; x=1684952526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GNWb62e8CZIjs8fCUmW4pdVL9gTqXJEWDD+orJ1zuz0=;
        b=H5waO2lVV3WBPBob6qcwDjzXxuUC5G8iugaCsakCau25e2nQVZkCEflYqfjCA79/+y
         NPM55qPl5re3i0yMT/YrYCQH9VeeIYZQYU8OJJtaglvYTDa5raa6jLqgPkNeeN3oT7wa
         P14wmAxZ2C2upU4ckUa+UiOKhgQv5ylRFql5AedoiuiJpk3cvv3kthNbfSPcBzdfOjLw
         LFUmc0hsGAouMZd5Bq+mYaqFJspu6z4HesNUuf0ImsN7FEwgKhYb0QjwGwbr13jrAg9B
         GAHkLUSMmAK1tNQwgf0vGKwQWwvZdAKrZS+YsNwcA/7TxUctioZnm0lMHRwQdhNuulVT
         sJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682360526; x=1684952526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNWb62e8CZIjs8fCUmW4pdVL9gTqXJEWDD+orJ1zuz0=;
        b=CAlNRDerE+Dgjs3BLFDp/kxmeepcAywH5cm8ZFzosLuuWt+EAJmXyEqDTaUg4DB1CM
         /NH26WbpA4i41hS0WYO0VTIVcuYdPTEo6hce+JbhTNjP/qkY5TmAQb3jSuJtdGnQOwN+
         1cXacfzBtaPhMg4hvCYAQwAWpgf5b+6frp35ZtSQi5gWT5RPArUmQB5EcfhSsdb8Duqv
         APCip29aQRdhCVfv/2uRN3fhIN+xMUz0m842bidR7vyw/aI1ttkZs78mxPoCLnoRDRVW
         DfJDetgbYm0X/j4LlTDSkLwS/4l/yt31gqVx3EkwMafeHFvD9IQ+zUjiCtzsw81TZ1wS
         6XoA==
X-Gm-Message-State: AAQBX9dQXqvCrPykzbtgNmaV2mxlf9sZT4ynkhk6ujDMMEZcdzLJGuq5
        B+1ynsXriPiEbhWZTCEj6VE=
X-Google-Smtp-Source: AKy350axh1bla12sBBL0jXPnMeWce8zQbehX+yTZ5r+1QdjTUe4lwDcOG4wov94gQPDhdmEZFp/48w==
X-Received: by 2002:adf:f983:0:b0:2ef:ba4f:c821 with SMTP id f3-20020adff983000000b002efba4fc821mr8354283wrr.36.1682360525728;
        Mon, 24 Apr 2023 11:22:05 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id z18-20020adfe552000000b002f3e1122c1asm11316412wrm.15.2023.04.24.11.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 11:22:05 -0700 (PDT)
Date:   Mon, 24 Apr 2023 19:22:03 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEa+L5ivNDhCmgj4@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 02:36:47PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 03:29:57PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Apr 24, 2023 at 10:39:25AM -0300, Jason Gunthorpe wrote:
> > > On Mon, Apr 24, 2023 at 01:38:49PM +0100, Lorenzo Stoakes wrote:
> > >
> > > > I was being fairly conservative in that list, though we certainly need to
> > > > set the flag for /proc/$pid/mem and ptrace to avoid breaking this
> > > > functionality (I observed breakpoints breaking without it which obviously
> > > > is a no go :). I'm not sure if there's a more general way we could check
> > > > for this though?
> > >
> > > More broadly we should make sure these usages of GUP safe somehow so
> > > that it can reliably write to those types of pages without breaking
> > > the current FS contract..
> > >
> > > I forget exactly, but IIRC, don't you have to hold some kind of page
> > > spinlock while writing to the page memory?
> > >
> >
> > I think perhaps you're thinking of the mm->mmap_lock? Which will be held
> > for the FOLL_GET cases and simply prevent the VMA from disappearing below
> > us but not do much else.
>
> No not mmap_lock, I want to say there is a per-page lock that
> interacts with the write protect, or at worst this needs to use the
> page table spinlocks.
>
> > I wonder whether we should do this check purely for FOLL_PIN to be honest?
> > As this indicates medium to long-term access without mmap_lock held. This
> > would exclude the /proc/$pid/mem and ptrace paths which use gup_remote().
>
> Everything is buggy. FOLL_PIN is part of a someday solution to solve
> it.
>
> > That and a very specific use of uprobes are the only places that use
> > FOLL_GET in this instance and each of them are careful in any case to
> > handle setting the dirty page flag.
>
> That is actually the bug :) Broadly the bug is to make a page dirty
> without holding the right locks to actually dirty it.
>
> Jason

OK I guess you mean the folio lock :) Well there is
unpin_user_pages_dirty_lock() and unpin_user_page_range_dirty_lock() and
also set_page_dirty_lock() (used by __access_remote_vm()) which should
avoid this.

Also __access_remote_vm() which all the ptrace and /proc/$pid/mem use does
set_page_dirty_lock() and only after the user actually writes to it (and
with FOLL_FORCE of course).

None of these are correctly telling a write notify filesystem about the
change, however.

We definitely need to keep ptrace and /proc/$pid/mem functioning correctly,
and I given the privilege levels required I don't think there's a security
issue there?

I do think the mkwrite/write notify file system check is the correct one as
these are the only ones to whom the page being dirty would matter to.

So perhaps we can move forward with:-

- Use mkwrite check rather than shmem/hugetlb.
- ALWAYS enforce not write notify file system if FOLL_LONGTERM (that
  removes a lot of the changes here).
- If FOLL_FORCE, then allow this to override the check. This is required
  for /proc/$pid/mem and ptrace and is a privileged operation anyway, so
  can not cause a security issue.
- Add a FOLL_WILL_UNPIN_DIRTY flag to indicate that the caller will
  actually do so (required for process_vm_access cases).

Alternatively we could implement something very cautious and opt-in, like a
FOLL_CHECK_SANITY flag? (starting to feel like I need one of those myself :)
