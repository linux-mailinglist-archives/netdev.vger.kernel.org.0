Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17AD6ECC
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 07:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbfJOFcX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Oct 2019 01:32:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42254 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbfJOFcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 01:32:22 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iKFRL-0000Qr-OZ; Tue, 15 Oct 2019 07:32:11 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 53CD81C06CD;
        Tue, 15 Oct 2019 07:31:49 +0200 (CEST)
Date:   Tue, 15 Oct 2019 05:31:49 -0000
From:   tip-bot2 for =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= 
        <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf tools: Make usage of test_attr__* optional for
 perf-sys.h
Cc:     =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn.topel@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191001113307.27796-2-bjorn.topel@gmail.com>
References: <20191001113307.27796-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Message-ID: <157111750919.12254.12122425573168365300.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     06f84d1989b7e58d56fa2e448664585749d41221
Gitweb:        https://git.kernel.org/tip/06f84d1989b7e58d56fa2e448664585749d41221
Author:        Björn Töpel <bjorn.topel@intel.com>
AuthorDate:    Tue, 01 Oct 2019 13:33:06 +02:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Mon, 07 Oct 2019 12:22:17 -03:00

perf tools: Make usage of test_attr__* optional for perf-sys.h

For users of perf-sys.h outside perf, e.g. samples/bpf/bpf_load.c, it's
convenient not to depend on test_attr__*.

After commit 91854f9a077e ("perf tools: Move everything related to
sys_perf_event_open() to perf-sys.h"), all users of perf-sys.h will
depend on test_attr__enabled and test_attr__open.

This commit enables a user to define HAVE_ATTR_TEST to zero in order
to omit the test dependency.

Fixes: 91854f9a077e ("perf tools: Move everything related to sys_perf_event_open() to perf-sys.h")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191001113307.27796-2-bjorn.topel@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-sys.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 63e4349..15e458e 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -15,7 +15,9 @@ void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 		     int fd, int group_fd, unsigned long flags);
 
-#define HAVE_ATTR_TEST
+#ifndef HAVE_ATTR_TEST
+#define HAVE_ATTR_TEST 1
+#endif
 
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
@@ -27,7 +29,7 @@ sys_perf_event_open(struct perf_event_attr *attr,
 	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
 		     group_fd, flags);
 
-#ifdef HAVE_ATTR_TEST
+#if HAVE_ATTR_TEST
 	if (unlikely(test_attr__enabled))
 		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
 #endif
