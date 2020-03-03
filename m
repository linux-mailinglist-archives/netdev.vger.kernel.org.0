Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5245A17834F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgCCTqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:46:31 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40723 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgCCTqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:46:31 -0500
Received: by mail-qk1-f194.google.com with SMTP id m2so4662560qka.7;
        Tue, 03 Mar 2020 11:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZdVY5Vckwr7WNxbsOe52epD+cDMz63xJAo3yI7inyJM=;
        b=iJn3TJwHsAmEvz6HqkRIDmZ0VnoLOxm6GlZx+9Ks+bKmAjwm1pzObdMzcoE/oET1RX
         lRMdT2YKAGOUZMuh8cRvtCOgDvJ+q3Te78DIHCLuWBXAHlFJ55EP+GQAqDaCvN0UFgfg
         9/cM+eUTrE/AhXD93M9jy6vXlfvZxiT1GpfFt2fUvJcBPexe3PdntAgUaVsbhAHi8Tji
         X8lz47yXsqtJ3p+XnxRhkyVtDJfEYMGLpNiOKKXT+TU6ze8Kgjn6w0kERenbyhx5ADF7
         yeVK1Y/9E13uRp5pUzfoGZe//sXB/owMLVVTD7q93fbBo3x0B5rN0aWnz8xenjb6G5sJ
         QQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZdVY5Vckwr7WNxbsOe52epD+cDMz63xJAo3yI7inyJM=;
        b=fG/l7PhIUJhvYhT1LQvgSTibYtxdHT5vdhMIzX8bzVg9Pgz30wBKeMsyY87H+ARUn+
         VllXchR4FeaDiK2HmYAi6xMjK6JQJ7dmAD6lmshBnl4K3qW3r6Q2dBSQm2qyqZ4AU7HA
         9vrYAsecscJp6dXFGRUr1OeVnQZAM2xefQfab0K0SbxerZ4FzTce0//b71hnlA7BsFLJ
         SYJPY2tOj1SR00dMReeaaAHVnSnsRq5k+3ZNPS/Huxx0ZN7hoeuywtSYkSMlSUAIiW90
         xbGHuI1fyZ521PZqy/ppWsFFANnITAQYZ1H2XK8QO25o3w3rEumUNe6iYb1YUDLjk3jv
         9UVQ==
X-Gm-Message-State: ANhLgQ1uQdx9VQa1eklzJgpZWmjJ0XBjqcYr2r43B89JzrASyiYSOno4
        peYqHupR9agSYQKxzy5tbVHdcR/bRHkygBOtUY8=
X-Google-Smtp-Source: ADFU+vufi8sRlxBM5SgKNarNEmDmyDo6wPmNqMD5yWM4k0Gpd8Us2rVXYvqyNLD0enSayqRxN80fjhVicsM6MO3TvSo=
X-Received: by 2002:a37:6716:: with SMTP id b22mr5832284qkc.437.1583264790196;
 Tue, 03 Mar 2020 11:46:30 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk> <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com> <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
In-Reply-To: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Mar 2020 11:46:18 -0800
Message-ID: <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 11:23 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/3/20 4:46 PM, Alexei Starovoitov wrote:
> > On 3/3/20 12:12 AM, Daniel Borkmann wrote:
> >>
> >> I can see the motivation for this abstraction in particular for tracing, but given
> >> the goal of bpf_link is to formalize and make the various program attachment types
> >> more uniform, how is this going to solve e.g. the tc/BPF case? There is no guarantee
> >> that while you create a link with the prog attached to cls_bpf that someone else is
> >> going to replace that qdisc underneath you, and hence you end up with the same case
> >> as if you would have only pinned the program itself (and not a link). So bpf_link
> >> then gives a wrong impression that something is still attached and active while it
> >> is not. What is the plan for these types?
> >
> > TC is not easy to handle, right, but I don't see a 'wrong impression' part. The link will keep the program attached to qdisc. The admin
> > may try to remove qdisc for netdev, but that's a separate issue.
> > Same thing with xdp. The link will keep xdp program attached,
> > but admin may do ifconfig down and no packets will be flowing.
> > Similar with cgroups. The link will keep prog attached to a cgroup,
> > but admin can still do rmdir and cgroup will be in 'dying' state.
> > In case of tracing there is no intermediate entity between programs
> > and the kernel. In case of networking there are layers.
> > Netdevs, qdiscs, etc. May be dev_hold is a way to go.
>
> Yep, right. I mean taking tracing use-case aside, in Cilium we attach to XDP, tc,
> cgroups BPF and whatnot, and we can tear down the Cilium user space agent just
> fine while packets keep flowing through the BPF progs, and a later restart will
> just reattach them atomically, e.g. Cilium version upgrades are usually done this
> way.

Right. This is the case where you want attached BPF program to survive
control application process exiting. Which is not a safe default,
though, because it might lead to BPF program running without anyone
knowing, leading to really bad consequences. It's especially important
for applications that are deployed fleet-wide and that don't "control"
hosts they are deployed to. If such application crashes and no one
notices and does anything about that, BPF program will keep running
draining resources or even just, say, dropping packets. We at FB had
outages due to such permanent BPF attachment semantics. With FD-based
bpf_link we are getting a framework, which allows safe,
auto-detachable behavior by default, unless application explicitly
opts in w/ bpf_link__pin().

>
> This decoupling works since the attach point is already holding the reference on
> the program, and if needed user space can always retrieve what has been attached
> there. So the surrounding object acts like the "bpf_link" already. I think we need
> to figure out what semantics an actual bpf_link should have there. Given an admin
> can change qdisc/netdev/etc underneath us, and hence cause implicit detachment, I
> don't know whether it would make much sense to keep surrounding objects like filter,
> qdisc or even netdev alive to work around it since there's a whole dependency chain,
> like in case of filter instance, it would be kept alive, but surrounding qdisc may
> be dropped.

I don't have specific enough knowledge right now to answer tc/BPF
question, but it seems like attached BPF program should hold a
reference to whatever it's attached to (net_device or whatnot) and not
let it just disappear? E.g., for cgroups, cgroup will go into dying
state, but it still will be there as long as there are remaining BPF
programs attached, sockets open, etc. I think it should be a general
approach, but again, I don't know specifics of each "attach point".

>
> Question is, if there are no good semantics and benefits over what can be done
> today with existing infra (abstracted from user space via libbpf) for the remaining
> program types, perhaps it makes sense to have the pinning tracing specific only
> instead of generic abstraction which only ever works for a limited number?

See above, I think bpf_link is what allows to have both
auto-detachment by default, as well as allow long-lived BPF
attachments (with explicit opt int).

As for what bpf_link can provide on top of existing stuff. One thing
that becomes more apparent with recent XDP discussions and what was
solved in cgroup-specific way for cgroup BPFs, is that there is a need
to swap BPF programs without interruption (BPF_F_REPLACE behavior for
cgroup BPF). Similar semantics is desirable for XDP, it seems. That's
where bpf_link is useful. Once bpf_link is attached (for specificity,
let's say XDP program to some ifindex), it cannot be replaced with
other bpf_link. Attached bpf_link will need to be detached first (by
means of closing all open FDs) to it. This ensures no-one can
accidentally replace XDP dispatcher program.

Now, once you have bpf_link attached, there will be bpf_link operation
(e.g., BPF_LINK_SWAP or something like that), where underlying BPF
program, associated with bpf_link, will get replaced with a new BPF
program without an interruption. Optionally, we can provide
expected_bpf_program_fd to make sure we are replacing the right
program (for cases where could be few bpf_link owners trying to modify
bpf_link, like in libxdp case). So in that sense bpf_link is a
coordination point, which mediates access to BPF hook (resource).

Thoughts?


>
> Thanks,
> Daniel
