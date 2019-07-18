Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A336CE57
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390385AbfGRM4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 08:56:16 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46317 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfGRM4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 08:56:16 -0400
Received: by mail-ot1-f68.google.com with SMTP id z23so553726ote.13;
        Thu, 18 Jul 2019 05:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jYE6MymFjDVX4CF0nJsDS+by+eJsrSXNYSIMXDpnX+8=;
        b=qLZxQ7m1IJQOEFvMp2MJXd7UgMJauWFNo+5wM8qZnSzjMmUEXz9iMVSExXUdC9TYRJ
         YxvMyg2TzFV+KM3EffkwLE3h9Z/tkQ8Y+8ISO/JLe1G2BVT8EWhMZ9BpIemGUwnOMzEz
         X0BZlVmwZv19DuCGrOfp21omTA+0SsMNSoLhQ1XKbujy4SkfnE9Irl4IZ1ha8SGqdHSY
         Eo0UKC+trB+VhVQ7/VcnpnBaEyuVbv7nxm55oH8/GQ2FslvEwVo8a7zR3+mjCSCa6gyL
         jtWawqDTArT66qL58Iulv1qRF1Y/wDgGGeGEyhEFVIk7XXC5QeT73d+qunUMOzGTou4Z
         8ETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jYE6MymFjDVX4CF0nJsDS+by+eJsrSXNYSIMXDpnX+8=;
        b=dOfH54lBOds689hwT3b/MFxNy/pX1Bm6aKWwTc8joZV4F+jSxcx8WoMm+pF2TvzMBh
         M6s9ln+fNjCeZ38nk7cxbWcjwweom9PM0k+R3oN/BZKfiAooDTfJx8mhUi1VXnlZjLB+
         zo4m6WK0O4eVJ63PM0ofin6kdKVdSyfIoHlBJ4Eqyrm5C9v3bO09kmERhGvCiGuD0kjM
         gozoieXi4IZF7W7ypUFSFd3kfGeMAnTZwqJyy3sgxP2zXdx91KZ849prVmKWKJl5hwwT
         zaQceyXoeDZtF44YWksKU4bf7f0UJB7j31O2xKbc0j5XDWmpiRaW75Pu+S2umlnCqsJR
         n9pw==
X-Gm-Message-State: APjAAAWbPR3yiSlplBgjdLNpTtbmk2HwCLmxdcV1D33Rb8Zqo/YroqEu
        tK516nmy+9ktF4vcLrL1mutE3xYEsyj3PGZTvNg=
X-Google-Smtp-Source: APXvYqzz1HsmIgocZWU4D8ld+h/76GbKhaZ/M5gYyfWXunQEewO1ahy85kWEfVyG0Fx2aDBinwlrjZ0SS1RpjkW5IDY=
X-Received: by 2002:a05:6830:104e:: with SMTP id b14mr34603703otp.264.1563454575385;
 Thu, 18 Jul 2019 05:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190717201925.fur57qfs2x3ha6aq@debian> <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
 <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
 <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
 <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com> <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
 <8124bbe5-eaa8-2106-2695-4788ec0f6544@gmail.com>
In-Reply-To: <8124bbe5-eaa8-2106-2695-4788ec0f6544@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 18 Jul 2019 13:55:38 +0100
Message-ID: <CADVatmPQRf9A9z1LbHe5cd+bFLrPGG12YxPh2-yXAj_C9s8ZeA@mail.gmail.com>
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

On Thu, Jul 18, 2019 at 12:42 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/18/19 1:18 PM, Sudip Mukherjee wrote:
> > Hi Eric,
> >
> > On Thu, Jul 18, 2019 at 7:58 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 7/17/19 11:52 PM, Thomas Gleixner wrote:
> >>> Sudip,
> >>>
> >>> On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
> >>>> On Wed, Jul 17, 2019 at 9:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >>>>> You can hack ksoftirq_running() to return always false to avoid this, but
> >>>>> that might cause application starvation and a huge packet buffer backlog
> >>>>> when the amount of incoming packets makes the CPU do nothing else than
> >>>>> softirq processing.
> >>>>
> >>>> I tried that now, it is better but still not as good as v3.8
> >>>> Now I am getting 375.9usec as the maximum time between raising the softirq
> >>>> and it starting to execute and packet drops still there.
> >>>>
> >>>> And just a thought, do you think there should be a CONFIG_ option for
> >>>> this feature of ksoftirqd_running() so that it can be disabled if needed
> >>>> by users like us?
> >>>
> >>> If at all then a sysctl to allow runtime control.
> >>>
> >
> > <snip>
> >
> >>
> >> ksoftirqd might be spuriously scheduled from tx path, when
> >> __qdisc_run() also reacts to need_resched().
> >>
> >> By raising NET_TX while we are processing NET_RX (say we send a TCP ACK packet
> >> in response to incoming packet), we force __do_softirq() to perform
> >> another loop, but before doing an other round, it will also check need_resched()
> >> and eventually call wakeup_softirqd()
> >>
> >> I wonder if following patch makes any difference.
> >>
> >> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> >> index 11c03cf4aa74b44663c74e0e3284140b0c75d9c4..ab736e974396394ae6ba409868aaea56a50ad57b 100644
> >> --- a/net/sched/sch_generic.c
> >> +++ b/net/sched/sch_generic.c
> >> @@ -377,6 +377,8 @@ void __qdisc_run(struct Qdisc *q)
> >>         int packets;
> >>
> >>         while (qdisc_restart(q, &packets)) {
> >> +               if (qdisc_is_empty(q))
> >> +                       break;
> >
> > unfortunately its v4.14.55 and qdisc_is_empty() is not yet introduced.
> > And I can not backport 28cff537ef2e ("net: sched: add empty status
> > flag for NOLOCK qdisc")
> > also as TCQ_F_NOLOCK is there. :(
> >
>
> On old kernels, you can simply use
>
> static inline bool qdisc_is_empty(struct Qdisc *q)
> {
>         return !qdisc_qlen(q);
> }
>

Thanks Eric. But there is no improvement in delay between
softirq_raise and softirq_entry with this change.
But moving to a later kernel (linus master branch? ) like Thomas has
said in the other mail might be difficult atm. I can definitely
move to v4.14.133 if that helps. Thomas ?


-- 
Regards
Sudip
