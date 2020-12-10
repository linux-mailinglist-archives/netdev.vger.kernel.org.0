Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2AF2D6617
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393384AbgLJTN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393380AbgLJTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:13:06 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55196C06179C;
        Thu, 10 Dec 2020 11:12:26 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id x16so8902639ejj.7;
        Thu, 10 Dec 2020 11:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMPtkPHlfScXxnYtiT73cT3123zHLd5ONBXCS1dAZ+M=;
        b=VZvQ6MsGSCr52HnisluE283ZiiX5FQ2VQwX1Sq80Xfx9pK2XkorU4Buz1hjD/9mLXV
         rIt/H0xMm28hNn1cdVEgmFaQceeFGLXMcvr866GMkMqe7c4TmoThjfJ1gJvmyjhI/IpH
         3PGh7XvIoqlC+J70qn0s2dRq9wVa6ZUx0V73iF8emJ0z+O1o5wTJ87tO4OlOwclWFpuU
         JXcKAY3J94y9Y/JOXHlNU46P3n1YMpnLwKnYNHS3RLdhghV7Y4GkYUlu+vBd3P2vqGmQ
         jb9vOtMekAiKplU+95IZceUUp1KCd5gDTdGcuQ9z7/t1QfkhPMIB6N2EtXyvHxaM8g5+
         tXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMPtkPHlfScXxnYtiT73cT3123zHLd5ONBXCS1dAZ+M=;
        b=IXdx6EuwnUAw4RWKQkEraRQt7SoY6QP7qDyCSZ7vIc37esWWjSdqmVqyioFtplsLJS
         25X+a/SXTakNWpa71y9akYNoKkSnAzKbaauVe0AEHOCl7Vu+cabCbufDjzTmEOd9n0Ya
         YF04bGedhgYLmhbtsD7y9LqLeUDpY9NUel6Kym9CAr9caiPAn/WFbtkm29/cxU3LKv+t
         7bsPAbHRlSHaRZ41y0/zOvlQhryplBIcDyfol4gU/G+UGmKohrZTkV5KpgG/0zf9/yUx
         xHAoSU2z1Uw6zbOBxL+D0OKGNsf3w0J3xPJRE66/+IDLm6prc/+UBrXEHuc1dDIR4H+C
         XXBQ==
X-Gm-Message-State: AOAM533UTPdpM/NrzfkHZzlvwdCUgTXAONiB4mwCZYcuOT/J1o/MEnPo
        PX0KTRplQVE+7wGpzNVypwNQ3gN8qDAETFftvJU=
X-Google-Smtp-Source: ABdhPJzKj2M4qLSgR7C5iggAlGzaZdKq+cTuuQy/hK6vAtsOTDChiPq6Z2rGEATrtFA4PF+BrGkmGuHrdXxbitZdRpo=
X-Received: by 2002:a17:906:3683:: with SMTP id a3mr7528466ejc.538.1607627544909;
 Thu, 10 Dec 2020 11:12:24 -0800 (PST)
MIME-Version: 1.0
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com> <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com> <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Dec 2020 14:11:49 -0500
Message-ID: <CAF=yD-LkknU3GwJgG_OiMPFONZtO3ECHEX0QfTaUTTX_N0i-KA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
To:     "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     Network Development <netdev@vger.kernel.org>,
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
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Molzahn, Ines" <ines.molzahn@siemens.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Bucher, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger, Michael" <michael.saenger@siemens.com>,
        "Maehringer, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert@siemens.com" <gisela.greinert@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 3:18 PM Geva, Erez <erez.geva.ext@siemens.com> wrote:
>
>
> On 09/12/2020 18:37, Willem de Bruijn wrote:
> > On Wed, Dec 9, 2020 at 10:25 AM Geva, Erez <erez.geva.ext@siemens.com> wrote:
> >>
> >>
> >> On 09/12/2020 15:48, Willem de Bruijn wrote:
> >>> On Wed, Dec 9, 2020 at 9:37 AM Erez Geva <erez.geva.ext@siemens.com> wrote:
> >>>>
> >>>> Configure and send TX sending hardware timestamp from
> >>>>    user space application to the socket layer,
> >>>>    to provide to the TC ETC Qdisc, and pass it to
> >>>>    the interface network driver.
> >>>>
> >>>>    - New flag for the SO_TXTIME socket option.
> >>>>    - New access auxiliary data header to pass the
> >>>>      TX sending hardware timestamp.
> >>>>    - Add the hardware timestamp to the socket cookie.
> >>>>    - Copy the TX sending hardware timestamp to the socket cookie.
> >>>>
> >>>> Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
> >>>
> >>> Hardware offload of pacing is definitely useful.
> >>>
> >> Thanks for your comment.
> >> I agree, it is not limited of use.
> >>
> >>> I don't think this needs a new separate h/w variant of SO_TXTIME.
> >>>
> >> I only extend SO_TXTIME.
> >
> > The patchset passes a separate timestamp from skb->tstamp along
> > through the ip cookie, cork (transmit_hw_time) and with the skb in
> > shinfo.
> >
> > I don't see the need for two timestamps, one tied to software and one
> > to hardware. When would we want to pace twice?
>
> As the Net-Link uses system clock and the network interface hardware uses it's own PHC.
> The current ETF depends on synchronizing the system clock and the PHC.

If I understand correctly, you are trying to achieve a single delivery time.
The need for two separate timestamps passed along is only because the
kernel is unable to do the time base conversion.

Else, ETF could program the qdisc watchdog in system time and later,
on dequeue, convert skb->tstamp to the h/w time base before
passing it to the device.

It's still not entirely clear to me why the packet has to be held by
ETF initially first, if it is held until delivery time by hardware
later. But more on that below.

So far, the use case sounds a bit narrow and the use of two timestamp
fields for a single delivery event a bit of a hack.

And one that does impose a cost in the hot path of many workloads
by adding a field the ip cookie, cork and writing to (possibly cold)
skb_shinfo for every packet.

> >>> Indeed, we want pacing offload to work for existing applications.
> >>>
> >> As the conversion of the PHC and the system clock is dynamic over time.
> >> How do you propse to achive it?
> >
> > Can you elaborate on this concern?
>
> Using single time stamp have 3 possible solutions:
>
> 1. Current solution, synchronize the system clock and the PHC.
>     Application uses the system clock.
>     The ETF can use the system clock for ordering and pass the packet to the driver on time
>     The network interface hardware compare the time-stamp to the PHC.
>
> 2. The application convert the PHC time-stamp to system clock based.
>      The ETF works as solution 1
>      The network driver convert the system clock time-stamp back to PHC time-stamp.
>      This solution need a new Net-Link flag and modify the relevant network drivers.
>      Yet this solution have 2 problems:
>      * As applications today are not aware that system clock and PHC are not synchronized and
>         therefore do not perform any conversion, most of them only use the system clock.
>      * As the conversion in the network driver happens ~300 - 600 microseconds after
>         the application send the packet.
>         And as the PHC and system clock frequencies and offset can change during this period.
>         The conversion will produce a different PHC time-stamp from the application original time-stamp.
>         We require a precession of 1 nanoseconds of the PHC time-stamp.
>
> 3. The application uses PHC time-stamp for skb->tstamp
>     The ETF convert the  PHC time-stamp to system clock time-stamp.
>     This solution require implementations on supporting reading PHC clocks
>     from IRQ/kernel thread context in kernel space.

ETF has to release the packet well in advance of the hardware
timestamp for the packet to arrive at the device on time. In practice
I would expect this delta parameter to be at least at usec timescale.
That gives some wiggle room with regard to s/w tstamp, at least.

If changes in clock distance are relatively infrequent, could this
clock diff be a qdisc parameter, updated infrequently outside the
packet path?

It would even be preferable if the qdisc and core stack could be
ignorant of such hardware clocks and the time base is converted by the
device driver when encoding skb->tstamp into the tx descriptor. Is the
device hardware clock readable by the driver?

From the above, it sounds like this is not trivial.

I don't know which exact device you're targeting. Is it an in-tree driver?

> Just for clarification:
> ETF as all Net-Link, only uses system clock (the TAI)
> The network interface hardware only uses the PHC.
> Nor Net-Link neither the driver perform any conversions.
> The Kernel does not provide and clock conversion beside system clock.
> Linux kernel is a single clock system.
>
> >
> > The simplest solution for offloading pacing would be to interpret
> > skb->tstamp either for software pacing, or skip software pacing if the
> > device advertises a NETIF_F hardware pacing feature.
>
> That will defy the purpose of ETF.
> ETF exist for ordering packets.
> Why should the device driver defer it?
> Simply do not use the QDISC for this interface.

ETF queues packets until their delivery time is reached. It does not
order for any other reason than to calculate the next qdisc watchdog
event, really.

If h/w can do the same and the driver can convert skb->tstamp to the
right timebase, indeed no qdisc is needed for pacing. But there may be
a need for selective h/w offload if h/w has additional constraints,
such as on the number of packets outstanding or time horizon.

> >
> > Clockbase is an issue. The device driver may have to convert to
> > whatever format the device expects when copying skb->tstamp in the
> > device tx descriptor.
>
> We do hope our definition is clear.
> In the current kernel skb->tstamp uses system clock.
> The hardware time-stamp is PHC based, as it is used today for PTP two steps.
> We only propose to use the same hardware time-stamp.
>
> Passing the hardware time-stamp to the skb->tstamp might seems a bit tricky
> The gaol is the leave the driver unaware to whether we
> * Synchronizing the PHC and system clock
> * The ETF pass the hardware time-stamp to skb->tstamp
> Only the applications and the ETF are aware.
> The application can detect by checking the ETF flag.
> The ETF flags are part of the network administration.
> That also configure the PTP and the system clock synchronization.
>
> >
> >>
> >>> It only requires that pacing qdiscs, both sch_etf and sch_fq,
> >>> optionally skip queuing in their .enqueue callback and instead allow
> >>> the skb to pass to the device driver as is, with skb->tstamp set. Only
> >>> to devices that advertise support for h/w pacing offload.
> >>>
> >> I did not use "Fair Queue traffic policing".
> >> As for ETF, it is all about ordering packets from different applications.
> >> How can we achive it with skiping queuing?
> >> Could you elaborate on this point?
> >
> > The qdisc can only defer pacing to hardware if hardware can ensure the
> > same invariants on ordering, of course.
>
> Yes, this is why we suggest ETF order packets using the hardware time-stamp.
> And pass the packet based on system time.
> So ETF query the system clock only and not the PHC.

On which note: with this patch set all applications have to agree to
use h/w time base in etf_enqueue_timesortedlist. In practice that
makes this h/w mode a qdisc used by a single process?

> >
> > Btw: this is quite a long list of CC:s
> >
> I need to update my company colleagues as well as the Linux group.

Of course. But even ignoring that this is still quite a large list (> 40).

My response yesterday was actually blocked as a result ;) Retrying now.
