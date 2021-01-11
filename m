Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E11E2F21F3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbhAKVkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:40:17 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66880C061786;
        Mon, 11 Jan 2021 13:39:36 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id f13so177767ybk.11;
        Mon, 11 Jan 2021 13:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UCTLgQi//trDf/3xfHtidBpAiONSARa5x17fgpo7iHY=;
        b=eMYBooe4uyihN5ZgPxyecKyJftfnqFS3hDFX6FIsWaIsQQyWvPdQ/EkYOaSq2fkmxu
         kAjzHw/MI0ITcodiLKfOeDuCyXZO1BFLLKvQcjpc+sqt9OH5+1JMYnNI/0FSPYcWLYib
         EaaZ9LHVYzXKiWGKOISBMllG+UsPYpqeswEDwtUjtJiK6z6L4oG/0SE2PSXS32uTiC2Z
         QJscbLxYW6umwIegDm0sCX4JsAe9nx5XlepR3PSGAGRzojakRuKtgq+ES54DEhWmc96S
         GQkC27/jqsn4YK4IodFoVWc26eEBuIVKxSUfCO4qiuMThOMHd2+PZClUosp2oi3WcmI/
         r9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UCTLgQi//trDf/3xfHtidBpAiONSARa5x17fgpo7iHY=;
        b=PMJzDIBG413oL0htf/DTRqpeLqtVcjgXEvA6dryVu70n8zbgV4vxHi9C6x2EVZdMM7
         HBV8aDj/G3pWs5ECEUWRI4VW7Aa6M99GnDx/3keWqwCjmbGw6I7JxaITBGAvubKdfvpY
         wlg9YG8d+0zq1sghiuVurDtGKBmNNBI/bSeG2SktfHvDOolekzChqCm9WXQwQFYwmg1v
         HvKx2JWiY4hFRX9/H63+SlKoFOoihM6lKSHkDaiAog1HU/V3/6lys/to023tH9YmoxQ5
         d5MdZFBL3KbvEpGjuMgEx8I880l9CS+RlFnaIxAdJ1FQvWF0sGRJlV21I9J8gTMpNWcg
         0eyQ==
X-Gm-Message-State: AOAM532LIQy3rXiBwajVVJ6bpB+NeeV7cPHjl4w4+p7A4nTFzGSzm2G8
        FCb8sFPVKOoEADgR1aySpEDOOLcnaIs/L7L0Qwk=
X-Google-Smtp-Source: ABdhPJyMJPE5kdPqCRNVjjsxClKRWaYhRGXh80tUvdEi6eXnE4Dp00aw12MKmh0IqqQQOB9cebb92Buj0eyEKQD9LO8=
X-Received: by 2002:a25:9882:: with SMTP id l2mr2375996ybo.425.1610401175718;
 Mon, 11 Jan 2021 13:39:35 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-7-andrii@kernel.org>
 <CA+khW7jWiTRe36Uc5zKzk_bHmC+R_QZ43EBRo0gmPGhZHiOrqA@mail.gmail.com>
In-Reply-To: <CA+khW7jWiTRe36Uc5zKzk_bHmC+R_QZ43EBRo0gmPGhZHiOrqA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:39:25 -0800
Message-ID: <CAEf4Bza7XcXMGb-85SE+2ymtRsxvEooWg18dvjh6xztJ6k3akQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 6/7] libbpf: support kernel module ksym externs
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:00 AM Hao Luo <haoluo@google.com> wrote:
>
> Acked-by: Hao Luo <haoluo@google.com>, with a couple of nits.
>
> On Fri, Jan 8, 2021 at 2:09 PM Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Add support for searching for ksym externs not just in vmlinux BTF, but across
> > all module BTFs, similarly to how it's done for CO-RE relocations. Kernels
> > that expose module BTFs through sysfs are assumed to support new ldimm64
> > instruction extension with BTF FD provided in insn[1].imm field, so no extra
> > feature detection is performed.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 47 +++++++++++++++++++++++++++---------------
> >  1 file changed, 30 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 6ae748f6ea11..57559a71e4de 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> [...]
> > @@ -7319,7 +7321,8 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
> >  static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >  {
> >         struct extern_desc *ext;
> > -       int i, id;
> > +       struct btf *btf;
> > +       int i, j, id, btf_fd, err;
> >
> >         for (i = 0; i < obj->nr_extern; i++) {
> >                 const struct btf_type *targ_var, *targ_type;
> > @@ -7331,8 +7334,22 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> >                 if (ext->type != EXT_KSYM || !ext->ksym.type_id)
> >                         continue;
> >
> > -               id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> > -                                           BTF_KIND_VAR);
> > +               btf = obj->btf_vmlinux;
> > +               btf_fd = 0;
> > +               id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
>
> Is "if (id <= 0)" better? Just in case, more error code is introduced in future.

There is id <= 0 right below after special-casing -ENOENT, so all
works as you want, no?

>
> > +               if (id == -ENOENT) {
> > +                       err = load_module_btfs(obj);
> > +                       if (err)
> > +                               return err;
> > +
> > +                       for (j = 0; j < obj->btf_module_cnt; j++) {
> > +                               btf = obj->btf_modules[j].btf;
> > +                               btf_fd = obj->btf_modules[j].fd;
> > +                               id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
> > +                               if (id != -ENOENT)
> > +                                       break;
> > +                       }
> > +               }
> >                 if (id <= 0) {
>
> Nit: the warning message isn't accurate any more, right? We also
> searched kernel modules' BTF.

Right, how about just "failed to find BTF ID in kernel BTF"? Where
"kernel BTF" is "vmlinux BTF or any of kernel modules' BTFs"?

>
> >                         pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
> >                                 ext->name);
> > @@ -7343,24 +7360,19 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> [...]
>
> > --
> > 2.24.1
> >
