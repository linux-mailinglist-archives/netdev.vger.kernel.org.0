Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0833043DD11
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhJ1IqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhJ1IqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 04:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635410636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KccYG4rSdcXMoVRo53pQg4Ozdzh38yw0Q7oh7hWL/OA=;
        b=c45lKX9DXiQYwvolli/sIVzmoa4Mh18wfI7ot+bctXCtm5rhllu/pwV+MR6AcHOU4NMi/K
        G7LXOYvKXmGL5iO6Dp3iU0jo4+dT/cd3tW/SSeawnVv1/LDc9nEvMqeTWcM+D9tOh/cNX9
        9Wy1Ng8y1IEdePIvo9Z3fjLZQrLo9vE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-mf5U1EumNeOPOOd19Nsupw-1; Thu, 28 Oct 2021 04:43:54 -0400
X-MC-Unique: mf5U1EumNeOPOOd19Nsupw-1
Received: by mail-qk1-f197.google.com with SMTP id s20-20020a05620a0bd400b0045e893f2ed8so3427566qki.11
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 01:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KccYG4rSdcXMoVRo53pQg4Ozdzh38yw0Q7oh7hWL/OA=;
        b=4CElseWSNWuULFgHciVb/e5qAtaB5AloRz6/QAbaVKbqvEYJ9LIm6Lh9iDSb0fLdoM
         yYJoyjdU3WYjrf31t2d2f9vqgfMR++sKqd/jdyis8HVTBrruOAOg/OKm7yPWrTQdgp8t
         Dkbb8Agj1tuBYzkLQIs1pInFGJnaSf4Y4aYsgdGf+eXrEMtY4BQgkrslnS3jGVSXevZc
         CJg0+rWe8qkj0pA0HTFlGQmGqOUynt81R4iZaX0txUoTjt0TO/xE8Ol2XGu79uTzCR5n
         ypTjEod/oclphlQThE1HuIgQMaCxBsmfyyKc9rGWdmpjPX6iqMoTQJQKnmQmzyT5erU0
         UTAg==
X-Gm-Message-State: AOAM532Fy0LhzU2CLBYBWuNz5YKs0K45oFJWA3Zr7a8hbhAU1jDXc2qC
        a27Xf5b2zyLJuS3p0d8iMNpgOgpX8vbgdyAsjaI/ZUdyTYpNTMht7tHVAzWIgIQT63WIAqP94IE
        JgaljK9qi20F/AGCz+YD6m4g2XpCUOTq3
X-Received: by 2002:a05:620a:15f3:: with SMTP id p19mr2422633qkm.337.1635410634143;
        Thu, 28 Oct 2021 01:43:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzArBk6z7YGdByxd/X+igic/KcScZxC371ErWZ5REyS2JhtSA3Npou6sTwbdZL/ZSDM/1i2lyGhR3evMJPw0lI=
X-Received: by 2002:a05:620a:15f3:: with SMTP id p19mr2422618qkm.337.1635410633974;
 Thu, 28 Oct 2021 01:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211021151528.116818-1-lmb@cloudflare.com> <20211021151528.116818-2-lmb@cloudflare.com>
 <b215bb8c-3ffd-2b43-44a3-5b25243db5be@iogearbox.net>
In-Reply-To: <b215bb8c-3ffd-2b43-44a3-5b25243db5be@iogearbox.net>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Thu, 28 Oct 2021 10:43:43 +0200
Message-ID: <CAOssrKciL5EDhrbQe1mkOrtD1gwkrEBRQyQmVhRE8Z-Kjb0WGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] libfs: support RENAME_EXCHANGE in simple_rename()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 1:46 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> [ Adding Miklos & Greg to Cc for review given e0e0be8a8355 ("libfs: support RENAME_NOREPLACE in
>    simple_rename()"). If you have a chance, would be great if you could take a look, thanks! ]
>
> On 10/21/21 5:15 PM, Lorenz Bauer wrote:
> > Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
> > This affects binderfs, ramfs, hubetlbfs and bpffs. There isn't much
> > to do except update the various *time fields.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >   fs/libfs.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/libfs.c b/fs/libfs.c
> > index 51b4de3b3447..93c03d593749 100644
> > --- a/fs/libfs.c
> > +++ b/fs/libfs.c
> > @@ -455,9 +455,12 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
> >       struct inode *inode = d_inode(old_dentry);
> >       int they_are_dirs = d_is_dir(old_dentry);
> >
> > -     if (flags & ~RENAME_NOREPLACE)
> > +     if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
> >               return -EINVAL;
> >
> > +     if (flags & RENAME_EXCHANGE)
> > +             goto done;
> > +

This is not sufficient.   RENAME_EXCHANGE can swap a dir and a
non-dir, in which case the parent nlink counters need to be fixed up.

See shmem_exchange().   My suggestion is to move that function to
libfs.c:simple_rename_exchange().

Thanks,
Miklos

