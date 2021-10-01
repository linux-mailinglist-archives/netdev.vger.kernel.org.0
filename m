Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B99041F788
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355644AbhJAWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhJAWpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:45:43 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F315C061775;
        Fri,  1 Oct 2021 15:43:58 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id v10so23591199ybq.7;
        Fri, 01 Oct 2021 15:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pz5XMDd3fwgkO0YoRcqhk4zSb6oj6saPGnuNJn+cgXU=;
        b=JRssuMej2QmnQruo1pOd7hzoAKXtnf3OrOA02InZOVbTunTUQgOQ2r0nPLoPzwfgmY
         CFTEagmnile8u0WmXutwWwa2JWvl3GOMlIF1DS5W/GIjT9QznNC2CQKQLd/FB08onOYt
         cSqJqPy8/rSVkO9nFx+MXptnnjuC2yJHM1Bxn9KWHyji+p+cRweTn5EgGO8q7kbdxtda
         Gz99zOnU155GPggbYOqC2/YLIF8qAHuOKh/Y/CO9IAAgdiZCizrDwTxJEhRj90hgnbPb
         Pd1a3glaTMVCsMvIP0W3Gk2OgmO7beWtks1/nvG5VjHUesMT994KWdP8RKz4u06QGci9
         z4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pz5XMDd3fwgkO0YoRcqhk4zSb6oj6saPGnuNJn+cgXU=;
        b=Ya5+x5nKx8qXe+lvKAuR+1uWVBkTpy/0ES4PAUk0Pbmz5hpmTvo0HwWKE7RgiJHxZ8
         0YyFmJOJPvYajnDilpIByzwU9azVn9KFa7tDoFr4+XlTxoCwKT1d/d+CTieWIF2YkBZJ
         JOan3Hd6LbQvtcWctHnNaMzH6lY29JCOJ4KwbeSUR3CSMJVVpk9y7HAzFXQWaEaEuXCm
         Gl3bCjpmjVA+/oLYq7GNBhMYKtOieLO5Wpq+cgdPbfHnD3VL8j6viFX+LmdFs7CENxu5
         m2tiYtxaCVXDC5QEJe6nCswjdXiyBve6Ld9sr8zaV0gxkuhZnJomqzi+KA9NTfYcQNh8
         I5Iw==
X-Gm-Message-State: AOAM530v6R1A5hyj0GthKtwAaye4P3iT0QxxALVALNeR138FJNYDmZj7
        9c72UR/s5sz1jPvxITGVWi2CJD0lfUkM4OPYKiQ=
X-Google-Smtp-Source: ABdhPJyT5oO/YDN97j9gPo+9yslLKdqmF3c9yGh0OSMVUOQGh/QnP54KMHc4jqMyWKzs+0ZNYFtmb52HvMmNuOa3YEQ=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr418350ybh.267.1633128237745;
 Fri, 01 Oct 2021 15:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210930113306.14950-1-quentin@isovalent.com> <20210930113306.14950-7-quentin@isovalent.com>
 <354d2a7b-3dfc-f1b2-e695-1b77d013c621@isovalent.com> <37d25d01-c6ad-4ff9-46e2-236c60369171@isovalent.com>
In-Reply-To: <37d25d01-c6ad-4ff9-46e2-236c60369171@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 15:43:46 -0700
Message-ID: <CAEf4BzYeTQjYAQo+RqtU-z56GQ0DnWO0pzfvr23qn3A8hEfrQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] bpf: iterators: install libbpf headers when building
To:     Quentin Monnet <quentin@isovalent.com>,
        Yucong Sun <fallentree@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 4:06 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-09-30 13:17 UTC+0100 ~ Quentin Monnet <quentin@isovalent.com>
> > 2021-09-30 12:33 UTC+0100 ~ Quentin Monnet <quentin@isovalent.com>
> >> API headers from libbpf should not be accessed directly from the
> >> library's source directory. Instead, they should be exported with "make
> >> install_headers". Let's make sure that bpf/preload/iterators/Makefile
> >> installs the headers properly when building.
> >
> > CI complains when trying to build
> > kernel/bpf/preload/iterators/iterators.o. I'll look more into this.
>
> My error was in fact on the previous patch for kernel/preload/Makefile,
> where iterators.o is handled. The resulting Makefile in my v1 contained:
>
>         bpf_preload_umd-objs := iterators/iterators.o
>         bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
>
>         $(obj)/bpf_preload_umd: $(LIBBPF_A)
>
> This declares a dependency on $(LIBBPF_A) for building the final
> bpf_preload_umd target, when iterators/iterators.o is linked against the
> libraries. It does not declare the dependency for iterators/iterators.o
> itself. So when we attempt to build the object file, libbpf has not been
> compiled yet (not an issue per se), and the API headers from libbpf have
> not been installed and made available to iterators.o, causing the build
> to fail.
>
> Before this patch, there was no issue because the headers would be
> included directly from tools/lib/bpf, so they would always be present.
> I'll fix this by adding the relevant dependency, and send a v2.
>
> As a side note, I couldn't reproduce the issue locally or in the VM for
> the selftests, I'm not sure why. I struggled to get helpful logs from
> the kernel CI (kernel build in non-verbose mode), so I ended up copying
> the CI infra (running on kernel-patches/bpf on GitHub) to my own GitHub
> repository to add debug info and do other runs without re-posting every
> time to the mailing list. In case anyone else is interested, I figured I
> might share the steps:
>
> - Clone the linux repo on GitHub, push the bpf-next branch
> - Copy all files and directories from the kernel-patches/vmtest GitHub
> repo (including the .github directory) to the root of my linux repo, on
> my development branch.
> - Update the checks on "kernel-patches/bpf" repository name in
> .github/workflows/test.yaml, to avoid pulling new Linux sources and
> overwriting the files on my branch.
> - (Add as much build debug info as necessary.)
> - Push the branch to GitHub and open a PR against my own bpf-next
> branch. This should trigger the Action.
>
> Or was there a simpler way to test my set on the CI, that I ignore?

Don't know, I never tried :) But maybe Yucong (cc'ed) knows some tips
and tricks?

>
> Quentin
