Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5684B3EBEF9
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhHNA0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbhHNA0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 20:26:44 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC25C061756;
        Fri, 13 Aug 2021 17:26:17 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id o126so13787426ybo.7;
        Fri, 13 Aug 2021 17:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoysL5lDfLKZ+wWbRS+l3epQ03ts/jCJh76pqNcdD48=;
        b=Cpt0mHNLdfgtg3TtpzUCxAgqCRq5+1ViLV0JZoWtHfmYNIeHmijYps3VChf0HLMFZL
         uaSr8YM+0MJLdfbQVgxqSM6AYCGhKW0jKPEUye2QimSXkHHXbgKZK/lhDUlhkXiXNMfr
         RmQuzlL5hIcsOYDM6EtND9VdSe1Oc5s91mUQ7tT+REyigr4gMBXEm6ZOSEdCmAbi6Gy2
         z7tmMmQfmewJ6vpeJq5zibx6GW9bVSk/euoCUQMp/oNOTgGrPTunJBp7W6C+LD2jjKXP
         eJpUQIZ+ZeXWTeoOScUUV9QFWnjH42/H4pcHXjc+7CG17BjBA3fAkwfFDkAGG8tEep/n
         qAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZoysL5lDfLKZ+wWbRS+l3epQ03ts/jCJh76pqNcdD48=;
        b=OmbEmQblhnxbCrc7G1Bl77h9qITjMomReRMn4yrWKsncascaqx7CoThzrYugiiii0f
         z2Gr6g6ysUHAq10YBVkQ7dmpQBOzydV+VzC/RzdPoVbJ9SxHpFuAKJkxtLraX80xLC2T
         yOLjNDv8fYZIk8GhGc/Q9b4WRaUGjXIAQqKkHALbxhsUfYpIcmO6x7dtBKoy2EtroUXF
         +AlZW+cnps8OVGtCHWzjBJLm/yDFUvB1IHxvAtdiX7kFtSYB1CIc3v436PddgEXGfP60
         psI/9DAZWydyuWNwBsf9Q5IfcnbPBsDM5qatDZy/rcZiDx5S64OeVwZ2oFl9bMMTn7BI
         V2nw==
X-Gm-Message-State: AOAM530AWbcxTibNW0H7XM5nLPJnRql7ExzoFrAY7e0NChhMNrAvWEBm
        VP6hdsjyu2xN/YN0ULpiixIHemlTVS7OkT8GjWo=
X-Google-Smtp-Source: ABdhPJyDoooqsgG36cAMj9eA/V02V86WgBcnBXv/KkrUh5Sp4rDXdwKPZgC/VSTivyYIJ8d2oNb2zfZOenmmu53m5Ak=
X-Received: by 2002:a25:4941:: with SMTP id w62mr6313920yba.230.1628900776300;
 Fri, 13 Aug 2021 17:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZ3sVx1m1mOCcPcuVPiY6cWEAO=6VGHDiXEs9ZVD-RoLg@mail.gmail.com>
 <20210814002101.33742-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210814002101.33742-1-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 17:26:05 -0700
Message-ID: <CAEf4BzbVpqkXk4XiaXW=hTa6hwH3u8c2n8MruTNAKM5Y0XTjQg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/4] selftest/bpf: Implement sample UNIX
 domain socket iterator program.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 5:21 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Date:   Fri, 13 Aug 2021 16:25:53 -0700
> > On Thu, Aug 12, 2021 at 9:46 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > The iterator can output almost the same result compared to /proc/net/unix.
> > > The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
> > > can be easily overflown.
> > >
> > >   # cat /sys/fs/bpf/unix
> > >   Num               RefCount Protocol Flags    Type St Inode    Path
> >
> > It's totally my OCD, but why the column name is not aligned with
> > values? I mean the "Inode" column. It's left aligned, but values
> > (numbers) are right-aligned? I'd fix that while applying, but I can't
> > apply due to selftests failures, so please take a look.
>
> Ah, honestly, I've felt something strange about the column... will fix it!
>
>
> >
> >
> > >   ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
> > >   ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@
> > >
> > >   # cat /proc/net/unix
> > >   Num       RefCount Protocol Flags    Type St Inode Path
> > >   ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
> > >   ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@
> > >
> > > Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
> > > Yonghong Song for analysing and fixing.
> > >
> > > [0] https://reviews.llvm.org/D107483
> > >
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > ---
> >
> > This selftests breaks test_progs-no_alu32 ([0], the error log is super
> > long and can freeze browser; it looks like an infinite loop and BPF
> > verifier just keeps reporting it until it runs out of 1mln
> > instructions or something). Please check what's going on there, I
> > can't land it as it is right now.
> >
> >   [0] https://github.com/kernel-patches/bpf/runs/3326071112?check_suite_focus=true#step:6:124288
> >
> >
> > >  tools/testing/selftests/bpf/README.rst        | 38 +++++++++
> > >  .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
> > >  tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
> > >  .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++++++
> > >  .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
> > >  5 files changed, 143 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > >
> >
> > [...]
> >
> > > +                       /* The name of the abstract UNIX domain socket starts
> > > +                        * with '\0' and can contain '\0'.  The null bytes
> > > +                        * should be escaped as done in unix_seq_show().
> > > +                        */
> > > +                       int i, len;
> > > +
> >
> > no_alu32 variant probably isn't happy about using int for this, it
> > probably does << 32, >> 32 dance and loses track of actual value in
> > the loop. You can try using u64 instead.
>
> Sorry, I missed the no_alu32 test.
> Changing int to __u64 fixed the error, thanks!
>
>
> >
> > > +                       len = unix_sk->addr->len - sizeof(short);
> > > +
> > > +                       BPF_SEQ_PRINTF(seq, " @");
> > > +
> > > +                       /* unix_mkname() tests this upper bound. */
> > > +                       if (len < sizeof(struct sockaddr_un))
> > > +                               for (i = 1; i < len; i++)
> >
> > if you move above if inside the loop to break out of the loop, does it
> > change how Clang generates code?
> >
> > for (i = 1; i < len i++) {
> >     if (i >= sizeof(struct sockaddr_un))
> >         break;
> >     BPF_SEQ_PRINTF(...);
> > }
>
> Yes, but there seems little defference.
> Which is preferable?
>
> ---8<---
> before (for inside if) <- -> after (if inside loop)
>       96:       07 08 00 00 fe ff ff ff r8 += -2                          |     ;                       for (i = 1; i < len; i++) {
> ;                       if (len < sizeof(struct sockaddr_un))             |           97:       bf 81 00 00 00 00 00 00 r1 = r8
>       97:       25 08 10 00 6d 00 00 00 if r8 > 109 goto +16 <LBB0_21>    |           98:       07 01 00 00 fc ff ff ff r1 += -4
> ;                               for (i = 1; i < len; i++)                 |           99:       25 01 12 00 6b 00 00 00 if r1 > 107 goto +18 <LBB0_21>
>       98:       a5 08 0f 00 02 00 00 00 if r8 < 2 goto +15 <LBB0_21>      |          100:       07 08 00 00 fe ff ff ff r8 += -2
>       99:       b7 09 00 00 01 00 00 00 r9 = 1                            |          101:       b7 09 00 00 01 00 00 00 r9 = 1
>      100:       05 00 16 00 00 00 00 00 goto +22 <LBB0_18>                |          102:       b7 06 00 00 02 00 00 00 r6 = 2
>                                                                           |          103:       05 00 17 00 00 00 00 00 goto +23 <LBB0_17>
> ...
>      111:       85 00 00 00 7e 00 00 00 call 126                          |          113:       b4 05 00 00 08 00 00 00 w5 = 8
> ;                               for (i = 1; i < len; i++)                 |          114:       85 00 00 00 7e 00 00 00 call 126
>      112:       07 09 00 00 01 00 00 00 r9 += 1                           |     ;                       for (i = 1; i < len; i++) {
>      113:       ad 89 09 00 00 00 00 00 if r9 < r8 goto +9 <LBB0_18>      |          115:       25 08 02 00 6d 00 00 00 if r8 > 109 goto +2 <LBB0_21>
>                                                                           >          116:       07 09 00 00 01 00 00 00 r9 += 1
>                                                                           >     ;                       for (i = 1; i < len; i++) {
>                                                                           >          117:       ad 89 09 00 00 00 00 00 if r9 < r8 goto +9 <LBB0_17>
> ---8<---
>

Have you tried running the variant I proposed on Clang without
Yonghong's recent fix? I wonder if it works without that fix (not that
there is anything wrong about the fix, but if we can avoid depending
on it, it would be great).

>
> >
> >
> > > +                                       BPF_SEQ_PRINTF(seq, "%c",
> > > +                                                      unix_sk->addr->name->sun_path[i] ?:
> > > +                                                      '@');
> > > +               }
> > > +       }
> > > +
> > > +       BPF_SEQ_PRINTF(seq, "\n");
> > > +
> > > +       return 0;
> > > +}
> > > diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> > > index 3af0998a0623..eef5646ddb19 100644
> > > --- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> > > +++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> > > @@ -5,6 +5,10 @@
> > >  #define AF_INET                        2
> > >  #define AF_INET6               10
> > >
> > > +#define __SO_ACCEPTCON         (1 << 16)
> > > +#define UNIX_HASH_SIZE         256
> > > +#define UNIX_ABSTRACT(unix_sk) (unix_sk->addr->hash < UNIX_HASH_SIZE)
> > > +
> > >  #define SOL_TCP                        6
> > >  #define TCP_CONGESTION         13
> > >  #define TCP_CA_NAME_MAX                16
> > > --
> > > 2.30.2
> > >
