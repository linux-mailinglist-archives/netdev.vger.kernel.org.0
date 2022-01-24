Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4949876A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244792AbiAXR77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244797AbiAXR75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:59:57 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D23AC06173B;
        Mon, 24 Jan 2022 09:59:57 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b14so51649439lff.3;
        Mon, 24 Jan 2022 09:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QsKXVrw3F9lsxKkyvC/zU4uBfnyL7GghuKOugyivPGg=;
        b=atoDIWiXRXzO2zgMjOO4EYNXE6CRElkM/2OZOgAY2s45Y+UHV5GTmIVx3sv9xRCo18
         ZXvU4wM/afAaItzf/aged/MaiYFmzom3v89hwqW5bXtM2ADd/sNryCuABt/GPAPB73YP
         VN59N9Cd2NW/F2L34Fs4hPSGkrkOH/3mk0Y89uMmNXy2YKTEJOYjdzyUHzLxa6QJPrTy
         0wJ5H+NARAVTSXFoMwzcUFzn8tgf0DELPMbdX6dnzLnPMpo/HllaeUSewtUvHoYLnuZS
         h0ZkdWH0ywlZbO4z9401dVwkmiMbXj5ODLWqPqZQqw/sHfB7B4pJDccFUT2bM7hvE6Dp
         /Vsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QsKXVrw3F9lsxKkyvC/zU4uBfnyL7GghuKOugyivPGg=;
        b=xkcQhI+uncRuuDO8Md+tBhozEFHbOb2EAYVrzOD2HFzBeIGA7GRzYzlco+yu4JaK2r
         YPFzEYtLiZvKLLWh3EPj0AXxstnpDAlmx6unOdYxLLxjEQgteFxaFcy9MmjR4u14zmzd
         9DNr6JHe6QymhsTyfq7gw7wigpj6RDci5PcPGorDudqOTC0krVerNbj+r+dxKNO4/URs
         pXhA6kVkOSX7cRrdVXY004+/W8Obl4k8WVJEgvUi7mxFnf6fAW6xB0/Zi/RnVdX5zwQe
         fJF1BA0y43Efb6jVp9TghBkIkgmKuE+FJCrqYMPxnZFp+sGEnwGwMNllRDlLhU+aUWLP
         QYZw==
X-Gm-Message-State: AOAM531WkUwI8KOBmBJb59R9OQaaR+LGqmKs4Y13P+E8q3TNA3D784/C
        3KaixRJYf+ZePSMbiiZ4iJ7LZ3H4K6ZSVabSpchUYv1yx+TjIA==
X-Google-Smtp-Source: ABdhPJwygNmDgklD8cKvzdK0UVdDB4x4K7zqKqK/YUzVjQRboVf5gkZ+wAnkrRrfKD8aQX+/kKGWbdnfU3L9PaOlTXM=
X-Received: by 2002:a05:6512:1681:: with SMTP id bu1mr13902600lfb.499.1643047195689;
 Mon, 24 Jan 2022 09:59:55 -0800 (PST)
MIME-Version: 1.0
References: <000000000000588c2c05aa156b2b@google.com> <00000000000087569605b8928ce3@google.com>
 <CACT4Y+a3Xe11dAkRAAewXQ7b=KzK1pk36Arwq=vCR7R-KQy9DQ@mail.gmail.com>
In-Reply-To: <CACT4Y+a3Xe11dAkRAAewXQ7b=KzK1pk36Arwq=vCR7R-KQy9DQ@mail.gmail.com>
From:   Vegard Nossum <vegard.nossum@gmail.com>
Date:   Mon, 24 Jan 2022 18:59:43 +0100
Message-ID: <CAOMGZ=Eyfq4+H_7Uray9jXceTDAugm5bRorGoHZUf2W314Kr+w@mail.gmail.com>
Subject: Re: kernel BUG at mm/vmalloc.c:LINE! (2)
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+5f326d255ca648131f87@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        John Fastabend <john.fastabend@gmail.com>,
        jonathan.lemon@gmail.com, Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        marekx.majtyka@intel.com, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 at 10:16, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sun, Jan 10, 2021 at 10:34 PM syzbot
> <syzbot+5f326d255ca648131f87@syzkaller.appspotmail.com> wrote:
> >
> > syzbot suspects this issue was fixed by commit:
> >
> > commit 537cf4e3cc2f6cc9088dcd6162de573f603adc29
> > Author: Magnus Karlsson <magnus.karlsson@intel.com>
> > Date:   Fri Nov 20 11:53:39 2020 +0000
> >
> >     xsk: Fix umem cleanup bug at socket destruct
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=139f3dfb500000
> > start commit:   e87d24fc Merge branch 'net-iucv-fixes-2020-11-09'
> > git tree:       net
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5f326d255ca648131f87
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d10006500000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126c9eaa500000
> >
> > If the result looks correct, please mark the issue as fixed by replying with:
> >
> > #syz fix: xsk: Fix umem cleanup bug at socket destruct
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> FTR, the bisection log looks clean, but this does not look like the
> fix for this. The reproducer does not destroy sockets.

I think it's the correct fix.

The crash report also has this, which shows the reproducer does
actually destroy sockets:

 xdp_umem_addr_unmap net/xdp/xdp_umem.c:44 [inline]
 xdp_umem_release net/xdp/xdp_umem.c:62 [inline]
 xdp_put_umem+0x113/0x330 net/xdp/xdp_umem.c:80
 xsk_destruct net/xdp/xsk.c:1150 [inline]
 xsk_destruct+0xc0/0xf0 net/xdp/xsk.c:1142
 __sk_destruct+0x4b/0x8f0 net/core/sock.c:1759
 rcu_do_batch kernel/rcu/tree.c:2476 [inline]

I've tested the reproducer on both 537cf4e3cc2f and 537cf4e3cc2f^ and
it only reproduces on 537cf4e3cc2f^ here (with the same stack trace as
the syzbot report).

The repro I used was
https://syzkaller.appspot.com/text?tag=ReproSyz&x=10d10006500000 which
is just:

r0 = socket$xdp(0x2c, 0x3, 0x0)
setsockopt$XDP_UMEM_REG(r0, 0x11b, 0x4,
&(0x7f0000000040)={&(0x7f0000000000)=""/2, 0x1000000, 0x1000}, 0x20)

so the socket definitely gets created/destroyed.

Feel free to undo if you disagree:

#syz fix: xsk: Fix umem cleanup bug at socket destruct


Vegard
