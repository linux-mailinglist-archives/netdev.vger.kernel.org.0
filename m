Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9851CA552
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgEHHi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgEHHi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:38:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAED0C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 00:38:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 50so145532wrc.11
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 00:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u83FRgtfw4OcVu6HwuF64+XAx0e3gp0cIRwQwZTP4Fg=;
        b=RQz1BD5FPV9Bjt5oraTG3yF+V0Dcg+DKWqJLp0CleFmkHnDezam8GS2uhhQCHzVRT2
         duJqGMQIEMVLiWhUuqzJhlYeTNEyC9nB2MuDewvY1lIgL/bnOdgcPaMTtyeBFGcosci7
         LLRJsb0G1+oaw6n7ZNPe1HTYnYKQht2N8UBYtLrd+D2cteRmJnbkgNm92Damd8ZaIXYE
         xhpK23B/HmqZa36O7b3mk6xggmGnQixHW4SVfyQE2lSwItN7AzIHychpmJRqGp6ENNCO
         Cbtn8hbvf7zgFKjv0KM5aaR53EPeJV7+W4JrfcNYck4NKSUwnyxFMfy1R1F6fj2MNISM
         L+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u83FRgtfw4OcVu6HwuF64+XAx0e3gp0cIRwQwZTP4Fg=;
        b=b+d8EE38DHa5DUVqqauhV9Z5g2TwG9qwlkxM0GbEFpUp06KsceohLLivvP1PlgI4ch
         63Y8p59SLbS73fpyIBqUgy+kA+J5YbhOxpcW0x88L88nJSwHVMephTkATWsPZ9QGr3/R
         Bu6YgCxoNr1m/HKZs9SVMwliob07e83z0O8zda+i88haA/4E+ufRMo9Jh6QoogNIQYBe
         PcV2uvZeK3P/l2da7jxet8Nsqd7zJ6w6vbJUz1oV3EIwKaVcded0+ClKYtz2Bjs/07s7
         7OtJwZs+584r5i6tmIGMI2dpXg67fyCpNujPsoXAUWCv/+Q203zasTMTza1gr+OEy6lZ
         2ZTg==
X-Gm-Message-State: AGi0PuZDj4B3dzTJx3SIm+fAlsdVLDuWcItsN4vR2fVQC3nkIsfWJZVc
        quoHx0NXD8g0+lbKkNmotDPBymHKCy/M+rrhOGk=
X-Google-Smtp-Source: APiQypIjsA6oYX1mTEr0G/ZxOfgpuqSyxof/xIAFR4m98j5XLTBUDOFsS7tG15Isz9Pxw5QF8TTflx/QKVGPy9Mg8ac=
X-Received: by 2002:adf:8401:: with SMTP id 1mr1352871wrf.241.1588923504402;
 Fri, 08 May 2020 00:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200508040728.24202-1-haokexin@gmail.com> <CA+sq2CfMoOhrVz7tMkKiM3BwAgoyMj6i2RWz0JWwvpBMCO3Whg@mail.gmail.com>
 <20200508053015.GB3222151@pek-khao-d2.corp.ad.wrs.com>
In-Reply-To: <20200508053015.GB3222151@pek-khao-d2.corp.ad.wrs.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 8 May 2020 13:08:13 +0530
Message-ID: <CA+sq2CfmFaQ1=8m6vBOD6d_uoez2yU7KrAP1JUMo_nJbe=9_6g@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers
To:     Kevin Hao <haokexin@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 11:00 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> On Fri, May 08, 2020 at 10:18:27AM +0530, Sunil Kovvuri wrote:
> > On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
> > >
> > > In the current codes, the octeontx2 uses its own method to allocate
> > > the pool buffers, but there are some issues in this implementation.
> > > 1. We have to run the otx2_get_page() for each allocation cycle and
> > >    this is pretty error prone. As I can see there is no invocation
> > >    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
> > >    the allocated pages have the wrong refcount and may be freed wrongly.
> >
> > Thanks for pointing, will fix.
> >
> > > 2. It wastes memory. For example, if we only receive one packet in a
> > >    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
> > >    to refill the pool buffers and leave the remain area of the allocated
> > >    page wasted. On a kernel with 64K page, 62K area is wasted.
> > >
> > > IMHO it is really unnecessary to implement our own method for the
> > > buffers allocate, we can reuse the napi_alloc_frag() to simplify
> > > our code.
> > >
> > > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> >
> > Have you measured performance with and without your patch ?
>
> I will do performance compare later. But I don't think there will be measurable
> difference.
>
> > I didn't use napi_alloc_frag() as it's too costly, if in one NAPI
> > instance driver
> > receives 32 pkts, then 32 calls to napi_alloc_frag() and updates to page ref
> > count per fragment etc are costly.
>
> No, the page ref only be updated at the page allocation and all the space are
> used. In general, the invocation of napi_alloc_frag() will not cause the update
> of the page ref. So in theory, the count of updating page ref should be reduced
> by using of napi_alloc_frag() compare to the current otx2 implementation.
>

Okay, it seems i misunderstood it. Have tested this patch.
Tested-by: Sunil Goutham <sgoutham@marvell.com>
