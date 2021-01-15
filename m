Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1002F7162
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbhAOEIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbhAOEIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:08:13 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6119DC061575;
        Thu, 14 Jan 2021 20:07:32 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x20so11243390lfe.12;
        Thu, 14 Jan 2021 20:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4q6zbVh1VNqw6PLsirWC3rxykqBGr0L9ejileG2+Vxk=;
        b=gJ5u1SvxjRxiYdl8dxSF5xLz16Ddel4gTHFnFw+lq77zhhN3YxWMGqv0T+fzhxxcFY
         kIfLCMzSDCAw0fCmSJInKUaXM0MfFnO8QiR0LX2+FiHvZalIRyogjfT7rhfw7Xj9l7uW
         FcdpNsT8Pq9rsXZQyeUEejmokUWn56sgV3PeG5/6wBRFbYf6jpY6JQzgb7S4pz+ResYe
         TKPBNblXswo8JKkQerU8pV6SUkAtjwTHsisosC1rWwJKCoG4FKo5uRa72ugb64t07NBr
         BYvRczsoyMqBgDtfDIYRB7gFrd/3ITjT7omMoppBtGdA87zKLLiNXxVc/PV0uuYnJVX2
         uHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4q6zbVh1VNqw6PLsirWC3rxykqBGr0L9ejileG2+Vxk=;
        b=IKDO2WZA1Na2PiFXi+0o68c1rvavWfoE8V538uis/VxZ3e2tvxSml30MVDl/ZbBgpL
         MENo8qL8DvudZFiV/p13Ssjk8uKaCXijMHU4/0M3UVYg1D9TeZTTX+N/NWu61aazI4ET
         5xMDxTO+qP8oLR2kcG70axd5FgDcHBWW7OKucZZuBIxPSd++LYXT12MqaUa33Wd8hx3i
         C6+uEmPsTpyLfSejM5RqjDh9LeAwZON/bqiAwCzzhlLbgnTu15r6VETV1T/9Wzg/vMg5
         dK3NLZjjzugil/tDXQ3S7DWCIo/O0uskXLWCdwGEIN+MP8w6wp1c/dVSSumjcI6BJ9UL
         j9MA==
X-Gm-Message-State: AOAM532PL7oHxQdbCG6wPzTq7ig/aKSIsqRYga6Gqz1cHQVsM85x8Iit
        P95/7A7KL7bOIEpEkc9VFepTZ4F5Aw8olcGkcvs=
X-Google-Smtp-Source: ABdhPJysoxp962Pm6j0dPdurQ/RR36fw3dxjXx8WWoJ0FbqKQB+WAsaaeavHEX4JQrYOw/8fclvWpwQmK9TXMSLgSX4=
X-Received: by 2002:a05:6512:34c5:: with SMTP id w5mr4839218lfr.214.1610683650956;
 Thu, 14 Jan 2021 20:07:30 -0800 (PST)
MIME-Version: 1.0
References: <20210113213321.2832906-1-sdf@google.com> <20210113213321.2832906-2-sdf@google.com>
 <CAADnVQLssJ4oStg7C4W-nafFKaka1H3-N0DhsBrB3FdmgyUC_A@mail.gmail.com>
 <CAKH8qBsaZjOkvGZuNCtG=V2M9YfAJgtG+moAejwtBCB6kNJUwA@mail.gmail.com>
 <CAADnVQ+2MDGVEKRZ+B-q+GcZ8CExN5VfSZpkvntg48dpww3diA@mail.gmail.com> <CAKH8qBuMUj0j7eS+O87=U6jzndXnCPiJ+4RbQ7nAdzbHY7cqAQ@mail.gmail.com>
In-Reply-To: <CAKH8qBuMUj0j7eS+O87=U6jzndXnCPiJ+4RbQ7nAdzbHY7cqAQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jan 2021 20:07:19 -0800
Message-ID: <CAADnVQKPj9Yh0nVi0AjHAxo5UaES9gYwLxAEixP+G6_EhdNpOg@mail.gmail.com>
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

On Thu, Jan 14, 2021 at 8:05 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Thu, Jan 14, 2021 at 7:57 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 7:40 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Thu, Jan 14, 2021 at 7:27 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Jan 13, 2021 at 1:33 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > > > 3% overhead for locking/unlocking the socket.
> > > > >
> > > > > Without this patch:
> > > > >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> > > > >             |
> > > > >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> > > > >                        |
> > > > >                         --0.81%--__kmalloc
> > > > >
> > > > > With the patch applied:
> > > > >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> > > > >
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > > > Cc: Song Liu <songliubraving@fb.com>
> > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > > >
> > > > Few issues in this patch and the patch 2 doesn't apply:
> > > > Switched to a new branch 'tmp'
> > > > Applying: bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
> > > > .git/rebase-apply/patch:295: trailing whitespace.
> > > > #endif
> > > > .git/rebase-apply/patch:306: trailing whitespace.
> > > > union tcp_word_hdr {
> > > > .git/rebase-apply/patch:309: trailing whitespace.
> > > > };
> > > > .git/rebase-apply/patch:311: trailing whitespace.
> > > > #define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words [3])
> > > > .git/rebase-apply/patch:313: trailing whitespace.
> > > > enum {
> > > > warning: squelched 1 whitespace error
> > > > warning: 6 lines add whitespace errors.
> > > > Applying: bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
> > > > error: patch failed: kernel/bpf/cgroup.c:1390
> > > > error: kernel/bpf/cgroup.c: patch does not apply
> > > > Patch failed at 0002 bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
> > > Sorry, I mentioned in the cover letter that the series requires
> > > 4be34f3d0731 ("bpf: Don't leak memory in bpf getsockopt when optlen == 0")
> > > which is only in the bpf tree. No sure when bpf & bpf-next merge.
> > > Or are you trying to apply on top of that?
> >
> > hmm. It will take a while to wait for the trees to converge.
> > Ok. I've cherry-picked that bpf commit and applied 3 patches on top,
> > but the test failed to build:
> >
> > progs/sockopt_sk.c:60:47: error: use of undeclared identifier
> > 'TCP_ZEROCOPY_RECEIVE'
> >         if (ctx->level == SOL_TCP && ctx->optname == TCP_ZEROCOPY_RECEIVE) {
> >                                                      ^
> > progs/sockopt_sk.c:66:16: error: invalid application of 'sizeof' to an
> > incomplete type 'struct tcp_zerocopy_receive'
> >                 if (optval + sizeof(struct tcp_zerocopy_receive) > optval_end)
> >
> > Looks like copied uapi/tcp.h into tools/ wasn't in the include path.
> Interesting, let me try to understand where it comes on my system
> because it did work even without this uapi/tcp.h so I might
> have messed something up. Thank you!

You probably have a newer glibc. Mine is old. I think our CI doesn't
use glibc and
is probably missing the newest tcp.h as well.
