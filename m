Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578AF71B24
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390478AbfGWPLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388428AbfGWPLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 11:11:31 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6060227B7
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563894689;
        bh=7j1bpwOtchxmNmpyJwIt/hzbvJKG5hZjfYmVjkpnc/I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rFXu+sTWkD/54l70rzbB+dUx4OauzntmqViEq/zcU2+O2D80EbxIRyrdyerywJBPR
         GMQvKxx0TIk1MtBG6b+6ZDNsBtjkbPRapdXfPScETmsEK2q2YZ3dEN6eSPfAjq4FJT
         VHnBzKNRB2zBoAYaJX2rLGp9Ssx4hmHZO0EFuVMY=
Received: by mail-wr1-f53.google.com with SMTP id y4so43612572wrm.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 08:11:28 -0700 (PDT)
X-Gm-Message-State: APjAAAVvs4UOXrtUaJkgB61G8AmMVFx2hkSn+JGhjz63KVR7TcWSpT0j
        E5BsFGsz1Mn+abUYfuYxypfyMCMAIhcVxM0ZIsxoog==
X-Google-Smtp-Source: APXvYqx2W1npMbyvmugkZS82BmvrcI+iJu+ihy6mqs7TXZ2QycMn1wC9RACywYA+kE8/OO3iaRcMH0r6tsUUtWyiHXE=
X-Received: by 2002:adf:cf02:: with SMTP id o2mr62485122wrj.352.1563894687396;
 Tue, 23 Jul 2019 08:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
In-Reply-To: <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 23 Jul 2019 08:11:15 -0700
X-Gmail-Original-Message-ID: <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
Message-ID: <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 1:54 PM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy, Lorenz, and all,
>
> > On Jul 2, 2019, at 2:32 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:
> >>
> >> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
> >>> I think I'm understanding your motivation.  You're not trying to make
> >>> bpf() generically usable without privilege -- you're trying to create
> >>> a way to allow certain users to access dangerous bpf functionality
> >>> within some limits.
> >>>
> >>> That's a perfectly fine goal, but I think you're reinventing the
> >>> wheel, and the wheel you're reinventing is quite complicated and
> >>> already exists.  I think you should teach bpftool to be secure when
> >>> installed setuid root or with fscaps enabled and put your policy in
> >>> bpftool.  If you want to harden this a little bit, it would seem
> >>> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
> >>> not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
> >>> capabilities that they currently check.
> >>
> >> If finer grained controls are wanted, it does seem like the /dev/bpf
> >> path makes the most sense. open, request abilities, use fd. The open can
> >> be mediated by DAC and LSM. The request can be mediated by LSM. This
> >> provides a way to add policy at the LSM level and at the tool level.
> >> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owned
> >> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
> >> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
> >>
> >> With only a new CAP, you don't get the fine-grained controls. (The
> >> "request abilities" part is the key there.)
> >
> > Sure you do: the effective set.  It has somewhat bizarre defaults, but
> > I don't think that's a real problem.  Also, this wouldn't be like
> > CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.
> >
> > I think that a /dev capability-like object isn't totally nuts, but I
> > think we should do it well, and this patch doesn't really achieve
> > that.  But I don't think bpf wants fine-grained controls like this at
> > all -- as I pointed upthread, a fine-grained solution really wants
> > different treatment for the different capable() checks, and a bunch of
> > them won't resemble capabilities or /dev/bpf at all.
>
> With 5.3-rc1 out, I am back on this. :)
>
> How about we modify the set as:
>   1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.

I'm fine with this in principle, but:

>   2. Better handling of capable() calls through bpf code. I guess the
>      biggest problem here is is_priv in verifier.c:bpf_check().

I think it would be good to understand exactly what /dev/bpf will
enable one to do.  Without some care, it would just become the next
CAP_SYS_ADMIN: if you can open it, sure, you're not root, but you can
intercept network traffic, modify cgroup behavior, and do plenty of
other things, any of which can probably be used to completely take
over the system.

It would also be nice to understand why you can't do what you need to
do entirely in user code using setuid or fscaps.

Finally, at risk of rehashing some old arguments, I'll point out that
the bpf() syscall is an unusual design to begin with.  As an example,
consider bpf_prog_attach().  Outside of bpf(), if I want to change the
behavior of a cgroup, I would write to a file in
/sys/kernel/cgroup/unified/whatever/, and normal DAC and MAC rules
apply.  With bpf(), however, I just call bpf() to attach a program to
the cgroup.  bpf() says "oh, you are capable(CAP_NET_ADMIN) -- go for
it!".  Unless I missed something major, and I just re-read the code,
there is no check that the caller has write or LSM permission to
anything at all in cgroupfs, and the existing API would make it very
awkward to impose any kind of DAC rules here.

So I think it might actually be time to repay some techincal debt and
come up with a real fix.  As a less intrusive approach, you could see
about requiring ownership of the cgroup directory instead of
CAP_NET_ADMIN.  As a more intrusive but perhaps better approach, you
could invert the logic to to make it work like everything outside of
cgroup: add pseudo-files like bpf.inet_ingress to the cgroup
directories, and require a writable fd to *that* to a new improved
attach API.  If a user could do:

int fd = open("/sys/fs/cgroup/.../bpf.inet_attach", O_RDWR);  /* usual
DAC and MAC policy applies */
int bpf_fd = setup the bpf stuff;  /* no privilege required, unless
the program is huge or needs is_priv */
bpf(BPF_IMPROVED_ATTACH, target = fd, program = bpf_fd);

there would be no capabilities or global privilege at all required for
this.  It would just work with cgroup delegation, containers, etc.

I think you could even pull off this type of API change with only
libbpf changes.  In particular, there's this code:

int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
                    unsigned int flags)
{
        union bpf_attr attr;

        memset(&attr, 0, sizeof(attr));
        attr.target_fd     = target_fd;
        attr.attach_bpf_fd = prog_fd;
        attr.attach_type   = type;
        attr.attach_flags  = flags;

        return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
}

This would instead do something like:

int specific_target_fd = openat(target_fd, bpf_type_to_target[type], O_RDWR);
attr.target_fd = specific_target_fd;
...

return sys_bpf(BPF_PROG_IMPROVED_ATTACH, &attr, sizeof(attr));

Would this solve your problem without needing /dev/bpf at all?

--Andy
