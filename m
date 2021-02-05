Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04C4311941
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBFDAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhBFCuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:50:51 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E2BC0698C6;
        Fri,  5 Feb 2021 14:25:16 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id c3so8291979ybi.3;
        Fri, 05 Feb 2021 14:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYUg3hUYLhRgtIvFTbD2VmRbiO8E/oS3HEcH+2mdLys=;
        b=D/3Szo3U0J1VcnkFYVHbqwjGp20STlNB4R1cBtjGpJ3Pe/kU/JgKGkAYcdQFg1oyeH
         EFwqKYd0FfjGc/aJEK7kezMmBkJOQFoyMbP1X4O7qqFBnTnJB/pv6oWNiehS1ycSK8ZS
         fO77QvpCHiX42uE03qFBinL40qgQPWhz+r//HGZaSOesmEM3z4UKLJWxQk+Uw9Ow1wLf
         IOPeAdTfZZi0ohvdCHS4Wo0m9YKvAtkxhytEDe0ZOguQh4S2Lol9v3YgrbyFbTu9Zca0
         zHwsn7Rmhm660asec3AV/x5tBA56CSt/j/w5FdmBjOYpqQhXf8JLfYG5zgNxnx/DYAMf
         1PmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYUg3hUYLhRgtIvFTbD2VmRbiO8E/oS3HEcH+2mdLys=;
        b=fbT7IFOTyBDNwxFvNYNEqawfSpazV4xkWGP6WrCCnlxadMPOFP5SVPP+ZPRyG/NLI1
         E2viHDSDXeDapZwgIjrTteeIiJIcDoyzsmsE/TPnwghvJu2Jc/TnpwzGSIq2pqDo44v9
         KGZq7/2lGZSRG6dzVERnrFFJO4yGg0ZYEsEwvehCNcemDFUPnf7YqBZ8c2u0mJTQLh6d
         DmAJeFeQ3PwZUO5BHqCsdWrni6r3t2rQF+LFUIbn099g/l4EvCEj+pz+APjhVD4c+Q1c
         19ZEGQxiX8ZwyMofvFexkuy/8MU7KsNbpSLeqDrzPnvDX+jItmbfcvODTAI1tk9DgDZe
         stIA==
X-Gm-Message-State: AOAM533m3bSw3vMkPWRBU/i+yzHiEBxTItDEwDjlXOJy1useiMtmJHCI
        QAi1OwKCh8LMYZX3RXCHUptxgsTtN9y/6OyFczk=
X-Google-Smtp-Source: ABdhPJxPvMF+GPOj/8IjoyGkasonxz/I6RMZw8DMRUyvUJ14OqNyfV/+HbUj0a2/lwXZGicPrAZWNrbkKKSo7ekzHN0=
X-Received: by 2002:a5b:3c4:: with SMTP id t4mr8617231ybp.510.1612563915723;
 Fri, 05 Feb 2021 14:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-4-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Feb 2021 14:25:04 -0800
Message-ID: <CAEf4BzYPOmS9=cuF9BkUcWv1MNZ0OEyi-bT6KUwm60PxXivS2Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] tools/resolve_btfids: Set srctree variable unconditionally
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 4:46 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We want this clean to be called from tree's root Makefile,
> which defines same srctree variable and that will screw
> the make setup.
>
> We actually do not use srctree being passed from outside,
> so we can solve this by setting current srctree value
> directly.
>
> Also changing the way how srctree is initialized as suggested
> by Andrri.
>
> Also root Makefile does not define the implicit RM variable,
> so adding RM initialization.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/resolve_btfids/Makefile | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index be09ec4f03ff..bb9fa8de7e62 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -2,11 +2,7 @@
>  include ../../scripts/Makefile.include
>  include ../../scripts/Makefile.arch
>
> -ifeq ($(srctree),)
> -srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> -srctree := $(patsubst %/,%,$(dir $(srctree)))
> -srctree := $(patsubst %/,%,$(dir $(srctree)))
> -endif
> +srctree := $(abspath $(CURDIR)/../../../)
>
>  ifeq ($(V),1)
>    Q =
> @@ -22,6 +18,7 @@ AR       = $(HOSTAR)
>  CC       = $(HOSTCC)
>  LD       = $(HOSTLD)
>  ARCH     = $(HOSTARCH)
> +RM      ?= rm
>
>  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
>
> --
> 2.26.2
>
