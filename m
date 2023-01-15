Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1376E66AFB1
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjAOHSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjAOHRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:17:05 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EBCB47E;
        Sat, 14 Jan 2023 23:16:53 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r18so17603897pgr.12;
        Sat, 14 Jan 2023 23:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXtBMdlxptD+rgtlXku5y/M/YWWbgrzqb1KWu60anSo=;
        b=BzmMU/twu97qKTkVkWbfv/IpCYI7V78IjtH988IqnzkiwIotFszjB/0iW4aaIh2PkQ
         xQe9B6Yx8zLJm9PsstCTVI2RIwr+UKI4bxo9ym22HOs1l/RyiI/59YX0Zp3yGioEtYEe
         Qu0gNltLlB1HXc11BHyTelg3OdzPMhFepJEosvg+0PATsqDbb4s+vk9Da7nYok9INw8x
         Oer/8+qoex1iwnMcdiRWxlEg17iB7d+RubnseD5WjQcNU2Jcvs3KghAhh5WGqXkDKmCr
         zXvczc4sy+RlwjQGGerTHnMrTyySdel0S6Ntrp/79hRz14LdUd9TdQ+IRJoVBhSto6bJ
         IRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXtBMdlxptD+rgtlXku5y/M/YWWbgrzqb1KWu60anSo=;
        b=KkMTz+65ewKEClUFOEG66F6fo/1hQiJF48z57hpRdTbbRftdk5DySBbVd6BtQ7MnfF
         jrN3VPucX+z7pwX6y7HlpVbkk2EQGywOvrFUfvE51CASqc7nEF8540Jic5p2EamSTvBR
         /l9yV5Oru5nN6Wd9rVy2AmK2voCRwVXEvu5P/mZzqo05zrM/2jR2LYxQBNs8jae7K/25
         uCyccNoS8kDlHSKtuuNv7IkXxT9LJNOK9S5YdSsf6yhVOKDGSW1+1S5Ea3DM0aPt98KA
         ZpEqkgACUui9YmtT78YyGnP9NV3DRWzusc+Ca2aGz31kjLsXaeIe55y6l93aJBczMCpS
         shug==
X-Gm-Message-State: AFqh2kp0b955/FFZpNLOj7uHaJIozH/qtSxy9szQ9wncMyoZollzng5A
        n3FUejGFvVTCHVjZ8fD1NA==
X-Google-Smtp-Source: AMrXdXs56/WCCSSciGtUdzHeaGwrcYkmERKIE5bb4yigLmTgf5G8RRH6ADAjlzf9Yi93UhS1aN6deA==
X-Received: by 2002:a05:6a00:198c:b0:582:d44f:3948 with SMTP id d12-20020a056a00198c00b00582d44f3948mr41081152pfl.18.1673767012723;
        Sat, 14 Jan 2023 23:16:52 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:52 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 09/10] samples/bpf: use vmlinux.h instead of implicit headers in BPF test program
Date:   Sun, 15 Jan 2023 16:16:12 +0900
Message-Id: <20230115071613.125791-10-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
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

This commit applies vmlinux.h to BPF functionality testing program.
Macros that were not defined despite migration to "vmlinux.h" were
defined separately in individual files.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/lwt_len_hist_kern.c         |  5 +----
 samples/bpf/sock_flags_kern.c           |  6 ++----
 samples/bpf/test_cgrp2_tc_kern.c        |  3 +--
 samples/bpf/test_lwt_bpf.c              | 11 +----------
 samples/bpf/test_map_in_map_kern.c      |  7 ++++---
 samples/bpf/test_overhead_kprobe_kern.c |  4 +---
 samples/bpf/test_overhead_raw_tp_kern.c |  2 +-
 samples/bpf/test_overhead_tp_kern.c     |  3 +--
 8 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist_kern.c
index 44ea7b56760e..dbab80e813fe 100644
--- a/samples/bpf/lwt_len_hist_kern.c
+++ b/samples/bpf/lwt_len_hist_kern.c
@@ -10,10 +10,7 @@
  * General Public License for more details.
  */
 
-#include <uapi/linux/bpf.h>
-#include <uapi/linux/if_ether.h>
-#include <uapi/linux/ip.h>
-#include <uapi/linux/in.h>
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 
 struct {
diff --git a/samples/bpf/sock_flags_kern.c b/samples/bpf/sock_flags_kern.c
index 84837ed48eb3..0da749f6a9e1 100644
--- a/samples/bpf/sock_flags_kern.c
+++ b/samples/bpf/sock_flags_kern.c
@@ -1,8 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "vmlinux.h"
 #include "net_shared.h"
-#include <uapi/linux/bpf.h>
-#include <linux/net.h>
-#include <uapi/linux/in.h>
-#include <uapi/linux/in6.h>
 #include <bpf/bpf_helpers.h>
 
 SEC("cgroup/sock")
diff --git a/samples/bpf/test_cgrp2_tc_kern.c b/samples/bpf/test_cgrp2_tc_kern.c
index 45a2f01d2029..c7d2291d676f 100644
--- a/samples/bpf/test_cgrp2_tc_kern.c
+++ b/samples/bpf/test_cgrp2_tc_kern.c
@@ -5,9 +5,8 @@
  * License as published by the Free Software Foundation.
  */
 #define KBUILD_MODNAME "foo"
+#include "vmlinux.h"
 #include "net_shared.h"
-#include <uapi/linux/ipv6.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
 /* copy of 'struct ethhdr' without __packed */
diff --git a/samples/bpf/test_lwt_bpf.c b/samples/bpf/test_lwt_bpf.c
index fc093fbc760a..9a13dbb81847 100644
--- a/samples/bpf/test_lwt_bpf.c
+++ b/samples/bpf/test_lwt_bpf.c
@@ -10,17 +10,8 @@
  * General Public License for more details.
  */
 
+#include "vmlinux.h"
 #include "net_shared.h"
-#include <stdint.h>
-#include <stddef.h>
-#include <linux/bpf.h>
-#include <linux/ip.h>
-#include <linux/in.h>
-#include <linux/in6.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
-#include <linux/icmpv6.h>
-#include <linux/if_ether.h>
 #include <bpf/bpf_helpers.h>
 #include <string.h>
 
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 0e17f9ade5c5..1883559e5977 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -6,16 +6,17 @@
  * License as published by the Free Software Foundation.
  */
 #define KBUILD_MODNAME "foo"
-#include <linux/ptrace.h>
+#include "vmlinux.h"
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
-#include <uapi/linux/in6.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
 
 #define MAX_NR_PORTS 65536
 
+#define EINVAL 22
+#define ENOENT 2
+
 /* map #0 */
 struct inner_a {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
index ba82949338c2..c3528731e0e1 100644
--- a/samples/bpf/test_overhead_kprobe_kern.c
+++ b/samples/bpf/test_overhead_kprobe_kern.c
@@ -4,10 +4,8 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
+#include "vmlinux.h"
 #include <linux/version.h>
-#include <linux/ptrace.h>
-#include <linux/sched.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
diff --git a/samples/bpf/test_overhead_raw_tp_kern.c b/samples/bpf/test_overhead_raw_tp_kern.c
index 3e29de0eca98..6af39fe3f8dd 100644
--- a/samples/bpf/test_overhead_raw_tp_kern.c
+++ b/samples/bpf/test_overhead_raw_tp_kern.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018 Facebook */
-#include <uapi/linux/bpf.h>
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 
 SEC("raw_tracepoint/task_rename")
diff --git a/samples/bpf/test_overhead_tp_kern.c b/samples/bpf/test_overhead_tp_kern.c
index f170e9b1ea21..67cab3881969 100644
--- a/samples/bpf/test_overhead_tp_kern.c
+++ b/samples/bpf/test_overhead_tp_kern.c
@@ -4,8 +4,7 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/sched.h>
-#include <uapi/linux/bpf.h>
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 
 /* from /sys/kernel/debug/tracing/events/task/task_rename/format */
-- 
2.34.1

