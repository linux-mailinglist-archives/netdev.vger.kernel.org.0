Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC66826CC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHEVZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbfHEVZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:25:51 -0400
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D11AF21871
        for <netdev@vger.kernel.org>; Mon,  5 Aug 2019 21:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040349;
        bh=+l9DehNASVoHn7djt3L6uVYbYDlaLXDdNHQeIZZo8xc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OQVKv9lzZKgh82WYkAe44Rnp+YhYsJHtn2fUeYzCGK4a/7O8Jr8SmHFFAuoLePiiN
         MKOZQfYkkQhIGzC9Wt4UbcJMSKr2tD+L336UyDQhRrvHf8ffOA6mt3pkk69QliFL/n
         cnaeJqkO4ah4YbOXF3UpMUp5sADVhWov2LL3LOPs=
Received: by mail-wm1-f50.google.com with SMTP id x15so76110005wmj.3
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 14:25:48 -0700 (PDT)
X-Gm-Message-State: APjAAAUzm5Ggx5AolAdACdZhs3xn1FSdIpJMk8ZPE+caE7WWNuG9TmHJ
        7YUxR//rXMyOJZUIqYPgLZMHhLQFWgs6mABr6Wg0gw==
X-Google-Smtp-Source: APXvYqzFmdYo1bPO8hahvT0VMTYu4BljtES3SsxDIoELVojqSWyuT5f88uBp6bUJpn1BQdF4K0+mRu0b2FIuVYlVBzI=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr222170wme.173.1565040347104;
 Mon, 05 Aug 2019 14:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com> <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
In-Reply-To: <20190805192122.laxcaz75k4vxdspn@ast-mbp>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 5 Aug 2019 14:25:35 -0700
X-Gmail-Original-Message-ID: <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
Message-ID: <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
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

On Mon, Aug 5, 2019 at 12:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 05, 2019 at 10:23:10AM -0700, Andy Lutomirski wrote:
> >
> > I refreshed the branch again.  I had a giant hole in my previous idea
> > that we could deprivilege program loading: some BPF functions need
> > privilege.  Now I have a changelog comment to that effect and a patch
> > that sketches out a way to addressing this.
> >
> > I don't think I'm going to have time soon to actually get any of this
> > stuff mergeable, and it would be fantastic if you or someone else who
> > likes working of bpf were to take this code and run with it.  Feel
> > free to add my Signed-off-by, and I'd be happy to help review.
>
> Thanks a lot for working on patches and helping us with the design!
>
> Can you resend the patches to the mailing list?
> It's kinda hard to reply/review to patches that are somewhere in the web.

Will do.

> I'm still trying to understand the main idea.
> If I'm reading things correctly:

The series doesn't, strictly speaking, have an overall problem that it
solves.  It's a series of steps in the direction of making bpf() make
more sense without privilege and toward reducing the required
privilege.

> patch 1 "add access permissions to bpf fds"
>   just passes the flags ?

It tries to make the kernel respect the access modes for fds.  Without
this patch, there seem to be some holes: nothing looked at program fds
and, unless I missed something, you could take a readonly fd for a
program, pin the program, and reopen it RW.

> patch 2 "Don't require mknod() permission to pin an object"
>  makes sense in isolation.

It makes even more sense now :)

> patch 3 "Allow creating all program types without privilege"
>   is not right.

I think it can be made right, which is the point.

> patch 4 "Add a way to mark functions as requiring privilege"
>  is an interesting idea, but I don't think it helps that much.

Other than the issue that this patch partially fixes, can you see any
reason that loading a program should require privilege?  Obviously the
verifier is weakened a bit when called by privileged users, but a lot
of that is about excessive resource usage and various less-well-tested
features.  It seems to me that most of the value of bpf() should be
available to programs that should not need privilege to load.  Are
there things I'm missing?

>
> So the main thing we're trying to solve with augmented bpf syscall
> and/or /dev/bpf is to be able to use root-only features of bpf when
> trused process already dropped root permissions.
> These features include bpf2bpf calls, bounded loops, special maps (like LPM), etc.

Can you elaborate on all these:

I see nothing inherently wrong with bpf2bpf for unprivileged users as
long as they have appropriate access to the called program.  Patch 1
improves that.

Bounded loops: if they are adequately well verified, then the only
damage is that they can make bpf progs that run slowly, right?  It
seems like some kind of capability or sysctl for "allow using lots of
bpf resources" would do the trick.  This could even be a cgroup
setting -- bpf resources aren't all that different from any other
resource.

LPM: I don't see why this requires privilege at all.  It indeed checks
capable(CAP_SYS_ADMIN), but I don't see why.

>
> Attaching to a cgroup already has file based permission checks.
> The user needs to open cgroup directory to attach.
> acls on cgroup dir can already be used to prevent attaching to
> certain parts of cgroup hierarchy.

The current checks seem inadequate.

$ echo 'yay' </sys/fs/cgroup/systemd/system.slice/

The ability to obtain an fd to a cgroup does *not* imply any right to
modify that cgroup.  The ability to write to a cgroup directory
already means something else -- it's the ability to create cgroups
under the group in question.  I'm suggesting that a new API be added
that allows attaching a bpf program to a cgroup without capabilities
and that instead requires write access to a new file in the cgroup
directory.  (It could be a single file for all bpf types or one file
per type.  I prefer the latter -- it gives the admin finer-grained
control.)

> What we need is to drop privileges sooner in daemons like systemd.

This is doable right now: systemd could fork off a subprocess and
delegate its cgroup operations to it.  It would be maybe a couple
hundred lines of code.  As an added benefit, that subprocess could
verify that the bpf operations in question are reasonable.
Alternatively, if there was a CAP_BPF_ADMIN, systemd could retain that
capability and flip it on and off as needed.

> Container management daemon runs in the nested containers.
> These trusted daemons need to have access to full bpf, but they
> don't want to be root all the time.
> They cannot flip back and forth via seteuid to root every time they
> need to do bpf.
> Hence the idea is to have a file that this daemon can open,
> then drop privileges and still keep doing bpf things because FD is held.
> Outer container daemon can pass this /dev/bpf's FD to inner daemon, etc.
> This /dev/bpf would be accessible to root only.
> There is no desire to open it up to non-root.

This seems extremely dangerous right now.  A program that can bypass
*all* of the capable() checks in bpf() can do a whole lot.  Among
other things, it can read all of kernel memory.  It can very likely
gain full system root by appropriate installation of malicious
programs in a cgroup that contains fully privileged programs.  In this
regard, bpf() is like most of the Linux capabilities -- it seems
somewhat limited, but it really implies a lot of privilege.  There was
a little paper awhile back pointing out that, on a normal system, most
of the Linux capabilities were functionally equivalent.

>
> It seems there is concern that /dev/bpf is unnecessary special.
> How about we combine bpffs and /dev/bpf ideas?
> Like we can have a special file name in bpffs.
> The root would do 'touch /sys/fs/bpf/privileges' and it would behave
> just like /dev/bpf, but now it can be in any bpffs directory and acls
> to bpffs mount would work as-is.

This seems to have most of the same problems.  My main point is that
it conflates a whole lot of different permissions, and I really don't
think it's that much work to mostly disentangle the permissions in
question.  My little series (if completed) plus a patch to allow
unprivileged cgroup attach operations if you have an FMODE_WRITE fd to
an appropriate file should get most of the way there.

Also, be careful about your bpffs idea: bpffs is (sort of) namespaced,
and it would make sense to allow new bpf instances to be created
inside unprivileged user namespaces.  Such instances should not be
able to create magical privilege-granting files.  In that respect,
/dev/bpf is better.

>
> CAP_BPF is also good idea. I think for the enviroment where untrusted
> and unprivileged users want to run 'bpftrace' that would be perfect mechanism.
> getcap /bin/bpftrace would have cap_bpf, cap_kprobe and whatever else.
> Sort of like /bin/ping.
> But I don't see how cap_bpf helps to solve our trusted root daemon problem.
> imo open ("/sys/fs/bpf/privileges") and pass that FD into bpf syscall
> is the only viable mechanism.
>

As above, I think that forking before dropping privileges and asking
the child to do the bpf() operations is safer and more flexible.

> Note the verifier does very different amount of work for unpriv vs root.
> It does speculative execution analysis, pointer leak checks for unpriv.
> So we gotta pass special flag to the verifier to make it act like it's
> loading a program for root.
>

Indeed.  And programs in untrusted containers should not be able to do this.
