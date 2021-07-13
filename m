Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142513C7A53
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 01:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhGMXzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 19:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhGMXzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 19:55:00 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842FBC0613DD;
        Tue, 13 Jul 2021 16:52:08 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u13so267687lfs.11;
        Tue, 13 Jul 2021 16:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ejIPe0hRiuqiMzFNCQVfxfEsFRf0m265B2btb22fMW8=;
        b=qSqIFbZvRHMKVXEFeXmPOvcAHx6RxgfSWGV6Q0Ow/HwefSd4st3/qWjU1I+GghUeie
         bagVY8Ss+ITdYJCgvOUW+1C9moelNOmBg+veet64ArlZbB3rKjBcmrfRqdTJo5iWErrj
         mjvkslrZEw9RyPPMqk88eMmrKZL3gXzUAgKPkWPU7XVtRh7wDsPhAcObsowwjK97RvQF
         sxtyplnRnafJEWXo6f9MKzTzhpMG4j4Otg7x5xQWjBVnu4SWw+ZM9cVMZkRMEN13z86H
         FRAU67qSh/Jp7sDnjaRMZ47OkMvhiowG/EnHHnpT4FdWazbInaDtvV0sU6wDOTVW8d5M
         1a6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejIPe0hRiuqiMzFNCQVfxfEsFRf0m265B2btb22fMW8=;
        b=N0xcFFEEsSKSsXO8GxdbQ+tOwe0ABjUTgidAbjxShfkjOB92J/9AhPL3vA89AmYKH+
         DSxviVRdc/A+V+WkDK9W42yJN7Eiy7sLPMvo1xwYnRBn2uaNr4Ts5yXLfFOIz2HUDSQu
         KyYALNRUBFquktHw38i3gB2mViNXQ5xp+bnmIDHqWPDPD/Msy6y1BzyLhZ522LEpivQp
         jT8QNY03vDXY14D1K5ne1OshlO73uGI3s9x/vaStIJh3YybxAoH0atdXTPVjMUjlTtTn
         f7VYXiZ1ovpoKVtNq6xNbBlkDSPX+giEKXv9m37uPaFwv7n1FQb3XuMLhAQ/48BHzv97
         jIMg==
X-Gm-Message-State: AOAM5314Igv9USIxZlJBHtfwNcULW2U45dP7WFCJ9VzOayMZQq2N4QM+
        1Jdk8IIeDvTbzohhVPWi5QHH9lJ702CT150TcAI=
X-Google-Smtp-Source: ABdhPJxgSIRIr5ETuhoyEFWDLTCc8uzN9+wVMathNyr3XqCcDm3vjr9XxFDmH3VWo9SmHMij6no1coIB4LFNgxlPhxs=
X-Received: by 2002:a05:6512:3709:: with SMTP id z9mr5269002lfr.182.1626220326861;
 Tue, 13 Jul 2021 16:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR11MB4173595C36B9876CBF2CCFA1A6189@MN2PR11MB4173.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB4173595C36B9876CBF2CCFA1A6189@MN2PR11MB4173.namprd11.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Jul 2021 16:51:55 -0700
Message-ID: <CAADnVQJ9M6ip6uYb9ky=eH-Z1BO-cTeGOpYs0M3EZrgURWpNcQ@mail.gmail.com>
Subject: Re: How to limit TCP packet lengths given to TC egress EBPF programs?
To:     "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>,
        bpf <bpf@vger.kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Lapukhov <petr@fb.com>,
        Sandesh Dhawaskar Sathyanarayana 
        <Sandesh.DhawaskarSathyanarayana@colorado.edu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 11:40 AM Fingerhut, John Andy
<john.andy.fingerhut@intel.com> wrote:
>
> Greetings:
>
> I am working on a project that runs an EBPF program on the Linux
> Traffic Control egress hook, which modifies selected packets to add
> headers to them that we use for some network telemetry.
>
> I know that this is _not_ what one wants to do to get maximum TCP
> performance, but at least for development purposes I was hoping to
> find a way to limit the length of all TCP packets that are processed
> by this EBPF program to be at most one MTU.
>
> Towards that goal, we have tried several things, but regardless of
> which subset of the following things we have tried, there are some
> packets processed by our EBPF program that have IPv4 Total Length
> field that is some multiple of the MSS size, sometimes nearly 64
> KBytes.  If it makes a difference in configuration options available,
> we have primarily been testing with Ubuntu 20.04 Linux running the
> Linux kernel versions near 5.8.0-50-generic distributed by Canonical.
>
> Disable TSO and GSO on the network interface:
>
>     ethtool -K enp0s8 tso off gso off
>
> Configuring TCP MSS using 'ip route' command:
>
>     ip route change 10.0.3.0/24 dev enp0s8 advmss 1424
>
> The last command _does_ have some effect, in that many packets
> processed by our EBPF program have a length affected by that advmss
> value, but we still see many packets that are about twice as large,
> about three times as large, etc., which fit into that MSS after being
> segmented, I believe in the kernel GSO code.
>
> Is there some other configuration option we can change that can
> guarantee that when a TCP packet is given to a TC egress EBPF program,
> it will always be at most a specified length?
>
>
> Background:
>
> Intel is developing and releasing some open source EBPF programs and
> associated user space programs that modify packets to add INT (Inband
> Network Telemetry) headers, which can be used for some kinds of
> performance debugging reasons, e.g. triggering events when packet
> losses are detected, or significant changes in one-way packet latency
> between two hosts configured to run this Host INT code.  See the
> project home page for more details if you are interested:
>
> https://github.com/intel/host-int

I suspect MTU/MSS issue is only the tip of the iceberg.

https://github.com/intel/host-int/blob/main/docs/Host_INT_fmt.md
That's an interesting design !
Few things should be probably be addressed sooner than later:
"Host INT currently only supports adding INT headers to IPv4 packets."
To consider such a feature of Tofino switches IPv6 has to be supported.
That shouldn't be hard to do, right?

https://github.com/intel/host-int/blob/main/docs/host-int-project.pptx
That's a lot of bpf programs :)
Looks like in the bridge case (last slide) every incoming packet will
be processed
by two XDP programs.
XDP is certainly fast, but it still adds overhead.
Not every packet will have such INT header so most of the packets will be
passing through XDP prog into the stack or from stack through TC egress program.
Such XDP ingress and TC egress progs will add overhead that might be
unacceptable in production deployment.
Have you considered using the new TCP header option instead?
https://lore.kernel.org/bpf/CAADnVQJ21Tt2HaJ5P4wbxBLVo1YT-PwN3bOHBQK+17reK5HxOg@mail.gmail.com/
BPF prog can conditionally add it for few packets/flows and another BPF prog
on receive side will process such header option.
While Tofino switch will find packets with a special TCP header and fill them in
with telemetry data.
"INT report packets are sent as UDP datagrams" part of the design can stay.
Looks like you're reserving a UDP port for such a purpose, so no need
for the receive side to have an XDP program to process every packet.

With TCP header option approach the MTU issue will go away as well.

> Note: The code published now is an alpha release.  We know there are
> bugs.  We know our development team is not what you would call EBPF
> experts (at least not yet), so feel free to point out bugs and/or
> anything that code is doing that might be a bad idea.

Thank you for reaching out. We're here to help with your BPF/XDP needs :)

> Thanks,
> Andy Fingerhut
> Principal Engineer
> Intel Corporation
