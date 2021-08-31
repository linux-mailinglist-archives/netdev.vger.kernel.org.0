Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA843FCFA4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 00:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhHaWrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 18:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhHaWrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 18:47:02 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0642DC061575;
        Tue, 31 Aug 2021 15:46:07 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id z5so1493541ybj.2;
        Tue, 31 Aug 2021 15:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=otZ3oCMw/n5h1EAwm8NZDtbkroLUykkNJKE+BB/u/0I=;
        b=fA9jt2LcIWExthUTiv6lZj2Aevt6EGWd+pXWWnWQtYzz+uCDS7oIsGFwPxrNtU/Zmo
         clUysZminLenj7HzV2SGVU/mafgDOBPa6VPSsEkxJocWkgKJ/I2op32fxQa9/U78X5En
         McmwCVFB32wDRxiG1WwWjTY+cbykVZS3zE2aNKft9g6v+U7dbDs4Bfuge608zUytgurp
         eNzkJiBcqwrRVhEJyZlIj0BdrEPRb8aeUvGC0Bh3cBrdd81XqueQcSH/+8Mzjg/4revv
         nS7GyVPecsSJThwhTZyYe3pm5kjNGFRl0s7CyTTRUCB//wH0WJ6XjBoxPIh8hxZsXUHA
         6tvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=otZ3oCMw/n5h1EAwm8NZDtbkroLUykkNJKE+BB/u/0I=;
        b=J2s0HQxOIDdubLjo1+Hy0hyx6Y0Bx5EJ+82OoVXNLRIvLhm4fQlmOaiVXIovD1oCWm
         BBsoRRbPu3WYj1KEOz2/39IjPs81+Uf4ecPyVt1OxXBTCb3wRLOxpH9WZbJdYmVDnPT8
         Nr923Dmudx921kAVo/tKYWL51n1ccAj68KyAIX0ODPENeQUQcrHYe53RqdMUjocB2fjs
         K/pSmAip/1vdGxu7s1o7SryBP+Fpo9UN3eXzP5OUz8MLH1Uu/ZL6rSqaRiHR+qzJQjGd
         zZwfXk7LRzk1xXAqPurwFPRZe4DUUVxKUyarxJ974RcNanyWGMX+5txuHrHFItsDucuG
         2fnQ==
X-Gm-Message-State: AOAM533ebgCHHWnqY2g9Mj1rlooKGbnYe+GZ40PUrvA5nSWtV7HFt3Yc
        /p+Ogg7TukPzadroBubWIry0Y4W5ulxlsw8jwWiF/mrw
X-Google-Smtp-Source: ABdhPJzJz0oXKu32c+3Pm4TcoAwyGygVbmatGEzZDBddE0FxseU0nIuUKdylKqIiKSS9QgkAlHF8OhcoC7m2oaOkZyE=
X-Received: by 2002:a5b:142:: with SMTP id c2mr31867012ybp.425.1630449966235;
 Tue, 31 Aug 2021 15:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210831165802.168776-1-toke@redhat.com>
In-Reply-To: <20210831165802.168776-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 15:45:54 -0700
Message-ID: <CAEf4BzaCukRbk=wBY=jobyCKDpQma-41gH34D=iigpj_AO6Hiw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: don't crash on object files with no symbol tables
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 9:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> If libbpf encounters an ELF file that has been stripped of its symbol
> table, it will crash in bpf_object__add_programs() when trying to
> dereference the obj->efile.symbols pointer. Add a check and return to avo=
id
> this.
>
> Fixes: 6245947c1b3c ("libbpf: Allow gaps in BPF program sections to suppo=
rt overriden weak functions")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6f5e2757bb3c..4cd102affeef 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -668,6 +668,9 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_=
Data *sec_data,
>         const char *name;
>         GElf_Sym sym;
>
> +       if (!symbols)
> +               return -ENOENT;
> +

The more logical place to do this check is in
bpf_object__elf_collect(). Can you add this there? We can also include
helpful error message.

But I'm also curious which Clang version is being used to cause no ELF
symbols being generated?

>         progs =3D obj->programs;
>         nr_progs =3D obj->nr_programs;
>         nr_syms =3D symbols->d_size / sizeof(GElf_Sym);
> --
> 2.33.0
>
