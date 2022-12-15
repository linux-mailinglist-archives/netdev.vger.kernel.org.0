Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F404664DA86
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiLOLjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLOLjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:39:47 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC3116496;
        Thu, 15 Dec 2022 03:39:46 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x66so6512375pfx.3;
        Thu, 15 Dec 2022 03:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLG3GskQNPwnXFfpwtJ413hWYf/t2snRdM+z5Y/9OjI=;
        b=ZIy6wxOzkoXpM8e2+LwciduP0g84nGWOxtS2XtUT+gEACc09McQKtGte7+U0QQ3EkE
         6+vlD6woRzx+gC3y3mLqGVzAkdYguTlR/U3gUP/AZb3EWKVeAUGVAYo3PgpSc9O5gNTt
         X095+bEEjZ8QQDRh59jfJJjXwWLtje5D/dlyn+lym9XUUyVP0yxLc5ZbayZ1rBivsPFT
         oI35qS0x3moWJSCp90DHYBknCQvJ68sPpR8oMmU50T4yI9IhyMOENwVd97ka00E+CEvd
         nwdgRN5/yzjwh2S0BdXKIHiu3s8xWb5RoI+baND5y42VaT6cmAWl7B5BMIfRaj3uOlSX
         3vEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLG3GskQNPwnXFfpwtJ413hWYf/t2snRdM+z5Y/9OjI=;
        b=Z9dX2olO5UYJ1akpM7VzQOVvh7+Dx4pjxgdSXS89/N8fHInQ8s8XyfCGd+2WVN/e5K
         OgeDsbQFKtvJ6iU+Zs8jQvsqDLRhO4TeAD1dC1tK+IhLMRNvVW8NP/wRyDwEgTqhei3Z
         /IpN0gN0SWDZoHxJqCPuSmdaJ8uMqkdGgoiWYaxt/gJh5kn5BZ4O/I/kctM7SN6ZLTNT
         0K7VXVv/aqtDZRO2lpyVa854FTBMqFQUCrHvs9xyWqqAMUKDx1xZkoju5AWWJ18AI6n8
         hkcKIb+tZiWBWIPDP4VjZE2coyVquRpCAUOgF2mJmH1pvgQw1IqVoz3owr82YYWD4Ihi
         yuQQ==
X-Gm-Message-State: ANoB5pm2oISAqZeqhIUd9MoeMSkAVnUBteUXbweZDD8Mtj/Qysi0MbzI
        Pbx2xClm+d2B4iVgZp6pltSE5/8Tlgwp
X-Google-Smtp-Source: AA0mqf52WkR9TsAhWYKjypO7nMKtKuX900fipDtThpdH0o+5l1upjKZlJC7cp1Fu/WQZMDdP5912dA==
X-Received: by 2002:a05:6a00:2255:b0:578:3592:6eb7 with SMTP id i21-20020a056a00225500b0057835926eb7mr22151615pfu.25.1671104386225;
        Thu, 15 Dec 2022 03:39:46 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id g30-20020aa79dde000000b00574d38f4d37sm1553440pfq.45.2022.12.15.03.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 03:39:45 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 2/5] samples: bpf: use vmlinux.h instead of implicit headers in syscall tracing program
Date:   Thu, 15 Dec 2022 20:39:34 +0900
Message-Id: <20221215113937.113936-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221215113937.113936-1-danieltimlee@gmail.com>
References: <20221215113937.113936-1-danieltimlee@gmail.com>
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

