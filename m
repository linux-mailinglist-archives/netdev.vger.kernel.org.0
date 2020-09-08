Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB3E2610F9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgIHLuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729305AbgIHLjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:39:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A55C061796;
        Tue,  8 Sep 2020 04:37:36 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so9844490pgd.5;
        Tue, 08 Sep 2020 04:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qZQdroSdlZPgLxB0axJE1VbD4VyjCyb0ExGeUn8jyYA=;
        b=feiWwlY5m5X/poukLCIXVUznp1v6YzwSnrYGs57mOqH1uqdlruhrRqUXK9I+yCkwZ9
         TF9cPtT9oE2gaTO+H5qgQMOhzLHULt6x95wPpYqi73TT+wh162RuJGlxgT4x5J3l2TUX
         bsPEd55MsOgYs51TVmFn7DzrVe2Bfmf2bAi33wH5MMn/0cmsigP3X/AmTWo5r/7r0wkE
         9UeTIMSmUGXeEZ++AVhACt6VwszBqAtDxBco7t032wfN79Q56dSW5aZIrCivqshweMYz
         ICQvCrqVZT2sJq4QXZbwl8HlqAVNrZZb3FL8Q/8Hf6HVOq4HtGAIy44KzVq2mX2eVPWm
         kzIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qZQdroSdlZPgLxB0axJE1VbD4VyjCyb0ExGeUn8jyYA=;
        b=SR09nKTG2nJeqGo7KDF/SMcid2EnWVWQOYXgJYunjrp3fjWYFHpAPwAiu7y7V3sJAO
         ctCmHpd+odNaA+7+Cyyew46x5bXdCEHIqO4giHugij7VxOOsCVZd92dkt4GMFO2B/bPS
         iUx6Zo1XmgBAa3ChK84nK3Gt7BqBLwueMzPql2GELY2zq3wLTpwSyPUH5WBdX+5CxK/R
         fseqnrwwOpQXsrK1WaU0JrnPKPNOd86cMj+yPKy0ZA9hsyOFFjlleDQ1lFHhWLQ05zNd
         1+o/DPXoRCX3WwMcDvbE59vDu6zyu5RnjIwjbdA95aN6xsWag7n92VXQ3SBpAdi1AHPi
         JP6w==
X-Gm-Message-State: AOAM532hFGG9fofJLKOjOvG9io/OvMcY1vvIgJS2GVlkuR8w3jcoa7CL
        /R9Q5sR9rT+XGHClFpTp3AqgmlK0niR74d9Yjp8=
X-Google-Smtp-Source: ABdhPJxvB/UAQ9/+LyteEXl5IYO+BqxIZARWPRi6EvCAUoapDZUTrScpa0vMM9G7scfpXEiQ5GcqmCkc4UEDn+aEC5k=
X-Received: by 2002:aa7:80d3:: with SMTP id a19mr24557164pfn.102.1599565055486;
 Tue, 08 Sep 2020 04:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200904135332.60259-1-bjorn.topel@gmail.com> <0257f769-0f43-a5b7-176d-7c5ff8eaac3a@intel.com>
 <11f663ec-5ea7-926c-370d-0b67d3052583@nvidia.com>
In-Reply-To: <11f663ec-5ea7-926c-370d-0b67d3052583@nvidia.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 8 Sep 2020 13:37:24 +0200
Message-ID: <CAJ8uoz3WbS7E1OiC5p8x+o48vwkN43R9JxMwvRvgVk4n3SNiZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is full
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        hawk@kernel.org, John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 12:33 PM Maxim Mikityanskiy <maximmi@nvidia.com> wro=
te:
>
> On 2020-09-04 16:59, Bj=C3=B6rn T=C3=B6pel wrote:
> > On 2020-09-04 15:53, Bj=C3=B6rn T=C3=B6pel wrote:
> >> This series addresses a problem that arises when AF_XDP zero-copy is
> >> enabled, and the kernel softirq Rx processing and userland process
> >> is running on the same core.
> >>
> > [...]
> >>
> >
> > @Maxim I'm not well versed in Mellanox drivers. Would this be relevant
> > to mlx5 as well?
>
> Thanks for letting me know about this series! So the basic idea is to
> stop processing hardware completions if the RX ring gets full, because
> the application didn't have chance to run? Yes, I think it's also
> relevant to mlx5, the issue is not driver-specific, and a similar fix is
> applicable. However, it may lead to completion queue overflows - some
> analysis is needed to understand what happens then and how to handle it.
>
> Regarding the feature, I think it should be opt-in (disabled by
> default), because old applications may not wakeup RX after they process
> packets in the RX ring.

How about need_wakeup enable/disable at bind time being that opt-in,
instead of a new option? It is off by default, and when it is off, the
driver busy-spins on the Rx ring until it can put an entry there. It
will not yield to the application by returning something less than
budget. Applications need not check the need_wakeup flag. If
need_wakeup is enabled by the user, the contract is that user-space
needs to check the need_wakeup flag and act on it. If it does not,
then that is a programming error and it can be set for any unspecified
reason. No reason to modify the application, if it checks need_wakeup.
But if this patch behaves like that I have not checked.

Good points in the rest of the mail, that I think should be addressed.

/Magnus

> Is it required to change xdpsock accordingly?
> Also, when need_wakeup is disabled, your driver implementation seems to
> quit NAPI anyway, but it shouldn't happen, because no one will send a
> wakeup.
>
> Waiting until the RX ring fills up, then passing control to the
> application and waiting until the hardware completion queue fills up,
> and so on increases latency - the busy polling approach sounds more
> legit here.
>
> The behavior may be different depending on the driver implementation:
>
> 1. If you arm the completion queue and leave interrupts enabled on early
> exit too, the application will soon be interrupted anyway and won't have
> much time to process many packets, leading to app <-> NAPI ping-pong one
> packet at a time, making NAPI inefficient.
>
> 2. If you don't arm the completion queue on early exit and wait for the
> explicit wakeup from the application, it will easily overflow the
> hardware completion queue, because we don't have a symmetric mechanism
> to stop the application on imminent hardware queue overflow. It doesn't
> feel correct and may be trickier to handle: if the application is too
> slow, such drops should happen on driver/kernel level, not in hardware.
>
> Which behavior is used in your drivers? Or am I missing some more options=
?
>
> BTW, it should be better to pass control to the application before the
> first dropped packet, not after it has been dropped.
>
> Some workloads different from pure AF_XDP, for example, 50/50 AF_XDP and
> XDP_TX may suffer from such behavior, so it's another point to make a
> knob on the application layer to enable/disable it.
>
>  From the driver API perspective, I would prefer to see a simpler API if
> possible. The current API exposes things that the driver shouldn't know
> (BPF map type), and requires XSK-specific handling. It would be better
> if some specific error code returned from xdp_do_redirect was reserved
> to mean "exit NAPI early if you support it". This way we wouldn't need
> two new helpers, two xdp_do_redirect functions, and this approach would
> be extensible to other non-XSK use cases without further changes in the
> driver, and also the logic to opt-in the feature could be put inside the
> kernel.
>
> Thanks,
> Max
>
> >
> > Cheers,
> > Bj=C3=B6rn
>
