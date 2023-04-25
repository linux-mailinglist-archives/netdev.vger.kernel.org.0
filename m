Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC306EE5FD
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbjDYQpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbjDYQpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:45:46 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A8D32E;
        Tue, 25 Apr 2023 09:45:40 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f19b9d5358so37403675e9.1;
        Tue, 25 Apr 2023 09:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682441139; x=1685033139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQgl8loxAa0veEtZSLtrUvcvIyw2BmuwVPdtNPCihQg=;
        b=sIcEl1Tq3fwrs5UA5d0jX7GXW2Kr1kzevC2acB6kGpDEHKhEr1s9Nv64aQTPCMYV3b
         8ogebBHtokSZSmEB38ASPWmJFv8VhO9CXDIGJ7A3a0jSniormcYUo170KQJgaZ/9ZNhH
         cOfQjXRcRLByvhH8UPAVLiw4tMzfQCtNEO1KMn6VCHOdb3sKSnbH/IcHPKhOeMrChhNv
         JMb0WcLeiws5HqMPX8V0OIa1fx6cu4d4gQ0O1QMNmcSGGMhIWpJ6dE602GjSAh8KDHHy
         /ei4tBSGhgulm1GTAscNu1bTIhOBVZ+E3mup8DtyVPaVcm5IQ6WVGGr4ObkkwKUvTf5L
         XsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682441139; x=1685033139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQgl8loxAa0veEtZSLtrUvcvIyw2BmuwVPdtNPCihQg=;
        b=Npba7R5Ulyw1NJmOI0dLq0Pav1PO1rgUSuQT97E/01eUIUfgPbhQLwn553zyy9JHA+
         dpj2myvkI3KbVeA9A/K1xthmSqD8Nl3zZlW2LZ6amQuVa2YqzlkgMBg6AAiRN2+mwjeL
         8gKhZ8JwarN09X8Lkq5QELVm4ZY38fbaLBGn4yoVraC6pG0UHfAnp5ix1jbakXL/5kXN
         qqFdT+abj9+ybsMiJlHZjhbCBkkJG0Be9evW5tepHNCuMNzjkGoGyucwfoGO9nNb4O5C
         d5Kjyk1pEgDgfydswa+o1/Q3rqK9UNO87P0GVJZVeyeyoK8p64E6cUniqNZJbH871m6k
         e5OQ==
X-Gm-Message-State: AAQBX9dZRMkVToc0ge+tqj2FGLO+SSfcjT87nwsCWSeqk4Zb4rSeSYUc
        pUbdz0IM4gxaQZB39NoloBw=
X-Google-Smtp-Source: AKy350bhH1kCJAVU7jh/SMJsu6YcMsWKt9KQNik/pi2ziZhXf7/st499uGWpq4b1M825P+kzcwiSwA==
X-Received: by 2002:a05:600c:3783:b0:3f1:6fb4:44cf with SMTP id o3-20020a05600c378300b003f16fb444cfmr10814511wmr.28.1682441138560;
        Tue, 25 Apr 2023 09:45:38 -0700 (PDT)
Received: from localhost ([208.34.186.1])
        by smtp.gmail.com with ESMTPSA id p10-20020a1c544a000000b003f03d483966sm18820138wmi.44.2023.04.25.09.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 09:45:37 -0700 (PDT)
Date:   Tue, 25 Apr 2023 17:45:36 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     "Kirill A . Shutemov" <kirill@shutemov.name>
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
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v3] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEgDsOlIW1xhuQXv@murray>
References: <23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com>
 <20230425101153.xxi4arpwkz7ijnvm@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425101153.xxi4arpwkz7ijnvm@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 01:11:53PM +0300, Kirill A . Shutemov wrote:
> On Tue, Apr 25, 2023 at 08:14:14AM +0100, Lorenzo Stoakes wrote:
> > GUP does not correctly implement write-notify semantics, nor does it
> > guarantee that the underlying pages are correctly dirtied, which could lead
> > to a kernel oops or data corruption when writing to file-backed mappings.
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
> > In the meantime, we add a check for the most broken GUP case -
> > FOLL_LONGTERM - which really under no circumstances can safely access
> > dirty-tracked file mappings.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> > v3:
> > - Rebased on latest mm-unstable as of 24th April 2023.
> > - Explicitly check whether file system requires folio dirtying. Note that
> >   vma_wants_writenotify() could not be used directly as it is very much focused
> >   on determining if the PTE r/w should be set (e.g. assuming private mapping
> >   does not require it as already set, soft dirty considerations).
>
> Hm. Okay. Have you considered having a common base for your case and
> vma_wants_writenotify()? Code duplication doesn't look good.
>

I did and I actually started implementing something for the same reason,
however I wondered whether it was worth it for essentially 3 clauses that
are shared between the two.

On second thoughts, it is painful to have this duplicated, so let me take
another look.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov
