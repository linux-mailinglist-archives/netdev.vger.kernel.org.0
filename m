Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5433046DC44
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbhLHTg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:36:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239595AbhLHTgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638991972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rfKb97MY2LoauqiuW+A+PPQUdGoftCNQSgBEkDbYCMw=;
        b=cVa7FPO/FM/YQTHcUrWEQZRmxOEntPIDj+eUkPjDU6wmKtfUiKT9MDl/yJDXHvGmvdLibi
        ARIBrCtN0nYZtiATlCnrw8KNY3fnbbSqAbQz/iuSdsJPBkGD70OCF1zbE0mFv1PKZtzOqU
        JLpLsZiTrwCmGlAnY26z+nRWY5ZCsl4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-kVZymXnGMcaG04Pvjf9bGw-1; Wed, 08 Dec 2021 14:32:49 -0500
X-MC-Unique: kVZymXnGMcaG04Pvjf9bGw-1
Received: by mail-wm1-f69.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so1804953wmb.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 11:32:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rfKb97MY2LoauqiuW+A+PPQUdGoftCNQSgBEkDbYCMw=;
        b=00w1r1j+HGfL8jl1r8DxQqN9JJVghkyl+42M4y8jbj0iMBQADpTvkbgmBxBIMmYRX+
         /leAnoO+kdojaNx0beC9Y1gjxWvRuCcN98pGT4SEfXGt9C1DDWMe85OTOjA8ROmd0/jP
         30FgbJEjs19qgAlVolFs/1mX5ME3+cVFzFtnnukUchWkCq+GUJPqrdkvzEoBJwhaXIXv
         9Uj5yX6lQWrrovYrbxEbT8bO67DqD/1gr48WJolB5LWMJXygJyJfIkWP4J7+4aXbDFVw
         DM7okjaLB9AYshr1X+oNxwduTd4mcnOThd118SIaeeMUCnVbyUpdmNdUwXRtHY0HZITl
         XubQ==
X-Gm-Message-State: AOAM533TK4nqKtBTo6Zmtchy4uGiqfnEtO0Qh7N4MSBZ8/huvPoUHbTe
        6bsFXMJ3gAgTH9cCqXWZkd2wDA8Ycrt3BBhrjw4f/XUZjyHcrVTUGcGpQ821PCyd1WySx5Xsyc4
        LkkYwgl4w4RG9VB2U
X-Received: by 2002:a5d:6d09:: with SMTP id e9mr797295wrq.17.1638991968112;
        Wed, 08 Dec 2021 11:32:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWkUS4YGY+iAOqtR1FNKCFzOtgPbiRNgPR3VxzgMbBbCLFD5TvRrjwaUmrgdDG4ZeMj5Og4Q==
X-Received: by 2002:a5d:6d09:: with SMTP id e9mr797261wrq.17.1638991967827;
        Wed, 08 Dec 2021 11:32:47 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id m21sm3472125wrb.2.2021.12.08.11.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:32:47 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next 0/5] bpf: Add helpers to access traced function arguments
Date:   Wed,  8 Dec 2021 20:32:40 +0100
Message-Id: <20211208193245.172141-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding new helpers to access traced function arguments that
came out of the trampoline batch changes [1].

  Get n-th argument of the traced function:
    long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
  
  Get return value of the traced function:
    long bpf_get_func_ret(void *ctx, u64 *value)
  
  Get arguments count of the traced funtion:
    long bpf_get_func_arg_cnt(void *ctx)

v2 changes:
  - added acks
  - updated stack diagram
  - return -EOPNOTSUPP instead of -EINVAL in bpf_get_func_ret
  - removed gpl_only for all helpers
  - added verifier fix to allow proper arguments checks,
    Andrii asked for checking also 'int *b' argument in
    bpf_modify_return_test programs and it turned out that it's currently
    not supported by verifier - we can't read argument that is int pointer,
    so I had to add verifier change to allow that + adding verifier selftest
  - checking all arguments in bpf_modify_return_test test programs
  - moved helpers proto gets in tracing_prog_func_proto with attach type check

thanks,
jirka


[1] https://lore.kernel.org/bpf/20211118112455.475349-1-jolsa@kernel.org/
---
Jiri Olsa (5):
      bpf: Allow access to int pointer arguments in tracing programs
      selftests/bpf: Add test to access int ptr argument in tracing program
      bpf, x64: Replace some stack_size usage with offset variables
      bpf: Add get_func_[arg|ret|arg_cnt] helpers
      selftests/bpf: Add tests for get_func_[arg|ret|arg_cnt] helpers

 arch/x86/net/bpf_jit_comp.c                                 |  55 ++++++++++++++++++++++++++++++-----------
 include/linux/bpf.h                                         |   5 ++++
 include/uapi/linux/bpf.h                                    |  28 +++++++++++++++++++++
 kernel/bpf/btf.c                                            |   7 +++---
 kernel/bpf/trampoline.c                                     |   8 ++++++
 kernel/bpf/verifier.c                                       |  77 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/trace/bpf_trace.c                                    |  55 ++++++++++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h                              |  28 +++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c |  44 +++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/get_func_args_test.c      | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/btf_ctx_access.c       |  12 +++++++++
 11 files changed, 418 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/verifier/btf_ctx_access.c

