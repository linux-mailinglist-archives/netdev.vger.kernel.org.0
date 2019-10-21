Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8DDF321
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfJUQb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:31:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726332AbfJUQb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571675487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6w7dW9mOc7e8F/WURa36AE0ItFqfFxyky2HnpydUOE0=;
        b=SF5OKUrDsDTeU/iz/G/ugCJQcqZq/jkqnxdZEOUonKgs2OLFGeRPY+nKhcnRxEx7DSaR9R
        SuhEeyobKyRoaDSYx8EGMVseVQ+6iRky7Yb/C7rboTayDuSuleJhZvXGlR4CRiDEIhUSHc
        L5IYRb1hDUL6DmAUS4KVdOs+Jn/YDhY=
Received: from mail-yw1-f72.google.com (mail-yw1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-PBJlcdQFPkiILZ1bK4bwPA-1; Mon, 21 Oct 2019 12:31:26 -0400
Received: by mail-yw1-f72.google.com with SMTP id j15so10890184ywg.22
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fsdy/jGiGhYO0LCoELtFkTkwnBVL5KY786AsoYKXAR4=;
        b=avyxzQq4jcyVOtHV2Yzu3fdk9F1Lqh6pNxOomqXgNvP1glBLXWvO77BzHFmeuQJfzM
         LYsBYYpjZ4inbcBmE4yc3NVr3nOIVcn64oAyFRUK6858Y38d/4D+DLO+tQ5wMD/XCAkw
         2kc7EROWi0ke3DPKpoV35lyeWpM4fDl2Q7MybSgaGEFoBtRWmvUhEymWM0ipMJhyzuw1
         GyUnJScSrU93YQGhu3kSrVuo3tDxxRUSN8EDIR5r1SnIHNiIu3xU4sC0NUKn85KmOm+H
         RzfHT609vUEhlpZC8kyN2Oj01QnTGo8ahbw4XAfKTsKCo+v46xpYl4XvUKkJsagvOAPu
         yXRQ==
X-Gm-Message-State: APjAAAVawUlVMtJA6oJidtqyoipBieOYVM7y3cRFQUuVAkxSwbX/EYdz
        mRmSyJTg6wBloQolgRZsAJldlUrhOLBBg7bWuwAbOkjpx/Jv0N+pc5NplI6YzK7kH8YMBzbEMLw
        MyJR7onaNwn8AEDu2j84AQuGLt8qkUstS
X-Received: by 2002:a05:6902:4c8:: with SMTP id v8mr16247512ybs.66.1571675485763;
        Mon, 21 Oct 2019 09:31:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxciDyD1lopQLg+gvSHhlech/D0NjAF1pJvvntU8U9FKaM9F7s7bZSlGbX3GSbC/6IuqejGRuqLtQKO7Q/5Jvs=
X-Received: by 2002:a05:6902:4c8:: with SMTP id v8mr16247482ybs.66.1571675485370;
 Mon, 21 Oct 2019 09:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <CACVy4SVuw0Qbjiv6PLRn1symoxGzyBMZx2F5O23+jGZG6WHuYA@mail.gmail.com>
 <20191021083731.GK15862@gauss3.secunet.de>
In-Reply-To: <20191021083731.GK15862@gauss3.secunet.de>
From:   Tom Rix <trix@redhat.com>
Date:   Mon, 21 Oct 2019 09:31:13 -0700
Message-ID: <CACVy4SV3K257XfFkR_ahkU2yy9mzJD-9LrSiQPCnespB3k_0XQ@mail.gmail.com>
Subject: Re: [PATCH] xfrm : lock input tasklet skb queue
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-MC-Unique: PBJlcdQFPkiILZ1bK4bwPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When preempt rt is full, softirq and interrupts run in kthreads. So it
is possible for the tasklet to sleep and for its queue to get modified
while it sleeps.

On Mon, Oct 21, 2019 at 1:37 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Sun, Oct 20, 2019 at 08:46:10AM -0700, Tom Rix wrote:
> > On PREEMPT_RT_FULL while running netperf, a corruption
> > of the skb queue causes an oops.
> >
> > This appears to be caused by a race condition here
> >         __skb_queue_tail(&trans->queue, skb);
> >         tasklet_schedule(&trans->tasklet);
> > Where the queue is changed before the tasklet is locked by
> > tasklet_schedule.
> >
> > The fix is to use the skb queue lock.
> >
> > Signed-off-by: Tom Rix <trix@redhat.com>
> > ---
> >  net/xfrm/xfrm_input.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> > index 9b599ed66d97..226dead86828 100644
> > --- a/net/xfrm/xfrm_input.c
> > +++ b/net/xfrm/xfrm_input.c
> > @@ -758,12 +758,16 @@ static void xfrm_trans_reinject(unsigned long dat=
a)
> >      struct xfrm_trans_tasklet *trans =3D (void *)data;
> >      struct sk_buff_head queue;
> >      struct sk_buff *skb;
> > +    unsigned long flags;
> >
> >      __skb_queue_head_init(&queue);
> > +    spin_lock_irqsave(&trans->queue.lock, flags);
> >      skb_queue_splice_init(&trans->queue, &queue);
> >
> >      while ((skb =3D __skb_dequeue(&queue)))
> >          XFRM_TRANS_SKB_CB(skb)->finish(dev_net(skb->dev), NULL, skb);
> > +
> > +    spin_unlock_irqrestore(&trans->queue.lock, flags);
> >  }
> >
> >  int xfrm_trans_queue(struct sk_buff *skb,
> > @@ -771,15 +775,20 @@ int xfrm_trans_queue(struct sk_buff *skb,
> >                     struct sk_buff *))
> >  {
> >      struct xfrm_trans_tasklet *trans;
> > +    unsigned long flags;
> >
> >      trans =3D this_cpu_ptr(&xfrm_trans_tasklet);
> > +    spin_lock_irqsave(&trans->queue.lock, flags);
>
> As you can see above 'trans' is per cpu, so a spinlock
> is not needed here. Also this does not run in hard
> interrupt context, so irqsave is also not needed.
> I don't see how this can fix anything.
>
> Can you please explain that race a bit more detailed?
>

