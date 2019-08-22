Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBA09A3D6
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfHVXbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:31:50 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:38750 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfHVXbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:31:50 -0400
Received: by mail-io1-f48.google.com with SMTP id p12so15825673iog.5;
        Thu, 22 Aug 2019 16:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g5ev4YNyacCPm5TJniJ3SxphrLoEtQ+ucV5R5bFgZog=;
        b=kO48W3vzJvUqY9+qybTl957Id+ZSNxe0FLDIkqYWgzLeAV5FHgAGu2QDgOy5JiITDK
         NqfE4bAC8RUFCU4hRRUAJtWjLBZG56P3tOm2YclOQeWzlyfo6Uy9C+gwb1Id8W1hfypZ
         qROxLZj6YL19xuhnTyj9/wlmS+eMmjjAbt2dTOoUvMwIEP0+EMuHybogaQYSmZNCCIa1
         bZRtF5bAugZqmnlC1o8AllgKdYt5iV5IDedKt64ZlbBolu8iVSRjGYCUNozw2P1sB0yP
         d7ww/5C7Z0TTZNgSE4XRY9iENyX514brnwqWJldZiBh+eXszXyD4q7umb+nzVOZsh6dy
         ijmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g5ev4YNyacCPm5TJniJ3SxphrLoEtQ+ucV5R5bFgZog=;
        b=VYHbOCxnLvAWs9P+dnuiVPDbiYw4tgKAXgGO3Y6Yg3sqqBKnK1fu9+ZTL7NE2CsJHT
         sfSr7H7U0MReVa1ewU54ESQpDs3ABXhIXpPROKe1VVsvKCZEOoQI6NnLfRcI7J2X4qgt
         8pU2LMDLziTasEE0oIhVuxpNAzvRwMnPtqWjAyCfbiZRwaEkm9CFiXISDnBAdyvrA9cX
         4/HRlGNJUjQP5SMgc+E65N21XHEZK2WRU8pgyJ7nc9Vvfv62dsIF9tQNITfI+gIv7tMo
         Tcx3TbKNf8je46j9amMv5vm+S3OsrOlDeeKHxThNL3irinrMqlDjjK6Sx2HKnRM5NEVM
         NgXQ==
X-Gm-Message-State: APjAAAXlgArkkUOTYqQWiFXWFW+n+kraoTyI8KqGNlxITYUd8pH3OTYe
        jCTtJaGIteVOLYIuOKTFdDR1UmB1
X-Google-Smtp-Source: APXvYqwzhLctk149ll6mMhuP9SbwVeXiU3ERzqdFVfB57YGFcFm3A91KeZ7wSYWB02pl0/ycOfRneA==
X-Received: by 2002:a63:e148:: with SMTP id h8mr1399523pgk.275.1566516384818;
        Thu, 22 Aug 2019 16:26:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1070])
        by smtp.gmail.com with ESMTPSA id x10sm586643pjo.4.2019.08.22.16.26.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:26:24 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:26:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: Re: RFC: very rough draft of a bpf permission model
Message-ID: <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
 <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
 <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 08:17:54AM -0700, Andy Lutomirski wrote:
> BPF security strawman, v0.1
> 
> This is very rough.  Most of this, especially the API details, needs
> work before it's ready to implement.  The whole concept also needs
> review.
> 
> = Goals =
> 
> The overall goal is to make it possible to use eBPF without having
> what is effectively administrator access.  For example, an eBPF user
> should not be able to directly tamper with other processes (unless
> this permission is explicitly granted) and should not be able to
> read or write other users' eBPF maps.
> 
> It should be possible to use eBPF inside a user namespace without breaking
> the userns security model.
> 
> Due to the risk of speculation attacks and such being carried out via
> eBPF, it should not become possible to use too much of eBPF without the
> administrator's permission.  (NB: it is already possible to use
> *classic* BPF without any permission, and classic BPF is translated
> internally to eBPF, so this goal can only be met to a limited extent.)

agree with the goals.

> = Definitions =
> 
> Global capability: A capability bit in the caller's effective mask, so
> long as the caller is in the root user namespace.  Tasks in non-root
> user namespaces never have global capabilibies.  This is what capable()
> checks.
> 
> Namespace capability: A capability over a specific user namespace.
> Tasks in a user namespace have all the capabilities in their effective
> mask over their user namespace.  A namespace capability generally
> indicates that the capability applies to the user namespace itself and
> to all non-user namespaces that live in the user namespace.  For
> example, CAP_NET_ADMIN means that you can configure all networks
> namespaces in the current user namespace.  This is what ns_capable()
> checks.

definitions make sense too.

> Anything that requires a global capability will not work in a non-root
> user namespace.
> 
> = unprivileged_bpf_disabled =
> 
> Nothing in here supercedes unprivileged_bpf_disabled.  If
> unprivileged_bpf_disabled = 1, then these proposals should not allow anything
> that is disallowed today.  The idea is to make unprivileged_bpf_disabled=0
> both safer and more useful.

... a bunch of new features skipped for brevity...

You're proposing all of the above in addition to CAP_BPF, right?
Otherwise I don't see how it addresses the use cases I kept
explaining for the last few weeks.

I don't mind additional features if people who propose them
actively help to maintain that new code and address inevitable
side channel issues in the new code.
But first things first.

Here is another example of use case that CAP_BPF is solving:
The daemon X is started by pid=1 and currently runs as root.
It loads a bunch of tracing progs and attaches them to kprobes
and tracepoints. It also loads cgroup-bpf progs and attaches them
to cgroups. All progs are collecting data about the system and
logging it for further analysis.
There can be different bugs (not security bugs) in the daemon.
Simple coding bugs, but due to processing running as root they
may make the system inoperable. There is a strong desire to
drop privileges for this daemon. Let it do all BPF things the
way it does today and drop root, since other operations do not
require root.
Essentially a bunch of daemons run as root only because
they need bpf. This tracing bpf is looking into kernel memory
and using bpf_probe_read. Clearly it's not _secure_. But it's _safe_.
The system is not going to crash because of BPF,
but it can easily crash because of simple coding bugs in the user
space bits of that daemon.

Flagging functions is not going to help this case.
bpf_probe_read is necessary.
pointer-to-integer-conversions is also necessary.
bypass hardening features is also necessary for speed,
since this data collection is 24/7.
cgroup.subtree_control idea can help some of it, but not all.

I still think that CAP_BPF is the best way to split this root privilege
universe into smaller 'bpf piece'. Just like CAP_NET_ADMIN splits
all of root into networking specific privileges.

Potentially we can go sysctl_perf_event_paranoid approach, but
it's less flexible, since it's single sysctl for the whole system.

Loading progs via FD instead of memory is something that android folks
proposed some time ago. The need is real. Whether it's going to be
loading via FD or some other form of signing the program is TBD.
imo this is orthogonal.

I hope I answered all points of your proposal.

