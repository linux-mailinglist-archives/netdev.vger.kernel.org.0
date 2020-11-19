Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6594E2B9CC0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgKSVLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgKSVLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:11:47 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CA3C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:11:47 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lv15so4068476ejb.12
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RLdXfBh08auw1e90q2eGblODEvJ+CFvALyNfcPcJ12s=;
        b=q1EXtpK1Bc25KM3CdwjNs9tKhWPGKlPm5nFsbpdKCBsR2Vq+FE+lyRztuYd9zz3Nx1
         MSUTb56w289WZcq2RJFFC0Lot7VcWZYGTQ7I3amdGY2zs9CGUmm3vc/zdkHZIoePGRiz
         7CbtrngS5BttJBqh0kATFNlIML1q9NgZopX4O9FEELF/tfIDZO10kgMJayk5dom6D6kf
         s13mJUL/x1Mxuw3P0VsbxteZeZRLnQeSFA8a0ayCQSg+WLdrlspDzdaDzL/Fq3sTUVPl
         8Ts0P3OBCiTDGbSCh1WeMq/S8SOOCFcwSYvkmX4s346uJVD27MBZdMAVOI0NmVhgmxG2
         XjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLdXfBh08auw1e90q2eGblODEvJ+CFvALyNfcPcJ12s=;
        b=YiuPhYu7fQ2O0jZR3YAuTjrE9VpSCnOTkb5c1TLu+Df8qjV7xGVdeqWZzMdg34UvSW
         H7ef3p2VieY2Gafp9DNpziMDZcY1H3C76hFdcfS1lB4ytrarhUT9bo/8VbbYY48MDa95
         TM7VFz3aD6VoovJ7CTgMBKvibSezM39Me79rCw6C7hppptOpaRcB6f7JziyNPeWkWauQ
         k+ahvqWJg6VcrYtUI9x0u99OqX08ZyFPbEP+dvpHoIYT35RTSlClPQXaTfg742ZobRe/
         eQOYhrY5Ejno2D7waP2smlaQvwx1uc/Hs9Va+D2D6JwW6DlOswrouRJn8iYjPoA0JVao
         +UPg==
X-Gm-Message-State: AOAM531yFeVe2DQzv8/1dx2HIxuVIxx9POZxAqcQ9FAdRHJnJVun5hcb
        4zTTxB4lIhP1uVKvC+d3F+19BITrX/pVbcwcIN87rw==
X-Google-Smtp-Source: ABdhPJwm8O2lvJPf7yx/NyqSaMOSofr8uU5hJkhFpHytu05oLxoTLyFnHJ0nToQ+aZwoNM1fzDlMwnX9Rv2vUK9TgYw=
X-Received: by 2002:a17:906:6896:: with SMTP id n22mr31614098ejr.56.1605820306064;
 Thu, 19 Nov 2020 13:11:46 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-3-awogbemila@google.com> <CAKgT0Ufx7NS0BDwx_egT9-Q9GwbUsBEWiAY8H5YyLFP1h2WQmw@mail.gmail.com>
 <CAL9ddJdL0KNp69J6tVn_1Bp8xxwo2JxKRVajHfAriY=pUH0r1g@mail.gmail.com> <CAKgT0UdG+fB=KNzro7zMg-617KcNCAL_dMZcqeL0JrcJuT4_CQ@mail.gmail.com>
In-Reply-To: <CAKgT0UdG+fB=KNzro7zMg-617KcNCAL_dMZcqeL0JrcJuT4_CQ@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 19 Nov 2020 13:11:35 -0800
Message-ID: <CAL9ddJfOcUbqDXgGHdeXMa=P5HO5uW+-U2uDWz+pw0FJgjFEQA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 2/4] gve: Add support for raw addressing to
 the rx path
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 8:25 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 3:15 PM David Awogbemila <awogbemila@google.com> wrote:
> >
> > On Wed, Nov 11, 2020 at 9:20 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> > > >
> > > > From: Catherine Sullivan <csully@google.com>
> > > >
> > > > Add support to use raw dma addresses in the rx path. Due to this new
> > > > support we can alloc a new buffer instead of making a copy.
> > > >
> > > > RX buffers are handed to the networking stack and are
> > > > re-allocated as needed, avoiding the need to use
> > > > skb_copy_to_linear_data() as in "qpl" mode.
> > > >
> > > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > > ---
>
> <snip>
>
> > > > @@ -399,19 +487,45 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
> > > >         return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
> > > >  }
> > > >
> > > > +static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
> > > > +{
> > > > +       bool empty = rx->fill_cnt == rx->cnt;
> > > > +       u32 fill_cnt = rx->fill_cnt;
> > > > +
> > > > +       while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
> > >
> > > So one question I would have is why do you need to mask fill_cnt and
> > > cnt here, but not above? Something doesn't match up.
> >
> > fill_cnt and cnt are both free-running uints with fill_cnt generally
> > greater than cnt
> > as fill_cnt tracks freed/available buffers while cnt tracks used buffers.
> > The difference between "fill_cnt == cnt" and "(fill_cnt & rx->mask) ==
> > (cnt & rx->mask)" is
> > useful when all the buffers are completely used up.
> > If all the descriptors are used up ("fill_cnt == cnt") when we attempt
> > to refill buffers, the right
> > hand side of the while loop's OR condition, "(fill_cnt & rx->mask) !=
> > (rx->cnt & rx->mask)"
> > will be false and we wouldn't get to attempt to refill the queue's buffers.
>
> I think I see what you are trying to get at, but it seems convoluted.
> Your first check is checking for the empty case where rx->fill_cnt ==
> rx->cnt. The second half of this is about pushing the count up so that
> you cause fill_cnt to wrap and come back around and be equal to cnt.
> That seems like a really convoluted way to get there.
>
> Why not just simplify this and do something like the following?:
> while (fill_cnt - rx->cnt  < rx->mask)
>
> I would argue that is much easier to read and understand rather than
> having to double up the cases by using the mask field as a mask on the
> free running counters.

Okay, that's simpler, I'll use that, thanks.
