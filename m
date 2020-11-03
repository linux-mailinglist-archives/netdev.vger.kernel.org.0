Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD302A3BBC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgKCFTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgKCFTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:19:01 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032A1C0617A6;
        Mon,  2 Nov 2020 21:19:00 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id o70so13801689ybc.1;
        Mon, 02 Nov 2020 21:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gxrcoahf+z+YCv27snV0wtwr6H2W8dOeW6o+kPT2z40=;
        b=sHnvGlJApyh5NYo8ZoFUxzRO3yUcDyPkAXOQtja7eU3IPfnXyDDc1+njw6byhH6aW1
         HLnvLVm4oAnjsM1SZbfutD7BXGa9aEbMQJ3pNBOH8s6cnH6OMAv7q7yifnFA2sZUC49i
         rmawkA3BX1BCueMGI4hkSkt9v6R7Q11C+9vm5/lSMi7MSlQ4iY8y6cJRY8MXHz7rqyO6
         8eFwS5/4FRTGJLRbVs9MtZ/+8UY2HgsU8DBXAUgZ1iolbl9HpP1DAHbHU6TnoZPy6d3w
         5Z+mHpAO24WzRZV3jNwBNX2a51MmChr6KjF4dyU0gz1mJJMJuvRma1KN//RC8VWzZ5Qf
         bbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gxrcoahf+z+YCv27snV0wtwr6H2W8dOeW6o+kPT2z40=;
        b=nl7d8jTlcKUugh96wZQ46OnwLgE3HGlk/cmosdfwEuYMYE6kW8Kl3qLl9cGyfe4DFJ
         yjqCSBgQj0mXr8ioaR64EkaagO/pM6daoomPlFpAidirAGbD1ChR/nlRXh1H5M/FnGhb
         oxTqHh2LB7qeIzR6tG4sHwBoKvC+HEhNisWXvXHLiR+EqOqeN+fmXAQda1z3rULbjjOj
         9JPX2EsRBOj0cLrtB0gMb/Vys37G9DBOGcV3zJTduHXvpSXmWqyzf/+As5YTKThOYdhe
         Skicfhsw8vdSjduZK4XjW1DVCTAn1LojSLBE+tbFsvkSFkD7H+6AYX3JhoLOEsL3d7tp
         Dvrw==
X-Gm-Message-State: AOAM531GwL4z8O4XOUNC8l3bd3J1uCxZ37CtNWMydAktsYYBJvKPBzui
        mJkbTxwivx8OuVxjGkb51hZzeFrTrdvg3fxRdxU=
X-Google-Smtp-Source: ABdhPJx0UjDrjUVo0hWQgQlSBNYcVxf02H36ljcuHTEnny29zgI/QIfBPEN8LQI/NBa5gkmwe1YWYj55dDUHeLZJ+FE=
X-Received: by 2002:a25:c001:: with SMTP id c1mr24586021ybf.27.1604380740101;
 Mon, 02 Nov 2020 21:19:00 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-8-andrii@kernel.org>
 <DC33E827-1A58-4AFF-A91B-138FBC8728A6@fb.com>
In-Reply-To: <DC33E827-1A58-4AFF-A91B-138FBC8728A6@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 21:18:48 -0800
Message-ID: <CAEf4Bzbwmbx=q7o03q99866sgSijtAjBMWWTbSCgshtv76otyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/11] libbpf: fix BTF data layout checks and
 allow empty BTF
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 4:51 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Make data section layout checks stricter, disallowing overlap of types and
> > strings data.
> >
> > Additionally, allow BTFs with no type data. There is nothing inherently wrong
> > with having BTF with no types (put potentially with some strings). This could
> > be a situation with kernel module BTFs, if module doesn't introduce any new
> > type information.
> >
> > Also fix invalid offset alignment check for btf->hdr->type_off.
> >
> > Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> > tools/lib/bpf/btf.c | 16 ++++++----------
> > 1 file changed, 6 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 20c64a8441a8..9b0ef71a03d0 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -245,22 +245,18 @@ static int btf_parse_hdr(struct btf *btf)
> >               return -EINVAL;
> >       }
> >
> > -     if (meta_left < hdr->type_off) {
> > -             pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
> > +     if (meta_left < hdr->str_off + hdr->str_len) {
> > +             pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> >               return -EINVAL;
> >       }
>
> Can we make this one as
>         if (meta_left != hdr->str_off + hdr->str_len) {

That would be not forward-compatible. I.e., old libbpf loading new BTF
with extra stuff after the string section. Kernel is necessarily more
strict, but I'd like to keep libbpf more permissive with this.

>
> >
> > -     if (meta_left < hdr->str_off) {
> > -             pr_debug("Invalid BTF string section offset:%u\n", hdr->str_off);
> > +     if (hdr->type_off + hdr->type_len > hdr->str_off) {
> > +             pr_debug("Invalid BTF data sections layout: type data at %u + %u, strings data at %u + %u\n",
> > +                      hdr->type_off, hdr->type_len, hdr->str_off, hdr->str_len);
> >               return -EINVAL;
> >       }
>
> And this one
>         if (hdr->type_off + hdr->type_len != hdr->str_off) {
>
> ?

Similarly, libbpf could be a bit more permissive here without
sacrificing correctness (at least for read-only BTF, when rewriting
BTF extra data will be discarded, of course).

>
> [...]
