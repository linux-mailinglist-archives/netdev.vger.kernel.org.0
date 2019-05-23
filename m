Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C00C27766
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEWHtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:49:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44007 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEWHtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:49:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id i26so5617153qtr.10;
        Thu, 23 May 2019 00:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zsBZLzsSkG2Thvu7NvXAA1EVdlKzHSGn/2dZlRnXby4=;
        b=Z/ZnEg+Y9xdYLtG+IIAkTFQVNNqV+HFUeEDzOGffJuhDhN6NfagXkvx4Wdxs3GRAAC
         oQGnbznsL5uHErzhPtmaAPBQMmI4xMog9YDj1E4i37eJ21n4XBjZzHveJf2Rmu8SQOgU
         PMQHutZiphjGyV4DeHtIJZQBgS30sZMW/MJnjs99h50fjOuiKKAonyT1zj7BQRSzvub6
         gEWzEgjLPw7jyq8n8y/PCNOoprG91Lu8D7/BvFUpqhKLNpB6CgvnplZd46y6tIW1HC5v
         EGRZvHZmXsyi47NJwCK/fbxCQrKENtsYcjwKSvObx8PUkzQkbfLIHkGEzu1Am/bih/TQ
         zLOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zsBZLzsSkG2Thvu7NvXAA1EVdlKzHSGn/2dZlRnXby4=;
        b=TiVD7cgptSOtugVaW9ToG0c6Rd4Cy3wGJ73A3yJhFObILYBosOHzpeG+IztFpKsepz
         zd885VxstOCFtIWDfVNJIjPGYRCSpwGa8XRIl8gY9S2p266GbtYd5oVWUXJ9wgqNtwSk
         aUy1cw/tR9hpfYX0tT/mIUFezE1RUWImnZzgwcdcvIBwWHNs2Kmaimf5s2qqD1wAcGRr
         YGJpkaE2abhfDDQoxcFZ2xbwBEsvdghnx4ygep4l2yIWO69Tir09UfDiNwAB8RLv5gp/
         y3e5ZPrEvWhqUQIINhVegkVoO0mSUg7b7nlkWctczfdNQ9B2cItvgTsSlk0CDi6n4q7z
         lM+w==
X-Gm-Message-State: APjAAAXNBIXImRQHs0JimxxqdI7M+8XIR7PAjc6JMlYadWiF7WFZ3G4L
        xWiMlv8pRUBwOQnqDJOlmD9WYk7CF1JyonANV0A=
X-Google-Smtp-Source: APXvYqwcNKXhJYPs7as3t5b/KabbA0YgE+fVdKPLvkWvKN8jgehrKSWYLAscm1k0jx8mxQIDE4v/qyruGDsCVe8RkuA=
X-Received: by 2002:aed:21b8:: with SMTP id l53mr79192886qtc.36.1558597743542;
 Thu, 23 May 2019 00:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190522092323.17435-1-bjorn.topel@gmail.com> <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
 <CAJ+HfNhR2UozhqTrhDTmZNntmjRCWFyPyU2AaRdo-E6sJUZCKg@mail.gmail.com> <CAH3MdRX6gocSFJCkuMuhko+0eheWqKq4Y4X-Tb3q=hzMW5buyw@mail.gmail.com>
In-Reply-To: <CAH3MdRX6gocSFJCkuMuhko+0eheWqKq4Y4X-Tb3q=hzMW5buyw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 23 May 2019 09:48:52 +0200
Message-ID: <CAJ+HfNhLDB88=kSYYTny0Pu1FccfKgP1vkU6FV3ze=PvuO5zrw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32 and/or/xor
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 at 08:39, Y Song <ys114321@gmail.com> wrote:
>
> On Wed, May 22, 2019 at 1:46 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > On Wed, 22 May 2019 at 20:13, Y Song <ys114321@gmail.com> wrote:
> > >
> > > On Wed, May 22, 2019 at 2:25 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gm=
ail.com> wrote:
> > > >
> > > > Add three tests to test_verifier/basic_instr that make sure that th=
e
> > > > high 32-bits of the destination register is cleared after an ALU32
> > > > and/or/xor.
> > > >
> > > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > >
> > > I think the patch intends for bpf-next, right? The patch itself looks
> > > good to me.
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > >
> >
> > Thank you. Actually, it was intended for the bpf tree, as a test
> > follow up for this [1] fix.
> Then maybe you want to add a Fixes tag and resubmit?

Hmm, I thought that adding tests were OK for non-next. Should the
Fixes: tag for the test reflex the corresponding fixed code (in this
case the RV JIT)?

> >
> >
> > Cheers,
> > Bj=C3=B6rn
> >
> > [1] https://lore.kernel.org/bpf/CAJ+HfNifkxKz8df7gLBuqWA6+t6awrrRK6oW6m=
1nAYETJD+Vfg@mail.gmail.com/
> >
> > > > ---
> > > >  .../selftests/bpf/verifier/basic_instr.c      | 39 +++++++++++++++=
++++
> > > >  1 file changed, 39 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/verifier/basic_instr.c b/t=
ools/testing/selftests/bpf/verifier/basic_instr.c
> > > > index ed91a7b9a456..4d844089938e 100644
> > > > --- a/tools/testing/selftests/bpf/verifier/basic_instr.c
> > > > +++ b/tools/testing/selftests/bpf/verifier/basic_instr.c
> > > > @@ -132,3 +132,42 @@
> > > >         .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > >         .result =3D ACCEPT,
> > > >  },
> > > > +{
> > > > +       "and32 reg zero extend check",
> > > > +       .insns =3D {
> > > > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > > > +       BPF_MOV64_IMM(BPF_REG_2, -2),
> > > > +       BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_2),
> > > > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > > > +       BPF_EXIT_INSN(),
> > > > +       },
> > > > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > > +       .result =3D ACCEPT,
> > > > +       .retval =3D 0,
> > > > +},
> > > > +{
> > > > +       "or32 reg zero extend check",
> > > > +       .insns =3D {
> > > > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > > > +       BPF_MOV64_IMM(BPF_REG_2, -2),
> > > > +       BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_2),
> > > > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > > > +       BPF_EXIT_INSN(),
> > > > +       },
> > > > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > > +       .result =3D ACCEPT,
> > > > +       .retval =3D 0,
> > > > +},
> > > > +{
> > > > +       "xor32 reg zero extend check",
> > > > +       .insns =3D {
> > > > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > > > +       BPF_MOV64_IMM(BPF_REG_2, 0),
> > > > +       BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_2),
> > > > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > > > +       BPF_EXIT_INSN(),
> > > > +       },
> > > > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > > +       .result =3D ACCEPT,
> > > > +       .retval =3D 0,
> > > > +},
> > > > --
> > > > 2.20.1
> > > >
