Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C8434240
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhJSXql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJSXqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 19:46:40 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AA9C06161C;
        Tue, 19 Oct 2021 16:44:27 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id s64so11055687yba.11;
        Tue, 19 Oct 2021 16:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OgZOvJmnISi/IWP7zIaJQiVLG2Y9+AndDlobQslWf88=;
        b=AwRqF8u0YONWK3flzEr5mraz4t4x/M73V4GEN2IZxD6IycDT2g2eTESdclFAGU68Gc
         hEFKR8ps6I8o8YQxewHl6AaB3i64zg+kGVMCVVQTOwXPHHsapt3UFWnHPL9Wrqhw//uW
         OVgyK1NM3loL9fPeGxcUuuD2v1AOhd3UiaNse4t7wRWl2kMWIt4+5Y6a4Y1aIsg/Kpre
         1YQuVk6k/18LJHikGeqtIPj699pfCsYzjxyaDv+Hq//JmANj9fBsEmkyeaj+FRnA2gAM
         qTo3xBht+nnExAP7VKsib5KsIPx99TIGcFSizov+DknXVi+eN/dYgfkjDtkPOUm9iP2j
         on0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OgZOvJmnISi/IWP7zIaJQiVLG2Y9+AndDlobQslWf88=;
        b=FJ6XHKNa0/WtAmyfUQ8wgWob3zEWzZdF0ukEaeyNqv4SkMUytIFYHX6DL2eUgB7oN3
         VEPNvBDtEJfwx/bYi1tMz+LDP5nTLeilxSvq14NfSNP/VYP5QYugUmsvd7wsXC+3Lscy
         iT/3UIIGqwoQCnGxSPPsDYoszyHzueeGxfbFr9Ojesd+nlTMMLgN1OdB+Sx3opH2tQFY
         jpRklLIDKHDJgcTL+PkXjindoQ3OyzdsEyvBmMAChSCuZTKUrnfokUFIulU80AuwrKMB
         nvKHFXGaHmpIU1Ko05M3qdm+KIby95DjiCwnP8MkqFtvlzVa854mKBHSc52tJazSTGEU
         CVDg==
X-Gm-Message-State: AOAM532fp/Hbqb2AJwXd5Qs5s4n2WqhZ6VdzLXVNFGo+gfL3t8WUrznG
        fxSrZejp2FtYq8pUGZsgyvBbQk2Ms0TK71G1n8jJr9e5+iLogw==
X-Google-Smtp-Source: ABdhPJzkL7Amrn25peUsKiKkCmdaIL08ogsVoJmzw6witmzBU28kFxgxDDgzNGmgWeDu1hqLui4Fke97DyF/8wqD2ks=
X-Received: by 2002:a25:5606:: with SMTP id k6mr40105192ybb.51.1634687066337;
 Tue, 19 Oct 2021 16:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211009210341.6291-1-quentin@isovalent.com> <20211009210341.6291-2-quentin@isovalent.com>
In-Reply-To: <20211009210341.6291-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Oct 2021 16:44:15 -0700
Message-ID: <CAEf4BzbM1q-Ta8dO31E-zTszmGH3c+oAH6EeQtwv-TyQEXwp4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: fix install for libbpf's internal header(s)
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 2:03 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> We recently updated bpftool's Makefile to make it install the headers
> from libbpf, instead of pulling them directly from libbpf's directory.
> There is also an additional header, internal to libbpf, that needs be
> installed. The way that bpftool's Makefile installs that particular
> header is currently correct, but would break if we were to modify
> $(LIBBPF_INTERNAL_HDRS) to make it point to more than one header.
>
> Use a static pattern rule instead, so that the Makefile can withstand
> the addition of other headers to install.
>
> The objective is simply to make the Makefile more robust. It should
> _not_ be read as an invitation to import more internal headers from
> libbpf into bpftool.
>
> Fixes: f012ade10b34 ("bpftool: Install libbpf headers instead of including the dir")
> Reported-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 9c2d13c513f0..2c510293f32b 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -14,7 +14,7 @@ else
>    Q = @
>  endif
>
> -BPF_DIR = $(srctree)/tools/lib/bpf/
> +BPF_DIR = $(srctree)/tools/lib/bpf
>
>  ifneq ($(OUTPUT),)
>    _OUTPUT := $(OUTPUT)
> @@ -25,6 +25,7 @@ BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
>  LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
>  LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
>  LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
> +LIBBPF_HDRS_DIR := $(LIBBPF_INCLUDE)/bpf
>
>  LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
>  LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
> @@ -32,7 +33,8 @@ LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>
>  # We need to copy nlattr.h which is not otherwise exported by libbpf, but still
>  # required by bpftool.
> -LIBBPF_INTERNAL_HDRS := nlattr.h
> +_LIBBPF_INTERNAL_HDRS := nlattr.h

Felt weird and ugly to have _LIBBPF_INTERNAL_HDRS, so I just inlined it.

> +LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,$(_LIBBPF_INTERNAL_HDRS))
>
>  ifeq ($(BPFTOOL_VERSION),)
>  BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
> @@ -45,10 +47,9 @@ $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
>         $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
>                 DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
>
> -$(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS): \
> -               $(addprefix $(BPF_DIR),$(LIBBPF_INTERNAL_HDRS)) $(LIBBPF)
> -       $(call QUIET_INSTALL, bpf/$(notdir $@))
> -       $(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)$(notdir $@)
> +$(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h $(LIBBPF)
> +       $(call QUIET_INSTALL, $@)
> +       $(Q)install -m 644 -t $(LIBBPF_HDRS_DIR) $<
>
>  $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
>         $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
> @@ -150,7 +151,7 @@ BOOTSTRAP_OBJS = $(addprefix $(BOOTSTRAP_OUTPUT),main.o common.o json_writer.o g
>  $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
>
>  OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
> -$(OBJS): $(LIBBPF) $(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS)
> +$(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
>
>  VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
>                      $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \
> --
> 2.30.2
>
