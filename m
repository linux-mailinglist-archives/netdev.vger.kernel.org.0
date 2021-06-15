Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92E03A832B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFOOuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFOOuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:50:05 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E01C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:47:59 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id c9so15885826qkm.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSIsabANz4aUvK/N6S7m3JBWS8IXROuSHJLelGdHzKY=;
        b=FkXpRZ1oDIWwYr6+Nixc9RStlLX7TuHlyz+e0G3xPUFf+OFCjLQO42Fbk+6xvFTgdU
         lLbMkma9Tm+tXdGoumgKXfIY/LGr5bLO/6ANpeiwnL8btV6WVxWgwBRljBZRyl2rH/V1
         QNcW4eI+RxBeUMuKxDpV3+MFlaX9dL2GLrNrenrfCtwr6M3zPjpNCDDBx2XuKFlifwW0
         c/wNdOdoqYQQby3eno4MvvxGK9z7rjEWK0VhNDabjhreWhKLtmT9780ma72+qWLOi4e3
         WOt1yT0YIZjlfA6KRZgwsOIzqO1tAcrD2P6/vR1v7xrQWC7w2WCj2WpLBkl8j94bKcpF
         iWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSIsabANz4aUvK/N6S7m3JBWS8IXROuSHJLelGdHzKY=;
        b=q6ko+INhsTXOO8dj2DlUPbuhuHyJYgNWkEPIe7qxLp+9AyAeWgH7Ivo1YM2uencnsC
         ZkNzGUba/plbfPf1D1HX96kRV/Ix4FrX+JpZKllul6+lW6Ksl2AydYOBQCmcJBU1uxj6
         qx1i87AkKCnMomgE9FhRSaAofFXNWGY4jfnuu6GRdXi/ZZonAorXc/Wvig2fGq/lYaLB
         17vZ9rvWv2ZfUmAaPdgyz3OYI1PAq06D3Nf4UDvrxBwlxjme1jHRJnuZj/dW0xUk1Cmi
         E1fa6Krh9HKPwXcwZUiqRlH655pZhPpl0g86aKrfPaET8AuxawLqAecUYF87wyiCNY7F
         EX9Q==
X-Gm-Message-State: AOAM531eg6P2hQA6ophdk+8/dLL/Y0eUVzNz8KdFhDE9IuxB4zsAASNN
        kR5x4Qi6vSY2GIFbX/lAS38INIrJKNTB22TrVcY=
X-Google-Smtp-Source: ABdhPJyCG1UY27FnzGCew4x/z89nKHTyVMwWHi0GJngA0RPaKLRPPP57ppDaH6EuemkLEdB/WoQW9FnxKCza4VymYA8=
X-Received: by 2002:a37:94e:: with SMTP id 75mr22131288qkj.127.1623768478791;
 Tue, 15 Jun 2021 07:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com> <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com> <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com> <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com> <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
 <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com>
In-Reply-To: <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 15 Jun 2021 10:47:22 -0400
Message-ID: <CAF=yD-J7kcXSqrXM1AcctpdBPznWeORd=z+bge+cP9KO_f=_yQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> Isn't virtio_net_hdr a virito-net specific metadata?
> > I don't think it is ever since it was also adopted for tun, tap,
> > pf_packet and uml. Basically, all callers of virtio_net_hdr_to_skb.
>
>
> For tun/tap it was used to serve the backend of the virtio-net datapath
> which is still virtio-net specific.
>
> For pf_packet and uml, they looks more like a byproduct or shortcut of
> the virtio-net backend (vhost has code to use af_packet, but I'm not
> whether or not it still work), so still kind of.
>
> But the most important thing is that, the semantic of vnet header is
> defined by virtio spec.

The packet socket and tuntap interfaces have use cases unrelated
to virtio. virtio_net_hdr is just a way to egress packets with offloads.

So yes and no. The current definition of struct virtio_net_hdr is part of
the Linux ABI as is, and used outside virtio.

If virtio changes its spec, let's say to add SO_TXTIME to give an
example, we may or may not bother to add a pf_packet setsockopt
to optionally support that.

>
> >
> >>
> >>> The only metadata that can be passed with tuntap, pf_packet et al is
> >>> virtio_net_hdr.
> >>>
> >>> I quite don't understand where xen-netfront et al come in.
> >>
> >> The problem is, what kind of issue you want to solve. If you want to
> >> solve virtio specific issue, why do you need to do that in the general
> >> flow dissector?
> >>
> >> If you want to solve the general issue of the packet metadata validation
> >> from untrusted source, you need validate not only virtio-net but all the
> >> others. Netfront is another dodgy source and there're a lot of implied
> >> untrusted source in the case of virtualization environment.
> > Ah understood.
> >
> > Yes, the goal is to protect the kernel from untrusted packets coming
> > from userspace in general. There are only a handful such injection
> > APIs.
>
> Userspace is not necessarily the source: it could come from a device or
> BPF.
>
> Theoretically, in the case of virtualization/smart NIC, they could be
> other type of untrusted source. Do we need to validate/mitigate the issues

Adding packets coming from NICs or BPF programs greatly expands
the scope.

The purpose of this patch series is to protect the kernel against packets
inserted from userspace, by adding validation at the entry point.

Agreed that BPF programs can do unspeakable things to packets, but
that is a different issue (with a different trust model), and out of scope.

> 1) per source/device like what this patch did, looks like a lot of work
> 2) validate via the general eBPF facility like XDP which requires
> multi-buffer and gso/csum support (which we know will happen for sure)
>
> ?

Are you thinking of the XDP support in virtio-net, which is specific
to that device and does not capture these other uses cases of
struct virtio_net_hdr_to_skb?

Or are you okay with the validation hook, but suggesting using
an XDP program type instead of a flow dissector program type?

>
> >
> > I have not had to deal with netfront as much as the virtio_net_hdr
> > users. I'll take a look at that and netvsc.
>
>
> For xen, it's interesting that dodgy was set by netfront but not netback.
>
>
> >   I cannot recall seeing as
> > many syzkaller reports about those, but that may not necessarily imply
> > that they are more robust -- it could just be that syzkaller has no
> > easy way to exercise them, like with packet sockets.
>
>
> Yes.
>
>
> >
> >>>> That's why I suggest to use something more
> >>>> generic like XDP from the start. Yes, GSO stuffs was disabled by
> >>>> virtio-net on XDP but it's not something that can not be fixed. If the
> >>>> GSO and s/g support can not be done in short time
> >>> An alternative interface does not address that we already have this
> >>> interface and it is already causing problems.
> >>
> >> What problems did you meant here?
> > The long list of syzkaller bugs that required fixes either directly in
> > virtio_net_hdr_to_skb or deeper in the stack, e.g.,
> >
> > 924a9bc362a5 net: check if protocol extracted by
> > virtio_net_hdr_set_proto is correct
> > 6dd912f82680 net: check untrusted gso_size at kernel entry
> > 9274124f023b net: stricter validation of untrusted gso packets
> > d2aa125d6290 net: Don't set transport offset to invalid value
> > d5be7f632bad net: validate untrusted gso packets without csum offload
> > 9d2f67e43b73 net/packet: fix packet drop as of virtio gso
> >
> > 7c68d1a6b4db net: qdisc_pkt_len_init() should be more robust
> > cb9f1b783850 ip: validate header length on virtual device xmit
> > 418e897e0716 gso: validate gso_type on ipip style tunnels
> > 121d57af308d gso: validate gso_type in GSO handlers
> >
> > This is not necessarily an exhaustive list.
> >
> > And others not directly due to gso/csum metadata, but malformed
> > packets from userspace nonetheless, such as
> >
> > 76c0ddd8c3a6 ip6_tunnel: be careful when accessing the inner header
>
>
> I see. So if I understand correctly, introducing SKB_GSO_DODGY is a
> balance between security and performance. That is to say, defer the
> gso/header check until just before they are used. But a lot of codes
> were not wrote under this assumption (forget to deal with dodgy packets)
> which breaks things.

DODGY and requiring robust kernel stack code is part of it, but

Making the core kernel stack robust against bad packets incurs cost on
every packet for the relatively rare case of these packets coming from
outside the stack. Ideally, this cost is incurred on such packets
alone. That's why I prefer validation at the source.

This patch series made it *optional* validation at the source to
address your concerns about performance regressions. I.e., if you know
that the path packets will take is robust, such as a simple bridging
case between VMs, it is perhaps fine to forgo the checks. But egress
over a physical NIC or even through the kernel egress path (or
loopback to ingress, which has a different set of expectations) has
higher integrity requirements.

Not all concerns are GSO, and thus captured by DODGY. Such as truncated hdrlen.

> So the problem is that, the NIC driver is wrote under the assumption
> that the gso metadata is correct. I remember there's a kernel CVE
> (divide by zero) because of the gso_size or other fields several years
> ago for a driver.

Right, and more: both NICs and the software stack itself have various
expectations on input. Such as whether protocol headers are in the
linear section, or that the csum offset is within bounds.

> > In the case where they are used along with some ABI through which data
> > can be inserted into the kernel,
>
>
> CPUMAP is something that the data can be inserted into the kernel.
>
>
> > such as AF_XDP, it is relevant. And I
> > agree that then the XDP program can do the validation directly.
> >
> > That just does not address validating of legacy interfaces. Those
> > interfaces generally require CAP_NET_RAW to setup, but they are often
> > used after setup to accept untrusted contents, so I don't think they
> > should be considered "root, so anything goes".
>
>
> I'm not sure I understand the meaning of "legacy" interface here.

the existing interfaces to insert packets from userspace:
tuntap/uml/pf_packet/..

>
>
> >
> >> Thanks
> > Thanks for the discussion. As said, we'll start by looking at the
> > other similar netfront interfaces.
>
>
> Thanks, I'm not objecting the goal, but I want to figure out whether
> it's the best to choice to do that via flow dissector.

Understood. My main question at this point is whether you are
suggesting a different bpf program type at the same hooks, or are
arguing that a XDP-based interface will make all this obsolete.
