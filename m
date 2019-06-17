Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A67548BFB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfFQSfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:35:41 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33784 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfFQSfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:35:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id x2so12034425qtr.0;
        Mon, 17 Jun 2019 11:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6R1eTlGzgAfQR7Dbiz2phmu63E+RU6ETeg5r7VI5LIU=;
        b=tADnIhed7CuC/BijpCUz/9AxD4B4fY30mvOvoiXuro/1gyvnxqIwsAqmyMHkx1bw6T
         rAN5BXfCItoQS3t+mmhF+LvZ+cWDruYLyZjCzD60lJb3u43+AExC9o06Lwz0aApG7Q85
         7pmedRwYyat+pIBMkYsbZuqoqQYsavpL9zBfkxdYLV5sCFBeF69G8Y5xmVjoaJ8dkfb8
         YZyrAyPady+YFP0NapwaPaF7rmF48Ez8dJXjwLXtUbjvSOlIpMccfRXcn0w/ZGuqM0pc
         Ca3Xuxf0T97t1RJ6zwRqdqrl+9SvAdOgLs3r6DJ/0CGFqRMcH5ZwyjyMCv2I3jyHr0Jq
         L7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6R1eTlGzgAfQR7Dbiz2phmu63E+RU6ETeg5r7VI5LIU=;
        b=rvDclBaOYxdAjXgRltClgwPYMJKdGthqSCyFcQQTL9IZac/3T7y3tdtHdgG3q4zszg
         z5KPRtOkxk16ysdklO3xmkzEbPALwstiLofF2Gki2FBCwSgpxc/DPnOW1OrdYxovzQ/q
         NS2thOWIzyW0JoeQYKC4hShFvKel7Ch95ZyXIUfBk7j6jv2RI4fhWKoB3dtq64Rg66gH
         pjms0qjOpx8PxAeHyoB805imXnkhnSGML0804wPc3CWYqnvGrYxoUGrbJ6iKahqcAgHW
         9Op779NI5bgcVNtK7k0O7QF+Vd8jOwqiv3K2XShpSWsQGX3lboHjDxTw8UKRIeeKz7DJ
         U1WQ==
X-Gm-Message-State: APjAAAW0hZaqXiQvK4533MwUdyZVj9p75YrYxcq1wSWODnwSpGwh5aMl
        RgR6G6elltrlnjkrJLiw9p7fntMZ6t/Gsn7Njr8=
X-Google-Smtp-Source: APXvYqw3ayZjxjfSJGWiVqOR9NoqEhVz0jUkyjLZR6RvXr/HYuweowdEY9d4cJr0MmrsM9NARW2soXKAQ5kpvhWBjRQ=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr23098602qvh.78.1560796540158;
 Mon, 17 Jun 2019 11:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-3-andriin@fb.com>
 <CAPhsuW6kAN=gMjtXiAJazDFTszuq4xE-9OQTP_GhDX2cxym0NQ@mail.gmail.com>
 <CAEf4BzY_X9jPvwgcVQozS4RyonXEK9mkd58uvPVrjFi-Gvui3Q@mail.gmail.com> <8F07D61C-2751-44A6-9E89-9BE6781FEF81@fb.com>
In-Reply-To: <8F07D61C-2751-44A6-9E89-9BE6781FEF81@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 11:35:29 -0700
Message-ID: <CAEf4BzbP4Urmg3m-ynSv8XAVhhm-4Rk3+F7zguZ7E7-oGBuWOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify ELF
 parsing logic
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:07 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 17, 2019, at 10:24 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Jun 15, 2019 at 1:26 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >>
> >> On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> As a preparation for adding BTF-based BPF map loading, extract .BTF and
> >>> .BTF.ext loading logic. Also simplify error handling in
> >>> bpf_object__elf_collect() by returning early, as there is no common
> >>> clean up to be done.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>> tools/lib/bpf/libbpf.c | 137 ++++++++++++++++++++++-------------------
> >>> 1 file changed, 75 insertions(+), 62 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>> index ba89d9727137..9e39a0a33aeb 100644
> >>> --- a/tools/lib/bpf/libbpf.c
> >>> +++ b/tools/lib/bpf/libbpf.c
> >>> @@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
> >>>        }
> >>> }
> >>>
> >>> +static int bpf_object__load_btf(struct bpf_object *obj,
> >>> +                               Elf_Data *btf_data,
> >>> +                               Elf_Data *btf_ext_data)
> >>> +{
> >>> +       int err = 0;
> >>> +
> >>> +       if (btf_data) {
> >>> +               obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
> >>> +               if (IS_ERR(obj->btf)) {
> >>> +                       pr_warning("Error loading ELF section %s: %d.\n",
> >>> +                                  BTF_ELF_SEC, err);
> >>> +                       goto out;
> >>
> >> If we goto out here, we will return 0.
> >
> >
> > Yes, it's intentional. BTF is treated as optional, so if we fail to
> > load it, libbpf will emit warning, but will proceed as nothing
> > happened and no BTF was supposed to be loaded.
> >
> >>
> >>> +               }
> >>> +               err = btf__finalize_data(obj, obj->btf);
> >>> +               if (err) {
> >>> +                       pr_warning("Error finalizing %s: %d.\n",
> >>> +                                  BTF_ELF_SEC, err);
> >>> +                       goto out;
> >>> +               }
> >>> +               bpf_object__sanitize_btf(obj);
> >>> +               err = btf__load(obj->btf);
> >>> +               if (err) {
> >>> +                       pr_warning("Error loading %s into kernel: %d.\n",
> >>> +                                  BTF_ELF_SEC, err);
> >>> +                       goto out;
> >>> +               }
> >>> +       }
> >>> +       if (btf_ext_data) {
> >>> +               if (!obj->btf) {
> >>> +                       pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
> >>> +                                BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> >>> +                       goto out;
> >>
> >> We will also return 0 when goto out here.
> >
> >
> > See above, it's original behavior of libbpf.
> >
> >>
> >>> +               }
> >>> +               obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
> >>> +                                           btf_ext_data->d_size);
> >>> +               if (IS_ERR(obj->btf_ext)) {
> >>> +                       pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> >>> +                                  BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
> >>> +                       obj->btf_ext = NULL;
> >>> +                       goto out;
> >> And, here. And we will not free obj->btf.
> >
> > This is situation in which we successfully loaded .BTF, but failed to
> > load .BTF.ext. In that case we'll warn about .BTF.ext, but will drop
> > it and continue with .BTF only.
> >
>
> Yeah, that makes sense.
>
> Shall we let bpf_object__load_btf() return void? Since it always
> returns 0?

This is split into bpf_object__init_btf and
bpf_object__sanitize_and_load_btf in patch #6, both of which can
return errors. So probably not worth changing just for one patch.

>
> Thanks,
> Song
>
> <snip>
>
