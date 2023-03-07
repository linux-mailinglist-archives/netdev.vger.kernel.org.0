Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414D76AFAC6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCGXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGXxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:53:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2D999C35;
        Tue,  7 Mar 2023 15:53:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id k10so35263896edk.13;
        Tue, 07 Mar 2023 15:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678233198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdjE0n4Mn4g5FWhFGcgINl7gukDbjB9TKM/iRt5mgrQ=;
        b=cVmEl3B/u542VqRx2sYhwamgmtWUPXBnDULsNr0Oj+hVmGKEVgPtVhi2cThqUmQMxG
         YgBiCnvH8aYEsI3vTaArc3mNyI/D9SpgHJ7CLFonH+1p/mQ5Tl936ZAyiunCi3s36B5T
         1sAsgvTqh8MNKlouyRKT9XeAnZs4lIrE0+sCRr34wUNjMpMO+LMMyZDuujnM28gkL7M3
         S0Nn9KSADDXUol3sZVt64/aMfYjrWZkg4IM00ddHZC22gOyvw5agz0fxLRBALLj14N4p
         xav0f0sy8QIDiEYrxd+WbXujYWKZcybGRTLs9uwKibspaqieBymONQvClV7Df8JN+w1A
         ZOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678233198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FdjE0n4Mn4g5FWhFGcgINl7gukDbjB9TKM/iRt5mgrQ=;
        b=Vl199kUdYTDCs/73vrATVUMRavss+gzYq02XIOUr8dEp5yYEtDEcZ22w0G6B3N9/Dj
         Tv7Eqwoq9YBaJ5AITY57wr2JKGQSDVpWbGuiJmviPJiga0h2eJT9cyauFaCMi6r2JD9l
         4gwFIfZgfppEem2BaFa8Wq9wmwtQo8A9+LnjglzXhmIdvGrq5RRXM9kC9XKfcVpapUuF
         gHH2k/qCIDrLFS6my2pzO4PRTk4w7tEXA/pMl7djH2YZvFAxYZPq0y50mXOnfbxKXugb
         z3ThHKBE2FivxA45CW/iHVZvPy6PvchVX64YplyIMe/y4ay8YoUM8aR9XLGWnKH/qz/W
         nRHA==
X-Gm-Message-State: AO0yUKVE1zL/wJ7PCup9EtSzx4R/wUq1zYdnvUJ5X8zxKExfcn/U4BRj
        r4JreXOEMhfmcJ1z22teBU0ty5keJ5VeC/sJh40=
X-Google-Smtp-Source: AK7set9B6oVRaFntg12OgVAm7Qe95jsjRRyNTS3c23PoEGnmr/pBV8bZG4hbZ09iHA1EI8Fo1yY8DsyRfhYZVHy0l8c=
X-Received: by 2002:a17:906:3141:b0:8e5:411d:4d09 with SMTP id
 e1-20020a170906314100b008e5411d4d09mr8148375eje.15.1678233198343; Tue, 07 Mar
 2023 15:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-4-joannelkoong@gmail.com> <20230306073628.g2kg5vp6lw6vzyya@apollo>
 <CAJnrk1ZF5FEtXKsMEnwbLu5qr-mQ6-j9+PK2j1NEf=hLE1CCKQ@mail.gmail.com>
In-Reply-To: <CAJnrk1ZF5FEtXKsMEnwbLu5qr-mQ6-j9+PK2j1NEf=hLE1CCKQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Mar 2023 15:53:06 -0800
Message-ID: <CAEf4BzbJTwG6cZ_Oq+ViqR4BiZ+VyVn0q9iYZbyb21ZwdLP9Wg@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 03/10] bpf: Allow initializing dynptrs in kfuncs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, toke@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 10:54=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sun, Mar 5, 2023 at 11:36=E2=80=AFPM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Wed, Mar 01, 2023 at 04:49:46PM CET, Joanne Koong wrote:
> > > This change allows kfuncs to take in an uninitialized dynptr as a
> > > parameter. Before this change, only helper functions could successful=
ly
> > > use uninitialized dynptrs. This change moves the memory access check
> > > (including stack state growing and slot marking) into
> > > process_dynptr_func(), which both helpers and kfuncs call into.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  kernel/bpf/verifier.c | 67 ++++++++++++++---------------------------=
--
> > >  1 file changed, 22 insertions(+), 45 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index e0e00509846b..82e39fc5ed05 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -268,7 +268,6 @@ struct bpf_call_arg_meta {
> > >       u32 ret_btf_id;
> > >       u32 subprogno;
> > >       struct btf_field *kptr_field;
> > > -     u8 uninit_dynptr_regno;
> > >  };
> > >
> > >  struct btf *btf_vmlinux;
> > > @@ -6225,10 +6224,11 @@ static int process_kptr_func(struct bpf_verif=
ier_env *env, int regno,
> > >   * Helpers which do not mutate the bpf_dynptr set MEM_RDONLY in thei=
r argument
> > >   * type, and declare it as 'const struct bpf_dynptr *' in their prot=
otype.
> > >   */
> > > -static int process_dynptr_func(struct bpf_verifier_env *env, int reg=
no,
> > > -                            enum bpf_arg_type arg_type, struct bpf_c=
all_arg_meta *meta)
> > > +static int process_dynptr_func(struct bpf_verifier_env *env, int reg=
no, int insn_idx,
> > > +                            enum bpf_arg_type arg_type)
> > >  {
> > >       struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[re=
gno];
> > > +     int err;
> > >
> > >       /* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
> > >        * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
> > > @@ -6254,23 +6254,23 @@ static int process_dynptr_func(struct bpf_ver=
ifier_env *env, int regno,
> > >        *               to.
> > >        */
> > >       if (arg_type & MEM_UNINIT) {
> > > +             int i;
> > > +
> > >               if (!is_dynptr_reg_valid_uninit(env, reg)) {
> > >                       verbose(env, "Dynptr has to be an uninitialized=
 dynptr\n");
> > >                       return -EINVAL;
> > >               }
> > >
> > > -             /* We only support one dynptr being uninitialized at th=
e moment,
> > > -              * which is sufficient for the helper functions we have=
 right now.
> > > -              */
> > > -             if (meta->uninit_dynptr_regno) {
> > > -                     verbose(env, "verifier internal error: multiple=
 uninitialized dynptr args\n");
> > > -                     return -EFAULT;
> > > +             /* we write BPF_DW bits (8 bytes) at a time */
> > > +             for (i =3D 0; i < BPF_DYNPTR_SIZE; i +=3D 8) {
> > > +                     err =3D check_mem_access(env, insn_idx, regno,
> > > +                                            i, BPF_DW, BPF_WRITE, -1=
, false);
> > > +                     if (err)
> > > +                             return err;
> > >               }
> >
> > I am not sure moving check_mem_access into process_dynptr_func is the r=
ight
> > thing to do. Not sure if a problem already, but sooner or later it migh=
t be.
> >
> > The side effects of the call should take effect on the current state on=
ly after
> > we have gone through all arguments for the helper/kfunc call. In this c=
ase we
> > will now do stack access while processing the dynptr arg, which may aff=
ect the
> > state of stack we see through other memory arguments coming later.
> >
> > I think it is better to do it after argument processing is done, simila=
r to
> > existing meta.access_size handling which is done after check_func_arg l=
oop (for
> > the same reasons).
> >
>
> Thanks for taking a look. I don't have a strong preference for either
> so if you do feel strongly about doing the check_mem_access() only
> after argument processing, I'm happy to change it. The
> check_mem_access() call on the dyntpr will mark only the dynptr stack
> slots, so I don't fully see how it may affect the state of stack
> through other memory arguments coming later, but I do see your point
> about keeping the logic more separated out.

FWIW, I did a similar approach for iters as well. And I suspect it's
not the only place where we do similar things while processing helper
arguments, etc.

Let's keep this in mind, but I wouldn't necessarily go complicating
code right now with more of "let's record some info for later" and
then "ok, we recorded something before, let's act on it".

>
> > > [...]
