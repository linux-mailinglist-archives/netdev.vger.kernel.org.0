Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA7120EC0B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgF3DfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgF3DfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:35:05 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF7BC061755;
        Mon, 29 Jun 2020 20:35:05 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id el4so4589829qvb.13;
        Mon, 29 Jun 2020 20:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODjqhnM4EYauxP5u1z5d0rzCDxBUPQowO18e+pMY0SA=;
        b=erdada7PFEBW59urx/AnQDu2eoz35PvlLaYuNToWB4L05zO0AXNgG4NsKZU1SREmN1
         fwA2l0PiNmlevZU00vBMjEM0Mouwn0j+lSdiTeE5ncdkXmf2SGo5U/8xO3FHVQPzSJFR
         wuxMVcDPie2daaRv6BxNMWRDH3MjdRn/ofa6gcWf3y0D/BE0SOKCXtx6RQXVtw270zk9
         dGVyW4ENjDooxYaGShabaxQiVE0KlSA9P8WInHVYWqP3YCTtHn4kFkm7Jvgr1vc0fZxq
         36caEqRE9AzDSmFs5r6bjoFzL8n8owZBmqw3zBcnAl4RFZX4FVw9pxa6qWUe6/RR0I5V
         MmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODjqhnM4EYauxP5u1z5d0rzCDxBUPQowO18e+pMY0SA=;
        b=T0Q6iTBJWAJEECzW6wx3J111tQnUwGCjxhDr3SiBwKsgX0F6RyCe9UlK9/zuM+atYM
         iHZdgKrMpiWHI40O8SqAcZUEDpai9XooKBdZEWJERPqXxeKt4l5f8JCKqLNuDKFp/+kn
         7bYTWrQqkoFqtxUz2n6HGfOmbpCnfbn8qJ8tHfEIpXIe1cNYlFBBEu2m6Nn/oxBLeg21
         1PQpOqiT5+8o6CWlAOUzJCZrHx0P/KB0rDlNC6WSWnQPLeCcBWhCct7wilgs6X36Le9+
         E9vBBKW60JyPYRzXjia4Bnf25/kbTLB8Trx0Ej84tTsnmeololuvPuX3LZFH0ecYYqEs
         M5bg==
X-Gm-Message-State: AOAM533ej2yG1w1mrj8O6+QmPQKDSlicp2wlNsCDfsPNikpjR7n+rxmH
        3yotQkmQXi6c2wsALQY+NLo9lJQinfmfY1Wclqg=
X-Google-Smtp-Source: ABdhPJzubhJZqUrz7rlamhHpg26uiu7O5tWj/66gVCsSrNs4O2SM+SeL8FAYH6WyOODS6VmdwdYRsm8S8PsLGiSZlOQ=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr18077847qvb.196.1593488105100;
 Mon, 29 Jun 2020 20:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
 <20200630003441.42616-6-alexei.starovoitov@gmail.com> <CAEf4BzaH367tNd77puOvwrDHCeGqoNAHPYxdy4tXtWghXqyFSQ@mail.gmail.com>
 <20200630030653.fkgp43sz5gqi426y@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200630030653.fkgp43sz5gqi426y@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 20:34:54 -0700
Message-ID: <CAEf4BzZqWTdSOnko1g9HKiqzbD8_xL+4tN8znoaNO6suq_LbAQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/5] selftests/bpf: Add sleepable tests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 8:06 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 29, 2020 at 06:25:38PM -0700, Andrii Nakryiko wrote:
> >
> > > +
> > > +SEC("fentry.s/__x64_sys_setdomainname")
> > > +int BPF_PROG(test_sys_setdomainname, struct pt_regs *regs)
> > > +{
> > > +       int buf = 0;
> > > +       long ret;
> > > +
> > > +       ret = bpf_copy_from_user(&buf, sizeof(buf), (void *)regs->di);
> > > +       if (regs->si == -2 && ret == 0 && buf == 1234)
> > > +               copy_test++;
> > > +       if (regs->si == -3 && ret == -EFAULT)
> > > +               copy_test++;
> > > +       if (regs->si == -4 && ret == -EFAULT)
> > > +               copy_test++;
> >
> > regs->si and regs->di won't compile on non-x86 arches, better to use
> > PT_REGS_PARM1() and PT_REGS_PARM2() from bpf_tracing.h.
>
> the test is x86 only due to:
> +SEC("fentry.s/__x64_sys_setdomainname")

Right, but here I'm talking about compilation error because pt_regs
don't have si, di fields on other arches. __x64 just won't attach in
runtime, which is not a big deal if you are ignoring this particular
test.

>
> I guess we can move samples/bpf/trace_common.h into libbpf as well
> to clean the whole thing up. Something for later patches.

trace_common.h works only for the latest kernels. Before some version
(don't remember which version precisely), __x64 shouldn't be added.
Which makes this header not a good candidate for inclusion to libbpf.
BCC does this dynamically in runtime based on kallsyms, which I'm not
a big fan of doing as well. So let's punt trace_common.h for better
times :)
