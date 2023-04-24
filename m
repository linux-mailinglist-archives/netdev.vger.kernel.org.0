Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3296ED058
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjDXOaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDXOaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:30:02 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB66D1708;
        Mon, 24 Apr 2023 07:30:00 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f19323259dso34206845e9.3;
        Mon, 24 Apr 2023 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682346599; x=1684938599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ALXzGJ5JvLTy0+4F2uq1xRRPXqqALEamM+dBHIwr4DU=;
        b=jN6OPjaHPR+35RVu5HjWm806ZMgHf01oApnLVzOoITrD4+H3+33xZ6dZ5oRf6qOZUP
         D8hA3Wt44+/uTDeVRl8Ov5vr+CJfATx0OLo0X1EW5HpwpfUNG+UJik3wBieB7KEjsimQ
         y1HCZNLKGyA7om63+beqZU93mzJXtP5mOtlZ6xytdf2q3oM+pAkAGAUnopDzvWh322W1
         4P+KbO6x4luVrUwPFIY3Kz+NJFvZi9mRoQERFsgyWpa7xNiB+Kl9hiYh2UGYR8newEsb
         nNPRnYDg7clTomT3WnhQfQKHmrFMU6VtI4ds5fP3IX5FZTm3u1VX+ZmjErAMXFNfLvTc
         Gtzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682346599; x=1684938599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALXzGJ5JvLTy0+4F2uq1xRRPXqqALEamM+dBHIwr4DU=;
        b=ByQe8uW8hNfq7uYCLF8fGjkAL/ZJDy4u+j4MsyP69zgWvp8O/uctIleoMvcck6KEYf
         x5/OxMB1BHdjGkrf4wqgA2sTYbVnYU4s+a22oil/ju15f3xqK2L0d35ZNn0ttQpsuCAo
         O2iuVRWz1Jow+fNgWMX5flycrvOuzYsLBdgW7tpH5yHAekE8y55LRxRAGH72cSYOhcqM
         fnlgwNNJeugjOKZaRTCzxcTEPkpzBLsESyJVViweI57B2WpDPAsTE8R9wIsIzSkhffci
         aTCoq0Huo8zhg93b95jOSRuvZGVNtiMxIrnGcKkxzM7eLhMbZHPlVf8CUqJ04nSOAxSy
         ixRg==
X-Gm-Message-State: AAQBX9fPmuFe46T++835Srvcs1VLtQ4zu1hGPLX8wcBSYme8/IdzLwZG
        nsNlvPkDEjwpXyd2OtoAZyw=
X-Google-Smtp-Source: AKy350b0rBDMlMKwXgslvzplbT1eTTOv7dxTLMhpCvOuA79NqOaO/7KznoKPY9xRsZr4W2xUpEdJIw==
X-Received: by 2002:a05:600c:2214:b0:3f1:98bd:acec with SMTP id z20-20020a05600c221400b003f198bdacecmr5257735wml.11.1682346598884;
        Mon, 24 Apr 2023 07:29:58 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id y21-20020a05600c365500b003f182a10106sm12424385wmq.8.2023.04.24.07.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:29:57 -0700 (PDT)
Date:   Mon, 24 Apr 2023 15:29:57 +0100
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
Message-ID: <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEaGjad50lqRNTWD@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 10:39:25AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 01:38:49PM +0100, Lorenzo Stoakes wrote:
>
> > I was being fairly conservative in that list, though we certainly need to
> > set the flag for /proc/$pid/mem and ptrace to avoid breaking this
> > functionality (I observed breakpoints breaking without it which obviously
> > is a no go :). I'm not sure if there's a more general way we could check
> > for this though?
>
> More broadly we should make sure these usages of GUP safe somehow so
> that it can reliably write to those types of pages without breaking
> the current FS contract..
>
> I forget exactly, but IIRC, don't you have to hold some kind of page
> spinlock while writing to the page memory?
>

I think perhaps you're thinking of the mm->mmap_lock? Which will be held
for the FOLL_GET cases and simply prevent the VMA from disappearing below
us but not do much else.

> So, users that do this, or can be fixed to do this, can get file
> backed pages. It suggests that a flag name is more like
> FOLL_CALLER_USES_FILE_WRITE_LOCKING
>

As stated above, I'm not sure what locking you're referring to, but seems
to me that FOLL_GET already implies what you're thinking?

I wonder whether we should do this check purely for FOLL_PIN to be honest?
As this indicates medium to long-term access without mmap_lock held. This
would exclude the /proc/$pid/mem and ptrace paths which use gup_remote().

That and a very specific use of uprobes are the only places that use
FOLL_GET in this instance and each of them are careful in any case to
handle setting the dirty page flag.

All PUP cases that do not specify FOLL_LONGTERM also do this, so we could
atually go so far as to reduce the patch to simply performing the
vma_wants_writenotify() check if (FOLL_PIN | FOLL_LONGTERM) is specified,
which covers the io_uring case.

Alternatively if we wanted to be safer, we could add a FOLL_ALLOW_FILE_PIN
that is checked on FOLL_PIN and ignored on FOLL_LONGTERM?

> > I wouldn't be totally opposed to dropping it for RDMA too, because I
> > suspect accessing file-backed mappings for that is pretty iffy.
> >
> > Do you have a sense of which in the list you feel could be pared back?
>
> Anything using FOLL_LONGTERM should not set the flag, GUP should even
> block the combination.

OK

>
> And we need to have in mind that the flag indicates the code is
> buggy, so if you set it then we should understand how is that caller
> expected to be fixed.
>
> Jason

I think we are working towards a much simpler solution in any case!
