Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6D411AAD3
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfLKMay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:30:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46053 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfLKMax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:30:53 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so1739067pfg.12;
        Wed, 11 Dec 2019 04:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6SeiTsvAEy8VQxsdRHDPpYhwUBoXZ86ZAU9B9WJ43Dg=;
        b=qSSy380u5/sjaarQ+dNwzZlB6aui2R3qP1cxudXSHWPttVaoClVozVKoifkDqvU+7V
         uzxskK+w1RMuYVp1r7DZWAFWFfL3GyHVUAqkHRatUwonda/p42dgu/urTWfEfjpoKia8
         Acq6/LYKXtl+zhHVHolodBs08CS8rRqoDM9jVdE47di+tmNj4JGBHY2VWXJCU3HwzMkN
         mZB3DJX9i36cxxKID0ssrLI2jx+fS652LawR55fAmNCJf+XO9SWTRS1B/a3UiJ4AWoQs
         J4Vnaeel1cWbe9qz9A19vtPDx9393VJucsGCfUhwrnsKX9INUoX0gJ6s2fY6UErh96Je
         ASUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6SeiTsvAEy8VQxsdRHDPpYhwUBoXZ86ZAU9B9WJ43Dg=;
        b=igXrLiJpLbT5xuzkS09dUJAleBVK1cffn/zK7Bue2lhL0O97TgF9xZER3qDu7UH5SQ
         Pz7jJGpKod2xlfOwNUjrI5153uOrElHQTd91Bx97Hv8XIvGH1DLka4KeIhrE4Y9w1oww
         EB8olgwkp033X1FWCN/gpZVfIkAekqNz+r47fhAXHNrNDzyCdBf6Mq61or4xWgRK1RBP
         qEshlEyfd3HfM4n30INoZgJye+emYVBJVH6Uo69q3NpD/qaJXo95lcJXJWG0Ju5SMsnj
         7jbs6jDSyqxDLfTn7KCYJ3DKWpAaPSZL1caOPVlc8Ct/DS1pTXRlThUP95bdFkgWywwI
         ysQg==
X-Gm-Message-State: APjAAAW/2RRGI8N59W0dAMaDGQb084r1y7/K8bpEyLx9Xb4Kuf/HUSBW
        Csk7bpaui/NBgnKESBa/n7AE1Pyw6lGVTg==
X-Google-Smtp-Source: APXvYqzU81v/S5/fMnHIRIx+CsRrM+MTLRbsAMHhiU1RVjh1pX+QwQzMzzkxN0Yb9HO3XTlgmNuNkQ==
X-Received: by 2002:aa7:9355:: with SMTP id 21mr2063060pfn.61.1576067452793;
        Wed, 11 Dec 2019 04:30:52 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 24sm3097132pfn.101.2019.12.11.04.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 04:30:52 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v4 5/6] selftests: bpf: add xdp_perf test
Date:   Wed, 11 Dec 2019 13:30:16 +0100
Message-Id: <20191211123017.13212-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123017.13212-1-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The xdp_perf is a dummy XDP test, only used to measure the the cost of
jumping into a naive XDP program one million times.

To build and run the program:
  $ cd tools/testing/selftests/bpf
  $ make
  $ ./test_progs -v -t xdp_perf

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 .../selftests/bpf/prog_tests/xdp_perf.c       | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_perf.c b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
new file mode 100644
index 000000000000..7185bee16fe4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+void test_xdp_perf(void)
+{
+	const char *file = "./xdp_dummy.o";
+	__u32 duration, retval, size;
+	struct bpf_object *obj;
+	char in[128], out[128];
+	int err, prog_fd;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	err = bpf_prog_test_run(prog_fd, 1000000, &in[0], 128,
+				out, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_PASS || size != 128,
+	      "xdp-perf",
+	      "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	bpf_object__close(obj);
+}
-- 
2.20.1

