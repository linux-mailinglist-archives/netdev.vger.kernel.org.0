Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA403CB1B0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhGPEws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhGPEwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:52:47 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2145AC06175F;
        Thu, 15 Jul 2021 21:49:53 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id c16so6090989ybl.9;
        Thu, 15 Jul 2021 21:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PkyEPk/4wB7JABAl75ww38Y0BngqhgSDP8waOBjAM9g=;
        b=eZpw18yXkJC5JJZpR7mX8LlyMfjOiOARt0UIrVJdb+X0sJWYxATl71Z5qkolyBRZyu
         qfCkOmkEzwOEh7NXDXJh81aJKMADCuvKZrJpPEdLAdLACbc7NfmZ9za2LqcbbdNIOHvv
         zjh2Huotb4PLkQQQjj9UZqJZ4r9uhXl8cHsSYAWTy8iLP73pyfQgyzphPQ5/HjIUM89p
         WrrZi+e4VGyvIzWv3W2bpl8KNo3xK9P9zVKg1gVHUbPOJNltCd7KwOa8FlMwOuW8uhUr
         jF6N5hHxUMqhfp2Rk/4cyxqo+G5qlumllEVNTnH+/50EVDw28nCTbMLSuWYWPgRb6PPG
         A5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PkyEPk/4wB7JABAl75ww38Y0BngqhgSDP8waOBjAM9g=;
        b=IFbJNEkyFl0oLYY4PlxqD3B0H8qKrAp4f1ES5pHNdx6uWAfC/687ckueM5EVMA7G25
         5XxrT/gj7KBKmancpoWQ52kYiwROW38Z2vxGHxdfLQ4pdhxtq3Vsee9EHamgDfKqdH4Z
         CIUPiSzR8v2EjoLfMxrOupA/0wBelTg/1VJq51/P0ihLNKa8G5hGAjZqvfe+qNBQP276
         BXhZTFSQSv5OMiuJHZUZVPEtkCYje/MJPw17CdM/lqunEgh/PslUcw0iQ4gMdOSk3KVe
         XnqWcjR0IkCalHzjNkMdsP/bVsH029cWWz7iC7MTRjbYuxWwRw8xSDgWlM9C/6JoeS9m
         0PNw==
X-Gm-Message-State: AOAM5336dLzsqfX2mQEpkFfJbBS5radxhxJVrMUR/HnrdlT0FK9hKzTR
        jn2DMjKLFGCigH0RSxo6mjFftihivrPSGsYHhQc=
X-Google-Smtp-Source: ABdhPJzdWbSDPWr4RvQEq7NkKlhLkXhqjCu2LPtLjSY0MS5Lf84i7tkBSrkt7A7bY7Yyp0rz40Qq1Avu6tIhlE56Yv0=
X-Received: by 2002:a25:b203:: with SMTP id i3mr10217027ybj.260.1626410992260;
 Thu, 15 Jul 2021 21:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:49:41 -0700
Message-ID: <CAEf4BzaDMeZ5+v4enTA6m3OJrQsNXY9G8e9uchhaeQmauTTiiQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] Add btf_custom_path in bpf_obj_open_opts
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 5:43 AM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:
>
> This patch set adds the ability to point to a custom BTF for the
> purposes of BPF CO-RE relocations. This is useful for using BPF CO-RE
> on old kernels that don't yet natively support kernel (vmlinux) BTF
> and thus libbpf needs application's help in locating kernel BTF
> generated separately from the kernel itself. This was already possible
> to do through bpf_object__load's attribute struct, but that makes it
> inconvenient to use with BPF skeleton, which only allows to specify
> bpf_object_open_opts during the open step. Thus, add the ability to
> override vmlinux BTF at open time.
>
> Patch #1 adds libbpf changes.
> Patch #2 fixes pre-existing memory leak detected during the code review.
> Patch #3 switches existing selftests to using open_opts for custom BTF.
>

LGTM with some minor things I'll adjust while applying (which I'll
point out in respective patches). So no need to re-send anything.
Thanks.

> Changelog:
> ----------
>
> v3: https://lore.kernel.org/bpf/CAEf4BzY2cdT44bfbMus=gei27ViqGE1BtGo6XrErSsOCnqtVJg@mail.gmail.com/T/#m877eed1d4cf0a1d3352d3f3d6c5ff158be45c542
> v3->v4:
> --- Follow Andrii's suggestion to modify cover letter description.
> --- Delete function bpf_object__load_override_btf.
> --- Follow Dan's suggestion to add fixes tag and modify commit msg to patch #2.
> --- Add pathch #3 to switch existing selftests to using open_opts.
>
> v2: https://lore.kernel.org/bpf/CAEf4Bza_ua+tjxdhyy4nZ8Boeo+scipWmr_1xM1pC6N5wyuhAA@mail.gmail.com/T/#mf9cf86ae0ffa96180ac29e4fd12697eb70eccd0f
> v2->v3:
> --- Load the BTF specified by btf_custom_path to btf_vmlinux_override
>     instead of btf_bmlinux.
> --- Fix the memory leak that may be introduced by the second version
>     of the patch.
> --- Add a new patch to fix the possible memory leak caused by
>     obj->kconfig.
>
> v1: https://lore.kernel.org/bpf/CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com/t/#m4d9f7c6761fbd2b436b5dfe491cd864b70225804
> v1->v2:
> -- Change custom_btf_path to btf_custom_path.
> -- If the length of btf_custom_path of bpf_obj_open_opts is too long,
>    return ERR_PTR(-ENAMETOOLONG).
> -- Add `custom BTF is in addition to vmlinux BTF`
>    with btf_custom_path field.
>
> Shuyi Cheng (3):
>   libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
>   libbpf: Fix the possible memory leak on error
>   selftests/bpf: switches existing selftests to using open_opts for custom BTF
>
>  tools/lib/bpf/libbpf.c                             | 42 +++++++++++++++++-----
>  tools/lib/bpf/libbpf.h                             |  9 ++++-
>  .../selftests/bpf/prog_tests/core_autosize.c       | 22 ++++++------
>  .../testing/selftests/bpf/prog_tests/core_reloc.c  | 28 +++++++--------
>  4 files changed, 66 insertions(+), 35 deletions(-)
>
> --
> 1.8.3.1
>
