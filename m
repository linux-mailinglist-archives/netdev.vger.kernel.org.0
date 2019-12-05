Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68244113E7E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 10:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfLEJru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 04:47:50 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:37978 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728604AbfLEJru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 04:47:50 -0500
Received: by mail-vk1-f194.google.com with SMTP id m128so898865vkb.5;
        Thu, 05 Dec 2019 01:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lrwnfiVVF6lFAzyrr0Hoi20YAxWZoj4rPySupLreSEI=;
        b=lvjagJDB3LySDjqV11cZQCfd54L0h4d/oqLUfhq8wLKZzkFeYoGF/weGw8jpbDCjiQ
         vq9TGxBv0rVf6e5C6F4x/6a7ybt4bRxGWRJPSqHCbCVwoNAhx+yNd/dXznuELltFEuyh
         1VcYKTbuUY2XE/GeGETLaLqa/8Ow4nzZ1bdpY3J3l/LvIA7KTwmrit85CZRJfSrDD8Oe
         qjG+XzSATTlh8IxOJURRiyJLFR8rj4rWzf0ZelfL+X4HtEKOrRb2CbqaPejXLCBWQ56t
         oCiTj8xdzP/03sYXaNyt4nl6Q34ZiPH4ffhYvpHR62a7VO1lzXdEZAEDi226luAkQwng
         +oLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lrwnfiVVF6lFAzyrr0Hoi20YAxWZoj4rPySupLreSEI=;
        b=JOU3id1Oqvegm0SLZHSJFlauvmbkO3GYYM7oFU69ZQ7HeWDeUKWXQfq5tfcnNkondR
         rjkoXtyGqpgLEz+9wX/uhAHZFsbG5sJTVlOuNl6W62csPzVXaEK/vAg+J7CF4FLWqS+6
         J3znW1XbKaRl8dEkv0qjExEiX0hZXK7S0C2/FrQXGvISgR6CJBim9R/6Zx8pEY5PiNzf
         64Ysf+pt5QkxNxXXJ7GAnpvxX646qZmtE3T1nnIinCoc7fqDcOj1WPK6+vRO8oxacsdd
         Wqy+SOju0glW5fshuLiSlw9ShrlnbaGub6Ovk7FasJu1ykhitfWayH6PkBmAjYn4WYaA
         t5Iw==
X-Gm-Message-State: APjAAAVH23NnQhB3lYrLdOg+FK68Bq6Ymhqngl6Lb43TqnU5iEoAuK3M
        fAfmNwPoEVvHcVHeXQuLwZ3eF6JYe3VEK8hf3dc=
X-Google-Smtp-Source: APXvYqyz3F7oUWnHlWhlZ7hFtfuJ8CDIrmB3FlT0xyrs5Gb/Lb5kILGymolkpHCo9IWDLJnMqMcDsbn5kMw69mPCZIo=
X-Received: by 2002:a1f:3dd0:: with SMTP id k199mr5779884vka.75.1575539268514;
 Thu, 05 Dec 2019 01:47:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575517685.git.ethercflow@gmail.com> <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
 <20191205071858.entnj2c27n44kwit@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191205071858.entnj2c27n44kwit@ast-mbp.dhcp.thefacebook.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Thu, 5 Dec 2019 17:47:36 +0800
Message-ID: <CABtjQmaWQNvmzH-rerm_gevtzKS-1jbD6HxjNU4xg3H5Wq3Q8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, ast@kernel.org,
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

> On Sat, Nov 23, 2019 at 05:35:14AM +0000, Al Viro wrote:
> > On Fri, Nov 22, 2019 at 09:19:21PM -0800, Alexei Starovoitov wrote:
> >
> > > hard to tell. It will be run out of bpf prog that attaches to kprobe =
or
> > > tracepoint. What is the concern about locking?
> > > d_path() doesn't take any locks and doesn't depend on any locks. Abov=
e 'if'
> > > checks that plain d_path() is used and not some specilized callback w=
ith
> > > unknown logic.
> >
> > It sure as hell does.  It might end up taking rename_lock and/or mount_=
lock
> > spinlock components.  It'll try not to, but if the first pass ends up w=
ith
> > seqlock mismatch, it will just grab the spinlock the second time around=
.

> ohh. got it. I missed _or_lock() part in there.
> The need_seqretry() logic is tricky. afaics there is no way for the check=
s
> outside of prepend_path() to prevent spin_lock to happen. And adding a fl=
ag to
> prepend_path() to return early if retry is needed is too ugly. So this he=
lper
> won't be safe to be run out of kprobe. But if we allow it for tracepoints=
 only
> it should be ok. I think. There are no tracepoints in inner guts of vfs a=
nd I
> don't think they will ever be. So running in tracepoint->bpf_prog->d_path=
 we
> will be sure that rename_lock+mount_lock can be safely spinlocked. Am I m=
issing
> something?

Hi Alexei,

Would you please give me an example of a deadlock condition under kprobe+bp=
f?
I'm not familiar with this detail and want to learn more.

> Above 'if's are not enough to make sure that it won't dead lock.
> Allowing it in tracing_func_proto() means that it's available to kprobe t=
oo.
> Hence deadlock is possible. Please see previous email thread.
> This helper is safe in tracepoint+bpf only.

So I should move it to `tp_prog_prog_func_proto` and `raw_tp_prog_func_prog=
`
right? Is raw tracepoint+bpf safe?

Thank you.

Alexei Starovoitov <alexei.starovoitov@gmail.com> =E4=BA=8E2019=E5=B9=B412=
=E6=9C=885=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=883:19=E5=86=99=E9=81=
=93=EF=BC=9A
>
> On Wed, Dec 04, 2019 at 11:20:35PM -0500, Wenbo Zhang wrote:
> >
> > +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> > +{
> > +     struct file *f;
> > +     char *p;
> > +     int ret =3D -EBADF;
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
>
> Above 'if's are not enough to make sure that it won't dead lock.
> Allowing it in tracing_func_proto() means that it's available to kprobe t=
oo.
> Hence deadlock is possible. Please see previous email thread.
> This helper is safe in tracepoint+bpf only.
>
