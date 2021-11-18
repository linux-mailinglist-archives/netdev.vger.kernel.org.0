Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032DF455A21
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343699AbhKRL2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343807AbhKRL2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZxrU+YdlzdoK9MwbrDEtnXiUcR0OkL5aLQFUj4RP96M=;
        b=H+gtDUqrNFkiSYvhtr5AtNQSzYHg4Br6CCGVVPj26+QhXiJ6smjh6m+Slw7KQmQmoFcyQx
        6r2ymArKlva0at6vVOCaXsEbUtY/78ZKx6PDDe5bvGEcAK4ZXol/Vf885DwBli8isqqXkb
        PvDUnxBOod86USgyqSrDL1GPaOiTcUk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-6GeNkAMWNLKt8M7CXAhN2Q-1; Thu, 18 Nov 2021 06:24:58 -0500
X-MC-Unique: 6GeNkAMWNLKt8M7CXAhN2Q-1
Received: by mail-ed1-f71.google.com with SMTP id i19-20020a05640242d300b003e7d13ebeedso4995316edc.7
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZxrU+YdlzdoK9MwbrDEtnXiUcR0OkL5aLQFUj4RP96M=;
        b=X24NuR0/QafXrPgxsbs9uuG/dk9ySIjKH2y9O0o1whnltCyHNag/IL1pJUuyRRElVX
         1FzRlem+DGr4dbXRFlpBIYYyYQpVPSyWK+oDpm9gbONMGZyVAVyo37j7xVhxSFqVzuql
         ucOxPdVMGfnyDulOB7neOhins4lUp1zHqmWjkbtWMYQwEYuP5cays/aSdVvALDOx15rG
         MW5DpBlxUSqWu+p+BbbszmE7g20VUyNbkex48pKXoUX/JM4iqLIJJUgnDtYBBQ7+fGoV
         Z5ybsL6O2AVp5KSeAOj0OpjTfNbx+x1L2q0owToq/1dXKF166X9vbbDEnLdO9KwuknDU
         eUaA==
X-Gm-Message-State: AOAM531ZcILoySeA6EXiW5VywQlf8q/A6AbqsD8pejdbcK7sHF/NA5qZ
        MkR/3Gim2vQHsrX+roqy221PzbkOGPVyx9mByhhQGGjkIO6M9BKBEUs6lGLphL9qS4R0pN3zi2n
        bXrPUm2pT0+c7Vlqk
X-Received: by 2002:a17:906:7951:: with SMTP id l17mr32406000ejo.284.1637234697172;
        Thu, 18 Nov 2021 03:24:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1jBWluEfOkRv0RU793HSUUfqq0SJBCZSfZque6kDo4eh9az4prr608fExDmItOCEOF335Rw==
X-Received: by 2002:a17:906:7951:: with SMTP id l17mr32405959ejo.284.1637234696948;
        Thu, 18 Nov 2021 03:24:56 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id he17sm1131074ejc.110.2021.11.18.03.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:24:56 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Steven Rostedt <srostedt@vmware.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next v5 00/29] bpf: Add batch support for attaching trampolines
Date:   Thu, 18 Nov 2021 12:24:26 +0100
Message-Id: <20211118112455.475349-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
sending new version of batch attach support, previous post is in
here [1].

As discussed in previous post adding this version is adding generic
approach to attach program to multiple functions, meaning you are
now able to attach multiple trampolines on top of each other with
no limitations, which was not possible in previous version.

v5 changes:
  - ftrace new direct batch api got merged, so it's not longer
    part of this patchset (thanks Steven!), adding just few small
    related fixes 
  - added code that allows attach trampolines on top of each other
    as per previous version comments
  - fixed btf__find_by_glob_kind as per Andrii's comments
  - added new selftest to check on the trampoline's splitting
  - added in bpf_arg/bpf_ret_value helpers with tests

I'm not completely sure about the approach, because it was quite
difficult to debug/finalize, but I can't think of anything better
for now.. so sending this as RFC ;)

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/batch

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210826193922.66204-1-jolsa@kernel.org/
Cc: Steven Rostedt <srostedt@vmware.com>
---
Jiri Olsa (29):
      ftrace: Use direct_ops hash in unregister_ftrace_direct
      ftrace: Add cleanup to unregister_ftrace_direct_multi
      ftrace: Add ftrace_set_filter_ips function
      bpf: Factor bpf_check_attach_target function
      bpf: Add bpf_check_attach_model function
      bpf: Add bpf_arg/bpf_ret_value helpers for tracing programs
      bpf, x64: Allow to use caller address from stack
      bpf: Keep active attached trampoline in bpf_prog
      bpf: Add support to load multi func tracing program
      bpf: Add bpf_trampoline_id object
      bpf: Add addr to bpf_trampoline_id object
      bpf: Add struct bpf_tramp_node layer
      bpf: Add bpf_tramp_attach layer for trampoline attachment
      bpf: Add support to store multiple ids in bpf_tramp_id object
      bpf: Add support to store multiple addrs in bpf_tramp_id object
      bpf: Add bpf_tramp_id_single function
      bpf: Resolve id in bpf_tramp_id_single
      bpf: Add refcount_t to struct bpf_tramp_id
      bpf: Add support to attach trampolines with multiple IDs
      bpf: Add support for tracing multi link
      libbpf: Add btf__find_by_glob_kind function
      libbpf: Add support to link multi func tracing program
      selftests/bpf: Add bpf_arg/bpf_ret_value test
      selftests/bpf: Add fentry multi func test
      selftests/bpf: Add fexit multi func test
      selftests/bpf: Add fentry/fexit multi func test
      selftests/bpf: Add mixed multi func test
      selftests/bpf: Add ret_mod multi func test
      selftests/bpf: Add attach multi func test

 arch/x86/net/bpf_jit_comp.c                                      |  31 ++-
 include/linux/bpf.h                                              |  76 +++++--
 include/linux/bpf_verifier.h                                     |  23 +--
 include/linux/ftrace.h                                           |   3 +
 include/uapi/linux/bpf.h                                         |  26 +++
 kernel/bpf/core.c                                                |   4 +-
 kernel/bpf/syscall.c                                             | 379 +++++++++++++++++++++++++++++++----
 kernel/bpf/trampoline.c                                          | 926 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c                                            | 173 +++++++++++++---
 kernel/kallsyms.c                                                |   2 +-
 kernel/trace/bpf_trace.c                                         |  38 +++-
 kernel/trace/ftrace.c                                            |  61 +++++-
 tools/include/uapi/linux/bpf.h                                   |  26 +++
 tools/lib/bpf/bpf.c                                              |   7 +
 tools/lib/bpf/bpf.h                                              |   6 +-
 tools/lib/bpf/btf.c                                              |  77 ++++++++
 tools/lib/bpf/btf.h                                              |   3 +
 tools/lib/bpf/libbpf.c                                           |  66 +++++++
 tools/testing/selftests/bpf/Makefile                             |  10 +-
 tools/testing/selftests/bpf/prog_tests/args_test.c               |  34 ++++
 tools/testing/selftests/bpf/prog_tests/modify_return.c           | 114 ++++++++++-
 tools/testing/selftests/bpf/prog_tests/multi_attach_test.c       | 176 +++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c |  32 +++
 tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c       |  30 +++
 tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c        |  31 +++
 tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c        |  34 ++++
 tools/testing/selftests/bpf/progs/args_test.c                    |  30 +++
 tools/testing/selftests/bpf/progs/multi_attach.c                 | 105 ++++++++++
 tools/testing/selftests/bpf/progs/multi_check.c                  |  86 ++++++++
 tools/testing/selftests/bpf/progs/multi_fentry.c                 |  17 ++
 tools/testing/selftests/bpf/progs/multi_fentry_fexit.c           |  28 +++
 tools/testing/selftests/bpf/progs/multi_fexit.c                  |  20 ++
 tools/testing/selftests/bpf/progs/multi_mixed.c                  |  43 ++++
 tools/testing/selftests/bpf/progs/multi_modify_return.c          |  17 ++
 34 files changed, 2539 insertions(+), 195 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/args_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_attach_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/args_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fentry.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fentry_fexit.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fexit.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_mixed.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_modify_return.c

