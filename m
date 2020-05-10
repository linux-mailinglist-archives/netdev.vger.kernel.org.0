Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7373B1CC5DF
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 03:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEJBD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 21:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbgEJBD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 21:03:56 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08797C061A0C;
        Sat,  9 May 2020 18:03:55 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 188so4445832lfa.10;
        Sat, 09 May 2020 18:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oUtCBI0SpjkuBlySGcVr6wv9x0FCxiJz7SVspQbRCUE=;
        b=tjx4U6vvgWQJ4b+stBXI4gRGBxQfyg0hC4M5h4WWXhDVj7cTBzwjRDEF//yhWAe6gH
         SAKb3e/hi54Vau4iLS17nLChQkaPkam3c8z2vOdnpW78GRs94hyuvYuHelxcWOULEAA6
         t8X/3Fv6m3QSpC12j72dFSIO+HNH7Ehf0vi6FLxYcV7OYhVhdxStpmg0WUNqP8JF8xDp
         HoIl3V2XQoWxgi1f5XikcqhbjDxchLTLSmWqmMEDvzWq0xdELH4nBcep6obPGCbX0pam
         ekIX9aRW2yXBXJywswDbh1ycjka9AVCG4pH3wbdim90h23Ab6Fjt5+8pTwLwlBDZOCww
         qkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oUtCBI0SpjkuBlySGcVr6wv9x0FCxiJz7SVspQbRCUE=;
        b=H3BTQfKXtnF7CknzZg5ov50Q5NUqOzFuGN9RvD90sSSBZUBzkn/tYO+wUYtmyc6nU2
         svfbh9w0sQE1BgVK9saPA1W9XzTGD5O4LxnkAS2sj5vgZvM3i4G58bUnbNa/ydKJzjSm
         4kDkEW8JYkQdkfgD2syQqywMvCEm6vqv+9xk41uNOVLP9Vws32MgVODggQtzYNYDiHAp
         RekkqVUFFAOl5nFISW2f7UZMOaNWopnpraeBCFjMs4Cc4oukeoY0gOA/plAhfzsoW6il
         Z+cBuQnWkl+gwLqpStFcMZ8sVaxwFEE0/RUP4/HbYaCSD9noTUQo1vpKPPGlsK9Pp+Ig
         4VSg==
X-Gm-Message-State: AOAM530QhoD/0zw+/uKZxaPmDcP9iALR6Xaj++MkA2OlvMp+/K1upIR0
        21UO3cCvYg5FLHnAdtUc8lA0ePAA2SAL+2JNVUI=
X-Google-Smtp-Source: ABdhPJxZQdlg/2Glq4lwN9ni91R83DjlXzgvcws7dKg0k94GpcefKo7F2j9KuI6eiZhOTHDsQSZXNCwna8Wo57s/qcA=
X-Received: by 2002:a19:505c:: with SMTP id z28mr6352903lfj.174.1589072634419;
 Sat, 09 May 2020 18:03:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200430071506.1408910-1-songliubraving@fb.com>
 <20200430071506.1408910-3-songliubraving@fb.com> <CAADnVQK-Zo19Z1Gdaq9MYE_9GmyrCuOFbz873D4uCvvVSp0j0w@mail.gmail.com>
 <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
In-Reply-To: <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 9 May 2020 18:03:42 -0700
Message-ID: <CAADnVQJp+KvwivjRkh8_NEgihqXU_9y66N+J8M_9WFaA3vmkgw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
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

On Mon, May 4, 2020 at 10:45 AM Song Liu <songliubraving@fb.com> wrote:
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

Applied.
In the future please always send patches as fresh email
otherwise they don't register in patchworks.
I applied this one manually.
