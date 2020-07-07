Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1404D216352
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgGGB0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGGB0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 21:26:41 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BD1C061755;
        Mon,  6 Jul 2020 18:26:41 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c30so32898263qka.10;
        Mon, 06 Jul 2020 18:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4xqdfLrpFxIxIS6jRVgn6BEI1F3SAijjrL00fECzWc=;
        b=ucReTtDk4WXDHJ4Nh9KGiVsV93iDURg9L0Gi8l3LuaeAhASu+VVU695eVsqEvKNqRQ
         k0qRoa8+PRRJylQMJMgPFsjEcri0c8ciNW/w9KxkC2KggVPJun+7mPZCHDPWvqeYg33q
         vUOoiShyXwYBy47mRR2zXVbdwpKY+M4SSkyCv/P7mfA/xUQ6kU2Fj8k+0uH5Z0Dj76cv
         VHG5xO5chdA+k2g8gEaquxu5i5sV9Q+T6rmYzL2vjJAmz37rtWWkNKN7qukXkBs+a470
         h8je3a5Q5HMjcFdZJt8jE+bPphf+VxYiMd66OY2KzFf7rC4MMqwTYtMwzLzxe3G55rYr
         UayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4xqdfLrpFxIxIS6jRVgn6BEI1F3SAijjrL00fECzWc=;
        b=leo2gOyqyGaDell+uADR0stHV38rXelOO+QqH3C9iwpLvybXC4T4AMP4aYszZ530B1
         2aipnAX6OPAxpdM/1j5tvTWGEgPEZnXzt/YWG/iQD+e31MXImBfQeswE50ZdarciF+65
         DnAzbHgzvVwZ7elLJ2mPZ6vZb9UGpqxs8aRNTqsjbDRyI9lZ/zS2yYwibX4VcoK3SOzZ
         7h3KO+qHoHUjDu8sutlCABDvA9W1qqvSboqp/3H+9xJuyN6ZbXxWcqfZN8kR39HdsVPm
         k7k/h3JvL33RAhpen0WOazh8jRzWgPsjawndUrGsCoroGhwsh8pmgYapQUojultzuOsO
         9L7w==
X-Gm-Message-State: AOAM530c9XhZN68fAhSCKA3mk7fbPTRSl67BOQcFim6iwiQS9e216ilX
        BVNQheJqWHOY0E9Eg++OYidosrR/m+8LU8dG4eY=
X-Google-Smtp-Source: ABdhPJycuUAC8QWgdUN5ilLsksr0M5Q1mcz3AJA3sgqxxxnXmCI1YjJJfIZlmK2COjSeEZJrWheMIs9QBJo+81TIVHQ=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr39832822qkg.437.1594085200271;
 Mon, 06 Jul 2020 18:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-10-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 18:26:28 -0700
Message-ID: <CAEf4BzYuDU2mARcP5GVAv+WiknSnWuzGyNqQx0TiJ23CWA8NiA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 9/9] selftests/bpf: Add test for resolve_btfids
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 2:54 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding resolve_btfids test under test_progs suite.
>
> It's possible to use btf_ids.h header and its logic in
> user space application, so we can add easy test for it.
>
> The test defines BTF_ID_LIST and checks it gets properly
> resolved.
>
> For this reason the test_progs binary (and other binaries
> that use TRUNNER* macros) is processed with resolve_btfids
> tool, which resolves BTF IDs in .BTF.ids section.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/testing/selftests/bpf/Makefile          |  22 ++-
>  .../selftests/bpf/prog_tests/resolve_btfids.c | 170 ++++++++++++++++++
>  2 files changed, 190 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 1f9c696b3edf..b47a685d12bd 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -190,6 +190,16 @@ else
>         cp "$(VMLINUX_H)" $@
>  endif
>
> +$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ)                               \
> +                              $(TOOLSDIR)/bpf/resolve_btfids/main.c    \
> +                              $(TOOLSDIR)/lib/rbtree.c                 \
> +                              $(TOOLSDIR)/lib/zalloc.c                 \
> +                              $(TOOLSDIR)/lib/string.c                 \
> +                              $(TOOLSDIR)/lib/ctype.c                  \
> +                              $(TOOLSDIR)/lib/str_error_r.c
> +       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids \
> +       OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
> +

please indent OUTPUT, so it doesn't look like it's a separate command

>  # Get Clang's default includes on this system, as opposed to those seen by
>  # '-target bpf'. This fixes "missing" files on some architectures/distros,
>  # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> @@ -333,7 +343,8 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:                   \
>                       $(TRUNNER_BPF_SKELS)                              \
>                       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
>         $$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
> -       cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> +       cd $$(@D) && $$(CC) -I. $$(CFLAGS) $(TRUNNER_EXTRA_CFLAGS)      \
> +       -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
>
>  $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:                          \
>                        %.c                                              \
> @@ -355,6 +366,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)                   \
>                              | $(TRUNNER_BINARY)-extras
>         $$(call msg,BINARY,,$$@)
>         $$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
> +       $(TRUNNER_BINARY_EXTRA_CMD)

no need to make this generic, just write out resolve_btfids here explicitly

>
>  endef
>
> @@ -365,7 +377,10 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c     \
>                          network_helpers.c testing_helpers.c            \
>                          flow_dissector_load.h
>  TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read                          \
> -                      $(wildcard progs/btf_dump_test_case_*.c)
> +                      $(wildcard progs/btf_dump_test_case_*.c)         \
> +                      $(SCRATCH_DIR)/resolve_btfids
> +TRUNNER_EXTRA_CFLAGS := -D"BUILD_STR(s)=\#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))"
> +TRUNNER_BINARY_EXTRA_CMD := $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) test_progs

I hope we can get rid of this, see suggestion below.

>  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
>  TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
>  TRUNNER_BPF_LDFLAGS := -mattr=+alu32
> @@ -373,6 +388,7 @@ $(eval $(call DEFINE_TEST_RUNNER,test_progs))
>

[...]

> +
> +static int duration;
> +
> +static struct btf *btf__parse_raw(const char *file)

another copy here...

> +{
> +       struct btf *btf;
> +       struct stat st;
> +       __u8 *buf;
> +       FILE *f;
> +

[...]

> +
> +BTF_ID_LIST(test_list)
> +BTF_ID_UNUSED
> +BTF_ID(typedef, pid_t)
> +BTF_ID(struct,  sk_buff)
> +BTF_ID(union,   thread_union)
> +BTF_ID(func,    memcpy)
> +
> +struct symbol {
> +       const char      *name;
> +       int              type;
> +       int              id;
> +};
> +
> +struct symbol test_symbols[] = {
> +       { "unused",       -1,                0 },

could use BTF_KIND_UNKN here instead of -1

> +       { "pid_t",        BTF_KIND_TYPEDEF, -1 },
> +       { "sk_buff",      BTF_KIND_STRUCT,  -1 },
> +       { "thread_union", BTF_KIND_UNION,   -1 },
> +       { "memcpy",       BTF_KIND_FUNC,    -1 },
> +};
> +

[...]

> +
> +static int resolve_symbols(void)
> +{
> +       const char *path = VMLINUX_BTF;


This build-time parameter passing to find the original VMLINUX_BTF
really sucks, IMO.

Why not use the btf_dump tests approach and have our own small
"vmlinux BTF", which resolve_btfids would use to resolve these IDs?
See how btf_dump_xxx.c files define BTFs that are used in tests. You
can do something similar here, and use a well-known BPF object file as
a source of BTF, both here in a test and in Makefile for --btf param
to resolve_btfids?


> +       struct btf *btf;
> +       int type_id;
> +       __u32 nr;
> +

[...]
