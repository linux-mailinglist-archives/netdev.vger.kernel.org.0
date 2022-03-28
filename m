Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499314E9660
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbiC1MUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiC1MUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:20:50 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3872B87B
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:19:09 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id g9so23212745ybf.1
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eKwmN+9En8+NeURudR1q9AFdHqkfLXQ++oiNukepjQA=;
        b=Lir7tQN+XaczOdbJpwswV/2Qvvp7Q4dVObT0kWYrTDIH2XJUYzkXVWP1UGTgvynI5i
         467iFcNnHLAYylwRxqtnXiK0XU+D/o4dHcXjp4KzEY3WGTffpuhBpxArOwPA/zn2N5ww
         KPf5AdF5BUYsPKrIamHWHgXZXMSLMrUsuS2XjspkydjsONjV4yZUOMAFmqWCDQGwcftG
         aXKEWsS8GOVWs83kH1hvEPe3K9G0Sw/LVOkAgzEs4g5f8frxazzww/WQw51ekpLMycd7
         XvkSk539vWfem8vjVkDeQRnI0j7+Ifbx7TfeKlNCNIESCmwIMCOeRC0zd/5Jm8odtuM8
         z1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eKwmN+9En8+NeURudR1q9AFdHqkfLXQ++oiNukepjQA=;
        b=DJFdat2aT+BMxyldwMQKsl7LE5NsZP3ExYKiXFu8DzE1jPeO5XObP/XbRh5u91pbxW
         Wg6VVMbzVdAmEWVh2Ex9vtzVUJ15/4wjduZ/Y9sYpqF1B5kBIvpeoV1qCSOSem+So7b+
         H68mzhNugSYs/s5Vc6B91XJoYPQNgVYH/mRMO6o7U7LR/nDtZ3MRvokMjPDyAZZZjoaM
         tND/7RM2z5tJYxVY4ga2g64gbmoUxpCVbuPJLpihS/gwSKvAxpvQs+J5ZagBhiqhiGJO
         tj7shxomd+wHGQ/XAsNAKtFvv8gKYsBtMbR5CPMIuywRkXlOstcPIj+wFp2wE/AEiO1H
         dHaQ==
X-Gm-Message-State: AOAM533VvsFml2TF0r8eb6SXrZnKP6UDpF1J3TS+hks+4wV6dKqN9Tw+
        NuhOYqnc7AJ4cI+c/s04hr5l6O00rcVe4XfOAignvA==
X-Google-Smtp-Source: ABdhPJxR9JbXRuYigOdoqSzF1TRactcfi29J8SWmTcXcssCkRljc05tR83BCZOuHeG+0Stw6rxdeAcff9bmyTvwr8fk=
X-Received: by 2002:a25:780a:0:b0:633:ccea:3430 with SMTP id
 t10-20020a25780a000000b00633ccea3430mr22037826ybc.26.1648469948956; Mon, 28
 Mar 2022 05:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220324172913.26293-1-jean-philippe@linaro.org>
 <6dca1c23-e72e-7580-31ba-0ef1dfe745ad@huawei.com> <SA1PR15MB5137A34F08A624A565150338BD1A9@SA1PR15MB5137.namprd15.prod.outlook.com>
 <YkGjxox4gsJrWvJT@myrica>
In-Reply-To: <YkGjxox4gsJrWvJT@myrica>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 28 Mar 2022 15:18:32 +0300
Message-ID: <CAC_iWjJEbegY+Uxipxck97Qvrn7EY4fiBJ2dLTzqbgYReXebfg@mail.gmail.com>
Subject: Re: [PATCH net] skbuff: disable coalescing for page_pool recycling
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Apologies for chiming in late.

On Mon, 28 Mar 2022 at 15:02, Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Fri, Mar 25, 2022 at 02:50:46AM +0000, Alexander Duyck wrote:
> > > >     The problem is here: both SKB1 and SKB2 point to PAGE2 but SKB1=
 does
> > > >     not actually hold a reference to PAGE2.
> > >
> > > it seems the SKB1 *does* hold a reference to PAGE2 by calling
> > > __skb_frag_ref(), which increments the page->_refcount instead of
> > > incrementing pp_frag_count, as skb_cloned(SKB3) is true and
> > > __skb_frag_ref() does not handle page pool
> > > case:
> > >
> > > INVALID URI REMOVED
> > > rc1/source/net/core/skbuff.c*L5308__;Iw!!Bt8RZUm9aw!u944ZiA7uzBuFvccr
> > > rtR1xvondLNnkMf5xzM8xbbkosow-v5t-XdZJd6bMsByMx2Kw$
> >
> > I'm confused here as well. I don't see a path where you can take owners=
hip of the page without taking a reference.
> >
> > Specifically the skb_head_is_locked() won't let you steal the head if t=
he skb is cloned. And then for the frags they have an additional reference =
taken if the skb is cloned.
> >
> > >  Without coalescing, when
> > > >     releasing both SKB2 and SKB3, a single reference to PAGE2 would=
 be
> > > >     dropped. Now when releasing SKB1 and SKB2, two references to PA=
GE2
> > > >     will be dropped, resulting in underflow.
> > > >
> > > >  (3c) Drop SKB2:
> > > >
> > > >       af_packet_rcv(SKB2)
> > > >         consume_skb(SKB2)
> > > >           skb_release_data(SKB2)                // drops second dat=
aref
> > > >             page_pool_return_skb_page(PAGE2)    // drops one pp_fra=
g_count
> > > >
> > > >                       SKB1 _____ PAGE1
> > > >                            \____
> > > >                                  PAGE2
> > > >                                  /
> > > >                 RX_BD3 _________/
> > > >
> > > > (4) Userspace calls recvmsg()
> > > >     Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1=
, we
> > > >     release the SKB3 page as well:
> > > >
> > > >     tcp_eat_recv_skb(SKB1)
> > > >       skb_release_data(SKB1)
> > > >         page_pool_return_skb_page(PAGE1)
> > > >         page_pool_return_skb_page(PAGE2)        // drops second
> > > pp_frag_count
> > > >
> > > > (5) PAGE2 is freed, but the third RX descriptor was still using it!
> > > >     In our case this causes IOMMU faults, but it would silently cor=
rupt
> > > >     memory if the IOMMU was disabled.
> >
> > I think I see the problem. It is when you get into steps 4 and 5 that y=
ou are actually hitting the issue. When you coalesced the page you ended up=
 switching the page from a page pool page to a reference counted page, but =
it is being stored in a page pool skb. That is the issue. Basically if the =
skb is a pp_recycle skb we should be incrementing the frag count, not the r=
eference count.
> > So essentially the logic should be that if to->pp_recycle is set but fr=
om is cloned then you need to return false. The problem isn't that they are=
 both pp_recycle skbs, it is that the from was cloned and we are trying to =
merge that into a pp_recycle skb by adding to the reference count of the pa=
ges.
>
> I agree with this, the problem is switching from a page_pool frag refcoun=
t
> to a page refcount. I suppose we could change __skb_frag_ref() to increas=
e
> the pp_frag_count but that's probably best left as future improvement, I
> don't want to break more than I fix here.

I would prefer if we managed to keep the skb bits completely agnostic
to page pool recycling (apart from the obvious pp_recycle flag which
belongs to an skb to begin with).

> I'll send a v2 with a check on
> (cloned(from) && from->pp_recycle)

Coalescing is helping a lot wrt to processing packets and speeding up
things,  so completely removing it from page pool allocated buffers is
not what we want.  Limiting that to cloned page pool allocated SKBs
sounds reasonable I guess.

Thanks
/Ilias

>
> Thanks,
> Jean
>
> >
> > > > A proper implementation would probably take another reference from =
the
> > > > page_pool at step (3b), but that seems too complicated for a fix. K=
eep
> > > > it simple for now, prevent coalescing for page_pool users.
