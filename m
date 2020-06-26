Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F3820AE56
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgFZIRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgFZIRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:17:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC6CC08C5C1;
        Fri, 26 Jun 2020 01:17:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y18so4009375plr.4;
        Fri, 26 Jun 2020 01:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=juf7fAzPWIhVrTNiZlgtvVLKLPmJczbIdf+ONGx8iJc=;
        b=q8cIJUmWU3sK+AEgWf1xalkPjw9E2efUvU4ksgEv7NUW50CVFy770meP5d3xRUcVl0
         H5Bn7lTjfE0SBwGWdtLlDxGIPZ8Y8nQW4t3P5IYHUHkSlb5Le2ucRuiRGyGVOnZUzUWX
         79DrLFEac/Qi0myRyqNqWR4OdIT0b+qAuCEqzjBzZ04swwD3dF2dSVSnNISlnsJncTMO
         BAa80qGQSgiqNRqyKJ4OUNBdPZJfVfIF0leg1VNpgp+YhEpNUo2Ou4lpVqtglzJLWwxm
         8mkZiHwZNJc9j53EsZoxLy2gjI0DQg5twAfriapTl5yU6X4M4HvGWT/y354CH4suZJXh
         N/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=juf7fAzPWIhVrTNiZlgtvVLKLPmJczbIdf+ONGx8iJc=;
        b=uKB/W1GD3fbAk7xoQCwB/PS6IGDnUavwPq5+zwrQ8OqtIzprpR7hSZLxoZOjALUdFC
         4wQ+AAE+WmWzwZ3KajK+HGSbIojhERB7Ae8OH6y6x/Is7fg+xalY4+h2nSiUHzhhHWV5
         6rjpoT0e+8LpIKmJ4HAIfkng4DUHtm6YI7hnunt831t3osNDHIuDwSrd7e5arMEhP2GR
         8ZH1el+Ul2X3FaQYWtwYrZMrIhj2vAEXSjBjNTaVkXhrE0rCjJPGvTzQDhXWOtkwEmpJ
         yjfyaJA8JsZQ72PNmo0wv5W+d3W4zh9AkAMhawQUO2Hc0X3M+N1sybouYVAZ2E8IzvG6
         ewgQ==
X-Gm-Message-State: AOAM533N8AeL/cmIBd/cHGhaJGFO2n3gOo0EmyM+jLqGM7TxWm/ygYam
        1Da0QAGVcGefBjIQt+zYlQ==
X-Google-Smtp-Source: ABdhPJyomg7hO+755GU+vsLPqKB8u909EORkiMnrl6Fs2tuyx2XmP2NRmqO6nhtUrmgJndiP/L92rw==
X-Received: by 2002:a17:90b:3685:: with SMTP id mj5mr2230818pjb.162.1593159452114;
        Fri, 26 Jun 2020 01:17:32 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s22sm16514023pgv.43.2020.06.26.01.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 01:17:31 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 2/3] samples: bpf: cleanup pointer error check with libbpf
Date:   Fri, 26 Jun 2020 17:17:19 +0900
Message-Id: <20200626081720.5546-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200626081720.5546-1-danieltimlee@gmail.com>
References: <20200626081720.5546-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf has its own helper function to check for errors in the bpf
data structure (pointer). And Some codes do not use this libbbpf
helper function and check the pointer's error directly.

This commit clean up the existing pointer error check logic with
libbpf.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/sampleip_user.c    | 2 +-
 samples/bpf/trace_event_user.c | 2 +-
 samples/bpf/tracex1_user.c     | 2 +-
 samples/bpf/tracex5_user.c     | 2 +-
 samples/bpf/tracex7_user.c     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
index 921c505bb567..554dfa1cb34d 100644
--- a/samples/bpf/sampleip_user.c
+++ b/samples/bpf/sampleip_user.c
@@ -186,7 +186,7 @@ int main(int argc, char **argv)
 	}
 
 	prog = bpf_object__find_program_by_name(obj, "do_sample");
-	if (!prog) {
+	if (libbpf_get_error(prog)) {
 		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
 		goto cleanup;
 	}
diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index ac1ba368195c..8bcb9b4bfbe6 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -318,7 +318,7 @@ int main(int argc, char **argv)
 	}
 
 	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
-	if (!prog) {
+	if (libbpf_get_error(prog)) {
 		printf("finding a prog in obj file failed\n");
 		goto cleanup;
 	}
diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
index 9d4adb7fd834..d3e01807dcd0 100644
--- a/samples/bpf/tracex1_user.c
+++ b/samples/bpf/tracex1_user.c
@@ -20,7 +20,7 @@ int main(int ac, char **argv)
 	}
 
 	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
-	if (!prog) {
+	if (libbpf_get_error(prog)) {
 		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
 		goto cleanup;
 	}
diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index 98dad57a96c4..65c753b30121 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -53,7 +53,7 @@ int main(int ac, char **argv)
 	}
 
 	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
-	if (!prog) {
+	if (libbpf_get_error(prog)) {
 		printf("finding a prog in obj file failed\n");
 		goto cleanup;
 	}
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index fdcd6580dd73..10c896732139 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -22,7 +22,7 @@ int main(int argc, char **argv)
 	}
 
 	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
-	if (!prog) {
+	if (libbpf_get_error(prog)) {
 		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
 		goto cleanup;
 	}
-- 
2.25.1

