Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E624927A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHSBj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:39:26 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0678FC061389;
        Tue, 18 Aug 2020 18:39:25 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a34so12432317ybj.9;
        Tue, 18 Aug 2020 18:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gUq2e4CgBr1fHk/2rAJErzEp3SApcCE9FrdZ5LYKV+0=;
        b=rA5owWm5D7deAhf/XCoqQzx5Bqv9AhKuWqGJthnKSIoEEGeCO831HLIOhepxKAT045
         d2rlpx5AY0rQ51vPV8Wb/Vk204fQqOMxTQcjFiMvzBTqQ/cTSFTljR51RB1FdxjxMyu2
         Vq0VpigME8Gv7JeleoOYI4xWB4rr8xXSUhwFHAfJJEXO+Ftef2ekv8aOj9Lp0wOpG8pJ
         NP/h8spERhXY0xfA3mIgiAegenvlhuobVycUEaolIhT84kcwWKfcJgB1UwkT5wzyP9N/
         a0FG19r82IZ7Y7FWNuEhcSLuv/2T9l/ilN/DD9R9VY7/7w0j0ZboAlSJkaNSpTch0Zyz
         G2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gUq2e4CgBr1fHk/2rAJErzEp3SApcCE9FrdZ5LYKV+0=;
        b=Ngcv8RLMK5RMd3FwPINWN/JiAERDhcobXKCQwJ0SFYEekjA9rXZWlEIwdGXCRWxp8p
         /Pck+ZpvEhagAMO6CkNkPSUr5ChsPyt5RYqH5WkBzexZh+FO3nT7b+PgAugdUosZFnl9
         oZlmvuSzfukE7GlXsMBT8WPgtbTrfH37F7QyyX3Db8pT6/3xksFlktj19njbLOh7wH5t
         cyxQtgyxhGX2dge+3AGZ/v+6VLpJmvmAL6S1e0AUUnfn3ybVIQZszivngL1RI4o7C98n
         aV40p77HYxRxqTe91ImD0kwCQq/LukYUvsTRQX2+ff/sAaBWI+IRzTxlxZHSOt7pO1Wg
         74Zg==
X-Gm-Message-State: AOAM531QxugKIChQcASqKzkoYGbBKMTh6QnmyC9cSc+S6IR+G2Tevon4
        BDrnUruqIn/6fJIt6KXf7mh8HbwVfN5Bylm0vXM=
X-Google-Smtp-Source: ABdhPJx64lCgXZwo4aS3JVCif0ZoY4Vi+/iKIAEqi06W2K6AtKoZsvXtkhWMcArTt17KeSIBBOf9A8ACUsf2ycvcfkY=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr29779904ybe.510.1597801165267;
 Tue, 18 Aug 2020 18:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200818213356.2629020-1-andriin@fb.com> <20200818213356.2629020-2-andriin@fb.com>
 <b26b5c66-f335-2e47-bf6c-f557853ce2d7@fb.com>
In-Reply-To: <b26b5c66-f335-2e47-bf6c-f557853ce2d7@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 18:39:14 -0700
Message-ID: <CAEf4BzaTWVhymaGuSHHHL8+TCbP=qRFc+YvG+ZMYMNTEg-vA-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] libbpf: disable -Wswitch-enum compiler warning
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
> > That compilation warning is more annoying, than helpful.
>
> Curious which compiler and which version caused this issue?
> I did not hit with gcc 8.2 or latest clang in my environment.
>

Strange, I just tried on bpf-next, removed -Wno-switch-enum and got
tons of errors:

libbpf.c: In function =E2=80=98bpf_object__sanitize_prog=E2=80=99:
libbpf.c:5560:3: error: enumeration value =E2=80=98BPF_FUNC_unspec=E2=80=99=
 not
handled in switch [-Werror=3Dswitch-enum]
   switch (func_id) {
   ^~~~~~
libbpf.c:5560:3: error: enumeration value =E2=80=98BPF_FUNC_map_lookup_elem=
=E2=80=99
not handled in switch [-Werror=3Dswitch-enum]
libbpf.c:5560:3: error: enumeration value =E2=80=98BPF_FUNC_map_update_elem=
=E2=80=99
not handled in switch [-Werror=3Dswitch-enum]
... and many more ...

My compiler:

$ cc --version
cc (GCC) 8.2.1 20180801 (Red Hat 8.2.1-2)


> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index bf8ed134cb8a..95c946e94ca5 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -107,7 +107,7 @@ ifeq ($(feature-reallocarray), 0)
> >   endif
> >
> >   # Append required CFLAGS
> > -override CFLAGS +=3D $(EXTRA_WARNINGS)
> > +override CFLAGS +=3D $(EXTRA_WARNINGS) -Wno-switch-enum
> >   override CFLAGS +=3D -Werror -Wall
> >   override CFLAGS +=3D -fPIC
> >   override CFLAGS +=3D $(INCLUDES)
> >
