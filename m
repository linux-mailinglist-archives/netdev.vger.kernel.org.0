Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98B56F4445
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbjEBMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjEBMwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:52:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E99EE4D;
        Tue,  2 May 2023 05:52:20 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-2f40b891420so3612259f8f.0;
        Tue, 02 May 2023 05:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683031939; x=1685623939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgwBcf7DhZhRTBqFpSufVvlB/n4MHMrRDDLyfB3lDk8=;
        b=RTXVfHTQcYWexO8uKN4oGh7/UbDzqHFdpYK9PCwoAdzgWP2NG/zuT+WQ8hBJxyxSal
         7E2hDW9yo9dKRz4XU8FVvhKw8yM2AAZBPDBp8qGqBtkZ5yRt8nu5FxusbEUcYf3lTohH
         1t4yl6qx5lbtlGON9lRmoX8dCRpqmIJGWFMTfivpxQ9kXIh5yORMdd96zBeDsJGtsg32
         GFoR0TxTwX/BbYCOyy4PbKdzhFXOBKO7S7xFn4tJDGnJTnosOyQhvVJlzMsvmCtYZ+h0
         sXTYLyAGSYxx38UKmxt9v/mQeBoxilLUFoqiLY9gtwa1ZIY6G7g+OfsfFgd3MtRhaahE
         jwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683031939; x=1685623939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgwBcf7DhZhRTBqFpSufVvlB/n4MHMrRDDLyfB3lDk8=;
        b=N06bS1S5DD70U5qBpn1PkygeklkNiZntrFwwEZH4KWXB2RNzR3K3vlcKh6P0vBwF9s
         aWh4M32ID27L2oYN7/tlnu0t+JXHYAT+GCXO2KG6/5tKbpEFuDNpW77av85XRwARdv6+
         qoFUnsa9CclyKlPHLSKnUq28I6OCFHMgYpny/aOSJ0oMx1JMO57xVdkVwCUhegRazKmc
         jFn8NcdQMB2hVkqKhN4fyIxibULGpHUq18+Eg+CFsx1qZ6UUfwAUA3V+7AaqCCQm8qXd
         BCI2YiYG0XApZcc+8aIAWHXGlfQZCVJ5eBtU6ddDaGlnBDzqDsGB6PZDjkVMyr1YixE7
         /j3A==
X-Gm-Message-State: AC+VfDyoKhU3CZcHSiPXl3vmJR1cdhhVR3URyX6FrmxepUdRT+CpQGp9
        hPDI66I5Rs3vEl1Q647/Uxo=
X-Google-Smtp-Source: ACHHUZ5JpfJxILvMgYMoFZ7s8DTGKSLgm5Nh7/7J6kRKyFAC3eUsj7RlfYPNnWakTy//xgA4VId9Qw==
X-Received: by 2002:adf:f491:0:b0:306:35d1:7a98 with SMTP id l17-20020adff491000000b0030635d17a98mr2068400wro.8.1683031938861;
        Tue, 02 May 2023 05:52:18 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id f11-20020adffccb000000b002f90a75b843sm30912077wrs.117.2023.05.02.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 05:52:17 -0700 (PDT)
Date:   Tue, 2 May 2023 13:52:17 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Paul McKenney <paulmck@kernel.org>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <4529b057-19ae-408b-8433-7d220f1871c0@lucifer.local>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
 <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
 <20230502124058.GB1597602@hirez.programming.kicks-ass.net>
 <a597947b-6aba-bd8d-7a97-582fa7f88ad2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a597947b-6aba-bd8d-7a97-582fa7f88ad2@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:47:22PM +0200, David Hildenbrand wrote:
> On 02.05.23 14:40, Peter Zijlstra wrote:
> > On Tue, May 02, 2023 at 02:08:10PM +0200, Peter Zijlstra wrote:
> >
> > > > >
> > > > >
> > > > > 	if (folio_test_anon(folio))
> > > > > 		return true;
> > > >
> > > > This relies on the mapping so belongs below the lockdep assert imo.
> > >
> > > Oh, right you are.
> > >
> > > > >
> > > > > 	/*
> > > > > 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
> > > > > 	 * grace periods from making progress, IOW. they imply
> > > > > 	 * rcu_read_lock().
> > > > > 	 */
> > > > > 	lockdep_assert_irqs_disabled();
> > > > >
> > > > > 	/*
> > > > > 	 * Inodes and thus address_space are RCU freed and thus safe to
> > > > > 	 * access at this point.
> > > > > 	 */
> > > > > 	mapping = folio_mapping(folio);
> > > > > 	if (mapping && shmem_mapping(mapping))
> > > > > 		return true;
> > > > >
> > > > > 	return false;
> > > > >
> > > > > > +}
> >
> > So arguably you should do *one* READ_ONCE() load of mapping and
> > consistently use that, this means open-coding both folio_test_anon() and
> > folio_mapping().
>
> Open-coding folio_test_anon() should not be required. We only care about
> PAGE_MAPPING_FLAGS stored alongside folio->mapping, that will stick around
> until the anon page was freed.
>

Ack, good point!

> @Lorenzo, you might also want to special-case hugetlb directly using
> folio_test_hugetlb().
>

I already am :) I guess you mean when I respin along these lines? Will port
that across to.

> --
> Thanks,
>
> David / dhildenb
>
