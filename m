Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8713C9ECD
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhGOMk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhGOMk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:40:58 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAD9C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 05:38:05 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p22so8790277yba.7
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 05:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AGW+c5GaM/xOaoIZowl6bOJR9OeKj5JF5OQ5bE4BgbI=;
        b=wqNRKxZcXX8yhtdHdnxdo0thbHOhRAMMlA1btOsqQJv68zgsKtmhYdccJrROUvntww
         Dqu5QdWohVBbu1A4XzGzyAEcMzK1qmT/lXVP/FMOtz5A0CPLfpptBWtRy6nEUI4fiQ3J
         e4Pa1oIg4pOUQU0xt06AVDICiAt8oekyyhRD1aOjXA0bM4fQvv7FFNzrksffwp/uLn5l
         0xXERwxcl9a4pKO6BMvWEtI8+v7yC2S32f7AjBLJYVHrLec24/i0wE8w8cOII/ppF3Lf
         Gp6B55mUMQTLFV9TV4MjBXGJKO+AvtLadCJ7Vd7yU0KFJhsiMNnwfRO8iHv2LG5EfjzD
         2jKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AGW+c5GaM/xOaoIZowl6bOJR9OeKj5JF5OQ5bE4BgbI=;
        b=cf8PJNv6Pp0Gu2QRpP2cSiH7xJ6axHLJk1cHMBVvtaGgo7OKeupQEW0HvsX3YbPc0N
         /tYNxd0VetkDYQwhVfekYXS2IQ3/3r/68KATTP8LWCd2mgpEXS3C0MGAuAFo2tAyMg8h
         rVNx3qPYfC0DK2vPytaaQrw6DDcJ+kdlte2SNaUD37TW35ZChKDpixaWtxCpOCoJeDZe
         /bVVSZA9VLmIK4H+vhtizDmHJA8eBFhZQoGfTwlA17+LAiaF6tOhO/K5YIPngrvon3hu
         uw7FToz2NTqHl3qMUgCBlRjCHvsN6becbZe0NQKfMdsm+yMtuMIvX6WrSD95hH8mZ0fz
         epEQ==
X-Gm-Message-State: AOAM531pC+o3pF7dbZlLxrDFtB9zJtnsrwdFMZ/K7iRh8/2savIHqp4T
        9kwzubQIeObqqAdD8qWg0k7vC92Y/Pw/MKVKvgMODA==
X-Google-Smtp-Source: ABdhPJwesHWjVlQ5vB1cCcE805wWh4704fk2bMHNJqXZ26teaNU1KqkHZUjaF/pToI/iqOK/rtlZbFmhfDpKnsEzMA4=
X-Received: by 2002:a25:8b91:: with SMTP id j17mr4979349ybl.228.1626352683797;
 Thu, 15 Jul 2021 05:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com> <CAC_iWjLypqTGMxw_1ng1H8r5Yiv83G3yxUW8T1863XzFM-ShpA@mail.gmail.com>
 <CAC_iWjLfsvr_Z2te=ABfEAecAOkQBiu22QZ8GhorA4MYnt4Uxg@mail.gmail.com> <401f10b2-3b92-a3f9-f01e-df2e190c8ff3@huawei.com>
In-Reply-To: <401f10b2-3b92-a3f9-f01e-df2e190c8ff3@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 15 Jul 2021 15:37:26 +0300
Message-ID: <CAC_iWjJJO6-+W+wq2HWYYbrz89tCs6Oc44YMtb88_gGXMqm2RQ@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Networking <netdev@vger.kernel.org>,
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
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Jul 2021 at 13:48, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/15 18:38, Ilias Apalodimas wrote:
> > On Thu, 15 Jul 2021 at 13:00, Ilias Apalodimas
> > <ilias.apalodimas@linaro.org> wrote:
> >>
> >> On Thu, 15 Jul 2021 at 07:01, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>
> >>> On 2021/7/9 14:29, Ilias Apalodimas wrote:
> >>>> As Alexander points out, when we are trying to recycle a cloned/expanded
> >>>> SKB we might trigger a race.  The recycling code relies on the
> >>>> pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> >>>> If that cloned SKB gets expanded or if we get references to the frags,
> >>>> call skbb_release_data() and overwrite skb->head, we are creating separate
> >>>> instances accessing the same page frags.  Since the skb_release_data()
> >>>> will first try to recycle the frags,  there's a potential race between
> >>>> the original and cloned SKB, since both will have the pp_recycle bit set.
> >>>>
> >>>> Fix this by explicitly those SKBs not recyclable.
> >>>> The atomic_sub_return effectively limits us to a single release case,
> >>>> and when we are calling skb_release_data we are also releasing the
> >>>> option to perform the recycling, or releasing the pages from the page pool.
> >>>>
> >>>> Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> >>>> Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> >>>> Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> >>>> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> >>>> ---
> >>>> Changes since v1:
> >>>> - Set the recycle bit to 0 during skb_release_data instead of the
> >>>>   individual fucntions triggering the issue, in order to catch all
> >>>>   cases
> >>>>  net/core/skbuff.c | 4 +++-
> >>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>> index 12aabcda6db2..f91f09a824be 100644
> >>>> --- a/net/core/skbuff.c
> >>>> +++ b/net/core/skbuff.c
> >>>> @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
> >>>>       if (skb->cloned &&
> >>>>           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> >>>>                             &shinfo->dataref))
> >>>> -             return;
> >>>> +             goto exit;
> >>>
> >>> Is it possible this patch may break the head frag page for the original skb,
> >>> supposing it's head frag page is from the page pool and below change clears
> >>> the pp_recycle for original skb, causing a page leaking for the page pool?
> >>>
> >>
> >> So this would leak eventually dma mapping if the skb is cloned (and
> >> the dataref is now +1) and we are freeing the original skb first?
> >>
> >
> > Apologies for the noise, my description was not complete.
> > The case you are thinking is clone an SKB and then expand the original?
>
> Yes.
> It seems we might need different pp_recycle bit for head frag and data frag.

We could just reset the pp_recycle flag on pskb_carve_inside_header,
pskb_expand_header and pskb_carve_inside_nonlinear which were the
three functions that might trigger the race to begin with.  The point
on adding it on skb_release_data was to have a catch all for all
future cases ...
Let me stare at itt a bit more in case I can come up with something better

Thanks
/Ilias
>
> >
> > thanks
> > /Ilias
> >
> >
> >>>>
> >>>>       skb_zcopy_clear(skb, true);
> >>>>
> >>>> @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
> >>>>               kfree_skb_list(shinfo->frag_list);
> >>>>
> >>>>       skb_free_head(skb);
> >>>> +exit:
> >>>> +     skb->pp_recycle = 0;
> >>>>  }
> >>>>
> >>>>  /*
> >>>>
> > .
> >
