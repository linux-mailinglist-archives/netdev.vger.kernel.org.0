Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3237CC84
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfGaTJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfGaTJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 15:09:42 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79061217F5
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564600180;
        bh=5sbq1CUz/4Np8diMsPeYBJ+i1aJj9MKsghvG1UWBzjg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EZHhqpan5TKtpQ81oKj2cKstineoX3GVqcoD1rjnhWw5RVfbdFLFCKTanF5OehRSW
         8TQ2MuDoWX2jmbV2Dae5nCcCv29C/K5OsMB9sm1vxJGaAO15N9x3A195qJZF63jmlj
         JfJeMOXlLCcPc1TTIJ7EWgPOk06X3UAQnocRvKI8=
Received: by mail-wm1-f41.google.com with SMTP id p74so61926927wme.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:09:40 -0700 (PDT)
X-Gm-Message-State: APjAAAWz+498Dq36v2loubCpXurEW4yTpuqWP1Kulrj/1huv4daQBIBE
        3cquNgFb6FjShyCOFRMyMoiFrsTXiuQSPsHVmZ1vGQ==
X-Google-Smtp-Source: APXvYqx4zb8LrcibSKUodOi60ie226tvSHupyQ0d4LTQVRZ4SeTKKUMFrOQKYUOpT8Ag2AxIjIWeCiufncu+lKbqMAs=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr51242084wme.173.1564600178852;
 Wed, 31 Jul 2019 12:09:38 -0700 (PDT)
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
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
In-Reply-To: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 31 Jul 2019 12:09:27 -0700
X-Gmail-Original-Message-ID: <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
Message-ID: <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
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

On Wed, Jul 31, 2019 at 1:10 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 1:24 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Mon, Jul 29, 2019 at 10:07 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Hi Andy,
> >>
> >>> On Jul 27, 2019, at 11:20 AM, Song Liu <songliubraving@fb.com> wrote:
> >>>
> >>> Hi Andy,
> >>>
> >>>
>
> [...]
>
> >>>
> >>
> >> I would like more comments on this.
> >>
> >> Currently, bpf permission is more or less "root or nothing", which we
> >> would like to change.
> >>
> >> The short term goal is to separate bpf from root, in other words, it is
> >> "all or nothing". Special user space utilities, such as systemd, would
> >> benefit from this. Once this is implemented, systemd can call sys_bpf()
> >> when it is not running as root.
> >
> > As generally nasty as Linux capabilities are, this sounds like a good
> > use for CAP_BPF_ADMIN.
>
> I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make
> existing tools (setcap, getcap, etc.) and libraries aware of the new CAP.

It's been done before -- it's not that hard.  IMO the main tricky bit
would be try be somewhat careful about defining exactly what
CAP_BPF_ADMIN does.

> > I don't see why you need to invent a whole new mechanism for this.
> > The entire cgroup ecosystem outside bpf() does just fine using the
> > write permission on files in cgroupfs to control access.  Why can't
> > bpf() do the same thing?
>
> It is easier to use write permission for BPF_PROG_ATTACH. But it is
> not easy to do the same for other bpf commands: BPF_PROG_LOAD and
> BPF_MAP_*. A lot of these commands don't have target concept. Maybe
> we should have target concept for all these commands. But that is a
> much bigger project. OTOH, "all or nothing" model allows all these
> commands at once.

For BPF_PROG_LOAD, I admit I've never understood why permission is
required at all.  I think that CAP_SYS_ADMIN or similar should be
needed to get is_priv in the verifier, but I think that should mainly
be useful for tracing, and that requires lots of privilege anyway.
BPF_MAP_* is probably the trickiest part.  One solution would be some
kind of bpffs, but I'm sure other solutions are possible.
