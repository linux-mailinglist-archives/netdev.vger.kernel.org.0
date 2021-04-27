Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D132E36C98A
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbhD0Qg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbhD0Qg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:36:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146C9C061574;
        Tue, 27 Apr 2021 09:36:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m12so1996116pgr.9;
        Tue, 27 Apr 2021 09:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=us1QLHyOThwNs0pNjX5cl0xbAyePJaqilbCwLaL8F1Y=;
        b=fkWyAL4zagqdwoKwqRhhkGnTqKyggI0Hk1bAX20wLavFf+Zvx9S0faDaCNNIUJ5yQJ
         IV4HY4fzhrJ9t4TQoSVwE9jy744N6iEuddGgkFSxcEj+bLUEMRVXDQS0knxrcgPRqqy2
         WICwFAdLe67xxagJ0z5XuKYeHv+LIPF3O5ThW5XO1YI3OeThCgRQvO701OZTMjSnwi6S
         p1VMG/yzZ1Gtwy3aibwXlA9iWdANG2+/T7LcNIODQZUXwNyyainUUlKxsCfMfFBzwOat
         uUJbjWGzm+fvJftIR6fK3I1UoRf95bIC8CnSA2gs88uNR75wC5+n/jEcgTX5EZzWRCPB
         GAwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=us1QLHyOThwNs0pNjX5cl0xbAyePJaqilbCwLaL8F1Y=;
        b=mZ3OTYmqRqcJnA9VSMXFE15YdVoNHcuKM7HklWu1PLXykhPmLLJm+K6wZzV6ZQOJaq
         aiO97SFWZPHH/847yYgncjdL7t4TkXwb7Llt/B8CK6SFLNOzL+PKCMXfISczgA5nn5xV
         2O4bMkC7ySX2LQkp4fUi2kvIhwfG1XedrAOho28rtyCkgiSWBs+KEoDJZKyTRlD6ezjS
         S3SPP6sx/d+H3UJDj2Q08V/va9/Gp/IxrnaxUg8bpc2C2SgepyJRyXKAxptKRy2GEPn6
         IyXAPsZZwj0xlnzkt8TysBNdhYkcbgRB0IYFVR4kMYUWAvS95CEIrZfxwLc3j9WVO2nW
         RclA==
X-Gm-Message-State: AOAM533uVk6qfVauikLFoPon6cPzZ0fM4qV8ybz5ljKeoirEvAVlPdAw
        cnXcSJHjHZT864kqLZNoH7IkRwXJs7PieE1iUkg=
X-Google-Smtp-Source: ABdhPJx9XrAQdBqPEXWKDggQXZe97bCF2PhliyF7OCARspzbNmPyMI1BCL7F1w5uJG+ckg4athdnqdvFcOEdyzDbNKs=
X-Received: by 2002:a63:6a41:: with SMTP id f62mr22033540pgc.428.1619541372560;
 Tue, 27 Apr 2021 09:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com> <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Apr 2021 09:36:01 -0700
Message-ID: <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 7:02 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 04:37:19PM -0700, Cong Wang wrote:
> > On Mon, Apr 26, 2021 at 4:05 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Apr 26, 2021 at 4:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > Hi, Alexei
> > > >
> > > > On Wed, Apr 14, 2021 at 9:25 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Wed, Apr 14, 2021 at 9:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >
> > > > > > Then how do you prevent prog being unloaded when the timer callback
> > > > > > is still active?
> > > > >
> > > > > As I said earlier:
> > > > > "
> > > > > If prog refers such hmap as above during prog free the kernel does
> > > > > for_each_map_elem {if (elem->opaque) del_timer().}
> > > > > "
> > > >
> > > > I have discussed this with my colleagues, sharing timers among different
> > > > eBPF programs is a must-have feature for conntrack.
> > > >
> > > > For conntrack, we need to attach two eBPF programs, one on egress and
> > > > one on ingress. They share a conntrack table (an eBPF map), and no matter
> > > > we use a per-map or per-entry timer, updating the timer(s) could happen
> > > > on both sides, hence timers must be shared for both.
> > > >
> > > > So, your proposal we discussed does not work well for this scenario.
> > >
> > > why? The timer inside the map element will be shared just fine.
> > > Just like different progs can see the same map value.
> >
> > Hmm? In the above quotes from you, you suggested removing all the
> > timers installed by one eBPF program when it is freed, but they could be
> > still running independent of which program installs them.
>
> Right. That was before the office hours chat where we discussed an approach
> to remove timers installed by this particular prog only.
> The timers armed by other progs in the same map would be preserved.
>
> > In other words, timers are independent of other eBPF programs, so
> > they should not have an owner. With your proposal, the owner of a timer
> > is the program which contains the subprog (or callback) of the timer.
>
> right. so?
> How is this anything to do with "sharing timers among different eBPF programs"?

It matters a lot which program installs hence removes these timers,
because conceptually each connection inside a conntrack table does not
belong to any program, so are the timers associated with these
connections.

If we enforce this ownership, in case of conntrack the owner would be
the program which sees the connection first, which is pretty much
unpredictable. For example, if the ingress program sees a connection
first, it installs a timer for this connection, but the traffic is
bidirectional,
hence egress program needs this connection and its timer too, we
should not remove this timer when the ingress program is freed.

From another point of view: maps and programs are both first-class
resources in eBPF, a timer is stored in a map and associated with a
program, so it is naturally a first-class resource too.

>
> > >
> > > Also if your colleagues have something to share they should be
> > > posting to the mailing list. Right now you're acting as a broken phone
> > > passing info back and forth and the knowledge gets lost.
> > > Please ask your colleagues to participate online.
> >
> > They are already in CC from the very beginning. And our use case is
> > public, it is Cilium conntrack:
> > https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack.h
> >
> > The entries of the code are:
> > https://github.com/cilium/cilium/blob/master/bpf/bpf_lxc.c
> >
> > The maps for conntrack are:
> > https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack_map.h
>
> If that's the only goal then kernel timers are not needed.
> cilium conntrack works well as-is.

We don't go back to why user-space cleanup is inefficient again,
do we? ;)

More importantly, although conntrack is our use case, we don't
design timers just for our case, obviously. Timers must be as flexible
to use as possible, to allow other future use cases.

Thanks.
