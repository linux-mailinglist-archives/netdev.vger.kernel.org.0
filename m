Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B6C524384
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344626AbiELDiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiELDiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:38:02 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03837252AA;
        Wed, 11 May 2022 20:38:01 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e3so4056508ios.6;
        Wed, 11 May 2022 20:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L006SjPdX5Xticdbo7RvVa2pKtl5XV/E8ac7wvDMDRg=;
        b=b4Ajt7dkwAuyf+d/E1hEmc3TDC+F7MDLdJW53zbRGFxKgmySJHZkI/yJJKO0pHHrN/
         4WxXJ7LAyByBJAdU782sKCLaYpy30ZBsnU/yW0x56kfUZ+vecbvoLx9NrhE4ZonjpEUJ
         MXKK9Pbd4tP+uF4WJr3ZrvbhJpr9lsG2hHECTOITc9UDkhHYjic1WJhAhnXuivo1VhcF
         PeyALUo+T0cj6RQUyDTqOJUS3/zm/z3nPILaGLjKjI45+HCX46IhuKionbhtzNYMqyBH
         +x0CKZBvUPpHPZRi99uUCEpFe7tvHaWKAAFQ7n0efWDfGQvV7CePvclMUX6wq/aA744W
         gljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L006SjPdX5Xticdbo7RvVa2pKtl5XV/E8ac7wvDMDRg=;
        b=JCXVw9qfhsHbvWe658x2TXZQsVdrhW//aDqmWY4Yn5Tmom4Yd1ouIRh11LH0rpCtl+
         2ezmGuWrz0RVvvTMm3Yn6lX36X3wjLT12jvSCTcvZrmu0PLXd9utboYA95EotDdn6Zjm
         HNi9IBo9Q86UJ825r/Dw7UcKWWgRRhV853YLb5UQr5q3mJawkUgkUd8JXvWEkh1YRt1i
         Ejroo02DOP6abbYgMmLfCUknSKM6aHi/OSlyq+wdHSWU7ksx10GzetcIiHRgtYpcfM1a
         L55Xt/1XdaIq0I1nrlDr3vm++H5zdPbCZWcMWdXnSumjMs19jPJqy3lB3O+/JW0ZyGD/
         z2jw==
X-Gm-Message-State: AOAM532Ls2YXmJd/YdgswteO32ZexlP4YMpDagq1D3F/N52pAbALmPVy
        Suj6GEynvm/ZvOSN3FCaeLPnt9hws4Z2uOsRnLfHxiJW
X-Google-Smtp-Source: ABdhPJze/Meo8bZOkseCNV0kb+Bax/T1SnVEGUB5b83Ku7ntFNulOWozQWt9pSpocpS00WgRpBQKEcL9HSJL50aWxTU=
X-Received: by 2002:a05:6638:468e:b0:32b:fe5f:d73f with SMTP id
 bq14-20020a056638468e00b0032bfe5fd73fmr9515960jab.234.1652326680406; Wed, 11
 May 2022 20:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-11-sdf@google.com>
 <CAEf4BzY3Nd2pi+O-x4bp41=joFgPXU2+UFqBusdjR08ME62k5g@mail.gmail.com>
 <CAKH8qBtk6CpR-29R6sWicz_zW=RCYUrXZqBZbgF9eqt4XGgNqQ@mail.gmail.com>
 <CAEf4BzZvVzHd9Sb=uH+614fq0wrht1wBAyG1zh6ZJg-_Qz0-rA@mail.gmail.com> <CAKH8qBv401RBdiouFD71JGZScG_oFD+3fUNav68JpzA=VWLkiA@mail.gmail.com>
In-Reply-To: <CAKH8qBv401RBdiouFD71JGZScG_oFD+3fUNav68JpzA=VWLkiA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 May 2022 20:37:49 -0700
Message-ID: <CAEf4Bzb0Dnh49rwy8eFwoZK1ThOn-YQjcwXJiKbT-p7aATqEQw@mail.gmail.com>
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

On Tue, May 10, 2022 at 10:31 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, May 9, 2022 at 4:44 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, May 9, 2022 at 4:38 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Mon, May 9, 2022 at 2:54 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Apr 29, 2022 at 2:16 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > sk_priority & sk_mark are writable, the rest is readonly.
> > > > >
> > > > > Add new ldx_offset fixups to lookup the offset of struct field.
> > > > > Allow using test.kfunc regardless of prog_type.
> > > > >
> > > > > One interesting thing here is that the verifier doesn't
> > > > > really force me to add NULL checks anywhere :-/
> > > > >
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
> > > > >  .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
> > > > >  2 files changed, 87 insertions(+), 1 deletion(-)
> > > > >  create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > > >
> > > >
> > > > [...]
> > > >
> > > > > diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > > > new file mode 100644
> > > > > index 000000000000..af0efe783511
> > > > > --- /dev/null
> > > > > +++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> > > > > @@ -0,0 +1,34 @@
> > > > > +#define SK_WRITABLE_FIELD(tp, field, size, res) \
> > > > > +{ \
> > > > > +       .descr = field, \
> > > > > +       .insns = { \
> > > > > +               /* r1 = *(u64 *)(r1 + 0) */ \
> > > > > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > > > > +               /* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
> > > > > +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> > > > > +               /* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
> > > > > +               BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
> > > > > +               /* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
> > > > > +               BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
> > > > > +               BPF_MOV64_IMM(BPF_REG_0, 1), \
> > > > > +               BPF_EXIT_INSN(), \
> > > > > +       }, \
> > > > > +       .result = res, \
> > > > > +       .errstr = res ? "no write support to 'struct sock' at off" : "", \
> > > > > +       .prog_type = BPF_PROG_TYPE_LSM, \
> > > > > +       .expected_attach_type = BPF_LSM_CGROUP, \
> > > > > +       .kfunc = "socket_post_create", \
> > > > > +       .fixup_ldx = { \
> > > > > +               { "socket", "sk", 1 }, \
> > > > > +               { tp, field, 2 }, \
> > > > > +               { tp, field, 3 }, \
> > > > > +       }, \
> > > > > +}
> > > > > +
> > > > > +SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
> > > > > +SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
> > > > > +SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
> > > > > +SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
> > > > > +SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
> > > > > +
> > > >
> > > > have you tried writing it as C program and adding the test to
> > > > test_progs? Does something not work there?
> > >
> > > Seems like it should work, I don't see any issues with writing 5
> > > programs to test each field.
> > > But test_verified still feels like a better fit? Any reason in
> > > particular you'd prefer test_progs over test_verifier?
> >
> > Adding that fixup_ldx->strct special handling didn't feel like the
> > best fit, tbh. test_progs is generally much nicer to deal with in
> > terms of CI and in terms of comprehending what's going on and
> > supporting the code longer term.
>
> This is not new, right? We already have a bunch of fixup_xxx things.

I'm not saying it's wrong, but we don't have to keep adding extra
custom fixup_xxx things and having hand crafted assembly test cases if
we can do C tests, right? BPF assembly tests are sometimes necessary
if we need to craft some special conditions which are hard to
guarantee from Clang side during C to BPF assembly translation. But
this one doesn't seem to be the case.

> I can try to move this into test_progs in largely the same manner if
> you prefer, having a C file per field seems like an overkill.

You don't need a separate C file for each case. See what Joanne does
with SEC("?...") for dynptr tests, or what Kumar did for his kptr
tests. You can put multiple negative tests as separate BPF programs in
one file with auto-load disabled through SEC("?...") and then
open/load skeleton each time for each program, one at a time.
