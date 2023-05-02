Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D806F4931
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbjEBRfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbjEBRfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:35:01 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8EC10D9;
        Tue,  2 May 2023 10:34:19 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f19b9d5358so41215475e9.1;
        Tue, 02 May 2023 10:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683048857; x=1685640857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3UgLddjkHIg2a43YemgHaCt+QBmXeXskji4qIT5rtw8=;
        b=Ao5JI1alD7DgI+d6pCbXv0LEtRlV3U84XxStQ9NleMu8V3R9GYgBnVWm8YoSAm71Wa
         ntGorG7vEZGvwySwKgSU+FLhXKtfU5/fd7yY1Xazt8ZYJoKTUTNk8+zllRlulgFcSoT5
         Acthh5do5CP+EjXcnNOHCIzvFr49g2Lo75XuSe/t9Uup4GIphVF9JV5+ryxpbr4BDMdS
         kLkBMMTQRh2So04dLmKVXOiBw683mIUB2gQR14AMDnBnrRidhTKwECAhsAv2riseoeLy
         HDsDwvjLuxRKVX7odLIm5oijlEHVqccUX1MpFrga45j8iJcLePlh9GpxVRIvO+UVw4zm
         6LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683048857; x=1685640857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UgLddjkHIg2a43YemgHaCt+QBmXeXskji4qIT5rtw8=;
        b=LjK1msf4Vo5HV68a5Dr8m4Qahm445pwKkuAdkyAocDN7LGAmhoOPrusZkZbNguuV/x
         1G0GnlAptPuAf0Y2/VMHpL89qUtE9V7Kgie5geV3KXrLdb4Fg9zSv1N1mUnzUA+aw0Ii
         jWVF5zMXA4J8OCRoUL4twLSTYJgavGvMM+at82QeV7iZ4KSX3nu3ttC/NJew9YnbM1EH
         FFNHNRFtEi/APWrrbHX/6VAdysBYi2ZlzBiWIwLZ/mhxzRi+7eicVxM7ipXlEHnOD/2m
         NQgNmwiU8XRXhEAjgLFOk5+UlCMG3VXt1aSLKsytrsjYaAt38c8paP0Cdjdji1ka3tvJ
         Y8fw==
X-Gm-Message-State: AC+VfDzqml65wSw6HeIE5OB/I+qJll6ejTZe6FoOxjjVXrf8VKJ4Hi1C
        3wg7MTYTsIrntxPpB20c7siqzvLiaGapAQ==
X-Google-Smtp-Source: ACHHUZ7b85L6+LUsBFJD+tnhEjxFFCRDnSzY0aCIqOHHgnTb5/okLOWnD8QQ17TrR/t6156C/0fZWQ==
X-Received: by 2002:a05:600c:21c8:b0:3f1:745d:821 with SMTP id x8-20020a05600c21c800b003f1745d0821mr12599496wmj.23.1683048857363;
        Tue, 02 May 2023 10:34:17 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003f179fc6d8esm35912012wml.44.2023.05.02.10.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:34:16 -0700 (PDT)
Date:   Tue, 2 May 2023 18:34:16 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <a6992b07-7bce-44ac-87db-7e7db06782b6@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 07:22:32PM +0200, Peter Zijlstra wrote:
> On Tue, May 02, 2023 at 07:13:49PM +0200, David Hildenbrand wrote:
> > [...]
> >
> > > +{
> > > +	struct address_space *mapping;
> > > +
> > > +	/*
> > > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > > +	 * to disappear from under us, as well as preventing RCU grace periods
> > > +	 * from making progress (i.e. implying rcu_read_lock()).
> > > +	 *
> > > +	 * This means we can rely on the folio remaining stable for all
> > > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > +	 * and those that do not.
> > > +	 *
> > > +	 * We get the added benefit that given inodes, and thus address_space,
> > > +	 * objects are RCU freed, we can rely on the mapping remaining stable
> > > +	 * here with no risk of a truncation or similar race.
> > > +	 */
> > > +	lockdep_assert_irqs_disabled();
> > > +
> > > +	/*
> > > +	 * If no mapping can be found, this implies an anonymous or otherwise
> > > +	 * non-file backed folio so in this instance we permit the pin.
> > > +	 *
> > > +	 * shmem and hugetlb mappings do not require dirty-tracking so we
> > > +	 * explicitly whitelist these.
> > > +	 *
> > > +	 * Other non dirty-tracked folios will be picked up on the slow path.
> > > +	 */
> > > +	mapping = folio_mapping(folio);
> > > +	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
> >
> > "Folios in the swap cache return the swap mapping" -- you might disallow
> > pinning anonymous pages that are in the swap cache.
> >
> > I recall that there are corner cases where we can end up with an anon page
> > that's mapped writable but still in the swap cache ... so you'd fallback to
> > the GUP slow path (acceptable for these corner cases, I guess), however
> > especially the comment is a bit misleading then.
> >
> > So I'd suggest not dropping the folio_test_anon() check, or open-coding it
> > ... which will make this piece of code most certainly easier to get when
> > staring at folio_mapping(). Or to spell it out in the comment (usually I
> > prefer code over comments).
>
> So how stable is folio->mapping at this point? Can two subsequent reads
> get different values? (eg. an actual mapping and NULL)
>
> If so, folio_mapping() itself seems to be missing a READ_ONCE() to avoid
> the compiler from emitting the load multiple times.

Yes that actually feels like a bit of a flaw in folio_mapping(). I suppose
we run the risk of mapping being reset (e.g. to NULL) even if any mapping
we get being guaranteed to be safe due to the RCU thing.

Based on David's feedback I think I'll recode to something more direct
where we READ_ONCE() the mapping, then check mapping flags for anon, avoid
the swap case + check shmem.
