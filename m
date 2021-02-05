Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4253118B3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhBFCoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhBFCcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:32:22 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDE8C0698D0;
        Fri,  5 Feb 2021 14:24:22 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id v123so8213517yba.13;
        Fri, 05 Feb 2021 14:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uQykqIICKTbhMjXss2MdZxSh7LZznNksmMLb9c4zDc4=;
        b=Ay28IZ3EsBl/gjG2R8wQSaUcxtl6QcUdqz5eD9wkDmwXZMxVicrSdYLMYmmx+yVEZN
         ESfE6FRI7xmODJHf7tYejQJCD0REH/Je5d41OAgah7qGX1fOShnYtRpcMN/Q05LVk3L+
         dx3u929XHqvFSCMw4f5ycfOgED9nXxPd7hv0t7eBRxdgs2ixnJub256N+O6iSza7CYWp
         FwweYQSBbkgoUNx12rUD0PzYXOYXyGwZtoOyqNAUJkpzBQnXiWkWzDSEqW+giBCwW/UM
         4lxZjdao/MABtm7gIfbuAUQ5K3x1/ViOoitrxijIZh5prwkOljMAkaR2m68PqU2STif+
         shnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQykqIICKTbhMjXss2MdZxSh7LZznNksmMLb9c4zDc4=;
        b=L24SkP7JnyaKZKs1DTHGqmF7lm9aM25s0ksoF4LXIWShNZByXXhddOUULPok58+1th
         i49gMAgrJ6I9WNG7SVu6OF47E/UtTEP8dZavy9KKBmZ90bZpaX1UEoVuWSWNs1RcfB71
         zOJVfroLRRmDdisWSsYya8HxZJvsFnjIT0oWPkcRcbwuWglZHl7GtS/JrvanhDhYwVIY
         aTRljw/A+x/izJ2hlp96C1yV3UcoCTEYibN3BhbvtrDBnx2LjM6sv0ooBXqowkMPNvdq
         j7LzyUFmSW7ZBtOYHL/VOmeTHemeMeLGA3J8lLkBVCTWHI1ev6XHgHocoH9B43SwJ7T5
         bcuQ==
X-Gm-Message-State: AOAM531wZjt/9iXEVYbIDI8w8jRMBJIUCxwBjLDMaO4e/G98lBmDt7ad
        pHpbHTnBR6ZE+r/0o2cTN325xRw7eI264MD64ss=
X-Google-Smtp-Source: ABdhPJxnBFgFM492SdCHWsGVGLaqGC/D15+x7dV47Dl81Nrb6e1r0coQitDT1CNXG/CqpyDLOFuBlX2m3U86YDmPvYQ=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr9295890yba.403.1612563861495;
 Fri, 05 Feb 2021 14:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-2-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Feb 2021 14:24:10 -0800
Message-ID: <CAEf4BzYKq+Z1T6+yfM0dfuGMvZB1TRaqT-jWpPzUvgPdXh=Y0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
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
> Setting up separate build directories for libbpf and libpsubcmd,
> so it's separated from other objects and we don't get them mixed
> in the future.
>
> It also simplifies cleaning, which is now simple rm -rf.
>
> Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
> files in .gitignore anymore.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/resolve_btfids/.gitignore |  2 --
>  tools/bpf/resolve_btfids/Makefile   | 26 +++++++++++---------------
>  2 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> index a026df7dc280..25f308c933cc 100644
> --- a/tools/bpf/resolve_btfids/.gitignore
> +++ b/tools/bpf/resolve_btfids/.gitignore
> @@ -1,4 +1,2 @@
> -/FEATURE-DUMP.libbpf
> -/bpf_helper_defs.h
>  /fixdep
>  /resolve_btfids
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index bf656432ad73..1d46a247ec95 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -28,22 +28,22 @@ OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
>  LIBBPF_SRC := $(srctree)/tools/lib/bpf/
>  SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
>
> -BPFOBJ     := $(OUTPUT)/libbpf.a
> -SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
> +BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
> +SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
>
>  BINARY     := $(OUTPUT)/resolve_btfids
>  BINARY_IN  := $(BINARY)-in.o
>
>  all: $(BINARY)
>
> -$(OUTPUT):
> +$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
>         $(call msg,MKDIR,,$@)
> -       $(Q)mkdir -p $(OUTPUT)
> +       $(Q)mkdir -p $(@)
>
> -$(SUBCMDOBJ): fixdep FORCE
> -       $(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
> +$(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
> +       $(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
>
> -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
>         $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
>
>  CFLAGS := -g \
> @@ -57,23 +57,19 @@ LIBS = -lelf -lz
>  export srctree OUTPUT CFLAGS Q
>  include $(srctree)/tools/build/Makefile.include
>
> -$(BINARY_IN): fixdep FORCE
> +$(BINARY_IN): fixdep FORCE | $(OUTPUT)
>         $(Q)$(MAKE) $(build)=resolve_btfids
>
>  $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
>         $(call msg,LINK,$@)
>         $(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
>
> -libsubcmd-clean:
> -       $(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
> -
> -libbpf-clean:
> -       $(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
> -
> -clean: libsubcmd-clean libbpf-clean fixdep-clean
> +clean: fixdep-clean
>         $(call msg,CLEAN,$(BINARY))
>         $(Q)$(RM) -f $(BINARY); \
>         $(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> +       $(RM) -rf $(OUTPUT)/libbpf; \
> +       $(RM) -rf $(OUTPUT)/libsubcmd; \
>         find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
>
>  tags:
> --
> 2.26.2
>
