Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59257652000
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 12:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiLTL7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 06:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLTL7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 06:59:34 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F572654;
        Tue, 20 Dec 2022 03:59:33 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o12so12155432pjo.4;
        Tue, 20 Dec 2022 03:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s/CQ3BK8SlxjrBH9d+tS2SnPd9FmDyBnBBYhNR+gh0w=;
        b=WAJRLYLkWmcLakddgkrMPbd95jUNBF0IwGwO8CCLMdPJeZbz7CnliAGbLdtL/U5rTS
         cIZrhjx9lp84quakb9MuSjlsHH2TrYeJoN9Q7nnGSpwFRXtzmXSv09xSk2VufJaWuQL+
         +kjAZwOVKCBFTwMGLyDb0Nf3zW5kR5DGzXRjjl0F4iinp3z4/047lP1DdriOSC+49dBS
         Vspyq2cx9JNt4t+0HOrrbVxcZzpCPvkk3X45kq7LR7UITJHuDo2EoycA2ywI0ZnGfFls
         3O5wcdvNs8cr8MalQQi9KPASaVEIrKlYi4TmlhWfQLhg0rLs5KCtnQolUgEziJ/YdvkB
         Bohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/CQ3BK8SlxjrBH9d+tS2SnPd9FmDyBnBBYhNR+gh0w=;
        b=i9EUSFSRPGhNbaMSBQqyBoQaCuLZkmxKKfmYOG4hPXL+rtePLfgmdv1v1cb3stENAO
         QEcomLu7Wac7ZB6oa4slU1rmdR5FZb3TvJtP2bjty765g+6IHoxhgf5mtnKjVDsb7ndS
         6ijCz8NuvXXaHabpNAkTpV51vaAd7U+UWHaeWEs7ZUU6PFgr5Gw8UjyCg7ff0GoLWB47
         saH0qOG1GZbagWnI0PK3u15KeQCMjSutZd+1ce5OYL63l9qBCaRIihOor2Vt1olBGckD
         b/zyQg5nZqUh42PBSBWC0+nCxD5fgNkF82jBSjZPsq82IsvQuLAJ2i9/CUez8SFKMGhE
         p8Cg==
X-Gm-Message-State: AFqh2kpMCGu5s4cAf/5Al7qIHxE6ax96WRVspt89H3AsTsBCq2Azuvj/
        LDvRmlqTx2vokGoby0/RAA==
X-Google-Smtp-Source: AMrXdXtq6hvGVcnSi8MZV2B//hsXoD+ZcpiC2JU730qJx4Ib35u8O/BVr/WYmuya6MrBzac3+S7/yQ==
X-Received: by 2002:a17:90b:81:b0:223:de00:f5ab with SMTP id bb1-20020a17090b008100b00223de00f5abmr4649486pjb.28.1671537572893;
        Tue, 20 Dec 2022 03:59:32 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b00219752c8ea3sm10982482pjd.48.2022.12.20.03.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:59:32 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 0/5] samples/bpf: enhance syscall tracing program
Date:   Tue, 20 Dec 2022 20:59:23 +0900
Message-Id: <20221220115928.11979-1-danieltimlee@gmail.com>
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

---
Changes in V2:
- add gnu/stub.h hack to fix compile error with 'clang -target bpf'

Daniel T. Lee (5):
  samples/bpf: use kyscall instead of kprobe in syscall tracing program
  samples/bpf: use vmlinux.h instead of implicit headers in syscall
    tracing program
  samples/bpf: change _kern suffix to .bpf with syscall tracing program
  samples/bpf: fix tracex2 by using BPF_KSYSCALL macro
  samples/bpf: use BPF_KSYSCALL macro in syscall tracing programs

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
 14 files changed, 52 insertions(+), 81 deletions(-)
 create mode 100644 samples/bpf/gnu/stubs.h
 rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
 rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
 rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
 delete mode 100644 samples/bpf/trace_common.h
 rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
 rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)

-- 
2.34.1

