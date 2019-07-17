Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9186B5CE
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 07:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfGQFMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 01:12:10 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42692 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfGQFMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 01:12:10 -0400
Received: by mail-io1-f65.google.com with SMTP id e20so13444437iob.9;
        Tue, 16 Jul 2019 22:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P18LXWJzk1p3M6n7gC2JDodduYn4DY2FTMI41+jZyT0=;
        b=Tk6eJLjoxwEWfbJ1R9yNN/xvwvCFcn6jevVofyziU4rraBbexRzuLmbzgEIzt7BRm4
         JiJloO5j9Lr46CXJCVqxX3TtKOlZcUJ/7kLtkTjkjkK87XVWnWFx8Xsbp8RakzQsuA47
         v/2nM2TYg0W0RWQWQUein3ZDySHmYGAwmMvvwsLCP1S4TPSxiWrM8jxPzYI6SWfhHsSm
         W0i8MB2pzGU74XmJqrrw9MMachL+/3mYp60IAndsHtd01lQgrtvBYor1bvptu0Uc6mVG
         MqiitrvMXOhUMc/Td0e40tAQflcLLKPz6nkejsjb1whPX/3rwF7QB5uFkqPeSaHDtxUf
         uMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P18LXWJzk1p3M6n7gC2JDodduYn4DY2FTMI41+jZyT0=;
        b=IUQltA3l0BH6xJY0dVbjpsMXT3de6+okdyYs5c31s9wB/cgqWSXmMuyBqNi5zCmN4m
         3Q2NopQGoZLbv3+VppgWtia/SonktSFI0Httdn/XmNj4Ci1XbHEhOcYXmvKiR397o+Ih
         h69qDPYpobQw01QEGtF0hl1vVB0yoL95tb5uWcQrio5aN0sOl130WQ6cIi0f5J95fVL2
         6I3euKpDjYebsFcx7zE6LRxd0Kbau2OW5ABtiLcIWZXCZaC/uaApPvqzwhpfhhnSo81S
         SFT9HBCHv6yFv09m6J/pFMJQSRrgULdMSiZuWm31Bh/siOG0kSRL4hYrUDYhKBNAHmly
         UV3Q==
X-Gm-Message-State: APjAAAVZ+YC6veK9r0oMjwQWlyvGdNQx3S5BwKRbf5XRaHwFesKdX6Nb
        Js3cCxlWcwDLXqx5LZOkJwmgvzMvwG0KtMnbl7Y=
X-Google-Smtp-Source: APXvYqw5i2iP5ADet8mgqdNpv/krQffvuHM3py6o6iv6RWgaojGA9sAUZNW9gY/oj5YXgefloa63u1qWUFVv82HNjTk=
X-Received: by 2002:a02:ce35:: with SMTP id v21mr37798136jar.108.1563340329468;
 Tue, 16 Jul 2019 22:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190716115910.23093-1-iii@linux.ibm.com> <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
In-Reply-To: <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 16 Jul 2019 22:11:33 -0700
Message-ID: <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[sorry, resend again as previous one has come text messed out due to
networking issues]

On Tue, Jul 16, 2019 at 10:08 PM Y Song <ys114321@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 4:59 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> >
> > test_pkt_md_access is failing on s390, since the associated eBPF prog
> > returns TC_ACT_SHOT, which in turn happens because loading a part of a
> > struct __sk_buff field produces an incorrect result.
> >
> > The problem is that when verifier emits the code to replace partial load
> > of a field with a full load, a shift and a bitwise AND, it assumes that
> > the machine is little endian.
> >
> > Adjust shift count calculation to account for endianness.
> >
> > Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > ---
> >  kernel/bpf/verifier.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 5900cbb966b1..3f9353653558 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -8616,8 +8616,12 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
> >                 }
> >
> >                 if (is_narrower_load && size < target_size) {
> > -                       u8 shift = (off & (size_default - 1)) * 8;
> > -
> > +                       u8 load_off = off & (size_default - 1);
> > +#ifdef __LITTLE_ENDIAN
> > +                       u8 shift = load_off * 8;
> > +#else
> > +                       u8 shift = (size_default - (load_off + size)) * 8;
> > +#endif
>
All the values are in register. The shifting operations should be the
same for big endian and little endian, e.g., value 64 >> 2 = 16 when
value "64" is in register. So I did not see a problem here.

Could you elaborate which field access in test_pkt_md_access
caused problem?

It would be good if you can give detailed memory layout and register values
to illustrate the problem.

>
> >                         if (ctx_field_size <= 4) {
> >                                 if (shift)
> >                                         insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
> > --
> > 2.21.0
> >
