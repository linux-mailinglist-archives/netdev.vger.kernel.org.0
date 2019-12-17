Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3E21222D6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLQEGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:06:10 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38564 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLQEGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:06:10 -0500
Received: by mail-ua1-f66.google.com with SMTP id z17so2950295uac.5;
        Mon, 16 Dec 2019 20:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rZR4WxfTXLuZhywVifXRiInVzhtxjrgCpN59zPaZHeo=;
        b=rNjt5GfRgReG+Nc4mKj4f4clWHMEGLEyTlaDb3vm8H+bEgZFSfQJULvvQvcEhPexRi
         Sb5KCoWBgxYfxkIs5bol6e4zB/PUbZEk/J8TUTaVoumu/2/MFvLogX9WAcy/OdahYGrn
         XrpiGMDBCqyACGemUl0Jv/uYScu/X0sMgQmRRPopSOLBM4aQ5+qL+wLbsVtu7eSLzQKr
         EWN0axJGHB6o6LNpHTMrBTdjlzI+eKviRbYPhmHXbHkluabX2D7Gya03hjLh9i9V14jA
         fBBxVXA1CPBQXrPsAND2WJwc+K78roFdqYJnXfk/UyZHBsxPo4phdtdKLTjNZJbqt45d
         k8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rZR4WxfTXLuZhywVifXRiInVzhtxjrgCpN59zPaZHeo=;
        b=m2rFziPK9haDnSoc5S8VpvlgMINnwbShm6jiiqz/YP9H8FWuSbvn/Tn/rMlMH1z1Nr
         u/xyD6cpc8nBfYGnH6QvlHsDeA7eF6vPXiuhdcOmxGeybKuXvV6lCNklJpksiVIbBOFE
         Qp57OzT56ohu59/Ma2s6NaAWdU50/W0vLF2FCbiMUIhNb4SdaH9fZQNX3ZJwIg+8xMEh
         CnrpzKcKJ0DEqlUXrh1l70FFvGpAAtu3L+AbrCqMGas0ufrM+yTM+Q1tqKdWFO3IfexP
         ElPvIUBNXhhT3/dcU0PuSt6I0f1D+qV2VRhuGc5DyIyyq1/ahAdljC6zB5NrSqyBwU0q
         DvZw==
X-Gm-Message-State: APjAAAUKDrEMyt7pOgFeUUhmfkyhhvw4SdXny6uYsQn5uUSVCpufc64W
        LGUUz96jFLUgS944Y9ZEj1QPO+uYABV+qztxK4E=
X-Google-Smtp-Source: APXvYqxNoTQnB5p5K+Yx3oEfF3F/hDOhk/vV0pzSaGL83oQsOSkOB0y6/SVSt6bPfUiw22zNLD140zYjFxyDA3BrejY=
X-Received: by 2002:ab0:b12:: with SMTP id b18mr1883895uak.90.1576555568966;
 Mon, 16 Dec 2019 20:06:08 -0800 (PST)
MIME-Version: 1.0
References: <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
 <cover.1576381511.git.ethercflow@gmail.com> <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
 <CAJN39ohooPboU_ydys8rPbfwCEZabw3bLBGBnfz2EmJ6P8PGmg@mail.gmail.com>
In-Reply-To: <CAJN39ohooPboU_ydys8rPbfwCEZabw3bLBGBnfz2EmJ6P8PGmg@mail.gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Tue, 17 Dec 2019 12:05:58 +0800
Message-ID: <CABtjQmYNx8NNkTLf87tX+CpsDaAf3APEcTSqfX0kRbAsFECVfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
To:     Brendan Gregg <bgregg@netflix.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I just realized that among my tools that want the path, the input is eith=
er:

> A) syscall tracepoints: int fd
> B) kprobes: struct file *

> This serves (A). If we ever add a different helper for (B), we might
> think that this helper was misnamed. Should it be called get_fd_path
> instead? That leaves get_file_path available for a later "struct file
> *" -> pathname helper.

+1, I'll rename it in the next version.

Brendan Gregg <bgregg@netflix.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8817=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=886:09=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Dec 14, 2019 at 8:01 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
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
> > v11->v12: addressed Alexei's feedback
> > - only allow tracepoints to make sure it won't dead lock
> >
> > v10->v11: addressed Al and Alexei's feedback
> > - fix missing fput()
> >
> > v9->v10: addressed Andrii's feedback
> > - send this patch together with the patch selftests as one patch series
> >
> > v8->v9:
> > - format helper description
> >
> > v7->v8: addressed Alexei's feedback
> > - use fget_raw instead of fdget_raw, as fdget_raw is only used inside f=
s/
> > - ensure we're in user context which is safe fot the help to run
> > - filter unmountable pseudo filesystem, because they don't have real pa=
th
> > - supplement the description of this helper function
> >
> > v6->v7:
> > - fix missing signed-off-by line
> >
> > v5->v6: addressed Andrii's feedback
> > - avoid unnecessary goto end by having two explicit returns
> >
> > v4->v5: addressed Andrii and Daniel's feedback
> > - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> > helper's names
> > - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> > - remove fdput from fdget_raw's error path
> > - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointe=
r
> > into the buffer or an error code if the path was too long
> > - modify the normal path's return value to return copied string length
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
> >
> > Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> > ---
> >  include/uapi/linux/bpf.h       | 29 +++++++++++++-
> >  kernel/trace/bpf_trace.c       | 70 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 29 +++++++++++++-
> >  3 files changed, 126 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index dbbcf0b02970..71d9705df120 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >   *     Return
> >   *             On success, the strictly positive length of the string,=
 including
> >   *             the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_file_path(char *path, u32 size, int fd)
> > + *     Description
> > + *             Get **file** atrribute from the current task by *fd*, t=
hen call
> > + *             **d_path** to get it's absolute path and copy it as str=
ing into
> > + *             *path* of *size*. Notice the **path** don't support unm=
ountable
> > + *             pseudo filesystems as they don't have path (eg: SOCKFS,=
 PIPEFS).
> > + *             The *size* must be strictly positive. On success, the h=
elper
> > + *             makes sure that the *path* is NUL-terminated, and the b=
uffer
> > + *             could be:
> > + *             - a regular full path (include mountable fs eg: /proc, =
/sys)
> > + *             - a regular full path with "(deleted)" at the end.
> > + *             On failure, it is filled with zeroes.
> > + *     Return
> > + *             On success, returns the length of the copied string INC=
LUDING
> > + *             the trailing NUL.
> > + *
> > + *             On failure, the returned value is one of the following:
> > + *
> > + *             **-EPERM** if no permission to get the path (eg: in irq=
 ctx).
> > + *
> > + *             **-EBADF** if *fd* is invalid.
> > + *
> > + *             **-EINVAL** if *fd* corresponds to a unmountable pseudo=
 fs
> > + *
> > + *             **-ENAMETOOLONG** if full path is longer than *size*
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -2938,7 +2964,8 @@ union bpf_attr {
> >         FN(probe_read_user),            \
> >         FN(probe_read_kernel),          \
> >         FN(probe_read_user_str),        \
> > -       FN(probe_read_kernel_str),
> > +       FN(probe_read_kernel_str),      \
> > +       FN(get_file_path),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index e5ef4ae9edb5..db9c0ec46a5d 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -762,6 +762,72 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >         .arg1_type      =3D ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> > +{
> > +       struct file *f;
> > +       char *p;
> > +       int ret =3D -EBADF;
> > +
> > +       /* Ensure we're in user context which is safe for the helper to
> > +        * run. This helper has no business in a kthread.
> > +        */
> > +       if (unlikely(in_interrupt() ||
> > +                    current->flags & (PF_KTHREAD | PF_EXITING))) {
> > +               ret =3D -EPERM;
> > +               goto error;
> > +       }
> > +
> > +       /* Use fget_raw instead of fget to support O_PATH, and it doesn=
't
> > +        * have any sleepable code, so it's ok to be here.
> > +        */
> > +       f =3D fget_raw(fd);
> > +       if (!f)
> > +               goto error;
> > +
> > +       /* For unmountable pseudo filesystem, it seems to have no meani=
ng
> > +        * to get their fake paths as they don't have path, and to be n=
o
> > +        * way to validate this function pointer can be always safe to =
call
> > +        * in the current context.
> > +        */
> > +       if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) =
{
> > +               ret =3D -EINVAL;
> > +               fput(f);
> > +               goto error;
> > +       }
> > +
> > +       /* After filter unmountable pseudo filesytem, d_path won't call
> > +        * dentry->d_op->d_name(), the normally path doesn't have any
> > +        * sleepable code, and despite it uses the current macro to get
> > +        * fs_struct (current->fs), we've already ensured we're in user
> > +        * context, so it's ok to be here.
> > +        */
> > +       p =3D d_path(&f->f_path, dst, size);
> > +       if (IS_ERR(p)) {
> > +               ret =3D PTR_ERR(p);
> > +               fput(f);
> > +               goto error;
> > +       }
> > +
> > +       ret =3D strlen(p);
> > +       memmove(dst, p, ret);
> > +       dst[ret++] =3D '\0';
> > +       fput(f);
> > +       return ret;
> > +
> > +error:
> > +       memset(dst, '0', size);
> > +       return ret;
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
> > @@ -953,6 +1019,8 @@ tp_prog_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
> >                 return &bpf_get_stackid_proto_tp;
> >         case BPF_FUNC_get_stack:
> >                 return &bpf_get_stack_proto_tp;
> > +       case BPF_FUNC_get_file_path:
> > +               return &bpf_get_file_path_proto;
> >         default:
> >                 return tracing_func_proto(func_id, prog);
> >         }
> > @@ -1146,6 +1214,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
> >                 return &bpf_get_stackid_proto_raw_tp;
> >         case BPF_FUNC_get_stack:
> >                 return &bpf_get_stack_proto_raw_tp;
> > +       case BPF_FUNC_get_file_path:
> > +               return &bpf_get_file_path_proto;
> >         default:
> >                 return tracing_func_proto(func_id, prog);
> >         }
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index dbbcf0b02970..71d9705df120 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >   *     Return
> >   *             On success, the strictly positive length of the string,=
 including
> >   *             the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_file_path(char *path, u32 size, int fd)
> > + *     Description
> > + *             Get **file** atrribute from the current task by *fd*, t=
hen call
> > + *             **d_path** to get it's absolute path and copy it as str=
ing into
> > + *             *path* of *size*. Notice the **path** don't support unm=
ountable
> > + *             pseudo filesystems as they don't have path (eg: SOCKFS,=
 PIPEFS).
> > + *             The *size* must be strictly positive. On success, the h=
elper
> > + *             makes sure that the *path* is NUL-terminated, and the b=
uffer
> > + *             could be:
> > + *             - a regular full path (include mountable fs eg: /proc, =
/sys)
> > + *             - a regular full path with "(deleted)" at the end.
> > + *             On failure, it is filled with zeroes.
> > + *     Return
> > + *             On success, returns the length of the copied string INC=
LUDING
> > + *             the trailing NUL.
> > + *
> > + *             On failure, the returned value is one of the following:
> > + *
> > + *             **-EPERM** if no permission to get the path (eg: in irq=
 ctx).
> > + *
> > + *             **-EBADF** if *fd* is invalid.
> > + *
> > + *             **-EINVAL** if *fd* corresponds to a unmountable pseudo=
 fs
> > + *
> > + *             **-ENAMETOOLONG** if full path is longer than *size*
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -2938,7 +2964,8 @@ union bpf_attr {
> >         FN(probe_read_user),            \
> >         FN(probe_read_kernel),          \
> >         FN(probe_read_user_str),        \
> > -       FN(probe_read_kernel_str),
> > +       FN(probe_read_kernel_str),      \
> > +       FN(get_file_path),
>
>
> I just realized that among my tools that want the path, the input is eith=
er:
>
> A) syscall tracepoints: int fd
> B) kprobes: struct file *
>
> This serves (A). If we ever add a different helper for (B), we might
> think that this helper was misnamed. Should it be called get_fd_path
> instead? That leaves get_file_path available for a later "struct file
> *" -> pathname helper.
>
> Brendan
>
> --
> Brendan Gregg, Senior Performance Architect, Netflix
