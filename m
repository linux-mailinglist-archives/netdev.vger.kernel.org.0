Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BF3379EFA
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 07:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhEKFHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 01:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhEKFHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 01:07:23 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1741C06175F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 22:06:16 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id t20so9491118qtx.8
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 22:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lNONBfM9DvnwbpKJFTuj1RNSLW5/OK2eghETZOp56NY=;
        b=bzYt6X+0sbzhk8VKKB6Tdf9MFO/wndyHNbq6g8Hs65j0M96XfS5+4UqKlH2jGOGOiz
         qZEuQLOkjJ8wADD+flDlpR//ioqbQAnVLOwHr++QV3LTMZ4hVLqftoORSl42ZriTdLU6
         cFe7DbULckXk+Y21aLWuuNsDDSjP0r2nBG+a5HpM4sud8NfZwi9Yez35Hj3nB5JDKM0b
         WpVMntdPKYgsNsmW3LUwthbvj6INK5ejhMdFZgU7ekSy4LVdcve3NbOzw/SlSYmF74zr
         h2JDdWv4I9nWtwiwKhh1qJ6Bgny6qCld6Mn/ykp1Ax95a00TD8WrNh2uK2ueEZWdyrk0
         TIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNONBfM9DvnwbpKJFTuj1RNSLW5/OK2eghETZOp56NY=;
        b=Lpq3m0SkCM7goOoM9Tp7Zjk09n7PzrBVp2Ck1r8hojHBJOOJZ4Ofwjp/rvkZ+VQUvr
         CXUNAW2yDQqEueogvi9OpL/YWUfYg4+RG2Dx2COkt5id2yWlEgYrw+Q28F+eTyNDlH2l
         KKgWMLSNa/ASf2HCTle/WpMh0mLZbSOSLNqjpYmGuvHgqM6M5yeyj6jxRBM091DAWy2r
         wr115jKB9jk1WxVhIeROHMJzJNRglhR0jAvq3WkdZmb7DaLq7emS6lbHHjSCXyGDqLPr
         Ir4lMw8xc7PGmBUeQedLdyL1dVRuyoBEoYraMmgh7Cb+haHhMlLt/08ze8WcdgoN2Zlh
         v/Vg==
X-Gm-Message-State: AOAM533/pZsFHE/pErS91/PmmF4SnJQw+9dhl3VN5MaPFK4WRfo4bHMg
        pLniDVm0uKGzBAEFS0QCCKpCdqZNzArOCoEF
X-Google-Smtp-Source: ABdhPJyhrcL3dTo4PTMKag28yBV9+Nkbkl7mze1h7zv5FIvf4VN2CF2G69aT1XGfxMr+Dh881qqb2A==
X-Received: by 2002:ac8:45c6:: with SMTP id e6mr22659964qto.67.1620709575433;
        Mon, 10 May 2021 22:06:15 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id l65sm6314877qke.7.2021.05.10.22.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 22:06:14 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id v188so24711717ybe.1;
        Mon, 10 May 2021 22:06:14 -0700 (PDT)
X-Received: by 2002:a25:8803:: with SMTP id c3mr4494302ybl.115.1620709574185;
 Mon, 10 May 2021 22:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com> <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
In-Reply-To: <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
From:   Joe Stringer <joe@cilium.io>
Date:   Mon, 10 May 2021 22:05:59 -0700
X-Gmail-Original-Message-ID: <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
Message-ID: <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
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

Hi Cong,

On Sat, May 8, 2021 at 10:39 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Apr 27, 2021 at 11:34 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 27, 2021 at 9:36 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > We don't go back to why user-space cleanup is inefficient again,
> > > do we? ;)
> >
> > I remain unconvinced that cilium conntrack _needs_ timer apis.
> > It works fine in production and I don't hear any complaints
> > from cilium users. So 'user space cleanup inefficiencies' is
> > very subjective and cannot be the reason to add timer apis.
>
> I am pretty sure I showed the original report to you when I sent
> timeout hashmap patch, in case you forgot here it is again:
> https://github.com/cilium/cilium/issues/5048
>
> and let me quote the original report here:
>
> "The current implementation (as of v1.2) for managing the contents of
> the datapath connection tracking map leaves something to be desired:
> Once per minute, the userspace cilium-agent makes a series of calls to
> the bpf() syscall to fetch all of the entries in the map to determine
> whether they should be deleted. For each entry in the map, 2-3 calls
> must be made: One to fetch the next key, one to fetch the value, and
> perhaps one to delete the entry. The maximum size of the map is 1
> million entries, and if the current count approaches this size then
> the garbage collection goroutine may spend a significant number of CPU
> cycles iterating and deleting elements from the conntrack map."

I'm also curious to hear more details as I haven't seen any recent
discussion in the common Cilium community channels (GitHub / Slack)
around deficiencies in the conntrack garbage collection since we
addressed the LRU issues upstream and switched back to LRU maps.
There's an update to the report quoted from the same link above:

"In recent releases, we've moved back to LRU for management of the CT
maps so the core problem is not as bad; furthermore we have
implemented a backoff for GC depending on the size and number of
entries in the conntrack table, so that in active environments the
userspace GC is frequent enough to prevent issues but in relatively
passive environments the userspace GC is only rarely run (to minimize
CPU impact)."

By "core problem is not as bad", I would have been referring to the
way that failing to garbage collect hashtables in a timely manner can
lead to rejecting new connections due to lack of available map space.
Switching back to LRU mitigated this concern. With a reduced frequency
of running the garbage collection logic, the CPU impact is lower as
well. I don't think we've explored batched map ops for this use case
yet either, which would already serve to improve the CPU usage
situation without extending the kernel.

The main outstanding issue I'm aware of is that we will often have a
1:1 mapping of entries in the CT map and the NAT map, and ideally we'd
like them to have tied fates but currently we have no mechanism to do
this with LRU. When LRU eviction occurs, the entries can get out of
sync until the next GC. I could imagine timers helping with this if we
were to switch back to hash maps since we could handle this problem in
custom eviction logic, but that would reintroduce the entry management
problem above. So then we'd still need more work to figure out how to
address that with a timers approach. If I were to guess right now, the
right solution for this particular problem is probably associating
programs with map entry lifecycle events (like LRU eviction) rather
than adding timers to trigger the logic we want, but that's a whole
different discussion.

Cheers,
Joe
