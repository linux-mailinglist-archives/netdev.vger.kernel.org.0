Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2136F8B0
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 12:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhD3Kwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 06:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhD3Kwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 06:52:50 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC39AC06174A;
        Fri, 30 Apr 2021 03:52:01 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id i11so7597966oig.8;
        Fri, 30 Apr 2021 03:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J+unp5PxhVpVjsMmrUBBaWya53dQDO0EzZZu8+eM3+I=;
        b=XFHLC735K7ymnVmtQsWhC9FjVFYpPScmcTv2+RP1VW9z5oYgd1lAwOwOstSswRHOyJ
         545q0JFeb6kq4yr3xq4WtmT204UlhCQe2bHRTnAl0V98tmL7mX+pGvMPiFERGVP82aan
         ERKH3L3ZUx/TpBmnNmL88zLhIJ7NkKw/IBh65AAuILate/SB2OUS5Ie9bXtr1+Bp6bZw
         qWrw7dkt6/1Gamrwmi8t4woaEIeo86TIFP3X0hDg6+eP4QFZvli5k7XJZlakS9640N4P
         zzXGO7dUPj+uOBcBHxZ6lxhbAI0P1WgRWYqPaGzPL85N11mpeMkFQ0UPCabuL/8PR2Zy
         /WwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+unp5PxhVpVjsMmrUBBaWya53dQDO0EzZZu8+eM3+I=;
        b=gpyUN9ZDkVhKz73RPPNzte9GpeMgPiO5r6Fo5hDiwe6C2Tjit+81ahZg3No1neHBdu
         yHvtUSpufYGjYtGM+p5xPjgmTz7HIOs1nQYetNS5vt6maRuOJUEjfMlKW1JuVzIFAp9C
         nKgD9t03Hwp9Sb3xnbSncsEqzui8vu2wFMJZbsX9UlyYuleidOrPy+uoc+dcV29lXiNz
         flZNMK9qjavVfZhVZIQSb3ZRVJZVaxb9rjyw051tstZIQLYyL7xAb0D1iLdADIr2BCaf
         9TTq8YDDmRIZPAMCxYWbLaDYNQg3u+KcmqXM+FnwcNQNZfbb4fZn/FSiA8jZkN3xn16O
         P0Jg==
X-Gm-Message-State: AOAM533w1qjUcLyiclK4/zwRtNnjfPkJuKVUwDksCciiui6I595lOw8u
        m5WiUOIswdFbK0mC6Hck8yQRZvYWB2v09L//5+k=
X-Google-Smtp-Source: ABdhPJy+GiAEHYfOIz4cuRhk484cKT5p7rlLipy9wJQmZLHTz/2ayiVJDyo8ddyePyWeppIdMwRBplABoh4mqv59LoM=
X-Received: by 2002:aca:cf09:: with SMTP id f9mr10361216oig.95.1619779921114;
 Fri, 30 Apr 2021 03:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <20200604090014.23266-1-kerneljasonxing@gmail.com> <CANn89iKt=3iDZM+vUbCvO_aGuedXFhzdC6OtQMeVTMDxyp9bAg@mail.gmail.com>
 <CAL+tcoCU157eGmMMabT5icdFJTMEWymNUNxHBbxY1OTir0=0FQ@mail.gmail.com>
 <CAL+tcoA9SYUfge02=0dGbVidO0098NtT2+Ab_=OpWXnM82=RWQ@mail.gmail.com> <bcbaf21e-681e-2797-023e-000dbd6434d1@gmail.com>
In-Reply-To: <bcbaf21e-681e-2797-023e-000dbd6434d1@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 30 Apr 2021 18:51:25 +0800
Message-ID: <CAL+tcoB8q5q-Kp-Z8mfzStJHtDt9OmRzuS=i0VQ2KY_YSygQQQ@mail.gmail.com>
Subject: Re: [PATCH v2 4.19] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 11:33 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 8/11/20 3:37 AM, Jason Xing wrote:
> > Hi everyone,
> >
> > Could anyone take a look at this issue? I believe it is of high-importance.
> > Though Eric gave the proper patch a few months ago, the stable branch
> > still hasn't applied or merged this fix. It seems this patch was
> > forgotten :(
>
>
> Sure, I'll take care of this shortly.

Hi Eric,

It has been a very long time. It seems this issue was left behind and
almost forgotten, I think.
Could you mind taking some time to fix this up if you still consider
it as important?
Our team has been waiting for your patchset. Afterall, it once had a
huge impact on our
thousands and hundreds of machines.

thanks,
Jason

>
> Thanks.
>
> >
> > Thanks,
> > Jason
> >
> > On Thu, Jun 4, 2020 at 9:47 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >>
> >> On Thu, Jun 4, 2020 at 9:10 PM Eric Dumazet <edumazet@google.com> wrote:
> >>>
> >>> On Thu, Jun 4, 2020 at 2:01 AM <kerneljasonxing@gmail.com> wrote:
> >>>>
> >>>> From: Jason Xing <kerneljasonxing@gmail.com>
> >>>>
> >>>> When using BBR mode, too many tcp socks cannot be released because of
> >>>> duplicate use of the sock_hold() in the manner of tcp_internal_pacing()
> >>>> when RTO happens. Therefore, this situation maddly increases the slab
> >>>> memory and then constantly triggers the OOM until crash.
> >>>>
> >>>> Besides, in addition to BBR mode, if some mode applies pacing function,
> >>>> it could trigger what we've discussed above,
> >>>>
> >>>> Reproduce procedure:
> >>>> 0) cat /proc/slabinfo | grep TCP
> >>>> 1) switch net.ipv4.tcp_congestion_control to bbr
> >>>> 2) using wrk tool something like that to send packages
> >>>> 3) using tc to increase the delay and loss to simulate the RTO case.
> >>>> 4) cat /proc/slabinfo | grep TCP
> >>>> 5) kill the wrk command and observe the number of objects and slabs in
> >>>> TCP.
> >>>> 6) at last, you could notice that the number would not decrease.
> >>>>
> >>>> v2: extend the timer which could cover all those related potential risks
> >>>> (suggested by Eric Dumazet and Neal Cardwell)
> >>>>
> >>>> Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> >>>> Signed-off-by: liweishi <liweishi@kuaishou.com>
> >>>> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> >>>
> >>> That is not how things work really.
> >>>
> >>> I will submit this properly so that stable teams do not have to guess
> >>> how to backport this to various kernels.
> >>>
> >>> Changelog is misleading, this has nothing to do with BBR, we need to be precise.
> >>>
> >>
> >> Thanks for your help. I can finally apply this patch into my kernel.
> >>
> >> Looking forward to your patchset :)
> >>
> >> Jason
> >>
> >>> Thank you.
