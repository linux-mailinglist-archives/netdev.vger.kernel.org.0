Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6A123B60
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLRALq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:11:46 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36605 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLRALq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:11:46 -0500
Received: by mail-vs1-f66.google.com with SMTP id u14so268892vsu.3;
        Tue, 17 Dec 2019 16:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VWM8CMVOeBatrfOgBjv+cpzRBfAT4uJ14z7HgHVWfw0=;
        b=U5Yw8w3uZIW5xU0Toxi2Vd6V6p3aC/zxVPQZX8xYN6bt0EKulTekGVvEU0rGtYiCqE
         QNqlkkpZEMWl1h+YdFMImpivxtG1UrPdnOOkc0UqupADLYZkaESAQukkKBYCE0eCmOMn
         zE4LtmXRLwAOteBnU+jJScWDzf27JHjhz8t+y1/oga95s3M9UTn/3ByMsf4vHX4w9CoY
         efyj/0o/0O94ai+g099ytTR9sy0jBH3QmJbJH2Ob6z8qjYqPIuR1r+g9NXHFjM5w3m+y
         hJ4WzbfnVCDpkaXaQ5pZs0CJImydg5pVL2A8cQrSRgj+HmtW3rdJN7lf+2niKE7y3yfR
         Yy/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VWM8CMVOeBatrfOgBjv+cpzRBfAT4uJ14z7HgHVWfw0=;
        b=kemsP3YYiOTjWihCTWwRIsBd+B/qvxuHzza9WPsJ14dfNGwYUIYEQCzRMUYYExpKP3
         pWb4D5cC9wYQJUpiTBQ6CqmfZM1J044R6j45OCJ0wbs/FU1loLUyM9QNIDXDV22wMHsC
         pQtvGbGP+MlmjdykFz+VIMaoLQdLOQ6DkdXF2OZ07I77Bitaw+a/u42ii4cbYKEhDS1j
         sQROKxMrrkhyn9weC6yOT4eYwyOdSo2+I8ioh3Iz0YgnnIQuB0rGXNkktVpxKOrsKd5n
         7WZEFkbOgiNfCOWIrVrR/NhlRqW/jaHzpUvJqGw6dQ5aKTCZatZZ/V9rmSQdLCkAt85y
         g5Wg==
X-Gm-Message-State: APjAAAX5HGA2mvxiGt/UE7dtMeMOc2ZpnZG+Se20c6krpDEfc3fkKptc
        LCIEL0Lb0LK4yQqawJ6XlCtBAIB9vHjmVVFeOzc=
X-Google-Smtp-Source: APXvYqy60ySVdAZpYAil4uJAJEhmBQOaQpuj30YPduVL2wJYi9bS8/sA9HoNvjZ2CxUag6RpXWDSvkBw01Cq6NJpdhw=
X-Received: by 2002:a67:fa89:: with SMTP id f9mr4902652vsq.145.1576627905462;
 Tue, 17 Dec 2019 16:11:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576575253.git.ethercflow@gmail.com> <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <f54e3df6-626f-e9c4-f2c2-a63fb9953944@fb.com> <a8a763e2-65d2-7c71-e99d-ffae1523f0f0@iogearbox.net>
In-Reply-To: <a8a763e2-65d2-7c71-e99d-ffae1523f0f0@iogearbox.net>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Wed, 18 Dec 2019 08:11:34 +0800
Message-ID: <CABtjQmZW1AEFZcq1=EF61d9TSmSpBD0-0rzGUWS-azg=1m1cEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v13 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bgregg@netflix.com" <bgregg@netflix.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [...]
>>> + *          On failure, it is filled with zeroes.
> [...]
> You fill it with 0x30's ...

So sorry about this, I'll submit another revision to fix this. Thanks
again for your
preciseness and patience.

Daniel Borkmann <daniel@iogearbox.net> =E4=BA=8E2019=E5=B9=B412=E6=9C=8818=
=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=883:39=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On 12/17/19 5:29 PM, Yonghong Song wrote:
> > On 12/17/19 1:47 AM, Wenbo Zhang wrote:
> [...]
> >> + *          On failure, it is filled with zeroes.
> [...]
> >>     */
> >>    #define __BPF_FUNC_MAPPER(FN)             \
> >>      FN(unspec),                     \
> >> @@ -2938,7 +2964,8 @@ union bpf_attr {
> >>      FN(probe_read_user),            \
> >>      FN(probe_read_kernel),          \
> >>      FN(probe_read_user_str),        \
> >> -    FN(probe_read_kernel_str),
> >> +    FN(probe_read_kernel_str),      \
> >> +    FN(get_fd_path),
> >>
> >>    /* integer value in 'imm' field of BPF_CALL instruction selects whi=
ch helper
> >>     * function eBPF program intends to call
> >> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> >> index e5ef4ae9edb5..43a6aa6ad967 100644
> >> --- a/kernel/trace/bpf_trace.c
> >> +++ b/kernel/trace/bpf_trace.c
> >> @@ -762,6 +762,71 @@ static const struct bpf_func_proto bpf_send_signa=
l_proto =3D {
> >>      .arg1_type      =3D ARG_ANYTHING,
> >>    };
> >>
> >> +BPF_CALL_3(bpf_get_fd_path, char *, dst, u32, size, int, fd)
> >> +{
> >> +    int ret =3D -EBADF;
> >> +    struct file *f;
> >> +    char *p;
> >> +
> >> +    /* Ensure we're in user context which is safe for the helper to
> >> +     * run. This helper has no business in a kthread.
> >> +     */
> >> +    if (unlikely(in_interrupt() ||
> >> +                 current->flags & (PF_KTHREAD | PF_EXITING))) {
> >> +            ret =3D -EPERM;
> >> +            goto error;
> >> +    }
> >> +
> >> +    /* Use fget_raw instead of fget to support O_PATH, and it doesn't
> >> +     * have any sleepable code, so it's ok to be here.
> >> +     */
> >> +    f =3D fget_raw(fd);
> >> +    if (!f)
> >> +            goto error;
> >> +
> >> +    /* For unmountable pseudo filesystem, it seems to have no meaning
> >> +     * to get their fake paths as they don't have path, and to be no
> >> +     * way to validate this function pointer can be always safe to ca=
ll
> >> +     * in the current context.
> >> +     */
> >> +    if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
> >> +            ret =3D -EINVAL;
> >> +            fput(f);
> >> +            goto error;
> >> +    }
> >> +
> >> +    /* After filter unmountable pseudo filesytem, d_path won't call
> >> +     * dentry->d_op->d_name(), the normally path doesn't have any
> >> +     * sleepable code, and despite it uses the current macro to get
> >> +     * fs_struct (current->fs), we've already ensured we're in user
> >> +     * context, so it's ok to be here.
> >> +     */
> >> +    p =3D d_path(&f->f_path, dst, size);
> >> +    if (IS_ERR(p)) {
> >> +            ret =3D PTR_ERR(p);
> >> +            fput(f);
> >> +            goto error;
> >> +    }
> >> +
> >> +    ret =3D strlen(p) + 1;
> >> +    memmove(dst, p, ret);
> >> +    fput(f);
> >> +    return ret;
> >> +
> >> +error:
> >> +    memset(dst, '0', size);
>
> You fill it with 0x30's ...
>
> >> +    return ret;
> >> +}
