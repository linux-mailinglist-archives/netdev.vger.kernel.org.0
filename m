Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F59843A6
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfHGFYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfHGFYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 01:24:39 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 219F621880
        for <netdev@vger.kernel.org>; Wed,  7 Aug 2019 05:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565155478;
        bh=CjuQgL09pQH6XikSknVDOW+uxXrr2z62KM9ggjnnPag=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hM4kZYk74xC358c7QYNpNu7qK6yiYjEsC953rGv5mWne6TQZuJAH8AAkj/2zlvxD0
         MwcNCHNEqs4PitehLGOYGZcNNxCb17UyKJfL5rnkW0wdpaMHOwhe4jBkmxs7NqXzAb
         1PhAstqqCkZvlNYaDbuPkKwAdwjUamzlMgNFL2Ik=
Received: by mail-wr1-f45.google.com with SMTP id p17so89972108wrf.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 22:24:38 -0700 (PDT)
X-Gm-Message-State: APjAAAX/D2GoXzfg0aPWe7/FAzEMeq9XbvoVRaQJO7QLMFDEblI1FypO
        +RzK1GSFT49Kupta6goO355CMF1rMj7OHLx3TDWAaw==
X-Google-Smtp-Source: APXvYqw7hE1TmqQ9Y5v5Hspi4JaeP11sWfX0sgjg8zNAco0JPNqFazXPgW+OhkVJ4WOiIV/lXoUyQfSnQrqfM95Kzm8=
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr7721712wrm.265.1565155476577;
 Tue, 06 Aug 2019 22:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
In-Reply-To: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 6 Aug 2019 22:24:25 -0700
X-Gmail-Original-Message-ID: <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
Message-ID: <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 6:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 05, 2019 at 02:25:35PM -0700, Andy Lutomirski wrote:
> > It tries to make the kernel respect the access modes for fds.  Without
> > this patch, there seem to be some holes: nothing looked at program fds
> > and, unless I missed something, you could take a readonly fd for a
> > program, pin the program, and reopen it RW.
>
> I think it's by design. iirc Daniel had a use case for something like this.

That seems odd.  Daniel, can you elaborate?

> Hence unprivileged bpf is actually something that can be deprecated.

I hope not.  There are a couple setsockopt uses right now, and and
seccomp will surely want it someday.  And the bpf-inside-container use
case really is unprivileged bpf -- containers are, in many (most?)
cases, explicitly not trusted by the host.  But regardless, see below.

> > The ability to obtain an fd to a cgroup does *not* imply any right to
> > modify that cgroup.  The ability to write to a cgroup directory
> > already means something else -- it's the ability to create cgroups
> > under the group in question.  I'm suggesting that a new API be added
> > that allows attaching a bpf program to a cgroup without capabilities
> > and that instead requires write access to a new file in the cgroup
> > directory.  (It could be a single file for all bpf types or one file
> > per type.  I prefer the latter -- it gives the admin finer-grained
> > control.)
>
> This is something to discuss. I don't mind something like this,
> but in general bpf is not for untrusted users.
> Hence I don't want to overdesign.

I think the code would end up being extremely simple.  It would be an
ABI change, but I think that it could easily be arranged so that new
and old libbpf would be fully functional on new and old kernels except
that only new libbpf with a new kernel would be able to attach cgroup
programs without privilege.  I see no reason to remove the current
cgroup attach API.

> See https://github.com/systemd/systemd/blob/01234e1fe777602265ffd25ab6e73823c62b0efe/src/core/bpf-firewall.c#L671-L674
> bpf based IP sandboxing doesn't work in 'systemd --user'.
> That is just one of the problems that people complained about.

This isn't privilege *dropping* -- this is not having privilege in the
first place.  Giving systemd --user unrestricted use of bpf() is
tantamount to making the user root.  But again, see below.

>
> Inside containers and inside nested containers we need to start processes
> that will use bpf. All of the processes are trusted.

Trusted by whom?  In a non-nested container, the container manager
*might* be trusted by the outside world.  In a *nested* container,
unless the inner container management is controlled from outside the
outer container, it's not trusted.  I don't know much about how
Facebook's containers work, but the LXC/LXD/Podman world is moving
very strongly toward user namespaces and maximally-untrusted
containers, and I think bpf() should work in that context.

> To solve your concern of bypassing all capable checks...
> How about we do /dev/bpf/full_verifier first?
> It will replace capable() checks in the verifier only.

I'm not convinced that "in the verifier" is the right distinction.
Telling administrators that some setting lets certain users bypass
bpf() verifier checks doesn't have a clear enough meaning.  I propose,
instead, that the current capable() checks be divided into three
categories:

a) Those that, by design, control privileged operations.  This
includes most attach calls, but it also includes allow_ptr_leaks,
bpf_probe_read(), and quite a few other things.  It also includes all
of the by_id calls, I think, unless some clever modification to the
way they worked would isolate different users' objects.  I think that
persistent objects can do pretty much everything that by_id users
would need, so this isn't a big deal.

b) Those that protect code that is considered to be at higher risk of
exposing security bugs.  In other words, these are things that would
have no need for privilege if we could prove that the implementation
was perfect.  This includes bpf2bpf, LPM, etc.

c) Those that serve to prevent excessive resource usage.  This
includes the bounded loop code (I think -- this might also be category
(b)) and several explicit checks for program size.

I suppose that the speculative execution mitigation stuff could be
split out from (b) into its own category.

Based on this, how about a different division: /dev/bpf_dangerous for
(b) and /dev/bpf_resources for (c)?  And (a) is dealt with by
gradually reducing the privilege needed for the important operations.
/dev/bpf_dangerous isn't ideal in the long run though, since a lot of
the operations in that category will probably become less dangerous as
the code is better vetted, and people granting "dangerous" permission
might want to restrict it to only the specific parts that they need.
/dev/bpf_lpm, /dev/bpf2bpf, etc could work better.

This type of thing actually fits quite nicely into an idea I've been
thinking about for a while called "implicit rights". In very brief
summary, there would be objects called /dev/rights/xyz, where xyz is
the same of a "right".  If there is a readable object of the right
type at the literal path "/dev/rights/xyz", then you have right xyz.
There's a bit more flexibility on top of this.  BPF could use
/dev/rights/bpf/maptypes/lpm and
/dev/rights/bpf/verifier/bounded_loops, for example.  Other non-BPF
use cases include a biggie:
/dev/rights/namespace/create_unprivileged_userns.
/dev/rights/bind_port/80 would be nice, too.

I may have a bit of time over the next few days to actually prototype
this.  Would you be interested in using this for BPF?
