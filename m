Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315DF3D7DD0
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhG0Si5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhG0Siz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 14:38:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CB5C061757;
        Tue, 27 Jul 2021 11:38:53 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id u12so16652105eds.2;
        Tue, 27 Jul 2021 11:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9ueGDlrIDyyhxrV4NQq28M57e2BsW0VmTFATXW8SVcY=;
        b=SFxwE+tLmGGaaPvmxvhX9z5KDUoKQRtDV4qSQxtuI7fzII+4jnBizPioauqQH9ek/6
         +XL/ys4mN8O4yJibD1q+fpTQiXooZtXkKGhSJu1lfzQVfDBqBS/H1ZmhL8OLiAKSlP49
         peX5nNKO/VtOSyNp+S5putGDvLHzbrSTD+N7Of9/j0GaEHgsq5vXlDoOWp1ZdvRgB/GA
         0MJQtBHG+P0XlrQlMrH5OUL/Ref9bbNZbASmfNfsZsj6CGNt77JDiA7W6KmWMCaHjzP+
         B92gpTeQjXvRLxnaPR+FRgD/l+ks/kVS5+dlJLa2ZftTzB2puU+5Tc9bhI24zu3dZYWt
         Vhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9ueGDlrIDyyhxrV4NQq28M57e2BsW0VmTFATXW8SVcY=;
        b=dwKuwCijFe+E8CbjHDV8C8mcTH8cqgI/eIa6VqgWPNV28C0Ky9Sxl2YLrf9qQBykcn
         We86NmYvhRyzIRfvlcYZuGmySIobZJsq0bVAyKyitDnZXEZpo4mIvYDsZv1GqsEALWih
         IG4pvMsH2WmdQ0wOjhgcDZGkfTZQAf28mq0jCQwBCR0SvhRnrMQnGFSWjo2e8zBSRGTu
         nHZbGerCYyhEgsZ1jUS51hQIoYQIxsjM0zfVGFEQBmgmvt7048tYOBTYooyU0TK1/jwI
         RJbd6l6CaAvq4at7CMUMmJMIGJxxx8xpXTsLXM5pL3ztGjESe/xC49ffycbiRztvRkIw
         /XIg==
X-Gm-Message-State: AOAM531yd+PsINwCzKF3a6weP0eHRJFajjQ6UOUD4yGfMEGnmJs1SU25
        3iKQUzDlD2xECRyGeRXyU3Fxciqd6Jge+scyXBU=
X-Google-Smtp-Source: ABdhPJwB8FRWS2J5s3syc6/M+EMNaReP0OaIRZlBGLVThpmeTSMNEz5G45mKFfDPXEoD2mggktSf1ht0pmg3nj+wicA=
X-Received: by 2002:aa7:d703:: with SMTP id t3mr29303497edq.50.1627411132094;
 Tue, 27 Jul 2021 11:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com> <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com> <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
 <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com> <CAKgT0Ud+PRzz7mgX1dru1=i3TDiaGOoyhg7vp6cz+3NzVFZf+A@mail.gmail.com>
 <20210724130709.GA1461@ip-172-31-30-86.us-east-2.compute.internal>
 <CAKgT0UckhFhvmsjNhBM6tX_EUn12NCn--puJkwVUGitk9yZedw@mail.gmail.com> <75213c28-d586-3dfe-c2a7-738af9dd9864@huawei.com>
In-Reply-To: <75213c28-d586-3dfe-c2a7-738af9dd9864@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 27 Jul 2021 11:38:40 -0700
Message-ID: <CAKgT0UcvPaP8AqjiF9eSXSWgnJqGVCNccW-brYeqmkZucpgb8A@mail.gmail.com>
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Yunsheng Lin <yunshenglin0825@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 12:54 AM Yunsheng Lin <linyunsheng@huawei.com> wrot=
e:
>
> On 2021/7/26 0:49, Alexander Duyck wrote:
> > On Sat, Jul 24, 2021 at 6:07 AM Yunsheng Lin <yunshenglin0825@gmail.com=
> wrote:
> >>
> >> On Fri, Jul 23, 2021 at 09:08:00AM -0700, Alexander Duyck wrote:
> >>> On Fri, Jul 23, 2021 at 4:12 AM Yunsheng Lin <linyunsheng@huawei.com>=
 wrote:
> >>>>
> >>>> On 2021/7/22 23:18, Alexander Duyck wrote:
> >>>>>>>

<snip>

> >>>
> >>> Rather than trying to reuse the devices page pool it might make more
> >>> sense to see if you couldn't have TCP just use some sort of circular
> >>> buffer of memory that is directly mapped for the device that it is
> >>> going to be transmitting to. Essentially what you would be doing is
> >>> creating a pre-mapped page and would need to communicate that the
> >>> memory is already mapped for the device you want to send it to so tha=
t
> >>> it could skip that step.
> >>
> >> IIUC sk_page_frag_refill() is already doing a similar reusing as the
> >> rx reusing implemented in most driver except for the not pre-mapping
> >> part.
> >>
> >> And it seems that even if we pre-map the page and communicate that the
> >> memory is already mapped to the driver, it is likely that we will not
> >> be able to reuse the page when the circular buffer is not big enough
> >> or tx completion/tcp ack is not happening quickly enough, which might
> >> means unmapping/deallocating old circular buffer and allocating/mappin=
g
> >> new circular buffer.
> >>
> >> Using page pool we might be able to alleviate the above problem as it
> >> does for rx?
> >
> > I would say that instead of looking at going straight for the page
> > pool it might make more sense to look at seeing if we can coalesce the
> > DMA mapping of the pages first at the socket layer rather than trying
> > to introduce the overhead for the page pool. In the case of sockets we
> > already have the destructors that are called when the memory is freed,
> > so instead of making sockets use page pool it might make more sense to
> > extend the socket buffer allocation/freeing to incorporate bulk
> > mapping and unmapping of pages to optimize the socket Tx path in the
> > 32K page case.
>
> I was able to enable tx recycling prototyping based on page pool to
> run some performance test, the performance improvement is about +20%
> =EF=BC=8830Gbit -> 38Gbit=EF=BC=89 for single thread iperf tcp flow when =
IOMMU is in
> strict mode. And CPU usage descreases about 10% for four threads iperf
> tcp flow for line speed of 100Gbit when IOMMU is in strict mode.

That isn't surprising given that for most devices the IOMMU will be
called per frag which can add a fair bit of overhead.

> Looking at the prototyping code, I am agreed that it is a bit controversi=
al
> to use the page pool for tx as the page pool is assuming NAPI polling
> protection for allocation side.
>
> So I will take a deeper look about your suggestion above to see how to
> implement it.
>
> Also, I am assuming the "destructors" means tcp_wfree() for TCP, right?
> It seems tcp_wfree() is mainly used to do memory accounting and free
> "struct sock" if necessary.

Yes, that is what I was thinking. If we had some way to add something
like an argument or way to push the information about where the skbs
are being freed back to the socket the socket could then be looking at
pre-mapping the pages for the device if we assume a 1:1 mapping from
the socket to the device.

> I am not so familiar with socket layer to understand how the "destructors=
"
> will be helpful here, any detailed idea how to use "destructors" here?

The basic idea is the destructors are called when the skb is orphaned
or freed. So it might be a good spot to put in any logic to free pages
from your special pool. The only thing you would need to sort out is
making certain to bump reference counts appropriately if the skb is
cloned and the destructor is copied.
