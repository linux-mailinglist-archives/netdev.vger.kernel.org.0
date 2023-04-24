Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568916ED536
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjDXTSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjDXTSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:18:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE12E6D;
        Mon, 24 Apr 2023 12:18:37 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f1738d0d4cso31247715e9.1;
        Mon, 24 Apr 2023 12:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682363916; x=1684955916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1q/4i2elk3BA3Rj+QoCYnRS4MnuAVuxCMWMhVXymMw=;
        b=Vxlkf6eXc8hNlYZKosRpWF10A+8sPT/LRwFFpD5gCIgEgQHJBPpwl9XiMM+9uYDKuC
         YSn4qSHxRINZbV3uwOtC94D3OJm+l367BKSLmUgej0ndLIhkKZCtmFmrkUxlSmVoNLJe
         GRvJGjJKlxVnK4G0OrmF46tlTXyKPBtRd5H8joCvOh7P0ty5Hfzc4EEEMj+Q9zl/9W3a
         2u7zMqMYAbF8qwiF8KdyV6Lrl3fV/JR5w2wyzmlnUmeeCGpse4JDmBWv8KwSdBiOfCzT
         R6s4Y8XFOF0n78/m5pa0JPN8s76eyEnWzqN3PPZdKTQlQArnoA98jmakIPBtAhbCfvpQ
         Bs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682363916; x=1684955916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1q/4i2elk3BA3Rj+QoCYnRS4MnuAVuxCMWMhVXymMw=;
        b=df0z6N76T4awY3Xt3ePqv5lJp9pL4it6/fpJu5Bn5Dr5EuaTpIVRk74CL1ae/z+4sf
         RUkwMjzEpieb8hU4lhDKSoGmzNeSzeYHT7gPRZKaVKt/Fkyevo7J0vc7AopTR9Wl/v1Q
         9CeUZ6u8QGWZEWgWqoUTCChb6sEfIqu6ZU3w72Rinzvu/DJK5yP+b/wWxOpdBX67NDfE
         LLzLzbrI5j2GPZRnTF7/Ar1I7JdwbkqW9WUEpsfKFJ6i2Ay5AmU81cZIzxpFAdfDD4Sn
         Z5O2cLbZS5y1TlEtei1Ad1B4nFB32RiC8zuwo5DNrdF2nmIA4b0epGPnsB2a8NobwZuF
         3w7w==
X-Gm-Message-State: AAQBX9dITIGKVrLIi/JLFjvhW1gph42p+HyCqqagJt7knxp3JHsVrQ09
        RCHN/Jw7avFYnIL5JYKNo2A=
X-Google-Smtp-Source: AKy350ZDhAPYuLEpF8HIpNccA9jbhB9WMePiz/zH6jKMYHFwbOFzbI0LXgErhPvQ+QtiuM8faomL1A==
X-Received: by 2002:a5d:5962:0:b0:2cf:ee9d:ce2f with SMTP id e34-20020a5d5962000000b002cfee9dce2fmr10085377wri.19.1682363915655;
        Mon, 24 Apr 2023 12:18:35 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id j14-20020adfea4e000000b002fc3d8c134bsm11397032wrn.74.2023.04.24.12.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 12:18:34 -0700 (PDT)
Date:   Mon, 24 Apr 2023 20:18:33 +0100
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
Message-ID: <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
 <ZEbQeImOiaXrydBE@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEbQeImOiaXrydBE@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:54:48PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 07:22:03PM +0100, Lorenzo Stoakes wrote:
>
> > OK I guess you mean the folio lock :) Well there is
> > unpin_user_pages_dirty_lock() and unpin_user_page_range_dirty_lock() and
> > also set_page_dirty_lock() (used by __access_remote_vm()) which should
> > avoid this.
>
> It has been a while, but IIRC, these are all basically racy, the
> comment in front of set_page_dirty_lock() even says it is racy..
>
> The race is that a FS cleans a page and thinks it cannot become dirty,
> and then it becomes dirty - and all variations of that..
>
> Looking around a bit, I suppose what I'd expect to see is a sequence
> sort of like what do_page_mkwrite() does:
>
>         /* Synchronize with the FS and get the page locked */
>      	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
> 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
> 		return ret;
> 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
> 		lock_page(page);
> 		if (!page->mapping) {
> 			unlock_page(page);
> 			return 0; /* retry */
> 		}
> 		ret |= VM_FAULT_LOCKED;
> 	} else
> 		VM_BUG_ON_PAGE(!PageLocked(page), page);
>
> 	/* Write to the page with the CPU */
> 	va = kmap_local_atomic(page);
> 	memcpy(va, ....);
> 	kunmap_local_atomic(page);
>
> 	/* Tell the FS and unlock it. */
> 	set_page_dirty(page);
> 	unlock_page(page);
>
> I don't know if this is is exactly right, but it seems closerish
>
> So maybe some kind of GUP interfaces that returns single locked pages
> is the right direction? IDK
>
> Or maybe we just need to make a memcpy primitive that works while
> holding the PTLs?
>

I think this patch suggestion has scope crept from 'incremental
improvement' to 'major rework of GUP' at this point. Also surely you'd want
to obtain the PTL of all mappings to a file? This seems really unworkable
and I don't think holding a folio lock over a long period is sensible
either.

> > We definitely need to keep ptrace and /proc/$pid/mem functioning correctly,
> > and I given the privilege levels required I don't think there's a security
> > issue there?
>
> Even root is not allowed to trigger data corruption or oops inside the
> kernel.
>
> Jason

Of course, but isn't this supposed to be an incremental fix? It feels a
little contradictory to want to introduce a flag intentionally to try to
highlight brokenness then to not accept any solution that doesn't solve
that brokenness.

In any case, I feel that this patch isn't going to go anywhere as-is, it's
insufficiently large to solve the problem as a whole (I think that's a
bigger problem we can return to later), and there appears to be no taste
for an incremental improvement, even from the suggester :)

As a result, I suggest we take the cautious route in order to unstick the
vmas patch series - introduce an OPT-IN flag which allows the check to be
made, and update io_uring to use this.

That way it defers the larger discussion around this improvement, avoids
breaking anything, provides some basis in code for this check and is a net,
incremental small and digestible improvement.
