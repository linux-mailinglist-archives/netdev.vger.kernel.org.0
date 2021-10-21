Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9743595F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhJUDsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhJUDrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B06C06176C;
        Wed, 20 Oct 2021 20:45:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y1so17550205plk.10;
        Wed, 20 Oct 2021 20:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uy3o0eBsmouk5ahMP3KJoDGcOIHNVLUaAaLBsszL4+Y=;
        b=R3/ueHF0dUBx+ft7vo2bPSGoyUu3C6CI1aqEBP6m5imsX+fM2mQ4Ot3GxvdM3LHNzd
         XWMoQa3fuF1UxkaW38MUMsWv+ujSWksCoV1pYsFbf0ZSWt2FMPcWGHuqlYhQnvZw5tOT
         X7ExQfMgPbEeqZS2wRiHxl8/QbC/bn2gtZ0lcyx/VCLG73WUJOYnD9s9HxIuKZOdE+1Z
         GmuNAEIFke4joS9L9jy83Bh3U0azss/r0JvKdy24eMCM7HWxNMHy4HPBgdrKgHKqJKjM
         Iw9FeNeGB94rbbV72hTF8sHztNkVn8gR6B4MLetGSRSLnyvwLncCAM15Dx00nm+kYeqm
         S9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uy3o0eBsmouk5ahMP3KJoDGcOIHNVLUaAaLBsszL4+Y=;
        b=q1PsWzYXTz3A2ia8geZJCdnId/c2JK4Wwfyx0FzmxreeY5p/7bKsVt7Tr0FrciZEP4
         U4azgMjLNU1wLyma34uyVnokEcEnfXDLPXqRy0ghQCJGZweUM2xYNbcPifpq/04+fuwF
         kuzJFuGY+PEIJg26oGiyFyC9DTNFWZj+c0xNp7PqBeZTQxvoK0FDHcYoJXcFNH9V/T3Q
         fr773DsGIqCQhBfVLi5WPXk4lFRq/cbXbVv+Ci13eFGq4ujxwqYo9RfYd11OLxmJ43RJ
         jS+xOjGXZv4kHC+x22RAqWZ81/s/32/0OzJAsP6CwjP69ccS+neQ6KCKwBYO66B/IlRU
         oRGg==
X-Gm-Message-State: AOAM532e5CSC4K9Pd4fTlPO0rikFuTxl1EYQfqm1MBztVndhJZNpu9Vc
        mI/NdpIYnxJPCLl0J9SUYqY=
X-Google-Smtp-Source: ABdhPJyW7Ikui+cme9Xhlpd/hF/RWFbJExS2TdOG3kb9pPK5BVi/Aohiu5p1m6CVCaudl1kJ/LW11Q==
X-Received: by 2002:a17:90a:de8f:: with SMTP id n15mr3615780pjv.155.1634787935181;
        Wed, 20 Oct 2021 20:45:35 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:34 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v5 08/15] samples/bpf/user: use TASK_COMM_LEN_16 instead of hard-coded 16
Date:   Thu, 21 Oct 2021 03:45:15 +0000
Message-Id: <20211021034516.4400-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The task comm size is invisible to the bpf userspace, we have to
define a new TASK_COMM_LEN_16 in the userspace. Use this macro instead
of the hard-coded 16 can make it more grepable.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 samples/bpf/offwaketime_user.c | 6 +++---
 samples/bpf/tracex2_user.c     | 7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/offwaketime_user.c b/samples/bpf/offwaketime_user.c
index 73a986876c1a..ca918ac93ee7 100644
--- a/samples/bpf/offwaketime_user.c
+++ b/samples/bpf/offwaketime_user.c
@@ -36,11 +36,11 @@ static void print_ksym(__u64 addr)
 		printf("%s;", sym->name);
 }
 
-#define TASK_COMM_LEN 16
+#define TASK_COMM_LEN_16 16
 
 struct key_t {
-	char waker[TASK_COMM_LEN];
-	char target[TASK_COMM_LEN];
+	char waker[TASK_COMM_LEN_16];
+	char target[TASK_COMM_LEN_16];
 	__u32 wret;
 	__u32 tret;
 };
diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
index 1626d51dfffd..70081d917c6d 100644
--- a/samples/bpf/tracex2_user.c
+++ b/samples/bpf/tracex2_user.c
@@ -10,8 +10,9 @@
 #include <bpf/libbpf.h>
 #include "bpf_util.h"
 
-#define MAX_INDEX	64
-#define MAX_STARS	38
+#define MAX_INDEX		64
+#define MAX_STARS		38
+#define TASK_COMM_LEN_16	16
 
 /* my_map, my_hist_map */
 static int map_fd[2];
@@ -28,7 +29,7 @@ static void stars(char *str, long val, long max, int width)
 }
 
 struct task {
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 	__u64 pid_tgid;
 	__u64 uid_gid;
 };
-- 
2.17.1

