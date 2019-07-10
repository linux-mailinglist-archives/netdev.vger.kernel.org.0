Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6364805
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfGJOQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:16:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41549 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbfGJOQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:16:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so1174792pff.8
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yg+Fia+4TffgvjfVtZaMrwTvAUof2HACdCWfE9Adz90=;
        b=puPKxWZQb+LZdgernOXSGHoCjjFfNqhgNCQgR3EAJVuYHTxPi0MWhE1gMoTZzoxDtL
         JPgeBqpXoNCnj35nK/tB1FCJMvJg2YoHOxNlJ0Vchnf+Zhz2VlASaorgKKmUkgTvSIJf
         8FW/bsoH46dLIF8XeGGCXT64TEZRMHpQZe0+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yg+Fia+4TffgvjfVtZaMrwTvAUof2HACdCWfE9Adz90=;
        b=OtF2IcQooBvdIgUDfKwRk4xaYwk0+ssjA0OiXa5+E4/tjFnACVqnQtGjdzfXAFSvQO
         xk7gfG59uFMkIZZ4pqO34UvCYmHOqPXeuaRP0OR6MdYRKDJgP3LVCmM2RtXxzxgwS0kV
         nQz5aHxFnxLAR6/XtUdlQixqZ2PQgJAZI9EK8f6P0fxcCVcfCeruFUFpC7nSMWRiQOP/
         LG7Eukr9XQ2Z3uDsFi67EhTx74LPiITBvjpqik0/Gm8PWxDbjpDUvCKMK3tqFg6voATL
         VgJcXHfdIksPGHZCFI337EcbV94PQir+eXPJWxeWgIEkKMTCvTRfTKWWIIsfSp4bkjCQ
         YLvQ==
X-Gm-Message-State: APjAAAXJGbjahCZ4Rde7lLuFM9DQuZhWp8QXpTwsKkX/JJiIL3rUByic
        uX6imyzlMzadChjHGZq7Qfc=
X-Google-Smtp-Source: APXvYqxireE36SRG7vQaha91GKI62TdGTjOZ+qzVeiQZzoJfKbV6cQyUm55T8TcIjbBj3K5Tt9zuKQ==
X-Received: by 2002:a17:90a:290b:: with SMTP id g11mr7342173pjd.122.1562768172230;
        Wed, 10 Jul 2019 07:16:12 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l124sm2589249pgl.54.2019.07.10.07.16.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 07:16:11 -0700 (PDT)
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
Subject: [PATCH RFC 4/4] selftests/bpf: Add test for ftrace-based BPF attach/detach
Date:   Wed, 10 Jul 2019 10:15:48 -0400
Message-Id: <20190710141548.132193-5-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190710141548.132193-1-joel@joelfernandes.org>
References: <20190710141548.132193-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we add support for testing the attach and detach of a BPF program
to a tracepoint through tracefs.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 .../raw_tp_writable_test_ftrace_run.c         | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_writable_test_ftrace_run.c

diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_writable_test_ftrace_run.c b/tools/testing/selftests/bpf/prog_tests/raw_tp_writable_test_ftrace_run.c
new file mode 100644
index 000000000000..7b42e3a69b71
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_writable_test_ftrace_run.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <linux/nbd.h>
+
+void test_raw_tp_writable_test_ftrace_run(void)
+{
+	__u32 duration = 0;
+	char error[4096];
+	int ret;
+
+	const struct bpf_insn trace_program[] = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 0),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_6, 0),
+		BPF_MOV64_IMM(BPF_REG_0, 42),
+		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+
+	struct bpf_load_program_attr load_attr = {
+		.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+		.license = "GPL v2",
+		.insns = trace_program,
+		.insns_cnt = sizeof(trace_program) / sizeof(struct bpf_insn),
+		.log_level = 2,
+	};
+
+	int bpf_fd = bpf_load_program_xattr(&load_attr, error, sizeof(error));
+
+	if (CHECK(bpf_fd < 0, "bpf_raw_tracepoint_writable loaded",
+		  "failed: %d errno %d\n", bpf_fd, errno))
+		return;
+
+	const struct bpf_insn skb_program[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+
+	struct bpf_load_program_attr skb_load_attr = {
+		.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
+		.license = "GPL v2",
+		.insns = skb_program,
+		.insns_cnt = sizeof(skb_program) / sizeof(struct bpf_insn),
+	};
+
+	int filter_fd =
+		bpf_load_program_xattr(&skb_load_attr, error, sizeof(error));
+	if (CHECK(filter_fd < 0, "test_program_loaded", "failed: %d errno %d\n",
+		  filter_fd, errno))
+		goto out_bpffd;
+
+	ret = bpf_raw_tracepoint_ftrace_attach("bpf_test_run",
+					       "bpf_test_finish",
+					       bpf_fd);
+	if (CHECK(ret < 0, "bpf_raw_tracepoint_ftrace_attach",
+		  "failed: %d errno %d\n", ret, errno))
+		goto out_filterfd;
+
+	char test_skb[128] = {
+		0,
+	};
+
+	__u32 prog_ret;
+	int err = bpf_prog_test_run(filter_fd, 1, test_skb, sizeof(test_skb), 0,
+				    0, &prog_ret, 0);
+	CHECK(err != 42, "test_run",
+	      "tracepoint did not modify return value\n");
+	CHECK(prog_ret != 0, "test_run_ret",
+	      "socket_filter did not return 0\n");
+
+	ret = bpf_raw_tracepoint_ftrace_detach("bpf_test_run",
+					       "bpf_test_finish",
+					       bpf_fd);
+	if (CHECK(ret < 0, "bpf_raw_tracepoint_ftrace_detach",
+		  "failed: %d errno %d\n", ret, errno))
+		goto out_filterfd;
+
+	err = bpf_prog_test_run(filter_fd, 1, test_skb, sizeof(test_skb), 0, 0,
+				&prog_ret, 0);
+	CHECK(err != 0, "test_run_notrace",
+	      "test_run failed with %d errno %d\n", err, errno);
+	CHECK(prog_ret != 0, "test_run_ret_notrace",
+	      "socket_filter did not return 0\n");
+
+out_filterfd:
+	close(filter_fd);
+out_bpffd:
+	close(bpf_fd);
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

