Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7E123F85
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfLRGXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:23:50 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:34820 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfLRGXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:23:50 -0500
Received: by mail-qv1-f65.google.com with SMTP id u10so253926qvi.2;
        Tue, 17 Dec 2019 22:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=83wGPErMOeYaxiZ5aYYnzkstX9KM8EIS3DlEeudi+x4=;
        b=qh94WHFKzmWpOxhmketEE7Bcbpa1s0QhiE1e3Qx9PHPiLcQ4E0y0krG98X82gLG23p
         FRLD+hPKlMgLE7hP6CsUUgo+iplVG/ueVq5KfRUXSQpwW5ogwEEIGPLxXVrnIEdH/aEK
         pjs6MVNs3ZO5tsITEsyw1kZAFHNdrgxkNgk5uzIDu1tnceatAMZ5XUVYu74SGfKPGQKM
         O6ldB+SvuJLGM+4UmdI6If2GJ3nRfVtUAUo+RsdymGhyN0bqLoz+ZHiWfhGDnkJHRK0w
         a6Fi2pa+E7rDhsac0BYM7dBiucckRkx+Zya67gB/jGN4zESpaO2JQXNkNI+EHCsXCUOL
         QJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=83wGPErMOeYaxiZ5aYYnzkstX9KM8EIS3DlEeudi+x4=;
        b=AGCljwGVgqZXLUCwkhec/G3d6RpjVPaoBvLgNhj9lJ+dOOaH80h4SyOM4OoHi+m9s+
         qmMvMaXwFrpelaPBxN3A+MR3VooG36iigCONyXysxErGDavgZhkOIZvff5anczU/c/ap
         /EPNBS3p40HpFZDjcPWwE4UbOQuogQUP2CVsbRoMji7xoLsAbfK1053iSwmSI65Se5MH
         svaJHa7lt1ci4hGl1aAEMGMMK5e21SjfgiWt8shPRyf4KLyjEYcmTGFk9arx1cRpwbWu
         LCiXYLFKimsMRp2T1ORr2Bwn5OcVqjtks4xleqsknbRouKFCg+1mNZlCze2Na0+V8eQZ
         01Qw==
X-Gm-Message-State: APjAAAVorRTaqdMDhrm8JSivLfuO7EFm2DB34/f4wBYiGzssMIkfavFD
        2f/c5HB3gjTe/SGgWylmDUSAJKA1e+WKOthx4YM=
X-Google-Smtp-Source: APXvYqzCoubsE/pqnJpJe9yVYRDL5Gr4QuWbyeNA0WlAk62SYVgn1sd70PuYLh+olS29TI2VUwq/WC8BX8MFBLXslrE=
X-Received: by 2002:a05:6214:707:: with SMTP id b7mr811157qvz.97.1576650229139;
 Tue, 17 Dec 2019 22:23:49 -0800 (PST)
MIME-Version: 1.0
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-7-bjorn.topel@gmail.com>
 <7ceab77a-92e7-6415-3045-3e16876d4ef8@iogearbox.net>
In-Reply-To: <7ceab77a-92e7-6415-3045-3e16876d4ef8@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Dec 2019 07:23:07 +0100
Message-ID: <CAJ+HfNgmcjLniyG0oj7OE60=NASfskVzP_bgX_JXp+SLczmyOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT
 image alloc/free
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 at 16:09, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/16/19 10:13 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > This commit makes sure that the JIT images is kept close to the kernel
> > text, so BPF calls can use relative calling with auipc/jalr or jal
> > instead of loading the full 64-bit address and jalr.
> >
> > The BPF JIT image region is 128 MB before the kernel text.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > ---
> >   arch/riscv/include/asm/pgtable.h |  4 ++++
> >   arch/riscv/net/bpf_jit_comp.c    | 13 +++++++++++++
> >   2 files changed, 17 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index 7ff0ed4f292e..cc3f49415620 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -404,6 +404,10 @@ static inline int ptep_clear_flush_young(struct vm=
_area_struct *vma,
> >   #define VMALLOC_END      (PAGE_OFFSET - 1)
> >   #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> >
> > +#define BPF_JIT_REGION_SIZE  (SZ_128M)
> > +#define BPF_JIT_REGION_START (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> > +#define BPF_JIT_REGION_END   (VMALLOC_END)
> > +
>
> Series looks good to me, thanks; I'd like to get an ACK from Palmer/other=
s on this one.
>

Palmer/Paul/Albert, any thoughts/input? I can respin the the series
w/o the call optimizations (excluding this patch and the next), but
I'd prefer not given it's a nice speed/clean up for calls.
