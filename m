Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9603BF073
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhGGTtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:49:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231721AbhGGTtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625687184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=08TrtkuSWJk38qiu/d57f1LF0OJ3zMr5MSSzzSnYovc=;
        b=PevONGMs6nf+T8kNY/GkwmAX16+RotjzhFfbc6qlXnfyR/L8O7Mu1He9LI/TLnhxnhxjho
        3ZiBtEAUFJthg8XcS7uEmFKicTm2EUVjdGTqA2M6hFRBLwEIx9TO5HdTB27YaTtzBZ0p/Z
        TcBAjaRoyJySF1RWoezhK5jdVNTPzIA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-h5TJYSQfNoS14HjiyOlmzw-1; Wed, 07 Jul 2021 15:46:23 -0400
X-MC-Unique: h5TJYSQfNoS14HjiyOlmzw-1
Received: by mail-wm1-f72.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so1394466wmh.9
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=08TrtkuSWJk38qiu/d57f1LF0OJ3zMr5MSSzzSnYovc=;
        b=OQU0zTzJ8eISbmBTOUcfT1JC/C0O+7kcA4CBXt7Bc4P08M1YsUfMLXW0NAQTAh5y9u
         Y5PQS2mwt4CpWC6g9vceDVFomZqMAaandEK1zmXFlA7jO3uu7l8ttwO0WUm3S7+zJ3QX
         be9q+jfYPEnudf97ObzFcnRxWNwl0RBiFoyPHJ4WbCnUFeFLrCqK2ZntqlJt5qqX1p6A
         6tYRaC69BiI2rrQOos+gG0G6WjBV+XpL34n5UY0ncupUSJmW5PxTwpzZkEHZvMKRdR4J
         +Atarc3FyJiQXHzL3wrNsrKFtZLaUdYH0OJ6EuZ2OHlBQTN/lQ9/NmnT/qXfIpTJLsRX
         p3yA==
X-Gm-Message-State: AOAM532JinzABj4oMDbDAhJxgRRILcMMqzpKGuUfpOVP8YV5PlSLGFRv
        1RPgq+sk8GL+hB/ynUyUExAlIb+2sWqVCZ+Vjr7RHc/Aeqk0WpEqQyuaqZvyBVMeNR/c/ZzJMnr
        bMGKlYTdCboaYlcfd
X-Received: by 2002:a5d:414f:: with SMTP id c15mr29172691wrq.86.1625687182491;
        Wed, 07 Jul 2021 12:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXtPRDXNkj6nVCUBWyGW9bk0IUrqAXUV690UhnJ9d4u/a+ANSYzGBGJI64FXaWjkgf2smWsw==
X-Received: by 2002:a5d:414f:: with SMTP id c15mr29172668wrq.86.1625687182357;
        Wed, 07 Jul 2021 12:46:22 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id c16sm19415143wmr.2.2021.07.07.12.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:46:22 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv2 bpf-next 0/7] bpf, x86: Add bpf_get_func_ip helper
Date:   Wed,  7 Jul 2021 21:46:12 +0200
Message-Id: <20210707194619.151676-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding bpf_get_func_ip helper that returns IP address of the
caller function for trampoline and krobe programs.

There're 2 specific implementation of the bpf_get_func_ip
helper, one for trampoline progs and one for kprobe/kretprobe
progs.

The trampoline helper call is replaced/inlined by verifier
with simple move instruction. The kprobe/kretprobe is actual
helper call that returns prepared caller address.

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/get_func_ip

v2 changes:
  - use kprobe_running to get kprobe instead of cpu var [Masami]
  - added support to add kprobe on function+offset
    and test for that [Alan]

thanks,
jirka


---
Alan Maguire (1):
      libbpf: allow specification of "kprobe/function+offset"

Jiri Olsa (6):
      bpf, x86: Store caller's ip in trampoline stack
      bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
      bpf: Add bpf_get_func_ip helper for tracing programs
      bpf: Add bpf_get_func_ip helper for kprobe programs
      selftests/bpf: Add test for bpf_get_func_ip helper
      selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe

 arch/x86/net/bpf_jit_comp.c                               | 19 +++++++++++++++++++
 include/linux/bpf.h                                       |  5 +++++
 include/linux/filter.h                                    |  3 ++-
 include/uapi/linux/bpf.h                                  |  7 +++++++
 kernel/bpf/trampoline.c                                   | 12 +++++++++---
 kernel/bpf/verifier.c                                     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c                                  | 32 ++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h                            |  7 +++++++
 tools/lib/bpf/libbpf.c                                    | 20 +++++++++++++++++---
 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/get_func_ip_test.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 270 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c

