Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9F9B8BA
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfHWXJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfHWXJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:09:25 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6076D233A0
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 23:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566601764;
        bh=c+BSqu55NOe8BN0wFq51LG6Xu6UzGAqyajR5Ji/T+Yk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2f9S8qR6siG8TgkvVCeyCQ8lZy/+kYqjEduMqoEbEZyEibOFEcTCYyYMRChAscuz4
         gmZDT+MKjokJ8TdYx3W5peE3KCWUpmkmWzap+uF7VSvn6Tl5w44Cx7BE5yYQ1+9z+d
         h4QHrwoB1zRHk8Oz44gfquJe3qpsSy3OB/F1FX6k=
Received: by mail-wm1-f45.google.com with SMTP id i63so10511313wmg.4
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 16:09:24 -0700 (PDT)
X-Gm-Message-State: APjAAAWTliw16zSjdirVKuW50yxcdbn5P333cvHhxikqnHJtlw4+9+oz
        lStu4upJzDJ5RqUcfgp+MB81b+9fPZISrQ4toftWSw==
X-Google-Smtp-Source: APXvYqwwcJBEap+ZL6rU6I3mFF6i9jKrRW0N8Rc1w0rr1BOiYTRF/I11PjzMtWPy6dqcP+KKv4pJFU6/k8TaBp37wyk=
X-Received: by 2002:a1c:c5c2:: with SMTP id v185mr8147746wmf.161.1566601762747;
 Fri, 23 Aug 2019 16:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net> <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
 <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com> <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 23 Aug 2019 16:09:11 -0700
X-Gmail-Original-Message-ID: <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com>
Message-ID: <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com>
Subject: Re: RFC: very rough draft of a bpf permission model
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 4:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> You're proposing all of the above in addition to CAP_BPF, right?
> Otherwise I don't see how it addresses the use cases I kept
> explaining for the last few weeks.

None of my proposal is intended to exclude changes like CAP_BPF to
make privileged bpf() operations need less privilege.  But I think
it's very hard to evaluate CAP_BPF without both a full description of
exactly what CAP_BPF would do and what at least one full example of a
user would look like.

I also think that users who want CAP_BPF should look at manipulating
their effective capability set instead.  A daemon that wants to use
bpf() but otherwise minimize the chance of accidentally causing a
problem can use capset() to clear its effective and inheritable masks.
Then, each time it wants to call bpf(), it could re-add CAP_SYS_ADMIN
or CAP_NET_ADMIN to its effective set, call bpf(), and then clear its
effective set again.  This works in current kernels and is generally
good practice.

Aside from this, and depending on exactly what CAP_BPF would be, I
have some further concerns.  Looking at your example in this email:

> Here is another example of use case that CAP_BPF is solving:
> The daemon X is started by pid=1 and currently runs as root.
> It loads a bunch of tracing progs and attaches them to kprobes
> and tracepoints. It also loads cgroup-bpf progs and attaches them
> to cgroups. All progs are collecting data about the system and
> logging it for further analysis.

This needs more than just bpf().  Creating a perf kprobe event
requires CAP_SYS_ADMIN, and without a perf kprobe event, you can't
attach a bpf program.  And the privilege to attach bpf programs to
cgroups without any DAC or MAC checks (which is what the current API
does) is an extremely broad privilege that is not that much weaker
than CAP_SYS_ADMIN or CAP_NET_ADMIN.  Also:

> This tracing bpf is looking into kernel memory
> and using bpf_probe_read. Clearly it's not _secure_. But it's _safe_.
> The system is not going to crash because of BPF,
> but it can easily crash because of simple coding bugs in the user
> space bits of that daemon.

The BPF verifier and interpreter, taken in isolation, may be extremely
safe, but attaching BPF programs to various hooks can easily take down
the system, deliberately or by accident.  A handler, especially if it
can access user memory or otherwise fault, will explode if attached to
an inappropriate kprobe, hw_breakpoint, or function entry trace event.
(I and the other maintainers consider this to be a bug if it happens,
and we'll fix it, but these bugs definitely exist.)  A cgroup-bpf hook
that blocks all network traffic will effectively kill a machine,
especially if it's a server.  A bpf program that runs excessively
slowly attached to a high-frequency hook will kill the system, too.
(I bet a buggy bpf program that calls bpf_probe_read() on an unmapped
address repeatedly could be make extremely slow.  Page faults take
thousands to tens of thousands of cycles.)  A bpf firewall rule that's
wrong can cut a machine off from the network -- I've killed machines
using iptables more than once, and bpf isn't magically safer.

Something finer-grained can mitigate some of this.  CAP_BPF as I think
you're imagining it will not.

I'm wondering if something like CAP_TRACING would make sense.
CAP_TRACING would allow operations that can reveal kernel memory and
other secret kernel state but that do not, by design, allow modifying
system behavior.  So, for example, CAP_TRACING would allow privileged
perf_event_open() operations and privileged bpf verifier usage.  But
it would not allow cgroup-bpf unless further restrictions were added,
and it would not allow the *_BY_ID operations, as those can modify
other users' bpf programs' behavior.

(To get CAP_TRACING to work with cgroup-bpf, there could be a flag to
attach a "tracing" bpf program to a cgroup.  This program would run in
addition to normal or MULTI programs, but it would not be allowed to
return a rejection result.)
