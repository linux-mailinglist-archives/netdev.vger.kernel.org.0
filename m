Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2674B128A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243849AbiBJQTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:19:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiBJQTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:19:05 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF6098;
        Thu, 10 Feb 2022 08:19:05 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k18so10468509wrg.11;
        Thu, 10 Feb 2022 08:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ExeWQc9SUOqYcrRLN43WRoHZMIKzifId+2InLZRt+PQ=;
        b=EsnqJ5WpC+8gesQoT17NvYMvanu9wd2hDWjYhUR/uFhAsGNLZDya/IyC06RFvZgpdk
         0mkCziXaDhkVWFlq/7GuTQGs8UsANXFSm/kP7jSUcMG9QZYLMjoxcllva6SfXeCd8RRz
         oynCPxEPV8zYb/kpiwC3mAof688qEvjd6EbvkL5lyCvuBOiSReXuwmWHWmzPJ1YEZMbA
         0hlyH3tJR6kqmo/wkq/hc8jeeFTrKdojaK+nl/BdhnibHVHy8TyiKBfevgOs/r5Xke4/
         lAcX/TgJad1G12lh594d78NPT8/swKpDP8vBePXUi3KdS2XR+YYzTYAGo5KAolVkr1R9
         k8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ExeWQc9SUOqYcrRLN43WRoHZMIKzifId+2InLZRt+PQ=;
        b=yd0dpHtK7Y5Y4/NXfqW33qAV4laUbQLShOw+y40VugqF7HiWjylvDPJ5BGB5AufOQ0
         kdxbbZ4MiJqMvEefBPJQzsYkRg2ghpCsQg1Mw6PvouVfUCPKCeevi/qVuG3D5mjKWucE
         Tmyr34dHsnDoCbwPQLiKcY3lhWlmv+BPO1vuJVS7r9mdFmH/ugc3QGvwincUrj17PYcF
         94BA5zf7h8NxC+gf7GEFxSc9IvqPBT4FU1ytbdQ4HTh7cNyQbOygKSAfb9+N073K7FZ9
         ocaqMMkZlUz/ppanB+D+vi6/fVbBTUphTGeWXMaGT6UZudynAQh1z9J7Bw2Nbtx463pe
         xgqw==
X-Gm-Message-State: AOAM531rDuixS9ujJVZDuf2DSmO0RC5sS69Sws14yBK9QX6ojF4++Kpc
        NoC2pKvjIggEcCt5n1ojUItGU3l7wZSVrhIdDF4=
X-Google-Smtp-Source: ABdhPJzLa+ZcEdnWY8kZ6vC+kndyjKV326hStd8ZZhxGEYPbi51SWjuWqzqutzFO4RxENSyniI0IaGB4OXM+4MCpNsk=
X-Received: by 2002:a05:6000:1846:: with SMTP id c6mr7165029wri.438.1644509944114;
 Thu, 10 Feb 2022 08:19:04 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a3571605d27817b5@google.com> <0000000000001f60ef05d7a3c6ad@google.com>
 <20220210081125.GA4616@1wt.eu> <359ee592-747f-8610-4180-5e1d2aba1b77@iogearbox.net>
In-Reply-To: <359ee592-747f-8610-4180-5e1d2aba1b77@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 10 Feb 2022 17:18:52 +0100
Message-ID: <CAJ+HfNjeapa=2Ue19L3EWF8z5vxFB0k2QO_LuBu4Meqs0=AE4Q@mail.gmail.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Willy Tarreau <w@1wt.eu>,
        syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        fgheet255t@gmail.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        mudongliangabcd@gmail.com, Netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 at 09:35, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/10/22 9:11 AM, Willy Tarreau wrote:
> > On Wed, Feb 09, 2022 at 10:08:07PM -0800, syzbot wrote:
> >> syzbot has bisected this issue to:
> >>
> >> commit 7661809d493b426e979f39ab512e3adf41fbcc69
> >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date:   Wed Jul 14 16:45:49 2021 +0000
> >>
> >>      mm: don't allow oversized kvmalloc() calls
> >>
> >> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13bc74c=
2700000
> >> start commit:   f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kern=
el.o..
> >> git tree:       upstream
> >> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D107c74c=
2700000
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17bc74c270=
0000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D5707221760=
c00a20
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=3D11421fbbff99=
b989670e
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e514a4=
700000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15fcdf8a70=
0000
> >>
> >> Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
> >> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> >>
> >> For information about bisection process see: https://goo.gl/tpsmEJ#bis=
ection
> >
> > Interesting, so in fact syzkaller has shown that the aforementioned
> > patch does its job well and has spotted a call path by which a single
> > userland setsockopt() can request more than 2 GB allocation in the
> > kernel. Most likely that's in fact what needs to be addressed.
> >
> > FWIW the call trace at the URL above is:
> >
> > Call Trace:
> >   kvmalloc include/linux/mm.h:806 [inline]
> >   kvmalloc_array include/linux/mm.h:824 [inline]
> >   kvcalloc include/linux/mm.h:829 [inline]
> >   xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
> >   xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
> >   xdp_umem_create+0x6a5/0xf00 net/xdp/xdp_umem.c:252
> >   xsk_setsockopt+0x604/0x790 net/xdp/xsk.c:1068
> >   __sys_setsockopt+0x1fd/0x4e0 net/socket.c:2176
> >   __do_sys_setsockopt net/socket.c:2187 [inline]
> >   __se_sys_setsockopt net/socket.c:2184 [inline]
> >   __x64_sys_setsockopt+0xb5/0x150 net/socket.c:2184
> >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > and the meaningful part of the repro is:
> >
> >    syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> >    syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
> >    syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> >    intptr_t res =3D 0;
> >    res =3D syscall(__NR_socket, 0x2cul, 3ul, 0);
> >    if (res !=3D -1)
> >      r[0] =3D res;
> >    *(uint64_t*)0x20000080 =3D 0;
> >    *(uint64_t*)0x20000088 =3D 0xfff02000000;
> >    *(uint32_t*)0x20000090 =3D 0x800;
> >    *(uint32_t*)0x20000094 =3D 0;
> >    *(uint32_t*)0x20000098 =3D 0;
> >    syscall(__NR_setsockopt, r[0], 0x11b, 4, 0x20000080ul, 0x20ul);
>
> Bjorn had a comment back then when the issue was first raised here:
>
>    https://lore.kernel.org/bpf/3f854ca9-f5d6-4065-c7b1-5e5b25ea742f@iogea=
rbox.net/
>
> There was earlier discussion from Andrew to potentially retire the warnin=
g:
>
>    https://lore.kernel.org/bpf/20211201202905.b9892171e3f5b9a60f9da251@li=
nux-foundation.org/
>
> Bjorn / Magnus / Andrew, anyone planning to follow-up on this issue?
>

Honestly, I would need some guidance on how to progress. I could just
change from U32_MAX to INT_MAX, but as I stated earlier (lore-link
above), that has a hacky feeling to it. Andrew's mail didn't really
land in a consensus. From my perspective, the code isn't broken, with
the memcg limits in consideration. Introducing a LARGE flag or a new
"_yes_this_can_be_huge_but_it_is_ok()" version would make sense if
this problem is applicable to more users in the kernel.

So, thoughts? ;-)


Bj=C3=B6rn
