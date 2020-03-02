Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7717684D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgCBXho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:37:44 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45411 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgCBXho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 18:37:44 -0500
Received: by mail-qk1-f194.google.com with SMTP id z12so1587936qkg.12;
        Mon, 02 Mar 2020 15:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bahgYzgAXZPDS0WcmGHpI43ZI7c2XPEoK/ZgXyNwZd4=;
        b=fUOvMEbSNV3dpMBUlm8BY7X2f80UXsfRkryY6IK1SOLJwAY/r9G0RYYu48H/m2huCE
         jNcqBx7TlygmnBP+QaQ59t1momwR1sSJFbCHjdtd3WmeC6pHGwYIGdxF0RtdIjH3AoMO
         VyXs6Z/5UgSrcDVKFFSxmFFulW7J8l5Bj2LNqeFHoARMZtfeMx8fMUmzNETmQdG1kWNE
         Ps5BLvqh0GsGUb4Nu/9tgL3j/MFmIUHjDupgvceIXTs38MQD+6ITTLZQZ7aYDoSepwXx
         QyifSdR28/QeIzHq/Ohjy+x2SAuRZ30mLHo6zs/pr0zQ49EUv/EAgTPOKETLdwyjx3G7
         lsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bahgYzgAXZPDS0WcmGHpI43ZI7c2XPEoK/ZgXyNwZd4=;
        b=p3okAo7ZmBPIIsAZT7dMWNPX5fUJlaNeX551VlBKRx6w/BtN/FRBHrBquhdAux3tWF
         N0Y1jiEpK5/BM5o4cJIYz3sAp2LzqJ/wzxlSzv7YMfcAPXOvs+ld4fzToR46faysVOUs
         +vD9twPNiPULi/xYb5USb/FzZvEGYttD/Ja9OLtyB8Dk7jyJN2st3bgGXimcYjR2/7Xk
         mUGoe+XqGWdNYhIVLvbCXYmMxq6CTIcmQ0KyimslbWVNGlza5Y8t3v7J/l5s9TT8usym
         MiYwkpnWnmh6Qjc53+uLLj+L/auXLgnkNK+UiikyFhDYBX/yvsBKSSjlK/M9cytBmCs1
         rpmA==
X-Gm-Message-State: ANhLgQ1QJbHUdd/c6p9AbnutlMiQmmUEkbbw3Wu2LI3cslg+lWIqjsss
        cbVwlLbqecTXJ5YiAKXwDvfD3r4dqZdByKoks5c=
X-Google-Smtp-Source: ADFU+vt2Qfynp+dh/Mlh4r2veHokcw8aReThEBNPbPqQVxHYaRaP02ujS2k6TOExcUwtPB0icZFRAaf9bBLZF/4nLco=
X-Received: by 2002:a05:620a:99d:: with SMTP id x29mr1618981qkx.39.1583192263404;
 Mon, 02 Mar 2020 15:37:43 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-2-andriin@fb.com>
 <87k143t682.fsf@toke.dk> <CAEf4BzY_2rLNS4rJnySGr_44e315SGs0FMBNh1010YYBX8OBmg@mail.gmail.com>
 <87r1yasaej.fsf@toke.dk>
In-Reply-To: <87r1yasaej.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 15:37:32 -0800
Message-ID: <CAEf4Bza6-5QzArHgq9Uh24mR1C+ARDnnfw78q4CSm1=Rb3qOOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 1:40 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Mar 2, 2020 at 2:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andriin@fb.com> writes:
> >>
> >> > Introduce bpf_link abstraction, representing an attachment of BPF pr=
ogram to
> >> > a BPF hook point (e.g., tracepoint, perf event, etc). bpf_link encap=
sulates
> >> > ownership of attached BPF program, reference counting of a link itse=
lf, when
> >> > reference from multiple anonymous inodes, as well as ensures that re=
lease
> >> > callback will be called from a process context, so that users can sa=
fely take
> >> > mutex locks and sleep.
> >> >
> >> > Additionally, with a new abstraction it's now possible to generalize=
 pinning
> >> > of a link object in BPF FS, allowing to explicitly prevent BPF progr=
am
> >> > detachment on process exit by pinning it in a BPF FS and let it open=
 from
> >> > independent other process to keep working with it.
> >> >
> >> > Convert two existing bpf_link-like objects (raw tracepoint and traci=
ng BPF
> >> > program attachments) into utilizing bpf_link framework, making them =
pinnable
> >> > in BPF FS. More FD-based bpf_links will be added in follow up patche=
s.
> >> >
> >> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >> > ---
> >> >  include/linux/bpf.h  |  13 +++
> >> >  kernel/bpf/inode.c   |  42 ++++++++-
> >> >  kernel/bpf/syscall.c | 209 ++++++++++++++++++++++++++++++++++++----=
---
> >> >  3 files changed, 226 insertions(+), 38 deletions(-)
> >> >

[...]

> >> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> > index c536c65256ad..fca8de7e7872 100644
> >> > --- a/kernel/bpf/syscall.c
> >> > +++ b/kernel/bpf/syscall.c
> >> > @@ -2173,23 +2173,153 @@ static int bpf_obj_get(const union bpf_attr=
 *attr)
> >> >                               attr->file_flags);
> >> >  }
> >> >
> >> > -static int bpf_tracing_prog_release(struct inode *inode, struct fil=
e *filp)
> >> > +struct bpf_link {
> >> > +     atomic64_t refcnt;
> >>
> >> refcount_t ?
> >
> > Both bpf_map and bpf_prog stick to atomic64 for their refcounting, so
> > I'd like to stay consistent and use refcount that can't possible leak
> > resources (which refcount_t can, if it's overflown).
>
> refcount_t is specifically supposed to turn a possible use-after-free on
> under/overflow into a warning, isn't it? Not going to insist or anything
> here, just found it odd that you'd prefer the other...

Well, underflow is a huge bug that should never happen in well-tested
code (at least that's assumption for bpf_map and bpf_prog), and we are
generally very careful about that. Overflow can happen only because
refcount_t is using 32-bit integer, which atomic64_t side-steps
completely by going to 64-bit integer. So yeah, I'd rather stick to
the same stuff that's used for bpf_map and bpf_prog.

>
> -Toke
>
