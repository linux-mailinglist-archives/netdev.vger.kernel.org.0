Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EA634F50F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 01:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhC3XbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 19:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhC3Xaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 19:30:52 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991FEC061574;
        Tue, 30 Mar 2021 16:30:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id o10so26300228lfb.9;
        Tue, 30 Mar 2021 16:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q86N4Ipee4cOuOSoKuuXES9jQCxRaJsXucpi8+zhcjo=;
        b=UqW8IjHcBTTLNRmgHR+MOJeglKm86mIssPm6cD9TIaSfxP3tdkcHPSA806Ouu2l3tc
         aK72v0JGn69nOQ6cFT1F/P0SaKdi3DzhcGp+fnXUgh3NAjmm4Fw2OisCR35jFdw4IsvM
         NSLMRwQgjftceRcbzHQ097DzPQcqflhDjzn4FyGQvmFo/NwANywgUJX3iePCMajaIUSY
         yLJ02Zy+sUz6tfWxIpXE5wLe+Y0uBUjEXlJgys0wAe1WpiKmL/cGaS84XXlS/AmgPeMZ
         IzJbwbl9hBbmvS7aBw5FlCcAc/gGT3lyRq5+QC/Q+c3CpijTdUu709l1ter0u1Hr3eoQ
         MOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q86N4Ipee4cOuOSoKuuXES9jQCxRaJsXucpi8+zhcjo=;
        b=WD4kihME6ZvL76JIBxfqp2LiB89L+BGxsIRk1C73ewfncFKjbLgX3QSynQ0prnWlr7
         kCBAxq4Z75JXVfaI7B15gY2BHDQ+Nojx7QMZncF2otfnpLF2AE926sLGucO3904c3Su5
         1dD5POGZQeXcFsP6u4CiCY8DCf6F+L22XRGSudu0XNmgJrxSrDOs4+9azIC+M8xOhtdx
         qNG47zJDOVMTExUijWci+PKO7pfzRtb2Ie3DlHW4KJHJV/4TzSq0wvtTFkPnxphgPciG
         SfX8o3+po/mXZuzoDRbhbgNszGa32avZOKgg8oLHvvpG1O6vdYkoedPR1vCelR70NiHU
         Qc3Q==
X-Gm-Message-State: AOAM530APQTnlbhNfFAyXLO13uBrj8BpppzVKBlAPC8F+I03DUNFPUtB
        kKuokNPWUzVty8PqMeC2BDx7ir+MO7KwBjGCoS0=
X-Google-Smtp-Source: ABdhPJzuGLnokRH73+DxvFOn0VExwcrwyd+AtuMcBo0lp5eY4kzWi1KoObq9KSpq/56E0YGL53oRZ+KgmIGZnSnpG0o=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr382924lfq.214.1617147049905;
 Tue, 30 Mar 2021 16:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
In-Reply-To: <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 16:30:38 -0700
Message-ID: <CAADnVQ+xPH+i=Y44Vyr0ukU+3eHNZXYNW7s0JAJLUXtskYACng@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 2:26 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/30/21 10:39 PM, Andrii Nakryiko wrote:
> > On Sun, Mar 28, 2021 at 1:11 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> >> On Sun, Mar 28, 2021 at 10:12:40AM IST, Andrii Nakryiko wrote:
> >>> Is there some succinct but complete enough documentation/tutorial/etc
> >>> that I can reasonably read to understand kernel APIs provided by TC
> >>> (w.r.t. BPF, of course). I'm trying to wrap my head around this and
> >>> whether API makes sense or not. Please share links, if you have some.
> >>
> >> Hi Andrii,
> >>
> >> Unfortunately for the kernel API part, I couldn't find any when I was working
> >> on this. So I had to read the iproute2 tc code (tc_filter.c, f_bpf.c,
> >> m_action.c, m_bpf.c) and the kernel side bits (cls_api.c, cls_bpf.c, act_api.c,
> >> act_bpf.c) to grok anything I didn't understand. There's also similar code in
> >> libnl (lib/route/{act,cls}.c).
> >>
> >> Other than that, these resources were useful (perhaps you already went through
> >> some/all of them):
> >>
> >> https://docs.cilium.io/en/latest/bpf/#tc-traffic-control
> >> https://qmonnet.github.io/whirl-offload/2020/04/11/tc-bpf-direct-action/
> >> tc(8), and tc-bpf(8) man pages
> >>
> >> I hope this is helpful!
> >
> > Thanks! I'll take a look. Sorry, I'm a bit behind with all the stuff,
> > trying to catch up.
> >
> > I was just wondering if it would be more natural instead of having
> > _dev _block variants and having to specify __u32 ifindex, __u32
> > parent_id, __u32 protocol, to have some struct specifying TC
> > "destination"? Maybe not, but I thought I'd bring this up early. So
> > you'd have just bpf_tc_cls_attach(), and you'd so something like
> >
> > bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, parent_id, protocol))
> >
> > or
> >
> > bpf_tc_cls_attach(prog_fd, TC_BLOCK(block_idx, protocol))
> >
> > ? Or it's taking it too far?
> >
> > But even if not, I think detaching can be unified between _dev and
> > _block, can't it?
>
> Do we even need the _block variant? I would rather prefer to take the chance
> and make it as simple as possible, and only iff really needed extend with
> other APIs, for example:
>
>    bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS});
>
> Internally, this will create the sch_clsact qdisc & cls_bpf filter instance
> iff not present yet, and attach to a default prio 1 handle 1, and _always_ in
> direct-action mode. This is /as simple as it gets/ and we don't need to bother
> users with more complex tc/cls_bpf internals unless desired. For example,
> extended APIs could add prio/parent so that multi-prog can be attached to a
> single cls_bpf instance, but even that could be a second step, imho.

+1 to support sched_cls in direct-action mode only.
