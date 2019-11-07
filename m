Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005B4F3689
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbfKGSC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:02:56 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:40184 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfKGSC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:02:56 -0500
Received: by mail-vk1-f193.google.com with SMTP id k24so808369vko.7;
        Thu, 07 Nov 2019 10:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A4Rn71KNo1Dh5p7LMbw37OQ9xbgmD7XKRKWGlT6uhV4=;
        b=h6Kn1YJPwnKnfNNJKlhkelLy6rzBCcooHXeB6CwcSjaydO20nIzGp3slJZKKz/hbUZ
         aRHfOoH+kL4ZanuX8d4SCBZluG6OfvKgiMwKwToQ911s/m9gVxHvk1T8GI14u2/vFkEY
         d/4A+Y3qpKX+4su1kcMpyI7d/2tQRERu1n1jR6ofkfw5yPpgkuIPBrGdemG0CDvYz+HP
         3P9MEglSaOT30y6iHbcprsK74F/ijqQdXsgC1NYkdTNhR7JX22hyybFVeDXL9V7/miED
         HiBJehNhoabE7uWJtDbdsT1aNHp3cWWfZtC3y2IREk5rIxsq35TrL6U0bhSyJskNMXXS
         tjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A4Rn71KNo1Dh5p7LMbw37OQ9xbgmD7XKRKWGlT6uhV4=;
        b=hML8LkHVj+PBMF7OAL7Y9lN/wJ0t+q3w8Im+xlSifjc1Pvv+ihmdgjoFrD2t/ckaMb
         s5xwnaydhdvNfrOXgsnWLWZbzJybL+TdAZii1nxOqneAJ6Cvl+SYff1s/DYn4ljRgYx2
         hxAP11ZzrbuOxTwiWiMyGgeR9sJD6ThlIr06end+PWh+ItuY81/rfGHD6BHGlz2r4j+z
         1ngDfAoQJsEYACZhdGuY3iVDYYL8I4wcGDHgxFrbZEa42sGsSHiMEVwynuPLTscl00Bn
         9xZkrpVvno3lMJcHW+ryqMuIlg3T+drLMzR85KSc2U8QUQRlseYpeetT5z48eSkhaYoF
         437g==
X-Gm-Message-State: APjAAAW1b2iwUrKovhDGZJ/RFlUAqyj325f29JBdg8wmGyMH/G+wSA+S
        L3ZpJq3kp2WCbsBy1SksmfcimLv7kg0PQT7tq4w=
X-Google-Smtp-Source: APXvYqzfDBMVH4GwGhG6MfUg+2DwbRtvIUkZLsn1ihY8SUoWC73rIWuGtJSH2LO+3frRW3kC6+Emc7NJ8hav5jT9qeI=
X-Received: by 2002:a1f:18ca:: with SMTP id 193mr3697416vky.66.1573149773923;
 Thu, 07 Nov 2019 10:02:53 -0800 (PST)
MIME-Version: 1.0
References: <20191103075417.36443-1-ethercflow@gmail.com> <20191105221951.lxlitdtl7frkyrmk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191105221951.lxlitdtl7frkyrmk@ast-mbp.dhcp.thefacebook.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Fri, 8 Nov 2019 02:02:42 +0800
Message-ID: <CABtjQmb_Pts45VwVtCbw-OoxCCGCNnCupuXPwPggBc0D4F0d2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7] bpf: add new helper get_file_path for mapping
 a file descriptor to a pathname
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - fdget_raw is only used inside fs/, so it doesn't look right to skip the=
 layers.

Sorry,  I mistakenly thought that as long as it is non-internel.h it
can be accessed externally.
Would you please give me more details about how to deal with this
situation or is there any
documents explain this? I hope to learn more then fix this.

> - accessing current->fs is not always correct, so the code should somehow
>  check that it's ok to do so, but I'm not sure if (in_irq()) would be eno=
ugh.

I'll check more about this these days, then determine the solution.

> - some implementations of d_dname do sleep.  For example: dmabuffs_dname.
>  Though it seems to me that it's a bug in that particular FS. But I'd lik=
e
>  to hear clear yes from VFS experts that fdget_raw() + d_path() is ok
>  from preempt_disabled section.
> The other alternative is to wait for sleepable and preemptible BPF progra=
ms to
> appear. Which is probably a month or so away. Then all these issues will
> disappear.

Sorry for didn't check the whole exist callback functions, gave an
imprecise conclusion.
I will do my best to learn more, I hope I can make better
contributions to bpf in the future.

> The other alternative is to wait for sleepable and preemptible BPF progra=
ms to
> appear. Which is probably a month or so away. Then all these issues will
> disappear.

I think wait for sleepable and preemptible BPF programs to appear is a
better way to compatible
with all kinds implementations of d_dname.

Thank you for providing these valuable suggestions and information.

Alexei Starovoitov <alexei.starovoitov@gmail.com> =E4=BA=8E2019=E5=B9=B411=
=E6=9C=886=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=886:19=E5=86=99=E9=81=
=93=EF=BC=9A
>
> On Sun, Nov 03, 2019 at 02:54:17AM -0500, Wenbo Zhang wrote:
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported=
.
> >
> > This requirement is mainly discussed here:
> >
> >   https://github.com/iovisor/bcc/issues/237
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
> >  include/uapi/linux/bpf.h       | 15 ++++++++++-
> >  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 15 ++++++++++-
> >  3 files changed, 76 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a6bf19dabaab..d618a914c6fe 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2777,6 +2777,18 @@ union bpf_attr {
> >   *           restricted to raw_tracepoint bpf programs.
> >   *   Return
> >   *           0 on success, or a negative error in case of failure.
> > + *
> > + * int bpf_get_file_path(char *path, u32 size, int fd)
> > + *   Description
> > + *           Get **file** atrribute from the current task by *fd*, the=
n call
> > + *           **d_path** to get it's absolute path and copy it as strin=
g into
> > + *           *path* of *size*. The **path** also support pseudo filesy=
stems
> > + *           (whether or not it can be mounted). The *size* must be st=
rictly
> > + *           positive. On success, the helper makes sure that the *pat=
h* is
> > + *           NUL-terminated. On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing NUL, or a negative error in case of failure.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)                \
> >       FN(unspec),                     \
> > @@ -2890,7 +2902,8 @@ union bpf_attr {
> >       FN(sk_storage_delete),          \
> >       FN(send_signal),                \
> >       FN(tcp_gen_syncookie),          \
> > -     FN(skb_output),
> > +     FN(skb_output),                 \
> > +     FN(get_file_path),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index f50bf19f7a05..41be1c5989af 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -683,6 +683,52 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >       .arg1_type      =3D ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> > +{
> > +     struct fd f;
> > +     char *p;
> > +     int ret =3D -EBADF;
> > +
> > +     /* Use fdget_raw instead of fdget to support O_PATH, and
> > +      * fdget_raw doesn't have any sleepable code, so it's ok
> > +      * to be here.
> > +      */
> > +     f =3D fdget_raw(fd);
> > +     if (!f.file)
> > +             goto error;
> > +
> > +     /* d_path doesn't have any sleepable code, so it's ok to
> > +      * be here. But it uses the current macro to get fs_struct
> > +      * (current->fs). So this helper shouldn't be called in
> > +      * interrupt context.
> > +      */
> > +     p =3D d_path(&f.file->f_path, dst, size);
> > +     if (IS_ERR(p)) {
> > +             ret =3D PTR_ERR(p);
> > +             fdput(f);
> > +             goto error;
> > +     }
>
> This is definitely very useful helper that bpf tracing community has
> been asking for long time, but I have few concerns with implementation:
> - fdget_raw is only used inside fs/, so it doesn't look right to skip the=
 layers.
> - accessing current->fs is not always correct, so the code should somehow
>   check that it's ok to do so, but I'm not sure if (in_irq()) would be en=
ough.
> - some implementations of d_dname do sleep.  For example: dmabuffs_dname.
>   Though it seems to me that it's a bug in that particular FS. But I'd li=
ke
>   to hear clear yes from VFS experts that fdget_raw() + d_path() is ok
>   from preempt_disabled section.
>
> The other alternative is to wait for sleepable and preemptible BPF progra=
ms to
> appear. Which is probably a month or so away. Then all these issues will
> disappear.
>
