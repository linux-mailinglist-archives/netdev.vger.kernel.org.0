Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508246C31D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbfGQWYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:24:15 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41590 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730024AbfGQWYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:24:10 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so44144570ioj.8;
        Wed, 17 Jul 2019 15:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fDeKn3uN3wytZ2t0L3sE7vCP06WtjLEk5eDod7cbjI4=;
        b=Br68CkeHsICqhX1gDg1HSw/XfGkf+GHJ3PnCdWsdeoCGgsnE4yneLQtDP0FbGmb79n
         vn08ZelTZVDe0U/T4gCI7yqDChlhveuCfljOClISre8675+35cWq/1YQXi0Yfg3a30cD
         N8i+hjsrZiWnnO01mUiXBKil5CTV19KZpZ903zBpC8wT/igynHbsznfaqkedBoJdJsG1
         68u0/P6YyrVeAb66avTCEvJK9OV29mRvmR5oNPKkguhSv8UAatM0EeQv+kmMw+N9RoL2
         jiJKe1vA81t1mV/Yw/r01yfg3Rx2D3xqCdv5r27SFFdo94yODy9Rq8+LPyFW2ddQochc
         P29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fDeKn3uN3wytZ2t0L3sE7vCP06WtjLEk5eDod7cbjI4=;
        b=pk/vrU0d7U3cezgm2M0ngSvPLDHZjPhzW/TAMBDqel35cRehCIgApzg83eC11R7tsY
         I4qBpLEGG2pptzV2pqvG4at/Ta7RQHwLorM385oLDUQHGXcbSqaQAKAjmDCigc59cWtA
         meTfs4ZxnNZ1mRW0wPj0OeLtQ4kU9058VBFqQNRA7BpZtr9PFMzMlNPj5eQmQ7xKPIXE
         wgtnruN9lDjLeHxqpXeQNiWvksiIguxw7PE+Xrl8dOplx43qNsY/W219ODsE2qSItJSA
         fdJvT6Qq7sISVvHvfMFjy1w9uKSwHG5ArKGCGTTw+Q37je2rQZwMPVWXFLtUUnGbK8n2
         HtTQ==
X-Gm-Message-State: APjAAAXOipL4LNE+ac9nbEw4Z6wEjrSOh15sXgPWI2EKaGqzCXW2+CeB
        d0cOb4DXEgG69BydoY3qCdbw3qltLd+0jvgHbXSLCym8
X-Google-Smtp-Source: APXvYqxz0xN5dK3q0nt6WX/aBKnGZMdAywqDpOJKZp4G/tPh4y4jTwdVlb0VUIO9miKzc6fLZhrYtoTzCdXzYSA1dwk=
X-Received: by 2002:a6b:bf01:: with SMTP id p1mr11324367iof.181.1563402248853;
 Wed, 17 Jul 2019 15:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190716115910.23093-1-iii@linux.ibm.com> <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
 <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
 <98C6AA13-A44D-4FF1-BA73-1BD446BD773A@linux.ibm.com> <4311B5C3-8D1B-4958-9CDE-450662A7851D@linux.ibm.com>
 <CAH3MdRV-qsJnyZVV1GnxRZ4=3KXTvKSgETp90fyevxycmAiHmA@mail.gmail.com> <B91434A8-6056-49E2-852D-6DE5FFD53B29@linux.ibm.com>
In-Reply-To: <B91434A8-6056-49E2-852D-6DE5FFD53B29@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 17 Jul 2019 15:23:32 -0700
Message-ID: <CAH3MdRUXJBf5qQFkUZ5x3X=ziXE8Ou7O1cH_WJvyXVpEtQQ0nQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 1:52 PM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> > Am 17.07.2019 um 18:25 schrieb Y Song <ys114321@gmail.com>:
> >
> > On Wed, Jul 17, 2019 at 3:36 AM Ilya Leoshkevich <iii@linux.ibm.com> wr=
ote:
> >>
> >>
> >> Here is a better one: len=3D0x11223344 and we would like to do
> >> ((u8 *)&len)[3].
> >>
> >> len is represented as `11 22 33 44` in memory, so the desired result i=
s
> >> 0x44. It can be obtained by doing (*(u32 *)&len) & 0xff, but today the
> >> verifier does ((*(u32 *)&len) >> 24) & 0xff instead.
> >
> > What you described above for the memory layout all makes sense.
> > The root cause is for big endian, we should do *((u8 *)&len + 3).
> > This is exactly what macros in test_pkt_md_access.c tries to do.
> >
> > if  __BYTE_ORDER__ =3D=3D __ORDER_LITTLE_ENDIAN__
> > #define TEST_FIELD(TYPE, FIELD, MASK)                                  =
 \
> >        {                                                               =
\
> >                TYPE tmp =3D *(volatile TYPE *)&skb->FIELD;             =
  \
> >                if (tmp !=3D ((*(volatile __u32 *)&skb->FIELD) & MASK)) =
  \
> >                        return TC_ACT_SHOT;                             =
\
> >        }
> > #else
> > #define TEST_FIELD_OFFSET(a, b) ((sizeof(a) - sizeof(b)) / sizeof(b))
> > #define TEST_FIELD(TYPE, FIELD, MASK)                                  =
 \
> >        {                                                               =
\
> >                TYPE tmp =3D *((volatile TYPE *)&skb->FIELD +           =
  \
> >                              TEST_FIELD_OFFSET(skb->FIELD, TYPE));     =
\
> >                if (tmp !=3D ((*(volatile __u32 *)&skb->FIELD) & MASK)) =
  \
> >                        return TC_ACT_SHOT;                             =
\
> >        }
> > #endif
> >
> > Could you check whether your __BYTE_ORDER__ is set
> > correctly or not for this case? You may need to tweak Makefile
> > if you are doing cross compilation, I am not sure how as I
> > did not have environment.
>
> I=E2=80=99m building natively on s390.
>
> Here is the (formatted) preprocessed C code for the first condition:
>
> {
>         __u8 tmp =3D *((volatile __u8 *)&skb->len +
>                 ((sizeof(skb->len) - sizeof(__u8)) / sizeof(__u8)));
>         if (tmp !=3D ((*(volatile __u32 *)&skb->len) & 0xFF)) return 2;
> };
>
> So I believe the endianness is chosen correctly.
>
> Here is the clang-generated BPF bytecode for the first condition:
>
> # llvm-objdump -d test_pkt_md_access.o
> 0000000000000000 process:
>        0:       71 21 00 03 00 00 00 00 r2 =3D *(u8 *)(r1 + 3)
>        1:       61 31 00 00 00 00 00 00 r3 =3D *(u32 *)(r1 + 0)
>        2:       57 30 00 00 00 00 00 ff r3 &=3D 255
>        3:       5d 23 00 1d 00 00 00 00 if r2 !=3D r3 goto +29 <LBB0_10>
>
> This also looks good to me.
>
> Finally, here is the verifier-generated BPF bytecode:
>
> # bpftool prog dump xlated id 14
> ; TEST_FIELD(__u8,  len, 0xFF);
>    0: (61) r2 =3D *(u32 *)(r1 +104)
>    1: (bc) w2 =3D w2
>    2: (74) w2 >>=3D 24
>    3: (bc) w2 =3D w2
>    4: (54) w2 &=3D 255
>    5: (bc) w2 =3D w2
>
> Here we can see the shift that I'm referring to. I believe we should
> translate *(u8 *)(r1 + 3) in this case without this shift on big-endian
> machines.

Thanks for the detailed illustration.
Now, with your detailed output of byte codes and xlated program, it
indeed becomes apparent
that verifier should not do shift at insn 2.

I was correct that after insn 0, register r2 should hold the same
value for big and little endian.
But I missed the fact in the first review that insn->off for original
first insn is different.
r2 =3D *(u8 *)(r1 + 3), the first insn on big endian, and r2 =3D *(u8 *)r1
for little endian.
They should really have the same shift amount.

Therefore, indeed, shifting amount is actually different between big
and little endians.
So your code is correct. Could you add a macro in linux/filter.h? Most
narrow load related
macros are there? This way, we maintain verifier.c __BYTE_ORDER__ macro fre=
e.

Also, could you put your above analysis in the commit message? This will he=
lp
reasoning the change easily later on.

Thanks!

>
> Best regards,
> Ilya
