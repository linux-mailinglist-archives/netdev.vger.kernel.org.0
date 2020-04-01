Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8305E19A36A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 04:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbgDACEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 22:04:12 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37850 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731523AbgDACEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 22:04:11 -0400
Received: by mail-pj1-f66.google.com with SMTP id o12so1964832pjs.2;
        Tue, 31 Mar 2020 19:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WhCPcLY1rAViKV/dy1knl/iE5cI19cpJ+TW7cjgwBFU=;
        b=f3hHqrHkT+0rKtsASgAs9vZU//INPQpPtatFAubznDRcIXrCtDyYnV3W7un/vvlLxI
         aLxYTrpVlE34Kq4wjmagobEXn8YMMJ4ZQqRJe4u6p9ljivO49vrukhvgJymc45CPVrj4
         RhxJaVDemPLEHZJmeAtwRpSkpTriYSdjfiFEIc9TdNHuVX7tMzWVHyZtMuyP8nu8RTZo
         +ygQt7yTUgc+wSQBlkKkUYTu5xXB0yGmXyvPiAMb7We7yZFjNrrUa0+WHnW8mkKnKjkI
         M71eBmsadsA5lS49GJq8pUIX+8q9Lt/sqd53i9Vgl6ii3NQIg9+kiozw8SRLN2pUw7bE
         MYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WhCPcLY1rAViKV/dy1knl/iE5cI19cpJ+TW7cjgwBFU=;
        b=ThVoq4W+/RlGSbsadMiC3NOMCujj4QlJwuAx3fc2aMV8c3w+QRWJgDXOFyi8aa/G+D
         KFn4U5G4Kr66TMbodsDxbl7dFOyBdWYXHMdvASCvVFXfGpMayubvYWm9XJ5exc8bw7uG
         qa6H6I4b6f1M1ac6PkptkJ6j9IY5RHTsW5CPyfskFxJq9vSWFJmxMWAhkFyZk13BoWIK
         1EHCDh9ffODzWJ92xr5MPSWlMyfZNOTNcO1PZpby+5cHJsF4c1kVQC2RHW2ZGVmdCbSm
         w4ujOcHoXkdIzbs4kN9PzL7X/WXJT7fHNYfChPsATYPoVChK5MrIjcMbnUejap4u/bBe
         ha7w==
X-Gm-Message-State: AGi0PuaHqpl49X1OrLOg7KZnpWzXht/jaI08eQDV25cF9+U3U3ScukMJ
        +H/geYtLyjFwGQZ4jX3JXTs=
X-Google-Smtp-Source: APiQypI2juvv5B9Pf0eLVqMK3WJWOI6NUZVX0Aj4EGRA6qtAXTpgrEVw2dUacaw8Hw9jM7auBiQInA==
X-Received: by 2002:a17:90a:9284:: with SMTP id n4mr2025663pjo.196.1585706648231;
        Tue, 31 Mar 2020 19:04:08 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:ebdd])
        by smtp.gmail.com with ESMTPSA id o15sm308091pjp.41.2020.03.31.19.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 19:04:07 -0700 (PDT)
Date:   Tue, 31 Mar 2020 19:04:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
Message-ID: <20200401020404.wbad24dxkv7qr2os@ast-mbp>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
 <20200331011753.qxo3pq6ldqm43bo7@ast-mbp>
 <95bfd8e0-86b3-cb87-9f06-68a7c1ba7d7a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95bfd8e0-86b3-cb87-9f06-68a7c1ba7d7a@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 07:42:46PM -0600, David Ahern wrote:
> On 3/30/20 7:17 PM, Alexei Starovoitov wrote:
> > On Mon, Mar 30, 2020 at 06:57:44PM -0600, David Ahern wrote:
> >> On 3/30/20 6:32 PM, Alexei Starovoitov wrote:
> >>>>
> >>>> This is not a large feature, and there is no reason for CREATE/UPDATE -
> >>>> a mere 4 patch set - to go in without something as essential as the
> >>>> QUERY for observability.
> >>>
> >>> As I said 'bpftool cgroup' covers it. Observability is not reduced in any way.
> >>
> >> You want a feature where a process can prevent another from installing a
> >> program on a cgroup. How do I learn which process is holding the
> >> bpf_link reference and preventing me from installing a program? Unless I
> >> have missed some recent change that is not currently covered by bpftool
> >> cgroup, and there is no way reading kernel code will tell me.
> > 
> > No. That's not the case at all. You misunderstood the concept.
> 
> I don't think so ...
> 
> > 
> >> That is my point. You are restricting what root can do and people will
> >> not want to resort to killing random processes trying to find the one
> >> holding a reference. 
> > 
> > Not true either.
> > bpf_link = old attach with allow_multi (but with extra safety for owner)
> 
> cgroup programs existed for roughly 1 year before BPF_F_ALLOW_MULTI.
> That's a year for tools like 'ip vrf exec' to exist and be relied on.
> 'ip vrf exec' does not use MULTI.
> 
> I have not done a deep dive on systemd code, but on ubuntu 18.04 system:
> 
> $ sudo ~/bin/bpftool cgroup tree
> CgroupPath
> ID       AttachType      AttachFlags     Name
> /sys/fs/cgroup/unified/system.slice/systemd-udevd.service
>     5        ingress
>     4        egress
> /sys/fs/cgroup/unified/system.slice/systemd-journald.service
>     3        ingress
>     2        egress
> /sys/fs/cgroup/unified/system.slice/systemd-logind.service
>     7        ingress
>     6        egress
> 
> suggests that multi is not common with systemd either at some point in
> its path, so 'ip vrf exec' is not alone in not using the flag. There
> most likely are many other tools.

Please take a look at systemd source code:
src/core/bpf-devices.c
src/core/bpf-firewall.c
It prefers to use BPF_F_ALLOW_MULTI when possible.
Since it's the most sensible flag.
Since 'ip vrf exec' is not using allow_multi it's breaking several systemd features.
(regardless of what bpf_link can and cannot do)

> > The only thing bpf_link protects is the owner of the link from other
> > processes of nuking that link.
> > It does _not_ prevent other processes attaching their own cgroup-bpf progs
> > either via old interface or via bpf_link.
> > 
> 
> It does when that older code does not use the MULTI flag. There is a
> history that is going to create conflicts and being able to id which
> program holds the bpf_link is essential.
> 
> And this is really just one use case. There are many other reasons for
> wanting to know what process is holding a reference to something.

I'm not disagreeing that it's useful to query what is attached where. My point
once again that bpf_link for cgroup didn't change a single bit in this logic.
There are processes (like systemd) that are using allow_multi. When they switch
to use bpf_link few years from now nothing will change for all other processes
in the system. Only systemd will be assured that their bpf-device prog will not
be accidentally removed by 'ip vrf'. Currently nothing protects systemd's bpf
progs. Any cap_net_admin process can _accidentally_ nuke it. It's even more
weird that bpf-cgroup-device that systemd is using is under cap_net_admin.
There is nothing networking about it. But that's a separate discussion.

May be you should fix 'ip vrf' first before systemd folks start yelling and
then we can continue arguing about merits of observability?
