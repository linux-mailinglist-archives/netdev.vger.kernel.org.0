Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21E61C4600
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgEDScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729762AbgEDScW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:32:22 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0449C061A0E;
        Mon,  4 May 2020 11:32:20 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id s10so12213010iln.11;
        Mon, 04 May 2020 11:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fXXtRyYva1+Yap2sD+XkgWxfM99Zk9A+tbgnZl+uYVs=;
        b=SqDpVLrBzxV1r67aZX8RA7P1/Q2tnpVkR+mjTtj/YOveeWkmWjzR3ywxsH99cxXY3a
         wKAEDVoENPtuKAEHqmr347MMGFTqKrvWj6XdVeR5FvfdQwacxFAa97surP3OLXAqr1vk
         F6StOrd7PZPE1jFsTaS6nBIU6prZh1L++TJVmZbVDnHGDQDwhO3pRNXqa9MXJVDEVJv7
         ZVb6ep2nk49H7i0ppC5mQH2d1sx1Mr1fg2CiIV957HQmNJh94KkX56AbH8G+HgxytY24
         QjKBoO37+FEhSXRxdcPF22TTd1CDdYheZNJmBdSazmOqltD+wPkGeEEMDIyeubrFrdSf
         fONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fXXtRyYva1+Yap2sD+XkgWxfM99Zk9A+tbgnZl+uYVs=;
        b=K1KTmeCKA1gH9YzEvu+4CBBRHvZpLcGIiKXe6ipvccFhJAdx+MKB73xb5qLwLG0esi
         nA8Dry7Zs60bwRlA33tlHDj/YLJF1+p15irQEdBAuWggvCaeVVkk3BR28SwKdMI0Vt8d
         ZLcUISiqEeFXYKeU49qk7KkAbgKHpsRWYjQSHAc09HUMdjZJnboX5EIcgZPkDBY07GPh
         /r7XvyNXA1SwOBcNUlRUl2MulWP6Xt4rcbUrxmZJXvOZhmUqgQ8Z6/T+zHRVbYkhPU+J
         XnuMd3aSWQ6EBhlSNImdE+HNrgaa29IV8ZfeuBD+Urc1F/Q0Em1JL8zPi6RYGto8sdUS
         Qw9Q==
X-Gm-Message-State: AGi0PuauM9RCfSrmOY5ax7DZNFyme6fV0D/EoHyuMSL663JwYfO7VBfx
        xSkDTpiUTkoxrw+l/aDKQOv6N4IrG6IjiqMDZm63+Q==
X-Google-Smtp-Source: APiQypIelHi5H2gOOeV6AG0p+DHhbAQdWM8rSXrfNS+YheSy9O8I6CDCBlbJIoDENRReAgdL4iw++6cAfwm27FCISDY=
X-Received: by 2002:a92:d786:: with SMTP id d6mr17358321iln.74.1588617140339;
 Mon, 04 May 2020 11:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200430071506.1408910-1-songliubraving@fb.com>
 <20200430071506.1408910-3-songliubraving@fb.com> <CAADnVQK-Zo19Z1Gdaq9MYE_9GmyrCuOFbz873D4uCvvVSp0j0w@mail.gmail.com>
 <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
In-Reply-To: <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 May 2020 11:32:09 -0700
Message-ID: <CAEf4BzacguQXgT9GUj2yfdw3M8dM85gBt55Di+CGLCZcYcuK6Q@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 10:47 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On May 2, 2020, at 1:00 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
> >
> > On Thu, Apr 30, 2020 at 12:15 AM Song Liu <songliubraving@fb.com> wrote=
:
> >>
> >> bpf_enable_stats() is added to enable given stats.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> > ...
> >> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> >> index 335b457b3a25..1901b2777854 100644
> >> --- a/tools/lib/bpf/bpf.h
> >> +++ b/tools/lib/bpf/bpf.h
> >> @@ -231,6 +231,7 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_s=
ize, char *log_buf,
> >> LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *b=
uf,
> >>                                 __u32 *buf_len, __u32 *prog_id, __u32 =
*fd_type,
> >>                                 __u64 *probe_offset, __u64 *probe_addr=
);
> >> +LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
> >
> > I see odd warning here while building selftests
> >
> > In file included from runqslower.c:10:
> > .../tools/testing/selftests/bpf/tools/include/bpf/bpf.h:234:38:
> > warning: =E2=80=98enum bpf_stats_type=E2=80=99 declared inside paramete=
r list will not
> > be visible outside of this definition or declaration
> >  234 | LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
> >
> > Since this warning is printed only when building runqslower
> > and the rest of selftests are fine, I'm guessing
> > it's a makefile issue with order of includes?
> >
> > Andrii, could you please take a look ?
> > Not urgent. Just flagging for visibility.
>
> The following should fix it.
>
> Thanks,
> Song
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D 8< =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> From 485c28c8e2cbcc22aa8fcda82f8f599411faa755 Mon Sep 17 00:00:00 2001
> From: Song Liu <songliubraving@fb.com>
> Date: Mon, 4 May 2020 10:36:26 -0700
> Subject: [PATCH bpf-next] runqslower: include proper uapi/bpf.h
>
> runqslower doesn't specify include path for uapi/bpf.h. This causes the
> following warning:
>
> In file included from runqslower.c:10:
> .../tools/testing/selftests/bpf/tools/include/bpf/bpf.h:234:38:
> warning: 'enum bpf_stats_type' declared inside parameter list will not
> be visible outside of this definition or declaration
>   234 | LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
>
> Fix this by adding -I tools/includ/uapi to the Makefile.
>
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

LGTM. Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/runqslower/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index 8a6f82e56a24..722a29a988cd 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -8,7 +8,8 @@ BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
>  BPFOBJ :=3D $(OUTPUT)/libbpf.a
>  BPF_INCLUDE :=3D $(OUTPUT)
> -INCLUDES :=3D -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../lib)
> +INCLUDES :=3D -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../lib)       =
 \
> +       -I$(abspath ../../include/uapi)
>  CFLAGS :=3D -g -Wall
>
>  # Try to detect best kernel BTF source
> --
> 2.24.1
>
