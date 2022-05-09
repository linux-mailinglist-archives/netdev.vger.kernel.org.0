Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485F55209A9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiEIXsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiEIXs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:48:27 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE782927A6;
        Mon,  9 May 2022 16:44:06 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b5so10363991ile.0;
        Mon, 09 May 2022 16:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hlnUMem1QdYii6BM4kGHNDrkazQ8G5y6jAbvWnz+9xo=;
        b=TfvxUUoRfum8PPdNDSoqlXbsF7fmevqwLUitXxJjKaV3kx/cxJ1B060RKec5FUuPQn
         HTmJ6ISzGdsIK0gpSejPYgqBgOA9Wnp1Q+SwMAK8d7B+gFsxfhLT72qqfeqJiONcjbht
         34dBNNAuyO/B6m/UbU/BQ4MCIk45RQoXV3B7uZN/6JmBTbw9cjsjhHIPoY5Qc51Z2lg7
         ubF+yqrmPYseTbBDq9r+bbDHZqUqsYB6UJ6K5JvAcjs17OVKEklY/12Y7JZYLcwZkVut
         SzPjREFUxqETjHfgCCNiEacEjlTtpb9lQABUYiZlPDFIYsG7evZhHbUVeBYwsxnXYkpb
         bn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hlnUMem1QdYii6BM4kGHNDrkazQ8G5y6jAbvWnz+9xo=;
        b=Sl5iYsl3D6yVcqbuQpvkKBhJTNdEl+TKtltr2GWZIIYWo7QtCysfD4goG4ySaoCYEv
         ZPZIDrTjrHnGsfR2Whpx8u1YSk9MeUtaGDnsiXnatFzyeQZ/gyolUKxnMFvMLhoSg3vv
         +V9+P1Vjyvbga2/b5xCVrgl/bB8QCrIDFxE9j2cfH4aH7D+itdDbJcxI/bWZ8n6XPz+X
         6U1xE2L+TurMNO80ApM1MyzmuchiI7KXE7TymFdENwEJHjQD/siG4PK8N4JKGfjMtvya
         K/UVQJgwmMLuYxTDqLCHmDaNJUmYDvBOYwjcUDyyXCMs1uW0UEJKMD/MN1DTku7+nY64
         ElOw==
X-Gm-Message-State: AOAM532E6E4UB7QvLq1qHw1Y/cjNWraGxXpQNYmQTAjS2g00u+Nzz8jO
        4+v0/JIKoWiD9FVXqqwOuFBjJbwkp3Bb+fgussM=
X-Google-Smtp-Source: ABdhPJwqxNEvhIzvTlS/UiBg2OGropLyQGbXaPRwiz5hBWyd+uP4OFeBr1TPFnNFAhfmE9Yg/mtLAYYiflZ13TOr+6Q=
X-Received: by 2002:a05:6e02:11a3:b0:2cf:90f9:30e0 with SMTP id
 3-20020a056e0211a300b002cf90f930e0mr4505070ilj.252.1652139844752; Mon, 09 May
 2022 16:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-11-sdf@google.com>
 <CAEf4BzY3Nd2pi+O-x4bp41=joFgPXU2+UFqBusdjR08ME62k5g@mail.gmail.com> <CAKH8qBtk6CpR-29R6sWicz_zW=RCYUrXZqBZbgF9eqt4XGgNqQ@mail.gmail.com>
In-Reply-To: <CAKH8qBtk6CpR-29R6sWicz_zW=RCYUrXZqBZbgF9eqt4XGgNqQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 16:43:54 -0700
Message-ID: <CAEf4BzZvVzHd9Sb=uH+614fq0wrht1wBAyG1zh6ZJg-_Qz0-rA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 10/10] selftests/bpf: verify lsm_cgroup struct
 sock access
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 4:38 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, May 9, 2022 at 2:54 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Apr 29, 2022 at 2:16 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > sk_priority & sk_mark are writable, the rest is readonly.
> > >
> > > Add new ldx_offset fixups to lookup the offset of struct field.
> > > Allow using test.kfunc regardless of prog_type.
> > >
> > > One interesting thing here is that the verifier doesn't
> > > really force me to add NULL checks anywhere :-/
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
> > >  .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
> > >  2 files changed, 87 insertions(+), 1 deletion(-)
> > >  create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > >
> >
> > [...]
> >
> > > diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > new file mode 100644
> > > index 000000000000..af0efe783511
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > @@ -0,0 +1,34 @@
> > > +#define SK_WRITABLE_FIELD(tp, field, size, res) \
> > > +{ \
> > > +       .descr = field, \
> > > +       .insns = { \
> > > +               /* r1 = *(u64 *)(r1 + 0) */ \
> > > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > > +               /* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
> > > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > > +               /* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
> > > +               BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
> > > +               /* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
> > > +               BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
> > > +               BPF_MOV64_IMM(BPF_REG_0, 1), \
> > > +               BPF_EXIT_INSN(), \
> > > +       }, \
> > > +       .result = res, \
> > > +       .errstr = res ? "no write support to 'struct sock' at off" : "", \
> > > +       .prog_type = BPF_PROG_TYPE_LSM, \
> > > +       .expected_attach_type = BPF_LSM_CGROUP, \
> > > +       .kfunc = "socket_post_create", \
> > > +       .fixup_ldx = { \
> > > +               { "socket", "sk", 1 }, \
> > > +               { tp, field, 2 }, \
> > > +               { tp, field, 3 }, \
> > > +       }, \
> > > +}
> > > +
> > > +SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
> > > +SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
> > > +SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
> > > +SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
> > > +SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
> > > +
> >
> > have you tried writing it as C program and adding the test to
> > test_progs? Does something not work there?
>
> Seems like it should work, I don't see any issues with writing 5
> programs to test each field.
> But test_verified still feels like a better fit? Any reason in
> particular you'd prefer test_progs over test_verifier?

Adding that fixup_ldx->strct special handling didn't feel like the
best fit, tbh. test_progs is generally much nicer to deal with in
terms of CI and in terms of comprehending what's going on and
supporting the code longer term.
