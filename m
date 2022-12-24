Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495F66558CF
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiLXHPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiLXHPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:15:35 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C117E10041;
        Fri, 23 Dec 2022 23:15:33 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ge16so3076500pjb.5;
        Fri, 23 Dec 2022 23:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yxExIgbJQo9/SkygEp6z1sjffav+4NJM8eGnxGrbEZg=;
        b=Jj15OnD+3PYuCeIbUDaynNTmWsq6wEOMq0T+nT3RGWql/xW96CJTKa4modFmkJd3HY
         VMYN2a6vnacRxQdN5sgnYCzM9QDe5k0ZRL++Au8FKo0y5Luq4MoSj6UiGuaHb/ueovMU
         YKSsGNpoZq6no6/lw9e8nZBM2WNiJyZ1nFrBkvdwsNjlUhYUE/MJMSQCFRCSWT3PkbRC
         yn4x+BwijbTIddffggG2CL3DGiRHaG2YW++Yos0dJE7zBVRLZI7/AiNpWYJC9Ep6dIZt
         /ikFFFiQuKf0kpFii9X7kLuXnuneHNNFcioer5XZyZDTU6s1aXic/6i+t4DYtRxKinTS
         Ipgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxExIgbJQo9/SkygEp6z1sjffav+4NJM8eGnxGrbEZg=;
        b=lRI+UOg/54Noj2Ub15HVVUzwCKJ7wX5q1E9cSefkx3SezWRwPhVjniF7bLvgk3iiym
         GZQpLotmxBK/0O1COMRAlssRFV3SR+Ti221b8nbHG7Z+3JkYKa7yRKuoPUFzlb6eyeVL
         ynNioDcYuV01FfrZa9+aROnc9SQKs+94VilKI1FdUm+GhPdDG2DgMqT92Ok1PFFsH6ye
         z1mSTwffF3GoU+EN3BpNPgR5+Zdy3Ms/bmzra4O1HPloFdlblnULp+1ppZ4JAMOyfUa1
         DPdrFtXqsuLYWgDRI/zOSXn8A27Qbde/J+cT7u6r0FWm1rZHTeyUWR56AcdQ/rStPjH6
         QtPw==
X-Gm-Message-State: AFqh2kr+lgGavj1toQhT1e8i6JJDYBtPmn6/gkpUDGnR1Bu/K2VbHGRE
        BKiKa+ZgZDZcd/0YbpNNoA==
X-Google-Smtp-Source: AMrXdXuxwJ+XFAM18jBA7qKbSF/T5D5biA0iMzZWqUe4IrXznrJQ/FozJPhOL6aUmBrKkIOVp9MvBw==
X-Received: by 2002:a17:902:c244:b0:189:603d:ea71 with SMTP id 4-20020a170902c24400b00189603dea71mr13492600plg.58.1671866133038;
        Fri, 23 Dec 2022 23:15:33 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:32 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 0/6] samples/bpf: enhance syscall tracing program
Date:   Sat, 24 Dec 2022 16:15:21 +0900
Message-Id: <20221224071527.2292-1-danieltimlee@gmail.com>
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

Also, this commit adds dummy gnu/stub.h to the samples/bpf directory.
This will fix the compiling problem with 'clang -target bpf'.

To fix the build error with the s390x, this patchset also includes the
fix of libbpf invalid return address register mapping in s390.

---
Changes in V2:
- add gnu/stub.h hack to fix compile error with 'clang -target bpf'
Changes in V3:
- fix libbpf invalid return address register mapping in s390

Daniel T. Lee (6):
  samples/bpf: use kyscall instead of kprobe in syscall tracing program
  samples/bpf: use vmlinux.h instead of implicit headers in syscall
    tracing program
  samples/bpf: change _kern suffix to .bpf with syscall tracing program
  samples/bpf: fix tracex2 by using BPF_KSYSCALL macro
  samples/bpf: use BPF_KSYSCALL macro in syscall tracing programs
  libbpf: fix invalid return address register in s390

 samples/bpf/Makefile                          | 10 ++--
 samples/bpf/gnu/stubs.h                       |  1 +
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
 tools/lib/bpf/bpf_tracing.h                   |  2 +-
 15 files changed, 53 insertions(+), 82 deletions(-)
 create mode 100644 samples/bpf/gnu/stubs.h
 rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
 rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
 rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
 delete mode 100644 samples/bpf/trace_common.h
 rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
 rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)

-- 
2.34.1

