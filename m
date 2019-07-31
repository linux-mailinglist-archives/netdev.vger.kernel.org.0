Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EBD7CA2B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 19:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfGaRTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 13:19:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44325 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfGaRTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 13:19:12 -0400
Received: by mail-qt1-f193.google.com with SMTP id 44so36323293qtg.11;
        Wed, 31 Jul 2019 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vut+5SeKuwpmKhsOF9oU2Lng89koznQFCQaV72q2LU0=;
        b=ih56czYcuESrpyj0QPqSlmg1K/i3SbpONEJLka7Gdd33DQRsvzyRqIjXCs3hXEcTjZ
         RW9DpX8aRvJ0xOu+e1Xj0xL6hsjybOG+Kkj1FpffEXOAyTZXAmquc8vYoqzBLks9VxjN
         ND0FicxKvmdab8B69jyoESSe3YkaIeZpKqgFOOpRpOzpfWZkfMEZJyZe08VlBNtbPgmv
         tPpfSPwxLfpfSM58mijETtX0gRYQWshdB5Do7nOpdtraUs+DjmHd1MjcFKk/bkst+5O7
         PxaaLVKR/iSRA07G5SD7mMsOjDyM+X+2GqzbePeFLEGuThfzqYnfwsllPXaon15/Lstf
         4tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vut+5SeKuwpmKhsOF9oU2Lng89koznQFCQaV72q2LU0=;
        b=r7rdLnfTDr89981ul3H3Eqbbh8W8O1lblJouiy7SwRBStSUXi4kPDN2kmdOhQEr/wy
         93t7M3bk3xROS8z7bSs/6VccUEcpDWe7H7d/J97yqEg+LSECzEMI+pN61FNQAFfRHcyI
         GHiCJssqcCWgwL6xJkBHLz3GTo8gdAz4yOgsbJpkLjBBtFAeF5k5yduoegk10Cc2Wuip
         87f8Qaq4wMZ6nc11T/b95XO/o/38tFWH0qZTUCvaQoyWyk17JzXZAGwG2ATZU4wkYtnx
         BZ/cRMpRb0w6myQXVRB/HkWKeI5W1XPEjMnL39SNwdh1qnKoZVvP4ICCkFCxou17ASXg
         7sSw==
X-Gm-Message-State: APjAAAUHGbzIJMhm5qIds9WbXqklfH9I0ErbJlNDty4Lugn5CTkADRyH
        pHqVBNv3pquwqDNgKCA1xSq5S5GqJb7GBJ7mHxw=
X-Google-Smtp-Source: APXvYqxInSQiHD5IMjegweTtiNlen9k3On+wJwxkv9Vr7aN8iNTGd1sCJ6NLemC79U+PeZu2WD/9OkZcDv313xy1Yso=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr84527111qty.59.1564593550813;
 Wed, 31 Jul 2019 10:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190730195408.670063-1-andriin@fb.com> <20190730195408.670063-3-andriin@fb.com>
 <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com> <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
 <AA9B5489-425E-4FAE-BE01-F0F65679DF00@fb.com> <CAEf4Bza3cAoZJE+24_MBiv-8yYtAaTkAez5xq1v12cLW1-RGcw@mail.gmail.com>
 <4D2E1082-5013-4A50-B75D-AB88FDCAAC52@fb.com>
In-Reply-To: <4D2E1082-5013-4A50-B75D-AB88FDCAAC52@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Jul 2019 10:18:59 -0700
Message-ID: <CAEf4Bzb6swYtf7J_m1bZo6o+aT1AcCXZX5ZBw7Uja=Tne2LCuw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 1:30 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 11:52 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jul 30, 2019 at 10:19 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Jul 30, 2019, at 6:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Tue, Jul 30, 2019 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>>> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >>>>>
> >>>>> This patch implements the core logic for BPF CO-RE offsets relocations.
> >>>>> Every instruction that needs to be relocated has corresponding
> >>>>> bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> >>>>> to match recorded "local" relocation spec against potentially many
> >>>>> compatible "target" types, creating corresponding spec. Details of the
> >>>>> algorithm are noted in corresponding comments in the code.
> >>>>>
> >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> [...]
>
> >>>>
> >>>
> >>> I just picked the most succinct and non-repetitive form. It's
> >>> immediately apparent which type it's implicitly converted to, so I
> >>> felt there is no need to repeat it. Also, just (void *) is much
> >>> shorter. :)
> >>
> >> _All_ other code in btf.c converts the pointer to the target type.
> >
> > Most in libbpf.c doesn't, though. Also, I try to preserve pointer
> > constness for uses that don't modify BTF types (pretty much all of
> > them in libbpf), so it becomes really verbose, despite extremely short
> > variable names:
> >
> > const struct btf_member *m = (const struct btf_member *)(t + 1);
>
> I don't think being verbose is a big problem here. Overusing

Problem is too big and strong word to describe this :). It hurts
readability and will often quite artificially force either wrapping
the line or unnecessarily splitting declaration and assignment. Void *
on the other hand is short and usually is in the same line as target
type declaration, if not, you'll have to find local variable
declaration to double-check type, if you are unsure.

Using (void *) + implicit cast to target pointer type is not
unprecedented in libbpf:

$ rg ' = \((const )?struct \w+ \*\)' tools/lib/bpf/ | wc -l
52
$ rg ' = \((const )?void \*\)' tools/lib/bpf/  | wc -l
35

52 vs 35 is majority overall, but not by a landslide.

> (void *) feels like a bigger problem.

Why do you feel it's a problem? void * conveys that we have a piece of
memory that we will need to reinterpret as some concrete pointer type.
That's what we are doing, skipping btf_type and then interpreting
memory after common btf_type prefix is some other type, depending on
actual BTF kind. I don't think void * is misleading in any way.

In any case, if you still feel strongly about this after all my
arguments, please let me know and I will convert them in this patch
set. It's not like I'm opposed to use duplicate type names (though it
does feel sort of Java-like before it got limited type inference),
it's just in practice it leads to unnecessarily verbose code which
doesn't really improve anything.

>
> >
> > Add one or two levels of nestedness and you are wrapping this line.
> >
> >> In some cases, it is not apparent which type it is converted to,
> >> for example:
> >>
> >> +       m = (void *)(targ_type + 1);
> >>
> >> I would suggest we do implicit conversion whenever possible.
> >
> > Implicit conversion (`m = targ_type + 1;`) is a compilation error,
> > that won't work.
>
> I misused "implicit" here. I actually meant to say
>
>         m = ((const struct btf_member *)(t + 1);

Ah, so you meant explicit, yep. It's either `void *` or `const struct
something *` then.

>
>
>
