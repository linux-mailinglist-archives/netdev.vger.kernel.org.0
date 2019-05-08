Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A063717918
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 14:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfEHMKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 08:10:32 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35277 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfEHMKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 08:10:32 -0400
Received: by mail-oi1-f195.google.com with SMTP id a132so3849174oib.2;
        Wed, 08 May 2019 05:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jVuhIhA/LiFmBM063fK9TJiTeasjszwScQRIlLqb0wM=;
        b=k1JCErm+eJnC0pqCry+ls0o00S7tiBMDpNKFyOnCIDlyKVuO3mTgvSVV3Q3oBTke8b
         kpxYjLsZ+oNg22i2/QOeeEnX43B4iUhSeobH9rtRqB0fy1gpgN0uQEJay9w7PAgyRUC4
         U8fMV9uCcChNfIisYY42XyDcIkE8S3SAhlzWQOdZLEihk8fK9ADCUbZgfiFh5GHPeD9b
         lAQm66TeQQZ8OoDnWoWif+dT9FH7R7GoWF46W9PrslZ+ZEc4mbP9jpurD4O8E1bN7DYH
         d9ANvKeDU1EDRA5VygkEKGkW6KwyEOFTbYAS8tBHS3bL3PcZ9KObxujSJrQHIVNP/i6e
         WhKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jVuhIhA/LiFmBM063fK9TJiTeasjszwScQRIlLqb0wM=;
        b=hc4Bev3zD+45J2Tc1D1ENSzZlVq8Cg4M90DTswitYLNAIj+sN6r7A1ukFvVyN+D+3q
         wr/dotpvvAiIHg2WzuhWn6jYo/xtVqxYnSONEla8s83m/At7K6WY7t7VlTosgoY0HThY
         ZuaXs/KyID0kBwBe/Cx/bbzw+ROSn3SB6hq5QMgvXe/qWiV/72Fp12TXwUZG3GA3SLG4
         depu/aF+YLThOzXAfIMzGXF+CDu9D2mCjh+jSBCP6YQCeTkB29xMb63bc0g9Cl69Gun2
         gO0820WMCYn6bvdFCcTfd0S+jUoPSKzClTZDSQzSRDr7GPqU+2xc+uVUggTpXnUEIb8W
         RLyA==
X-Gm-Message-State: APjAAAXgdZtcYOad5vSfciwNFkXKluamsTuKV72H+XmSoeE79yvw5FCK
        B2C3ZeG85S1lLnAiC9lZYl183GYD8yIWlzZK3Sc=
X-Google-Smtp-Source: APXvYqyIe0j8NY087rSlXmy50sfd47EYXL3W1W0oJw8GZqPKMu/vDzdTEesbPMskm3pgb/MfRYz4oCo41+gjDzz5TLg=
X-Received: by 2002:aca:b3c2:: with SMTP id c185mr2059332oif.98.1557317431026;
 Wed, 08 May 2019 05:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp> <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp>
In-Reply-To: <20190507182435.6f2toprk7jus6jid@ast-mbp>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 8 May 2019 14:10:19 +0200
Message-ID: <CAJ8uoz24HWGfGBNhz4c-kZjYELJQ+G3FcELVEo205xd1CirpqQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <bsd@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 7, 2019 at 8:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 07, 2019 at 01:51:45PM +0200, Magnus Karlsson wrote:
> > On Mon, May 6, 2019 at 6:33 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, May 02, 2019 at 10:39:16AM +0200, Magnus Karlsson wrote:
> > > > This RFC proposes to add busy-poll support to AF_XDP sockets. With
> > > > busy-poll, the driver is executed in process context by calling the
> > > > poll() syscall. The main advantage with this is that all processing
> > > > occurs on a single core. This eliminates the core-to-core cache
> > > > transfers that occur between the application and the softirqd
> > > > processing on another core, that occurs without busy-poll. From a
> > > > systems point of view, it also provides an advatage that we do not
> > > > have to provision extra cores in the system to handle
> > > > ksoftirqd/softirq processing, as all processing is done on the sing=
le
> > > > core that executes the application. The drawback of busy-poll is th=
at
> > > > max throughput seen from a single application will be lower (due to
> > > > the syscall), but on a per core basis it will often be higher as
> > > > the normal mode runs on two cores and busy-poll on a single one.
> > > >
> > > > The semantics of busy-poll from the application point of view are t=
he
> > > > following:
> > > >
> > > > * The application is required to call poll() to drive rx and tx
> > > >   processing. There is no guarantee that softirq and interrupts wil=
l
> > > >   do this for you. This is in contrast with the current
> > > >   implementations of busy-poll that are opportunistic in the sense
> > > >   that packets might be received/transmitted by busy-poll or
> > > >   softirqd. (In this patch set, softirq/ksoftirqd will kick in at h=
igh
> > > >   loads just as the current opportunistic implementations, but I wo=
uld
> > > >   like to get to a point where this is not the case for busy-poll
> > > >   enabled XDP sockets, as this slows down performance considerably =
and
> > > >   starts to use one more core for the softirq processing. The end g=
oal
> > > >   is for only poll() to drive the napi loop when busy-poll is enabl=
ed
> > > >   on an AF_XDP socket. More about this later.)
> > > >
> > > > * It should be enabled on a per socket basis. No global enablement,=
 i.e.
> > > >   the XDP socket busy-poll will not care about the current
> > > >   /proc/sys/net/core/busy_poll and busy_read global enablement
> > > >   mechanisms.
> > > >
> > > > * The batch size (how many packets that are processed every time th=
e
> > > >   napi function in the driver is called, i.e. the weight parameter)
> > > >   should be configurable. Currently, the busy-poll size of AF_INET
> > > >   sockets is set to 8, but for AF_XDP sockets this is too small as =
the
> > > >   amount of processing per packet is much smaller with AF_XDP. This
> > > >   should be configurable on a per socket basis.
> > > >
> > > > * If you put multiple AF_XDP busy-poll enabled sockets into a poll(=
)
> > > >   call the napi contexts of all of them should be executed. This is=
 in
> > > >   contrast to the AF_INET busy-poll that quits after the fist one t=
hat
> > > >   finds any packets. We need all napi contexts to be executed due t=
o
> > > >   the first requirement in this list. The behaviour we want is much=
 more
> > > >   like regular sockets in that all of them are checked in the poll
> > > >   call.
> > > >
> > > > * Should be possible to mix AF_XDP busy-poll sockets with any other
> > > >   sockets including busy-poll AF_INET ones in a single poll() call
> > > >   without any change to semantics or the behaviour of any of those
> > > >   socket types.
> > > >
> > > > * As suggested by Maxim Mikityanskiy, poll() will in the busy-poll
> > > >   mode return POLLERR if the fill ring is empty or the completion
> > > >   queue is full.
> > > >
> > > > Busy-poll support is enabled by calling a new setsockopt called
> > > > XDP_BUSY_POLL_BATCH_SIZE that takes batch size as an argument. A va=
lue
> > > > between 1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it off =
and
> > > > any other value will return an error.
> > > >
> > > > A typical packet processing rxdrop loop with busy-poll will look so=
mething
> > > > like this:
> > > >
> > > > for (i =3D 0; i < num_socks; i++) {
> > > >     fds[i].fd =3D xsk_socket__fd(xsks[i]->xsk);
> > > >     fds[i].events =3D POLLIN;
> > > > }
> > > >
> > > > for (;;) {
> > > >     ret =3D poll(fds, num_socks, 0);
> > > >     if (ret <=3D 0)
> > > >             continue;
> > > >
> > > >     for (i =3D 0; i < num_socks; i++)
> > > >         rx_drop(xsks[i], fds); /* The actual application */
> > > > }
> > > >
> > > > Need some advice around this issue please:
> > > >
> > > > In this patch set, softirq/ksoftirqd will kick in at high loads and
> > > > render the busy poll support useless as the execution is now happen=
ing
> > > > in the same way as without busy-poll support. Everything works from=
 an
> > > > application perspective but this defeats the purpose of the support
> > > > and also consumes an extra core. What I would like to accomplish wh=
en
> > >
> > > Not sure what you mean by 'extra core' .
> > > The above poll+rx_drop is executed for every af_xdp socket
> > > and there are N cpus processing exactly N af_xdp sockets.
> > > Where is 'extra core'?
> > > Are you suggesting a model where single core will be busy-polling
> > > all af_xdp sockets? and then waking processing threads?
> > > or single core will process all sockets?
> > > I think the af_xdp model should be flexible and allow easy out-of-the=
-box
> > > experience, but it should be optimized for 'ideal' user that
> > > does the-right-thing from max packet-per-second point of view.
> > > I thought we've already converged on the model where af_xdp hw rx que=
ues
> > > bind one-to-one to af_xdp sockets and user space pins processing
> > > threads one-to-one to af_xdp sockets on corresponding cpus...
> > > If so that's the model to optimize for on the kernel side
> > > while keeping all other user configurations functional.
> > >
> > > > XDP socket busy-poll is enabled is that softirq/ksoftirq is never
> > > > invoked for the traffic that goes to this socket. This way, we woul=
d
> > > > get better performance on a per core basis and also get the same
> > > > behaviour independent of load.
> > >
> > > I suspect separate rx kthreads of af_xdp socket processing is necessa=
ry
> > > with and without busy-poll exactly because of 'high load' case
> > > you've described.
> > > If we do this additional rx-kthread model why differentiate
> > > between busy-polling and polling?
> > >
> > > af_xdp rx queue is completely different form stack rx queue because
> > > of target dma address setup.
> > > Using stack's napi ksoftirqd threads for processing af_xdp queues cre=
ates
> > > the fairness issues. Isn't it better to have separate kthreads for th=
em
> > > and let scheduler deal with fairness among af_xdp processing and stac=
k?
> >
> > When using ordinary poll() on an AF_XDP socket, the application will
> > run on one core and the driver processing will run on another in
> > softirq/ksoftirqd context. (Either due to explicit core and irq
> > pinning or due to the scheduler or irqbalance moving the two threads
> > apart.) In AF_XDP busy-poll mode of this RFC, I would like the
> > application and the driver processing to occur on a single core, thus
> > there is no "extra" driver core involved that need to be taken into
> > account when sizing and/or provisioning the system. The napi context
> > is in this mode invoked from syscall context when executing the poll
> > syscall from the application.
> >
> > Executing the app and the driver on the same core could of course be
> > accomplished already today by pinning the application and the driver
> > interrupt to the same core, but that would not be that efficient due
> > to context switching between the two.
>
> Have you benchmarked it?
> I don't think context switch will be that noticable when kpti is off.
> napi processes 64 packets descriptors and switches back to user to
> do payload processing of these packets.
> I would think that the same job is on two different cores would be
> a bit more performant with user code consuming close to 100%
> and softirq is single digit %. Say it's 10%.
> I believe combining the two on single core is not 100 + 10 since
> there is no cache bouncing. So Mpps from two cores setup will
> reduce by 2-3% instead of 10%.
> There is a cost of going to sleep and being woken up from poll(),
> but 64 packets is probably large enough number to amortize.
> If not, have you tried to bump napi budget to say 256 for af_xdp rx queue=
s?
> Busy-poll avoids sleep/wakeup overhead and probably can make
> this scheme work with lower batching (like 64), but fundamentally
> they're the same thing.
> I'm not saying that we shouldn't do busy-poll. I'm saying it's
> complimentary, but in all cases single core per af_xdp rq queue
> with user thread pinning is preferred.
>
> > A more efficient way would be to
> > call the napi loop from within the poll() syscall when you are inside
> > the kernel anyway. This is what the classical busy-poll mechanism
> > operating on AF_INET sockets does. Inside the poll() call, it executes
> > the napi context of the driver until it finds a packet (if it is rx)
> > and then returns to the application that then processes the packets. I
> > would like to adopt something quite similar for AF_XDP sockets. (Some
> > of the differences can be found at the top of the original post.)
> >
> > From an API point of view with busy-poll of AF_XDP sockets, the user
> > would bind to a queue number and taskset its application to a specific
> > core and both the app and the driver execution would only occur on
> > that core. This is in my mind simpler than with regular poll or AF_XDP
> > using no syscalls on rx (i.e. current state), in which you bind to a
> > queue, taskset your application to a core and then you also have to
> > take care to route the interrupt of the queue you bound to to another
> > core that will execute the driver part in the kernel. So the model is
> > in both cases still one core - one socket - one napi. (Users can of
> > course create multiple sockets in an app if they desire.)
> >
> > The main reasons I would like to introduce busy-poll for AF_XDP
> > sockets are:
> >
> > * It is simpler to provision, see arguments above. Both application
> >   and driver runs efficiently on the same core.
> >
> > * It is faster (on a per core basis) since we do not have any core to
> >   core communication. All header and descriptor transfers between
> >   kernel and application are core local which is much
> >   faster. Scalability will also be better. E.g., 64 bytes desc + 64
> >   bytes packet header =3D 128 bytes per packet less on the interconnect
> >   between cores. At 20 Mpps/core, this is ~20Gbit/s and with 20 cores
> >   this will be ~400Gbit/s of interconnect traffic less with busy-poll.
>
> exactly. don't make cpu do this core-to-core stuff.
> pin one rx to one core.
>
> > * It provides a way to seamlessly replace user-space drivers in DPDK
> >   with Linux drivers in kernel space. (Do not think I have to argue
> >   why this is a good idea on this list ;-).) The DPDK model is that
> >   application and driver run on the same core since they are both in
> >   user space. If we can provide the same model (both running
> >   efficiently on the same core, NOT drivers in user-space) with
> >   AF_XDP, it is easy for DPDK users to make the switch. Compare this
> >   to the current way where there are both application cores and
> >   driver/ksoftirqd cores. If a systems builder had 12 cores in his
> >   appliance box and they had 12 instances of a DPDK app, one on each
> >   core, how would he/she reason when repartitioning between
> >   application and driver cores? 8 application cores and 4 driver
> >   cores, or 6 of each? Maybe it is also packet dependent? Etc. Much
> >   simpler to migrate if we had an efficient way to run both of them on
> >   the same core.
> >
> > Why no interrupt? That should have been: no interrupts enabled to
> > start with. We would like to avoid interrupts as much as possible
> > since when they trigger, we will revert to the non busy-poll model,
> > i.e. processing on two separate cores, and the advantages from above
> > will disappear. How to accomplish this?
> >
> > * One way would be to create a napi context with the queue we have
> >   bound to but with no interrupt associated with it, or it being
> >   disabled. The socket would in that case only be able to receive and
> >   send packets when calling the poll() syscall. If you do not call
> >   poll(), you do not get any packets, nor are any packets sent. It
> >   would only be possible to support this with a poll() timeout value
> >   of zero. This would have the best performance
> >
> > * Maybe we could support timeout values >0 by re-enabling the interrupt
> >   at some point. When calling poll(), the core would invoke the napi
> >   context repeatedly with the interrupt of that napi disabled until it
> >   found a packet, but max for a period of time up until the busy poll
> >   timeout (like regular busy poll today does). If that times out, we
> >   go up to the regular timeout of the poll() call and enable
> >   interrupts of the queue associated with the napi and put the process
> >   to sleep. Once woken up by an interrupt, the interrupt of the napi
> >   would be disabled again and control returned to the application. We
> >   would with this scheme process the vast majority of packets locally
> >   on a core with interrupts disabled and with good performance and
> >   only when we have low load and are sleeping/waiting in poll would we
> >   process some packets using interrupts on the core that the
> >   interrupt has been bound to.
>
> I think both 'no interrupt' solutions are challenging for users.
> Stack rx queues and af_xdp rx queues should look almost the same from
> napi point of view. Stack -> normal napi in softirq. af_xdp -> new kthrea=
d
> to work with both poll and busy-poll. The only difference between
> poll and busy-poll will be the running context: new kthread vs user task.
> If busy-poll drained the queue then new kthread napi has no work to do.
> No irq approach could be marginally faster, but more error prone.
> With new kthread the user space will still work in all configuration.
> Even when single user task is processing many af_xdp sockets.
>
> I'm proposing new kthread only partially for performance reasons, but
> mainly to avoid sharing stack rx and af_xdp queues within the same softir=
q.
> Currently we share softirqd for stack napis for all NICs in the system,
> but af_xdp depends on isolated processing.
> Ideally we have rss into N queues for stack and rss into M af_xdp sockets=
.
> The same host will be receive traffic on both.
> Even if we rss stack queues to one set of cpus and af_xdp on another cpus
> softirqds are doing work on all cpus.
> A burst of 64 packets on stack queues or some other work in softirqd
> will spike the latency for af_xdp queues if softirq is shared.
> Hence the proposal for new napi_kthreads:
> - user creates af_xdp socket and binds to _CPU_ X then
> - driver allocates single af_xdp rq queue (queue ID doesn't need to be ex=
posed)
> - spawns kthread pinned to cpu X
> - configures irq for that af_xdp queue to fire on cpu X
> - user space with the help of libbpf pins its processing thread to that c=
pu X
> - repeat above for as many af_xdp sockets as there as cpus
>   (its also ok to pick the same cpu X for different af_xdp socket
>   then new kthread is shared)
> - user space configures hw to RSS to these set of af_xdp sockets.
>   since ethtool api is a mess I propose to use af_xdp api to do this rss =
config
>
> imo that would be the simplest and performant way of using af_xdp.
> All configuration apis are under libbpf (or libxdp if we choose to fork i=
t)
> End result is one af_xdp rx queue - one napi - one kthread - one user thr=
ead.
> All pinned to the same cpu with irq on that cpu.
> Both poll and busy-poll approaches will not bounce data between cpus.
> No 'shadow' queues to speak of and should solve the issues that
> folks were bringing up in different threads.
> How crazy does it sound?

Actually, it sounds remarkably sane :-). It will create something
quite similar to what I have been wanting, but you take it at least
two steps further. Did not think about introducing a separate kthread
as a potential solution, and the user space configuration of RSS (and
maybe other flow steering mechanisms) from AF_XDP Bj=C3=B6rn and I have
only been loosely talking about. Anyway, I am producing performance
numbers for the options that we have talked about. I will get back to
you with them as soon as I have them and we can continue the
discussions based on those.

Thanks: Magnus
