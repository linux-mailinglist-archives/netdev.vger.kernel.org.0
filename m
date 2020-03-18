Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F20189594
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgCRGJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:09:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37196 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgCRGJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 02:09:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id l20so19755677qtp.4;
        Tue, 17 Mar 2020 23:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hOrDhu4laubKEeJB9k+cz1mNqqeDbEFibr1/+5oJSgI=;
        b=ioCptPEWSNpwtDQUWUXkdWQXvPtY+8WpquhOiONv9wlCKJSB+yrI8SuXjDlGbTOx0i
         3DnLyXop+gr5/iFXs5RJmnldUv5s/Q1j7Lp4frPBHVAN2xt2/VdtITisyvIJ7Z2G4mcL
         7b+yePt0xlJum//XYG023zMvuoIt3Q+duOLiswWQMSXRKdLPUSSbxI+mlKUKvKJ4ipDC
         RpKxw3OaB5lKplMOTHK9BLjK7oxjlNuUPqZaWXEXANukYjm+ZnY+Zhqg489jK7fXLmEY
         SVS8naD+zuOmQweSorhacFk9e4PCpkRcO+DfCaeK2mqi1kRcQUVpqG8AqvUXrErep79n
         DCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hOrDhu4laubKEeJB9k+cz1mNqqeDbEFibr1/+5oJSgI=;
        b=Qz14Ow6VNcsdFkhvktUoEAlKCQaoESpgHuWi7SuJfAobToi4nPdO+hyqEB+VJK/+b+
         /t48n7+RN7oZlVdP1aUpjWudCukCcOAfzVYhm1KEaNOGEfPOi47uM/ZqqbDKkuYuPLAY
         a6caEZ+GMIV+qoiJk/mbh1ojX2bnoyptrOhPke0OJypfTgKxlLDECUcHZuUnZ+sLqzGR
         sWlB0d89J5Q1YvQ9KEK51P3whi27IlojD97daeIUEKeykDLwHcncp/TxzEftVtyxIcVt
         zkbO0p1e2PiU/xT+uI3vtdFhV+4BZgAD7x8Dec66d9ZctczcnCn358RUYii5sixQHshJ
         SAOw==
X-Gm-Message-State: ANhLgQ20hlr2UeNTItiTCNuoVxaHRsxI/PE+2aKAOvQBTCg9E6bALcNi
        xsN/prWC/2uDuRyfhuOGUfW5moKTxsCb+IlunW0=
X-Google-Smtp-Source: ADFU+vsp4rVwqd+A1tvD7nL/o9mJ9XKQmb90OeRxNkJ8ylQPLktvRF3vgJSlOmLVh+9tEc37L7f56+Amoyk34GE/4ec=
X-Received: by 2002:ac8:4e14:: with SMTP id c20mr2781451qtw.141.1584511775031;
 Tue, 17 Mar 2020 23:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200318031431.1256036-1-kafai@fb.com> <20200318031437.1256423-1-kafai@fb.com>
In-Reply-To: <20200318031437.1256423-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Mar 2020 23:09:24 -0700
Message-ID: <CAEf4BzbghUkbAjQcDAUGGoTpT-RszbHRYegbFsDLSjRqGvcVDA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] bpftool: Print the enum's name instead of value
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 8:15 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch prints the enum's name if there is one found in
> the array of btf_enum.
>
> The commit 9eea98497951 ("bpf: fix BTF verification of enums")
> has details about an enum could have any power-of-2 size (up to 8 bytes).
> This patch also takes this chance to accommodate these non 4 byte
> enums.
>
> Acked-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/bpf/bpftool/btf_dumper.c | 39 +++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> index 01cc52b834fa..079f9171b1a3 100644
> --- a/tools/bpf/bpftool/btf_dumper.c
> +++ b/tools/bpf/bpftool/btf_dumper.c
> @@ -43,9 +43,42 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
>         return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
>  }
>
> -static void btf_dumper_enum(const void *data, json_writer_t *jw)
> +static void btf_dumper_enum(const struct btf_dumper *d,
> +                           const struct btf_type *t,
> +                           const void *data)
>  {
> -       jsonw_printf(jw, "%d", *(int *)data);
> +       const struct btf_enum *enums = btf_enum(t);
> +       __s64 value;
> +       __u16 i;
> +
> +       switch (t->size) {
> +       case 8:
> +               value = *(__s64 *)data;
> +               break;
> +       case 4:
> +               value = *(__s32 *)data;
> +               break;
> +       case 2:
> +               value = *(__s16 *)data;
> +               break;
> +       case 1:
> +               value = *(__s8 *)data;
> +               break;
> +       default:
> +               jsonw_string(d->jw, "<invalid_enum_size>");

Why not return error and let it propagate, similar to how
btf_dumper_array() can return an error? BTF is malformed if this
happened, so there is no point in continuing dumping, it's most
probably going to be a garbage.

> +               return;
> +       }
> +
> +       for (i = 0; i < btf_vlen(t); i++) {
> +               if (value == enums[i].val) {
> +                       jsonw_string(d->jw,
> +                                    btf__name_by_offset(d->btf,
> +                                                        enums[i].name_off));

nit: local variable will make it cleaner

> +                       return;
> +               }
> +       }
> +
> +       jsonw_int(d->jw, value);
>  }
>
>  static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
> @@ -366,7 +399,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
>         case BTF_KIND_ARRAY:
>                 return btf_dumper_array(d, type_id, data);
>         case BTF_KIND_ENUM:
> -               btf_dumper_enum(data, d->jw);
> +               btf_dumper_enum(d, t, data);
>                 return 0;
>         case BTF_KIND_PTR:
>                 btf_dumper_ptr(data, d->jw, d->is_plain_text);
> --
> 2.17.1
>
