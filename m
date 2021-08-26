Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B323F8ECF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhHZTkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243407AbhHZTkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:40:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=davZ4jO69VIx0sCT213WJQkwOaKgWaD8vJ86ZQWGZFs=;
        b=EEbuN6gDvl6n8eaRYyi+ico4zyJW3SZMAXcCwdAIRxm/ukNvaIFEDIC/cODAVYE85HC+qw
        sPZKys32S5NcC3gD1KiCYBjO1On2uCDTeVtgK4aw3MpqrzK6woigrL1QRRklUFbGtqppbS
        e7wKpd3cLmGRIZnfmeIVWGV6FyqRnig=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-rxq3ZnWHObGDpaGPXXovFw-1; Thu, 26 Aug 2021 15:39:25 -0400
X-MC-Unique: rxq3ZnWHObGDpaGPXXovFw-1
Received: by mail-wr1-f72.google.com with SMTP id b7-20020a5d4d87000000b001575d1053d2so1179191wru.23
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=davZ4jO69VIx0sCT213WJQkwOaKgWaD8vJ86ZQWGZFs=;
        b=NX+WiIoeZH0NmFTHsr0pDexsU62S+1TccuURBLaJqUgNXJw8D+90zKMpuHGquqOyD/
         jVRj7I8MUw53Rc1XjJPh+WcG1LdIXjf4cITeqRRIBoxcyL57KRoe7CGH8eJZrMdlOPtC
         5g01M/WSm2kbzrVUNKyd955j3xN8rgzPbXgHXXwX4omnxVJiEb+8yj3dGeOEvsSuZ5Xy
         JW5cFKfA67YEsitkqC9sPKJLbAiAcAOjIoc4xlmZE+qZEWTRLI6YnvvebPw9V0Xhdajw
         d2DWIwL6yaBK780MiLVIQA+k3uKeBr/WqW9YS8YAHX4TGLAxyiy6+Ym52m/ISRVwKEn+
         eItg==
X-Gm-Message-State: AOAM533E1Dp4HK/oZLYYWGhFJEmt9qNtoXGLBqdrx5HEls3FOxoz+uiA
        MIyfi7ZhW6MmrYG/TzNfUZz4Ro/33LEwr/TLVUxDqmE2MUh/xrF4Z1BkDpsCbj9rGOeN+ITs9Yi
        VNybKwhKyPR6/RihT
X-Received: by 2002:a1c:cc03:: with SMTP id h3mr15598660wmb.73.1630006763767;
        Thu, 26 Aug 2021 12:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrgmTk/4qyF9zL5aMOilhqAuWCBSQ9crSd3zOjH7dhtSo1ThMScn8zvjjsXH3Y7zf7wc977Q==
X-Received: by 2002:a1c:cc03:: with SMTP id h3mr15598640wmb.73.1630006763484;
        Thu, 26 Aug 2021 12:39:23 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id a12sm8091478wmm.42.2021.08.26.12.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:39:23 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 00/27] x86/ftrace/bpf: Add batch support for direct/tracing attach
Date:   Thu, 26 Aug 2021 21:38:55 +0200
Message-Id: <20210826193922.66204-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
sending new version of batch attach support, previous post
is in here [1].

The previous post could not assign multi trampoline on top
of regular trampolines. This patchset is trying to address
that, plus it has other fixes from last post.

This patchset contains:
  1) patches (1-4) that fix the ftrace graph tracing over the function
     with direct trampolines attached
  2) patches (5-8) that add batch interface for ftrace direct function
     register/unregister/modify
  3) patches (9-27) that add support to attach BPF program to multiple
     functions

The current functionality in nutshell:
  - allows to create 'multi trampoline' and use it to attach single
    program over multiple functions
  - it's possible to attach 'multi trampoline' on top of functions
    with attached trampoline
  - once 'multi trampoline' is created, the functions are locked and we:
       - do not allow to attach another 'multi trampoline' that intersects
         partially with already attached multi trampoline
       - do not allow to attach another standard trampoline on any function
         from 'multi trampoline'
       - allow to reuse 'multi trampoline' and attach another multi program
         in it

    These limitations are enforced to keep the implementation simple,
    because having multi trampolines to intersect would bring more
    complexity plus more ftrace direct API changes.

    It'd be probably possible allowing to attach another standard
    trampoline to 'multi trampoline' if needed.

v4 other changes from previous review:
  - more detailed changelogs in several patches
  - removed 'ip' argument assumption in verifier code,
    because we now have bpf_get_func_ip helper
  - moved 'multi_func' under other bools in bpf.h [Yonghong]
  - used static linker in selftests [Andrii]
  - added more tests
  - added btf__find_by_glob_kind for simplified glob matching
    instead of the previous glibc glob matching [Andrii]
  - used '__ksym' instead of resolving test functions [Andrii]
  - I kept the single BPF_F_MULTI_FUNC flag instead of adding
    new multi prog type, because it'd be more complex
  - removed superfluous BPF_PROG_TYPE_TRACING/multi_func check
    from check_multi_prog_type [Yonghong]
  - kept link_create.iter_info_len as BPF_LINK_CREATE_LAST_FIELD
    [Yonghong]
  - define FTRACE_OPS_GRAPH_STUB 0 to make code look sane [Andrii]
  - removed BPF_LINK_UPDATE interface

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/batch

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210605111034.1810858-1-jolsa@kernel.org/

---
Jiri Olsa (25):
      x86/ftrace: Remove extra orig rax move
      tracing: Add trampoline/graph selftest
      ftrace: Add ftrace_add_rec_direct function
      ftrace: Add multi direct register/unregister interface
      ftrace: Add multi direct modify interface
      ftrace/samples: Add multi direct interface test module
      bpf: Add support to load multi func tracing program
      bpf: Add struct bpf_tramp_node layer
      bpf: Factor out bpf_trampoline_init function
      bpf: Factor out __bpf_trampoline_lookup function
      bpf: Factor out __bpf_trampoline_put function
      bpf: Change bpf_trampoline_get to return error pointer
      bpf, x64: Allow to use caller address from stack
      bpf: Add bpf_trampoline_multi_get/put functions
      bpf: Add multi trampoline attach support
      bpf, x64: Store properly return value for trampoline with multi func programs
      bpf: Attach multi trampoline with ftrace_ops
      libbpf: Add btf__find_by_glob_kind function
      libbpf: Add support to link multi func tracing program
      selftests/bpf: Add fentry multi func test
      selftests/bpf: Add fexit multi func test
      selftests/bpf: Add fentry/fexit multi func test
      selftests/bpf: Add mixed multi func test
      selftests/bpf: Add attach multi func test
      selftests/bpf: Add ret_mod multi func test

Steven Rostedt (VMware) (2):
      x86/ftrace: Remove fault protection code in prepare_ftrace_return
      x86/ftrace: Make function graph use ftrace directly

 arch/x86/Makefile                                                |   7 +++
 arch/x86/boot/compressed/Makefile                                |   4 ++
 arch/x86/include/asm/ftrace.h                                    |   9 +++-
 arch/x86/kernel/ftrace.c                                         |  71 +++++++++++++------------
 arch/x86/kernel/ftrace_64.S                                      |  30 +----------
 arch/x86/net/bpf_jit_comp.c                                      |  53 +++++++++++++++----
 drivers/firmware/efi/libstub/Makefile                            |   3 ++
 include/linux/bpf.h                                              |  44 ++++++++++++++--
 include/linux/ftrace.h                                           |  22 ++++++++
 include/uapi/linux/bpf.h                                         |  12 +++++
 kernel/bpf/core.c                                                |   2 +
 kernel/bpf/syscall.c                                             | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/bpf/trampoline.c                                          | 400 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 kernel/bpf/verifier.c                                            |   7 +--
 kernel/trace/fgraph.c                                            |   6 ++-
 kernel/trace/ftrace.c                                            | 214 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 kernel/trace/trace_selftest.c                                    |  49 ++++++++++++++++-
 samples/ftrace/Makefile                                          |   1 +
 samples/ftrace/ftrace-direct-multi.c                             |  52 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                                   |  12 +++++
 tools/lib/bpf/bpf.c                                              |   8 +++
 tools/lib/bpf/bpf.h                                              |   6 ++-
 tools/lib/bpf/btf.c                                              |  80 ++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h                                              |   3 ++
 tools/lib/bpf/libbpf.c                                           |  72 +++++++++++++++++++++++++
 tools/testing/selftests/bpf/Makefile                             |   8 ++-
 tools/testing/selftests/bpf/prog_tests/modify_return.c           | 114 ++++++++++++++++++++++++++++++++++++++--
 tools/testing/selftests/bpf/prog_tests/multi_attach_check_test.c | 115 ++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c |  32 ++++++++++++
 tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c       |  30 +++++++++++
 tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c        |  31 +++++++++++
 tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c        |  34 ++++++++++++
 tools/testing/selftests/bpf/progs/multi_attach_check.c           |  36 +++++++++++++
 tools/testing/selftests/bpf/progs/multi_attach_check_extra1.c    |  12 +++++
 tools/testing/selftests/bpf/progs/multi_attach_check_extra2.c    |  12 +++++
 tools/testing/selftests/bpf/progs/multi_check.c                  |  85 ++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/multi_fentry.c                 |  17 ++++++
 tools/testing/selftests/bpf/progs/multi_fentry_fexit.c           |  28 ++++++++++
 tools/testing/selftests/bpf/progs/multi_fexit.c                  |  20 +++++++
 tools/testing/selftests/bpf/progs/multi_mixed.c                  |  43 +++++++++++++++
 tools/testing/selftests/bpf/progs/multi_modify_return.c          |  17 ++++++
 41 files changed, 1799 insertions(+), 165 deletions(-)
 create mode 100644 samples/ftrace/ftrace-direct-multi.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_attach_check_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach_check_extra1.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach_check_extra2.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fentry.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fentry_fexit.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fexit.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_mixed.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_modify_return.c

