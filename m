Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5346F48B8
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbjEBQ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbjEBQ5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:57:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DB11B5;
        Tue,  2 May 2023 09:56:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f3fe12de15so2488810f8f.3;
        Tue, 02 May 2023 09:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683046617; x=1685638617;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Mz3JgO9OUCyyg+clVKpi+PwVnMhBmUNWeJf+PIlmL0=;
        b=YLe+yDaVxFClxNu5+FYujakGSXI2o0gxsrkV2oa7Rx0LaKaMcN4hLywkiAFQw4mIVZ
         jMq8HjJfIi+8kXszOEIKOrGM9G8cLbKO1mxf6Od7Fm+1Mo8/gEGgtR498cap93ZMfohR
         X3EpKudwLflHJTcBqzoz2RgB7Xnaxa1Rc1Z4GoPWxvKkyv0IXGpAyhyUK2Cel7cdYquv
         jjQxBidYnW8MdtddvqtpuWWfH0Djds0tPrdHO6/2r8l8G2xG+6erbuYeixxJK4NSKr/z
         ieU+f9xPm0BDzg8RRpvkM47NdWkWQvcOB/2qncvQ4ybPks8nu+WPaTt95Wtukp5Gp0aY
         MLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683046617; x=1685638617;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mz3JgO9OUCyyg+clVKpi+PwVnMhBmUNWeJf+PIlmL0=;
        b=Rxpu7VzbzG5wTFcDAt5RE70nOfEP7PSoudZAjQEB4jlO0aY9QrcV8oC5M0mSFY794/
         hAXvjtEihjT2EW53hAjGdoDELa1307wySsFjlABrLY0D4GZvoSdtT6XsNPi7emLLcADT
         VLEYdbDv7Th5CKx1H2So20cHSi+BlE9+TirxILgOb1kpkwQrlwdPZQPxlzVqsf4qOGfj
         zUrGcYivURYO/pYq4QQikIdT9kU0hu0k5YgjhmwPFKVQ5yebrovmzzuMzNJ6G81TUNb9
         gC6o/r92hhOL9UpHjpSwrEsRf/CGqnAsKiA3IcIYItT2nQBc0nnx90eIuD9njZA1iJM4
         Imlw==
X-Gm-Message-State: AC+VfDynug4SvpHvBUzHUnyxdKQ2rOCehGkJKCW530uMRYG+90aVJHDN
        y5DfXPruYHSya42+4d6o3hE=
X-Google-Smtp-Source: ACHHUZ6xMmKXk0IW6/9L20YwWYpDscnA60peDf9+FOfwJLapZIRRykIV3S8fvm1p9DkmoZdPXLe2VQ==
X-Received: by 2002:a5d:5403:0:b0:306:434:f8ef with SMTP id g3-20020a5d5403000000b003060434f8efmr6852011wrv.70.1683046616571;
        Tue, 02 May 2023 09:56:56 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id v17-20020a5d43d1000000b003047ea78b42sm21955179wrr.43.2023.05.02.09.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 09:56:55 -0700 (PDT)
Date:   Tue, 2 May 2023 17:56:55 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v7 2/3] mm/gup: disallow FOLL_LONGTERM GUP-nonfast
 writing to file-backed mappings
Message-ID: <a97ec47d-5ef1-4c0c-8ba4-a8287047d0f6@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <f50f2b5794820a1f5dc597277a5f0a9a87d9d152.1683044162.git.lstoakes@gmail.com>
 <d2ca4a03-dd7e-29d8-d932-4ee5a31e1ab2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2ca4a03-dd7e-29d8-d932-4ee5a31e1ab2@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 06:42:42PM +0200, David Hildenbrand wrote:
> On 02.05.23 18:34, Lorenzo Stoakes wrote:
> > Writing to file-backed mappings which require folio dirty tracking using
> > GUP is a fundamentally broken operation, as kernel write access to GUP
> > mappings do not adhere to the semantics expected by a file system.
> >
> > A GUP caller uses the direct mapping to access the folio, which does not
> > cause write notify to trigger, nor does it enforce that the caller marks
> > the folio dirty.
> >
> > The problem arises when, after an initial write to the folio, writeback
> > results in the folio being cleaned and then the caller, via the GUP
> > interface, writes to the folio again.
> >
> > As a result of the use of this secondary, direct, mapping to the folio no
> > write notify will occur, and if the caller does mark the folio dirty, this
> > will be done so unexpectedly.
> >
> > For example, consider the following scenario:-
> >
> > 1. A folio is written to via GUP which write-faults the memory, notifying
> >     the file system and dirtying the folio.
> > 2. Later, writeback is triggered, resulting in the folio being cleaned and
> >     the PTE being marked read-only.
> > 3. The GUP caller writes to the folio, as it is mapped read/write via the
> >     direct mapping.
> > 4. The GUP caller, now done with the page, unpins it and sets it dirty
> >     (though it does not have to).
> >
> > This results in both data being written to a folio without writenotify, and
> > the folio being dirtied unexpectedly (if the caller decides to do so).
> >
> > This issue was first reported by Jan Kara [1] in 2018, where the problem
> > resulted in file system crashes.
> >
> > This is only relevant when the mappings are file-backed and the underlying
> > file system requires folio dirty tracking. File systems which do not, such
> > as shmem or hugetlb, are not at risk and therefore can be written to
> > without issue.
> >
> > Unfortunately this limitation of GUP has been present for some time and
> > requires future rework of the GUP API in order to provide correct write
> > access to such mappings.
> >
> > However, for the time being we introduce this check to prevent the most
> > egregious case of this occurring, use of the FOLL_LONGTERM pin.
> >
> > These mappings are considerably more likely to be written to after
> > folios are cleaned and thus simply must not be permitted to do so.
> >
> > This patch changes only the slow-path GUP functions, a following patch
> > adapts the GUP-fast path along similar lines.
> >
> > [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> > Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   mm/gup.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/gup.c b/mm/gup.c
> > index ff689c88a357..6e209ca10967 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -959,16 +959,53 @@ static int faultin_page(struct vm_area_struct *vma,
> >   	return 0;
> >   }
> > +/*
> > + * Writing to file-backed mappings which require folio dirty tracking using GUP
> > + * is a fundamentally broken operation, as kernel write access to GUP mappings
> > + * do not adhere to the semantics expected by a file system.
> > + *
> > + * Consider the following scenario:-
> > + *
> > + * 1. A folio is written to via GUP which write-faults the memory, notifying
> > + *    the file system and dirtying the folio.
> > + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> > + *    the PTE being marked read-only.
> > + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> > + *    direct mapping.
> > + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> > + *    (though it does not have to).
> > + *
> > + * This results in both data being written to a folio without writenotify, and
> > + * the folio being dirtied unexpectedly (if the caller decides to do so).
> > + */
> > +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> > +					   unsigned long gup_flags)
> > +{
> > +	/*
> > +	 * If we aren't pinning then no problematic write can occur. A long term
> > +	 * pin is the most egregious case so this is the case we disallow.
> > +	 */
> > +	if (!(gup_flags & (FOLL_PIN | FOLL_LONGTERM)))
> > +		return true;
>
> If you really want to keep FOLL_PIN here ... this has to be
>
> if ((gup_flags & (FOLL_PIN | FOLL_LONGTERM)) != (FOLL_PIN | FOLL_LONGTERM))
>
> or two separate checks.
>
> Otherwise you'd also proceed if only FOLL_PIN is set.
>
> Unless my tired eyes betrayed me.

Your tired eyes are rapidly taking on the firey visage of the dark lord
Sauron...  but also, ugh god pints_owed_to_myself++.

Sorry this was a me rushing it out of shame thing. Will fix on
respin... apologies for spam everyone :)

>
>
> --
> Thanks,
>
> David / dhildenb
>
