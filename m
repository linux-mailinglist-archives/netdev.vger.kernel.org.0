Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68910365A94
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhDTNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhDTNu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 09:50:28 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08B8C06174A;
        Tue, 20 Apr 2021 06:49:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a12so25589446pfc.7;
        Tue, 20 Apr 2021 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIn2vPs/0fzr8nOclXG7ZQaFqgjNByGzMn1tBsyy5F0=;
        b=APMACkG0BjslUecn9rs9WAs5/mhX0+XnLX1Qd6+rdEbWcfEpY2FNx45JamNJz9pQ5g
         pnceFvf1Ed6dSRtq4YvO+yEn04Vo/2Y0w0pWL2M4+b2Zvk+5VuHaprlnweQ0Qy8srIqG
         awj4JSoHbB6uqLB0x9o6M7CZ83Me5jh1m30fv6j+dAoN03Lcr4sj5aufvPMPskt0SgxO
         /YD5HUGn5yhhjGtv/MtO2xu1K9dSogXIWc9MZsdyZUWCgd5yZRWZYcv2o4ljRrga1QIu
         94KUW90092igGVUU2/wxVpaKLB0CezJyUK8gbHTnE8LmUCC/PxdNKchf+QrqUiTTNL25
         9tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIn2vPs/0fzr8nOclXG7ZQaFqgjNByGzMn1tBsyy5F0=;
        b=mxmrBV1BmohvKKguvH4Xzrp10vh2KXntCCzVSLACfybVxPlyddeGA8btvG/oOLq+pA
         G40DG0Ju45tkP/NWa2rbd1OOI1uXGHXN4SDQIkiqP5MzBFqwJkZF+5z9xnkjzZ+46h6w
         hKpArcvLUH730wjNvxBvnZX/mIZAijLxNfPzeOT69pdaqjZQiogg+X4eShs3VvoG/g0u
         vb27Jix+1OwnT/OVT/I+qeslKmxE5TJREsCNA/Xk0wF9KiBl1X7GWbpjzd6ZClDj0Swr
         EUUovDb8cbAQfLJnpH1ShWO4Cwmp8j5tUW8JcylD/OGt7wDVUeVtB8TbXJwzwRLrhIym
         BEJQ==
X-Gm-Message-State: AOAM5331/4xzPzi23VRFiYEhaoReYyDkE3QiAoi0fu5xYQMSrK2J5MRH
        f69ieOCDUAzIDuB9HPRN9VogWYw6f5flMZlMX44=
X-Google-Smtp-Source: ABdhPJwzjD+NfvjQhNi/vKS7Rj8m7XzWmQli4PRiY1MKa/L5aRNK+HYclCdEeL4ZijTRYQpASMI4EEb8wVojJgE1Vls=
X-Received: by 2002:a63:5b07:: with SMTP id p7mr13074517pgb.208.1618926596066;
 Tue, 20 Apr 2021 06:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org> <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <20210418181801.17166935@carbon> <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
 <YH0pdXXsZ7IELBn3@lore-desk>
In-Reply-To: <YH0pdXXsZ7IELBn3@lore-desk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 20 Apr 2021 15:49:44 +0200
Message-ID: <CAJ8uoz101VZiwuvM-bs4UdW+kFT5xjgdgUwPWHZn4ABEOkyQ-w@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 8:56 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Sun, Apr 18, 2021 at 6:18 PM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > On Fri, 16 Apr 2021 16:27:18 +0200
> > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > >
> > > > On Thu, Apr 8, 2021 at 2:51 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > >
> > > > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > > > > please focus on how these new types of xdp_{buff,frame} packets
> > > > > traverse the different layers and the layout design. It is on purpose
> > > > > that BPF-helpers are kept simple, as we don't want to expose the
> > > > > internal layout to allow later changes.
> > > > >
> > > > > For now, to keep the design simple and to maintain performance, the XDP
> > > > > BPF-prog (still) only have access to the first-buffer. It is left for
> > > > > later (another patchset) to add payload access across multiple buffers.
> > > > > This patchset should still allow for these future extensions. The goal
> > > > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > > > same performance as before.
> > > [...]
> > > > >
> > > > > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
> > > > > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> > > > > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver (XDPmulti-buffers section)
> > > >
> > > > Took your patches for a test run with the AF_XDP sample xdpsock on an
> > > > i40e card and the throughput degradation is between 2 to 6% depending
> > > > on the setup and microbenchmark within xdpsock that is executed. And
> > > > this is without sending any multi frame packets. Just single frame
> > > > ones. Tirtha made changes to the i40e driver to support this new
> > > > interface so that is being included in the measurements.
> > >
> > > Could you please share Tirtha's i40e support patch with me?
> >
> > We will post them on the list as an RFC. Tirtha also added AF_XDP
> > multi-frame support on top of Lorenzo's patches so we will send that
> > one out as well. Will also rerun my experiments, properly document
> > them and send out just to be sure that I did not make any mistake.
>
> ack, very cool, thx

I have now run a new set of experiments on a Cascade Lake server at
2.1 GHz with turbo boost disabled. Two NICs: i40e and ice. The
baseline is commit 5c507329000e ("libbpf: Clarify flags in ringbuf
helpers") and Lorenzo's and Eelco's path set is their v8. First some
runs with xdpsock (i.e. AF_XDP) in both 2-core mode (app on one core
and the driver on another) and 1-core mode using busy_poll.

xdpsock rxdrop throughput change with the multi-buffer patches without
any driver changes:
1-core i40e: -0.5 to 0%   2-cores i40e: -0.5%
1-core ice: -2%   2-cores ice: -1 to -0.5%

xdp_rxq_info -a XDP_DROP
i40e: -4%   ice: +8%

xdp_rxq_info -a XDP_TX
i40e: -10%   ice: +9%

The XDP results with xdp_rxq_info are just weird! I reran them three
times, rebuilt and rebooted in between and I always get the same
results. And I also checked that I am running on the correct NUMA node
and so on. But I have a hard time believing them. Nearly +10% and -10%
difference. Too much in my book. Jesper, could you please run the same
and see what you get? The xdpsock numbers are more in the ballpark of
what I would expect.

Tirtha and I found some optimizations in the i40e
multi-frame/multi-buffer support that we have implemented. Will test
those next, post the results and share the code.

> >
> > Just note that I would really like for the multi-frame support to get
> > in. I have lost count on how many people that have asked for it to be
> > added to XDP and AF_XDP. So please check our implementation and
> > improve it so we can get the overhead down to where we want it to be.
>
> sure, I will do.
>
> Regards,
> Lorenzo
>
> >
> > Thanks: Magnus
> >
> > > I would like to reproduce these results in my testlab, in-order to
> > > figure out where the throughput degradation comes from.
> > >
> > > > What performance do you see with the mvneta card? How much are we
> > > > willing to pay for this feature when it is not being used or can we in
> > > > some way selectively turn it on only when needed?
> > >
> > > Well, as Daniel says performance wise we require close to /zero/
> > > additional overhead, especially as you state this happens when sending
> > > a single frame, which is a base case that we must not slowdown.
> > >
> > > --
> > > Best regards,
> > >   Jesper Dangaard Brouer
> > >   MSc.CS, Principal Kernel Engineer at Red Hat
> > >   LinkedIn: http://www.linkedin.com/in/brouer
> > >
> >
