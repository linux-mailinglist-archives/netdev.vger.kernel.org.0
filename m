Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D6178A53
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 06:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCDFoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 00:44:37 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44960 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDFoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 00:44:37 -0500
Received: by mail-qt1-f193.google.com with SMTP id h16so497821qtr.11;
        Tue, 03 Mar 2020 21:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xxd5vo5QurLpt9L4qMgvVJGSW6Osjywwb4CYHY+R/FQ=;
        b=BMACOv8P0xReQkbncNGFSPzZ3rQdGF2v1ChmfuqjrARLtnn8UOV7/lwxSr51C0/AmE
         sRQUcJCtLZWFNIEEIDlZYM+qp0LD+vQYHon7Ctcl30PZGHjpEiEWbTsEXKqbEpjFWLkS
         L7EKmlS9Kh+Kgjzt2nJ4MS+h6dc2FNAnAawxrG58L6F+DELKIxz5r7beLE3cyhLmdsMW
         ApKWVieoR7chO1lSQu/mfH6ZciWQmaLqqWmh+KTYYw7xUy8+GcI2m1jPwh8jaURIKISp
         bKpBO6ex9JVX6yxUvfbUtPgaWzD7wbKoQSzot9J9ytGJ0S7VBX1cYohBKpvPZrYCJeS4
         Nvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xxd5vo5QurLpt9L4qMgvVJGSW6Osjywwb4CYHY+R/FQ=;
        b=JIStuwm3r++Tb7RbNDAm4XO0rTxRM645HCAGsoscbWEJ7PWuyy82qpqgQ73q/gZvqi
         0G6hJ9LAsfhaXMSaw0WINoPiR/JbQVrXypMj7n8ZCfXwlBTsfenSBGORe12ocC6kSBOI
         19cJQx3Ac/7gRGOR7kwbhFjYxXQFL8Pgwgp06Gmh57sGbMvzLrJSmbErfF0A/BlgHdrD
         2+b6wi3FlLFUXkbgQCJNN1AvCijU9+fSsu95gQ1T2zlUnBCboJzSmQ5BcgIqZJXofpvn
         tZeFqfxucgVhab1UFZfh4xLCTH7uuf+i3CHzWiNvp30na/8LG7sHtbtyrfLegaKWXiE2
         nZOg==
X-Gm-Message-State: ANhLgQ09X40+lUViWWv0KaQS7R7IaVUYwKVbFRoD/A5khaSxejmiPxxn
        X7yhtx2F/nV0BovFRASp5wV2IbiQ+i18SG3iVnA=
X-Google-Smtp-Source: ADFU+vuuhdqZ2hCGsDWcuSl7ClmlWIERn+UP536E/3crNluJT8VOzWB/pNm3rv2JaT9L3trW6Z0lljEuI1NFAvscL9Q=
X-Received: by 2002:aed:39c9:: with SMTP id m67mr1008871qte.107.1583300675522;
 Tue, 03 Mar 2020 21:44:35 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-2-luke.r.nels@gmail.com>
 <CAJ+HfNhSj9ycgh8Y44b_ZruW1A=+W_53fXnCDc488WXSESJ3dw@mail.gmail.com> <CADasFoC5EEXdq43waj9pQDb9HtpG2bWE2yMVySBZ4rpopYbROQ@mail.gmail.com>
In-Reply-To: <CADasFoC5EEXdq43waj9pQDb9HtpG2bWE2yMVySBZ4rpopYbROQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 4 Mar 2020 06:44:24 +0100
Message-ID: <CAJ+HfNgHyX_zMh7Wm00twwY75YLftZ8GFMw3rx5k+yiLH8p0eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] riscv, bpf: move common riscv JIT code to header
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 at 03:31, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> Hi Bj=C3=B6rn,
>
> Thanks for the comments! Inlined responses below:
>
> On Mon, Mar 2, 2020 at 11:50 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * Common functionality for RV32 and RV64 BPF JIT compilers
> > > + *
> > > + * Copyright (c) 2019 Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > > + * Copyright (c) 2020 Luke Nelson <luke.r.nels@gmail.com>
> > > + * Copyright (c) 2020 Xi Wang <xi.wang@gmail.com>
> >
> > I'm no lawyer, so this is more of a question; You've pulled out code
> > into a header, and renamed two functions. Does that warrant copyright
> > line additions? Should my line be removed?
>
> This header also includes new code for emitting instructions required
> for the RV32 JIT (e.g., sltu) and some additional pseudoinstructions
> (e.g., bgtu and similar). I'm also no lawyer, so I don't know either
> if this rises to the level of adding copyright lines. I'm happy to
> do the following in v5 if it looks better:
>
> + * Copyright (c) 2019 Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> + *
> + * Modified by ...
>

Ah, my mistake! Feel free to keep the Copyright. I was honestly just
curious what the correct way (if any) was. So; Keep your copyright!
Sorry for the noise!

> > > +#if __riscv_xlen =3D=3D 64
> >
> > Please remove this. If the inlined functions are not used, they're not
> > part of the binary. This adds complexity to the code, and without it
> > we can catch build errors early on!
>
> I agree in general we should avoid #if. The reason for using it
> here is to cause build errors if the RV32 JIT ever tries to emit
> an RV64-only instruction by mistake. Otherwise, what is now a build
> error would be delayed to an illegal instruction trap when the JITed
> code is executed, which is much harder to find and diagnose.
>
> We could use separate files, bpf_jit_32.h and bpf_jit_64.h (the
> latter will include the former), if we want to avoid #if. Though
> this adds another form of complexity.
>
> So the options here are 1) using no #if, with the risk of hiding
> subtle bugs in the RV32 JIT; 2) using #if as is; and 3) using
> separate headers. What do you think?
>

Ok, that is a valid concern. We could go the route of compile-time checking=
:

if (__riscv_xlen !=3D 64)
    bad_usage();

That's overkill in this case. Keep the #if.


Cheers,
Bj=C3=B6rn


> Thanks!
>
> Luke
