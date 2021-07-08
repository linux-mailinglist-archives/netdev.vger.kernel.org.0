Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69FA3C1632
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhGHPoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhGHPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:44:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BB0C061574;
        Thu,  8 Jul 2021 08:41:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id c17so10335572ejk.13;
        Thu, 08 Jul 2021 08:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5bU32yJf64wWn9CfdxsNuw5tyIVyQgOrDIQvU4YN6Bc=;
        b=VXajLMBrDp9MZZibgCZ0QCEOc5WbEkmG/g1P1YrY5mnZdqXZmKi9ttOjsQr9Zd17k4
         CF0X4hUWbXylNczO00mH4C8+EiaNfeEgrxjat6YShpfqsvrxSTjlZdS4zmuCt2BUXRJF
         2A2MUXpNJX5mzZhl0D4Eq7U5aRxmmMb9wTNDPBA9ew1KeHGrEIYzzLMxfEz808qgAp5v
         REw6HfCcEPLwvGFUYvmCLcFhy70/F1A7K4R5CRvbSrFxyHUlwAXCjdk27HzwH8qCXFPK
         o04KSL/hgtx4thmUEg9QwjJ4VkcFlhT7nTZrkPSmZceYMie+Qq/D7M05xAUtB/M2JDcG
         ladA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5bU32yJf64wWn9CfdxsNuw5tyIVyQgOrDIQvU4YN6Bc=;
        b=HgqDWjtEBmahzDgWZhoVtOPJ/vGu0qFS4NK23ZigKHF4I4tBH39Mn0oODhIC1dIOI6
         vwnZL6tcnCeNSA04q1wbuGWNSGq96cSTA2OvfDwhcZCAXjuxnL9SKZDffvL00v4ieT++
         OzwYP9M5plF9F5QXFizFohbq3remO3aIdnLobd8cFnuw79gP0BhaNqW9maAxtnNuk8jq
         oZ+yebF/uuKhmMEhjHAPC8/8BzlgbsaLbmElHTQTwYOZVneDLQlkLPWR8DmldGYW89gK
         wkT249XJMnAAhDeVJneMtrgpPCB49aacBgAOoeZfRECfIXiyul6xDbCqTm3XOtGdITN2
         Zzgg==
X-Gm-Message-State: AOAM5317lCjwL7Gr3eFhuZqSHdy7EJkm8UtYSbt0+88IpFNsnmRqfdp4
        ZsaZk7yBmfLC3FdXVdlAzWxUK+kXsRkfJiNjg/4=
X-Google-Smtp-Source: ABdhPJwCNoAHske5J5uWUfE99nkBOdwzueLyp2cACPMXjO+HwO0XN2yQgspY5xXym3RPo7ole52HvaSDABcfj++0wY8=
X-Received: by 2002:a17:907:3e22:: with SMTP id hp34mr20001925ejc.470.1625758879806;
 Thu, 08 Jul 2021 08:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com> <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus> <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus> <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
 <YOcQyKt6i+UeMzSS@enceladus> <YOcXDISpR7Cf+eZG@enceladus> <CAKgT0UcoLE=MhG+QxS=up5BH_cK5FBSwyMHDvfUg2g8083UM+w@mail.gmail.com>
 <YOcbgEKqq/cRBxX9@enceladus>
In-Reply-To: <YOcbgEKqq/cRBxX9@enceladus>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Jul 2021 08:41:08 -0700
Message-ID: <CAKgT0Ucnd4Oia8xy2D65O04901+Rh6cepX-d2vK1+0_Of2NwoA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        hawk@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mcroce@microsoft.com,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        cong.wang@bytedance.com, Kevin Hao <haokexin@gmail.com>,
        nogikh@google.com, Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 8:36 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Thu, Jul 08, 2021 at 08:29:56AM -0700, Alexander Duyck wrote:
> > On Thu, Jul 8, 2021 at 8:17 AM Ilias Apalodimas
> > <ilias.apalodimas@linaro.org> wrote:

<snip>

> > > What do you think about resetting pp_recycle bit on pskb_expand_head()?
> >
> > I assume you mean specifically in the cloned case?
> >
>
> Yes. Even if we do it unconditionally we'll just loose non-cloned buffers from
> the recycling.
> I'll send a patch later today.

If you do it unconditionally you could leak DMA mappings since in the
non-cloned case we don't bother with releasing the shared info since
we just did a memcpy of it without the reference count tweaks. We have
to be really careful here. The idea is that we have to make exactly
one call to the __page_pool_put_page function for this page.

> > > If my memory serves me right Eric wanted that from the beginning. Then the
> > > cloned/expanded SKB won't trigger the recycling.  If that skb hits the free
> > > path first, we'll end up recycling the fragments eventually.  If the
> > > original one goes first, we'll just unmap the page(s) and freeing the cloned
> > > one will free all the remaining buffers.
> >
> > I *think* that should be fine. Effectively what we are doing is making
> > it so that if the original skb is freed first the pages are released,
> > and if it is released after the clone/expended skb then it can be
> > recycled.
>
> Exactly
>
> >
> > The issue is we have to maintain it so that there will be exactly one
> > caller of the recycling function for the pages. So any spot where we
> > are updating skb->head we will have to see if there is a clone and if
> > so we have to clear the pp_recycle flag on our skb so that it doesn't
> > try to recycle the page frags as well.
>
> Correct. I'll keep looking around in case there's something less fragile we
> can do

That is the risk to this kind of thing. We have to make the call once
and only once and if we either miss it or call it too many times we
can introduce some serious issues.

Thanks.

- Alex
