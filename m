Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB25B3101B9
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhBEAkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhBEAka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 19:40:30 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE14C061786;
        Thu,  4 Feb 2021 16:39:50 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id i6so5087728ybq.5;
        Thu, 04 Feb 2021 16:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pET7RD4NSC0ZUKyfSRv90LKhsX/TD+jdw2JcHxXzzk=;
        b=RjzdMLm04tu+CkRSW7J8Dg9PztXjy2Y7jwLx2POersbaMTdTBAJgZRpEO7RnQooAL9
         KVOuMffTeORkw99UlSPUg+QezwVIS4OrlVYaw8cFTMKeMQGh8fLjGpY7WEpZHo0/xnSc
         aAwSARSfyopjnn2zbJRRMy7ZBfg5VKa+iHeQ+ZZeh8vm4Tii/zXKslRUYWdL4V0XtN8m
         0c8LuOELsBUCAScV4UfpEyysxrIHNugFe+2OEtYrjfBvgiZdaOdOKwTOYE8iIKJgbRVL
         yxJWVUXtlMQn5m4EWhzYDLKBQzRfQ7mqMNVStUu2qpXeJTy6Cm33GddX4Bi2Gu+76pkx
         wMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5pET7RD4NSC0ZUKyfSRv90LKhsX/TD+jdw2JcHxXzzk=;
        b=LaAZghnmQW7+4GvZEtlffBraChLBS9m38F1YrozoHnY//uAvJzBeM+oC33Ig6elCN/
         r7D0dsOYH6oq4bML3eFm1IATwUSiOLdSFh3gGTSlMmqqaZOjDx1cR68x5OfQ+WtXQG3H
         I/l72kGR9StNQ1VUKkvWV5XGZE0AFTy5xZXB3+iyg7pbo6gImbP3cPemoESlGD0tiG+P
         msp6l/fpJdc7CgQKShqmpvIk3OaVYSNdLam1siU3PbWpk2hJTygHVjm/EaQawgsraHQr
         TJA8BWwa6+mowxp6yIrroD2fJAzuKCcY2zoQu/Wh4/0Sq1VrVWgreAg2LkTrLGcp5a62
         Q+Xw==
X-Gm-Message-State: AOAM532j03EVrCZBNoM8xWU6kC3EcdHOhsgMjYz3Hkgeqjfu7k5fFEmZ
        lBApdadT5Y1VxPiI0LclR4ZPl2DgwSgp1+rv4k0=
X-Google-Smtp-Source: ABdhPJxx/PJbiNI40A9YqE7is4NPvwhvaAekDVsvyFwAZpKPPArMU8ommVGwPPjN6paLm+Zh0bZQgpucadGx9HmznJ8=
X-Received: by 2002:a25:9882:: with SMTP id l2mr2534374ybo.425.1612485589516;
 Thu, 04 Feb 2021 16:39:49 -0800 (PST)
MIME-Version: 1.0
References: <20210129134855.195810-1-jolsa@redhat.com> <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-2-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Feb 2021 16:39:38 -0800
Message-ID: <CAEf4BzYhnm2tfnuGWXDOAZZmYBnboSZ3JsWjDHM5ortCbaeEjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
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

On Thu, Feb 4, 2021 at 1:20 PM Jiri Olsa <jolsa@kernel.org> wrote:
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
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
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
> index bf656432ad73..b780b3a9fb07 100644
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
> +       $(RM) -rf $(OUTPUT)libbpf; \
> +       $(RM) -rf $(OUTPUT)libsubcmd; \

If someone specifies OUTPUT=bla, you will attempt to delete blalibbpf,
not bla/libbpf

>         find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
>
>  tags:
> --
> 2.26.2
>
