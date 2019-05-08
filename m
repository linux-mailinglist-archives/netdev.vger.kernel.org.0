Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5369F179E5
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfEHNGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:06:23 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37796 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfEHNGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 09:06:23 -0400
Received: by mail-oi1-f193.google.com with SMTP id 143so15069447oii.4;
        Wed, 08 May 2019 06:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HGqRoeqrGg6sw+QAMXIyAjWS9seLb2INdG6gceYJkhQ=;
        b=BCf9FfXbEVYTyBtRxnyZGZE1e8OuJtrpszcN1dRnOMpx7oAPJ0ChQ1mHEQfygBkvv8
         SOfrX2MqN7acOxvPvQ2AgUnZ83c1iPexymuEIgQImeptAyCL4+UleZ431iAcq4EdO8rR
         t43JRofEh10xfLp0NM5bOFxDcetIJNoi48x/u/xos76RbAV8Per6fxl37++E2Eka3a5F
         M3AT/aM89HCCOfVW/PYcZbNEEeXmy/+0rZYksfoM/lV18GMbjPVm8KknCrx+uWKfOEJu
         NBeArzvEcfbdW/3uGZZKFiZLvPZExY3wFmpHlKh7gPkb9P8O+eg9ZN32I4Vgrz4Koq+U
         Zo4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HGqRoeqrGg6sw+QAMXIyAjWS9seLb2INdG6gceYJkhQ=;
        b=fntIRcNqnvSAhA5hMnKQbz7E4FU6RP5zC5yiop8EcxEnQITbBq8mk9RzvFchOiXFJe
         Ez3NJ/tA+YjOArRLPn0egmrwpDjs0+AjUpyDi1zhEpsZgf1T+/QaFCCG2YucObuIrwvc
         Xd01kA+EwBLHrWBlJHa1LlXeMTU61Q9tqXGThXdRUgxhRS9u388wFT3mzjA5A5I8cWnC
         m2gGnZeE1jBkgoG+OZYSqtwl1qeD7kIId1iGjZj5l1E2sb138EgNLJkaqDHe6zGWSKzj
         k60EfjmqCYQaeDOxEDqpmRPdLIfIEA8pK5e4fF7aaMsxKhq0lSI8nJNMYnVq9Xmxt0w3
         hcXg==
X-Gm-Message-State: APjAAAUXu9XUU8WgJfoyAZakPFJULyzhUPKXwboo9brzP79CAR+xhLYL
        Og9BCU44W8ZHQwmDlkdR+7muM4/oENxdNiqcoN4=
X-Google-Smtp-Source: APXvYqxth31S0QS2oNbZBH5vp3xccX9pQPkC6kVaG7huhujrPDpWdBIY6NcefjnP4Sr6J5delkulboej3AqHtUcvGSY=
X-Received: by 2002:aca:ed10:: with SMTP id l16mr2171096oih.109.1557320781713;
 Wed, 08 May 2019 06:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190430181215.15305-1-maximmi@mellanox.com> <20190430181215.15305-5-maximmi@mellanox.com>
 <CAJ+HfNho0H7qq+hFn7Ri=9Y+KGEcM19SOChfPZxwkyqJNymKcQ@mail.gmail.com>
 <a9d22f97-b6b6-33ca-5120-fbe1231a9484@mellanox.com> <CAJ8uoz0=YLF1s2nm6kGS=gD0xBhiqN8H8cqOX6ZcqdW2af8qDg@mail.gmail.com>
 <ae660e46-27f2-98a6-42d6-e9df88bf2cb7@mellanox.com>
In-Reply-To: <ae660e46-27f2-98a6-42d6-e9df88bf2cb7@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 8 May 2019 15:06:10 +0200
Message-ID: <CAJ8uoz2UHk+5xPwz-STM9gkQZdm7r_=jsgaB0nF+mHgch=axPg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/16] xsk: Extend channels to support
 combined XSK/non-XSK traffic
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 7, 2019 at 4:19 PM Maxim Mikityanskiy <maximmi@mellanox.com> wr=
ote:
>
> On 2019-05-06 17:23, Magnus Karlsson wrote:
> > On Mon, May 6, 2019 at 3:46 PM Maxim Mikityanskiy <maximmi@mellanox.com=
> wrote:
> >>
> >> On 2019-05-04 20:26, Bj=C3=B6rn T=C3=B6pel wrote:
> >>> On Tue, 30 Apr 2019 at 20:12, Maxim Mikityanskiy <maximmi@mellanox.co=
m> wrote:
> >>>>
> >>>> Currently, the drivers that implement AF_XDP zero-copy support (e.g.=
,
> >>>> i40e) switch the channel into a different mode when an XSK is opened=
. It
> >>>> causes some issues that have to be taken into account. For example, =
RSS
> >>>> needs to be reconfigured to skip the XSK-enabled channels, or the XD=
P
> >>>> program should filter out traffic not intended for that socket and
> >>>> XDP_PASS it with an additional copy. As nothing validates or forces =
the
> >>>> proper configuration, it's easy to have packets drops, when they get
> >>>> into an XSK by mistake, and, in fact, it's the default configuration=
.
> >>>> There has to be some tool to have RSS reconfigured on each socket op=
en
> >>>> and close event, but such a tool is problematic to implement, becaus=
e no
> >>>> one reports these events, and it's race-prone.
> >>>>
> >>>> This commit extends XSK to support both kinds of traffic (XSK and
> >>>> non-XSK) in the same channel. It implies having two RX queues in
> >>>> XSK-enabled channels: one for the regular traffic, and the other for
> >>>> XSK. It solves the problem with RSS: the default configuration just
> >>>> works without the need to manually reconfigure RSS or to perform som=
e
> >>>> possibly complicated filtering in the XDP layer. It makes it easy to=
 run
> >>>> both AF_XDP and regular sockets on the same machine. In the XDP prog=
ram,
> >>>> the QID's most significant bit will serve as a flag to indicate whet=
her
> >>>> it's the XSK queue or not. The extension is compatible with the lega=
cy
> >>>> configuration, so if one wants to run the legacy mode, they can
> >>>> reconfigure RSS and ignore the flag in the XDP program (implemented =
in
> >>>> the reference XDP program in libbpf). mlx5e will support this extens=
ion.
> >>>>
> >>>> A single XDP program can run both with drivers supporting or not
> >>>> supporting this extension. The xdpsock sample and libbpf are updated
> >>>> accordingly.
> >>>>
> >>>
> >>> I'm still not a fan of this, or maybe I'm not following you. It makes
> >>> it more complex and even harder to use. Let's take a look at the
> >>> kernel nomenclature. "ethtool" uses netdevs and channels. A channel i=
s
> >>> a Rx queue or a Tx queue.
> >>
> >> There are also combined channels that consist of an RX and a TX queue.
> >> mlx5e has only this kind of channels. For us, a channel is a set of
> >> queues "pinned to a CPU core" (they use the same NAPI).
> >>
> >>> In AF_XDP we call the channel a queue, which
> >>> is what kernel uses internally (netdev_rx_queue, netdev_queue).
> >>
> >> You seem to agree it's a channel, right?
> >>
> >> AF_XDP doesn't allow to configure RX queue number and TX queue number
> >> separately. Basically you choose a channel in AF_XDP. For some reason,
> >> it's referred as a queue in some places, but logically it means "chann=
el".
> >
> > You can configure the Rx queue and the Tx queue separately by creating
> > two sockets tied to the same umem area. But if you just create one,
> > you are correct.
>
> Yes, I know I can open two sockets, but it's only a workaround. If I
> want to RX on RQ 3 and TX on SQ 5, I'll have one socket bound to RQ 3
> and SQ 3, and the other bound to RQ 5 and SQ 5. It's not a clean way to
> achieve the initial goal. It means that the current implementation
> actually binds a socket to a channel X (that has RQ X and SQ X). It
> could be different if there were two kinds of XSK sockets: RX-only and
> TX-only, but it's not the case.

It is possible to create Rx only or Tx only AF_XDP sockets from the
uapi by only creating an Rx or a Tx ring. Though, the NDO that
registers the umem in the driver would need to be extended with this
information so that the driver could act upon it. Today it is assumed
that it is always Rx and Tx which wastes resources and maybe also
performance. This has been on my todo list for quite some time, but it
has never floated up to the top.

> >>> Today, AF_XDP can attach to an existing queue for ingress. (On the
> >>> egress side, we're using "a queue", but the "XDP queue". XDP has thes=
e
> >>> "shadow queues" which are separated from the netdev. This is a bit
> >>> messy, and we can't really configure them. I believe Jakub has some
> >>> ideas here. :-) For now, let's leave egress aside.)
> >>
> >> So, XDP already has "shadow queues" for TX, so I see no problem in
> >> having the similar concept for AF_XDP RX.
> >
> > The question is if we would like to continue down the path of "shadow
> > queues" by adding even more.
>
> OK, I think "shadow queues" is not a valid name, and it's certainly not
> something bad. Initially, kernel had a concept of RX and TX queues. They
> can match the queues the driver has for regular traffic. Then new
> features appeared (XDP, then AF_XDP), and they required new types of
> queues: XDP TX queue, AF_XDP RX queue. These are absolutely new
> concepts, they aren't interchangeable with the legacy RX and TX queues.
> It means we can't just say we have 32 TX queues, 16 of which are regular
> SQs and 16 are XDP SQs. They function differently: the stack must not
> try sending anything from an XDP SQ, and XDP_REDIRECT must not try
> sending from the regular SQ.
>
> However, the kernel didn't learn about new types of queues. That's why
> the new queues remain "in shadow". And we certainly shouldn't use the
> same numeration for different types of queues, i.e. it's incorrect to
> say that TX queues 0..15 are regular SQs, TX queues 16..31 are XDP SQs,
> etc. The correct way is: there are 16 regular SQs 0..15 and 16 XDP SQs
> 0..15.
>
> The same considerations apply to AF_XDP RX queues (XSK RQs). This is a
> whole new type of queue, so it can't be mixed with the regular RQs.
> That's why they have their own numeration and are not accounted as RX
> queues (moreover, their numeration can be non-contiguous). If the kernel
> had need to know about them, they could be exposed to the netdev as a
> third type of queue, but I see no need currently.
>
> > In the busy-poll RFC I sent out last
> > week, I talk about the possibility to create a new queue (set) not
> > tied to the napi of the regular Rx queues in order to get better
> > performance when using busy-poll. How would such a queue set fit into
> > a shadow queue set approach?
>
> Looking at the question in the RFC, I don't see in what way it
> interferes with XSK RQs. Moreover, it's even more convenient to have a
> separate type of queue - you'll be able to create and destroy "unbound"
> (not driven by an interrupt, having a separate NAPI) XSK RQs without
> interfering with the regular queues. At first sight, I would say it's a
> perfect fit :). For me, it looks cleaner when we have regular RQs in
> channels, XSK RQs in channels and "unbound" XSK RQs than having channels
> that switch the RQ type and having some extra out-of-channel RQs that
> behave differently, but look the same to the kernel.

Agree with you that they are not interchangeable and that they
should be explicit. So we are on the same page here. Good. But
let us try to solve the Tx problem first because it has been
there from day one for both XDP and AF_XDP. Jakub Kicinski has
some ideas in this direction that he presented at Linux Kernel
Developers' bpfconf 2019
(http://vger.kernel.org/bpfconf2019.html) where he suggested to
start with Tx first. Let us start a discussion around that. Many
of the concepts developed there should hopefully extend to the Rx
side too.

Note that AF_XDP is today using the Rx queues that XDP operates
on (because it is an extension of XDP) both in the uapi and in
the driver. And these are the regular netdev Rx queues. But as we
all agree on, we need to change this so the choice becomes more
flexible and plays nicely with all side band configuration tools.

> > When does hiding the real queues created
> > to support various features break and we have to expose the real queue
> > number? Trying to wrap my head around these questions.
>
> As I said above, different types of queues should not share the
> numeration. So, if need be, they can be exposed as a different type, but
> I don't see the necessity yet.
>
> > Maxim, would it be possible for you to respin this set without this
> > feature?
>
> That's not as easy as you may think... It's not just a feature - for the
> kernel it's just a feature, but for the driver it's part of core design
> of AF_XDP support in mlx5. Removing it will require a lot of changes,
> reviewing and testing to adapt the driver to a different approach. I'd
> prefer to come to the conclusion before thinking of such changes :)

I leave it up to you if you would like to wait to submit the next
version of your patch set until the "queue id" problem of both Rx
and Tx has been resolved. I hope that it will be speedy so that
you can get your patch set in, but it might not be. It would have
been better if you had partitioned your patch set from the start
as: basic support -> new uapi/kernel feature -> implementation of
the new feature in your driver. Then we could have acked the
basic support quickly. It is good stuff.

Thanks: Magnus

> Thanks for giving the feedback and joining this discussion!
>
> > I like the other stuff you have implemented and think that
> > the rest of the common functionality should be useful for all of us.
> > This way you can get the AF_XDP support accepted quicker while we
> > debate the best way to solve the issue in this thread.
> >
> > Thanks for all your work: Magnus
> >
> >>> If an application would like to get all the traffic from a netdev,
> >>> it'll create an equal amout of sockets as the queues and bind to the
> >>> queues. Yes, even the queues in the RSS  set.
> >>>
> >>> What you would like (I think):
> >>> a) is a way of spawning a new queue for a netdev, that is not part of
> >>> the stack and/or RSS set
> >>
> >> Yes - for the simplicity sake and to make configuration easier. The on=
ly
> >> thing needed is to steer the traffic and to open an AF_XDP socket on
> >> channel X. We don't need to care about removing the queue out of RSS,
> >> about finding a way to administer this (which is hard because it's rac=
y
> >> if the configuration in not known in advance). So I don't agree I'm
> >> complicating things, my goal is to make them easier.
> >>
> >>> b) steering traffic to that queue using a configuration mechanism (tc=
?
> >>> some yet to be hacked BPF configuration hook?)
> >>
> >> Currently, ethtool --config-ntuple is used to steer the traffic. The
> >> user-def argument has a bit that selects XSK RQ/regular RQ, and action
> >> selects a channel:
> >>
> >> ethtool -N eth0 flow-type udp4 dst-port 4242 action 3 user-def 1
> >>
> >>> With your mechanism you're doing this in contrived way. This makes th=
e
> >>> existing AF_XDP model *more* complex/hard(er) to use.
> >>
> >> No, as I said above, some issues are eliminated with my approach, and =
no
> >> new limitations are introduced, so it makes things more universal and
> >> simpler to configure.
> >>
> >>> How do you steer traffic to this dual-channel RQ?
> >>
> >> First, there is no dual-channel RQ, a more accurate term is dual-RQ
> >> channel, cause now the channel contains a regular RQ and can contain a=
n
> >> XSK RQ.
> >>
> >> For the steering itself, see the ethtool command above - the user-def
> >> argument has a bit that selects one of two RQs.
> >>
> >>> So you have a netdev
> >>> receiving on all queues. Then, e.g., the last queue is a "dual
> >>> channel" queue that can receive traffic from some other filter. How d=
o
> >>> you use it?
> >>
> >> If I want to take the last (or some) channel and start using AF_XDP wi=
th
> >> it, I simply configure steering to the XSK RQ of that channel and open=
 a
> >> socket specifying the channel number. I don't need to reconfigure RSS,
> >> because RSS packets go to the regular RQ of that channel and don't
> >> interfere with XSK.
> >>
> >> No functionality is lost - if you don't distinguish the regular and XS=
K
> >> RQs on the XDP level, you'll get the same effect as with i40e's
> >> implementation. If you want to dedicate the CPU core and channel solel=
y
> >> for AF_XDP, in i40e you exclude the channel from RSS, and here you can
> >> do exactly the same thing. So, no use case is complicated comparing to
> >> i40e, but there are use cases where this feature is to advantage.
> >>
> >> I hope I explained the points you were interested in. Please ask more
> >> questions if there is still something that I should clarify regarding
> >> this topic.
> >>
> >> Thanks,
> >> Max
> >>
> >>>
> >>>
> >>> Bj=C3=B6rn
> >>>
> >>>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >>>> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> >>>> ---
> >>>>    include/uapi/linux/if_xdp.h       |  11 +++
> >>>>    net/xdp/xsk.c                     |   5 +-
> >>>>    samples/bpf/xdpsock_user.c        |  10 ++-
> >>>>    tools/include/uapi/linux/if_xdp.h |  11 +++
> >>>>    tools/lib/bpf/xsk.c               | 116 ++++++++++++++++++++++---=
-----
> >>>>    tools/lib/bpf/xsk.h               |   4 ++
> >>>>    6 files changed, 126 insertions(+), 31 deletions(-)
> >>>>
> >>>> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp=
.h
> >>>> index 9ae4b4e08b68..cf6ff1ecc6bd 100644
> >>>> --- a/include/uapi/linux/if_xdp.h
> >>>> +++ b/include/uapi/linux/if_xdp.h
> >>>> @@ -82,4 +82,15 @@ struct xdp_desc {
> >>>>
> >>>>    /* UMEM descriptor is __u64 */
> >>>>
> >>>> +/* The driver may run a dedicated XSK RQ in the channel. The XDP pr=
ogram uses
> >>>> + * this flag bit in the queue index to distinguish between two RQs =
of the same
> >>>> + * channel.
> >>>> + */
> >>>> +#define XDP_QID_FLAG_XSKRQ (1 << 31)
> >>>> +
> >>>> +static inline __u32 xdp_qid_get_channel(__u32 qid)
> >>>> +{
> >>>> +       return qid & ~XDP_QID_FLAG_XSKRQ;
> >>>> +}
> >>>> +
> >>>>    #endif /* _LINUX_IF_XDP_H */
> >>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> >>>> index 998199109d5c..114ba17acb09 100644
> >>>> --- a/net/xdp/xsk.c
> >>>> +++ b/net/xdp/xsk.c
> >>>> @@ -104,9 +104,12 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, st=
ruct xdp_buff *xdp, u32 len)
> >>>>
> >>>>    int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
> >>>>    {
> >>>> +       struct xdp_rxq_info *rxq =3D xdp->rxq;
> >>>> +       u32 channel =3D xdp_qid_get_channel(rxq->queue_index);
> >>>>           u32 len;
> >>>>
> >>>> -       if (xs->dev !=3D xdp->rxq->dev || xs->queue_id !=3D xdp->rxq=
->queue_index)
> >>>> +       if (xs->dev !=3D rxq->dev || xs->queue_id !=3D channel ||
> >>>> +           xs->zc !=3D (rxq->mem.type =3D=3D MEM_TYPE_ZERO_COPY))
> >>>>                   return -EINVAL;
> >>>>
> >>>>           len =3D xdp->data_end - xdp->data;
> >>>> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> >>>> index d08ee1ab7bb4..a6b13025ee79 100644
> >>>> --- a/samples/bpf/xdpsock_user.c
> >>>> +++ b/samples/bpf/xdpsock_user.c
> >>>> @@ -62,6 +62,7 @@ enum benchmark_type {
> >>>>
> >>>>    static enum benchmark_type opt_bench =3D BENCH_RXDROP;
> >>>>    static u32 opt_xdp_flags =3D XDP_FLAGS_UPDATE_IF_NOEXIST;
> >>>> +static u32 opt_libbpf_flags;
> >>>>    static const char *opt_if =3D "";
> >>>>    static int opt_ifindex;
> >>>>    static int opt_queue;
> >>>> @@ -306,7 +307,7 @@ static struct xsk_socket_info *xsk_configure_soc=
ket(struct xsk_umem_info *umem)
> >>>>           xsk->umem =3D umem;
> >>>>           cfg.rx_size =3D XSK_RING_CONS__DEFAULT_NUM_DESCS;
> >>>>           cfg.tx_size =3D XSK_RING_PROD__DEFAULT_NUM_DESCS;
> >>>> -       cfg.libbpf_flags =3D 0;
> >>>> +       cfg.libbpf_flags =3D opt_libbpf_flags;
> >>>>           cfg.xdp_flags =3D opt_xdp_flags;
> >>>>           cfg.bind_flags =3D opt_xdp_bind_flags;
> >>>>           ret =3D xsk_socket__create(&xsk->xsk, opt_if, opt_queue, u=
mem->umem,
> >>>> @@ -346,6 +347,7 @@ static struct option long_options[] =3D {
> >>>>           {"interval", required_argument, 0, 'n'},
> >>>>           {"zero-copy", no_argument, 0, 'z'},
> >>>>           {"copy", no_argument, 0, 'c'},
> >>>> +       {"combined", no_argument, 0, 'C'},
> >>>>           {0, 0, 0, 0}
> >>>>    };
> >>>>
> >>>> @@ -365,6 +367,7 @@ static void usage(const char *prog)
> >>>>                   "  -n, --interval=3Dn     Specify statistics updat=
e interval (default 1 sec).\n"
> >>>>                   "  -z, --zero-copy      Force zero-copy mode.\n"
> >>>>                   "  -c, --copy           Force copy mode.\n"
> >>>> +               "  -C, --combined       Driver supports combined XSK=
 and non-XSK traffic in a channel.\n"
> >>>>                   "\n";
> >>>>           fprintf(stderr, str, prog);
> >>>>           exit(EXIT_FAILURE);
> >>>> @@ -377,7 +380,7 @@ static void parse_command_line(int argc, char **=
argv)
> >>>>           opterr =3D 0;
> >>>>
> >>>>           for (;;) {
> >>>> -               c =3D getopt_long(argc, argv, "Frtli:q:psSNn:cz", lo=
ng_options,
> >>>> +               c =3D getopt_long(argc, argv, "Frtli:q:psSNn:czC", l=
ong_options,
> >>>>                                   &option_index);
> >>>>                   if (c =3D=3D -1)
> >>>>                           break;
> >>>> @@ -420,6 +423,9 @@ static void parse_command_line(int argc, char **=
argv)
> >>>>                   case 'F':
> >>>>                           opt_xdp_flags &=3D ~XDP_FLAGS_UPDATE_IF_NO=
EXIST;
> >>>>                           break;
> >>>> +               case 'C':
> >>>> +                       opt_libbpf_flags |=3D XSK_LIBBPF_FLAGS__COMB=
INED_CHANNELS;
> >>>> +                       break;
> >>>>                   default:
> >>>>                           usage(basename(argv[0]));
> >>>>                   }
> >>>> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/=
linux/if_xdp.h
> >>>> index 9ae4b4e08b68..cf6ff1ecc6bd 100644
> >>>> --- a/tools/include/uapi/linux/if_xdp.h
> >>>> +++ b/tools/include/uapi/linux/if_xdp.h
> >>>> @@ -82,4 +82,15 @@ struct xdp_desc {
> >>>>
> >>>>    /* UMEM descriptor is __u64 */
> >>>>
> >>>> +/* The driver may run a dedicated XSK RQ in the channel. The XDP pr=
ogram uses
> >>>> + * this flag bit in the queue index to distinguish between two RQs =
of the same
> >>>> + * channel.
> >>>> + */
> >>>> +#define XDP_QID_FLAG_XSKRQ (1 << 31)
> >>>> +
> >>>> +static inline __u32 xdp_qid_get_channel(__u32 qid)
> >>>> +{
> >>>> +       return qid & ~XDP_QID_FLAG_XSKRQ;
> >>>> +}
> >>>> +
> >>>>    #endif /* _LINUX_IF_XDP_H */
> >>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >>>> index a95b06d1f81d..969dfd856039 100644
> >>>> --- a/tools/lib/bpf/xsk.c
> >>>> +++ b/tools/lib/bpf/xsk.c
> >>>> @@ -76,6 +76,12 @@ struct xsk_nl_info {
> >>>>           int fd;
> >>>>    };
> >>>>
> >>>> +enum qidconf {
> >>>> +       QIDCONF_REGULAR,
> >>>> +       QIDCONF_XSK,
> >>>> +       QIDCONF_XSK_COMBINED,
> >>>> +};
> >>>> +
> >>>>    /* For 32-bit systems, we need to use mmap2 as the offsets are 64=
-bit.
> >>>>     * Unfortunately, it is not part of glibc.
> >>>>     */
> >>>> @@ -139,7 +145,7 @@ static int xsk_set_xdp_socket_config(struct xsk_=
socket_config *cfg,
> >>>>                   return 0;
> >>>>           }
> >>>>
> >>>> -       if (usr_cfg->libbpf_flags & ~XSK_LIBBPF_FLAGS__INHIBIT_PROG_=
LOAD)
> >>>> +       if (usr_cfg->libbpf_flags & ~XSK_LIBBPF_FLAGS_MASK)
> >>>>                   return -EINVAL;
> >>>>
> >>>>           cfg->rx_size =3D usr_cfg->rx_size;
> >>>> @@ -267,44 +273,93 @@ static int xsk_load_xdp_prog(struct xsk_socket=
 *xsk)
> >>>>           /* This is the C-program:
> >>>>            * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> >>>>            * {
> >>>> -        *     int *qidconf, index =3D ctx->rx_queue_index;
> >>>> +        *     int *qidconf, qc;
> >>>> +        *     int index =3D ctx->rx_queue_index & ~(1 << 31);
> >>>> +        *     bool is_xskrq =3D ctx->rx_queue_index & (1 << 31);
> >>>>            *
> >>>> -        *     // A set entry here means that the correspnding queue=
_id
> >>>> -        *     // has an active AF_XDP socket bound to it.
> >>>> +        *     // A set entry here means that the corresponding queu=
e_id
> >>>> +        *     // has an active AF_XDP socket bound to it. Value 2 m=
eans
> >>>> +        *     // it's zero-copy multi-RQ mode.
> >>>>            *     qidconf =3D bpf_map_lookup_elem(&qidconf_map, &inde=
x);
> >>>>            *     if (!qidconf)
> >>>>            *         return XDP_ABORTED;
> >>>>            *
> >>>> -        *     if (*qidconf)
> >>>> +        *     qc =3D *qidconf;
> >>>> +        *
> >>>> +        *     if (qc =3D=3D 2)
> >>>> +        *         qc =3D is_xskrq ? 1 : 0;
> >>>> +        *
> >>>> +        *     switch (qc) {
> >>>> +        *     case 0:
> >>>> +        *         return XDP_PASS;
> >>>> +        *     case 1:
> >>>>            *         return bpf_redirect_map(&xsks_map, index, 0);
> >>>> +        *     }
> >>>>            *
> >>>> -        *     return XDP_PASS;
> >>>> +        *     return XDP_ABORTED;
> >>>>            * }
> >>>>            */
> >>>>           struct bpf_insn prog[] =3D {
> >>>> -               /* r1 =3D *(u32 *)(r1 + 16) */
> >>>> -               BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 16),
> >>>> -               /* *(u32 *)(r10 - 4) =3D r1 */
> >>>> -               BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
> >>>> -               BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> >>>> -               BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
> >>>> -               BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
> >>>> +               /* Load index. */
> >>>> +               /* r6 =3D *(u32 *)(r1 + 16) */
> >>>> +               BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_ARG1, 16),
> >>>> +               /* w7 =3D w6 */
> >>>> +               BPF_MOV32_REG(BPF_REG_7, BPF_REG_6),
> >>>> +               /* w7 &=3D 2147483647 */
> >>>> +               BPF_ALU32_IMM(BPF_AND, BPF_REG_7, ~XDP_QID_FLAG_XSKR=
Q),
> >>>> +               /* *(u32 *)(r10 - 4) =3D r7 */
> >>>> +               BPF_STX_MEM(BPF_W, BPF_REG_FP, BPF_REG_7, -4),
> >>>> +
> >>>> +               /* Call bpf_map_lookup_elem. */
> >>>> +               /* r2 =3D r10 */
> >>>> +               BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_FP),
> >>>> +               /* r2 +=3D -4 */
> >>>> +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, -4),
> >>>> +               /* r1 =3D qidconf_map ll */
> >>>> +               BPF_LD_MAP_FD(BPF_REG_ARG1, xsk->qidconf_map_fd),
> >>>> +               /* call 1 */
> >>>>                   BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> >>>> -               BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> >>>> -               BPF_MOV32_IMM(BPF_REG_0, 0),
> >>>> -               /* if r1 =3D=3D 0 goto +8 */
> >>>> -               BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
> >>>> -               BPF_MOV32_IMM(BPF_REG_0, 2),
> >>>> -               /* r1 =3D *(u32 *)(r1 + 0) */
> >>>> -               BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> >>>> -               /* if r1 =3D=3D 0 goto +5 */
> >>>> -               BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
> >>>> -               /* r2 =3D *(u32 *)(r10 - 4) */
> >>>> -               BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
> >>>> -               BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
> >>>> +
> >>>> +               /* Check the return value. */
> >>>> +               /* if r0 =3D=3D 0 goto +14 */
> >>>> +               BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 14),
> >>>> +
> >>>> +               /* Check qc =3D=3D QIDCONF_XSK_COMBINED. */
> >>>> +               /* r6 >>=3D 31 */
> >>>> +               BPF_ALU64_IMM(BPF_RSH, BPF_REG_6, 31),
> >>>> +               /* r1 =3D *(u32 *)(r0 + 0) */
> >>>> +               BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
> >>>> +               /* if r1 =3D=3D 2 goto +1 */
> >>>> +               BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, QIDCONF_XSK_COMBINED=
, 1),
> >>>> +
> >>>> +               /* qc !=3D QIDCONF_XSK_COMBINED */
> >>>> +               /* r6 =3D r1 */
> >>>> +               BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
> >>>> +
> >>>> +               /* switch (qc) */
> >>>> +               /* w0 =3D 2 */
> >>>> +               BPF_MOV32_IMM(BPF_REG_0, XDP_PASS),
> >>>> +               /* if w6 =3D=3D 0 goto +8 */
> >>>> +               BPF_JMP32_IMM(BPF_JEQ, BPF_REG_6, QIDCONF_REGULAR, 8=
),
> >>>> +               /* if w6 !=3D 1 goto +6 */
> >>>> +               BPF_JMP32_IMM(BPF_JNE, BPF_REG_6, QIDCONF_XSK, 6),
> >>>> +
> >>>> +               /* Call bpf_redirect_map. */
> >>>> +               /* r1 =3D xsks_map ll */
> >>>> +               BPF_LD_MAP_FD(BPF_REG_ARG1, xsk->xsks_map_fd),
> >>>> +               /* w2 =3D w7 */
> >>>> +               BPF_MOV32_REG(BPF_REG_ARG2, BPF_REG_7),
> >>>> +               /* w3 =3D 0 */
> >>>>                   BPF_MOV32_IMM(BPF_REG_3, 0),
> >>>> +               /* call 51 */
> >>>>                   BPF_EMIT_CALL(BPF_FUNC_redirect_map),
> >>>> -               /* The jumps are to this instruction */
> >>>> +               /* exit */
> >>>> +               BPF_EXIT_INSN(),
> >>>> +
> >>>> +               /* XDP_ABORTED */
> >>>> +               /* w0 =3D 0 */
> >>>> +               BPF_MOV32_IMM(BPF_REG_0, XDP_ABORTED),
> >>>> +               /* exit */
> >>>>                   BPF_EXIT_INSN(),
> >>>>           };
> >>>>           size_t insns_cnt =3D sizeof(prog) / sizeof(struct bpf_insn=
);
> >>>> @@ -483,6 +538,7 @@ static int xsk_update_bpf_maps(struct xsk_socket=
 *xsk, int qidconf_value,
> >>>>
> >>>>    static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> >>>>    {
> >>>> +       int qidconf_value =3D QIDCONF_XSK;
> >>>>           bool prog_attached =3D false;
> >>>>           __u32 prog_id =3D 0;
> >>>>           int err;
> >>>> @@ -505,7 +561,11 @@ static int xsk_setup_xdp_prog(struct xsk_socket=
 *xsk)
> >>>>                   xsk->prog_fd =3D bpf_prog_get_fd_by_id(prog_id);
> >>>>           }
> >>>>
> >>>> -       err =3D xsk_update_bpf_maps(xsk, true, xsk->fd);
> >>>> +       if (xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__COMBINED_CH=
ANNELS)
> >>>> +               if (xsk->zc)
> >>>> +                       qidconf_value =3D QIDCONF_XSK_COMBINED;
> >>>> +
> >>>> +       err =3D xsk_update_bpf_maps(xsk, qidconf_value, xsk->fd);
> >>>>           if (err)
> >>>>                   goto out_load;
> >>>>
> >>>> @@ -717,7 +777,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >>>>           if (!xsk)
> >>>>                   return;
> >>>>
> >>>> -       (void)xsk_update_bpf_maps(xsk, 0, 0);
> >>>> +       (void)xsk_update_bpf_maps(xsk, QIDCONF_REGULAR, 0);
> >>>>
> >>>>           optlen =3D sizeof(off);
> >>>>           err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &of=
f, &optlen);
> >>>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> >>>> index 82ea71a0f3ec..be26a2423c04 100644
> >>>> --- a/tools/lib/bpf/xsk.h
> >>>> +++ b/tools/lib/bpf/xsk.h
> >>>> @@ -180,6 +180,10 @@ struct xsk_umem_config {
> >>>>
> >>>>    /* Flags for the libbpf_flags field. */
> >>>>    #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
> >>>> +#define XSK_LIBBPF_FLAGS__COMBINED_CHANNELS (1 << 1)
> >>>> +#define XSK_LIBBPF_FLAGS_MASK ( \
> >>>> +       XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD | \
> >>>> +       XSK_LIBBPF_FLAGS__COMBINED_CHANNELS)
> >>>>
> >>>>    struct xsk_socket_config {
> >>>>           __u32 rx_size;
> >>>> --
> >>>> 2.19.1
> >>>>
> >>
>
