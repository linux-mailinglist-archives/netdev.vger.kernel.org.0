Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2D43AB7B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhJZE5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 00:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJZE5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 00:57:23 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053FBC061745;
        Mon, 25 Oct 2021 21:54:59 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id d204so16246366ybb.4;
        Mon, 25 Oct 2021 21:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Rq+clhxkZCbB9+pnMudoNhmYAfOTd3FsrKbIehYoOg=;
        b=ENk6ibOPOfUzReh9gUL0YUlzmGErn2xn+r1N9Ons7Qaz7Koo+JEbqbvfVpT8/v6NSV
         WtfOE33nmy/qY5YUfEfxFNgoe9ukOrox7tQ74EbzUiLjKEt5LSkearLCbz8ekGfJPf2s
         jSOATRIeifQH9LMYXxpavPqnTq+gSnHGwgQTv5NpgJfwYvZvh7MvorOzdlCmhDK5SnXO
         pZ7cRIxlR1lONuPmTgzJFnHHUV/rUGPQ7ZGMY/DILgrai69qnseppOqDmpErTuS3wpjh
         SpwkimWgOSlXJ3v/gocxuJPyQEyjqhzCilX7tESAMVrFwQk9rfgBoR3k0Br7dzmLUsQt
         hJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Rq+clhxkZCbB9+pnMudoNhmYAfOTd3FsrKbIehYoOg=;
        b=0kYPlMCpdp0aF75zOtENpsjdxzUhQLb+fmx1yXimsbHkDfQQBR/pclwlzRAn8NfhUX
         P/KQzOTURLLmbog3cq/rDQlGy+OXsYM0V45CSruXg4P/Twssz+ca8YtG76MbYCHSBEc6
         v8p4G4yogzYTqLWNKaMOPxRgJUcg3Ry9hLWUcZevSamtqXdc5axxVI6qAstjDgucAhzy
         lWkdPIHMaQnx0BLM7fAx6pJ9mv+NQYpZWFMqNwiwgh58mymcUofiGLO0z80wuwSKhOiT
         Iqglt40e2MBqGSGCqo0ZY9weLZZpByWzWnmWX/YzVkpMDbYAtCCcY/f8hl9mNCytGLJG
         FimQ==
X-Gm-Message-State: AOAM5317bC6fMl7WzpD2fOywbMw3OkdO/jF0o1hCvS6HIfw7NpGVKTSn
        5FIIz/Sk//vaQ9rpkK9Rdi50wdIig4E9KA9b40s=
X-Google-Smtp-Source: ABdhPJwUZgNjMPaMKUt4rAUwYM0hduyZMGwrLGncIMxw8cafErJPiw75WyXWaDv3NmXa0gI5tbytv5UicsXXBJKSyuI=
X-Received: by 2002:a25:8749:: with SMTP id e9mr21100920ybn.2.1635224099251;
 Mon, 25 Oct 2021 21:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211023120452.212885-1-jolsa@kernel.org>
In-Reply-To: <20211023120452.212885-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 21:54:48 -0700
Message-ID: <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> hi,
> I'm trying to enable BTF for kernel module in fedora,
> and I'm getting big increase on modules sizes on s390x arch.
>
> Size of modules in total - kernel dir under /lib/modules/VER/
> from kernel-core and kernel-module packages:
>
>                current   new
>       aarch64      60M   76M
>       ppc64le      53M   66M
>       s390x        21M   41M
>       x86_64       64M   79M
>
> The reason for higher increase on s390x was that dedup algorithm
> did not detect some of the big kernel structs like 'struct module',
> so they are duplicated in the kernel module BTF data. The s390x
> has many small modules that increased significantly in size because
> of that even after compression.
>
> First issues was that the '--btf_gen_floats' option is not passed
> to pahole for kernel module BTF generation.
>
> The other problem is more tricky and is the reason why this patchset
> is RFC ;-)
>
> The s390x compiler generates multiple definitions of the same struct
> and dedup algorithm does not seem to handle this at the moment.
>
> I put the debuginfo and btf dump of the s390x pnet.ko module in here:
>   http://people.redhat.com/~jolsa/kmodbtf/
>
> Please let me know if you'd like to see other info/files.
>

Hard to tell what's going on without vmlinux itself. Can you upload a
corresponding kernel image with BTF in it?

> I found code in dedup that seems to handle such situation for arrays,
> and added 'some' fix for structs. With that change I can no longer
> see vmlinux's structs in kernel module BTF data, but I have no idea
> if that breaks anything else.
>
> thoughts? thanks,
> jirka
>
>
> ---
> Jiri Olsa (2):
>       kbuild: Unify options for BTF generation for vmlinux and modules
>       bpf: Add support to detect and dedup instances of same structs
>
>  Makefile                  |  3 +++
>  scripts/Makefile.modfinal |  2 +-
>  scripts/link-vmlinux.sh   | 11 +----------
>  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
>  tools/lib/bpf/btf.c       | 12 ++++++++++--
>  5 files changed, 35 insertions(+), 13 deletions(-)
>  create mode 100755 scripts/pahole-flags.sh
>
