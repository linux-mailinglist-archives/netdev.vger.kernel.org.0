Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F94245F4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhJFSYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhJFSYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:24:03 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED40BC061746;
        Wed,  6 Oct 2021 11:22:10 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id n65so7498914ybb.7;
        Wed, 06 Oct 2021 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GTQGdaAtHW0Uhg8ryNLUS9vvFMs/vzRHHOBWfDgk9D4=;
        b=WFmdw1yK4OgApNltj37iG9SFl6JsytPm9Yq310j5recLyBaefWGItlkV87MCkelfHt
         DeYlaGYW7K9v6SFzBt67tBdJujnAEFMDr/CFO0ZlGy1aa9wmnLTCXp3uPUoJjTTQwyeJ
         AM6MtZgFE6Lc6NgxXHr7DtLZ+pEK51lLx/hBauCtHsQilC7hPiwPVGUWswa4T9rpWcph
         62ZSeX5U7GemcIUL9iWYQGi4++NbtuHlKzpn0/i867rrweuZUQ4/iwshAUemxas2feOv
         OgeIgFGdUApTTYnf8IEILUDdw2tDrPTrqfNukrZyVcuVcuYVlKDDQG05AM7mDtupPYvH
         CGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GTQGdaAtHW0Uhg8ryNLUS9vvFMs/vzRHHOBWfDgk9D4=;
        b=bTWI1oVyl7/QSOGjKDVBKG3ewuV7m/lBd2qMrbnrRZ7iXKPvRIkwwpNO+gGxKDCNdx
         l5Kf2IBCrp/Ly+WBugM+MtEpKDOLHGfWFOaS3+g3REdbCi9k27+Kr8zKJpbJ7j2D3Yn/
         Ww6fNTR/dnTsKKMgLOTr8OY7SizEwiWOWxo5R1YrY8Oy4qRiKt1SMRETpqIrbxSby4FA
         6v8v1yucsUWYrDmZlUsfpeBsMhg/7m2cP/uc2GEKh3bH9hIn8D7BfzXV3H9JgZhafb1O
         JqToKJz4/qEe28u/2DpGdsvF+ZpGofYRBtooiq4OSnv4tkJ//KZDiiG1gej5HE+5+zfB
         yz8Q==
X-Gm-Message-State: AOAM533lt4XGDVgPrYLFJWQ3xNhsP0nl9w5Hm4UGb7NBrnbtO4BZI6yf
        5P+Cquaa9/CNcZ7T7zn0So8p6abpyE5nL6nWYXA=
X-Google-Smtp-Source: ABdhPJxpAHTqTua+MJOJ3bHigBqSVgUwe1ZgJeYseCpUP0befEHTQ5JH6Oeoe8dZqczqidT2B9s3buBjhf3wwYD6JSk=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr32496824ybc.225.1633544530227;
 Wed, 06 Oct 2021 11:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <20211003192208.6297-6-quentin@isovalent.com>
In-Reply-To: <20211003192208.6297-6-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 11:21:59 -0700
Message-ID: <CAEf4BzYtX4RBo+5qGXV_3uiq6gv-U-5FNtNbTxAO4HHpyPsQcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/10] bpf: preload: install libbpf headers
 when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> API headers from libbpf should not be accessed directly from the
> library's source directory. Instead, they should be exported with "make
> install_headers". Let's make sure that bpf/preload/Makefile installs the
> headers properly when building.
>
> Note that we declare an additional dependency for iterators/iterators.o:
> having $(LIBBPF_A) as a dependency to "$(obj)/bpf_preload_umd" is not
> sufficient, as it makes it required only at the linking step. But we
> need libbpf to be compiled, and in particular its headers to be
> exported, before we attempt to compile iterators.o. The issue would not
> occur before this commit, because libbpf's headers were not exported and
> were always available under tools/lib/bpf.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  kernel/bpf/preload/Makefile | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 1951332dd15f..efccf857f7ed 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -1,21 +1,36 @@
>  # SPDX-License-Identifier: GPL-2.0
>
>  LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
> -LIBBPF_A = $(obj)/libbpf.a
> -LIBBPF_OUT = $(abspath $(obj))
> +LIBBPF_OUT = $(abspath $(obj))/libbpf
> +LIBBPF_A = $(LIBBPF_OUT)/libbpf.a
> +LIBBPF_DESTDIR = $(LIBBPF_OUT)
> +LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
>
>  # Although not in use by libbpf's Makefile, set $(O) so that the "dummy" test
>  # in tools/scripts/Makefile.include always succeeds when building the kernel
>  # with $(O) pointing to a relative path, as in "make O=build bindeb-pkg".
> -$(LIBBPF_A):
> -       $(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
> +$(LIBBPF_A): | $(LIBBPF_OUT)
> +       $(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/   \
> +               DESTDIR=$(LIBBPF_DESTDIR) prefix=                              \
> +               $(LIBBPF_OUT)/libbpf.a install_headers
> +
> +libbpf_hdrs: $(LIBBPF_A)
> +
> +.PHONY: libbpf_hdrs
> +
> +$(LIBBPF_OUT):
> +       $(call msg,MKDIR,$@)
> +       $(Q)mkdir -p $@
>
>  userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
> -       -I $(srctree)/tools/lib/ -Wno-unused-result
> +       -I $(LIBBPF_INCLUDE) -Wno-unused-result
>
>  userprogs := bpf_preload_umd
>
>  clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
> +clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
> +
> +$(obj)/iterators/iterators.o: libbpf_hdrs

this should probably be order-only dependency as well

>
>  bpf_preload_umd-objs := iterators/iterators.o
>  bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
> --
> 2.30.2
>
