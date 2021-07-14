Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6780B3C8650
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239521AbhGNOtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhGNOtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:49:25 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13293C06175F;
        Wed, 14 Jul 2021 07:46:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id go30so3734696ejc.8;
        Wed, 14 Jul 2021 07:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jmnbKaeHY43auiwf/DJpFy/yehvSWlUJXGgTgX78hTk=;
        b=X48xVSzqMOxd9X+khEzyTkk+2q6TnzjLet7Hjup7n7vZ4tQ+UbAb23MF4d6CvWqsJW
         YGXDu1RK+/MvfyXzMFnNL7Z+Uwrj+ErGDVZeFqB/y2juOr/P+C8gZsCaATnpcjN4fi+Z
         6saa2ZfyAwxfdfaUeJr4Th3GPpktbWBQK/XN6U7SeRzfArMJTQSyAgGtSFb5RUw3bohp
         C2fL7TTLpC0gfbg2wu29vPp5lar5Noqu2/EFAX2HlYJ9qYaSPLxM8xwobkn72sKAYAzq
         VG2sULjsAiyIf6CRA8k6NArXXKQs3NDKyWbSL68r3RTQhqKmYbSeHOAuGVk7hnvym5cV
         NwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jmnbKaeHY43auiwf/DJpFy/yehvSWlUJXGgTgX78hTk=;
        b=gR0Rz2aJPe3g9qr7MajWPULRUNlKm1f/aRO0741bhnwNWhh5OJzRCPEqgcbd2I3YNV
         pYKloe5FFb8TuPeb9Pkn5rLSHI7HlwuK1Er/EKViVHug0UAsJ6hr8NDLOPwwUEIMJkh1
         6PFlGKXXvzclZjEqVIutbgGLaWybWkKsoT+Lmb7btDCHUGOPi9wxwLBgwN5Rt6yCNP3L
         ztyEeKTHoMRX3XbSBpRch3CLTMcWEonhp8DGRVNiGXwUAxTmjLAaNe8aEyvsATzQm9Wu
         fW5Qt43n0o3DOKArLxJ4qnpNSHyRjow/UWgPDpBR/XF4oUuoKFZsf5JeTIvinHB2nREd
         zesg==
X-Gm-Message-State: AOAM533DpD8UunBkyd2uW8z8O9mf2fwisZAgcgDew4aohFizL31cQQ6u
        IR4PlqGo8x1B2knRaRXNQfFrR12kepyriArxYfQ=
X-Google-Smtp-Source: ABdhPJzMT6CwpM7xMbhSoLInIM9EY+2bBrzCXMJN3RjfYNDiZAE1VXuCklrd2QwE147vNkfmxVzqJSZ64aHAPnOck8Y=
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr5064713ejc.473.1626273990557;
 Wed, 14 Jul 2021 07:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <1626255285-5079-1-git-send-email-linyunsheng@huawei.com>
 <1626255285-5079-3-git-send-email-linyunsheng@huawei.com> <79d9e41c-6433-efe1-773a-4f5e91e8de0f@redhat.com>
In-Reply-To: <79d9e41c-6433-efe1-773a-4f5e91e8de0f@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 14 Jul 2021 07:46:19 -0700
Message-ID: <CAKgT0UcDxSmMqCGvrWeYFiKNsxWXskF+pUhKQVCC6totduUyDQ@mail.gmail.com>
Subject: Re: [PATCH rfc v5 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 3:18 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 14/07/2021 11.34, Yunsheng Lin wrote:
> > As suggested by Alexander, "A DMA mapping should be page
> > aligned anyway so the lower 12 bits would be reserved 0",
> > so it might make more sense to repurpose the lower 12 bits
> > of the dma address to store the frag count for frag page
> > support in page pool for 32 bit systems with 64 bit dma,
> > which should be rare those days.
>
> Do we have any real driver users with 32-bit arch and 64-bit DMA, that
> want to use this new frag-count system you are adding to page_pool?
>
> This "lower 12-bit use" complicates the code we need to maintain
> forever. My guess is that it is never used, but we need to update and
> maintain it, and it will never be tested.
>
> Why don't you simply reject using page_pool flag PP_FLAG_PAGE_FRAG
> during setup of the page_pool for this case?
>
>   if ((pool->p.flags & PP_FLAG_PAGE_FRAG) &&
>       (sizeof(dma_addr_t) > sizeof(unsigned long)))
>     goto reject-setup;
>
>

That sounds good to me if we want to go that route. It would simplify
this quite a bit since essentially we could just drop these if blocks.

Thanks.

- Alex
