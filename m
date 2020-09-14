Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA3F269700
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgINUuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgINUuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:50:39 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B12AC061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:50:39 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f82so894441ilh.8
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K6A5OSh74mPAypZi4Sz7IdNNHSfQXKbyA7lU8bxwBwk=;
        b=TGJzf5g82AoJqomwZz4fyAMBcFXHur2ozcLmlRz5j+p+Kihot93J60Dxhh/Wi0L+MQ
         oKRHKMO+D0U+wqjH5HZecW0Ofnv7KBQI2RQAi9QITtNoQ26HdqwT9OF/4uH86X1+2Gmu
         sfxHVjQfETA4mzEHIcgY3iITaWT8cQvVgZ4cbFsTorUpd/9Sj0hvVmVPjvlzAXFVYyRz
         2erNK0YjfJaDLyfZUrzsWd+XAAE+gvk3IS/sAmmMxXSJ/Rz28HEO5MrHo3nTIRtFPs0S
         Jzos+MpA5UTXn5f6NynPHVC9zKKFDvSk+LltMRXR61bUhoDuLXs80d1Hj+QVZ2F0M/O5
         VFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K6A5OSh74mPAypZi4Sz7IdNNHSfQXKbyA7lU8bxwBwk=;
        b=Xz9SjmHyxQMPkDLbNleyiDRVrg8ty5NjZuWrnuq6o1VKN0jRG70zXWwxpmjapBWyf9
         I/uSpAW6o+mgzSDU8BW8WPZVog9UfXT5JRKOBCfB+pOXF7SMBYxQKqAWJ59wo1S1UuH5
         pZfmxJQyw63ev8VlM3wzEFbgl30qv9S40UlPutCAiQGkVaigiM8qRz8ZzgaSHJHjzlyQ
         l5OgowRLDLiduAjbd2oTaqcpwaE3kHgOPV310EBrqsbQuM7Lb3kn6Qz4NMBTL7Xo+VNT
         3zVsTuL5vxU7GzEGD63LBpBn+Ypeq2MZEsv4ydl+1DdO79+Ms51BcUV/M7fPU0g8QqkB
         N/SA==
X-Gm-Message-State: AOAM533N0SlIDMvzM8+RtGjRRZxO/n+O00nZidvrlV76AyvEywO93cQU
        NEj/bQdOS3HosmCqeGpndYUwKcARTq5Dd3Duux5Q7A==
X-Google-Smtp-Source: ABdhPJytWinqtzE6AutzVvL7xMemT+iXBG/kKk8ONByk8/Q4gnF5i51O/K3ej3AVhrLQ5xpNhaLICketsve+wAGENco=
X-Received: by 2002:a92:2001:: with SMTP id j1mr11503508ile.56.1600116637954;
 Mon, 14 Sep 2020 13:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <159921182827.1260200.9699352760916903781.stgit@firesoul>
 <20200904163947.20839d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907160757.1f249256@carbon> <CANP3RGfjUOoVH152VHLXL3y7mBsF+sUCqEZgGAMdeb9_r_Z-Bw@mail.gmail.com>
 <20200914160538.2bd51893@carbon>
In-Reply-To: <20200914160538.2bd51893@carbon>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 14 Sep 2020 13:50:24 -0700
Message-ID: <CANP3RGftg2-_tBc=hGGzxjGZUq9b1amb=TiKRVHSBEyXq-A5QA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: don't check against device MTU in __bpf_skb_max_len
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 7:05 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
>
> Hi Maze,
>
> Thanks for getting back to me, I appreciate that a lot.
> More inline below:
>
> On Thu, 10 Sep 2020 13:00:12 -0700
> Maciej =C5=BBenczykowski <maze@google.com> wrote:
>
> > All recent Android R common kernels are currently carrying the
> > following divergence from upstream:
> >
> > https://android.googlesource.com/kernel/common/+/194a1bf09a7958551a9e2d=
c947bdfe3f8be8eca8%5E%21/
> >
> > static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> >  {
> > - return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > -  SKB_MAX_ALLOC;
> > + if (skb_at_tc_ingress(skb) || !skb->dev)
> > + return SKB_MAX_ALLOC;
> > + return skb->dev->mtu + skb->dev->hard_header_len;
> >  }
>
> Thanks for sharing that Android now have this out-of-tree patch. I'm
> obviously annoyed that this was not upstreamed, as it hurts both you
> and me, but we do live in an imperfect world ;)

Yeah... it was too late in the dev cycle to reach consensus... and we
needed to ship. :-(
Since we strictly control the ebpf code I'm not (really) worried about
this exposing bugs.

(btw. besides there's another gso bpf 4to6/6to4 translation bug that's
already exposed and needs fixing,
problem is fix is not backwards compatible - so need to write an essay
about how stupid the current code
is and why it must be changed, even while potentially breaking userspace...
quick summary: the gso adjustments in 4to6/6to4 conversion funcs
should be outright deleted)

> > There wasn't agreement on how to handle this upstream because some
> > folks thought this check was useful...
> > Myself - I'm not entirely certain...
> > I'd like to be able to test for (something like) this, yes, but the
> > way it's done now is kind of pointless...
> > It breaks for gso packets anyway - it's not true that a gso packet can
> > just ignore the mtu check, you do actually need to check individual
> > gso segments are sufficiently small...
> > You need to check against the right interface, which again in the
> > presence of bpf redirect it currently utterly fails.
>
> I agree that the current check is done against the wrong interface.
>
> > Checking on receive just doesn't seem useful, so what if I want to
> > increase packet size that arrives at the stack?
>
> It seems very practical to allow increase packet size of received
> packet, also for local netstack deliver.  (e.g allowing to add encap
> headers, without being limited to RX device MTU).
>
>
> > I also don't understand where SKB_MAX_ALLOC even comes from... skb's
> > on lo/veth can be 64KB not SKB_MAX_ALLOC (which ifirc is 16KB).
>
> It was John that added the 16KiB SKB_MAX_ALLOC limit...
> Why this value John?
>
>
> > I think maybe there's now sufficient access to skb->len &
> > gso_segs/size to implement this in bpf instead of relying on the
> > kernel checking it???
> > But that might be slow...
> >
> > It sounded like it was trending towards some sort of larger scale refac=
toring.
> >
> > I haven't had the opportunity to take another look at this since then.
> > I'm not at all sure what would break if we just utterly deleted these
> > pkt too big > mtu checks.
>
> I'm looking at the code, and TC-ingress redirect to TC-egress and
> following code into driver (ixgbe) it does look like we don't have
> anything that limit/check the MTU before sending it out the driver (and
> the specific driver also didn't limit this).
>
> Thus, I think this patch is not enough on its own.  We/I likely need to
> move the MTU check (instead of simply removing it), but based on the
> egress device, and not the ingress device.  I will look more into this.

Yes, I think I agree that checking pkt > mtu (also for gso!) should be
done in some core 'just prior' to driver location.
However... this has the issue of being too late to return a clean
error to the bpf program itself :-(
Oh well?  Maybe we don't care?

> > In general in my experience bpf poorly handles gso and mtu and this is
> > an area in need of improvement.
> > I've been planning to get around to this, but am currently busy with a
> > bazillion other higher priority things :-(
> >
> > Like trying to figure out whether XDP is even usable with real world
> > hardware limitations (currently the answer is still leaning towards
> > no, though there was some slightly positive news in the past few
> > days).
>
> Getting XDP support in all the different Android drivers seems like an
> impossible task.  And you don't want to use generic-XDP, because it
> will very likely cause a SKB re-allocation and copy of the data.
>
> I think TC-BPF will likely be the better choice in the Android ecosystem.

Yeah currently it looks like our bottlenecks are full payload data
memcpy's in the cell and usb drivers (they're stupid!!!), combined
with the skb alloc/zero/free overhead costs.  Switching to XDP would
eliminate the latter...
But we'd end up with XDP with 2 data payload copies (into the XDP
frame in the cell driver, and out of the XDP frame in the usb driver).
So XDP and yet not.  Since the cell driver (at least 2 different ones
I've looked at) already does a full payload copy... this wouldn't
necessarily be any worse then it is now for normal stack destined
traffic.

I see some potential crazy workarounds:

Only run XDP on the first ~cacheline of the packet, so it can look at
ether/ip/tcp headers but not data - and modify (& prepend to) this
header.
We don't need data access anyway(*), add a new special driver transmit
function that takes a pointer/length to two read-only buffers -
without any memory ownership (ie. copy out prior to func returning).
With this approach I'm down to one copy of payload (2 copies of ip
headers)

* potential issue: we'd like to be able to do ipv6 udp checksum
calculation (ipv4 udp checksum 0 is valid, for ipv6 it is not, so
translation ipv4 to ipv6 udp requires it), which does require access
to full payload, but this could be hacked via partial checksum
implementation.
In this case the special xmit func would need to look like:
  ndp_xdp_light_xmit(const void* ptr1, u16 len1, const void* ptr2, u16
len2, u16 csum_start, u16 csum_offset, [int flags])

I'm also still trying to figure out whether the cell memory model and
usb/wifi hw capabilities would allow full zerocopy xdp, but I'm
virtually certain the answer is not on all hardware (requires at least
scatter gather capable usb controller, and cellular modem with full
RAM DMA access, and it looks like there's various DMA32 style
restrictions here, sometimes even more like DMA26...).

I don't currently understand the XDP memory model, so any description
there-of would be useful.  Does it require 4KB or can 2KB pieces be
used?  (remember I'm really only interested in XDP redirect across
drivers cell/wifi/usb gadget/usb dongle/ethernet/bluetooth)  How much
headroom/tailroom is needed (i'd need extra headroom for header
insertion/modification myself: how can I force the receiving
driver/nic to provide enough headroom, up to 40 ipv6 - 20 ipv4 + 8
ipv6 frag + 14 ethernet =3D 42 bytes, possibly 4 more for vlan, possibly
a few bytes more for tricks with scatter gather in usb ncm driver,
assuming zerocopy is doable)?  How should the memory be (ideally)
allocated/deallocated?  Is there a de-alloc callback?  How does that
work with conversion from xdp to skb, where skb free has no callback?
It might actually be ok, to force a payload memcpy during xdp->skb
upconversion...

> > And whether we can even reach our performance goals with
> > jit'ed bpf... or do we need to just write it in kernel C... :-(
>
> My experience is that Jit'ed BPF code is super fast, also for the ARM
> 64-bit experiments:
>
>  https://github.com/xdp-project/xdp-project/tree/master/areas/arm64

Would you happen to know what ebpf startup overhead is?
How big a problem is having two (or more) back to back tc programs
instead of one?
We're running into both verifier performance scaling problems and code
ownership issues with large programs...

[btw. I understand for XDP we could only use 1 program anyway...]

Hoping you'll do my work for me :-) or at least answer some of the
above questions to the best of your knowledge...

- Maciej
