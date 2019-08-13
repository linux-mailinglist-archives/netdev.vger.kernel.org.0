Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD998C400
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfHMV63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:58:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43303 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfHMV63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:58:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so42826609pld.10;
        Tue, 13 Aug 2019 14:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Q+5s20XHMc4iuRDKXdxpzS8kzsfDj5amerE2E4kpDU=;
        b=l/O31lke/LzDTPiubFahE36gGH9b7sra9UhQHBhE9dvYDQQDTH/b2l9ICZlbOngeiG
         TegryTsW14+xSSlKqxEJGRUqgLx5Ojuqjzmtd6k9b0DMbr12e7DukO6cgtuKp9DWAGP+
         hDB/+hGRyZah8sgYEeRYbDdU57uOIysYAP85b8dFxN1CbbOJiqNCj//SyJrwXRe8z3Tq
         UmjdunPkhf52DO4F8QMLiESq+I3VHo6ECaDvHm3QxoLmlfHGe/pqPEYsy9y5JkrOBhOr
         6iJJuQ7Dc67i3mai1CfK253Jb5OjmxmkTwQE8W6bSSt5ccQS8oFdMfXb/m6FNLEHV9sg
         7lNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Q+5s20XHMc4iuRDKXdxpzS8kzsfDj5amerE2E4kpDU=;
        b=W3QQj6zIydED18e48pnR66RyYxq0Y/rLn7Szy/2rWKqcTAYA0+KuK7uLaRHV659n8U
         4bgbzP5LtlgQhzHglQujtWZr1UiBhJSzxOuYIrmUEJ+GUeUzAf7gLEjfh8cYItrWzddq
         ZTOASATqz4TieK8jOa4/N6fGwMvqAZJoj2pBAIosx8Blea5Q6ExObSqX2W83UZ5aq+FF
         G8PTF4dH5yeS5ZxQA1q/wIahzwHoAPJvZPbv5oIuRw+6j46tWgFmlDn9I0DMGC0AjHwU
         fnpwmOHmVsESbA1hgOjHUF2QkMtpdULt2eLqk+/0qBberx+F2J6QBNBZocv7sYI2C8OP
         4aEw==
X-Gm-Message-State: APjAAAUctdp5l7nAE0YGC3DkynF/+FlnEZrnnJP0vnhNUTN4X+w8Txzh
        V5AfWoPXtPUFBr4M7SOuU/E=
X-Google-Smtp-Source: APXvYqxjiUmkl64G1tHSx+VC7+PCJACU5FiOcdV5TIbEkpKvm5x6v5eoIGUfB+eF3IlCJYHKUNBV0Q==
X-Received: by 2002:a17:902:9889:: with SMTP id s9mr11519716plp.100.1565733508159;
        Tue, 13 Aug 2019 14:58:28 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:8a34])
        by smtp.gmail.com with ESMTPSA id t6sm35037435pgu.23.2019.08.13.14.58.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:58:27 -0700 (PDT)
Date:   Tue, 13 Aug 2019 14:58:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190813215823.3sfbakzzjjykyng2@ast-mbp>
References: <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 10:24:25PM -0700, Andy Lutomirski wrote:
> >
> > Inside containers and inside nested containers we need to start processes
> > that will use bpf. All of the processes are trusted.
> 
> Trusted by whom?  In a non-nested container, the container manager
> *might* be trusted by the outside world.  In a *nested* container,
> unless the inner container management is controlled from outside the
> outer container, it's not trusted.  I don't know much about how
> Facebook's containers work, but the LXC/LXD/Podman world is moving
> very strongly toward user namespaces and maximally-untrusted
> containers, and I think bpf() should work in that context.

agree that containers (namespaces) reduce amount of trust necessary
for apps to run, but the end goal is not security though.
Linux has become a single user system.
If user can ssh into the host they can become root.
If arbitrary code can run on the host it will be break out of any sandbox.
Containers are not providing the level of security that is enough
to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.
Containers are used to make production systems safer.
Some people call it more 'secure', but it's clearly not secure for
arbitrary code and that is what kernel.unprivileged_bpf_disabled allows.
When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
It's been a constant source of pain. The constant blinding, randomization,
verifier speculative analysis, all spectre v1, v2, v4 mitigations
are simply not worth it. It's a lot of complex kernel code without users.
There is not a single use case to allow arbitrary malicious bpf
program to be loaded and executed.
As soon as we have /dev/bpf to allow all of bpf to be used without root
we will set sysctl kernel.unprivileged_bpf_disabled=1
Hence I prefer this /dev/bpf mechanism to be as simple a possible.
The applications that will use it are going to be just as trusted as systemd.

> > To solve your concern of bypassing all capable checks...
> > How about we do /dev/bpf/full_verifier first?
> > It will replace capable() checks in the verifier only.
> 
> I'm not convinced that "in the verifier" is the right distinction.
> Telling administrators that some setting lets certain users bypass
> bpf() verifier checks doesn't have a clear enough meaning.  

linux is a single user system. there are no administrators any more.
No doubt, folks will disagree, but that game is over.
At least on bpf side it's done.

> I propose,
> instead, that the current capable() checks be divided into three
> categories:

I don't see a use case for these categories.
All bpf programs extend the kernel in some way.
The kernel vs user is one category.
Conceptually CAP_BPF is enough. It would be similar to CAP_NET_ADMIN.
When application has CAP_NET_ADMIN it covers all of networking knobs.
There is no use case that would warrant fine grain CAP_ROUTE_ADMIN,
CAP_ETHTOOL_ADMIN, CAP_ETH0_ADMIN, etc.
Similarly CAP_BPF as the only knob is enough.
The only disadvantage of CAP_BPF is that it's not possible to
pass it from one systemd-like daemon to another systemd-like daemon.
Hence /dev/bpf idea and passing file descriptor.

> This type of thing actually fits quite nicely into an idea I've been
> thinking about for a while called "implicit rights". In very brief
> summary, there would be objects called /dev/rights/xyz, where xyz is
> the same of a "right".  If there is a readable object of the right
> type at the literal path "/dev/rights/xyz", then you have right xyz.
> There's a bit more flexibility on top of this.  BPF could use
> /dev/rights/bpf/maptypes/lpm and
> /dev/rights/bpf/verifier/bounded_loops, for example.  Other non-BPF
> use cases include a biggie:
> /dev/rights/namespace/create_unprivileged_userns.
> /dev/rights/bind_port/80 would be nice, too.

The concept of "implicit rights" is very nice and I'm sure it will
be a good fit somewhere, but I don't see why use it in bpf space.
There is no use case for fine grain partition of bpf features.

