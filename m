Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F03755B6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhEFOdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhEFOdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:33:50 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21A1C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:32:52 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id o5so5119030qkb.0
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qSpalX6I9jZafKbC++LSPBR3ku3l2X6C4IjSObdDUAY=;
        b=HIL3W3Wb7y9OecKdx7s21hxAMa3kP4yMQO9aJjWPJrCPE4Q/sFJYSztyDg5SFxQyBC
         cTOI33S6CuI3MARnSh23+CDSd7Mc89s8nvgPUUYEga7usV4jbVFJSUnvhqhAIfp4xaPr
         TmC9EqzaLv7EXVvDR35GX3uyk8HFGr/zXHwcRP/rIZnukqDrM9FJC08PzxJTxxWaECFh
         4b2nOX4d5dRYY+XyKy5h7IeaSSJViZe6ybjRLc+1VinNh9jcIbZMkk8Sw8r34DBYgjLv
         qYGdlG3CXNUU7cvhLc9gxZ+xbHJhTRwbizkC17vcSEFGIFzqbWdqiasovqAVRtGZCl3B
         TuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qSpalX6I9jZafKbC++LSPBR3ku3l2X6C4IjSObdDUAY=;
        b=P8y2zhc1QPNUy1TBFwl1i8xamVb0SYgt3A3Blbl8uysz2re6PmHrbBNY8aJNbCzmLb
         7tzWjfkQpHkPGxm+aUI3fkeIFC6UiMMDy7Yxo0KnhgURkXgte+UeWNWaSrW0x4E3uIPD
         +l+gEDqF5VUK5wn8iPNt/78pT1YrH2bIKEm8jsfM/l803HrD636C3wcDCLMCkp+qc6CC
         Fftrp9BOgltFlMIxlYfuIPFrCTn1Shd7JNFpAW7q1Ssm3I9NmjeOQRSy2jXYHPdAm6WR
         EJGdNsbpZtf8spjqJgVkEk3yh0ievcTLxDAkd6vQgLLKjIrssuDmB+v2hYJBu5+xq1cn
         Y9gQ==
X-Gm-Message-State: AOAM533bJKyEnNPbQMyvXg60TFyau4+b3waLj/zldXiVvvGfA+o6GPw6
        xMwPQi573sf3dkCekLGSFkZQaTr3jxg/eVG97pU=
X-Google-Smtp-Source: ABdhPJxwE3PghiwKemYCeNjlk3ahbe1dxjD9E0FKxn9BP5wRJjVHKxIPawIaqag7HqDVb+h0wFkDxTkozxMLeuwuNeg=
X-Received: by 2002:ae9:dc41:: with SMTP id q62mr4176764qkf.22.1620311571931;
 Thu, 06 May 2021 07:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620223174.git.pabeni@redhat.com> <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
 <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
 <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
 <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com> <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
In-Reply-To: <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 May 2021 10:32:16 -0400
Message-ID: <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 7:07 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2021-05-05 at 13:30 -0400, Willem de Bruijn wrote:
> > On Wed, May 5, 2021 at 1:28 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Wed, 2021-05-05 at 12:13 -0400, Willem de Bruijn wrote:
> > > > On Wed, May 5, 2021 at 11:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
> > > > > callback is available, the skb destructor is invoked on each
> > > > > aggregated packet via skb_release_head_state().
> > > > >
> > > > > Such field (and the pairer skb->sk) is left untouched, so the same
> > > > > destructor is invoked again when the segmented skbs are freed, leading
> > > > > to double-free/UaF of the relevant socket.
> > > >
> > > > Similar to skb_segment, should the destructor be swapped with the last
> > > > segment and callback delayed, instead of called immediately as part of
> > > > segmentation?
> > > >
> > > >         /* Following permits correct backpressure, for protocols
> > > >          * using skb_set_owner_w().
> > > >          * Idea is to tranfert ownership from head_skb to last segment.
> > > >          */
> > > >         if (head_skb->destructor == sock_wfree) {
> > > >                 swap(tail->truesize, head_skb->truesize);
> > > >                 swap(tail->destructor, head_skb->destructor);
> > > >                 swap(tail->sk, head_skb->sk);
> > > >         }
> > >
> > > My understanding is that one assumption in the original
> > > SKB_GSO_FRAGLIST implementation was that SKB_GSO_FRAGLIST skbs are not
> > > owned by any socket.
> > >
> > > AFAICS the above assumption was true until:
> > >
> > > commit c75fb320d482a5ce6e522378d137fd2c3bf79225
> > > Author: Paolo Abeni <pabeni@redhat.com>
> > > Date:   Fri Apr 9 13:04:37 2021 +0200
> > >
> > >     veth: use skb_orphan_partial instead of skb_orphan
> > >
> > > after that, if the skb is owned, skb->destructor is sock_efree(), so
> > > the above code should not trigger.
> >
> > Okay, great.
> >
> > > More importantly SKB_GSO_FRAGLIST can only be applied if the inner-
> > > most protocol is UDP, so
> > > commit 432c856fcf45c468fffe2e5029cb3f95c7dc9475
> > > and d6a4a10411764cf1c3a5dad4f06c5ebe5194488b should not be relevant.
> >
> > I think the first does apply, as it applies to any protocol that uses
> > sock_wfree, not just tcp_wfree? Anyway, the point is moot indeed.
>
> If we want to be safe about future possible sock_wfree users, I think
> the approach here should be different: in skb_segment(), tail-
> >destructor is expected to be NULL, while skb_segment_list(), all the
> list skbs can be owned by the same socket. Possibly we could open-
> code skb_release_head_state(), omitting the skb orphaning part
> for sock_wfree() destructor.
>
> Note that the this is not currently needed - sock_wfree destructor
> can't reach there.
>
> Given all the above, I'm unsure if you are fine with (or at least do
> not oppose to) the code proposed in this patch?

Yes. Thanks for clarifying, Paolo.
