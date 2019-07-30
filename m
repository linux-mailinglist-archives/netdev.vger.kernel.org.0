Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034FE7B450
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfG3UYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfG3UYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 16:24:15 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE6021773
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 20:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564518253;
        bh=Kt8xMfLEUIW3Y3BQbWr7auw3iHGpmo7WxKDcHNpHrJY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dg00idpt+nWyhqrCK+U2jSJ3sgEYeNS6kxfx6cIOY9laRHislxCGjaH1t797jpuTN
         sGqGFZ6UDDXBtBA8yTn8ZU4/UL97slbOmXPw5DL1vlUGJvdEOBhdRv5bRTES4/henZ
         J3pSln7N/BQjPbfsS7CEa6wQ1ApaNLU93HGJc8/0=
Received: by mail-wr1-f52.google.com with SMTP id x4so13980373wrt.6
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 13:24:13 -0700 (PDT)
X-Gm-Message-State: APjAAAV+tJlVxmkyeY//1z3cp+Ng4gWLLeM+kPktPgILc1v52e27G9cc
        5+rOEzxsh4FaUre/k84qP2d4wrBt0GjyNkz8d3XFtg==
X-Google-Smtp-Source: APXvYqzZ/BahTMAZqJKvw3CKJJrYc0VH2HO2IKCQHMz+jcl+qF5qZMCRFU61mq2qYTzjNeslp+cWZBSZeISWQwA0qnU=
X-Received: by 2002:adf:f28a:: with SMTP id k10mr52015339wro.343.1564518251602;
 Tue, 30 Jul 2019 13:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com> <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com> <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com> <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
In-Reply-To: <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 30 Jul 2019 13:24:00 -0700
X-Gmail-Original-Message-ID: <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
Message-ID: <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 10:07 PM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>
> > On Jul 27, 2019, at 11:20 AM, Song Liu <songliubraving@fb.com> wrote:
> >
> > Hi Andy,
> >
> >>>>>
> >>>>
> >>>> Well, yes. sys_bpf() is pretty powerful.
> >>>>
> >>>> The goal of /dev/bpf is to enable special users to call sys_bpf(). I=
n
> >>>> the meanwhile, such users should not take down the whole system easi=
ly
> >>>> by accident, e.g., with rm -rf /.
> >>>
> >>> That=E2=80=99s easy, though =E2=80=94 bpftool could learn to read /et=
c/bpfusers before allowing ruid !=3D 0.
> >>
> >> This is a great idea! fscaps + /etc/bpfusers should do the trick.
> >
> > After some discussions and more thinking on this, I have some concerns
> > with the user space only approach.
> >
> > IIUC, your proposal for user space only approach is like:
> >
> > 1. bpftool (and other tools) check /etc/bpfusers and only do
> >   setuid for allowed users:
> >
> >       int main()
> >       {
> >               if (/* uid in /etc/bpfusers */)
> >                       setuid(0);
> >               sys_bpf(...);
> >       }
> >
> > 2. bpftool (and other tools) is installed with CAP_SETUID:
> >
> >       setcap cap_setuid=3De+p /bin/bpftool
> >
> > 3. sys admin maintains proper /etc/bpfusers.
> >
> > This approach is not ideal, because we need to trust the tool to give
> > it CAP_SETUID. A hacked tool could easily bypass /etc/bpfusers check
> > or use other root only sys calls after setuid(0).
> >
>
> I would like more comments on this.
>
> Currently, bpf permission is more or less "root or nothing", which we
> would like to change.
>
> The short term goal is to separate bpf from root, in other words, it is
> "all or nothing". Special user space utilities, such as systemd, would
> benefit from this. Once this is implemented, systemd can call sys_bpf()
> when it is not running as root.

As generally nasty as Linux capabilities are, this sounds like a good
use for CAP_BPF_ADMIN.

But what do you have in mind?  Isn't non-root systemd mostly just the
user systemd session?  That should *not* have bpf() privileges until
bpf() is improved such that you can't use it to compromise the system.

>
> In longer term, it may be useful to provide finer grain permission of
> sys_bpf(). For example, sys_bpf() should be aware of containers; and
> user may only have access to certain bpf maps. Let's call this
> "fine grain" capability.
>
>
> Since we are seeing new use cases every year, we will need many
> iterations to implement the fine grain permission. I think we need an
> API that is flexible enough to cover different types of permission
> control.
>
> For example, bpf_with_cap() can be flexible:
>
>         bpf_with_cap(cmd, attr, size, perm_fd);
>
> We can get different types of permission via different combinations of
> arguments:
>
>     A perm_fd to /dev/bpf gives access to all sys_bpf() commands, so
>     this is "all or nothing" permission.
>
>     A perm_fd to /sys/fs/cgroup/.../bpf.xxx would only allow some
>     commands to this specific cgroup.
>

I don't see why you need to invent a whole new mechanism for this.
The entire cgroup ecosystem outside bpf() does just fine using the
write permission on files in cgroupfs to control access.  Why can't
bpf() do the same thing?

>
> Alexei raised another idea in offline discussions: instead of adding
> bpf_with_cap(), we add a command LOAD_PERM_FD, which enables special
> permission for the _next_ sys_bpf() from current task:
>
>     bpf(LOAD_PERM_FD, perm_fd);
>     /* the next sys_bpf() uses permission from perm_fd */
>     bpf(cmd, attr, size);
>
> This is equivalent to bpf_with_cap(cmd, attr, size, perm_fd), but
> doesn't require the new sys call.

That sounds almost every bit as problematic as the approach where you
ask for permission once and it sticks.

>
> 1. User space only approach doesn't work, even for "all or nothing"
>    permission control. I expanded the discussion in the previous
>    email. Please let me know if I missed anything there.

As in my previous email, I disagree.
