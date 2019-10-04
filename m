Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D877CBD4B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbfJDOdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:33:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46212 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389082AbfJDOdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:33:04 -0400
Received: by mail-qk1-f196.google.com with SMTP id 201so5938392qkd.13;
        Fri, 04 Oct 2019 07:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0BAOrnJxws/NkeaauPTsKJYqJzqmEoKMUXibZznRtY=;
        b=qq9INW7rg+wzsFFTTkeEeHVCyke12pfjMZeWj72hEYjGdazbfAwTbtIKYz7IjeoqrP
         Roilsa9Xrha5VPWnN9IIRNqwNDABHIrK/Ja8CG4PJyvtDgMXwakylAmIBahIerW8qHw0
         qBnjb4LgnsSaRgEcU+3ePQBHmyb4EKtRCrKAmiu3DLWQFeM3l/3l4NsC4Rm+v7md0u0Y
         otyhJN2egGqnEpfNxe9K7eeUetvkOqKo3IJiD96gl2sRs1lu2brXss8HUi38nszLKGdH
         oiNGQ0i6JU9+tWTkWDWFF7BJgxIFwamHYEJ1oRlVkb3RZohITkqqrkhFtP2KtOcgMpgO
         M0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0BAOrnJxws/NkeaauPTsKJYqJzqmEoKMUXibZznRtY=;
        b=najJVD1L1Zh/XwGZ8XSJJeA5edRI8gEt4b1QZawLbp5XRxINzOMEjhZ1P4TmD3Y7d+
         ri8uY8/cLo7+gcwHnjXnh5IMQRL8YGsgJ+he2vcCfzy6XCfIzSOxmUeZ07nxKpup1ZzI
         vat8gqSxoP3m1svCMzON+WFC3nQTKdaDFjubtpGrOD5ldqvN52qsF1Fr84PjykvTxkIo
         hMsnPSGDzqLyPLxRe6F0pkgd2Z2kE/9aPeLDH9I8tUwjXd0XdEVj3F89Ns9vbWzhuoSZ
         o/Q/+/wLM3WwL327EJsxelLFgL1y3wZ6Iv2Z9rQEv/SaL9O0pUCqJL1AhfmPIw/GpAXR
         FEsQ==
X-Gm-Message-State: APjAAAUesPS6VcYas49aOJQno/i+A1QC1KuioyciXGOFs9ZnxkyrRH1K
        bWqnIKyR7ZP3ip1AZ+m345xvHByLSnqVH/L+99k=
X-Google-Smtp-Source: APXvYqzDyp1CK81t2So0mIVSU5JD46MYjUColOZ8HjhmsZ6p38beJYSHbPGukwVx4VLxvDXK+BcUhbjGdL/aJixawoQ=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr10141436qkk.39.1570199581866;
 Fri, 04 Oct 2019 07:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191004030058.2248514-1-andriin@fb.com> <20191004030058.2248514-2-andriin@fb.com>
 <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
In-Reply-To: <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 07:32:50 -0700
Message-ID: <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 7:05 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Kernel version enforcement for kprobes/kretprobes was removed from
> > 5.0 kernel in 6c4fc209fcf9 ("bpf: remove useless version check for prog load").
> > Since then, BPF programs were specifying SEC("version") just to please
> > libbpf. We should stop enforcing this in libbpf, if even kernel doesn't
> > care. Furthermore, libbpf now will pre-populate current kernel version
> > of the host system, in case we are still running on old kernel.
> >
> > This patch also removes __bpf_object__open_xattr from libbpf.h, as
> > nothing in libbpf is relying on having it in that header. That function
> > was never exported as LIBBPF_API and even name suggests its internal
> > version. So this should be safe to remove, as it doesn't break ABI.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c                        | 79 ++++++-------------
> >  tools/lib/bpf/libbpf.h                        |  2 -
> >  .../selftests/bpf/progs/test_attach_probe.c   |  1 -
> >  .../bpf/progs/test_get_stack_rawtp.c          |  1 -
> >  .../selftests/bpf/progs/test_perf_buffer.c    |  1 -
> >  .../selftests/bpf/progs/test_stacktrace_map.c |  1 -
> >  6 files changed, 22 insertions(+), 63 deletions(-)
>
> [...]
>
> >  static struct bpf_object *
> > -__bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
> > -                bool needs_kver, int flags)
> > +__bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
> > +                int flags)
> >  {
> >       struct bpf_object *obj;
> >       int err;
> > @@ -3617,7 +3585,6 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
> >       CHECK_ERR(bpf_object__probe_caps(obj), err, out);
> >       CHECK_ERR(bpf_object__elf_collect(obj, flags), err, out);
>
> If we are not going to validate the section should we also skip collect'ing it?

Well, if user supplied version, we will parse and use it to override
out prepopulated one, so in that sense we do have validation.

But I think it's fine just to drop it altogether. Will do in v3.

>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e0276520171b..22a458cd602c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1567,12 +1567,6 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                                                        data->d_size);
>                         if (err)
>                                 return err;
> -               } else if (strcmp(name, "version") == 0) {
> -                       err = bpf_object__init_kversion(obj,
> -                                                       data->d_buf,
> -                                                       data->d_size);
> -                       if (err)
> -                               return err;
>                 } else if (strcmp(name, "maps") == 0) {
>                         obj->efile.maps_shndx = idx;
>                 } else if (strcmp(name, MAPS_ELF_SEC) == 0) {
>
>
> >       CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
> > -     CHECK_ERR(bpf_object__validate(obj, needs_kver), err, out);
> >
> >       bpf_object__elf_finish(obj);
> >       return obj;
> > @@ -3626,8 +3593,8 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
> >       return ERR_PTR(err);
> >  }
