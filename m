Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90582070F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 14:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfEPMiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 08:38:04 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46959 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfEPMiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 08:38:04 -0400
Received: by mail-ot1-f66.google.com with SMTP id j49so3206868otc.13;
        Thu, 16 May 2019 05:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=riuvu3PEmbb/kSaGHhJHl67EXuzhC/tSZ1ipV0WRxuE=;
        b=n7BeFSPgkXb9X2iqyZQtczufPX6gufDaMmS2pxg16HaThzQ1fwXpmIr0w0poR8BHPY
         +x6VSpQaUKfznZJV/Z9SsxwgViukOhuBmUIkbOD7C7qJFfCbBrfYKyDn5TkTVxbGgM2d
         5HjS7nf+yE5qFejBFu01BfSd7SLfiP1S61EF+tiYe82xzDzSCelphb+xznXYCWJxdIVu
         E9/cx6hN9HsYeOGRFsHqpOYZWBTwjjSe7gJ5wQfGkJeU+PFtKx1aj/euqjcoEIsoUhxN
         4FqZgZgIhkn5jakJG5gwNss7bzpUEamFteaob9xgn+IqJUq3wljDMI4MlHfl3BnKbFG+
         pwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=riuvu3PEmbb/kSaGHhJHl67EXuzhC/tSZ1ipV0WRxuE=;
        b=n+68bIwYAuBhskTqaadRscW6ekadNuvXFRVxOpLukYUCoqDOxkxgBM3ZCFQ/ONdQlh
         eF8OLdmgYBoFt+1J2ptYGch3h9Z+ihbcxq4BzVv2fdJ/ovOS7mJYnopjqHMreryVp8O8
         T+G181Arerzr0pvh8MzX+7BnJWLjZCU1esoeLJaqZ5/mb2wbaD0QDdHZAiorvSxCNj53
         ZVDateL/nRt4VjZGR6zk1ysxvIBtfy3uo6gOO7UG1obnoS/sCUlwiNZMJRdOQcXM6qY7
         CxVg89px5CVt+r2MMmmR/BnbuANkvqd1go4LD/ocLGWyLFoUVKViWnAlU5n5PfCRhi7Y
         +rRw==
X-Gm-Message-State: APjAAAWuqqeRBdBlRCppCe62jQekKdw7NlRtcmKnD4HgrhFf9Ufy6QEZ
        6V/Bs1GgJ6JUV/mtJ+eznd64hBzd3Xj0hdwhSNo=
X-Google-Smtp-Source: APXvYqxfTNpUd4hfnR163SdHANVeygFUDwFXC5oQzHdcgRQCxJ2arepYryo979jQK42TBo4Gmv9ijSuYWHZrI8EsB3Y=
X-Received: by 2002:a9d:4e12:: with SMTP id p18mr10537995otf.374.1558010282903;
 Thu, 16 May 2019 05:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp> <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp> <CAJ8uoz24HWGfGBNhz4c-kZjYELJQ+G3FcELVEo205xd1CirpqQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz24HWGfGBNhz4c-kZjYELJQ+G3FcELVEo205xd1CirpqQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 May 2019 14:37:51 +0200
Message-ID: <CAJ8uoz1i72MOk711wLX18zmgo9JS+ztzSYAx0YS0VKxkbvod-w@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <bsd@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 8, 2019 at 2:10 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Tue, May 7, 2019 at 8:24 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, May 07, 2019 at 01:51:45PM +0200, Magnus Karlsson wrote:
> > > On Mon, May 6, 2019 at 6:33 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Thu, May 02, 2019 at 10:39:16AM +0200, Magnus Karlsson wrote:
> > > > > This RFC proposes to add busy-poll support to AF_XDP sockets. Wit=
h
> > > > > busy-poll, the driver is executed in process context by calling t=
he
> > > > > poll() syscall. The main advantage with this is that all processi=
ng
> > > > > occurs on a single core. This eliminates the core-to-core cache
> > > > > transfers that occur between the application and the softirqd
> > > > > processing on another core, that occurs without busy-poll. From a
> > > > > systems point of view, it also provides an advatage that we do no=
t
> > > > > have to provision extra cores in the system to handle
> > > > > ksoftirqd/softirq processing, as all processing is done on the si=
ngle
> > > > > core that executes the application. The drawback of busy-poll is =
that
> > > > > max throughput seen from a single application will be lower (due =
to
> > > > > the syscall), but on a per core basis it will often be higher as
> > > > > the normal mode runs on two cores and busy-poll on a single one.
> > > > >
> > > > > The semantics of busy-poll from the application point of view are=
 the
> > > > > following:
> > > > >
> > > > > * The application is required to call poll() to drive rx and tx
> > > > >   processing. There is no guarantee that softirq and interrupts w=
ill
> > > > >   do this for you. This is in contrast with the current
> > > > >   implementations of busy-poll that are opportunistic in the sens=
e
> > > > >   that packets might be received/transmitted by busy-poll or
> > > > >   softirqd. (In this patch set, softirq/ksoftirqd will kick in at=
 high
> > > > >   loads just as the current opportunistic implementations, but I =
would
> > > > >   like to get to a point where this is not the case for busy-poll
> > > > >   enabled XDP sockets, as this slows down performance considerabl=
y and
> > > > >   starts to use one more core for the softirq processing. The end=
 goal
> > > > >   is for only poll() to drive the napi loop when busy-poll is ena=
bled
> > > > >   on an AF_XDP socket. More about this later.)
> > > > >
> > > > > * It should be enabled on a per socket basis. No global enablemen=
t, i.e.
> > > > >   the XDP socket busy-poll will not care about the current
> > > > >   /proc/sys/net/core/busy_poll and busy_read global enablement
> > > > >   mechanisms.
> > > > >
> > > > > * The batch size (how many packets that are processed every time =
the
> > > > >   napi function in the driver is called, i.e. the weight paramete=
r)
> > > > >   should be configurable. Currently, the busy-poll size of AF_INE=
T
> > > > >   sockets is set to 8, but for AF_XDP sockets this is too small a=
s the
> > > > >   amount of processing per packet is much smaller with AF_XDP. Th=
is
> > > > >   should be configurable on a per socket basis.
> > > > >
> > > > > * If you put multiple AF_XDP busy-poll enabled sockets into a pol=
l()
> > > > >   call the napi contexts of all of them should be executed. This =
is in
> > > > >   contrast to the AF_INET busy-poll that quits after the fist one=
 that
> > > > >   finds any packets. We need all napi contexts to be executed due=
 to
> > > > >   the first requirement in this list. The behaviour we want is mu=
ch more
> > > > >   like regular sockets in that all of them are checked in the pol=
l
> > > > >   call.
> > > > >
> > > > > * Should be possible to mix AF_XDP busy-poll sockets with any oth=
er
> > > > >   sockets including busy-poll AF_INET ones in a single poll() cal=
l
> > > > >   without any change to semantics or the behaviour of any of thos=
e
> > > > >   socket types.
> > > > >
> > > > > * As suggested by Maxim Mikityanskiy, poll() will in the busy-pol=
l
> > > > >   mode return POLLERR if the fill ring is empty or the completion
> > > > >   queue is full.
> > > > >
> > > > > Busy-poll support is enabled by calling a new setsockopt called
> > > > > XDP_BUSY_POLL_BATCH_SIZE that takes batch size as an argument. A =
value
> > > > > between 1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it of=
f and
> > > > > any other value will return an error.
> > > > >
> > > > > A typical packet processing rxdrop loop with busy-poll will look =
something
> > > > > like this:
> > > > >
> > > > > for (i =3D 0; i < num_socks; i++) {
> > > > >     fds[i].fd =3D xsk_socket__fd(xsks[i]->xsk);
> > > > >     fds[i].events =3D POLLIN;
> > > > > }
> > > > >
> > > > > for (;;) {
> > > > >     ret =3D poll(fds, num_socks, 0);
> > > > >     if (ret <=3D 0)
> > > > >             continue;
> > > > >
> > > > >     for (i =3D 0; i < num_socks; i++)
> > > > >         rx_drop(xsks[i], fds); /* The actual application */
> > > > > }
> > > > >
> > > > > Need some advice around this issue please:
> > > > >
> > > > > In this patch set, softirq/ksoftirqd will kick in at high loads a=
nd
> > > > > render the busy poll support useless as the execution is now happ=
ening
> > > > > in the same way as without busy-poll support. Everything works fr=
om an
> > > > > application perspective but this defeats the purpose of the suppo=
rt
> > > > > and also consumes an extra core. What I would like to accomplish =
when
> > > >
> > > > Not sure what you mean by 'extra core' .
> > > > The above poll+rx_drop is executed for every af_xdp socket
> > > > and there are N cpus processing exactly N af_xdp sockets.
> > > > Where is 'extra core'?
> > > > Are you suggesting a model where single core will be busy-polling
> > > > all af_xdp sockets? and then waking processing threads?
> > > > or single core will process all sockets?
> > > > I think the af_xdp model should be flexible and allow easy out-of-t=
he-box
> > > > experience, but it should be optimized for 'ideal' user that
> > > > does the-right-thing from max packet-per-second point of view.
> > > > I thought we've already converged on the model where af_xdp hw rx q=
ueues
> > > > bind one-to-one to af_xdp sockets and user space pins processing
> > > > threads one-to-one to af_xdp sockets on corresponding cpus...
> > > > If so that's the model to optimize for on the kernel side
> > > > while keeping all other user configurations functional.
> > > >
> > > > > XDP socket busy-poll is enabled is that softirq/ksoftirq is never
> > > > > invoked for the traffic that goes to this socket. This way, we wo=
uld
> > > > > get better performance on a per core basis and also get the same
> > > > > behaviour independent of load.
> > > >
> > > > I suspect separate rx kthreads of af_xdp socket processing is neces=
sary
> > > > with and without busy-poll exactly because of 'high load' case
> > > > you've described.
> > > > If we do this additional rx-kthread model why differentiate
> > > > between busy-polling and polling?
> > > >
> > > > af_xdp rx queue is completely different form stack rx queue because
> > > > of target dma address setup.
> > > > Using stack's napi ksoftirqd threads for processing af_xdp queues c=
reates
> > > > the fairness issues. Isn't it better to have separate kthreads for =
them
> > > > and let scheduler deal with fairness among af_xdp processing and st=
ack?
> > >
> > > When using ordinary poll() on an AF_XDP socket, the application will
> > > run on one core and the driver processing will run on another in
> > > softirq/ksoftirqd context. (Either due to explicit core and irq
> > > pinning or due to the scheduler or irqbalance moving the two threads
> > > apart.) In AF_XDP busy-poll mode of this RFC, I would like the
> > > application and the driver processing to occur on a single core, thus
> > > there is no "extra" driver core involved that need to be taken into
> > > account when sizing and/or provisioning the system. The napi context
> > > is in this mode invoked from syscall context when executing the poll
> > > syscall from the application.
> > >
> > > Executing the app and the driver on the same core could of course be
> > > accomplished already today by pinning the application and the driver
> > > interrupt to the same core, but that would not be that efficient due
> > > to context switching between the two.
> >
> > Have you benchmarked it?
> > I don't think context switch will be that noticable when kpti is off.
> > napi processes 64 packets descriptors and switches back to user to
> > do payload processing of these packets.
> > I would think that the same job is on two different cores would be
> > a bit more performant with user code consuming close to 100%
> > and softirq is single digit %. Say it's 10%.
> > I believe combining the two on single core is not 100 + 10 since
> > there is no cache bouncing. So Mpps from two cores setup will
> > reduce by 2-3% instead of 10%.
> > There is a cost of going to sleep and being woken up from poll(),
> > but 64 packets is probably large enough number to amortize.
> > If not, have you tried to bump napi budget to say 256 for af_xdp rx que=
ues?
> > Busy-poll avoids sleep/wakeup overhead and probably can make
> > this scheme work with lower batching (like 64), but fundamentally
> > they're the same thing.
> > I'm not saying that we shouldn't do busy-poll. I'm saying it's
> > complimentary, but in all cases single core per af_xdp rq queue
> > with user thread pinning is preferred.
> >
> > > A more efficient way would be to
> > > call the napi loop from within the poll() syscall when you are inside
> > > the kernel anyway. This is what the classical busy-poll mechanism
> > > operating on AF_INET sockets does. Inside the poll() call, it execute=
s
> > > the napi context of the driver until it finds a packet (if it is rx)
> > > and then returns to the application that then processes the packets. =
I
> > > would like to adopt something quite similar for AF_XDP sockets. (Some
> > > of the differences can be found at the top of the original post.)
> > >
> > > From an API point of view with busy-poll of AF_XDP sockets, the user
> > > would bind to a queue number and taskset its application to a specifi=
c
> > > core and both the app and the driver execution would only occur on
> > > that core. This is in my mind simpler than with regular poll or AF_XD=
P
> > > using no syscalls on rx (i.e. current state), in which you bind to a
> > > queue, taskset your application to a core and then you also have to
> > > take care to route the interrupt of the queue you bound to to another
> > > core that will execute the driver part in the kernel. So the model is
> > > in both cases still one core - one socket - one napi. (Users can of
> > > course create multiple sockets in an app if they desire.)
> > >
> > > The main reasons I would like to introduce busy-poll for AF_XDP
> > > sockets are:
> > >
> > > * It is simpler to provision, see arguments above. Both application
> > >   and driver runs efficiently on the same core.
> > >
> > > * It is faster (on a per core basis) since we do not have any core to
> > >   core communication. All header and descriptor transfers between
> > >   kernel and application are core local which is much
> > >   faster. Scalability will also be better. E.g., 64 bytes desc + 64
> > >   bytes packet header =3D 128 bytes per packet less on the interconne=
ct
> > >   between cores. At 20 Mpps/core, this is ~20Gbit/s and with 20 cores
> > >   this will be ~400Gbit/s of interconnect traffic less with busy-poll=
.
> >
> > exactly. don't make cpu do this core-to-core stuff.
> > pin one rx to one core.
> >
> > > * It provides a way to seamlessly replace user-space drivers in DPDK
> > >   with Linux drivers in kernel space. (Do not think I have to argue
> > >   why this is a good idea on this list ;-).) The DPDK model is that
> > >   application and driver run on the same core since they are both in
> > >   user space. If we can provide the same model (both running
> > >   efficiently on the same core, NOT drivers in user-space) with
> > >   AF_XDP, it is easy for DPDK users to make the switch. Compare this
> > >   to the current way where there are both application cores and
> > >   driver/ksoftirqd cores. If a systems builder had 12 cores in his
> > >   appliance box and they had 12 instances of a DPDK app, one on each
> > >   core, how would he/she reason when repartitioning between
> > >   application and driver cores? 8 application cores and 4 driver
> > >   cores, or 6 of each? Maybe it is also packet dependent? Etc. Much
> > >   simpler to migrate if we had an efficient way to run both of them o=
n
> > >   the same core.
> > >
> > > Why no interrupt? That should have been: no interrupts enabled to
> > > start with. We would like to avoid interrupts as much as possible
> > > since when they trigger, we will revert to the non busy-poll model,
> > > i.e. processing on two separate cores, and the advantages from above
> > > will disappear. How to accomplish this?
> > >
> > > * One way would be to create a napi context with the queue we have
> > >   bound to but with no interrupt associated with it, or it being
> > >   disabled. The socket would in that case only be able to receive and
> > >   send packets when calling the poll() syscall. If you do not call
> > >   poll(), you do not get any packets, nor are any packets sent. It
> > >   would only be possible to support this with a poll() timeout value
> > >   of zero. This would have the best performance
> > >
> > > * Maybe we could support timeout values >0 by re-enabling the interru=
pt
> > >   at some point. When calling poll(), the core would invoke the napi
> > >   context repeatedly with the interrupt of that napi disabled until i=
t
> > >   found a packet, but max for a period of time up until the busy poll
> > >   timeout (like regular busy poll today does). If that times out, we
> > >   go up to the regular timeout of the poll() call and enable
> > >   interrupts of the queue associated with the napi and put the proces=
s
> > >   to sleep. Once woken up by an interrupt, the interrupt of the napi
> > >   would be disabled again and control returned to the application. We
> > >   would with this scheme process the vast majority of packets locally
> > >   on a core with interrupts disabled and with good performance and
> > >   only when we have low load and are sleeping/waiting in poll would w=
e
> > >   process some packets using interrupts on the core that the
> > >   interrupt has been bound to.
> >
> > I think both 'no interrupt' solutions are challenging for users.
> > Stack rx queues and af_xdp rx queues should look almost the same from
> > napi point of view. Stack -> normal napi in softirq. af_xdp -> new kthr=
ead
> > to work with both poll and busy-poll. The only difference between
> > poll and busy-poll will be the running context: new kthread vs user tas=
k.
> > If busy-poll drained the queue then new kthread napi has no work to do.
> > No irq approach could be marginally faster, but more error prone.
> > With new kthread the user space will still work in all configuration.
> > Even when single user task is processing many af_xdp sockets.
> >
> > I'm proposing new kthread only partially for performance reasons, but
> > mainly to avoid sharing stack rx and af_xdp queues within the same soft=
irq.
> > Currently we share softirqd for stack napis for all NICs in the system,
> > but af_xdp depends on isolated processing.
> > Ideally we have rss into N queues for stack and rss into M af_xdp socke=
ts.
> > The same host will be receive traffic on both.
> > Even if we rss stack queues to one set of cpus and af_xdp on another cp=
us
> > softirqds are doing work on all cpus.
> > A burst of 64 packets on stack queues or some other work in softirqd
> > will spike the latency for af_xdp queues if softirq is shared.
> > Hence the proposal for new napi_kthreads:
> > - user creates af_xdp socket and binds to _CPU_ X then
> > - driver allocates single af_xdp rq queue (queue ID doesn't need to be =
exposed)
> > - spawns kthread pinned to cpu X
> > - configures irq for that af_xdp queue to fire on cpu X
> > - user space with the help of libbpf pins its processing thread to that=
 cpu X
> > - repeat above for as many af_xdp sockets as there as cpus
> >   (its also ok to pick the same cpu X for different af_xdp socket
> >   then new kthread is shared)
> > - user space configures hw to RSS to these set of af_xdp sockets.
> >   since ethtool api is a mess I propose to use af_xdp api to do this rs=
s config
> >
> > imo that would be the simplest and performant way of using af_xdp.
> > All configuration apis are under libbpf (or libxdp if we choose to fork=
 it)
> > End result is one af_xdp rx queue - one napi - one kthread - one user t=
hread.
> > All pinned to the same cpu with irq on that cpu.
> > Both poll and busy-poll approaches will not bounce data between cpus.
> > No 'shadow' queues to speak of and should solve the issues that
> > folks were bringing up in different threads.
> > How crazy does it sound?
>
> Actually, it sounds remarkably sane :-). It will create something
> quite similar to what I have been wanting, but you take it at least
> two steps further. Did not think about introducing a separate kthread
> as a potential solution, and the user space configuration of RSS (and
> maybe other flow steering mechanisms) from AF_XDP Bj=C3=B6rn and I have
> only been loosely talking about. Anyway, I am producing performance
> numbers for the options that we have talked about. I will get back to
> you with them as soon as I have them and we can continue the
> discussions based on those.
>
> Thanks: Magnus

After a number of surprises and issues in the driver here are now the
first set of results. 64 byte packets at 40Gbit/s line rate. All
results in Mpps. Note that I just used my local system and kernel build
for these numbers so they are not performance tuned. Jesper would
likely get better results on his setup :-). Explanation follows after
the table.

                                      Applications
method  cores  irqs        txpush        rxdrop      l2fwd
---------------------------------------------------------------
r-t-c     2     y           35.9          11.2        8.6
poll      2     y           34.2           9.4        8.3
r-t-c     1     y           18.1           N/A        6.2
poll      1     y           14.6           8.4        5.9
busypoll  2     y           31.9          10.5        7.9
busypoll  1     y           21.5           8.7        6.2
busypoll  1     n           22.0          10.3        7.3

r-t-c =3D Run-to-completion, the mode where we in Rx uses no syscalls
        and only spin on the pointers in the ring.
poll =3D Use the regular syscall poll()
busypoll =3D Use the regular syscall poll() in busy-poll mode. The RFC I
           sent out.

cores =3D=3D 2 means that softirq/ksoftirqd is one a different core from
           the application. 2 cores are consumed in total.
cores =3D=3D 1 means that both softirq/ksoftirqd and the application runs
           on the same core. Only 1 core is used in total.

irqs =3D=3D 'y' is the normal case. irqs =3D=3D 'n' means that I have creat=
ed a
        new napi context with the AF_XDP queues inside that does not
        have any interrupts associated with it. No other traffic goes
        to this napi context.

N/A =3D This combination does not make sense since the application will
      not yield due to run-to-completion without any syscalls
      whatsoever. It works, but it crawls in the 30 Kpps
      range. Creating huge rings would help, but did not do that.

The applications are the ones from the xdpsock sample application in
samples/bpf/.

Some things I had to do to get these results:

* The current buffer allocation scheme in i40e where we continuously
  try to access the fill queue until we find some entries, is not
  effective if we are on a single core. Instead, we try once and call
  a function that sets a flag. This flag is then checked in the xsk
  poll code, and if it is set we schedule napi so that it can try to
  allocate some buffers from the fill ring again. Note that this flag
  has to propagate all the way to user space so that the application
  knows that it has to call poll(). I currently set a flag in the Rx
  ring to indicate that the application should call poll() to resume
  the driver. This is similar to what the io_uring in the storage
  subsystem does. It is not enough to return POLLERR from poll() as
  that will only work for the case when we are using poll(). But I do
  that as well.

* Implemented Sridhar's suggestion on adding busy_loop_end callbacks
  that terminate the busy poll loop if the Rx queue is empty or the Tx
  queue is full.

* There is a race in the setup code in i40e when it is used with
  busy-poll. The fact that busy-poll calls the napi_busy_loop code
  before interrupts have been registered and enabled seems to trigger
  some bug where nothing gets transmitted. This only happens for
  busy-poll. Poll and run-to-completion only enters the napi loop of
  i40e by interrupts and only then after interrupts have been enabled,
  which is the last thing that is done after setup. I have just worked
  around it by introducing a sleep(1) in the application for these
  experiments. Ugly, but should not impact the numbers, I believe.

* The 1 core case is sensitive to the amount of work done reported
  from the driver. This was not correct in the XDP code of i40e and
  let to bad performance. Now it reports the correct values for
  Rx. Note that i40e does not honor the napi budget on Tx and sets
  that to 256, and these are not reported back to the napi
  library.

Some observations:

* Cannot really explain the drop in performance for txpush when going
  from 2 cores to 1. As stated before, the reporting of Tx work is not
  really propagated to the napi infrastructure. Tried reporting this
  in a correct manner (completely ignoring Rx for this experiment) but
  the results were the same. Will dig deeper into this to screen out
  any stupid mistakes.

* With the fixes above, all my driver processing is in softirq for 1
  core. It never goes over to ksoftirqd. Previously when work was
  reported incorrectly, this was the case. I would have liked
  ksoftirqd to take over as that would have been more like a separate
  thread. How to accomplish this? There might still be some reporting
  problem in the driver that hinders this, but actually think it is
  more correct now.

* Looking at the current results for a single core, busy poll provides
  a 40% boost for Tx but only 5% for Rx. But if I instead create a
  napi context without any interrupt associated with it and drive that
  from busy-poll, I get a 15% - 20% performance improvement for Rx. Tx
  increases only marginally from the 40% improvement as there are few
  interrupts on Tx due to the completion interrupt bit being set quite
  infrequently. One question I have is: what am I breaking by creating
  a napi context not used by anyone else, only AF_XDP, that does not
  have an interrupt associated with it?

Todo:

* Explain the drop in Tx push when going from 2 cores to 1.

* Really run a separate thread for kernel processing instead of softirq.

* What other experiments would you like to see?

/Magnus
