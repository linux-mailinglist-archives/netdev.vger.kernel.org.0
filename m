Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B80205843
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733142AbgFWRHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733032AbgFWRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:07:23 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D7CC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 10:07:22 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n6so17391505otl.0
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 10:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=otxfWiaSA/n5sj0rsbDV574kgaL1ginU3evlOR2FDIc=;
        b=sfyM3u3vrf7YbmVUKU2Qfhu8AbqOzRZGgvymHGjmLWjwIwYkmKYt9Qg3u0Wfnr/mBm
         bGjcXobsDVaPbCWSKeoep02eos3cRJXaHknp/RpGLh1Gud66EI3DiUg+1MA0C1C6mjQU
         6WBSqr41Zu+2lwcCuBk1TjltP+pMXSCS5YbQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=otxfWiaSA/n5sj0rsbDV574kgaL1ginU3evlOR2FDIc=;
        b=mFLl4DWFyyR6lK2QeG119lpC6UB+0EK4RnFZdvwrfHk7rpYA0o52q/GcoEgMP4tPF5
         C9lRqoFUDp0K0ZX+x6NOiOHojfpiM2sz9ORO4pdfDVSsh+VicpnOCla0DbcjAaCw9pFq
         7g17ZZb7Bx2TG0nJ4ve57YI3dFVEgTCGBMjxLXwSQHHGfofdgsVKkyKjBjUZfERZDHes
         ZuuxpnzIAvlqTXsgXBKQQ/xGV2Y1xxo8HIwESj/7DD8hjMIhO86AfiIn8C7KqJzzqfbi
         YWpz60ZncrEj2Bj/vgjCekdRLssnE7RK+r0Di2+DH21neSEZG1I5NH/pDL4Zk51ZwPF4
         u9Bw==
X-Gm-Message-State: AOAM530OgBtUuGlkIPVNyW80Vj76EIZaq5GCp2eXy5NKmjUDuFiWL40t
        5fZbUUq5gLWsXbnIN652es1cV/LDo91WXf1Vd1Vnpg==
X-Google-Smtp-Source: ABdhPJypkkGtNpV9FtWpGdQh9OjDA35TIQfAHV66hnOT9hMeyeCueyU/SKcI91G9Asj9Qvj956bjE7mfiV/bI3UUKVU=
X-Received: by 2002:a9d:7751:: with SMTP id t17mr20156459otl.334.1592932041728;
 Tue, 23 Jun 2020 10:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200612160141.188370-1-lmb@cloudflare.com> <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
 <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com>
 <CAADnVQJP_i+KsP771L=GwxousnE=w9o2KckZ7ZCbc064EqSq6w@mail.gmail.com>
 <CACAyw99Szs3nUTx=DSmh0x8iTBLNF9TTLGC0GQLZ=FifVnbzBA@mail.gmail.com>
 <CAADnVQLXEq5+ko_ojmuh1Oc84HiPrfLF-7Cdh1xwwm-PhoFwBQ@mail.gmail.com> <5ee9bcefda5a3_1d4a2af9b18625c4c0@john-XPS-13-9370.notmuch>
In-Reply-To: <5ee9bcefda5a3_1d4a2af9b18625c4c0@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 23 Jun 2020 18:07:09 +0100
Message-ID: <CACAyw98OCJs7qUomP9oGbZdZpbtYRN+tdS6roUze_4K7zj4eFA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Wed, 17 Jun 2020 at 07:49, John Fastabend <john.fastabend@gmail.com> wrote:
>
> Alexei Starovoitov wrote:
> > On Tue, Jun 16, 2020 at 1:30 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Tue, 16 Jun 2020 at 04:55, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Jun 15, 2020 at 7:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > >
> > > > > On Fri, 12 Jun 2020 at 23:36, Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Jun 12, 2020 at 9:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > > > >
> > > > > > > Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
> > > > > > > nor target_fd but accepts any value. Return EINVAL if either are non-zero.
> > > > > > >
> > > > > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > > > > Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
> > > > > > > ---
> > > > > > >  kernel/bpf/net_namespace.c | 3 +++
> > > > > > >  1 file changed, 3 insertions(+)
> > > > > > >
> > > > > > > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > > > > > > index 78cf061f8179..56133e78ae4f 100644
> > > > > > > --- a/kernel/bpf/net_namespace.c
> > > > > > > +++ b/kernel/bpf/net_namespace.c
> > > > > > > @@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > > > > >         struct net *net;
> > > > > > >         int ret;
> > > > > > >
> > > > > > > +       if (attr->attach_flags || attr->target_fd)
> > > > > > > +               return -EINVAL;
> > > > > > > +
> > > > > >
> > > > > > In theory it makes sense, but how did you test it?
> > > > >
> > > > > Not properly it seems, sorry!
> > > > >
> > > > > > test_progs -t flow
> > > > > > fails 5 tests.
> > > > >
> > > > > I spent today digging through this, and the issue is actually more annoying than
> > > > > I thought. BPF_PROG_DETACH for sockmap and flow_dissector ignores
> > > > > attach_bpf_fd. The cgroup and lirc2 attach point use this to make sure that the
> > > > > program being detached is actually what user space expects. We actually have
> > > > > tests that set attach_bpf_fd for these to attach points, which tells
> > > > > me that this is
> > > > > an easy mistake to make.
>
> In sockmap case I didn't manage to think what multiple programs of the same type
> on the same map would look like so we can just remove whatever program is there.
> Is there a problem with this or is it that we just want the sanity check.
>
> > > > >
> > > > > Unfortunately I can't come up with a good fix that seems backportable:
> > > > > - Making sockmap and flow_dissector have the same semantics as cgroup
> > > > >   and lirc2 requires a bunch of changes (probably a new function for sockmap)
> > > >
> > > > making flow dissector pass prog_fd as cg and lirc is certainly my preference.
> > > > Especially since tests are passing fd user code is likely doing the same,
> > > > so breakage is unlikely. Also it wasn't done that long ago, so
> > > > we can backport far enough.
> > > > It will remove cap_net_admin ugly check in bpf_prog_detach()
> > > > which is the only exception now in cap model.
> > >
> > > SGTM. What about sockmap though? The code for that has been around for ages.
> >
> > you mean the second patch that enforces sock_map_get_from_fd doesn't
> > use attach_flags?
> > I think it didn't break anything, so enforcing is fine.
>
> I'm ok with enforcing it.
>
> >
> > or the detach part that doesn't use prog_fd ?
> > I'm not sure what's the best here.
> > At least from cap perspective it's fine because map_fd is there.
> >
> > John, wdyt?
>
> I think we can keep the current detach without the prog_fd as-is. And
> then add logic so that if the prog_fd is included we check it?

Do you know of users that rely on this? FWIW all of the selftests actually
pass attach_bpf_fd when detaching from sockmap (on a recent bpf-next at least).

It'd be nice if I could make sockmap require this to be present, just
so that it's consistent with flow_dissector and other BPF_PROG_DETACH
users.

OTOH I'm not sure if this is backport material after all.

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
