Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D96CD3E
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 13:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390066AbfGRLSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 07:18:45 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35654 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfGRLSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 07:18:45 -0400
Received: by mail-ot1-f66.google.com with SMTP id j19so28606793otq.2;
        Thu, 18 Jul 2019 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aj2rqABk0xuHkR9UGCVKlVt81H3iXGb+Hp1fclBgK0k=;
        b=LwRuicFm6ghp8965yMx2N/Mf3pRxn2pcfB3y8A89qv2GrqgGFDc3FzbUFxhsr6IMX0
         h3Yvbay4jN1p7vNT44yr19HuGyAG5ALGS/Nnnsq2Pk2y46XkQadATq08L5fyQ9e4p8jg
         6cNhivL9NpsV/BU6SHykSy+eYJVR3bc2b9cBaclf9AdfiUzm+m9bPm4yRyDr1LglKnjQ
         3Ua1mlQ9ULtAKnwgNEvDQnh4bBpM1DsTQpR9OfrErolad5fHlaD0li+GPow8BTSoJTAU
         pE/kbJPZE57qZvK3hM+ulLCuSk+NYluQuxzsgfjaCQtFRFTYu/3c5XntoG583fI1w7Xb
         ubZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aj2rqABk0xuHkR9UGCVKlVt81H3iXGb+Hp1fclBgK0k=;
        b=iqmOZigrIzAZ6Xf7r9EPFYYHF1rdoonsz9ugh0pk4YfjUIGsHmPZI+u7y0KMG+Dv+5
         lmnVwRuCAU/aRYwZqgiDPTKZaCJCNnClzEwPXKA2rl0rpfxrPSoJVEDWZ8va3UR24IfM
         3OnSD3K2TeB9NnF+gmI/jIjgdxq26jg7597XbDD0JzF4S27MZ5o+7RiPPCsJ7L0rgL1t
         qZq5OIkaKFVN+ghPB+oMdo4tTQUglCgyhsqffed3f1uRil2HYW0F2ZQPMpyThBSPU0Nn
         +8U4fJWFCCkMlBfcUKU3v3kqmnVoEC0lLQ1oGsNsEQfu8tY5RgfO4u/mrVflVgEi/IUw
         YSnQ==
X-Gm-Message-State: APjAAAVY4cCqemOTgcNhwOk/WvpLSiP/aEPYZow9PZRGm5iVXyOV2DTr
        7SsR5sOQwERqsyTMCHycwQM4DfQqJ7xDray/xDY=
X-Google-Smtp-Source: APXvYqwW+8Qp0sCOChKDlD2SYquMDCfHQEumwfAoGI0H3Qi7XJFTlYr0GE2VfUmfFnWm9gyjhcWDuPddC6FEvq5vh94=
X-Received: by 2002:a05:6830:1697:: with SMTP id k23mr3310130otr.16.1563448724309;
 Thu, 18 Jul 2019 04:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190717201925.fur57qfs2x3ha6aq@debian> <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
 <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
 <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de> <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com>
In-Reply-To: <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 18 Jul 2019 12:18:07 +0100
Message-ID: <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
Subject: Re: regression with napi/softirq ?
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, Jul 18, 2019 at 7:58 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/17/19 11:52 PM, Thomas Gleixner wrote:
> > Sudip,
> >
> > On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
> >> On Wed, Jul 17, 2019 at 9:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >>> You can hack ksoftirq_running() to return always false to avoid this, but
> >>> that might cause application starvation and a huge packet buffer backlog
> >>> when the amount of incoming packets makes the CPU do nothing else than
> >>> softirq processing.
> >>
> >> I tried that now, it is better but still not as good as v3.8
> >> Now I am getting 375.9usec as the maximum time between raising the softirq
> >> and it starting to execute and packet drops still there.
> >>
> >> And just a thought, do you think there should be a CONFIG_ option for
> >> this feature of ksoftirqd_running() so that it can be disabled if needed
> >> by users like us?
> >
> > If at all then a sysctl to allow runtime control.
> >

<snip>

>
> ksoftirqd might be spuriously scheduled from tx path, when
> __qdisc_run() also reacts to need_resched().
>
> By raising NET_TX while we are processing NET_RX (say we send a TCP ACK packet
> in response to incoming packet), we force __do_softirq() to perform
> another loop, but before doing an other round, it will also check need_resched()
> and eventually call wakeup_softirqd()
>
> I wonder if following patch makes any difference.
>
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 11c03cf4aa74b44663c74e0e3284140b0c75d9c4..ab736e974396394ae6ba409868aaea56a50ad57b 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -377,6 +377,8 @@ void __qdisc_run(struct Qdisc *q)
>         int packets;
>
>         while (qdisc_restart(q, &packets)) {
> +               if (qdisc_is_empty(q))
> +                       break;

unfortunately its v4.14.55 and qdisc_is_empty() is not yet introduced.
And I can not backport 28cff537ef2e ("net: sched: add empty status
flag for NOLOCK qdisc")
also as TCQ_F_NOLOCK is there. :(


-- 
Regards
Sudip
