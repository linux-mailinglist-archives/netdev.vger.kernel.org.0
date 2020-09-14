Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057B026999A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgINXWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgINXWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:22:48 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B418FC06174A;
        Mon, 14 Sep 2020 16:22:48 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h20so1099406ybj.8;
        Mon, 14 Sep 2020 16:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqTMyDcwN1HJrkAmczkyD8eFiA4Y3iPz3/YyZ7QCWHQ=;
        b=WJ161TP65bpy7j1qbYEYgXKnrv0BD8faWnJz6Nj+CW70nivgHGIsITvFCODrVpWfqi
         H5b0o3kKGmXi7ShL3qNIgHjM+PiVenagZ2qO5KraD0hRG8KoXJmSG60fCimtnMI1q6o9
         lXCVltnff3tjoGZ2/xTRUErQdw0CrzjVdvCt+froRm77TXFgKgkfHOHtUUvPgzz0bRRV
         VzVcKLTRfj/o/ONarnb7Bflc+XFe1anERghso6uU3v0+7io4t3Kz251/LbpM4lkAf7Q5
         lds7taXGIZ03JadPzEXi2bA7MfMlo5Pc8+0uGJJ+DgBfMA3S0/sTb9DmjF82u5MCnNyR
         tw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqTMyDcwN1HJrkAmczkyD8eFiA4Y3iPz3/YyZ7QCWHQ=;
        b=GWj7tlHKztBWXs9Fsd4LGqGLQJa6X2iMtl/qbckq91y7+cGsV9cQ9vEgRJi88qPdHA
         bwPfWms0VWGggh7wzXOAhCQz6JKLL4J+BcX+BScOjQLbcohA5AARwMf7s1gGCIAksOGD
         Udxt6nVBWhV2za6ETEqnLxG1eIrHgdls3kH/IBf9n8NARD5VOYv/dbcQJT8WurBLnlDS
         lHJPXZDR/RBheedYbsfaJtCnjiWSpkDDs4CgK+esgGn7+ANlCeMLLJOZN7w1L48Yj6VD
         DbXS2zcHAN+Rpk5jiwIATn/uqlufukWVsYEqcfTCoYNGzmLdMJpqBmdMYxRVrTGS0N96
         KJdw==
X-Gm-Message-State: AOAM532MIKUH0FyH92yQmc8iICQRqtXZdMLjeWy4l7oWzeZ/njlX3C7A
        mlxs9NxfQ8VS1Pt6XanaL+qMWTKaMK8qrLAqLKg=
X-Google-Smtp-Source: ABdhPJwY6oJzsg/GbnuU8GX78r9YNxbtGOkcu20182SVFiVbWCj0sMdsJyVCdAY3UHpx0ODKwZzjGiSH8Y/ED4rhlH8=
X-Received: by 2002:a25:e655:: with SMTP id d82mr25267621ybh.347.1600125768071;
 Mon, 14 Sep 2020 16:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com> <20200914183615.2038347-4-sdf@google.com>
In-Reply-To: <20200914183615.2038347-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 16:22:37 -0700
Message-ID: <CAEf4BzZRwNXZfpkv-D5b65eBA1QLLnpRmW7d=fVGazXS9th46Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .rodata section
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:37 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> When the libbpf tries to load a program, it will probe the kernel for
> the support of this syscall and unconditionally bind .rodata section
> to the program.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf.c      | 16 +++++++++
>  tools/lib/bpf/bpf.h      |  8 +++++
>  tools/lib/bpf/libbpf.c   | 72 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 97 insertions(+)
>

[...]
