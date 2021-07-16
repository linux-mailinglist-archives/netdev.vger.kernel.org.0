Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AAC3CB2D5
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 08:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhGPGr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 02:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbhGPGrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 02:47:25 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F157DC061760
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 23:44:29 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i18so13141398yba.13
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 23:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwYXIr6ik9gRFyyihXOmtA5qXVO6HHeD+uU+nCHmsq0=;
        b=YZ52dA33UBIanGFBEMesnLQgILFUGfuI/dFj6cpjXYYJLxefZsLaVB9mys2X2kl2aT
         y98CmtNdAqXIhkeAHE9ZPrlTCVA6DoE8hgxSjVINFYy01TOc3ZztkHt1OwDb8jgsNt+g
         hJGctN5hI0TzrlwYbSjIqug84KTwTIiMfv5k0hP4TSgSJ+/YkE04zBJS3760u2hKZbz2
         rJf36PkwKxrR+b2/AFC6J3SYWRSsSzJ4yjN/Hp0BAMzeLmqvKwwtfI3KmKtHVYpgnAfJ
         y3dDJEF8MzRSVxR7Z9aEHWbQd4iCR2Xu4LB8j/fzKiliChdFrRU0UvYlSo/tZPDVaK9e
         zMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwYXIr6ik9gRFyyihXOmtA5qXVO6HHeD+uU+nCHmsq0=;
        b=S7GFg6IBO3OIWhbNjWXEhaQV7COt2sSyPOW0VvF68J8jHBVfWB7XCNW9OnxueFNzgb
         f8R4lPPZd0UFoORUocbuYk2jXO3dK75IHFtYOwjlOXLMWrewUKLG4LhfMkpC8QqYj9c+
         f/Ia6Z3nVza7zPoGWanzEypgTlhnXUd+yx8QDllGLzc45wxEzQG/1XM1jVYSOuvfHO9y
         rJJ2zn2BvGqiPF2Se/oFiumzSlFfc1mqXxzGDUGGchkHYJj1jIn3VVuF2/li5j+HPG+D
         IqHiPXwPpYhUVCVkAHd4j1bqoGblbb565y5AXaTRaolDfVzRNjP5Z5D7hJzQSH3QO/30
         U0rA==
X-Gm-Message-State: AOAM530NHES9iy5T0buug1Vi5RHSEhL58ian8uw+icU/cT/I0ZXzEu9u
        H+kcQeKwIDPv+KxWhZxHmnwRuybyXZZ+kO8PPPCJlg==
X-Google-Smtp-Source: ABdhPJxJMzGcNWQusJraAVSb+MJajMxp7Zs3BZ+r32zlFFk0nfESDuvHC/7b7SsklGbfthYEM/dCArmEO9yaPWvvKOw=
X-Received: by 2002:a25:8b91:: with SMTP id j17mr10365880ybl.228.1626417869290;
 Thu, 15 Jul 2021 23:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com> <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
 <YPBKFXWdDytvPmoN@Iliass-MBP> <CAKgT0UfOr7U-8T+Hr9NVPL7EMYaTzbx7w1-hUthjD9bXUFsqMw@mail.gmail.com>
 <YPBOHcx/sCEz/+wn@Iliass-MBP> <57b08af5-8be2-56c7-981c-27ab7187fbdf@huawei.com>
In-Reply-To: <57b08af5-8be2-56c7-981c-27ab7187fbdf@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 16 Jul 2021 09:43:53 +0300
Message-ID: <CAC_iWjL7X+wmeSk8m0q5=MdrPP-NiZY3K7RjCE6_GM2CxfN_7g@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Jul 2021 at 05:30, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/15 23:02, Ilias Apalodimas wrote:
> > On Thu, Jul 15, 2021 at 07:57:57AM -0700, Alexander Duyck wrote:
> >> On Thu, Jul 15, 2021 at 7:45 AM Ilias Apalodimas
> >> <ilias.apalodimas@linaro.org> wrote:
> >>>
> >>>>>>           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> >>>
> >>> [...]
> >>>
> >>>>>>                             &shinfo->dataref))
> >>>>>> -             return;
> >>>>>> +             goto exit;
> >>>>>
> >>>>> Is it possible this patch may break the head frag page for the original skb,
> >>>>> supposing it's head frag page is from the page pool and below change clears
> >>>>> the pp_recycle for original skb, causing a page leaking for the page pool?
> >>>>
> >>>> I don't see how. The assumption here is that when atomic_sub_return
> >>>> gets down to 0 we will still have an skb with skb->pp_recycle set and
> >>>> it will flow down and encounter skb_free_head below. All we are doing
> >>>> is skipping those steps and clearing skb->pp_recycle for all but the
> >>>> last buffer and the last one to free it will trigger the recycling.
> >>>
> >>> I think the assumption here is that
> >>> 1. We clone an skb
> >>> 2. The original skb goes into pskb_expand_head()
> >>> 3. skb_release_data() will be called for the original skb
> >>>
> >>> But with the dataref bumped, we'll skip the recycling for it but we'll also
> >>> skip recycling or unmapping the current head (which is a page_pool mapped
> >>> buffer)
> >>
> >> Right, but in that case it is the clone that is left holding the
> >> original head and the skb->pp_recycle flag is set on the clone as it
> >> was copied from the original when we cloned it.
> >
> > Ah yes, that's what I missed
> >
> >> What we have
> >> essentially done is transferred the responsibility for freeing it from
> >> the original to the clone.
> >>
> >> If you think about it the result is the same as if step 2 was to go
> >> into kfree_skb. We would still be calling skb_release_data and the
> >> dataref would be decremented without the original freeing the page. We
> >> have to wait until all the clones are freed and dataref reaches 0
> >> before the head can be recycled.
> >
> > Yep sounds correct
>
> Ok, I suppose the fraglist skb is handled similar as the regular skb, right?
>

Yes, even in the fragments case your cloned/expanded SBK will still
have the recycle bit set, so it will try to recycle them or unmap them

> Also, this patch might need respinning as the state of this patch is "Changes
> Requested" in patchwork.

Thanks, I'll respin it and add a comment explaining why

>
> >
> > Thanks
> > /Ilias
> > .
> >
