Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ECC2F714C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbhAOD6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731197AbhAOD6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:58:07 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD5DC061575;
        Thu, 14 Jan 2021 19:57:27 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id o19so11276114lfo.1;
        Thu, 14 Jan 2021 19:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BXgLIQIhwnUMcmHx/ZoNEaxTwnIIHjSLCw+ghfFkKQ=;
        b=UYCbxHG4TYY45AcIONEQVT+TbPQ7eCWCVwVZ/Y9xj/AqkYT1ogXqFCdh96nZf7vwi9
         0OarqGg9xpRnGNMAsE685qQop4Y4qWJARyMVkxMJIUcEEy0IvR9JucS79MBPX6sLa0P3
         B0PRGQ3a/cNgajuq/zhi9Z9trtvCRLYNNRsiBSp4mDCNzSRHTnEvSe27vs8cfd11BsWl
         mBOc8kOjLZ1xbqOktFxTnxDj4NMzwKwYOuNeCroeN7b18kAjPR52wcgXBQy7QQvt9Na0
         +1n6N0ZCXdfZCWvRW+M6z0soT3u/gal6s5LEbbU7aByZwwHfg3Tzg4QLKHXfuD99aw15
         jbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BXgLIQIhwnUMcmHx/ZoNEaxTwnIIHjSLCw+ghfFkKQ=;
        b=ZxTiQNJd3i98/2cZePl+bB3iPEJ1HjxHfZLI6ksPchM/oQGCI6UZlPIfhKwgbOUrMt
         weUWV1k4tiyqNFgp6w/MDEzNaxoCqeqmiXIOG4M3XzKIza1r62lQupnNh7rSrzJXQC75
         M6RXhWrdJ4khClQhE2kWIjmW/yUMjWPidPWiBFxT3rsKxPoKmAlVYbGvOrHaFw/vqYUS
         Uppiuf7fR8aKKsZe+GSQ1+Id2RnsRcpR9OK26RZ3IA05IGHMGkVzqu2jyxoegmJ7wK4r
         dAy00TKc+QFARSzZBFSRi+N3sl+hiCV9dlcu8t0gPOZzWg2NGz7Qd64TLDjE3dkvTqQb
         AeBA==
X-Gm-Message-State: AOAM531yiHJUQcbiFj/cnOP+NQYDkmbtmslY4gssbX9/R6CoouPi+3TH
        5OBHW6J7WE5hFtv7V5uL/0jHza+GTSslqFHM/jc=
X-Google-Smtp-Source: ABdhPJwK4Z2DENPIoy5Ov7eN5L6AY3Ox+jsMEWr8o2JH/nBKxj8dFdqqWucMWsYntvsRCIqBecpKu77BaMe/wsgbqkk=
X-Received: by 2002:a19:acd:: with SMTP id 196mr4818583lfk.539.1610683045609;
 Thu, 14 Jan 2021 19:57:25 -0800 (PST)
MIME-Version: 1.0
References: <20210113213321.2832906-1-sdf@google.com> <20210113213321.2832906-2-sdf@google.com>
 <CAADnVQLssJ4oStg7C4W-nafFKaka1H3-N0DhsBrB3FdmgyUC_A@mail.gmail.com> <CAKH8qBsaZjOkvGZuNCtG=V2M9YfAJgtG+moAejwtBCB6kNJUwA@mail.gmail.com>
In-Reply-To: <CAKH8qBsaZjOkvGZuNCtG=V2M9YfAJgtG+moAejwtBCB6kNJUwA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jan 2021 19:57:14 -0800
Message-ID: <CAADnVQ+2MDGVEKRZ+B-q+GcZ8CExN5VfSZpkvntg48dpww3diA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 7:40 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Thu, Jan 14, 2021 at 7:27 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 1:33 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > 3% overhead for locking/unlocking the socket.
> > >
> > > Without this patch:
> > >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> > >             |
> > >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> > >                        |
> > >                         --0.81%--__kmalloc
> > >
> > > With the patch applied:
> > >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Cc: Song Liu <songliubraving@fb.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Acked-by: Martin KaFai Lau <kafai@fb.com>
> >
> > Few issues in this patch and the patch 2 doesn't apply:
> > Switched to a new branch 'tmp'
> > Applying: bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
> > .git/rebase-apply/patch:295: trailing whitespace.
> > #endif
> > .git/rebase-apply/patch:306: trailing whitespace.
> > union tcp_word_hdr {
> > .git/rebase-apply/patch:309: trailing whitespace.
> > };
> > .git/rebase-apply/patch:311: trailing whitespace.
> > #define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words [3])
> > .git/rebase-apply/patch:313: trailing whitespace.
> > enum {
> > warning: squelched 1 whitespace error
> > warning: 6 lines add whitespace errors.
> > Applying: bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
> > error: patch failed: kernel/bpf/cgroup.c:1390
> > error: kernel/bpf/cgroup.c: patch does not apply
> > Patch failed at 0002 bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
> Sorry, I mentioned in the cover letter that the series requires
> 4be34f3d0731 ("bpf: Don't leak memory in bpf getsockopt when optlen == 0")
> which is only in the bpf tree. No sure when bpf & bpf-next merge.
> Or are you trying to apply on top of that?

hmm. It will take a while to wait for the trees to converge.
Ok. I've cherry-picked that bpf commit and applied 3 patches on top,
but the test failed to build:

progs/sockopt_sk.c:60:47: error: use of undeclared identifier
'TCP_ZEROCOPY_RECEIVE'
        if (ctx->level == SOL_TCP && ctx->optname == TCP_ZEROCOPY_RECEIVE) {
                                                     ^
progs/sockopt_sk.c:66:16: error: invalid application of 'sizeof' to an
incomplete type 'struct tcp_zerocopy_receive'
                if (optval + sizeof(struct tcp_zerocopy_receive) > optval_end)

Looks like copied uapi/tcp.h into tools/ wasn't in the include path.
