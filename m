Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC31281185
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgJBLtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgJBLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 07:49:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B41C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 04:49:00 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y20so1111824iod.5
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 04:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5HdSaawojkjITSm04Va0vCB5ZOkJqs6bcYYV5reDXiw=;
        b=ICCtf/EqlVISgwoo/faxqifEqDC9whb2V7RRhmw79AAH7uxUPulyC5laVe/F8gwXXa
         jsSK+wf/m+EvnEvaqi+mTVtI+Dx+m1HLwPrJ5Nq1cuP0RNRpOXtXAbGI/64757WqTWu+
         MSwQKBvnAyu4NmmlbzQZehmIqRYusj4tx1rw00+t88Tehg4fCFMlSgwXVMRatZ2SNoJ0
         89gZb4KsD932V66rOi0JvB19eCbHhNwzczw9EAT5Xaf/Uhgp3hqzR6xiv9B13vNoROo8
         EPAccp30waTXfG2y4tNXoQD026lORY8FRXLf2ydSRzsDv0l6P+QckR07s2kMiaHO1hPc
         yRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5HdSaawojkjITSm04Va0vCB5ZOkJqs6bcYYV5reDXiw=;
        b=pwyjkfL/em4qknptqla/oPbbWEbiO4+faBB3uJ6NItZ2ksKRPykaVyoOlZbQAEIERu
         9/NPo/DfWFTRC05S9r3ynPQE1C5KHyJ5yUY/puVY265bJmdyNoB5lU9io5/OydXgdNVC
         EE0xDY6WncjqLbc/9d5+nlB6b9HjVP5JRUNGOmR6XWkW4dlv1b2vVgiKd7I8CFseuDKF
         DAphv2YAEbTyVtK3+ksM/YMBOJxeK4LBUb/zXjgvrxoQ8NXPnYERAOy3DTp6xjVzcabK
         s/WYncc4VR9Hn+PKTt/KjkfdwHv5Qs8j3P19EGzzM6HzWJ3A1/zTHCFkteI+DtMrddCo
         VK8w==
X-Gm-Message-State: AOAM531Cyu+F/T0Yo7urenNg8Och6+kNDTYLBcqE3JWADA9w1IZaiark
        UHkyNorPMzAtx4bVYq9uSiihYNvYHTLR1ci3e8TBoEIYedu0WA==
X-Google-Smtp-Source: ABdhPJyRKNnZpGzjgndHAXrknvXe6ikf4g8I4yNX0DyUNhX18/VX722dPZratIe2+vyTzqG9fqS7AUtLTiMhpWtx68M=
X-Received: by 2002:a02:cd2e:: with SMTP id h14mr1965618jaq.6.1601639339275;
 Fri, 02 Oct 2020 04:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com> <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com> <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
In-Reply-To: <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Oct 2020 13:48:47 +0200
Message-ID: <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 1:09 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 02.10.2020 10:46, Eric Dumazet wrote:
> > On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 10/2/20 10:26 AM, Eric Dumazet wrote:
> >>> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>
> >>>> I have a problem with the following code in ndo_start_xmit() of
> >>>> the r8169 driver. A user reported the WARN being triggered due
> >>>> to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
> >>>> The driver is widely used, therefore I'd expect much more such
> >>>> reports if it should be a common problem. Not sure what's special.
> >>>> My primary question: Is it a valid use case that gso_size is
> >>>> greater than 0, and no SKB_GSO_ flag is set?
> >>>> Any hint would be appreciated.
> >>>>
> >>>>
> >>>
> >>> Maybe this is not a TCP packet ? But in this case GSO should have taken place.
> >>>
> >>> You might add a
> >>> pr_err_once("gso_type=%x\n", shinfo->gso_type);
> >>>
> >
> >>
> >> Ah, sorry I see you already printed gso_type
> >>
> >> Must then be a bug somewhere :/
> >
> >
> > napi_reuse_skb() does :
> >
> > skb_shinfo(skb)->gso_type = 0;
> >
> > It does _not_ clear gso_size.
> >
> > I wonder if in some cases we could reuse an skb while gso_size is not zero.
> >
> > Normally, we set it only from dev_gro_receive() when the skb is queued
> > into GRO engine (status being GRO_HELD)
> >
> Thanks Eric. I'm no expert that deep in the network stack and just wonder
> why napi_reuse_skb() re-initializes less fields in shinfo than __alloc_skb().
> The latter one does a
> memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
>

memset() over the whole thing is more expensive.

Here we know the prior state of some fields, while __alloc_skb() just
got a piece of memory with random content.

> What I can do is letting the affected user test the following.
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 62b06523b..8e75399cc 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6088,6 +6088,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>
>         skb->encapsulation = 0;
>         skb_shinfo(skb)->gso_type = 0;
> +       skb_shinfo(skb)->gso_size = 0;
>         skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
>         skb_ext_reset(skb);
>

As I hinted, this should not be needed.

For debugging purposes, I would rather do :

BUG_ON(skb_shinfo(skb)->gso_size);


Nothing in GRO stack will change gso_size, unless the packet is queued
by GRO layer (after this, napi_reuse_skb() wont be called)

napi_reuse_skb() is only used when a packet has been aggregated to
another, and at this point gso_size should be still 0.
