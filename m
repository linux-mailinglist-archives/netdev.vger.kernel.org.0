Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D3A1FC018
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbgFPUh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgFPUhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:37:24 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8F5C061573;
        Tue, 16 Jun 2020 13:37:24 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y11so123989ljm.9;
        Tue, 16 Jun 2020 13:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ED+E05jFvuSbF1d6fG9JM8s3vB5/r4QTyu/6Ssk0hqI=;
        b=pyXB6lOygv7d3fpovp/hfSOGjPv5ee22Kh91pmpyuPkSH3cPe3xSSoKSv3zqwVnXx5
         +hhuHw8IAeyT6YN+YmeJ8SISZmCPqA8fh5VAgYKlNwFqozX8D6KxPnyN0eqUlSB4iFjy
         0H9mr/YUYfncmuJd4v0jGbf+5gecaMKPZpgz/EwdlODlfHSUFP3c36q+sN12qIfRSTDc
         9XvqhgIfIAJ3h5l+xUN6yALuo9i/u+p6vm4CfhHzmRPyRrib0DNg9SrFIynm1eDiW+fz
         a5WjoU7rKP3KdkSRkTyfBDEWwObdz/xvMkdbgkD/hVLLtcLk5LAtPzC1lrDPU//KAnpI
         ENvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ED+E05jFvuSbF1d6fG9JM8s3vB5/r4QTyu/6Ssk0hqI=;
        b=rObWlGhHfsQITvObmKX8O7ZhbsJPwqDAl0r2llWXj6F1NK0P4JazhUNGqKTVUPFCpL
         BaeIt1GfZyudkP6aAnt9GXDvOcT30TcGB/QenrOWOO5xbrBWI8T2CAHNEgRAZz/5sn1z
         9bqHchEdngon6xgX+Exqgq4QjBuP+ddR54ubaFzvCFGUsOPZ+9aziwkrLO+JdzJVBOSz
         /NTT3jtUwnadKCd1ltUVsshnM70CA/wjQL2W+2YeaXU2VP0R2CT+0YuDjzvqj23dUIuO
         XYu8rNwMiaHTyaBwiBQ/Hz5y8OP0f5JVoiP6EUQt2qowV6DWQWy61eP3fdrb2G4T1SPo
         n5eg==
X-Gm-Message-State: AOAM53399Cyn5DCg2Uim0DwN/DovUOGwwOSrq79sM9jbNZUMcVyC9JLn
        CabeBx9z99ASy/Mnf2uz0DXL+8ly/jYnLBclG8A=
X-Google-Smtp-Source: ABdhPJwE2lMLvVUrdVYb5jqSp16Jt51lzYQ+YF39c3LoNZ6rdQE19vSQ2lSbpLa+BE9LdtTZnOw2WK0Z27HR99wUpn4=
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr2376050ljj.2.1592339842579;
 Tue, 16 Jun 2020 13:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200612160141.188370-1-lmb@cloudflare.com> <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
 <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com>
 <CAADnVQJP_i+KsP771L=GwxousnE=w9o2KckZ7ZCbc064EqSq6w@mail.gmail.com> <CACAyw99Szs3nUTx=DSmh0x8iTBLNF9TTLGC0GQLZ=FifVnbzBA@mail.gmail.com>
In-Reply-To: <CACAyw99Szs3nUTx=DSmh0x8iTBLNF9TTLGC0GQLZ=FifVnbzBA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jun 2020 13:37:11 -0700
Message-ID: <CAADnVQLXEq5+ko_ojmuh1Oc84HiPrfLF-7Cdh1xwwm-PhoFwBQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 1:30 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 16 Jun 2020 at 04:55, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jun 15, 2020 at 7:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Fri, 12 Jun 2020 at 23:36, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Jun 12, 2020 at 9:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > >
> > > > > Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
> > > > > nor target_fd but accepts any value. Return EINVAL if either are non-zero.
> > > > >
> > > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > > Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
> > > > > ---
> > > > >  kernel/bpf/net_namespace.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > > > > index 78cf061f8179..56133e78ae4f 100644
> > > > > --- a/kernel/bpf/net_namespace.c
> > > > > +++ b/kernel/bpf/net_namespace.c
> > > > > @@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > > >         struct net *net;
> > > > >         int ret;
> > > > >
> > > > > +       if (attr->attach_flags || attr->target_fd)
> > > > > +               return -EINVAL;
> > > > > +
> > > >
> > > > In theory it makes sense, but how did you test it?
> > >
> > > Not properly it seems, sorry!
> > >
> > > > test_progs -t flow
> > > > fails 5 tests.
> > >
> > > I spent today digging through this, and the issue is actually more annoying than
> > > I thought. BPF_PROG_DETACH for sockmap and flow_dissector ignores
> > > attach_bpf_fd. The cgroup and lirc2 attach point use this to make sure that the
> > > program being detached is actually what user space expects. We actually have
> > > tests that set attach_bpf_fd for these to attach points, which tells
> > > me that this is
> > > an easy mistake to make.
> > >
> > > Unfortunately I can't come up with a good fix that seems backportable:
> > > - Making sockmap and flow_dissector have the same semantics as cgroup
> > >   and lirc2 requires a bunch of changes (probably a new function for sockmap)
> >
> > making flow dissector pass prog_fd as cg and lirc is certainly my preference.
> > Especially since tests are passing fd user code is likely doing the same,
> > so breakage is unlikely. Also it wasn't done that long ago, so
> > we can backport far enough.
> > It will remove cap_net_admin ugly check in bpf_prog_detach()
> > which is the only exception now in cap model.
>
> SGTM. What about sockmap though? The code for that has been around for ages.

you mean the second patch that enforces sock_map_get_from_fd doesn't
use attach_flags?
I think it didn't break anything, so enforcing is fine.

or the detach part that doesn't use prog_fd ?
I'm not sure what's the best here.
At least from cap perspective it's fine because map_fd is there.

John, wdyt?
