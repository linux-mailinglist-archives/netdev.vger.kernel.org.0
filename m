Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF56FED1AA
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 05:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfKCEIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 00:08:14 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43214 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfKCEIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 00:08:14 -0400
Received: by mail-vs1-f66.google.com with SMTP id b16so2745793vso.10;
        Sat, 02 Nov 2019 21:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dHQ4kTrr26FK3sgxF6fkTUBGq8//AsIFAbnx2OckA/w=;
        b=PzxVF3TLvUKFk3NGYkyfPvkof9DdBTtIAgUK/kahNK0DUzHV6T1hPQe1uT56v7NY34
         loeWfgPbkMrX6BT/rHs2JVHp67xGu8yS7bzRYCOwEhQ7aZgoEocntKQZIRPP+UPFIcuT
         CvyU8zcueaYEiZkdDSrkZeQ9KgqAGkvarT1vJ0uWAhNZsv0iKT8ecybPGswRC2xdXxBJ
         WvRj25tZmt+2A2fZxBD1uDkqZLUr53GIuzpj62YCSkMU0g5FeIVC5L8jtCBLdOHu+3eN
         4EvY32sG0MNwk3Ivd6d37s0St+YE5LavDbI5dgi0Zb4IGAkohgV1XPuuoaF9/FKRdd2R
         jxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dHQ4kTrr26FK3sgxF6fkTUBGq8//AsIFAbnx2OckA/w=;
        b=LBG9T3bmbMNx4CDMneqK1f9erYgiL2Cd7YWs7qHaFifRhmk5JSqkxMd4pFD9PQmlgp
         PAPW6PO0C3e6gLHa+H7qOe/ThE2yIAq7eedSSgtqxqsiue+mMMFVJil1h3HKqq2DY5aa
         IncfGfb3T0jlvdXdxH0JwZRSRnsss6GGdKKyS/tNK7LXKDIfcTHODmyYTsTp88v0g5z6
         ElL65BP1OS+2d0rUGerqrhAGq7U0SYT2DC5iM/+fxBvj1VBNJSHBy6t4ZNjcEFhvIupd
         Aj2Qwckem6P7u+0iWk4PIDCmRswqas4XBe2lzxyicQZLJvV+MKS1V1ctptnKNOlo/UGj
         WGzg==
X-Gm-Message-State: APjAAAVF0IlsNkLUnApdzSfNXY4cykISTtAlfZealTjtO+CEtE9DD5SJ
        UmFR0prQeHKAKzbFIlMdkxyv4qVWmrbcA84vGdc=
X-Google-Smtp-Source: APXvYqw+HWS3LHIlGwEWEMxSPhgtTgKfkJPKPWsG5qZB9/g79rSfFVMJZYJxbrnZmWHnS/fQVmE3M6sdH6X/wY1nzEw=
X-Received: by 2002:a67:1dc7:: with SMTP id d190mr10262943vsd.154.1572754092798;
 Sat, 02 Nov 2019 21:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191101125707.10043-1-ethercflow@gmail.com> <CAEf4BzZhNCbASJ+ze4ECddoWLZwr5a=HL7BZ1Zgg+Re=4cyNzw@mail.gmail.com>
In-Reply-To: <CAEf4BzZhNCbASJ+ze4ECddoWLZwr5a=HL7BZ1Zgg+Re=4cyNzw@mail.gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Sun, 3 Nov 2019 12:08:09 +0800
Message-ID: <CABtjQmYCaKXTrNbdXpWGOMFi9_OD80Ex9XNehsnJhq1+dYDKWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] bpf: add new helper get_file_path for mapping
 a file descriptor to a pathname
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> nit: I'd avoid unnecessary goto end (and end label itself) by having
> two explicit returns:

>    return 0;
> error:
>    memset(...);

Agree, I'll send a new patch with explicit returns.  BTW Yonghong has
pointed this on v1 too, but I didn't get the whole point at that time,
 just made a part of change. Thank you both.

> This seems like a rather useful helper not just in tracing context. So
> if maintainers are ok with that, maybe you can follow up with patch
> that adds it in more BPF program types.

Glad to hear this, I'll keep following up with it.

Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2019=E5=B9=B411=E6=9C=
=882=E6=97=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=881:37=E5=86=99=E9=81=93=EF=
=BC=9A
>
> On Fri, Nov 1, 2019 at 5:57 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
> >
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported=
.
> >
> > This requirement is mainly discussed here:
> >
> >   https://github.com/iovisor/bcc/issues/237
> >
> > v4->v5: addressed Andrii and Daniel's feedback
> > - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> > helper's names
> > - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> > - remove fdput from fdget_raw's error path
> > - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointe=
r
> > into the buffer or an error code if the path was too long
> > - modify the normal path's return value to return copied string lengh
> > including NUL
> > - update this helper description's Return bits.
> >
> > v3->v4: addressed Daniel's feedback
> > - fix missing fdput()
> > - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> > - move fd2path's test code to another patch
> > - add comment to explain why use fdget_raw instead of fdget
> >
> > v2->v3: addressed Yonghong's feedback
> > - remove unnecessary LOCKDOWN_BPF_READ
> > - refactor error handling section for enhanced readability
> > - provide a test case in tools/testing/selftests/bpf
> >
> > v1->v2: addressed Daniel's feedback
> > - fix backward compatibility
> > - add this helper description
> > - fix signed-off name
> > ---
>
> See nit below, but I'm fine with the current state as well.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index f50bf19f7a05..fc9f577e65f5 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -683,6 +683,53 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >         .arg1_type      =3D ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> > +{
> > +       struct fd f;
> > +       char *p;
> > +       int ret =3D -EBADF;
> > +
> > +       /* Use fdget_raw instead of fdget to support O_PATH, and
> > +        * fdget_raw doesn't have any sleepable code, so it's ok
> > +        * to be here.
> > +        */
> > +       f =3D fdget_raw(fd);
> > +       if (!f.file)
> > +               goto error;
> > +
> > +       /* d_path doesn't have any sleepable code, so it's ok to
> > +        * be here. But it uses the current macro to get fs_struct
> > +        * (current->fs). So this helper shouldn't be called in
> > +        * interrupt context.
> > +        */
> > +       p =3D d_path(&f.file->f_path, dst, size);
> > +       if (IS_ERR(p)) {
> > +               ret =3D PTR_ERR(p);
> > +               fdput(f);
> > +               goto error;
> > +       }
> > +
> > +       ret =3D strlen(p);
> > +       memmove(dst, p, ret);
> > +       dst[ret++] =3D '\0';
> > +       fdput(f);
> > +       goto end;
> > +
> > +error:
> > +       memset(dst, '0', size);
> > +end:
> > +       return ret;
>
> nit: I'd avoid unnecessary goto end (and end label itself) by having
> two explicit returns:
>
>     return 0;
> error:
>     memset(...);
>     return ret;
>
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_file_path_proto =3D {
> > +       .func       =3D bpf_get_file_path,
> > +       .gpl_only   =3D true,
> > +       .ret_type   =3D RET_INTEGER,
> > +       .arg1_type  =3D ARG_PTR_TO_UNINIT_MEM,
> > +       .arg2_type  =3D ARG_CONST_SIZE,
> > +       .arg3_type  =3D ARG_ANYTHING,
> > +};
> > +
> >  static const struct bpf_func_proto *
> >  tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *pr=
og)
> >  {
> > @@ -735,6 +782,8 @@ tracing_func_proto(enum bpf_func_id func_id, const =
struct bpf_prog *prog)
> >  #endif
> >         case BPF_FUNC_send_signal:
> >                 return &bpf_send_signal_proto;
> > +       case BPF_FUNC_get_file_path:
> > +               return &bpf_get_file_path_proto;
>
> This seems like a rather useful helper not just in tracing context. So
> if maintainers are ok with that, maybe you can follow up with patch
> that adds it in more BPF program types.
>
> >         default:
> >                 return NULL;
> >         }
>
> [...]
