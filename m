Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1175C3289
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfJALdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:33:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36597 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJALdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:33:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so7755025pfr.3;
        Tue, 01 Oct 2019 04:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peGT14BlsLdGabPKwMdnJuyKWVcTNuskR5BUm3mqwVE=;
        b=Cv3EZv85P/wXNkHY/o4sRYwi1M8/RSRsGDqTvlx9zSTd0Yb1mCe/7QGsxSoiaiuDRs
         i2p57ex/xJ9C5BUIO/ijWKBc0OkLuZ4t6vMc8xGGzACs0V+CZL7Pj3pZ7iNmc7104T4e
         uzCXYvk61G98nGk0iNA//vwK8H9WHc1li4TAIJpdBgqTBYs3dmVpEwiRurZxldc0WfQd
         6y2zYEgiuRUWIhR2kPVZCihZ9s3bDGDFC3preokWl1BwpoFoteEQ5o7Eblb5UpMQgG0M
         i5g5ttqyqLWmAVHHgIXfRppIjribAJ/L97Trtmd6FPUDoeDGwIdbi+rVUNXMgoDjyLve
         7AvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peGT14BlsLdGabPKwMdnJuyKWVcTNuskR5BUm3mqwVE=;
        b=SOUOW0NSDISsgrnfHCO1Mt46NHICkDb3fQwcTCt2LLsiQfHLE5xUUiFnopVExm5JfY
         yxAeorlxMhHj2fGND8K2NWXKWW2Ea2g/x6IYY+NjXjaC6zhErsBW7dY1SF+c1hFavPnZ
         8msZ6udApYeu0/NWLHGgjEw3hMVvVEzxx27rDJL6ZEEY+0G+J/Qs3RHrzO/2Wx7wR2aS
         4OvfoNc9PWjipr0NeoPPqdtZdgDR064nXzJdu3R1M7OvDRZy0J3KfZ80I9pBNBrQU2t3
         8rrnIqaEUnlz064XrEgMKWGj8uJ8k1P+BuW1rXefg6AHVpsmwgjMlHcK+ait20FOyqpX
         +WmQ==
X-Gm-Message-State: APjAAAVIEvRcQPPQs7CGZXN5oWhFgaMNi1tBpJ1DHdYsv2/fu/APgnOW
        4dQvoYLYZpb7boIgu3uZZm8Pn22JMnrGVQ==
X-Google-Smtp-Source: APXvYqzvLr6kMQTIDddPKpOuQOctyO+VyAYQpXpJ0k3fE5/Xqxw/THOnBn2LeidJp1GuUjqFzy96cQ==
X-Received: by 2002:a63:501:: with SMTP id 1mr9935217pgf.290.1569929601631;
        Tue, 01 Oct 2019 04:33:21 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a29sm16238634pfr.152.2019.10.01.04.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:33:21 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     linux-kernel@vger.kernel.org, acme@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, adrian.hunter@intel.com, jolsa@kernel.org,
        namhyung@kernel.org
Subject: [PATCH 1/2] perf tools: Make usage of test_attr__* optional for perf-sys.h
Date:   Tue,  1 Oct 2019 13:33:06 +0200
Message-Id: <20191001113307.27796-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001113307.27796-1-bjorn.topel@gmail.com>
References: <20191001113307.27796-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

For users of perf-sys.h outside perf, e.g. samples/bpf/bpf_load.c,
it's convenient not to depend on test_attr__*.

After commit 91854f9a077e ("perf tools: Move everything related to
sys_perf_event_open() to perf-sys.h"), all users of perf-sys.h will
depend on test_attr__enabled and test_attr__open.

This commit enables a user to define HAVE_ATTR_TEST to zero in order
to omit the test dependency.

Fixes: 91854f9a077e ("perf tools: Move everything related to sys_perf_event_open() to perf-sys.h")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/perf/perf-sys.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 63e4349a772a..15e458e150bd 100644
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
-- 
2.20.1

