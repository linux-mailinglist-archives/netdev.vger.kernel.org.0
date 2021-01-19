Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BDE2FB8E8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406446AbhASN7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:59:25 -0500
Received: from foss.arm.com ([217.140.110.172]:54686 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390818AbhASMX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 07:23:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FD7E113E;
        Tue, 19 Jan 2021 04:22:46 -0800 (PST)
Received: from e107158-lin.cambridge.arm.com (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3C3C3F719;
        Tue, 19 Jan 2021 04:22:44 -0800 (PST)
From:   Qais Yousef <qais.yousef@arm.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v3 bpf-next 0/2] Allow attaching to bare tracepoints
Date:   Tue, 19 Jan 2021 12:22:35 +0000
Message-Id: <20210119122237.2426878-1-qais.yousef@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
	* Fix not returning error value correctly in
	  trigger_module_test_write() (Yonghong)
	* Add Yonghong acked-by to patch 1.

Changes in v2:
	* Fix compilation error. (Andrii)
	* Make the new test use write() instead of read() (Andrii)

Add some missing glue logic to teach bpf about bare tracepoints - tracepoints
without any trace event associated with them.

Bare tracepoints are declare with DECLARE_TRACE(). Full tracepoints are declare
with TRACE_EVENT().

BPF can attach to these tracepoints as RAW_TRACEPOINT() only as there're no
events in tracefs created with them.

Qais Yousef (2):
  trace: bpf: Allow bpf to attach to bare tracepoints
  selftests: bpf: Add a new test for bare tracepoints

 Documentation/bpf/bpf_design_QA.rst           |  6 +++++
 include/trace/bpf_probe.h                     | 12 +++++++--
 .../bpf/bpf_testmod/bpf_testmod-events.h      |  6 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 21 ++++++++++++++-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  6 +++++
 .../selftests/bpf/prog_tests/module_attach.c  | 27 +++++++++++++++++++
 .../selftests/bpf/progs/test_module_attach.c  | 10 +++++++
 7 files changed, 85 insertions(+), 3 deletions(-)

-- 
2.25.1

