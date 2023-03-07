Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C26AD7AF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCGGyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGGyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:54:01 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AB5367E7;
        Mon,  6 Mar 2023 22:54:00 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 82so10471339ybn.6;
        Mon, 06 Mar 2023 22:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678172040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0EHXS3Ap8HuXGSMW5ADL+Ibpan5sh3lcTUzLyMohRE=;
        b=WerA/8ecKCD4Kgg5MwGJNQQHWyu92KD83f8vPdGkmRe8SoXrc7hIBviZGju8237xik
         qfLRtKqdpBNcA8eredtgs5E3i/UM1CbyxHJJof57BDt2DOc9JVEoBEcOmtpBO90RLplt
         NCUkzEKg1jMTOIpe785kClXDYxXoGqsxxKuPWT7d0Q0VqHYe07DzZtkuaRnNgOJhyL84
         g0mg4JQ5cPkIvgDRqTPnZkhx0rvyz8EI0Cb23jmVsDjpY4lZ2q6yTowwu0ACbyQ2uOEY
         MNPtp5GrOVaT5eLf7OKZHA6RMJVZM3uOKM2/PzrfHsXrMQpDLi0118pV20hQ3ZDFW+yA
         Atpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678172040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0EHXS3Ap8HuXGSMW5ADL+Ibpan5sh3lcTUzLyMohRE=;
        b=OQxYM19d6L8h7hmT3W5aA6FSoKSz4wExiNr82MN3jyKaJIkyheJrXNZSPTrjEf7Lf9
         mwxtRp+LBM81/nYZBj/ji15JsEQajIZAPFwtjhDmoFs7gHL/YCWATaVK0jkmnxFZhMcq
         rSjq3lzaL3XqnbGGPUVbH1xH3huEKN7Fgn2V3t0VX8+DP//bTIGn4tN3L1M7rUKntNvH
         4iecn9i7lNWkkO2FJVd1RCE8QfDkjR9DDN2W7uEMzX/XtJKV/7QreJR+Kx3/A4ETiTZu
         sHwlZngbkSTVlQjjBJglWoqzH4nDB68YnFBwDBs/hZ/o4FGyJ/GSFSDqp9OeXceGV87P
         DA3g==
X-Gm-Message-State: AO0yUKXupm5CQRPC3k22QfgqJUpn7Qsqv3708iSERTnDGj/VYCchjJVj
        ktqNSlXpbqnrJJoflrXkFBQsCOiW/mA/oNMjGmld5JDw1ek=
X-Google-Smtp-Source: AK7set+qQyX56S6aaYgQAnWZADrUuGEyCv2jXN12QQNplsIswKcSSX7rqvdOmZeVgzehXxLR2YVMuZ4NCtoCtFAFLJI=
X-Received: by 2002:a05:6902:208:b0:ace:1ae4:9dd2 with SMTP id
 j8-20020a056902020800b00ace1ae49dd2mr8095919ybs.8.1678172039937; Mon, 06 Mar
 2023 22:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-4-joannelkoong@gmail.com> <20230306073628.g2kg5vp6lw6vzyya@apollo>
In-Reply-To: <20230306073628.g2kg5vp6lw6vzyya@apollo>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 6 Mar 2023 22:53:48 -0800
Message-ID: <CAJnrk1ZF5FEtXKsMEnwbLu5qr-mQ6-j9+PK2j1NEf=hLE1CCKQ@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 03/10] bpf: Allow initializing dynptrs in kfuncs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
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

On Sun, Mar 5, 2023 at 11:36=E2=80=AFPM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Mar 01, 2023 at 04:49:46PM CET, Joanne Koong wrote:
> > This change allows kfuncs to take in an uninitialized dynptr as a
> > parameter. Before this change, only helper functions could successfully
> > use uninitialized dynptrs. This change moves the memory access check
> > (including stack state growing and slot marking) into
> > process_dynptr_func(), which both helpers and kfuncs call into.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  kernel/bpf/verifier.c | 67 ++++++++++++++-----------------------------
> >  1 file changed, 22 insertions(+), 45 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index e0e00509846b..82e39fc5ed05 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -268,7 +268,6 @@ struct bpf_call_arg_meta {
> >       u32 ret_btf_id;
> >       u32 subprogno;
> >       struct btf_field *kptr_field;
> > -     u8 uninit_dynptr_regno;
> >  };
> >
> >  struct btf *btf_vmlinux;
> > @@ -6225,10 +6224,11 @@ static int process_kptr_func(struct bpf_verifie=
r_env *env, int regno,
> >   * Helpers which do not mutate the bpf_dynptr set MEM_RDONLY in their =
argument
> >   * type, and declare it as 'const struct bpf_dynptr *' in their protot=
ype.
> >   */
> > -static int process_dynptr_func(struct bpf_verifier_env *env, int regno=
,
> > -                            enum bpf_arg_type arg_type, struct bpf_cal=
l_arg_meta *meta)
> > +static int process_dynptr_func(struct bpf_verifier_env *env, int regno=
, int insn_idx,
> > +                            enum bpf_arg_type arg_type)
> >  {
> >       struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regn=
o];
> > +     int err;
> >
> >       /* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
> >        * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
> > @@ -6254,23 +6254,23 @@ static int process_dynptr_func(struct bpf_verif=
ier_env *env, int regno,
> >        *               to.
> >        */
> >       if (arg_type & MEM_UNINIT) {
> > +             int i;
> > +
> >               if (!is_dynptr_reg_valid_uninit(env, reg)) {
> >                       verbose(env, "Dynptr has to be an uninitialized d=
ynptr\n");
> >                       return -EINVAL;
> >               }
> >
> > -             /* We only support one dynptr being uninitialized at the =
moment,
> > -              * which is sufficient for the helper functions we have r=
ight now.
> > -              */
> > -             if (meta->uninit_dynptr_regno) {
> > -                     verbose(env, "verifier internal error: multiple u=
ninitialized dynptr args\n");
> > -                     return -EFAULT;
> > +             /* we write BPF_DW bits (8 bytes) at a time */
> > +             for (i =3D 0; i < BPF_DYNPTR_SIZE; i +=3D 8) {
> > +                     err =3D check_mem_access(env, insn_idx, regno,
> > +                                            i, BPF_DW, BPF_WRITE, -1, =
false);
> > +                     if (err)
> > +                             return err;
> >               }
>
> I am not sure moving check_mem_access into process_dynptr_func is the rig=
ht
> thing to do. Not sure if a problem already, but sooner or later it might =
be.
>
> The side effects of the call should take effect on the current state only=
 after
> we have gone through all arguments for the helper/kfunc call. In this cas=
e we
> will now do stack access while processing the dynptr arg, which may affec=
t the
> state of stack we see through other memory arguments coming later.
>
> I think it is better to do it after argument processing is done, similar =
to
> existing meta.access_size handling which is done after check_func_arg loo=
p (for
> the same reasons).
>

Thanks for taking a look. I don't have a strong preference for either
so if you do feel strongly about doing the check_mem_access() only
after argument processing, I'm happy to change it. The
check_mem_access() call on the dyntpr will mark only the dynptr stack
slots, so I don't fully see how it may affect the state of stack
through other memory arguments coming later, but I do see your point
about keeping the logic more separated out.

> > [...]
