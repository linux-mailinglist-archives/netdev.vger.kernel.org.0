Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55481F9A9A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgFOOn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbgFOOn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 10:43:58 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15093C05BD1E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 07:43:58 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id q188so3405148ooq.4
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 07:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r8im4dJtuxkkAaqZZS6bmcni2naI0KL21K/0KZhRnTg=;
        b=Kvpm8lif52moFLeMmaNKGAHoyXK5aBJWB+oAUhzGn06yJXqIvn/PnfObLHY9dxrmon
         3LBcru7CGHTqvQ2q9h7SG/2RHOsw3K4VKzqDapSU6QXnYY72ZBKse0+FifGxXpmZGSa2
         WqECeuk02tQWmywJxEP3fjo9i0CJIQPSkhfB4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r8im4dJtuxkkAaqZZS6bmcni2naI0KL21K/0KZhRnTg=;
        b=ZIvkir9hpsjizS+bdSkf2qbh5kgYtdqIoHM4Pcu7a3byb/JFHZlEyT1Kf+AWYH1Kbc
         YUUyblF5RIVBnhF/qiSUbIZF9+6iF+MeaQtpzMr3eW/j+0jzkkLD2Zg5iP+ay8zL3TR6
         DXCINOue02CZDiTrQD2zwOUvPqhAd/mSFB3VOwUK1UbpDSSP3CqtYsxMrH8rb6TFxRps
         2w5dc9RTA5iYIriGkP3FPEM/cRTCXBotj9uHIfCCI5f3sMYoKKBEwwWW/NkKl3BUDTl/
         NgFL4hFMdQm7nhr4PJH3Bo2Uhcoet2FJWjZxFKmEMHODr8M+3UW7GQhLkcBXNC86f6zq
         u6ng==
X-Gm-Message-State: AOAM533ywEuowIQ+MtyefjGomT4BgsNC9qru4SfIbalLOkr2ec6hfy9e
        xDKI1wDrsvks74CapYMZ72cqzbVfECGpsw2fL3+wDarNPP7LnQ==
X-Google-Smtp-Source: ABdhPJzQC7JHZFZ5lcxDRbQbodCqupHVOnlokMDpxwYb3ub+OdcyuaHCeS2Lw5IKYZvlIc7mtPcUVZqSHhJ+MgwjgzQ=
X-Received: by 2002:a4a:3559:: with SMTP id w25mr21208459oog.6.1592232236922;
 Mon, 15 Jun 2020 07:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200612160141.188370-1-lmb@cloudflare.com> <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
In-Reply-To: <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 15 Jun 2020 15:43:45 +0100
Message-ID: <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Fri, 12 Jun 2020 at 23:36, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 12, 2020 at 9:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
> > nor target_fd but accepts any value. Return EINVAL if either are non-zero.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
> > ---
> >  kernel/bpf/net_namespace.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > index 78cf061f8179..56133e78ae4f 100644
> > --- a/kernel/bpf/net_namespace.c
> > +++ b/kernel/bpf/net_namespace.c
> > @@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >         struct net *net;
> >         int ret;
> >
> > +       if (attr->attach_flags || attr->target_fd)
> > +               return -EINVAL;
> > +
>
> In theory it makes sense, but how did you test it?

Not properly it seems, sorry!

> test_progs -t flow
> fails 5 tests.

I spent today digging through this, and the issue is actually more annoying than
I thought. BPF_PROG_DETACH for sockmap and flow_dissector ignores
attach_bpf_fd. The cgroup and lirc2 attach point use this to make sure that the
program being detached is actually what user space expects. We actually have
tests that set attach_bpf_fd for these to attach points, which tells
me that this is
an easy mistake to make.

Unfortunately I can't come up with a good fix that seems backportable:
- Making sockmap and flow_dissector have the same semantics as cgroup
  and lirc2 requires a bunch of changes (probably a new function for sockmap)
- Returning EINVAL from BPF_PROG_DETACH if attach_bpf_fd is specified
  leads to a lot of churn in selftests

Is it worth just landing these fixes on bpf or bpf-next without
backporting them?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
