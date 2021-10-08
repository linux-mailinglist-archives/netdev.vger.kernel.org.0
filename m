Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02AA427144
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 21:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241662AbhJHTPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 15:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241543AbhJHTPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 15:15:30 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD30C061570;
        Fri,  8 Oct 2021 12:13:34 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id u32so23227128ybd.9;
        Fri, 08 Oct 2021 12:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o9RBZBcLbLpsJfK9hX/mnshiLsPM5FtUw5WlCv2yvag=;
        b=n2TkT57tNmqou3Ke0M4YMyPwVbVSBrhl1RGnebwhd6nb8B8gdO/42s6VNth/2Zip/3
         aqxu1D6PVkGcyhegzOBvVB4qhW9Ue6rxJ9uyh+WHmq4UtYB+HKB3sib46diehJ9UTDrt
         OOfcvpVWxSn3ndDHuwYTzlWlTZc/xn98MlgoL/F3RUdcXUjN30KVLjhzUHBaYoJW23qu
         sRP9Qjt3gqZiYKOOMB69KVHa5yzEP8Rrj6saTPEyMTkU5YkCGHYoK6LPhNOD8u3KnRAZ
         tn94JH6tzFUwY0K5zEJ1PRNS5RehS4wHCkBpma/FCi6bvPr8+GxngLbwv5Rlr5Ccy7D9
         D8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o9RBZBcLbLpsJfK9hX/mnshiLsPM5FtUw5WlCv2yvag=;
        b=H1lbCcSQFEm2A4x6wIMdaMkSAcQVPRAMG6Tm0f+YnhiEyTFc8Vqp2tj5g/0PAWbFRW
         3Qqd66G3UxjTtOO1Do8PqdCS4JE3xf4gAWs6titRZCf//NYEdva3ligrS9iQqp8jsZ2I
         nCSna1QLM0cSgddTDiOipHprt7GaUgXznOZESu0tE1KTSd2tNXQxeH+4R95Tr4RUNHDT
         drEl3dcBYQsQzJboCeXOSCGgzwe5eDGufw2+BxFe2LJX8CebCMrJF8LJ74PUdM+Gv6HC
         gyRg8iD7pOw1wdiS8rRl9RyWkKizS1E9NbAerpfcUbhI0KkH5wVWFtEQJrNDpSnaIqkz
         JCkg==
X-Gm-Message-State: AOAM532RA5ruBxIiQUTJQOEaNHn2vMtFLho6i65w5EiX6vwm7P3wu26D
        RnXquLQAsiwdmuvmN9OJTrhAlOEGOLf9N9MuR20=
X-Google-Smtp-Source: ABdhPJyRyNQFOPlorcM1R/ZBeWBQfal4dt6tEYnnzrXFKg3EtAxNjyVGaORF6kks4TIAQO1LFjIwXx0pq+m1lcJEXpQ=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr4891035ybj.433.1633720414040;
 Fri, 08 Oct 2021 12:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211007194438.34443-1-quentin@isovalent.com> <20211007194438.34443-4-quentin@isovalent.com>
In-Reply-To: <20211007194438.34443-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Oct 2021 12:13:22 -0700
Message-ID: <CAEf4BzZF2Tmxr3peNQ6AgpXTjTs+g8U2aYw7pR+uMxXNETMTtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/12] bpftool: install libbpf headers instead
 of including the dir
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 12:44 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool relies on libbpf, therefore it relies on a number of headers
> from the library and must be linked against the library. The Makefile
> for bpftool exposes these objects by adding tools/lib as an include
> directory ("-I$(srctree)/tools/lib"). This is a working solution, but
> this is not the cleanest one. The risk is to involuntarily include
> objects that are not intended to be exposed by the libbpf.
>
> The headers needed to compile bpftool should in fact be "installed" from
> libbpf, with its "install_headers" Makefile target. In addition, there
> is one header which is internal to the library and not supposed to be
> used by external applications, but that bpftool uses anyway.
>
> Adjust the Makefile in order to install the header files properly before
> compiling bpftool. Also copy the additional internal header file
> (nlattr.h), but call it out explicitly. Build (and install headers) in a
> subdirectory under bpftool/ instead of tools/lib/bpf/. When descending
> from a parent Makefile, this is configurable by setting the OUTPUT,
> LIBBPF_OUTPUT and LIBBPF_DESTDIR variables.
>
> Also adjust the Makefile for BPF selftests, so as to reuse the (host)
> libbpf compiled earlier and to avoid compiling a separate version of the
> library just for bpftool.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/bpf/bpftool/Makefile           | 33 ++++++++++++++++++----------
>  tools/testing/selftests/bpf/Makefile |  2 ++
>  2 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 1fcf5b01a193..ba02d71c39ef 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -17,19 +17,23 @@ endif
>  BPF_DIR = $(srctree)/tools/lib/bpf/
>
>  ifneq ($(OUTPUT),)
> -  LIBBPF_OUTPUT = $(OUTPUT)/libbpf/
> -  LIBBPF_PATH = $(LIBBPF_OUTPUT)
> -  BOOTSTRAP_OUTPUT = $(OUTPUT)/bootstrap/
> +  _OUTPUT := $(OUTPUT)
>  else
> -  LIBBPF_OUTPUT =
> -  LIBBPF_PATH = $(BPF_DIR)
> -  BOOTSTRAP_OUTPUT = $(CURDIR)/bootstrap/
> +  _OUTPUT := $(CURDIR)
>  endif
> +BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
> +LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
> +LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
> +LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
>
> -LIBBPF = $(LIBBPF_PATH)libbpf.a
> +LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
>  LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
>  LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>
> +# We need to copy nlattr.h which is not otherwise exported by libbpf, but still
> +# required by bpftool.
> +LIBBPF_INTERNAL_HDRS := nlattr.h
> +
>  ifeq ($(BPFTOOL_VERSION),)
>  BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
>  endif
> @@ -38,7 +42,13 @@ $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT):
>         $(QUIET_MKDIR)mkdir -p $@
>
>  $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
> -       $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) $(LIBBPF_OUTPUT)libbpf.a
> +       $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
> +               DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
> +
> +$(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS): \

This worked only because LIBBPF_INTERNAL_HDRS is a single element list
right now. I didn't touch it for now, but please follow up with a
proper fix (you'd need to do % magic here)

> +               $(addprefix $(BPF_DIR),$(LIBBPF_INTERNAL_HDRS)) $(LIBBPF)
> +       $(call QUIET_INSTALL, bpf/$(notdir $@))
> +       $(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)$(notdir $@)
>
>  $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
>         $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
> @@ -60,10 +70,10 @@ CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
>  CFLAGS += $(filter-out -Wswitch-enum -Wnested-externs,$(EXTRA_WARNINGS))
>  CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
>         -I$(if $(OUTPUT),$(OUTPUT),.) \
> +       -I$(LIBBPF_INCLUDE) \
>         -I$(srctree)/kernel/bpf/ \
>         -I$(srctree)/tools/include \
>         -I$(srctree)/tools/include/uapi \
> -       -I$(srctree)/tools/lib \
>         -I$(srctree)/tools/perf
>  CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
>  ifneq ($(EXTRA_CFLAGS),)
> @@ -140,7 +150,7 @@ BOOTSTRAP_OBJS = $(addprefix $(BOOTSTRAP_OUTPUT),main.o common.o json_writer.o g
>  $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
>
>  OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
> -$(OBJS): $(LIBBPF)
> +$(OBJS): $(LIBBPF) $(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS)

the whole $(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS) use in
multiple places might benefit from having a dedicated variable


>
>  VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
>                      $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \
> @@ -167,8 +177,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
>         $(QUIET_CLANG)$(CLANG) \
>                 -I$(if $(OUTPUT),$(OUTPUT),.) \
>                 -I$(srctree)/tools/include/uapi/ \
> -               -I$(LIBBPF_PATH) \
> -               -I$(srctree)/tools/lib \
> +               -I$(LIBBPF_INCLUDE) \
>                 -g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
>
>  $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index c5c9a9f50d8d..849a4637f59d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -209,6 +209,8 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
>                     CC=$(HOSTCC) LD=$(HOSTLD)                                  \
>                     EXTRA_CFLAGS='-g -O0'                                      \
>                     OUTPUT=$(HOST_BUILD_DIR)/bpftool/                          \
> +                   LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/                    \
> +                   LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/                        \
>                     prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
>
>  all: docs
> --
> 2.30.2
>
