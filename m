Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147CB7B444
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfG3UUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbfG3UUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 16:20:25 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94B4217D6
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 20:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564518023;
        bh=Iu+6JPntZLE7GOijyjckcWIt8EYf9s4FJl/QwYGOOaE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JDmi0tnubv1So2xm5UTQtQWXJDJr+g2VqbhfsODtQfzpXun1MYr+R7IpC2F6HvJ+b
         TDi9FZqH8oOsJmdqwIGRwNMJ/vEhPhPmyQme3+GfHYUkR96dUGHowWzJEc+XKdFYTi
         QueCGEJJ0/d1j86TlgDEAo0+7wkpKRDWR5VFpmyU=
Received: by mail-wm1-f51.google.com with SMTP id g67so53650964wme.1
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 13:20:23 -0700 (PDT)
X-Gm-Message-State: APjAAAV5guAlYuw8O35jKDXuMvFGIfIqqLtOVSp1t8wCr8gX9ZIrjzJ8
        cGzulPQriURRDFbJ6UFtT9NRNi2XG51kIx7/qtG/pw==
X-Google-Smtp-Source: APXvYqzl8ZF//gu9dHlHhlkHH0HNpi+EOtNwImKwsGRjT7tn7mvma3rdV5Zit0f6Bw8ChZu9AISkh4etjc8YWGyd42M=
X-Received: by 2002:a1c:a942:: with SMTP id s63mr105071199wme.76.1564518022044;
 Tue, 30 Jul 2019 13:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com> <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com> <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com> <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
In-Reply-To: <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 30 Jul 2019 13:20:10 -0700
X-Gmail-Original-Message-ID: <CALCETrVS5FwtmTyspyg-UNoZTHes9wUNbbsvNYwQwXUUfrtaiQ@mail.gmail.com>
Message-ID: <CALCETrVS5FwtmTyspyg-UNoZTHes9wUNbbsvNYwQwXUUfrtaiQ@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 11:20 AM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>
> >>>>
> >>>
> >>> Well, yes. sys_bpf() is pretty powerful.
> >>>
> >>> The goal of /dev/bpf is to enable special users to call sys_bpf(). In
> >>> the meanwhile, such users should not take down the whole system easil=
y
> >>> by accident, e.g., with rm -rf /.
> >>
> >> That=E2=80=99s easy, though =E2=80=94 bpftool could learn to read /etc=
/bpfusers before allowing ruid !=3D 0.
> >
> > This is a great idea! fscaps + /etc/bpfusers should do the trick.
>
> After some discussions and more thinking on this, I have some concerns
> with the user space only approach.
>
> IIUC, your proposal for user space only approach is like:
>
> 1. bpftool (and other tools) check /etc/bpfusers and only do
>    setuid for allowed users:
>
>         int main()
>         {
>                 if (/* uid in /etc/bpfusers */)
>                         setuid(0);
>                 sys_bpf(...);
>         }
>
> 2. bpftool (and other tools) is installed with CAP_SETUID:
>
>         setcap cap_setuid=3De+p /bin/bpftool
>

You have this a bit backwards.  You wouldn't use CAP_SETUID.  You
would use the setuid *mode* bit, i.e. chmod 4111 (or 4100 and use ACLs
to further lock it down).  Or you could use setcap cap_sys_admin=3Dp,
although the details vary.  It woks a bit like this:

First, if you are running with elevated privilege due to SUID or
fscaps, the kernel and glibc offer you a degree of protection: you are
protected from ptrace(), LD_PRELOAD, etc.  You are *not* protected
from yourself.  For example, you may be running in a context in which
an attacker has malicious values in your environment variables, CWD,
etc.  Do you need to carefully decide whether you are willing to run
with elevated privilege on behalf of the user, which you learn like
this:

uid_t real_uid =3D getuid();

Your decision may may depend on command-line arguments as well (i.e.
you might want to allow tracing but not filtering, say).  Once you've
made this decision, the details vary:

For SUID, you either continue to run with euid =3D=3D 0, or you drop
privilege using something like:

if (setresuid(real_uid, real_uid, real_uid) !=3D 0) {
 /* optionally print an error to stderr */
 exit(1);
}

For fscaps, if you want to be privileged, you use something like
capng_update(); capng_apply() to set CAP_SYS_ADMIN to be effective
when you want privilege.  If you want to be unprivileged (because
bpfusers says so, for example), you could use capng_update() to drop
CAP_SYS_ADMIN entirely and see if the calls still work without
privilege.  But this is a little bit awkward, since you don't directly
know whether the user that invoked you in the first place had
CAP_SYS_ADMIN to begin with.

In general, SUID is a bit easier to work with.


> This approach is not ideal, because we need to trust the tool to give
> it CAP_SETUID. A hacked tool could easily bypass /etc/bpfusers check
> or use other root only sys calls after setuid(0).

How?  The whole SUID mechanism is designed fairly carefully to prevent
this.  /bin/sudo is likely to be SUID on your system, but you can't
just "hack" it to become root.
