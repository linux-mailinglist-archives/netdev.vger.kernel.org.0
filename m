Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133E855963
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfFYUuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:50:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45701 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:50:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so19987426qtr.12;
        Tue, 25 Jun 2019 13:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S3ThzB0FxOM43lC1HEahXxVTCZ708F6Vcodz7HniaZE=;
        b=KJ0ZXzXcIbKjkt0vtSCVpLnvHNFsgh09BQvaDlX2cIajjSEJRD3sQEZ06utl5qCFUa
         1O3bXsnM1MmOH5DsjYr3tA08qMxDgZJsNe+cb52zQSHF0rjf+cvuLXPCrhIZfkM7nF4f
         6rvydx382/mUSU5iX6UNgFbo22l1CRLfyZ9Yp9uvNtAgrke+9OQuHf+KElua5K2uLyq/
         FUTKJxtGWE5DOxcrsjldXQLSlb0ALM+/26F9pS61Qhjg64TSRYSlMVWITMhfRar6Uapg
         WJrFBijBdSDWfi+3lQXyEVKv3Yzt9wMeOWozckx11Yqr583pB/vGIFNJ7Vc9JXMhIkec
         vOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S3ThzB0FxOM43lC1HEahXxVTCZ708F6Vcodz7HniaZE=;
        b=YxkfLVKSrxGvn4RS8BKMVONl4U9/3Ikm5LrALIUHzm2lI41OTUneJqfwSXF1S5+MUk
         10lAwlO1qgB+y9tPnjKWTJo5aCW0ec+um6q7tcNyuwICzdEX/+quszi8zpM4WG/cENGQ
         0CD+qt8+C2ZN75DjnQvcDudwcujafIH+aj2afraAeUqrjCwnKU37G6TGjBAjHtu448U0
         ufXCj0+XjmGdSzNHzj1hd8uszAIHwbTt6HA0gyhF5T5nXy/AlGUyiXdST23gZ1oPrkey
         P3Ya9hV5hhACCXx1HNCPu+fiT+iLsRaxjMR23hjiSoH1IqqbmWuEUU4o/GQIKmsSj+uW
         2Yqg==
X-Gm-Message-State: APjAAAWRiadi1LqocMcctTGsbOrLUzm7PBFHsTo7M0u3tWBkQAvlQZgi
        Og1YvyM2r6u0sHIUQk9gKlZf7LpveCBIlUmn4sM=
X-Google-Smtp-Source: APXvYqx5XvW72PBr4mzP6TPvyWK17Tww9Cw49TQ5skdGckn/X36eEwJeLI791JpLuYoOddkGNNaPUHlzdAHDYMIYamQ=
X-Received: by 2002:a0c:d0b6:: with SMTP id z51mr256561qvg.3.1561495803720;
 Tue, 25 Jun 2019 13:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190625182352.13918-1-natechancellor@gmail.com> <34F07894-FDE7-44F8-B7F2-E2003D550AD2@gmail.com>
In-Reply-To: <34F07894-FDE7-44F8-B7F2-E2003D550AD2@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 25 Jun 2019 22:49:52 +0200
Message-ID: <CAJ+HfNjKHG2dmu_juCJE5Xjo4HR4wqfk=yNPSAz8i7YbEWq6uw@mail.gmail.com>
Subject: Re: [PATCH] xsk: Properly terminate assignment in xskq_produce_flush_desc
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 at 22:04, Jonathan Lemon <jonathan.lemon@gmail.com> wro=
te:
>
>
>
> On 25 Jun 2019, at 11:23, Nathan Chancellor wrote:
>
> > Clang warns:
> >
> > In file included from net/xdp/xsk_queue.c:10:
> > net/xdp/xsk_queue.h:292:2: warning: expression result unused
> > [-Wunused-value]
> >         WRITE_ONCE(q->ring->producer, q->prod_tail);
> >         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
> >         __u.__val;                                      \
> >         ~~~ ^~~~~
> > 1 warning generated.
> >
> > The q->prod_tail assignment has a comma at the end, not a semi-colon.
> > Fix that so clang no longer warns and everything works as expected.
> >
> > Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/544
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Nice find.
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>

Yikes. Yes, nice find, indeed.

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

The broader question is "Why does it work at all?", which is an "oh no" mom=
ent.

The problematic functions are xsk_flush() and xsk_generic_rcv, where
xskq_produce_flush_desc() is inlined. On the test machine, the GCC
version is:

$ gcc --version
gcc (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I when I diff the output, both .lst and .o:

$ diff -u old.lst new.lst
--- old.lst     2019-06-25 22:10:57.709591605 +0200
+++ new.lst     2019-06-25 22:10:35.301359865 +0200
@@ -2480,7 +2480,7 @@
     1566:      48 8b 87 e0 02 00 00    mov    0x2e0(%rdi),%rax
 {
     156d:      48 89 e5                mov    %rsp,%rbp
-       q->prod_tail =3D q->prod_head,
+       q->prod_tail =3D q->prod_head;
     1570:      8b 50 18                mov    0x18(%rax),%edx
     1573:      89 50 1c                mov    %edx,0x1c(%rax)
        WRITE_ONCE(q->ring->producer, q->prod_tail);
@@ -2649,7 +2649,7 @@
     16fb:      83 40 24 01             addl   $0x1,0x24(%rax)
        xskq_produce_flush_desc(xs->rx);
     16ff:      49 8b 86 e0 02 00 00    mov    0x2e0(%r14),%rax
-       q->prod_tail =3D q->prod_head,
+       q->prod_tail =3D q->prod_head;
     1706:      8b 50 18                mov    0x18(%rax),%edx
        xs->sk.sk_data_ready(&xs->sk);
     1709:      4c 89 f7                mov    %r14,%rdi

$ diff -u <(gdb -batch -ex 'file old.o' -ex 'disassemble xsk_flush')
<(gdb -batch -ex 'file new.o' -ex 'disassemble xsk_flush') && echo
"Whew"
Whew

$ diff -u <(gdb -batch -ex 'file old.o' -ex 'disassemble
xsk_generic_rcv') <(gdb -batch -ex 'file new.o' -ex 'disassemble
xsk_generic_rcv') && echo "Whew"
Whew

struct xsk_queue {
        u64                        chunk_mask;           /*     0   0x8 */
        u64                        size;                 /*   0x8   0x8 */
        u32                        ring_mask;            /*  0x10   0x4 */
        u32                        nentries;             /*  0x14   0x4 */
        u32                        prod_head;            /*  0x18   0x4 */
        u32                        prod_tail;            /*  0x1c   0x4 */
        u32                        cons_head;            /*  0x20   0x4 */
        u32                        cons_tail;            /*  0x24   0x4 */
        struct xdp_ring *          ring;                 /*  0x28   0x8 */
        u64                        invalid_descs;        /*  0x30   0x8 */

        /* size: 56, cachelines: 1, members: 10 */
        /* last cacheline: 56 bytes */
};

So, it appears that the generated code is equal, both in xsk_flush()
and xsk_generic_rcv() where flush was inlined. I'll be digging into
more GCC versions, and observe the generated code.

Regardless, this was a really good find. Thank you very much! Clang is
added to my kernel build workflow from now on...


Bj=C3=B6rn



>
> > ---
> >  net/xdp/xsk_queue.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > index 88b9ae24658d..cba4a640d5e8 100644
> > --- a/net/xdp/xsk_queue.h
> > +++ b/net/xdp/xsk_queue.h
> > @@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct
> > xsk_queue *q)
> >       /* Order producer and data */
> >       smp_wmb(); /* B, matches C */
> >
> > -     q->prod_tail =3D q->prod_head,
> > +     q->prod_tail =3D q->prod_head;
> >       WRITE_ONCE(q->ring->producer, q->prod_tail);
> >  }
> >
> > --
> > 2.22.0
