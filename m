Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024796F1B99
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345874AbjD1PdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjD1PdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:33:10 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EDA1FEF;
        Fri, 28 Apr 2023 08:33:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f19afc4fbfso79652085e9.2;
        Fri, 28 Apr 2023 08:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682695988; x=1685287988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KMHIByqgzKX5KpQ4bHSlED4BSShXTm+SWiPBiUyvnSM=;
        b=O+t4mr5YwIBx3mvPK9FXQtoztY+ksuoUQgsUNkW7Bp2xz8ETDEZabCuPcWeLl9uXwx
         tR5M7P9lGtnhD9iyom3vG3Oyhzq1sC9Tr/rgJ6yiyJwoxDD4oAKSeMFpvDlZp7Fu7I7B
         2sF4qeKJiN6QzcsyBGQPhKYVBS/HY08UuieEvSiOI9qNEdWhQ/XPvEn8KZxHMxFdVob1
         OxXJGjLDvajQrGQovrJHDiDCnqzbmZiMZNnyJU9DLOi8uLyZv2sTsnryXQiPY62q+KqP
         +DHJi7rUT9zIgQMqHxq38A5aYzxmZRrEWuV6aaSuQbYPm36McQPkkUj0WMb4TqC3xpaa
         gkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682695988; x=1685287988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMHIByqgzKX5KpQ4bHSlED4BSShXTm+SWiPBiUyvnSM=;
        b=aJxobEAnpr8s/dOIqWmffCUG7Plj7iLkyi3xF61yXYpgzly/Qm8NGvRJgAQyM46S3c
         xRn/vyhRxls/dtcGj883pacyHbVTFOOkyqOTM+HkJ9Y5vIk1HnqPtyWoLjyYOrpnkwyL
         kewGQSaMJP2pb0vhIhMZsQJLZzaYOjgQwlKZ4wjQGhnEglg8pY09+7+/LxBjrOMRRMHd
         TeA9AcSuid9jRpCabyr51dCoMc8DIPENCJ/6IUBzI9uay4w5/GsKCxaPElRk9FOMtJVd
         wej/+iEoPk5HvtUKp03Sc6vHuzOO6iHBcCIM8y5ZyEe5GikAaTHx8Rm+eAYraysuR1MU
         N3Bw==
X-Gm-Message-State: AC+VfDxOz2c+x2BTgsGlkSaxdGALasJ6oua25oWwkxUZ6S21LtsLlV9I
        XDRzvVj2v4ZmCNzwySU8kuY=
X-Google-Smtp-Source: ACHHUZ5E3zXFf2PGZTFl9bdasg140xVZ3fuHO2RbcwJ8jcYX+iOoxmrv2IPRwomx6VVZ3LBLmWvgYg==
X-Received: by 2002:a05:600c:213:b0:3f1:8223:6683 with SMTP id 19-20020a05600c021300b003f182236683mr4362504wmi.40.1682695987867;
        Fri, 28 Apr 2023 08:33:07 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id ay37-20020a05600c1e2500b003f18b52c73asm24474839wmb.24.2023.04.28.08.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 08:33:07 -0700 (PDT)
Date:   Fri, 28 Apr 2023 16:33:06 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
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
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > >
> > > Security is the primary case where we have historically closed uAPI
> > > items.
> >
> > As this patch
> >
> > 1) Does not tackle GUP-fast
> > 2) Does not take care of !FOLL_LONGTERM
> >
> > I am not convinced by the security argument in regard to this patch.
> >
> >
> > If we want to sells this as a security thing, we have to block it
> > *completely* and then CC stable.
>
> Regarding GUP-fast, to fix the issue there as well, I guess we could do
> something similar as I did in gup_must_unshare():
>
> If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> fallback to ordinary GUP. IOW, if we don't know, better be safe.

How do we determine it's non-anon in the first place? The check is on the
VMA. We could do it by following page tables down to folio and checking
folio->mapping for PAGE_MAPPING_ANON I suppose?

>
> Of course, this would prevent hugetlb/shmem from getting pinned writable
> during gup-fast. Unless we're able to whitelist them somehow in there.

We could degrade those to non-fast assuming not FOLL_FAST_ONLY. But it'd be
a pity.

>
>
> For FOLL_LONGTERM it might fairly uncontroversial. For everything else I'm
> not sure if there could be undesired side-effects.

Yeah this is why I pared the patch down to this alone :) there are
definitely concerns and issues with other cases, notably ptrace + friends
but obviously not only.

FOLL_LONGTERM is just the most egregious case.

>
> --
> Thanks,
>
> David / dhildenb
>
