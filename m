Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E716EC213
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDWTlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWTlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:41:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C254F1;
        Sun, 23 Apr 2023 12:41:00 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2fe3fb8e25fso2128440f8f.0;
        Sun, 23 Apr 2023 12:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682278859; x=1684870859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9DaWjR3sBt/MB4A/BsoBVVrHZIqBShz9wV60JqEIpNw=;
        b=OTvbplYFel6puUd9xiVtcmdFcIopxiUAKTZ3clqSvTurQ7cm0qEwdzp46/cpNTJzQU
         aMeUhMsxKMMw4vogrT72mv362gDPONVE/mW4rAONfsNiswuEm4G8NQ9TQr/4mhzqxthc
         EPtYvANUtrimsfAe+QxnhtiiIICjlKgvKLypNhfcqDWM4QskqliaM3fpcA4XH5L8Gxs5
         UtGT85QM5CHQDBzQ32Ua5Q0yJTPLApaAubXw4+qeT3fR28WAa3Eiw2I77HMyt4R0HaPm
         XImq/wiODepque1bHxqzsttdrXm0FZ8jlLGdO+rECHQp/nWkgeHUU3cug2joDC8CStjT
         QnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682278859; x=1684870859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DaWjR3sBt/MB4A/BsoBVVrHZIqBShz9wV60JqEIpNw=;
        b=Kzc9kZLkmDea3ZdXGvY4VhAmjXUlwmN5cRAeBuf5BIePsJuUmjGPdNALyKcnMvkzps
         PziVp1Bm8VMiP2OMmiKzTrgvMH5lg1u8qILHg9S7FNRRRgpxnUhHKjQFXWuABALGNg9Z
         C5TT0+cmnlvjdrXj0sVQpg1AgVmkhLgFZNxDXbvlxuFO7FM/APLiKpXObNEB6N4jrQYS
         44HGo/TcrggZUmJHnQWR4UXnBcVzJh/aBvD8tSTx3iworrbqOub+QZUQCSwbA1BW02FZ
         bWA6F4AjPsBkPjXVYDPSJMR2zrRjGkRSVsyLXOA6qLnWe3HvNT5iXmlF54NQB5ppM/Vm
         p1vw==
X-Gm-Message-State: AAQBX9dFxOOoTb8X6iwaha7cPU0xf5WY1irWauMz4iu4iAMzjAUixLdx
        xn07uVEw7pl1diPUPDPiQ10=
X-Google-Smtp-Source: AKy350b9aO+LV11OiBsG9rW4u8x8e9dMZwYimrCx5RyjHTWA/fxDg8WSB6/q0lYDlBi1IOI9Sl7VYg==
X-Received: by 2002:adf:eb4d:0:b0:2f4:d4f2:e2dd with SMTP id u13-20020adfeb4d000000b002f4d4f2e2ddmr8457564wrn.41.1682278858573;
        Sun, 23 Apr 2023 12:40:58 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id d13-20020adfe88d000000b002e55cc69169sm9223073wrm.38.2023.04.23.12.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:40:57 -0700 (PDT)
Date:   Sun, 23 Apr 2023 20:40:53 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <a6ceb82a-1766-4229-ba33-b6f25e111561@lucifer.local>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <ZEWHsbxhQlrSqnSC@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEWHsbxhQlrSqnSC@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 09:32:01PM +0200, Simon Horman wrote:
> On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> > It isn't safe to write to file-backed mappings as GUP does not ensure that
> > the semantics associated with such a write are performed correctly, for
> > instance filesystems which rely upon write-notify will not be correctly
> > notified.
> >
> > There are exceptions to this - shmem and hugetlb mappings are (in effect)
> > anonymous mappings by other names so we do permit this operation in these
> > cases.
> >
> > In addition, if no pinning takes place (neither FOLL_GET nor FOLL_PIN is
> > specified and neither flags gets implicitly set) then no writing can occur
> > so we do not perform the check in this instance.
> >
> > This is an important exception, as populate_vma_page_range() invokes
> > __get_user_pages() in this way (and thus so does __mm_populate(), used by
> > MAP_POPULATE mmap() and mlock() invocations).
> >
> > There are GUP users within the kernel that do nevertheless rely upon this
> > behaviour, so we introduce the FOLL_ALLOW_BROKEN_FILE_MAPPING flag to
> > explicitly permit this kind of GUP access.
> >
> > This is required in order to not break userspace in instances where the
> > uAPI might permit file-mapped addresses - a number of RDMA users require
> > this for instance, as do the process_vm_[read/write]v() system calls,
> > /proc/$pid/mem, ptrace and SDT uprobes. Each of these callers have been
> > updated to use this flag.
> >
> > Making this change is an important step towards a more reliable GUP, and
> > explicitly indicates which callers might encouter issues moving forward.
>
> nit: s/encouter/encounter/
>

Ack, I always seem to leave at least one or two easter egg spelling
mistakes in :)

Will fix up on next respin (in unlikely event of no further review,
hopefully Andrew would pick up!)
