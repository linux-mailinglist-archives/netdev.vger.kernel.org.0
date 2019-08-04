Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC080CE6
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfHDWRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfHDWRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 18:17:00 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1612184B
        for <netdev@vger.kernel.org>; Sun,  4 Aug 2019 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564957019;
        bh=NOsxGe27UUkBUODosCJyRGgFS2Jq9IOxrPzUq8LIvcM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Fqyy0NvLusu14az8Ov3YCYwhYCJ6lIV59Nr7t0tWwPT95pEWhNvy5Vi4+s9QecAYm
         KL7LsFVc0TgpSvXtY8Eoq2AejrCZqE6en3NVi0TjLUU/G/SL8FYDm0XzZbbjnCSZHB
         Z099ygyZifFp7av1c8XyGftglwxrcNNo/TCT4bXg=
Received: by mail-wr1-f46.google.com with SMTP id r1so82419927wrl.7
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:16:58 -0700 (PDT)
X-Gm-Message-State: APjAAAX189DIgQ2yyMNViaUnEheKdcnLO2+uHJFG9AXUzdCbToEjf8hG
        x+bhsd0fKeBcwlGHtnObOqMAJ6nf0y0xa3H6SYDSjQ==
X-Google-Smtp-Source: APXvYqxpYh/r8L67Yq8wytHQI4oN79Aw0hUduH+jnQG7PwmNVjSC50w0B3l5qWCsOFZlpSgQcSB+ucGe4OkPF/pYd34=
X-Received: by 2002:adf:f28a:: with SMTP id k10mr81834684wro.343.1564957017128;
 Sun, 04 Aug 2019 15:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com> <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com> <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com> <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com> <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
In-Reply-To: <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 4 Aug 2019 15:16:46 -0700
X-Gmail-Original-Message-ID: <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
Message-ID: <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 12:22 AM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>
 >> I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make
> >> existing tools (setcap, getcap, etc.) and libraries aware of the new CAP.
> >
> > It's been done before -- it's not that hard.  IMO the main tricky bit
> > would be try be somewhat careful about defining exactly what
> > CAP_BPF_ADMIN does.
>
> Agreed. I think defining CAP_BPF_ADMIN could be a good topic for the
> Plumbers conference.
>
> OTOH, I don't think we have to wait for CAP_BPF_ADMIN to allow daemons
> like systemd to do sys_bpf() without root.

I don't understand the use case here.  Are you talking about systemd
--user?  As far as I know, a user is expected to be able to fully
control their systemd --user process, so giving it unrestricted bpf
access is very close to giving it superuser access, and this doesn't
sound like a good idea.  I think that, if systemd --user needs bpf(),
it either needs real unprivileged bpf() or it needs a privileged
helper (SUID or a daemon) to intermediate this access.

>
> >
> >>> I don't see why you need to invent a whole new mechanism for this.
> >>> The entire cgroup ecosystem outside bpf() does just fine using the
> >>> write permission on files in cgroupfs to control access.  Why can't
> >>> bpf() do the same thing?
> >>
> >> It is easier to use write permission for BPF_PROG_ATTACH. But it is
> >> not easy to do the same for other bpf commands: BPF_PROG_LOAD and
> >> BPF_MAP_*. A lot of these commands don't have target concept. Maybe
> >> we should have target concept for all these commands. But that is a
> >> much bigger project. OTOH, "all or nothing" model allows all these
> >> commands at once.
> >
> > For BPF_PROG_LOAD, I admit I've never understood why permission is
> > required at all.  I think that CAP_SYS_ADMIN or similar should be
> > needed to get is_priv in the verifier, but I think that should mainly
> > be useful for tracing, and that requires lots of privilege anyway.
> > BPF_MAP_* is probably the trickiest part.  One solution would be some
> > kind of bpffs, but I'm sure other solutions are possible.
>
> Improving permission management of cgroup_bpf is another good topic to
> discuss. However, it is also an overkill for current use case.
>

I looked at the code some more, and I don't think this is so hard
after all.  As I understand it, all of the map..by_id stuff is, to
some extent, deprecated in favor of persistent maps.  As I see it, the
map..by_id calls should require privilege forever, although I can
imagine ways to scope that privilege to a namespace if the maps
themselves were to be scoped to a namespace.

Instead, unprivileged tools would use the persistent map interface
roughly like this:

$ bpftool map create /sys/fs/bpf/my_dir/filename type hash key 8 value
8 entries 64 name mapname

This would require that the caller have either CAP_DAC_OVERRIDE or
that the caller have permission to create files in /sys/fs/bpf/my_dir
(using the same rules as for any filesystem), and the resulting map
would end up owned by the creating user and have mode 0600 (or maybe
0666, or maybe a new bpf_attr parameter) modified by umask.  Then all
the various capable() checks that are currently involved in accessing
a persistent map would instead check FMODE_READ or FMODE_WRITE on the
map file as appropriate.

Half of this stuff already works.  I just set my system up like this:

$ ls -l /sys/fs/bpf
total 0
drwxr-xr-x. 3 luto luto 0 Aug  4 15:10 luto

$ mkdir /sys/fs/bpf/luto/test

$ ls -l /sys/fs/bpf/luto
total 0
drwxrwxr-x. 2 luto luto 0 Aug  4 15:10 test

I bet that making the bpf() syscalls work appropriately in this
context without privilege would only be a couple of hours of work.
The hard work, creating bpffs and making it function, is already done
:)

P.S. The docs for bpftool create are less than fantastic.  The
complete lack of any error message at all when the syscall returns
-EACCES is also not fantastic.
