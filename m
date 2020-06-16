Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6461F1FA72D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgFPDzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFPDzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:55:41 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C53C061A0E;
        Mon, 15 Jun 2020 20:55:39 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n24so21715349lji.10;
        Mon, 15 Jun 2020 20:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ef/c5sByl1dQLDC7ct1QT+x4ZA8mc0Ozfd+rnzLi0vM=;
        b=HrDELnRkblGg4LR88wDhd2g+xC39qXUU+freDI0HxIr32SiRt0bcNNXO5LsyiY8AXi
         ewFyq21sGR66Sk3yPq4kjEFg9wh01Zksx8Xh/zQijF4UDgK4KRmdKjrTr7LcSsEDXNGk
         5y/Ng9nKELD7mNp0o5soNjSdedHsv4mVD1gbxQ1oUE8EtFjvpfbSM0UtVZdywBKCpLE8
         5Lf1v7D2nP1P+Oa6Tpj/pyUqYMqqZ6+KeJVcexSqd3rJVmA6+COOHDRTUQvKZ78Og5Xj
         etPBbaZ6p9NTtC7ce+LBrGjLvhQEWDCEOI7oLmDi8MF8wvZ+falTQDLzEfnRXSey5R2j
         5uLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ef/c5sByl1dQLDC7ct1QT+x4ZA8mc0Ozfd+rnzLi0vM=;
        b=baGb9OhFLWka1v7mOT3An66kWWiddJIu6QlcS2jj/jczlrOrjXMwBdhIL4traRLKHq
         q5kIfSHsSd1CvY7qwYKXBOKU+W4LPVh7Vk7L/HjpzI/zfGjBABs+N0PEWpb2MP9Z57sn
         P721XSGGG5n8AWnijOUiFg0hEuHtD0RrqwyOqasbiBPTqqzZHNKzkJGdmUuosQOnGyT2
         BXcH5Y+9D9PZI29OLhaDkoAKiYhB2nPimyObgZkUCT7QuxarFYiNl0OYNhgBMIOM6tu0
         hRf6Y4dsC1iu9M72crsSOg5BZvMiGC+UM/uWH2omOU7DIUpMFxf8xcaCuwT4nwByuGQK
         bWZg==
X-Gm-Message-State: AOAM532UkrvlBTI+2CB0vFgn/zXtufmP+uEImIyLk+zghPxR7oimO8YS
        oFomSaxm7ZsVcrwXzZ5i7uMhHLa0kovkhDHJJCA=
X-Google-Smtp-Source: ABdhPJwv30NCg1WqRnRZqVd0fR/+EmBquaNoRMIRqikQ4C3M04oWhogn6YZD9m5ky5fIo/FgLoaGmo/xTvK2NSZyO6w=
X-Received: by 2002:a05:651c:1193:: with SMTP id w19mr401486ljo.121.1592279738042;
 Mon, 15 Jun 2020 20:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200612160141.188370-1-lmb@cloudflare.com> <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
 <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com>
In-Reply-To: <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Jun 2020 20:55:26 -0700
Message-ID: <CAADnVQJP_i+KsP771L=GwxousnE=w9o2KckZ7ZCbc064EqSq6w@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 7:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 12 Jun 2020 at 23:36, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jun 12, 2020 at 9:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
> > > nor target_fd but accepts any value. Return EINVAL if either are non-zero.
> > >
> > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
> > > ---
> > >  kernel/bpf/net_namespace.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > > index 78cf061f8179..56133e78ae4f 100644
> > > --- a/kernel/bpf/net_namespace.c
> > > +++ b/kernel/bpf/net_namespace.c
> > > @@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > >         struct net *net;
> > >         int ret;
> > >
> > > +       if (attr->attach_flags || attr->target_fd)
> > > +               return -EINVAL;
> > > +
> >
> > In theory it makes sense, but how did you test it?
>
> Not properly it seems, sorry!
>
> > test_progs -t flow
> > fails 5 tests.
>
> I spent today digging through this, and the issue is actually more annoying than
> I thought. BPF_PROG_DETACH for sockmap and flow_dissector ignores
> attach_bpf_fd. The cgroup and lirc2 attach point use this to make sure that the
> program being detached is actually what user space expects. We actually have
> tests that set attach_bpf_fd for these to attach points, which tells
> me that this is
> an easy mistake to make.
>
> Unfortunately I can't come up with a good fix that seems backportable:
> - Making sockmap and flow_dissector have the same semantics as cgroup
>   and lirc2 requires a bunch of changes (probably a new function for sockmap)

making flow dissector pass prog_fd as cg and lirc is certainly my preference.
Especially since tests are passing fd user code is likely doing the same,
so breakage is unlikely. Also it wasn't done that long ago, so
we can backport far enough.
It will remove cap_net_admin ugly check in bpf_prog_detach()
which is the only exception now in cap model.
