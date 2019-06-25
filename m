Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93B05532F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfFYPTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:19:50 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34896 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbfFYPTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:19:49 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so16702465ljh.2;
        Tue, 25 Jun 2019 08:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yrN/5+nIk9S5vTMVxcvBLKV3zzehKDZFkyMuquWsH68=;
        b=S2bKsaLhKFOfEvS9Nl05a4NLWHGAZi7SsAJ3e9lFuzC77wlYf/07wx6SVRNPN056xC
         rI91bQ2cL6eTqkhDpVjk6AfDbs5yMuPoZ/wHG5a1YyS5rPNErFuz1E6hYeQiPKCLIYQy
         n0Du8a/WbIE/tU6mmh2vCwmOXIza5u9gdMtC+amXPu/nu9kWdj4iHayoO5fIZqR5oPvM
         qZ6yP1WjWWqULpKGb6MUWAJj7d+5QFuy2K+lCHkVLH/iQuq8CwCi1JetYY7vfi9aOj4b
         qJ+pYXmz23Z3DD07c7n5j/xsT02DJlyKtzu4StCu+e+ZuJhKAY3FJsCTJR5vAYfR/n6H
         PuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yrN/5+nIk9S5vTMVxcvBLKV3zzehKDZFkyMuquWsH68=;
        b=pfqfnwTdrWcnyY/E4OR+UeIAdZD5oK03J5lTKTZ8ABdJpnYyAQ2FexMs8O6gWbJBV0
         JLeeRzBtVfTWqMpqjYPGdk3dM44r58/MxG2dAR5SOEEG4XB7Avw4M3j7RessBE3DflHI
         lXAaJeIpDQMJUG6i8gGAx0QSOpwNoABrABjBt8DyuOiYZOCQQgPC6/RMs7W0ihvcG2sy
         WnbvN6+7bH5LKJ4mGodfDLzzLYWjOsmHy0wkyrH9/IKU55aVnnfSSy+pIqSmJFgGlw6x
         +0dFia0WWIunUK97+9v7jWvlc7PsEULy69TBx6CmTSpB6idX/n2BRGroBz40y3O2Rej8
         OKMQ==
X-Gm-Message-State: APjAAAUjyR1ntu5rvQ9WQbPBsB60g5i5r5ytPPaCEqy04+ZJ8C/R2/UZ
        yWLEWNwa97P2c74bFqtJJFsascFRZSlfka2ZAck=
X-Google-Smtp-Source: APXvYqzfMKg4ZO2wrQpg3S8XMaHhJqWEmlU38FuZYYbSRKWkwz+ztC+lsEWGkD1Hzi/yea7tiMjxyfLL5dtOyXMYFqA=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr64124534lje.214.1561475987379;
 Tue, 25 Jun 2019 08:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb2545a0cf151bc443efa10c16c5a4de6f2670.1561460681.git.baruch@tkos.co.il>
 <CAADnVQJ3MPVCL-0x2gDYbUQsrmu8WipnisqXoU8ja4vZ-5nTmA@mail.gmail.com> <20190625150835.GA24947@altlinux.org>
In-Reply-To: <20190625150835.GA24947@altlinux.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jun 2019 08:19:35 -0700
Message-ID: <CAADnVQJNLk7tAHRHr7V7ugvCX9iCjaH4_vS9YuNWcMpwnA6ZyA@mail.gmail.com>
Subject: Re: [PATCH v2] bpf: fix uapi bpf_prog_info fields alignment
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 8:08 AM Dmitry V. Levin <ldv@altlinux.org> wrote:
>
> On Tue, Jun 25, 2019 at 07:16:55AM -0700, Alexei Starovoitov wrote:
> > On Tue, Jun 25, 2019 at 4:07 AM Baruch Siach <baruch@tkos.co.il> wrote:
> > >
> > > Merge commit 1c8c5a9d38f60 ("Merge
> > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> > > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > > applications") by taking the gpl_compatible 1-bit field definition from
> > > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > > bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> > > like m68k. Embed gpl_compatible into an anonymous union with 32-bit pad
> > > member to restore alignment of following fields.
> > >
> > > Thanks to Dmitry V. Levin his analysis of this bug history.
> > >
> > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > > ---
> > > v2:
> > > Use anonymous union with pad to make it less likely to break again in
> > > the future.
> > > ---
> > >  include/uapi/linux/bpf.h       | 5 ++++-
> > >  tools/include/uapi/linux/bpf.h | 5 ++++-
> > >  2 files changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index a8b823c30b43..766eae02d7ae 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -3142,7 +3142,10 @@ struct bpf_prog_info {
> > >         __aligned_u64 map_ids;
> > >         char name[BPF_OBJ_NAME_LEN];
> > >         __u32 ifindex;
> > > -       __u32 gpl_compatible:1;
> > > +       union {
> > > +               __u32 gpl_compatible:1;
> > > +               __u32 pad;
> > > +       };
> >
> > Nack for the reasons explained in the previous thread
> > on the same subject.
> > Why cannot you go with earlier suggestion of _u32 :31; ?
>
> By the way, why not use aligned types as suggested by Geert?
> They are already used for other members of struct bpf_prog_info anyway.
>
> FWIW, we use aligned types for bpf in strace and that approach
> proved to be more robust than manual padding.

because __aligned_u64 is used for pointers.
