Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9022344688C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhKESlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 14:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbhKESlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 14:41:42 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEB4C061714;
        Fri,  5 Nov 2021 11:39:02 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v138so25016406ybb.8;
        Fri, 05 Nov 2021 11:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=muRMsH1mcsMSZOhj1DDwe0i6rrLFXbtuuonC6NLt3f4=;
        b=CHRyE3fzkXzyxCy0B+viABzD8ZmeNUfQeI6zDk+6WZov2vT5zEuPJfrJPNZLbuLzXq
         sogw/sp4zGOr/cagRsY9ViMwu9SeHSVpVnc7GUKjehuApSxysoEv1kjbi2KzBpCEpxrP
         mYFJ+LnEko0XsgPqaZ/1/ASRhM7s9L1EHm+uLtcHAB8rCKvX+tuLaazmyDI2gcvrunc4
         YuYXf2+6UlTY+MrCOSQnmPigCNsTNHjP3XR1ixKgrFXEJTic2VvTkZxCITGTIQ+/6CEJ
         DVZ7RDpJ4XBgbUIreICwzV1lAiWwalwfukgPW0mYx6Ut89Ex67kdhGVsQf3fI0k1RpJw
         YLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=muRMsH1mcsMSZOhj1DDwe0i6rrLFXbtuuonC6NLt3f4=;
        b=jKgGb5lR1/O/c6BZKG1SC2rb+/nmQKZKwpLkc6anQtzRy6Xu4ITR3Eg/w4Hc2ykzfQ
         fyOwkLJVUBPKrQXmZ5QjZBAiicoIGdnJ26/JB5oOWuinmA5ZIRKM3D1q1Z6HsYzYEGC+
         UL3rkvcGDthF5oRaKiaRccX0/+tk1ccojG5k7kPAey+bFCoheuopruBPVWgw0a52luLt
         rlrQ6m5ZmHsUNeXa/vMmAwY8SXDMieKsyVPGVrf5wemZRgVL5qPkuZ7Db5O2hxfWH7b7
         hBtK+Axq60FhW4vfD7s4J/guF+Ycdhwe9iWx9kgRPNOQbrPoztDsAWot7IXA0Q+b3hh2
         Xlog==
X-Gm-Message-State: AOAM532kT/hPgocqfrRlwlrpJ9N2rEYBDLAMW6sIYLd43g3vBngjXDdR
        vGTrNMN6puvWUqPq6LG4FyV25VrDWdcOc0vt/YcIDbZv
X-Google-Smtp-Source: ABdhPJySCs+hNkr88RuBfZRy1pXFERF52pnRtTde7PL7HIvBDL8qL0MckVhMoMC/D/cLfcZ4PTJT5tSpdhvXHXYV/RY=
X-Received: by 2002:a25:d010:: with SMTP id h16mr59087873ybg.225.1636137541773;
 Fri, 05 Nov 2021 11:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211105020244.6869-1-quentin@isovalent.com>
In-Reply-To: <20211105020244.6869-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Nov 2021 11:38:50 -0700
Message-ID: <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] perf build: Install libbpf headers locally when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 7:02 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> API headers from libbpf should not be accessed directly from the
> library's source directory. Instead, they should be exported with "make
> install_headers". Let's adjust perf's Makefile to install those headers
> locally when building libbpf.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
> Note: Sending to bpf-next because it's directly related to libbpf, and
> to similar patches merged through bpf-next, but maybe Arnaldo prefers to
> take it?

Arnaldo would know better how to thoroughly test it, so I'd prefer to
route this through perf tree. Any objections, Arnaldo?

> ---
>  tools/perf/Makefile.perf | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index b856afa6eb52..3a81b6c712a9 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -241,7 +241,7 @@ else # force_fixdep
>
>  LIB_DIR         = $(srctree)/tools/lib/api/
>  TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
> -BPF_DIR         = $(srctree)/tools/lib/bpf/
> +LIBBPF_DIR      = $(srctree)/tools/lib/bpf/
>  SUBCMD_DIR      = $(srctree)/tools/lib/subcmd/
>  LIBPERF_DIR     = $(srctree)/tools/lib/perf/
>  DOC_DIR         = $(srctree)/tools/perf/Documentation/
> @@ -293,7 +293,6 @@ strip-libs = $(filter-out -l%,$(1))
>  ifneq ($(OUTPUT),)
>    TE_PATH=$(OUTPUT)
>    PLUGINS_PATH=$(OUTPUT)
> -  BPF_PATH=$(OUTPUT)
>    SUBCMD_PATH=$(OUTPUT)
>    LIBPERF_PATH=$(OUTPUT)
>  ifneq ($(subdir),)
> @@ -305,7 +304,6 @@ else
>    TE_PATH=$(TRACE_EVENT_DIR)
>    PLUGINS_PATH=$(TRACE_EVENT_DIR)plugins/
>    API_PATH=$(LIB_DIR)
> -  BPF_PATH=$(BPF_DIR)
>    SUBCMD_PATH=$(SUBCMD_DIR)
>    LIBPERF_PATH=$(LIBPERF_DIR)
>  endif
> @@ -324,7 +322,10 @@ LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS = $(if $(findstring -static,$(LDFLAGS)),,$(DY
>  LIBAPI = $(API_PATH)libapi.a
>  export LIBAPI
>
> -LIBBPF = $(BPF_PATH)libbpf.a
> +LIBBPF_OUTPUT = $(OUTPUT)libbpf
> +LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
> +LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
> +LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
>
>  LIBSUBCMD = $(SUBCMD_PATH)libsubcmd.a
>
> @@ -829,12 +830,14 @@ $(LIBAPI)-clean:
>         $(call QUIET_CLEAN, libapi)
>         $(Q)$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
>
> -$(LIBBPF): FORCE
> -       $(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) $(OUTPUT)libbpf.a FEATURES_DUMP=$(FEATURE_DUMP_EXPORT)
> +$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
> +       $(Q)$(MAKE) -C $(LIBBPF_DIR) FEATURES_DUMP=$(FEATURE_DUMP_EXPORT) \
> +               O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
> +               $@ install_headers
>
>  $(LIBBPF)-clean:
>         $(call QUIET_CLEAN, libbpf)
> -       $(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) clean >/dev/null
> +       $(Q)$(RM) -r -- $(LIBBPF_OUTPUT)
>
>  $(LIBPERF): FORCE
>         $(Q)$(MAKE) -C $(LIBPERF_DIR) EXTRA_CFLAGS="$(LIBPERF_CFLAGS)" O=$(OUTPUT) $(OUTPUT)libperf.a
> @@ -1036,14 +1039,13 @@ SKELETONS += $(SKEL_OUT)/bperf_cgroup.skel.h
>
>  ifdef BUILD_BPF_SKEL
>  BPFTOOL := $(SKEL_TMP_OUT)/bootstrap/bpftool
> -LIBBPF_SRC := $(abspath ../lib/bpf)
> -BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(BPF_PATH) -I$(LIBBPF_SRC)/..
> +BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(LIBBPF_INCLUDE)
>
> -$(SKEL_TMP_OUT):
> +$(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
>         $(Q)$(MKDIR) -p $@
>
>  $(BPFTOOL): | $(SKEL_TMP_OUT)
> -       CFLAGS= $(MAKE) -C ../bpf/bpftool \
> +       $(Q)CFLAGS= $(MAKE) -C ../bpf/bpftool \
>                 OUTPUT=$(SKEL_TMP_OUT)/ bootstrap
>
>  VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
> --
> 2.32.0
>
