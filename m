Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C73B20281C
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 05:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgFUDHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 23:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgFUDHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 23:07:14 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F12C061794;
        Sat, 20 Jun 2020 20:07:13 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q198so4874703qka.2;
        Sat, 20 Jun 2020 20:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WWJ0LfTE1o+QFSDrB22aIlwytmbwPgLM4+MVpi+Ikgw=;
        b=fveFj3UpqLfYSUpKJL37oIPqu30gkaIHWbPP2fZR8/SzF+U63sRE3eRxrMd/yWiIZk
         xNx47IZyUqnusomqYTzLJ1/PxM+JlO8ncbwizneMTilZVltV1QbRBmj0umcDF7dsaumJ
         LLmdtLqVBU6H259/fYqiH2D9RqPswA1f0FUXTlaHATKvdkDFUtNbuDPvldUpVdViUD+f
         ArCwaDiK8/YQYuLzzB7uEqmKyCvAuWNPQSOzFneOI6GjrvSXIWjRqkcLz63ty8PLwKOY
         WeZlbcNooqGrr87G77pdEfPgvKqt96OfJLg9wnE7yEsrgFP/a8pXHqsL0vSbRVAgdUop
         RUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WWJ0LfTE1o+QFSDrB22aIlwytmbwPgLM4+MVpi+Ikgw=;
        b=rqrs32nwEX5lx1p+ugAbFfr4SJzJNLOCULSr6xLRvx3i2l514einD31t4jp7tr1lFo
         Mn7+pIM0IGR1zu6Ymj4KjdLAYZ9bAc1Aw0mxjVEifQjFV7GSrWBHAV2TCvPKDj1NOFsH
         je0z61VlNyxLxtK1/NaHWJmh8tfsmub9FSzb16+3Q7Q4RrzOieqOGTXeAVYNtb0kayGj
         au1AXkTiouNMnYQzxqZXJxSgBaEWzqbAUC59fAIVa87szixHTy6x4qxAeYR5gQeNIbYy
         Obvdz60bK3H0Iep5CxxYJFyInb6Dj4ybUc1QkYQW28YDpQEmLjszPkkPjFDHQiACRsWV
         BZvA==
X-Gm-Message-State: AOAM533skPft1altB1CAAZBwdAULRZZFLRHeLDXvOr9N2HCIaELPub4M
        Nhzc85RGMi1pl8WQefGwVpSu8qqjtvruyrFjnpI=
X-Google-Smtp-Source: ABdhPJzubCzdPaAx75pzX69wRc5pty/dtSLC6+VPXYzATmwkrylHkYNBsn2OEm9TFkfLEYbBGB4SzaNitvD86YCeSl0=
X-Received: by 2002:a37:d0b:: with SMTP id 11mr11032477qkn.449.1592708832182;
 Sat, 20 Jun 2020 20:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200430071506.1408910-1-songliubraving@fb.com>
 <20200430071506.1408910-3-songliubraving@fb.com> <CAADnVQK-Zo19Z1Gdaq9MYE_9GmyrCuOFbz873D4uCvvVSp0j0w@mail.gmail.com>
 <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
In-Reply-To: <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 20 Jun 2020 20:07:01 -0700
Message-ID: <CAEf4BzY5G1+Uw9MFw_Lywi+5kA07Z78GoSpMNmH_BB7TzgkJcA@mail.gmail.com>
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

This is a partial work-around just for runqslower, which has a luxury
to access the very latest linux/bpf.h. Any other system that doesn't
have the very latest bpf.h header will get warnings about undefined
`enum bpf_stats_type` definition, even if they don't use
bpf_stats_enable(). I think the proper fix here is to add forward
declaration of this enum in libbpf/bpf.h. I'll send a patch in a few
minutes.
