Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C85C34F780
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 05:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhCaD3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 23:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbhCaD2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 23:28:45 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFF1C06175F
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 20:28:45 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso17670559otq.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 20:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YWqkHkXqjSSpodeGyf6JoDbRT3UAWqUxwXE4RX9bUXI=;
        b=Q1zGQHPl17buzrLUEgHFv2N82ENzftfFVy11LyG1DG+k9g1MY4Apy9TypTmcYZmFbE
         YK9aXi39PjeFM15QOYXGKxYDMGIR50i8SqQPlvA2/k+UBewWHiv8qpi2sXdG5h4eSGDO
         lkEoPINuszjJDJdzc1iNBUfm11AoTHWY19NJOQlIFYCyb4m4xn2lfgjLoh0qmOy20FSo
         JJM/C2A1supCIUox5qZ+ymU3HtDVh/6hcMzfXMVrWO8Fut+Y8/YWCt1Jloau1LWZRw7S
         z3ZFbvY+er7m2TExqcTD5trBTizCB05KaRh9JXdXJnI7z2WRMsR4ku541p5ycX7N4aWF
         T54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YWqkHkXqjSSpodeGyf6JoDbRT3UAWqUxwXE4RX9bUXI=;
        b=DnTscmq6S1Z+k1yEkTqUQdBasMU8v+4gYMSVFJC5h5z7KxXoJMjtRxuLWBMAo3uaBn
         5dIlz7Yk3NH4zYmFT1CSvkGnMiIlxUD68PhkD96NeS/bHz97RtvQ5OtySoRITDy0JAom
         tfcV6LROU69jZ959xbCUOGvp5zOkQ4csWjbwx6FwYqWSiP/7ardpMgjoPqINDei4JMyr
         oT00OdyT17wLCaKgHqzNCywaJEbiBqS0dNm09Dcvbm8BSbaB9q4v+iRnlmmArBJyhJxL
         Eer5HA5WbrmLAAlE59qKxK3ySRN5i2YTS9IOIMvynlMs8Y+x/VX151y4iYTmxb/o7N90
         bX9g==
X-Gm-Message-State: AOAM53171YnCSEbYB8U2J5MED7bnw10ItHATXVl6EOHWunGJn13y9eEU
        vafLxSBFDqA+kZCdzRUqKWQzEtxWQL6QqPAgwik8SJE5P0JKMA==
X-Google-Smtp-Source: ABdhPJzNDct2q5HLdhRjukH0jQt589qOnFQULvOQC8gYu/dXe8bQc1tXVdTzJgKLEew/j4BSIaVXho7vv/9CrSQi4PA=
X-Received: by 2002:a9d:5d0a:: with SMTP id b10mr920324oti.180.1617161325029;
 Tue, 30 Mar 2021 20:28:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
 <CAADnVQ+H1bHMeUtxNbes_-fUQTBP5Pdaqq7F5aVfW5QY+gi1bw@mail.gmail.com>
 <CAM_iQpXKQ6WDgoExX=9D2gXcuYtUD4xLsPOSKX=BnQ-0KpBZpg@mail.gmail.com> <20210330214301.ssskul54hyh67o77@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210330214301.ssskul54hyh67o77@kafai-mbp.dhcp.thefacebook.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Tue, 30 Mar 2021 20:28:34 -0700
Message-ID: <CAP_N_Z_+agZz4oBaGvOQY0AKxaZB=oqpU7WMEugAEftOkx45eA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2 bpf-next 00/14] bpf: Support calling
 kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

I am working with Cong to get Clang/LLVM-13 to test. But I am confused
whether CLANG/LLVM-13 is released or not.

From https://apt.llvm.org/ , I saw llvm-13 was released in Feb, but it
does not have the diff you mentioned.

From the following links, I am not sure if LLVM-13 was really released
or still in the process.
https://llvm.org/docs/ReleaseNotes.html#external-open-source-projects-using-llvm-13
https://github.com/llvm/llvm-project/releases

Did I miss something? Where could I get a good clang/llvm-13 ? Or
maybe clang-14? Thanks

Regards,

Jiang

On Tue, Mar 30, 2021 at 2:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Mar 30, 2021 at 12:58:22PM -0700, Cong Wang wrote:
> > On Tue, Mar 30, 2021 at 7:36 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Mar 30, 2021 at 2:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > On Thu, 25 Mar 2021 at 01:52, Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This series adds support to allow bpf program calling kernel function.
> > > >
> > > > I think there are more build problems with this. Has anyone hit this before?
> > > >
> > > > $ CLANG=clang-12 O=../kbuild/vm ./tools/testing/selftests/bpf/vmtest.sh -j 7
> > > >
> > > >   GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
> > > > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > > >   GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
> > > > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > > >   GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
> > > >   GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
> > > >   GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
> > > > libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
> > > > Error: failed to open BPF object file: No such file or directory
> > >
> > > The doc update is on its way:
> > > https://patchwork.kernel.org/project/netdevbpf/patch/20210330054156.2933804-1-kafai@fb.com/
> >
> > We just updated our clang to 13, and I still get the same error above.
> Please check if the llvm/clang has this diff
> https://reviews.llvm.org/D93563
