Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC16436867A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbhDVSVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhDVSV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:21:26 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CD8C06174A;
        Thu, 22 Apr 2021 11:20:50 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 130so8791700ybd.10;
        Thu, 22 Apr 2021 11:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yla/fgQMezi+zBG98YhdM1UO3tG9GpIMl8AKfmJOAIE=;
        b=LjkT53ZNHZ7sV8KUbxDrUQr05jcdvpeB6VGFM6VIIZ5LhlYRd+hKJfdzMSvHk2+BAO
         B33yIXe/BVCuVm2SUfzmnykR+JlU6cANKIRheetgoJBn+SO36SLrUsvGpZ6a8Qo0k1SE
         StBHv/olp9GO3zYf3cV2JpL1kHC2NjMILOvznhEBjIJRPDeiDn2y84dN2QuL+IhV3EAf
         X01BJaserezv4l1E2F5MEfyOWwrK8tjW2XuL4MWDtycUX29Nu4kMgRuJ9aQm2Z7evTSD
         l4ixBwgsHSn3G3InwJSxMwg7C6UTvUoLVuwcxYeYxLppcNlpVsGuWt7/8ezg0tQu+C38
         g1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yla/fgQMezi+zBG98YhdM1UO3tG9GpIMl8AKfmJOAIE=;
        b=MO4+CdeuSph5NiBo8eSyFYqD7xZz/OngjUic/gX2PcTfCI5JkgeaRxBs5xEV3r43Nw
         7utvUDgGhLAMXCslL/ShjqDZgpgg62W1tLOREPRhN1aHmLjMVUsueTPsC/RVM4WYb6CI
         GKsfqG+RWLpKZBCCG6Wyq0fZOEdVPJlUwzAesoye5wYqQ/He1Rt0mPm7I3emN2D6hNSc
         LOtA9swtnRcKmVZCh6yVq6XxRAZDtm4g8xV6vx1RUPiDlTy/oWenTZf7Okiymy1FaTCj
         fd5oHeIKybwSAc1JR2EfH8QIJY6H+9krTOzIsTQ49UMz+7MSjj4aw8O8q7DXAgkv6xO9
         3NgQ==
X-Gm-Message-State: AOAM532PZo30sNX8N/czjw7TLjNitsqAJ1SUp+I2V1dpxSLB5ZDca9vw
        GBfUsP4qOoWU66ahyqbZXxQUVC+MpOCchkdfNGc=
X-Google-Smtp-Source: ABdhPJyL933bBt4O4j54sdf4hTuPkmv/Kfi+bjk+85rJDuaKvYMDMAQO6fL7GdjDEjd3f8SbtBCSq5QdLkCTOaWrk4A=
X-Received: by 2002:a25:dc46:: with SMTP id y67mr6832430ybe.27.1619115649392;
 Thu, 22 Apr 2021 11:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-10-andrii@kernel.org>
 <7ad73fdc-e81a-9b4b-1dce-e8c304e88e0a@fb.com>
In-Reply-To: <7ad73fdc-e81a-9b4b-1dce-e8c304e88e0a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:20:38 -0700
Message-ID: <CAEf4BzZjry6=1tu=1Msx9JNGSwS8LOyCbZFioO-1CxWc-AzW6g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 09/17] libbpf: extend sanity checking ELF
 symbols with externs validation
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 9:35 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Add logic to validate extern symbols, plus some other minor extra checks, like
> > ELF symbol #0 validation, general symbol visibility and binding validations.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/linker.c | 43 +++++++++++++++++++++++++++++++++---------
> >   1 file changed, 34 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> > index 1263641e8b97..283249df9831 100644
> > --- a/tools/lib/bpf/linker.c
> > +++ b/tools/lib/bpf/linker.c
> > @@ -750,14 +750,39 @@ static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *s
> >       n = sec->shdr->sh_size / sec->shdr->sh_entsize;
> >       sym = sec->data->d_buf;
> >       for (i = 0; i < n; i++, sym++) {
> > -             if (sym->st_shndx
> > -                 && sym->st_shndx < SHN_LORESERVE
> > -                 && sym->st_shndx >= obj->sec_cnt) {
> > +             int sym_type = ELF64_ST_TYPE(sym->st_info);
> > +             int sym_bind = ELF64_ST_BIND(sym->st_info);
> > +
> > +             if (i == 0) {
> > +                     if (sym->st_name != 0 || sym->st_info != 0
> > +                         || sym->st_other != 0 || sym->st_shndx != 0
> > +                         || sym->st_value != 0 || sym->st_size != 0) {
> > +                             pr_warn("ELF sym #0 is invalid in %s\n", obj->filename);
> > +                             return -EINVAL;
> > +                     }
> > +                     continue;
> > +             }
>
> In ELF file, the first entry of symbol table and section table (index 0)
> is invalid/undefined.
>
> Symbol table '.symtab' contains 9 entries:
>     Num:    Value          Size Type    Bind   Vis       Ndx Name
>       0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   UND
>
> Section Headers:
>
>    [Nr] Name              Type            Address          Off    Size
>   ES Flg Lk Inf Al
>    [ 0]                   NULL            0000000000000000 000000 000000
> 00      0   0  0
>
> Instead of validating them, I think we can skip traversal of the index =
> 0 entry for symbol table and section header table. What do you think?

In valid ELF yes. But then entire sanity check logic is not needed if
we just assume correct ELF. But I don't want to make that potentially
dangerous assumption :) Here I'm validating that ELF is sane with
minimal efforts. I do skip symbol #0 later because I validated that
it's all-zero one, as expected by ELF standard.

>
> > +             if (sym_bind != STB_LOCAL && sym_bind != STB_GLOBAL && sym_bind != STB_WEAK) {
> > +                     pr_warn("ELF sym #%d is section #%zu has unsupported symbol binding %d\n",
> > +                             i, sec->sec_idx, sym_bind);
> > +                     return -EINVAL;
> > +             }
> > +             if (sym->st_shndx == 0) {
> > +                     if (sym_type != STT_NOTYPE || sym_bind == STB_LOCAL
> > +                         || sym->st_value != 0 || sym->st_size != 0) {
> > +                             pr_warn("ELF sym #%d is invalid extern symbol in %s\n",
> > +                                     i, obj->filename);
> > +
> > +                             return -EINVAL;
> > +                     }
> > +                     continue;
> > +             }
> > +             if (sym->st_shndx < SHN_LORESERVE && sym->st_shndx >= obj->sec_cnt) {
> >                       pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
> >                               i, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
> >                       return -EINVAL;
> >               }
> > -             if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
> > +             if (sym_type == STT_SECTION) {
> >                       if (sym->st_value != 0)
> >                               return -EINVAL;
> >                       continue;
> > @@ -1135,16 +1160,16 @@ static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj
> >               size_t dst_sym_idx;
> >               int name_off;
> >
> > -             /* we already have all-zero initial symbol */
> > -             if (sym->st_name == 0 && sym->st_info == 0 &&
> > -                 sym->st_other == 0 && sym->st_shndx == SHN_UNDEF &&
> > -                 sym->st_value == 0 && sym->st_size ==0)
> > +             /* We already validated all-zero symbol #0 and we already
> > +              * appended it preventively to the final SYMTAB, so skip it.
> > +              */
> > +             if (i == 0)
> >                       continue;
> >
> >               sym_name = elf_strptr(obj->elf, str_sec_idx, sym->st_name);
> >               if (!sym_name) {
> >                       pr_warn("can't fetch symbol name for symbol #%d in '%s'\n", i, obj->filename);
> > -                     return -1;
> > +                     return -EINVAL;
> >               }
> >
> >               if (sym->st_shndx && sym->st_shndx < SHN_LORESERVE) {
> >
