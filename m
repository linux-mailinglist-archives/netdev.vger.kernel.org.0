Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFAF2B97D3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKSQZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgKSQZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:25:46 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D26CC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:25:46 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i9so6722399ioo.2
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Amk92XByjR3F/5y7FmfHnJ2Hcyltt65mh2oq2R4XBPE=;
        b=QBH0flBZlJUqvMdGLicTS2kzdpgZ4awOeD9tVpWK+x3afA80zlzZZ8rJHt/HKrBdGn
         DiHIw2vLm1nYrFK5MYyUjwTMfOxgGtnTZbtKbMQKmsCQrvxIb4J8wNJy/WU+yg5fDB3m
         mH8VNBEK49OlSTvQVCKGkpONF53BnxXCu9lG8NK1lUbSC8ib9fGLYe7y/2xhdfBuYEL4
         LT2tvuYGoFA1Pqgpm9Fg9SyxVk2xM5ZDfKniUZBnYtlfdM6qaWMZyp7i3G0auZL9Ex28
         noc49C8jdJuzspyA01aqr7Hm6q8gcwOWbrPgVxOrqezE0jVBhyhIvRNJvc1mS6DkJ6og
         hh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Amk92XByjR3F/5y7FmfHnJ2Hcyltt65mh2oq2R4XBPE=;
        b=Z2uiA3pFwu79xH8nuaOAc88mlWYIv71dPbvXSGL0zULwPhtkO9VvjD0YKhvzXc9otF
         sVcupHW2uiMOOHksNP17QKi6WzgPotKasCJIun/bAlekx7MGJ4bUFYb5bkk5O/L5uDCs
         HeGw9vPA2pDq73ByJ+3aGgaMrhf4etfeEH91/zRIHk8tkCgfb+mAbf7p2/mpjdj62glJ
         /YVJGAB6D0FatEvkI5Xn3wiNFHhXgV7/ByXp0SXGWdS5UTxH/tWtVYmVe2XyUvC5QG76
         NLIzeOVsfuqcFOwvKDfOXt4IkF3RJCXm/iK+Os5KZwddnuyGEZSXokaO6QIPwDuJP2p1
         m1Jg==
X-Gm-Message-State: AOAM530y9n069T7OCWxsiHu3CYhRLQEhaqImiebyH5rIixzW3mT6FOt2
        V/rgSR0sjOESYpCJUHCrrlqjCZIhJEBb74qybDA=
X-Google-Smtp-Source: ABdhPJw2K1B/s5YgtnBs44+sG5PdoFunBjnOW/Sv2V9GJ/HAg+aTNJMaVz7mPlHk1pIKhYdyEnX6uDe3vUt+SjsZNLQ=
X-Received: by 2002:a6b:e40f:: with SMTP id u15mr20571660iog.88.1605803145803;
 Thu, 19 Nov 2020 08:25:45 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-3-awogbemila@google.com> <CAKgT0Ufx7NS0BDwx_egT9-Q9GwbUsBEWiAY8H5YyLFP1h2WQmw@mail.gmail.com>
 <CAL9ddJdL0KNp69J6tVn_1Bp8xxwo2JxKRVajHfAriY=pUH0r1g@mail.gmail.com>
In-Reply-To: <CAL9ddJdL0KNp69J6tVn_1Bp8xxwo2JxKRVajHfAriY=pUH0r1g@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 19 Nov 2020 08:25:34 -0800
Message-ID: <CAKgT0UdG+fB=KNzro7zMg-617KcNCAL_dMZcqeL0JrcJuT4_CQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 2/4] gve: Add support for raw addressing to
 the rx path
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 3:15 PM David Awogbemila <awogbemila@google.com> wrote:
>
> On Wed, Nov 11, 2020 at 9:20 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> > >
> > > From: Catherine Sullivan <csully@google.com>
> > >
> > > Add support to use raw dma addresses in the rx path. Due to this new
> > > support we can alloc a new buffer instead of making a copy.
> > >
> > > RX buffers are handed to the networking stack and are
> > > re-allocated as needed, avoiding the need to use
> > > skb_copy_to_linear_data() as in "qpl" mode.
> > >
> > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > ---

<snip>

> > > @@ -399,19 +487,45 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
> > >         return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
> > >  }
> > >
> > > +static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
> > > +{
> > > +       bool empty = rx->fill_cnt == rx->cnt;
> > > +       u32 fill_cnt = rx->fill_cnt;
> > > +
> > > +       while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
> >
> > So one question I would have is why do you need to mask fill_cnt and
> > cnt here, but not above? Something doesn't match up.
>
> fill_cnt and cnt are both free-running uints with fill_cnt generally
> greater than cnt
> as fill_cnt tracks freed/available buffers while cnt tracks used buffers.
> The difference between "fill_cnt == cnt" and "(fill_cnt & rx->mask) ==
> (cnt & rx->mask)" is
> useful when all the buffers are completely used up.
> If all the descriptors are used up ("fill_cnt == cnt") when we attempt
> to refill buffers, the right
> hand side of the while loop's OR condition, "(fill_cnt & rx->mask) !=
> (rx->cnt & rx->mask)"
> will be false and we wouldn't get to attempt to refill the queue's buffers.

I think I see what you are trying to get at, but it seems convoluted.
Your first check is checking for the empty case where rx->fill_cnt ==
rx->cnt. The second half of this is about pushing the count up so that
you cause fill_cnt to wrap and come back around and be equal to cnt.
That seems like a really convoluted way to get there.

Why not just simplify this and do something like the following?:
while (fill_cnt - rx->cnt  < rx->mask)

I would argue that is much easier to read and understand rather than
having to double up the cases by using the mask field as a mask on the
free running counters.
