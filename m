Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36B136CB26
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbhD0Se6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhD0Se6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 14:34:58 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261A3C061574;
        Tue, 27 Apr 2021 11:34:13 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z13so14183953lft.1;
        Tue, 27 Apr 2021 11:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z80CSEVjLPr29NMlgVZymyRLAugdtrDYEGxKSKN9yD0=;
        b=tohiOZW/Oy6Qbfo8fLHFQ7fTCY4O+o335heJAUMfO//hh8pgIOuV8OWv0nhLIMSPPP
         +aCZt0tuaoudstmNc3vqBBfEiBwRcWHW/DQ+zKDJ9124whV2al/jXK41+WNi5mpCELU0
         NIgsvrv+HPJaWUsRRYHCDzEFwpatWF44CXZpKM70hzObhcEcAE4B+gwKLxsA0eJB23ku
         23zJcJX53jGROKo3WfTKBHRJ0VD0MpO9T9D6GgZ78sxl6tLJ6Ek4AXudmHYx0wUy1rh1
         AkmcjVM04TXu+5Mccum4W02oBEQWjmxkLZVoHqRDe3xtgVmQBY8uI5XPbgsThfBrSbcW
         w8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z80CSEVjLPr29NMlgVZymyRLAugdtrDYEGxKSKN9yD0=;
        b=Pt5he1UREBl4X0gQvMWJ2I401VSaTBlgoOgmZpxSOfkUsbU2F9C2vtOpS8hlUrKBzy
         ZaY/7ZPkoJCXa4X6jGNwiQSK80FkgGW4WNr6JHe260Koc6Arhfk3hZW8kIPyRxAQAuaT
         TU5GCohHK0vfQ2QxGR6nLXYhahOqwIrMIa7cwCSSC95Y2Uw3oTSznUe+3sZVQXuBZTrr
         mcG85cSQbS9Q3++unGMYBpxqSzc2OqAQKNfvlxpXON8bRervWcki+dbvoG2Z13iwl3AS
         w1AYmwkVWCK7NCS3SDRtsFj0kk2logEvBfoHC9XCXeNsrIRO8m8q7WXF3fgYsb/qPRXr
         s4AA==
X-Gm-Message-State: AOAM530WamQc4HnTpzRAQKlNz0WpeqUdXARsnzqEIeQv2e3OtwDOxi5V
        GSVxIkS2YIJr1VG4RoCtXZ92bFFgW07jTKSaORY=
X-Google-Smtp-Source: ABdhPJxNVV2s3FHip7J0ujedmFbfIf3VNt0+wzG3eQcNQvW2LGchg3XAQFwBXWEnwPVLTtWWfdiwIHJEBDYdYFViQ+A=
X-Received: by 2002:ac2:491a:: with SMTP id n26mr18455535lfi.539.1619548451567;
 Tue, 27 Apr 2021 11:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com> <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
In-Reply-To: <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 27 Apr 2021 11:33:59 -0700
Message-ID: <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
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

On Tue, Apr 27, 2021 at 9:36 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> If we enforce this ownership, in case of conntrack the owner would be
> the program which sees the connection first, which is pretty much
> unpredictable. For example, if the ingress program sees a connection
> first, it installs a timer for this connection, but the traffic is
> bidirectional,
> hence egress program needs this connection and its timer too, we
> should not remove this timer when the ingress program is freed.

Sure. That's trivially achieved with pinning.
One can have an ingress prog that tailcalls into another prog
that arms the timer with one of its subprogs.
Egress prog can tailcall into the same prog as well.
The ingress and egress progs can be replaced one by one
or removed both together and middle prog can stay alive
if it's pinned in bpffs or held alive by FD.

> From another point of view: maps and programs are both first-class
> resources in eBPF, a timer is stored in a map and associated with a
> program, so it is naturally a first-class resource too.

Not really. The timer abstraction is about data. It invokes the callback.
That callback is a part of the program. The lifetime of the timer object
and lifetime of the callback can be different.
Obviously the timer logic need to make sure that callback text is alive
when the timer is armed.
Combining timer and callback concepts creates a messy abstraction.
In the normal kernel code one can have a timer in any kernel data
structure and callback in the kernel text or in the kernel module.
The code needs to make sure that the module won't go away while
the timer is armed. Same thing with bpf progs. The progs are safe
kernel modules. The timers are independent objects.

> >
> > > >
> > > > Also if your colleagues have something to share they should be
> > > > posting to the mailing list. Right now you're acting as a broken phone
> > > > passing info back and forth and the knowledge gets lost.
> > > > Please ask your colleagues to participate online.
> > >
> > > They are already in CC from the very beginning. And our use case is
> > > public, it is Cilium conntrack:
> > > https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack.h
> > >
> > > The entries of the code are:
> > > https://github.com/cilium/cilium/blob/master/bpf/bpf_lxc.c
> > >
> > > The maps for conntrack are:
> > > https://github.com/cilium/cilium/blob/master/bpf/lib/conntrack_map.h
> >
> > If that's the only goal then kernel timers are not needed.
> > cilium conntrack works well as-is.
>
> We don't go back to why user-space cleanup is inefficient again,
> do we? ;)

I remain unconvinced that cilium conntrack _needs_ timer apis.
It works fine in production and I don't hear any complaints
from cilium users. So 'user space cleanup inefficiencies' is
very subjective and cannot be the reason to add timer apis.

> More importantly, although conntrack is our use case, we don't
> design timers just for our case, obviously. Timers must be as flexible
> to use as possible, to allow other future use cases.

Right. That's why I'm asking for an explanation of a specific use case.
"we want to do cilium conntrack but differently" is not a reason.
