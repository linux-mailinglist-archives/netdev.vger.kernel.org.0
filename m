Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD339C42E
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 02:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFEAKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 20:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFEAKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 20:10:45 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1537C061766;
        Fri,  4 Jun 2021 17:08:41 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a2so16514627lfc.9;
        Fri, 04 Jun 2021 17:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7O4yi6cn6gBER8XX7UVPJXE8JpTGO2BmTJOk3c1YezY=;
        b=lONezNtAYZiUSr1iYLLF2FAFUQSyPAyKMiOyNd4PyFlEEnMeuQSfMC3kgd+j+4lyji
         fB5o3HzOIrLuUbRM74zkvm4Lt68gJ2bu5r4E/DIf+13z01pKiEq2BtEUXGB73MKFTX3w
         OEDOrkvwgTp9wS6cLO57bDvnaiRV8YFGvYrFASu3FMK79mLc02KdHb6y+LVIDrnO6QKw
         OSuOcAHiocCmla4RrGF0uChppDDsJ5qc8sbiJuIE4IFOCKqw+6XUleMpLHNKKl40lPFC
         3RjG+nHOzqrsTla4+yu4BnwK2TNFFsAS5jni8Dx5cVESEw7yHiVvjBYtk2QSO39BkQ7e
         wgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7O4yi6cn6gBER8XX7UVPJXE8JpTGO2BmTJOk3c1YezY=;
        b=dvBbrvd6DRAvLd0X/ulF/IXJg7JVPaDLFRYtlkOhr3JdilQEqrIZriNMTIMX94zm6d
         NpKNwTLGvypNYiNM6hqvfPdV6W5mQWSGJBvz4cQl1R4mzRjlosZ/mB5HbURyFvJc6c2J
         5ny1ShcixfrqIlAjf/eVAk7A721VUrneF+NB4zHyitavLxoduKXzenDn89VGrvQwEw2+
         tcW7d2V3u5xDEBoYdGYd2NUSiDtahVDlRcy3G+yvFVs2BELxxMQOAy+LpkIgrAGDMVz9
         gwOzsCia8zjjEjeGegrFFsx9zUr8l/7V8NRsOPcJKqqb2RQvOKGRkde33fgtoWjRy+ks
         B5RQ==
X-Gm-Message-State: AOAM533VJlS/9jE4YjhS7Kps3jNjdhkHxXbnMwZhg+7l/ThFUUX5wGSX
        4COUzwcHoZvylUKG/OgM5lfAWS3Xo3VWR0N7nbA=
X-Google-Smtp-Source: ABdhPJyE/AGEeMxwVpH/EFqVAUdh2yIubA70g70dg+zntH7F/uX+weKdCYbLk357XbEMR55n50qHL7nDnccDNBTMu8k=
X-Received: by 2002:a05:6512:3c91:: with SMTP id h17mr4482345lfv.214.1622851715688;
 Fri, 04 Jun 2021 17:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net> <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net> <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net> <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net> <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
 <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net> <CAHC9VhT1JhdRw9P_m3niY-U-vukxTWKTE9q6AMyQ=r_ohpPxMw@mail.gmail.com>
In-Reply-To: <CAHC9VhT1JhdRw9P_m3niY-U-vukxTWKTE9q6AMyQ=r_ohpPxMw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Jun 2021 17:08:24 -0700
Message-ID: <CAADnVQ+0bNtDj46Q8s-h=rqJgZz2JaGTeHpbmof3e7fBBQKuDQ@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Paul Moore <paul@paul-moore.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 4, 2021 at 4:34 PM Paul Moore <paul@paul-moore.com> wrote:
>
> > Again, the problem is not limited to BPF at all. kprobes is doing register-
> > time hooks which are equivalent to the one of BPF. Anything in run-time
> > trying to prevent probe_read_kernel by kprobes or BPF is broken by design.
>
> Not being an expert on kprobes I can't really comment on that, but
> right now I'm focused on trying to make things work for the BPF
> helpers.  I suspect that if we can get the SELinux lockdown
> implementation working properly for BPF the solution for kprobes won't
> be far off.

Paul,

Both kprobe and bpf can call probe_read_kernel==copy_from_kernel_nofault
from all contexts.
Including NMI. Most of audit_log_* is not acceptable.
Just removing a wakeup is not solving anything.
Audit hooks don't belong in NMI.
Audit design needs memory allocation. Hence it's not suitable
for NMI and hardirq. But kprobes and bpf progs do run just fine there.
BPF, for example, only uses pre-allocated memory.
