Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABCB2419D5
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 12:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgHKKi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 06:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgHKKi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 06:38:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14B6C06174A;
        Tue, 11 Aug 2020 03:38:25 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m22so12886544ljj.5;
        Tue, 11 Aug 2020 03:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+bLBNXzgQroSX4+PzVIZrtth34ymbRY4TcegtKy4Abc=;
        b=OLa3xQZm0JeZlgpQUICKoZbLqSN8onKQOVvymh0Gv4seL+2Xm6Mqd1Mbgq0iSpIRQu
         gvfDSjYYdbt9X+mwKMNzNcRrCnXNVjsoknnDUCljJ/T6z4ETFsmhbETRnfKmHujJW5Ur
         2I6pRO7vDYhJ9zdnKoeURN7iNd3bX6ePhf4tajNpU1QOqpYMK75v36ylkyZEfZOUIf0w
         BZLwpeN5zn/xFPsL14uZj0mKOnNSBOOspd9g8PKzYbJ/VDmawQghHtPT14sFr+u5Gw9E
         8A+8SSpMgCC0O8Q+E1r9J4Hg1k4zOA0JtRb1S9ugnU2yJI/wqc9WyDliXsey4kJGAtnk
         BFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+bLBNXzgQroSX4+PzVIZrtth34ymbRY4TcegtKy4Abc=;
        b=e6dYNG7sVqUOoh2YinlusrBgrrk6fw84gIPKEwH1n3rQ5X6swf6X9A7EeOsHGPrszr
         acF/R83KeZoeZK8VcUhJImMVtPeFsB3IL7qlLG3YZ6dB9FwaQU5q/J7/pUjS49V3+Lvz
         t2LSjlWhJwrBcBgnwMX9gnENlQKJFNFt5RMUlhidQoi2ddgTZMF8KqdMH47/rB+A18Qo
         POB8zJZJrkkkmgQsafafO0o09SOorjNUUtv2t+WTt/OKK8tyH2ATgt3T6WOgSDuSWfNT
         2eKDzIRcP3XhyyKvVBymABMCG4Xm5R/dBUm/OVkY3350FbyaAc38uzBwrBpMd8QNJIzg
         XxhQ==
X-Gm-Message-State: AOAM530b7Tudxh/G9pj7EVviBtte0W2cCx9sjAwIjJ42dNjuXTUTrRIn
        +as5eAAQApezY7ka5BG14u8dcPblFadxRbEX2gpY01qk
X-Google-Smtp-Source: ABdhPJxJdqJPI5vPU+oq//e+QjYm5n5J7vMxbLpPbh+ipeXR5Q4QOw4TGWa64Ge0+IGZVaqJVGk0U5GnsSLm5r1YtGw=
X-Received: by 2002:a2e:8956:: with SMTP id b22mr2677961ljk.189.1597142303157;
 Tue, 11 Aug 2020 03:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <20200604090014.23266-1-kerneljasonxing@gmail.com> <CANn89iKt=3iDZM+vUbCvO_aGuedXFhzdC6OtQMeVTMDxyp9bAg@mail.gmail.com>
 <CAL+tcoCU157eGmMMabT5icdFJTMEWymNUNxHBbxY1OTir0=0FQ@mail.gmail.com>
In-Reply-To: <CAL+tcoCU157eGmMMabT5icdFJTMEWymNUNxHBbxY1OTir0=0FQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 11 Aug 2020 18:37:46 +0800
Message-ID: <CAL+tcoA9SYUfge02=0dGbVidO0098NtT2+Ab_=OpWXnM82=RWQ@mail.gmail.com>
Subject: Re: [PATCH v2 4.19] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <edumazet@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

Could anyone take a look at this issue? I believe it is of high-importance.
Though Eric gave the proper patch a few months ago, the stable branch
still hasn't applied or merged this fix. It seems this patch was
forgotten :(

Thanks,
Jason

On Thu, Jun 4, 2020 at 9:47 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Thu, Jun 4, 2020 at 9:10 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Jun 4, 2020 at 2:01 AM <kerneljasonxing@gmail.com> wrote:
> > >
> > > From: Jason Xing <kerneljasonxing@gmail.com>
> > >
> > > When using BBR mode, too many tcp socks cannot be released because of
> > > duplicate use of the sock_hold() in the manner of tcp_internal_pacing()
> > > when RTO happens. Therefore, this situation maddly increases the slab
> > > memory and then constantly triggers the OOM until crash.
> > >
> > > Besides, in addition to BBR mode, if some mode applies pacing function,
> > > it could trigger what we've discussed above,
> > >
> > > Reproduce procedure:
> > > 0) cat /proc/slabinfo | grep TCP
> > > 1) switch net.ipv4.tcp_congestion_control to bbr
> > > 2) using wrk tool something like that to send packages
> > > 3) using tc to increase the delay and loss to simulate the RTO case.
> > > 4) cat /proc/slabinfo | grep TCP
> > > 5) kill the wrk command and observe the number of objects and slabs in
> > > TCP.
> > > 6) at last, you could notice that the number would not decrease.
> > >
> > > v2: extend the timer which could cover all those related potential risks
> > > (suggested by Eric Dumazet and Neal Cardwell)
> > >
> > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> >
> > That is not how things work really.
> >
> > I will submit this properly so that stable teams do not have to guess
> > how to backport this to various kernels.
> >
> > Changelog is misleading, this has nothing to do with BBR, we need to be precise.
> >
>
> Thanks for your help. I can finally apply this patch into my kernel.
>
> Looking forward to your patchset :)
>
> Jason
>
> > Thank you.
