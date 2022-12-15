Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD764DA83
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLOLjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLOLjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:39:43 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D69E4D;
        Thu, 15 Dec 2022 03:39:42 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c13so6505573pfp.5;
        Thu, 15 Dec 2022 03:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3feiUJRcWkw3+MvorCvuCEkYlGyhazUww4fEkrOO838=;
        b=Vd8dHJdOzbmr637O9yVZWHB0l1SjFri3mG3muoJZOQc/qeud8Eodygd7RZ6TXI75uV
         R4az99p/N45sdEnCj/qZEmSMv+zaOlbopN8xUtQMQFHk/9dQNTx6f7ZZC6TMyOTEdXxy
         5hvMw/ma1K7kS1zcGJ4ixgPSqkOUzWdUWW2pk7f7xtLxic8QpiOlvXxv8pZ1ajuf1cJZ
         VTE25/K3Wb4mEDZoCh66QgbGJf3NMx0HiqHFCrA6YI4rYPuuyZYruzOwM9UX/5HMmx/p
         woOF/w1TZa34lddAEs+qMlhmHS6vYUHFFzcC/JoaFanwODJb9/SKp9wLWI+pan7JnsJQ
         wQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3feiUJRcWkw3+MvorCvuCEkYlGyhazUww4fEkrOO838=;
        b=Rdd4pyERm4SzMc43oE1+F0/s0Xj1sintu5Pi86Gm7pmXFyX9rnCB6kve+o4ezoJFNg
         PS59I/h5di//Tp0YyLvH3kxPOZmdhkZR5IjlxHxUOr1ipuaLtcW6A686SIwyrjYk0lpK
         MHsZgUOQmFIWC8rU/L6OVkieCsdQrWuk8HUiZuDKEr9eYw88wfG93HJrhY9LViRmG62r
         qHCPSkvw0TnNvCALy4dGR4IEEG8q6kpUKqKP8ug4sUa89fnuMUEgSrURZ3BVJ2lCBw2B
         X/P5uvoSxQXPI50msutPyIIVxu5RHQoXKfqso3lFQO+zq0zhx9diveGw6U3MwMqUu4U1
         CLdQ==
X-Gm-Message-State: ANoB5pnk1IqzCkGYcyZdeaDLcICjzVaHT0AMTh+F6uznGJQ7YA6FojS3
        QgoEhKoOWf8xgNbyb+d7tqBPBNWOCVzD
X-Google-Smtp-Source: AA0mqf5H0frJ0un3kLdD2FidtEiFq9V15NP9R1pz8fFFADKR243Irw3DAnFD2cIhpv/dhtZpK0UMwA==
X-Received: by 2002:a62:17d5:0:b0:577:2a9:ec82 with SMTP id 204-20020a6217d5000000b0057702a9ec82mr25744590pfx.5.1671104381631;
        Thu, 15 Dec 2022 03:39:41 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id g30-20020aa79dde000000b00574d38f4d37sm1553440pfq.45.2022.12.15.03.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 03:39:41 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 0/5] samples: bpf: enhance syscall tracing program
Date:   Thu, 15 Dec 2022 20:39:32 +0900
Message-Id: <20221215113937.113936-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syscall tracing using kprobe is quite unstable. Since it uses the exact
name of the kernel function, the program might broke due to the rename
of a function. The problem can also be caused by a changes in the
arguments of the function to which the kprobe connects. This commit
enhances syscall tracing program with the following instruments. 

In this patchset, ksyscall is used instead of kprobe. By using
ksyscall, libbpf will detect the appropriate kernel function name.
(e.g. sys_write -> __s390_sys_write). This eliminates the need to worry
about which wrapper function to attach in order to parse arguments.
Also ksyscall provides more fine method with attaching system call, the
coarse SYSCALL helper at trace_common.h can be removed.

Next, BPF_SYSCALL is used to reduce the inconvenience of parsing
arguments. Since the nature of SYSCALL_WRAPPER function wraps the
argument once, additional process of argument extraction is required
to properly parse the argument. The BPF_SYSCALL macro will reduces the
hassle of parsing arguments from pt_regs.

Lastly, vmlinux.h is applied to syscall tracing program. This change
allows the bpf program to refer to the internal structure as a single
"vmlinux.h" instead of including each header referenced by the bpf
program.

Additionally, this patchset changes the suffix of _kern to .bpf to make
use of the new compile rule (CLANG-BPF) which is more simple and neat.
By just changing the _kern suffix to .bpf will inherit the benefit of
the new CLANG-BPF compile target.

Daniel T. Lee (5):
  samples: bpf: use kyscall instead of kprobe in syscall tracing program
  samples: bpf: use vmlinux.h instead of implicit headers in syscall
    tracing program
  samples: bpf: change _kern suffix to .bpf with syscall tracing program
  samples: bpf: fix tracex2 by using BPF_KSYSCALL macro
  samples: bpf: use BPF_KSYSCALL macro in syscall tracing programs

 samples/bpf/Makefile                          | 10 ++--
 ...p_perf_test_kern.c => map_perf_test.bpf.c} | 48 ++++++++-----------
 samples/bpf/map_perf_test_user.c              |  2 +-
 ...c => test_current_task_under_cgroup.bpf.c} | 11 ++---
 .../bpf/test_current_task_under_cgroup_user.c |  2 +-
 samples/bpf/test_map_in_map_kern.c            |  1 -
 ...ser_kern.c => test_probe_write_user.bpf.c} | 20 ++++----
 samples/bpf/test_probe_write_user_user.c      |  2 +-
 samples/bpf/trace_common.h                    | 13 -----
 ...trace_output_kern.c => trace_output.bpf.c} |  6 +--
 samples/bpf/trace_output_user.c               |  2 +-
 samples/bpf/{tracex2_kern.c => tracex2.bpf.c} | 13 ++---
 samples/bpf/tracex2_user.c                    |  2 +-
 13 files changed, 51 insertions(+), 81 deletions(-)
 rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
 rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
 rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
 delete mode 100644 samples/bpf/trace_common.h
 rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
 rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)

-- 
2.34.1

