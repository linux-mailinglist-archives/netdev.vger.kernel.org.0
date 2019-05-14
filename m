Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACCD1C42F
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 09:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfENHxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 03:53:38 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34995 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfENHxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 03:53:38 -0400
Received: by mail-qt1-f195.google.com with SMTP id a39so17096469qtk.2;
        Tue, 14 May 2019 00:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Eh/zQ+Sxx+00B0BqKToBzvL+L8p/RqQRPhJgO46Yy7g=;
        b=CeZskMnTfLm6ixsvW1WO28urhYno+oxXXtpmYjgn6uKob4dBeXkyMzZkyi3vj6iMbt
         U9WhrwyxVkn8CyAaN6ZMj6VHNwSm7ehaVVIaWR0MbXVhyALdsZG2RMsK/baIiiml6gQC
         Pm9EQl9uGhIYqyQiXr+3FXpd8Hio4RMUY4AERVCWNYTJQzsP9btomFhuft2u4wunAsgb
         lNSJscb6HwYsztLWfpUlVxLMBpdOsUKE//uIGfbMyk7xPz0YUG2wA+jTOAbN44n+kOBC
         /li05kDFh7J3BLbr9Jm4POtB48Tz+3V4bFoNEfNj/Yummy+eVSwiEBFyINYBQ9VS5vnw
         xABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Eh/zQ+Sxx+00B0BqKToBzvL+L8p/RqQRPhJgO46Yy7g=;
        b=Os2HkSMm0HwM/RBABsEgFyi5f79gFhEFgIAurYssSFcLWzONR+DG/B/QFC9GarONFW
         rQGxKp9lS5uzUyEmh3erT/CMX2zz5AarMl3CSXT69/L84kXUuyOVRYZM7NYZNAX7ibA5
         xxNjsFXIFUk4jBxFyT0F0q6FCDpECi/TKWovmJ+4ueIHYuucfWUz4rbs9GHHo1+eFHhg
         fIKY8hUhUagbiGx0snOHlCKpds6xqmGPl/sbUO1nFdFJ6NsM8ytdmiTji1De/eIonaco
         Qi3+VdTRSJFEt9Jr6iFw0zoPxhomaZmBF54iT1La3HujrJ2O+/YvKYkPxrRaDFKijIeI
         imZw==
X-Gm-Message-State: APjAAAXpV3Ksmy+0iD9yc1Vmrp6L9RpPoRzBjxZ4Rult8W6Y42rC95IF
        I9TktAcIWsxgIiLN8qu6tjmy6Eeab71mwxwQTaE=
X-Google-Smtp-Source: APXvYqxJfCsR8JtsfS8v3lsSgVBhoNuwTRJGh8IZtbxpRnikxh7Z9uYwa8I9N0G4CUlmb+YNNEQnzxks6NtDZ7WCwVI=
X-Received: by 2002:ac8:e81:: with SMTP id v1mr28637332qti.16.1557820416919;
 Tue, 14 May 2019 00:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp> <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp> <D40B5C89-53F8-4EC1-AB35-FB7C395864DE@fb.com>
In-Reply-To: <D40B5C89-53F8-4EC1-AB35-FB7C395864DE@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 14 May 2019 09:53:24 +0200
Message-ID: <CAJ+HfNgyfh+OYobQfpnuATPAde68DLDJzA_TsQPo9KuDE7=7fg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     Jonathan Lemon <bsd@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 May 2019 at 22:44, Jonathan Lemon <bsd@fb.com> wrote:
>
> Tossing in my .02 cents:
>
>
> I anticipate that most users of AF_XDP will want packet processing
> for a given RX queue occurring on a single core - otherwise we end
> up with cache delays.  The usual model is one thread, one socket,
> one core, but this isn't enforced anywhere in the AF_XDP code and is
> up to the user to set this up.
>

Hmm, I definitely see use-cases where one would like multiple Rx
sockets per core, and say, multiple Tx socket per core. Enforcing it
at the uapi is IMO not correct. (Maybe in libbpf, but that's another
thing.)

> On 7 May 2019, at 11:24, Alexei Starovoitov wrote:
> > I'm not saying that we shouldn't do busy-poll. I'm saying it's
> > complimentary, but in all cases single core per af_xdp rq queue
> > with user thread pinning is preferred.
>
> So I think we're on the same page here.
>
> > Stack rx queues and af_xdp rx queues should look almost the same from
> > napi point of view. Stack -> normal napi in softirq. af_xdp -> new
> > kthread
> > to work with both poll and busy-poll. The only difference between
> > poll and busy-poll will be the running context: new kthread vs user
> > task.
> ...
> > A burst of 64 packets on stack queues or some other work in softirqd
> > will spike the latency for af_xdp queues if softirq is shared.
>
> True, but would it be shared?  This goes back to the current model,
> which
> as used by Intel is:
>
>     (channel =3D=3D RX, TX, softirq)
>
> MLX, on the other hand, wants:
>
>     (channel =3D=3D RX.stack, RX.AF_XDP, TX.stack, TX.AF_XDP, softirq)
>
> Which would indeed lead to sharing.  The more I look at the above, the
> stronger I start to dislike it.  Perhaps this should be disallowed?
>
> I believe there was some mention at LSF/MM that the 'channel' concept
> was something specific to HW and really shouldn't be part of the SW API.
>

I'm probably stating things people already know, but let I'll take a
detour here anyway, hijacking this thread for a queue rant.

AF_XDP sockets has two modes; zero-copy mode and copy-mode. A socket
has different flavors: Rx, Tx or both. Sockets with Rx flavors (Rx or
'both') can be attached to an Rx queue. Today, the only Rx queues are
the ones attached to the stack.

Zero-copy sockets with Rx flavors require hardware steering, and to be
useful, a mechanism to create a set of queues is needed. When stack
queues and AF_XDP sockets reside on a shared netdev; Create queues
separated from the stack (how do we represent that to a user?).
Another way is creating a new netdev (say, macvlan with a zero-copy
support), and have all the Rx queues be represented by AF_XDP sockets.

Copy-mode Rx sockets, OTOH, does not require steering. In the
copy-mode case, the XDP program is a switchboard where some packets
can go to the stack, some to user-space and some elsewhere.

So, what does AF_XDP need, that's not in place yet (from my perspective)?

* For zero-copy: a mechanism to create new sets of Rx queues, and a
mechanism direct flows (via, say, a new bpf hook)
* For zero-copy/copy: a mechanism to create new Tx queues, and from
AF_XDP select that queue to be used by a socket. This would be good
for the generic XDP redirect case as well.

Zero-copy AF_XDP Rx sockets is typically used when the hardware
support that kind of steering, and typically a minimal XDP program
would then be used (if any, going forward). Copy-mode is for the
software fallback, where a more capable XDP program is needed. One
problem is that zero-copy and copy-mode behaves differently, so
copy-mode can't really be seen as a fallback to zero-copy today. In
copy-mode you cannot receive from Rx queue X, and redirect to socket
bound to queue Y (X !=3D Y). In zero-copy mode, you just bind to a
queue, and do the redirection from configuration.

So, it would be nice with "unbound/anonymous queue sockets" or
"virtual/no queues ids", which I think is what Alexei is proposing?
Create a bunch of sockets. For copy-mode, the XDP program will do the
steering (receive from HW queue X, redirect to any socket). For
zero-copy, the configuration will solve that. The userspace
application doesn't have to change, which is a good abstraction. :-)
For the copy-mode it would be a performance hit (relaxing the SPSC
relationship), but maybe we can care about that later.

From my perspective, a mechanism to create Tx *and* Rx queues separate
from the stack is useful even outside the scope of AF_XDP. Create a
set of Rx queues and Tx queues, configure flows to those Rx queues
(via BPF?), and let an XDP program do, say, load-balancing using the
setup Tx queues. This makes sense without AF_XDP as well. The
anonymous queue path is OTOH simpler, but is an AF_XDP only
mechanism...

> > Hence the proposal for new napi_kthreads:
> > - user creates af_xdp socket and binds to _CPU_ X then
> > - driver allocates single af_xdp rq queue (queue ID doesn't need to be
> > exposed)
> > - spawns kthread pinned to cpu X
> > - configures irq for that af_xdp queue to fire on cpu X
> > - user space with the help of libbpf pins its processing thread to
> > that cpu X
> > - repeat above for as many af_xdp sockets as there as cpus
> >   (its also ok to pick the same cpu X for different af_xdp socket
> >   then new kthread is shared)
> > - user space configures hw to RSS to these set of af_xdp sockets.
> >   since ethtool api is a mess I propose to use af_xdp api to do this
> > rss config
>
>
>  From a high level point of view, this sounds quite sensible, but does
> need
> some details ironed out.  The model above essentially enforces a model
> of:
>
>     (af_xdp =3D RX.af_xdp + bound_cpu)
>       (bound_cpu =3D hw.cpu + af_xdp.kthread + hw.irq)
>
> (temporarily ignoring TX for right now)
>

...and multiple Rx queues per core in there as well.

>
> I forsee two issues with the above approach:
>    1. hardware limitations in the number of queues/rings
>    2. RSS/steering rules
>
> > - user creates af_xdp socket and binds to _CPU_ X then
> > - driver allocates single af_xdp rq queue (queue ID doesn't need to be
> > exposed)
>
> Here, the driver may not be able to create an arbitrary RQ, but may need
> to
> tear down/reuse an existing one used by the stack.  This may not be an
> issue
> for modern hardware.
>

Again, let's focus on usability first. If the hardware cannot support
it efficiently, a software fallback. We don't want an API that's a
trash bin of different "stuff" hardware vendors want to put in because
they can. (Hi ethtool! ;-))

> > - user space configures hw to RSS to these set of af_xdp sockets.
> >   since ethtool api is a mess I propose to use af_xdp api to do this
> > rss config
>
> Currently, RSS only steers default traffic.  On a system with shared
> stack/af_xdp queues, there should be a way to split the traffic types,
> unless we're talking about a model where all traffic goes to AF_XDP.
>
> This classification has to be done by the NIC, since it comes before RSS
> steering - which currently means sending flow match rules to the NIC,
> which
> is less than ideal.  I agree that the ethtool interface is non optimal,
> but
> it does make things clear to the user what's going on.
>

I would also like to see a something else than ethtool, but not
limited to AF_XDP. Maybe a BPF configuration hook: Probe the HW for
capabilities; Missing support? Fallback and load an XDP program for
software emulation. Hardware support for BPF? Pass the "fallback" XDP
program to the hardware.

> Perhaps an af_xdp library that does some bookkeeping:
>    - open af_xdp socket
>    - define af_xdp_set as (classification, steering rules, other?)
>    - bind socket to (cpu, af_xdp_set)
>    - kernel:
>      - pins calling thread to cpu
>      - creates kthread if one doesn't exist, binds to irq and cpu
>      - has driver create RQ.af_xdp, possibly replacing RQ.stack
>      - applies (af_xdp_set) to NIC.
>
> Seems workable, but a little complicated?  The complexity could be moved
> into a separate library.
>

Yes. :-)


>
> > imo that would be the simplest and performant way of using af_xdp.
> > All configuration apis are under libbpf (or libxdp if we choose to
> > fork it)
> > End result is one af_xdp rx queue - one napi - one kthread - one user
> > thread.
> > All pinned to the same cpu with irq on that cpu.
> > Both poll and busy-poll approaches will not bounce data between cpus.
> > No 'shadow' queues to speak of and should solve the issues that
> > folks were bringing up in different threads.
>
> Sounds like a sensible model from my POV.

No, "shadow queues", but AF_XDP only queues. Maybe that's ok. OTOH the
XDP Tx queues are still there, and they cannot (today at least) be
configured.


Bj=C3=B6rn

> --
> Jonathan
