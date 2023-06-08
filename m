Return-Path: <netdev+bounces-9123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B09727630
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CA44281668
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D62C1C17;
	Thu,  8 Jun 2023 04:38:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9D81D;
	Thu,  8 Jun 2023 04:38:37 +0000 (UTC)
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B504272B;
	Wed,  7 Jun 2023 21:38:35 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-568928af8f5so3489197b3.1;
        Wed, 07 Jun 2023 21:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686199114; x=1688791114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2JsskG49VjWJfT73tF3irTp5aLOY9bRkVhiXnj04Ck=;
        b=fqncFh2vZGdwEr/7SVimGxwbGcBm2werxnOOqG/EuVM5l2UVMbhjfYp6twgUElGhHD
         IhYM4a6JPfjTnEwwRVDj7nNISnUAAVJOshKMOzBSd9u5iPQxKxTl+gEbEz5vfjzvfY+g
         T5AUxo2xfC+gb7hSP70hj+y+uDOsADRb2ms18/0jzqAPP4KMrmw6baN4+vB1p+2+TZDd
         UZAyzvfvFWU/1FtKhgux0wTR1O2EKggx07EXX8rYukx3OOW4WvhtTPZ+3Rnyo2TUSG1D
         jTktlwXiizBkp1SPDCDnF89arE67vAXbffSxhSlntIVAMz8ByghvEgTdCsHModLKu4Xz
         c6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686199114; x=1688791114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2JsskG49VjWJfT73tF3irTp5aLOY9bRkVhiXnj04Ck=;
        b=gszl81os443GCIfhvvLwavDa1NgLFclyak8LzJO6ormN/+AyrI+nOlxNACLhkh4kuk
         IRXjJ9AFr/obAaI6K4u8dp2RK59hfwD+J9egOFORcTrueqEXVSJht9PJUs2Id7/grVmu
         +UisLswR6zhXhEC7kyFbgyulJvxlEX67ZckaSSjuhaLmTgzZnYC/oi4lrdk/sDAxGSyo
         5nnFQbdSndL74LbAhHWBoCJcAby+sucJz3oAMFBH+YnhLLeRRwJHT80ZHLc2/Vyg/zVc
         1FlclalpWX0VohVLJ1Xn5To2+OQtlNJMcVDs9SSsOl9R/2Amgn8ncjDpQ+oyU5+nlOe/
         jqRg==
X-Gm-Message-State: AC+VfDzgVvd6FMZcJbY1IeqsQsvFJerPKY8fYuH1cBXU9I9WFBk2zly9
	KvSv9mHDGsuF9wsk6VKpkT4ULuozBWF/qgtJeRqATAfl/yA+Pw==
X-Google-Smtp-Source: ACHHUZ6xuJN3X1TjrO5TM4mHv7s+84gAYt9I6Svi/x4Ce/D9Gh3m7DjeN+msxH3HUJxGNDWuu/c1V5/TRAy1rKe0+e8=
X-Received: by 2002:a0d:d811:0:b0:568:f050:7c47 with SMTP id
 a17-20020a0dd811000000b00568f0507c47mr1410905ywe.0.1686199114561; Wed, 07 Jun
 2023 21:38:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-3-imagedong@tencent.com> <20230607200348.dprmfvpzdvk5ldpp@macbook-pro-8.dhcp.thefacebook.com>
In-Reply-To: <20230607200348.dprmfvpzdvk5ldpp@macbook-pro-8.dhcp.thefacebook.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Thu, 8 Jun 2023 12:38:23 +0800
Message-ID: <CADxym3a+5t9tMun6Pid+38UmFgcQkMYC4esWdENGs2E24zornA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] bpf, x86: clean garbage value in the
 stack of trampoline
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, x86@kernel.org, imagedong@tencent.com, benbjiang@tencent.com, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 4:03=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jun 07, 2023 at 08:59:10PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > There are garbage values in upper bytes when we store the arguments
> > into stack in save_regs() if the size of the argument less then 8.
> >
> > As we already reserve 8 byte for the arguments in regs and stack,
> > it is ok to store/restore the regs in BPF_DW size. Then, the garbage
> > values in upper bytes will be cleaned.
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 19 ++++++-------------
> >  1 file changed, 6 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 413b986b5afd..e9bc0b50656b 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1878,20 +1878,16 @@ static void save_regs(const struct btf_func_mod=
el *m, u8 **prog, int nr_regs,
> >
> >               if (i <=3D 5) {
> >                       /* copy function arguments from regs into stack *=
/
> > -                     emit_stx(prog, bytes_to_bpf_size(arg_size),
> > -                              BPF_REG_FP,
> > +                     emit_stx(prog, BPF_DW, BPF_REG_FP,
> >                                i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> >                                -(stack_size - i * 8));
>
> This is ok,
>
> >               } else {
> >                       /* copy function arguments from origin stack fram=
e
> >                        * into current stack frame.
> >                        */
> > -                     emit_ldx(prog, bytes_to_bpf_size(arg_size),
> > -                              BPF_REG_0, BPF_REG_FP,
> > +                     emit_ldx(prog, BPF_DW, BPF_REG_0, BPF_REG_FP,
> >                                (i - 6) * 8 + 0x18);
> > -                     emit_stx(prog, bytes_to_bpf_size(arg_size),
> > -                              BPF_REG_FP,
> > -                              BPF_REG_0,
> > +                     emit_stx(prog, BPF_DW, BPF_REG_FP, BPF_REG_0,
> >                                -(stack_size - i * 8));
>
> But this is not.
> See https://godbolt.org/z/qW17f6cYe
> mov dword ptr [rsp], 6
>
> the compiler will store 32-bit only. The upper 32-bit are still garbage.

Enn......I didn't expect this case, and it seems
that this only happens on clang. With gcc,
"push 6" is used.

I haven't found a solution for this case, and it seems
not worth it to add an extra insn to clean the garbage
values.

Does anyone have any ideas here?

Thanks!
Menglong Dong

>
> >               }
> >
> > @@ -1918,7 +1914,7 @@ static void restore_regs(const struct btf_func_mo=
del *m, u8 **prog, int nr_regs,
> >                       next_same_struct =3D !next_same_struct;
> >               }
> >
> > -             emit_ldx(prog, bytes_to_bpf_size(arg_size),
> > +             emit_ldx(prog, BPF_DW,
> >                        i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> >                        BPF_REG_FP,
> >                        -(stack_size - i * 8));
> > @@ -1949,12 +1945,9 @@ static void prepare_origin_stack(const struct bt=
f_func_model *m, u8 **prog,
> >               }
> >
> >               if (i > 5) {
> > -                     emit_ldx(prog, bytes_to_bpf_size(arg_size),
> > -                              BPF_REG_0, BPF_REG_FP,
> > +                     emit_ldx(prog, BPF_DW, BPF_REG_0, BPF_REG_FP,
> >                                (i - 6) * 8 + 0x18);
> > -                     emit_stx(prog, bytes_to_bpf_size(arg_size),
> > -                              BPF_REG_FP,
> > -                              BPF_REG_0,
> > +                     emit_stx(prog, BPF_DW, BPF_REG_FP, BPF_REG_0,
> >                                -(stack_size - (i - 6) * 8));
> >               }
> >
> > --
> > 2.40.1
> >

