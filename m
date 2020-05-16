Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0761D64C7
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 01:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgEPXxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 19:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726719AbgEPXxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 19:53:04 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692A6C05BD09
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 16:53:04 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d22so4867804lfm.11
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 16:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTOjg3LRKrOjZRaH+MBDwrWQ5QHycpS6ns5xrDhIPQU=;
        b=U1Hw8S8Ez1s26H+C7pGO1kjxeK+sPTVI/z5nX39rct4L2PiislzUljGXwNawxrIVc1
         CAerMm7TVyp+RbCU7OUnur9kefVzVsdlo0TouI8ATDIG0vk+6K+t1N1cZ7IUoVlOUALN
         sUKapGdU8n+9LV7zek6BnrmwjdtQGTHfbcpdt33B14UNMGDo8pwPim+6coFHxhNmJ6UK
         azckhOkGBYnfTGNpVTASqLiqCf23MUkWeNI8Hn6WBFnH7p305/ZNH1wlkZuGejL8fEBi
         U7yFY9xUoIgP/ywCN1FIfVvYe/MICTHZh1sJKEjF4GC/QZvbBdeG9gGgnBpOp0dbuB+n
         RchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTOjg3LRKrOjZRaH+MBDwrWQ5QHycpS6ns5xrDhIPQU=;
        b=fTXr2gIYHkwN5+tZM4MUXYX25/9oTrhF7aS4U+zMrN/ExtgKts7O/lqfvgx2zhSaqv
         7XBELof7SGCSWg8rBbsaU8m8NCp7I/pieSxw0onXcCkknDmW/48MHQfL72CFdmGHD2wD
         yvbf1USjSCf7Q3/tyxhMgWM13c9IqbOk04mcH2eqiQ7IpsHSECq6MqPrAi5na9eoh2w6
         9WNlQJQmEgEHRbSLxyYOXxZSccq5nnkGPq+cKTPo1igJSJLpUqa8TRVZSuUGE0H/qUDz
         YJUeDg1Hvga+G+EUqomgjozjrd0bcUDJpjz6EU0A4TzXHiMawVd2O+jlXnreF+rpRhEf
         SxQg==
X-Gm-Message-State: AOAM5334eaZuuz6JJIiUQzcs/ypTImjRtK2kmDQTRimUbh16uEWIT0TO
        JlbyPETYySakSz9tmEj8Q6ztIWk1nR9v61LFnhtjyg==
X-Google-Smtp-Source: ABdhPJxFg6Br+F3mfeEIVbPQPPWU4BQ1MiaAuBlHfXbkGVPTd6FVFzu+L7aXuGKZs0dkcczJTNgLtD1Ii7hmk99pxHw=
X-Received: by 2002:a19:d52:: with SMTP id 79mr5914680lfn.125.1589673182415;
 Sat, 16 May 2020 16:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200516021736.226222-1-shakeelb@google.com> <20200516.134018.1760282800329273820.davem@davemloft.net>
 <CALvZod7euq10j6k9Z_dej4BvGXDjqbND05oM-u6tQrLjosX31A@mail.gmail.com> <CANn89iJ9BYNi__DhLp_QE5JU7=RxkzknOSxD+P+qiHg2=Ho6Ow@mail.gmail.com>
In-Reply-To: <CANn89iJ9BYNi__DhLp_QE5JU7=RxkzknOSxD+P+qiHg2=Ho6Ow@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sat, 16 May 2020 16:52:51 -0700
Message-ID: <CALvZod6b2tHDGGzkspxT1r7c4So95BpUagPcwgUVf+++5eX5Hw@mail.gmail.com>
Subject: Re: [PATCH] net/packet: simply allocations in alloc_one_pg_vec_page
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 3:45 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, May 16, 2020 at 3:35 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Sat, May 16, 2020 at 1:40 PM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Shakeel Butt <shakeelb@google.com>
> > > Date: Fri, 15 May 2020 19:17:36 -0700
> > >
> > > > and thus there is no need to have any fallback after vzalloc.
> > >
> > > This statement is false.
> > >
> > > The virtual mapping allocation or the page table allocations can fail.
> > >
> > > A fallback is therefore indeed necessary.
> >
> > I am assuming that you at least agree that vzalloc should only be
> > called for non-zero order allocations. So, my argument is if non-zero
> > order vzalloc has failed (allocations internal to vzalloc, including
> > virtual mapping allocation and page table allocations, are order 0 and
> > use GFP_KERNEL i.e. triggering reclaim and oom-killer) then the next
> > non-zero order page allocation has very low chance of succeeding.
>
>
> 32bit kernels might have exhausted their vmalloc space, yet they can
> still allocate order-0 pages.

Oh ok it makes sense.
