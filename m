Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3591273FD
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLTDfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:35:20 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:37599 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLTDfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:35:20 -0500
Received: by mail-ua1-f66.google.com with SMTP id f9so2771886ual.4;
        Thu, 19 Dec 2019 19:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dSZ86v0Mu1ySriVc9gqwkJvhT4GqAJeYYgDn+nDx/NA=;
        b=H4NQFwkCHtmaW+phBtsqIzhnck1uMVx9DDkJOTyGKg43KvlftZkke53DVW1GP7Xj0q
         bDjrPwAGE86+FZCVLnWEsK/ka+G1Jlp8awL8Ib9ortQL4yqvMXQp4meQYqicZGEqTLKW
         3of4D5AWypxlF0vfW9J5frXdwy1KHi2BQsH2+jG7nqjYGj8svoY7D04/GvjI9woRwHLM
         1Gu/5uTXJwhD3/aLmOxO0yTQ0vEm9DdayqdO+GiQ+7h6LmnUe0VmS9/hSNsD+KJYBnei
         2bIY0lmKLKmTOjJTZ7R+zvbhaHrtYUc5CXN9WfrA2ActbMBaCFgF/LNYG9rubPgeT4O9
         ck+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dSZ86v0Mu1ySriVc9gqwkJvhT4GqAJeYYgDn+nDx/NA=;
        b=AA7cI0thJQOOf9odLFA88c69uduHV5JGKASQy7qVnrDEqt+RnOHuWdVnMQA7dTs3yS
         8gF4WUcb3tS3CxF9s5szGk0c0uzCTERbTjiiRUzmOmhZMgqJaUr0XBlRQEcKur1czp3v
         z56RgFcM1CCFRlgVetkqwZiOVzQ/Bevp1q6KYq0bU+lIwdcOeSJB8LvkeL6f7aYJMuvM
         aGQcokRaa3AKwjfCuGHG3jzflkbaE4fAi3/Urnh1qphLy1EG5LEuy3FgzOhWf9QBujS7
         hSVeP0jCS/tDZRnlxbpqa7vY72V5zd32y1Mf/woOVcfxuxAr20VUX/Rwg9Eg7AZ5TSVa
         VeFA==
X-Gm-Message-State: APjAAAUDMNN8TOxkrcaqD5QV0EEk/2DeZyr43Do+Kb4iiUHsoI4/LbJ3
        5qk483xONGDkuIWHVRUBwLrytBJbLT93pCzaUOE=
X-Google-Smtp-Source: APXvYqwxvwhtLk6UJSd/n6V0ttt9NyuictxlLRY5TsrxURRLYsZ3fHONUCwNTo8rJnwc3Gh2ytrDswN/yrcpxIZ6T1g=
X-Received: by 2002:ab0:1006:: with SMTP id f6mr7973581uab.94.1576812918982;
 Thu, 19 Dec 2019 19:35:18 -0800 (PST)
MIME-Version: 1.0
References: <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <cover.1576629200.git.ethercflow@gmail.com> <7464919bd9c15f2496ca29dceb6a4048b3199774.1576629200.git.ethercflow@gmail.com>
 <51564b9e-35f0-3c73-1701-8e351f2482d7@iogearbox.net>
In-Reply-To: <51564b9e-35f0-3c73-1701-8e351f2482d7@iogearbox.net>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Fri, 20 Dec 2019 11:35:08 +0800
Message-ID: <CABtjQmbh080cFr9e_V_vutb1fErRcCvw-bNNYeJHOcah-adFCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v14 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Brendan Gregg <bgregg@netflix.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [ Wenbo, please keep also Al (added here) in the loop since he was provid=
ing
>    feedback on prior submissions as well wrt vfs bits. ]

Get it, thank you!

Daniel Borkmann <daniel@iogearbox.net> =E4=BA=8E2019=E5=B9=B412=E6=9C=8820=
=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=8812:14=E5=86=99=E9=81=93=EF=BC=
=9A
>
> [ Wenbo, please keep also Al (added here) in the loop since he was provid=
ing
>    feedback on prior submissions as well wrt vfs bits. ]
>
> On 12/18/19 1:56 AM, Wenbo Zhang wrote:
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported=
.
> >
> > This requirement is mainly discussed here:
> >
> >    https://github.com/iovisor/bcc/issues/237
> >
> > v13->v14: addressed Yonghong and Daniel's feedback
> > - fix this helper's description to be consistent with comments in d_pat=
h
> > - fix error handling logic fill zeroes not '0's
> >
> > v12->v13: addressed Brendan and Yonghong's feedback
> > - rename to get_fd_path
> > - refactor code & comment to be clearer and more compliant
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
> >   include/uapi/linux/bpf.h       | 29 +++++++++++++-
> >   kernel/trace/bpf_trace.c       | 69 +++++++++++++++++++++++++++++++++=
+
> >   tools/include/uapi/linux/bpf.h | 29 +++++++++++++-
> >   3 files changed, 125 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index dbbcf0b02970..4534ce49f838 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >    *  Return
> >    *          On success, the strictly positive length of the string, i=
ncluding
> >    *          the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_fd_path(char *path, u32 size, int fd)
> > + *   Description
> > + *           Get **file** atrribute from the current task by *fd*, the=
n call
> > + *           **d_path** to get it's absolute path and copy it as strin=
g into
> > + *           *path* of *size*. Notice the **path** don't support unmou=
ntable
> > + *           pseudo filesystems as they don't have path (eg: SOCKFS, P=
IPEFS).
> > + *           The *size* must be strictly positive. On success, the hel=
per
> > + *           makes sure that the *path* is NUL-terminated, and the buf=
fer
> > + *           could be:
> > + *           - a regular full path (include mountable fs eg: /proc, /s=
ys)
> > + *           - a regular full path with " (deleted)" is appended.
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing '\0'.
> > + *
> > + *           On failure, the returned value is one of the following:
> > + *
> > + *           **-EPERM** if no permission to get the path (eg: in irq c=
tx).
> > + *
> > + *           **-EBADF** if *fd* is invalid.
> > + *
> > + *           **-EINVAL** if *fd* corresponds to a unmountable pseudo f=
s
> > + *
> > + *           **-ENAMETOOLONG** if full path is longer than *size*
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)               \
> >       FN(unspec),                     \
> > @@ -2938,7 +2964,8 @@ union bpf_attr {
> >       FN(probe_read_user),            \
> >       FN(probe_read_kernel),          \
> >       FN(probe_read_user_str),        \
> > -     FN(probe_read_kernel_str),
> > +     FN(probe_read_kernel_str),      \
> > +     FN(get_fd_path),
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >    * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index e5ef4ae9edb5..a2c18b193141 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -762,6 +762,71 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >       .arg1_type      =3D ARG_ANYTHING,
> >   };
> >
> > +BPF_CALL_3(bpf_get_fd_path, char *, dst, u32, size, int, fd)
> > +{
> > +     int ret =3D -EBADF;
> > +     struct file *f;
> > +     char *p;
> > +
> > +     /* Ensure we're in user context which is safe for the helper to
> > +      * run. This helper has no business in a kthread.
> > +      */
> > +     if (unlikely(in_interrupt() ||
> > +                  current->flags & (PF_KTHREAD | PF_EXITING))) {
> > +             ret =3D -EPERM;
> > +             goto error;
> > +     }
> > +
> > +     /* Use fget_raw instead of fget to support O_PATH, and it doesn't
> > +      * have any sleepable code, so it's ok to be here.
> > +      */
> > +     f =3D fget_raw(fd);
> > +     if (!f)
> > +             goto error;
> > +
> > +     /* For unmountable pseudo filesystem, it seems to have no meaning
> > +      * to get their fake paths as they don't have path, and to be no
> > +      * way to validate this function pointer can be always safe to ca=
ll
> > +      * in the current context.
> > +      */
> > +     if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
> > +             ret =3D -EINVAL;
> > +             fput(f);
> > +             goto error;
> > +     }
> > +
> > +     /* After filter unmountable pseudo filesytem, d_path won't call
> > +      * dentry->d_op->d_name(), the normally path doesn't have any
> > +      * sleepable code, and despite it uses the current macro to get
> > +      * fs_struct (current->fs), we've already ensured we're in user
> > +      * context, so it's ok to be here.
> > +      */
> > +     p =3D d_path(&f->f_path, dst, size);
> > +     if (IS_ERR(p)) {
> > +             ret =3D PTR_ERR(p);
> > +             fput(f);
> > +             goto error;
> > +     }
> > +
> > +     ret =3D strlen(p) + 1;
> > +     memmove(dst, p, ret);
> > +     fput(f);
> > +     return ret;
> > +
> > +error:
> > +     memset(dst, 0, size);
> > +     return ret;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_fd_path_proto =3D {
> > +     .func       =3D bpf_get_fd_path,
> > +     .gpl_only   =3D true,
> > +     .ret_type   =3D RET_INTEGER,
> > +     .arg1_type  =3D ARG_PTR_TO_UNINIT_MEM,
> > +     .arg2_type  =3D ARG_CONST_SIZE,
> > +     .arg3_type  =3D ARG_ANYTHING,
> > +};
> > +
> >   static const struct bpf_func_proto *
> >   tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *p=
rog)
> >   {
> > @@ -953,6 +1018,8 @@ tp_prog_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
> >               return &bpf_get_stackid_proto_tp;
> >       case BPF_FUNC_get_stack:
> >               return &bpf_get_stack_proto_tp;
> > +     case BPF_FUNC_get_fd_path:
> > +             return &bpf_get_fd_path_proto;
> >       default:
> >               return tracing_func_proto(func_id, prog);
> >       }
> > @@ -1146,6 +1213,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
> >               return &bpf_get_stackid_proto_raw_tp;
> >       case BPF_FUNC_get_stack:
> >               return &bpf_get_stack_proto_raw_tp;
> > +     case BPF_FUNC_get_fd_path:
> > +             return &bpf_get_fd_path_proto;
> >       default:
> >               return tracing_func_proto(func_id, prog);
> >       }
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index dbbcf0b02970..4534ce49f838 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >    *  Return
> >    *          On success, the strictly positive length of the string, i=
ncluding
> >    *          the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_fd_path(char *path, u32 size, int fd)
> > + *   Description
> > + *           Get **file** atrribute from the current task by *fd*, the=
n call
> > + *           **d_path** to get it's absolute path and copy it as strin=
g into
> > + *           *path* of *size*. Notice the **path** don't support unmou=
ntable
> > + *           pseudo filesystems as they don't have path (eg: SOCKFS, P=
IPEFS).
> > + *           The *size* must be strictly positive. On success, the hel=
per
> > + *           makes sure that the *path* is NUL-terminated, and the buf=
fer
> > + *           could be:
> > + *           - a regular full path (include mountable fs eg: /proc, /s=
ys)
> > + *           - a regular full path with " (deleted)" is appended.
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing '\0'.
> > + *
> > + *           On failure, the returned value is one of the following:
> > + *
> > + *           **-EPERM** if no permission to get the path (eg: in irq c=
tx).
> > + *
> > + *           **-EBADF** if *fd* is invalid.
> > + *
> > + *           **-EINVAL** if *fd* corresponds to a unmountable pseudo f=
s
> > + *
> > + *           **-ENAMETOOLONG** if full path is longer than *size*
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)               \
> >       FN(unspec),                     \
> > @@ -2938,7 +2964,8 @@ union bpf_attr {
> >       FN(probe_read_user),            \
> >       FN(probe_read_kernel),          \
> >       FN(probe_read_user_str),        \
> > -     FN(probe_read_kernel_str),
> > +     FN(probe_read_kernel_str),      \
> > +     FN(get_fd_path),
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >    * function eBPF program intends to call
> >
>
