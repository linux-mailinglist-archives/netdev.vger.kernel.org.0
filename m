Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF551470762
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241557AbhLJRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241481AbhLJRiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:38:13 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA01C061353
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:34:38 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id 7so14107630oip.12
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/dJmFjhwnInM6FSSfxFjvPIjNEnQu2yNBTZVyR0edug=;
        b=H84W+u8ZuMN5VRT4atnpiZFWjKwGaSqbEQHfol1liXDySnPSsLnLZeqUiIQgXscWrM
         xC1B49/NW0FYtKotyCwHSl/Nl4z6cHFf6levmetWtX6CoCWhK9T/zDV5sHl8XI+cXGea
         pkesln0SPt0yZWLC1pN+i0nG5pezdpC2c2oiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/dJmFjhwnInM6FSSfxFjvPIjNEnQu2yNBTZVyR0edug=;
        b=IfV7GFf/sBDGAUMyD1ePnMZ7jcZWOd0n5f90c4wHhG04KsgQCrEHeSXrJyUtbKuqA+
         CqO4pjcS9rz4CbseBpI2t+HRANlP0O3aqx6mKqDTPxvBkJcs9C2cN3X0+QXWEO8md7R6
         9YuFGC7/yVSOlqazK6QB3qvjAbX2RNWL+vkb0fT3zUEks2FZd38/7JXdbaGzO3yF3AQP
         X3J1r6NEcbMXZRRwZ21vsygy4vkRK3kbSNGiCnw4hiCgS3rCS0WqIziprIm1gVHT+Cq/
         NvtueZBhuQWQTE1MEQV5jwGXVnPB3gnWwXLCCSKfR0zCsRoTJ/a7BT2TaYuzjyxBVqWq
         02MA==
X-Gm-Message-State: AOAM5335TUjUKtrc1oWxKBRfm4ifcbB4CFFTNZ6FKu2fGqPgJGKqiIho
        PcdwMpzgR0fnnmrDMWi7+MyPTw==
X-Google-Smtp-Source: ABdhPJy15Gc8S3I8657EioGcfpK4uWVD6XI1GMbZgcAgsTrTw4LKvABQ+oBtRdzT3LF81vLPKkbljg==
X-Received: by 2002:aca:61c6:: with SMTP id v189mr13118314oib.103.1639157677771;
        Fri, 10 Dec 2021 09:34:37 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id ay40sm808342oib.1.2021.12.10.09.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:34:37 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/bpf: remove ARRAY_SIZE defines from tests
Date:   Fri, 10 Dec 2021 10:34:33 -0700
Message-Id: <20211210173433.13247-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARRAY_SIZE is defined in multiple test files. Remove the definitions
and include header file for the define instead.

Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
define.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
 tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
 tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
 5 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
index 1d8918dfbd3f..7a5ebd330689 100644
--- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -5,6 +5,7 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
+#include <bpf/bpf_util.h>
 
 #include <errno.h>
 
@@ -23,10 +24,6 @@ bool skip = false;
 #define BADPTR			0
 #endif
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
-#endif
-
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__uint(max_entries, 1);
diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 4896fdf816f7..aad30994ecd7 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -4,6 +4,7 @@
 #include <bpf/bpf_core_read.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_util.h>
 
 #include "profiler.h"
 
@@ -132,10 +133,6 @@ struct {
 	__uint(max_entries, 16);
 } disallowed_exec_inodes SEC(".maps");
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
-#endif
-
 static INLINE bool IS_ERR(const void* ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
index 553a282d816a..c7c512e0af79 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
@@ -8,10 +8,7 @@
 #include <linux/bpf.h>
 
 #include <bpf/bpf_helpers.h>
-
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
+#include <bpf/bpf_util.h>
 
 /* tcp_mem sysctl has only 3 ints, but this test is doing TCP_MEM_LOOPS */
 #define TCP_MEM_LOOPS 28  /* because 30 doesn't fit into 512 bytes of stack */
diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
index 2b64bc563a12..57cda15d0032 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
@@ -8,10 +8,8 @@
 #include <linux/bpf.h>
 
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_util.h>
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
 
 /* tcp_mem sysctl has only 3 ints, but this test is doing TCP_MEM_LOOPS */
 #define TCP_MEM_LOOPS 20  /* because 30 doesn't fit into 512 bytes of stack */
diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
index 5489823c83fc..6047c39eb457 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
@@ -8,6 +8,7 @@
 #include <linux/bpf.h>
 
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_util.h>
 
 /* Max supported length of a string with unsigned long in base 10 (pow2 - 1). */
 #define MAX_ULONG_STR_LEN 0xF
@@ -15,10 +16,6 @@
 /* Max supported length of sysctl value string (pow2). */
 #define MAX_VALUE_STR_LEN 0x40
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
-
 const char tcp_mem_name[] = "net/ipv4/tcp_mem";
 static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
 {
-- 
2.32.0

