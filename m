Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC474674A7
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfGLRtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:49:33 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33962 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfGLRtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:49:32 -0400
Received: by mail-qt1-f196.google.com with SMTP id k10so9000469qtq.1;
        Fri, 12 Jul 2019 10:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Af4m0BoGgUyJh88P/HiWq2/bRFzF0fAtz1mXVpi6QQ=;
        b=AzgVQvPbZA/8pGDQOAwuj3clKXyldFuuPZgQgtsFdIcCuanYtgiCQPbDU898YkIcqQ
         m/Blbqkl+Ac0TABUizPF/MA8n3MrL4/tIIC0LOkCWmcIIGiLBuD3oMs1d9wKU2dLyoyB
         IrwoFF7arp2rm3Hf/iSkIFmdYIkPKwtIcBtCM3+9Db9ubO1YHhyQPE62OsxWDWm6wwIG
         iD5NpA+DK7GA0wsg2Ts1zgQuPUN6QQ+f8j0a9kmQ/BWkVrtL9qxz1GVTXChimsSeSFwB
         dlduIp5apVtZhhkj9eVHMIv9FIDCbv6rjPdlfdJsa/b0SXv5APmYxALqJMzPJ4QtdMam
         SXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Af4m0BoGgUyJh88P/HiWq2/bRFzF0fAtz1mXVpi6QQ=;
        b=m4Ycn/vwxa5Kz5WVa0apY78ja+7zQYUCfkaEYMkx76/FUkmeG+OCjD33q7hA6ME8pM
         SigkBaARNELbfoIvwh7NFzcovp/eTI7zYEyZsTji9FtFWPwkSNy2XGw4gKDzX9Zkm0tB
         M3yNUJ6AvJCxyGk9/lMJLNHeViGwStNXleEGXr+YjL+zuSWpstxtZOjFU6IKfqvxmo3I
         c+ArtigejvUtRCxD4NHhZUSCwtYaD94C2xZHQe4mAU3INI7hIS1krSBpm/BkNfvRbxgQ
         zXhA3U/1UmDX5ThqLMZDALPckbvqLRleEh2bnrK8y22uFTLj3e0Nl0jtBk5Oyha2CRVY
         9agQ==
X-Gm-Message-State: APjAAAXoC6J/fCr0pdWAT3LtTFfODwQEv+Y8LR+qnmekDSXNKpKzc6H0
        odpfpjzMzcS102WnLWo+x45EdcFA2DANHp2bn2R6XIB/Mnjs0yEp
X-Google-Smtp-Source: APXvYqyZLEI7nprG1zfD8pfLglgXYfpC0ILtQwEmN5bmmRpO/CpJyfjggncLuNVGZgGsMTZNt77U11Ib84aJosIUaKQ=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr7180858qty.141.1562953771196;
 Fri, 12 Jul 2019 10:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-12-krzesimir@kinvolk.io>
 <CAEf4BzYaV=AxYZna225qKzyWPteU4YFPiBRE4cO30tYmyN_pJQ@mail.gmail.com> <CAGGp+cGMnumMx+GnKbD_ty1C+UWib70s0oBzqdS-=mA-L0jyHA@mail.gmail.com>
In-Reply-To: <CAGGp+cGMnumMx+GnKbD_ty1C+UWib70s0oBzqdS-=mA-L0jyHA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 10:49:20 -0700
Message-ID: <CAEf4BzZHJUns8uNuVJzF-77MCtctBOK53hxgkjqpGJxr9YcAoA@mail.gmail.com>
Subject: Re: [bpf-next v3 11/12] selftests/bpf: Add tests for
 bpf_prog_test_run for perf events progs
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 10:37 AM Krzesimir Nowak <krzesimir@kinvolk.io> wro=
te:
>
> On Fri, Jul 12, 2019 at 2:38 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> w=
rote:
> > >
> > > The tests check if ctx and data are correctly prepared from ctx_in an=
d
> > > data_in, so accessing the ctx and using the bpf_perf_prog_read_value
> > > work as expected.
> > >
> >
> > These are x86_64-specific tests, aren't they? Should probably guard
> > them behind #ifdef's.
>
> Yeah, they are x86_64 specific, because pt_regs are arch specific. I
> was wondering what to do here in the cover letter. Ifdef? Ifdef and
> cover also other arches (please no)? Do some weird tricks with
> overriding the definition of pt_regs? Else?

So one way to go about this would be to use bpf_helpers.h's
PT_REGS_PARM{1-5} and PT_REGS_RC, which seem to be define for all
"supported" platforms. You won't be testing all possible registers,
but those that are most commonly used by BPF programs (to get input
params and func result) would be tested, which is probably the most
important one. That way your test will be arch-agnostic.

>
> >
> > > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > ---
> > >  tools/testing/selftests/bpf/test_verifier.c   | 48 ++++++++++
> > >  .../selftests/bpf/verifier/perf_event_run.c   | 96 +++++++++++++++++=
++
> > >  2 files changed, 144 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_r=
un.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/test=
ing/selftests/bpf/test_verifier.c
> > > index 6f124cc4ee34..484ea8842b06 100644
> > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > @@ -295,6 +295,54 @@ static void bpf_fill_scale(struct bpf_test *self=
)
> > >         }
> > >  }
> > >
> > > +static void bpf_fill_perf_event_test_run_check(struct bpf_test *self=
)
> > > +{
> > > +       compiletime_assert(
> > > +               sizeof(struct bpf_perf_event_data) <=3D TEST_CTX_LEN,
> > > +               "buffer for ctx is too short to fit struct bpf_perf_e=
vent_data");
> > > +       compiletime_assert(
> > > +               sizeof(struct bpf_perf_event_value) <=3D TEST_DATA_LE=
N,
> > > +               "buffer for data is too short to fit struct bpf_perf_=
event_value");
> > > +
> > > +       struct bpf_perf_event_data ctx =3D {
> > > +               .regs =3D (bpf_user_pt_regs_t) {
> > > +                       .r15 =3D 1,
> > > +                       .r14 =3D 2,
> > > +                       .r13 =3D 3,
> > > +                       .r12 =3D 4,
> > > +                       .rbp =3D 5,
> > > +                       .rbx =3D 6,
> > > +                       .r11 =3D 7,
> > > +                       .r10 =3D 8,
> > > +                       .r9 =3D 9,
> > > +                       .r8 =3D 10,
> > > +                       .rax =3D 11,
> > > +                       .rcx =3D 12,
> > > +                       .rdx =3D 13,
> > > +                       .rsi =3D 14,
> > > +                       .rdi =3D 15,
> > > +                       .orig_rax =3D 16,
> > > +                       .rip =3D 17,
> > > +                       .cs =3D 18,
> > > +                       .eflags =3D 19,
> > > +                       .rsp =3D 20,
> > > +                       .ss =3D 21,
> > > +               },
> > > +               .sample_period =3D 1,
> > > +               .addr =3D 2,
> > > +       };
> > > +       struct bpf_perf_event_value data =3D {
> > > +               .counter =3D 1,
> > > +               .enabled =3D 2,
> > > +               .running =3D 3,
> > > +       };
> > > +
> > > +       memcpy(self->ctx, &ctx, sizeof(ctx));
> > > +       memcpy(self->data, &data, sizeof(data));
> >
> > Just curious, just assignment didn't work?
> >
> > > +       free(self->fill_insns);
> > > +       self->fill_insns =3D NULL;
> > > +}
> > > +
> > >  /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up map=
s */
> > >  #define BPF_SK_LOOKUP(func)                                         =
   \
> > >         /* struct bpf_sock_tuple tuple =3D {} */                     =
     \
> > > diff --git a/tools/testing/selftests/bpf/verifier/perf_event_run.c b/=
tools/testing/selftests/bpf/verifier/perf_event_run.c
> > > new file mode 100644
> > > index 000000000000..3f877458a7f8
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/verifier/perf_event_run.c
> > > @@ -0,0 +1,96 @@
> > > +#define PER_LOAD_AND_CHECK_PTREG(PT_REG_FIELD, VALUE)               =
   \
> > > +       PER_LOAD_AND_CHECK_CTX(offsetof(bpf_user_pt_regs_t, PT_REG_FI=
ELD), VALUE)
> > > +#define PER_LOAD_AND_CHECK_EVENT(PED_FIELD, VALUE)                  =
   \
> > > +       PER_LOAD_AND_CHECK_CTX(offsetof(struct bpf_perf_event_data, P=
ED_FIELD), VALUE)
> > > +#define PER_LOAD_AND_CHECK_CTX(OFFSET, VALUE)                       =
   \
> > > +       PER_LOAD_AND_CHECK_64(BPF_REG_4, BPF_REG_1, OFFSET, VALUE)
> > > +#define PER_LOAD_AND_CHECK_VALUE(PEV_FIELD, VALUE)                  =
   \
> > > +       PER_LOAD_AND_CHECK_64(BPF_REG_7, BPF_REG_6, offsetof(struct b=
pf_perf_event_value, PEV_FIELD), VALUE)
> >
> > Wrap long lines? Try also running scripts/checkpatch.pl again these
> > files you are modifying.
>
> Will wrap. Checkpatch was also complaining about complex macro not
> being inside parens, but I can't see how to wrap it in parens and keep
> it working at the same time.
>
> >
> > > +#define PER_LOAD_AND_CHECK_64(DST, SRC, OFFSET, VALUE)              =
   \
> > > +       BPF_LDX_MEM(BPF_DW, DST, SRC, OFFSET),                       =
   \
> > > +       BPF_JMP_IMM(BPF_JEQ, DST, VALUE, 2),                         =
   \
> > > +       BPF_MOV64_IMM(BPF_REG_0, VALUE),                             =
   \
> > > +       BPF_EXIT_INSN()
> > > +
> > > +{
> > > +       "check if regs contain expected values",
> > > +       .insns =3D {
> > > +       PER_LOAD_AND_CHECK_PTREG(r15, 1),
> > > +       PER_LOAD_AND_CHECK_PTREG(r14, 2),
> > > +       PER_LOAD_AND_CHECK_PTREG(r13, 3),
> > > +       PER_LOAD_AND_CHECK_PTREG(r12, 4),
> > > +       PER_LOAD_AND_CHECK_PTREG(rbp, 5),
> > > +       PER_LOAD_AND_CHECK_PTREG(rbx, 6),
> > > +       PER_LOAD_AND_CHECK_PTREG(r11, 7),
> > > +       PER_LOAD_AND_CHECK_PTREG(r10, 8),
> > > +       PER_LOAD_AND_CHECK_PTREG(r9, 9),
> > > +       PER_LOAD_AND_CHECK_PTREG(r8, 10),
> > > +       PER_LOAD_AND_CHECK_PTREG(rax, 11),
> > > +       PER_LOAD_AND_CHECK_PTREG(rcx, 12),
> > > +       PER_LOAD_AND_CHECK_PTREG(rdx, 13),
> > > +       PER_LOAD_AND_CHECK_PTREG(rsi, 14),
> > > +       PER_LOAD_AND_CHECK_PTREG(rdi, 15),
> > > +       PER_LOAD_AND_CHECK_PTREG(orig_rax, 16),
> > > +       PER_LOAD_AND_CHECK_PTREG(rip, 17),
> > > +       PER_LOAD_AND_CHECK_PTREG(cs, 18),
> > > +       PER_LOAD_AND_CHECK_PTREG(eflags, 19),
> > > +       PER_LOAD_AND_CHECK_PTREG(rsp, 20),
> > > +       PER_LOAD_AND_CHECK_PTREG(ss, 21),
> > > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .result =3D ACCEPT,
> > > +       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > +       .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > +       .data_len =3D sizeof(struct bpf_perf_event_value),
> > > +       .fill_helper =3D bpf_fill_perf_event_test_run_check,
> > > +       .override_data_out_len =3D true,
> > > +},
> > > +{
> > > +       "check if sample period and addr contain expected values",
> > > +       .insns =3D {
> > > +       PER_LOAD_AND_CHECK_EVENT(sample_period, 1),
> > > +       PER_LOAD_AND_CHECK_EVENT(addr, 2),
> > > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .result =3D ACCEPT,
> > > +       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > +       .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > +       .data_len =3D sizeof(struct bpf_perf_event_value),
> > > +       .fill_helper =3D bpf_fill_perf_event_test_run_check,
> > > +       .override_data_out_len =3D true,
> > > +},
> > > +{
> > > +       "check if bpf_perf_prog_read_value returns expected data",
> > > +       .insns =3D {
> > > +       // allocate space for a struct bpf_perf_event_value
> > > +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
> > > +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -(int)sizeof(struct bpf_per=
f_event_value)),
> > > +       // prepare parameters for bpf_perf_prog_read_value(ctx, struc=
t bpf_perf_event_value*, u32)
> > > +       // BPF_REG_1 already contains the context
> > > +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> > > +       BPF_MOV64_IMM(BPF_REG_3, sizeof(struct bpf_perf_event_value))=
,
> > > +       BPF_EMIT_CALL(BPF_FUNC_perf_prog_read_value),
> > > +       // check the return value
> > > +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
> > > +       BPF_EXIT_INSN(),
> > > +       // check if the fields match the expected values
> >
> > Use /* */ comments.
>
> Oops. Will fix.
>
> >
> > > +       PER_LOAD_AND_CHECK_VALUE(counter, 1),
> > > +       PER_LOAD_AND_CHECK_VALUE(enabled, 2),
> > > +       PER_LOAD_AND_CHECK_VALUE(running, 3),
> > > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .result =3D ACCEPT,
> > > +       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > +       .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > +       .data_len =3D sizeof(struct bpf_perf_event_value),
> > > +       .fill_helper =3D bpf_fill_perf_event_test_run_check,
> > > +       .override_data_out_len =3D true,
> > > +},
> > > +#undef PER_LOAD_AND_CHECK_64
> > > +#undef PER_LOAD_AND_CHECK_VALUE
> > > +#undef PER_LOAD_AND_CHECK_CTX
> > > +#undef PER_LOAD_AND_CHECK_EVENT
> > > +#undef PER_LOAD_AND_CHECK_PTREG
> > > --
> > > 2.20.1
> > >
>
>
>
> --
> Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago =
L=C3=B3pez Galeiras
> Registergericht/Court of registration: Amtsgericht Charlottenburg
> Registernummer/Registration number: HRB 171414 B
> Ust-ID-Nummer/VAT ID number: DE302207000
