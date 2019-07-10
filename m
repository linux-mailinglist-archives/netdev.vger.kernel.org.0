Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8B5647F5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfGJOP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:15:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44158 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJOP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:15:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so1165347pfe.11
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8u/8oBvwls3TmHDIAgdRr1iO5w1leafBhE5nzfgIbNY=;
        b=ik/txIOzI2+TUrsUL2ZoXzZa7twvPZdk3u9E2bYRIL99Lvfh0YdEPjD/zeLFzop8nI
         dz+tENQ7uf96nUYOS7DKtU7tYereh/giq76H0nt6EdsZLxNVhJac+smvmQ0qoLhDSLkO
         gydAI8tKn+4b+GYSIRTIbLPCYVtIOwL6NJwNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8u/8oBvwls3TmHDIAgdRr1iO5w1leafBhE5nzfgIbNY=;
        b=c+Vwb9nIiQuPcBU4dNFa1y67O4dk3e3fDAZIbY2X3KrcdgicRwB6q6fxn27SPf3Y4d
         IpDnRs4eJW2v4uUqvO06ih2WKTDvg+wLiaQcxgYNptOysZ7NTywzZBuw9ek68AlyA5vI
         Yec2y+0ty59Ue7UF5TYNYiw4MesmxXq84cJxfFwlK7gZiYlnGzAr4aNHeS+MOypWOcEk
         eAgQxLzZUj/EJ49NWNPM2Co0Y61rlQyRwd1xtGbQnDTrNzlplAxtIaTYtNPtKhufgfnU
         05ZJFtpiLs8Mt4pctJbi2XmHhVo7sc5NFFemPvem30GxV88hXIgk/k9IyyFWJxgyWjzw
         VGVw==
X-Gm-Message-State: APjAAAUNF6Eq8R0td1/Ga4ddtOczon+QY76MMztRltUM32RQFyLnEAmR
        +GQ5XJoRMoOtfrmidyq8/bDRlQ==
X-Google-Smtp-Source: APXvYqwWrgLgXgQwACA2VuP7IqF8CPk7WQxKdd5MI3KP8MV596Wrwf2m53X+vAoh9by7zbDtkvjKkg==
X-Received: by 2002:a63:4b02:: with SMTP id y2mr26565686pga.135.1562768156934;
        Wed, 10 Jul 2019 07:15:56 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l124sm2589249pgl.54.2019.07.10.07.15.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 07:15:56 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH RFC 0/4] Add support to directly attach BPF program to ftrace
Date:   Wed, 10 Jul 2019 10:15:44 -0400
Message-Id: <20190710141548.132193-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
These patches make it possible to attach BPF programs directly to tracepoints
using ftrace (/sys/kernel/debug/tracing) without needing the process doing the
attach to be alive. This has the following benefits:

1. Simplified Security: In Android, we have finer-grained security controls to
specific ftrace trace events using SELinux labels. We control precisely who is
allowed to enable an ftrace event already. By adding a node to ftrace for
attaching BPF programs, we can use the same mechanism to further control who is
allowed to attach to a trace event.

2. Process lifetime: In Android we are adding usecases where a tracing program
needs to be attached all the time to a tracepoint, for the full life time of
the system. Such as to gather statistics where there no need for a detach for
the full system lifetime. With perf or bpf(2)'s BPF_RAW_TRACEPOINT_OPEN, this
means keeping a process alive all the time.  However, in Android our BPF loader
currently (for hardeneded security) involves just starting a process at boot
time, doing the BPF program loading, and then pinning them to /sys/fs/bpf.  We
don't keep this process alive all the time. It is more suitable to do a
one-shot attach of the program using ftrace and not need to have a process
alive all the time anymore for this. Such process also needs elevated
privileges since tracepoint program loading currently requires CAP_SYS_ADMIN
anyway so by design Android's bpfloader runs once at init and exits.

This series add a new bpf file to /sys/kernel/debug/tracing/events/X/Y/bpf
The following commands can be written into it:
attach:<fd>     Attaches BPF prog fd to tracepoint
detach:<fd>     Detaches BPF prog fd to tracepoint

Reading the bpf file will show all the attached programs to the tracepoint.

Joel Fernandes (Google) (4):
Move bpf_raw_tracepoint functionality into bpf_trace.c
trace/bpf: Add support for attach/detach of ftrace events to BPF
lib/bpf: Add support for ftrace event attach and detach
selftests/bpf: Add test for ftrace-based BPF attach/detach

include/linux/bpf_trace.h                     |  16 ++
include/linux/trace_events.h                  |   1 +
kernel/bpf/syscall.c                          |  69 +-----
kernel/trace/bpf_trace.c                      | 225 ++++++++++++++++++
kernel/trace/trace.h                          |   1 +
kernel/trace/trace_events.c                   |   8 +
tools/lib/bpf/bpf.c                           |  53 +++++
tools/lib/bpf/bpf.h                           |   4 +
tools/lib/bpf/libbpf.map                      |   2 +
.../raw_tp_writable_test_ftrace_run.c         |  89 +++++++
10 files changed, 410 insertions(+), 58 deletions(-)
create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_writable_test_ftrace_run.c

--
2.22.0.410.gd8fdbe21b5-goog

