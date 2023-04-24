Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7FB6ED845
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 01:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjDXXDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 19:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDXXDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 19:03:41 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B3093E6;
        Mon, 24 Apr 2023 16:03:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f18335a870so32544805e9.0;
        Mon, 24 Apr 2023 16:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682377416; x=1684969416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P0nMjLjJ2Ejf4Gum9iKdCO8GGAzyEOx1mv4U4DYV4qE=;
        b=EuHX7Z/vAZocfhu4Vgyz49xCCl2q92HT9jd7KAaQxRyLHLUDRyT1hLjdT5+bk3UXb0
         RFVUJ3ICo+HD9jfBMqoShj5ln64HLYckW5U9H24eAMXOLV1BEJbCwqLJuTDq6xty7NGx
         cGvpM8DB3RDh7Anccmdge6TYaiqUOxvmmyhgkXDnFgOqaphLKnqe1pFzz2iZPuivObec
         d6L6S3mBEuw6NA3pUpIwzfSFUsz6ErK0neRJMH6NkT5PpgVYsoczXw7CprHX7Pi5SDm4
         QRRzJc/IHUy0nKhvW1yl2PtKcHCvXN4Y9BysJ8M0UHc3XfJiEv7dAKHcYsyju0hSDT73
         Tekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377416; x=1684969416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P0nMjLjJ2Ejf4Gum9iKdCO8GGAzyEOx1mv4U4DYV4qE=;
        b=MccwXko8v9gSHAxdQKamrW1aF9wjwMrfnXdvypNTHncwwAOwDYFFkLgCjmH3K4qnV1
         aj75trVEtdL5E+M2uzs7WeYTaiuXajU0z8u6+tRXqEiiw6wROwKBkfdO92BnO/+VW1Fx
         jHBHySLsrt0WNzc5jHGfMtzYAYFR5oHPXbPi7/S/J5uE3a1gcANxcZxhwGqtW0C9G857
         7Wy4LpAdhtSXsqV300T7jGpLEELmJj0YPMxHozglBNdkf/H1qKxLj57FbwMKLFu4/Rjx
         G6WcuO5NJjjxlnIGbkouHSdzeAhskABaM/ETTjznUgRcVYh/4WCnG4w/J7RKXBt87Jy/
         TN9g==
X-Gm-Message-State: AAQBX9d09d9NIRWaj6ZgrwKckY6Yif+PIsuvHeER6chBSabOm2PKdKbl
        7sJKSXb56SPRBRN79mMbQGk=
X-Google-Smtp-Source: AKy350bEw1oYBxZ1aQpLH2RCWXylid0vlvZ0fQa3JAem1BWm3uFPUGdsWn5khS006UqQkx6YbrWY7A==
X-Received: by 2002:adf:f185:0:b0:2f4:cfb4:57f7 with SMTP id h5-20020adff185000000b002f4cfb457f7mr9983848wro.61.1682377416362;
        Mon, 24 Apr 2023 16:03:36 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id g3-20020a5d5543000000b002fe254f6c33sm11648252wrw.92.2023.04.24.16.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 16:03:35 -0700 (PDT)
Date:   Tue, 25 Apr 2023 00:03:34 +0100
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
Message-ID: <4f16b1fc-6bc5-4e41-8e94-151c336fcf69@lucifer.local>
References: <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
 <ZEbQeImOiaXrydBE@nvidia.com>
 <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
 <ZEcIZspUwWUzH15L@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEcIZspUwWUzH15L@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 07:53:26PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 08:18:33PM +0100, Lorenzo Stoakes wrote:
>
> > I think this patch suggestion has scope crept from 'incremental
> > improvement' to 'major rework of GUP' at this point.
>
> I don't really expect to you clean up all the callers - but we are
> trying to understand what is actually wrong here to come up with the
> right FOLL_ names and overall strategy. Leave behind a comment, for
> instance.
>

Right, but you are suggesting introducing a whole new GUP interface holding
the right locks etc. which is really scope-creeping from the original
intent.

I'm not disagreeing that we need an interface that can return things in a
state where the dirtying can be done correctly, I just don't think _this_
patch series is the place for it.

> I don't think anyone has really thought about the ptrace users too
> much till now, we were all thinking about DMA use cases, it shows we
> still have some areas that need attention.

I do like to feel that my recent glut of GUP activity, even if noisy and
frustrating, has at least helped give some insights into usage and
semantics :)

>
> > Also surely you'd want to obtain the PTL of all mappings to a file?
>
> No, just one is fine. If you do the memcpy under a single PTL that
> points at a writable copy of the page then everything is trivially
> fine because it is very similar to what the CPU itself would do, which
> is fine by definition..
>
> Jason

Except you dirty a page that is mapped elsewhere that thought everything
was cleaned and... not sure the PTLs really help you much?

Anyway I feel we're digressing into the broader discussion which needs to
be had, but not when trying to unstick the vmas series :)

I am going to put forward an opt-in variant of this change that explicitly
checks whether any VMA in the range requires dirty page tracking, if not
failing the GUP operation.

This can then form the basis of the opt-OUT variant (it'll be the same
check code right?) and help provide a basis for the additional work that
clearly needs to be done.

It will also replace the open-coded VMA check in io_uring so has utility
and justification just from that.

If we want to be more adventerous the opt-in variant could default to on
for FOLL_LONGTERM too, but that discussion can be had over on that patch
series.
