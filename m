Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82856BD628
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjCPQph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCPQpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:45:36 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B772364F;
        Thu, 16 Mar 2023 09:45:23 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o12so10052429edb.9;
        Thu, 16 Mar 2023 09:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678985121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qk1KsGWLQztfODkdNA5CzyfHGVNa/z2WXDSLe6Kroh4=;
        b=TPl+6VW4i1BEntBSGrmHQhuPkLML1xqbQGeMJKTVjspAc7xPiOba9iZZ6L1U/Io5Ww
         WuBvjosXRcdiEPrST6aNoi7cK0u42OAGRO1n60HNQRKZwtIfRoNULJIMSBWBqjaj7imW
         uzPjbsZr9+Sb941AuVsWSLHmrkY7a4L+uiQ+xfYKXtmQ7PkZ8fgFo6EC7APH0jWWxsuM
         vR4+aZ/XJX+5sdpBmwZ+K7rmSzxMtRcMiL+5dNbGzyp9Ksh1nRqiPlRRTfWUbU3NKgO2
         DZQef3frrc2GxXCeDZDJNRMTT6moJcZ7YKo1WRQEZ2l/FMn6zsITqqFb94Q5M/FgS0ro
         BAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678985121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qk1KsGWLQztfODkdNA5CzyfHGVNa/z2WXDSLe6Kroh4=;
        b=E4mxZUa2H83ZR60xleeQKqBAw8zuigk95f3U5un1LJHogB7Eu3fLdwvS4buhLhT5rR
         +W2tVYPdKlGj9f9LY7dzKJ0uckFgZwDJrbgUGbausb0nf53p5lGCNsND8pWRNCmKVesk
         JEDlTTkof1aWwv2r0CjfruxoANAZyAP6V0TcRPmyyBtisY6fD84HgXhQcFcIlwsrGSil
         Jh/pbfwWNriGyV1cy0kDdlOXv3NP7VHJFJ+I7ZcO45U1sX38u9tpSo2ySKr05DJjWaPS
         bHr6xC30v+Q7nj0wdQwKPtw3Q8Vny+9dLX/PEAlx4GPepmJLhbXKAvJU9pPSAsmloWuf
         x2wA==
X-Gm-Message-State: AO0yUKV+zU8WsJ9P/gs+rsdFM8poPmUBMWAJwvndGlBdVu3aW34+ZPas
        HT+994VUydRdI/3Zo+BeLDZDdSmjD/j5tzsQUiQ=
X-Google-Smtp-Source: AK7set+n8BZhzkGD4ZyVPUj5SbSUpkrn7DsakOw8BaQfdZ36BLko2RCh5UwkfeOmpLxAd4+nOFvx4rrGkMvcRySKxx4=
X-Received: by 2002:a17:907:36e:b0:877:747d:4a85 with SMTP id
 rs14-20020a170907036e00b00877747d4a85mr5740162ejb.3.1678985121420; Thu, 16
 Mar 2023 09:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-2-alexei.starovoitov@gmail.com> <e3a68d87c4f7589ab19fe6ddf6b0341404108386.camel@gmail.com>
In-Reply-To: <e3a68d87c4f7589ab19fe6ddf6b0341404108386.camel@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Mar 2023 09:45:10 -0700
Message-ID: <CAADnVQL62Qr0ChNgOcs0o-pJ+x9HKx8R-TY321XaGqY=TSL2jQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to kfunc.
To:     Eduard Zingerman <eddyz87@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
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

On Thu, Mar 16, 2023 at 7:14=E2=80=AFAM Eduard Zingerman <eddyz87@gmail.com=
> wrote:
>
> On Wed, 2023-03-15 at 15:36 -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfunc=
.
> > PTR_MEM is already recognized for NULL-ness by is_branch_taken(),
> > so unresolved kfuncs will be seen as zero.
> > This allows BPF programs to detect at load time whether kfunc is presen=
t
> > in the kernel with bpf_kfunc_exists() macro.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  kernel/bpf/verifier.c       | 7 +++++--
> >  tools/lib/bpf/bpf_helpers.h | 3 +++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 60793f793ca6..4e49d34d8cd6 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15955,8 +15955,8 @@ static int check_pseudo_btf_id(struct bpf_verif=
ier_env *env,
> >               goto err_put;
> >       }
> >
> > -     if (!btf_type_is_var(t)) {
> > -             verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.=
\n", id);
> > +     if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
> > +             verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR =
or KIND_FUNC\n", id);
> >               err =3D -EINVAL;
> >               goto err_put;
> >       }
> > @@ -15990,6 +15990,9 @@ static int check_pseudo_btf_id(struct bpf_verif=
ier_env *env,
> >               aux->btf_var.reg_type =3D PTR_TO_BTF_ID | MEM_PERCPU;
> >               aux->btf_var.btf =3D btf;
> >               aux->btf_var.btf_id =3D type;
> > +     } else if (!btf_type_is_func(t)) {
> > +             aux->btf_var.reg_type =3D PTR_TO_MEM | MEM_RDONLY;
> > +             aux->btf_var.mem_size =3D 0;
>
> This if statement has the following conditions in master:
>
>         if (percpu) {
>         // ...
>         } else if (!btf_type_is_struct(t)) {
>         // ...
>         } else {
>         // ...
>         }
>
> Conditions `!btf_type_is_func()` and `!btf_type_is_struct()` are
> not mutually exclusive, thus adding `if (!btf_type_is_func())`
> would match certain conditions that were previously matched by struct
> case, wouldn't it? E.g. if type is `BTF_KIND_INT`?

ohh. good catch!

> Although, I was not able to trigger it, as it seems that pahole only
> encodes per-cpu vars in BTF.

right. that's why we don't have selftests for this code
that could have caught my braino.

There were patches to add vars to vmlinux btf, but it didn't materialize ye=
t.
