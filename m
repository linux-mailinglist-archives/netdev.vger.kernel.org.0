Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC4C652003
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 12:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiLTL7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 06:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiLTL7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 06:59:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0722F17418;
        Tue, 20 Dec 2022 03:59:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fy4so12214288pjb.0;
        Tue, 20 Dec 2022 03:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLG3GskQNPwnXFfpwtJ413hWYf/t2snRdM+z5Y/9OjI=;
        b=bO4WmYNgwHhIxAa7x0d1hfbTp0QKCgUN6m5itRIuH+KaGIJ+Hh8zMm0yfypqO6U9xH
         e5OfrRDDgs5lAmUgQ1SsWTXVReDLHl1sNaeAG2Qss+jfMcS0f1UUBLUNSHFd2KaZkIKD
         spA7sEkGSe0/VKVV1fyF4X8IZiElqP3xqqwMQ6WZbUphpknJstAcr3MwUnIU8iScuvHv
         cRN2he5ULh17VgcQx+ye9/z+lDsfF2Q1/tzjhWcIF36vusdVLQ4fB8dtiiju/x9fD/AE
         yCorpYHO3+3x50hIMrFu/VCdz2U/e6pZZFD9aiQ6facFpm/3k93mdCytEXFtFMu8yRJJ
         gdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLG3GskQNPwnXFfpwtJ413hWYf/t2snRdM+z5Y/9OjI=;
        b=UlaKjMmCuyCwEIGda15D0r4xqZgZ5QSNNecr0wk0AJyrcAug/7LosT8ZElpEZNxlRo
         Vo87P1LxEMHTYOPFyS6pMvLTXKucAOA0OJ1RINsdwjb4MaNlBbSQi4y+Fk3F9IrtvakE
         uEyRV7stA4x9WdvBdlkjkSb4tjz1rUnY/FHoWAJHoQ7fFON9MC2Vb8x8l1ScWhRrbjpS
         ptr/DsISpjhN8vtL0vVBOdbNns1q9Eqfc21V5lhCdzaP2XqzDBCb+OxoFzPsHtFubu4T
         0nfZ3n0pYBSTT36otx7mB2O8vUVwMfQte03G7dXaQv8Uu+2pXoNcOSvnzRItouBANaG8
         tgrg==
X-Gm-Message-State: AFqh2krR9EkMvuxF3Tz7Z/Md4ySW/Wfch8ccSfbkRygOrv02Mi7E3VQM
        Ds8+5TX4YxA5zgwDNeVFPQ==
X-Google-Smtp-Source: AMrXdXtYSfJp/0jM/pisFSi9G4vronmQYRAX+oYx0+sMN7q4Hm6qZrcAS13Cg8P1jT0iz7YnWYJnHw==
X-Received: by 2002:a17:90a:bd98:b0:221:5c1a:dca9 with SMTP id z24-20020a17090abd9800b002215c1adca9mr12943297pjr.30.1671537577491;
        Tue, 20 Dec 2022 03:59:37 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b00219752c8ea3sm10982482pjd.48.2022.12.20.03.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:59:37 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 2/5] samples/bpf: use vmlinux.h instead of implicit headers in syscall tracing program
Date:   Tue, 20 Dec 2022 20:59:25 +0900
Message-Id: <20221220115928.11979-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220115928.11979-1-danieltimlee@gmail.com>
References: <20221220115928.11979-1-danieltimlee@gmail.com>
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

This commit applies vmlinux.h to syscall tracing program. This change
allows the bpf program to refer to the internal structure as a single
"vmlinux.h" instead of including each header referenced by the bpf
program.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/map_perf_test_kern.c                  | 5 ++---
 samples/bpf/test_current_task_under_cgroup_kern.c | 4 +---
 samples/bpf/test_probe_write_user_kern.c          | 5 ++---
 samples/bpf/trace_output_kern.c                   | 3 +--
 samples/bpf/tracex2_kern.c                        | 4 +---
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 874e2f7e3d5d..0c7885057ffe 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -4,10 +4,9 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
+#include "vmlinux.h"
+#include <errno.h>
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
diff --git a/samples/bpf/test_current_task_under_cgroup_kern.c b/samples/bpf/test_current_task_under_cgroup_kern.c
index 541fc861b984..0b059cee3cba 100644
--- a/samples/bpf/test_current_task_under_cgroup_kern.c
+++ b/samples/bpf/test_current_task_under_cgroup_kern.c
@@ -5,11 +5,9 @@
  * License as published by the Free Software Foundation.
  */
 
-#include <linux/ptrace.h>
-#include <uapi/linux/bpf.h>
+#include "vmlinux.h"
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
-#include <uapi/linux/utsname.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index d60cabaaf753..a0f10c5ca273 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -4,9 +4,8 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <uapi/linux/bpf.h>
+#include "vmlinux.h"
+#include <string.h>
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output_kern.c
index a481abf8c4c5..565a73b51b04 100644
--- a/samples/bpf/trace_output_kern.c
+++ b/samples/bpf/trace_output_kern.c
@@ -1,6 +1,5 @@
-#include <linux/ptrace.h>
+#include "vmlinux.h"
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
 struct {
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 82091facb83c..a712eefc742e 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -4,10 +4,8 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
+#include "vmlinux.h"
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-- 
2.34.1

