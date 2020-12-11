Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5532D78FD
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437770AbgLKPRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437751AbgLKPQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:16:31 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E9AC061793;
        Fri, 11 Dec 2020 07:15:51 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id lt17so12832798ejb.3;
        Fri, 11 Dec 2020 07:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2aaKiEZk4U61gzkDJ4LumBR7Gh8KLHTbl34rXEDKxdA=;
        b=tQD4gNl+B6QDTrWDVzDJoMZRUwjCiu+0MyDOzGb/gCBcLPu0wlp6rj/CH/p/eh2/4h
         bAep1ZbVfdYguecbtPIGXAeX1HNJOzVLdojya8sWw/ZqL6P49umz/r7vPtQMILqPUA0B
         B+L0+JxdRfPMaNcDMq4PBHABxIyS3RdEEuxJ7s7gfBFHIaCHe5pG057ndUiB72qn2Wzp
         SSOpkNrOgJLyw+wXPmMUk0vcxIAPcwsAo8XAmBhSc4MEQy6ANJBc2xlErSF5ySl0UUz3
         jEkgKRfdXTp8dpqMdzowXgAFpNnL5+QBkV+SD6rIR99orsp4f5HhMwWgdMoPfhWhYpks
         ZKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2aaKiEZk4U61gzkDJ4LumBR7Gh8KLHTbl34rXEDKxdA=;
        b=Qy3k4MI6VbhHmNolVYhPjjbTq4uZoCd0p13MVvH5PsI1YAaxnT0h9eRRCgUWDBpXBQ
         oDShV62atAm8P0BdnfOBk92bsTlGmU4QloQ+i3y9jlfxG719YBDvxyM+78G2hSQsj0Ms
         /MUmJMbDTKlNRdsiAc6cZP7/3yL+ZHxTniCGhX3Yb8/O4QRE8fJNd0bj31nV5x0F/IIz
         JQwhfU82eZIBKL3H8mtRXKEwbg9aS75+P5ozhN0HPieZ1Fr7Zkw3PNa1Z33lO5VnXhzo
         UlfECr8Tu+xOWt/6BVWB15SdxfyvKnvgWIedkPi66G3LK81j2BaA8gVWokfVhXBAJ1WY
         2Hww==
X-Gm-Message-State: AOAM532sjdc8vCbpeKkbBQn8Sy7DNzbXDfYVj6a7vVV8nxJHWIrIWKs9
        X1sNClZUcU9tdzJTX4NsoJHAX8ZEClCH6WunPJ8=
X-Google-Smtp-Source: ABdhPJy+wt2enqGCJSJG6yroMv9oyr/vnzy4kxI/+aKNEAgXCu0iE28sjxXMrt0wn+mudx5PCERhwBLw3GJ9SY42f6w=
X-Received: by 2002:a17:906:8255:: with SMTP id f21mr11103776ejx.265.1607699749861;
 Fri, 11 Dec 2020 07:15:49 -0800 (PST)
MIME-Version: 1.0
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com> <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
 <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-LkknU3GwJgG_OiMPFONZtO3ECHEX0QfTaUTTX_N0i-KA@mail.gmail.com>
 <VI1PR10MB24460D805E8091EB09F81199ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-Lf=JpkXvGs=AGtyhCEFcG_8_WgnNbg1cbGownohsHw8g@mail.gmail.com> <87r1nxxk3u.fsf@intel.com>
In-Reply-To: <87r1nxxk3u.fsf@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 11 Dec 2020 10:15:13 -0500
Message-ID: <CAF=yD-Ladcx-xFWD__9ybz0=iKLJ4=1yWpiZ0GJu4YfmSvp7wQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "Geva, Erez" <erez.geva.ext@siemens.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vedang Patel <vedang.patel@intel.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> >>>> I did not use "Fair Queue traffic policing".
> >> >>>> As for ETF, it is all about ordering packets from different applications.
> >> >>>> How can we achive it with skiping queuing?
> >> >>>> Could you elaborate on this point?
> >> >>>
> >> >>> The qdisc can only defer pacing to hardware if hardware can ensure the
> >> >>> same invariants on ordering, of course.
> >> >>
> >> >> Yes, this is why we suggest ETF order packets using the hardware time-stamp.
> >> >> And pass the packet based on system time.
> >> >> So ETF query the system clock only and not the PHC.
> >> >
> >> > On which note: with this patch set all applications have to agree to
> >> > use h/w time base in etf_enqueue_timesortedlist. In practice that
> >> > makes this h/w mode a qdisc used by a single process?
> >>
> >> A single process theoretically does not need ETF, just set the skb-> tstamp and use a pass through queue.
> >> However the only way now to set TC_SETUP_QDISC_ETF in the driver is using ETF.
> >
> > Yes, and I'd like to eventually get rid of this constraint.
> >
>
> I'm interested in these kind of ideas :-)
>
> What would be your end goal? Something like:
>  - Any application is able to set SO_TXTIME;
>  - We would have a best effort support for scheduling packets based on
>  their transmission time enabled by default;
>  - If the hardware supports, there would be a "offload" flag that could
>  be enabled;
>
> More or less this?

Exactly. Pacing is stateless, so relatively amenable to offload.

For applications that offload pacing to the OS with SO_TXTIME, such as
QUIC, further reduce jitter and timer wake-ups (and thus cycles) by
offloading to hardware.

Not only for SO_TXTIME, also for pacing initiated by the kernel TCP stack.

Initially, in absence of hardware support, at least in virtual environments
offload from guest to host OS.
