Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98413D662
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405607AbfFKTDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405486AbfFKTDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 15:03:53 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8695621850;
        Tue, 11 Jun 2019 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560279833;
        bh=nQz/FiPhSp99AyagSW4bHpw6sEPfWuQnWGR4HXWX6TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahYlfeqMCpPLXR3vZ3QTn7BIDCw//yWC1clhFvq5Amssu4ZCsZ5uC5gzJHDOnDl1r
         d+++RvtdYs0aHgBtZqC3KmHICqwE/zIUWbGCg6dFEWQ+fHrG4qn1qL+jVZhzYZdidN
         C9fUMHkyNHN9n0oAa5Eqm4u6iBE5zSUk1D0wMQgU=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, Mark Drayton <mbd@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 62/85] perf config: Update default value for llvm.clang-bpf-cmd-template
Date:   Tue, 11 Jun 2019 15:58:48 -0300
Message-Id: <20190611185911.11645-63-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611185911.11645-1-acme@kernel.org>
References: <20190611185911.11645-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

The clang bpf cmdline template has defined default value in the file
tools/perf/util/llvm-utils.c, which has been changed for several times.

This patch updates the documentation to reflect the latest default value
for the configuration llvm.clang-bpf-cmd-template.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Drayton <mbd@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Fixes: d35b168c3dcd ("perf bpf: Give precedence to bpf header dir")
Fixes: cb76371441d0 ("perf llvm: Allow passing options to llc in addition to clang")
Fixes: 1b16fffa389d ("perf llvm-utils: Add bpf include path to clang command line")
Link: http://lkml.kernel.org/r/20190607143508.18141-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-config.txt | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-config.txt b/tools/perf/Documentation/perf-config.txt
index 462b3cde0675..e4aa268d2e38 100644
--- a/tools/perf/Documentation/perf-config.txt
+++ b/tools/perf/Documentation/perf-config.txt
@@ -564,9 +564,12 @@ llvm.*::
 	llvm.clang-bpf-cmd-template::
 		Cmdline template. Below lines show its default value. Environment
 		variable is used to pass options.
-		"$CLANG_EXEC -D__KERNEL__ $CLANG_OPTIONS $KERNEL_INC_OPTIONS \
-		-Wno-unused-value -Wno-pointer-sign -working-directory \
-		$WORKING_DIR  -c $CLANG_SOURCE -target bpf -O2 -o -"
+		"$CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS "\
+		"-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "	\
+		"$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
+		"-Wno-unused-value -Wno-pointer-sign "		\
+		"-working-directory $WORKING_DIR "		\
+		"-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
 
 	llvm.clang-opt::
 		Options passed to clang.
-- 
2.20.1

