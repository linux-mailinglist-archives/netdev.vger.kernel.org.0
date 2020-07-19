Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054BA224EB6
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 04:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgGSCRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 22:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgGSCRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 22:17:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB66FC0619D2;
        Sat, 18 Jul 2020 19:17:03 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so8604307pge.12;
        Sat, 18 Jul 2020 19:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kl14Oyojnz7qNzdRV9kI+oI9qkQq4W7peOgG+/MweoU=;
        b=S0w/Q3abVzMaa0Pd0coBL4i43B8ZKc9v9Yen8P4muuNJs1guw3MlR5AoFEWgL7DKe4
         xo8SGd9JNLlv5siZ13SDqNooEUp2Zwrb4InjZmNlUWu2IMuUEy8lJnPo2NGskEoY11pp
         7nZiKEJ2jLrsSrtZ1X4G4fwMYEW5IVF3WDWQVA47Nl2D7D4mm7OrMySqtSraOUkIC3Ow
         KBNllHlDpR6zZ+8FP1zOKCDi2rAXfF/G9K2R5E8QVAGWWXq0a0g62wLeykkeZAtO+z0K
         wYpVTSv9Uwd+PDuhYi+RCpGJd/z7gpUB8yYxEJDKrXTL1o2Sl5UmL8UU/roe6+fHw/c9
         EWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kl14Oyojnz7qNzdRV9kI+oI9qkQq4W7peOgG+/MweoU=;
        b=Ij6nvO5eGKe8MSlklKOk/PCi2RvGkxFub86DzGaOazavPYbHiZlMz1FSH2gB1Utzo6
         fdU+JfM6OEGMrYkoNMjJ2IBx3OsM6CrUfBcLwG3pMjrW7IknWb4fvD4rhPIFXaCUHy6N
         sVD1uKWq+a9tJf5yFOtn0hAsjS/FItRzqjCIKdEx1GuFQl62oOzkdHoQm21IIBv9bKi4
         SJNwwBXu3C2lYnyP5A2dbfdT4ntRTMiSZdIVDb/CDMDlmLyyj81B+h6wvZFBgbjZrjQv
         aVR4u7x3hzs7Vpay5pMGWntC1kVU5oAKvZLEjHF8vT3XcCvu/GdI4WXfD0qAvKVt7/24
         /p8w==
X-Gm-Message-State: AOAM531Tq8pxhkJiM97APlJ4atnSjrisT32hXlxYsIHdYDw4BiTctVkK
        qtWQr7U6kv8eYcZhSwNj9Ik=
X-Google-Smtp-Source: ABdhPJzTUABuF2Vzp+Y9Usd6Hjkm7rZDYp+mvf/3yQZOoG7CAfvk2coMFaxyRLh2S+YAc0Z4L3XduQ==
X-Received: by 2002:a62:834c:: with SMTP id h73mr14490407pfe.221.1595125023447;
        Sat, 18 Jul 2020 19:17:03 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id a68sm6891159pje.35.2020.07.18.19.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 19:17:03 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3/3] selftests/seccomp: add xtensa support
Date:   Sat, 18 Jul 2020 19:16:54 -0700
Message-Id: <20200719021654.25922-4-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200719021654.25922-1-jcmvbkbc@gmail.com>
References: <20200719021654.25922-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xtensa returns syscall number can be obtained and changed through the
struct user_pt_regs. Syscall return value register is fixed relatively
to the current register window in the user_pt_regs, so it needs a bit of
special treatment.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 252140a52553..1b445c2e7fbe 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -122,6 +122,8 @@ struct seccomp_data {
 #  define __NR_seccomp 358
 # elif defined(__s390__)
 #  define __NR_seccomp 348
+# elif defined(__xtensa__)
+#  define __NR_seccomp 337
 # else
 #  warning "seccomp syscall number unknown for this architecture"
 #  define __NR_seccomp 0xffff
@@ -1622,6 +1624,14 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 # define SYSCALL_SYSCALL_NUM regs[4]
 # define SYSCALL_RET	regs[2]
 # define SYSCALL_NUM_RET_SHARE_REG
+#elif defined(__xtensa__)
+# define ARCH_REGS	struct user_pt_regs
+# define SYSCALL_NUM	syscall
+/*
+ * On xtensa syscall return value is in the register
+ * a2 of the current window which is not fixed.
+ */
+#define SYSCALL_RET(reg) a[(reg).windowbase * 4 + 2]
 #else
 # error "Do not know how to find your architecture's registers and syscalls"
 #endif
@@ -1693,7 +1703,8 @@ void change_syscall(struct __test_metadata *_metadata,
 	EXPECT_EQ(0, ret) {}
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__powerpc__) || \
-	defined(__s390__) || defined(__hppa__) || defined(__riscv)
+	defined(__s390__) || defined(__hppa__) || defined(__riscv) || \
+	defined(__xtensa__)
 	{
 		regs.SYSCALL_NUM = syscall;
 	}
@@ -1736,6 +1747,9 @@ void change_syscall(struct __test_metadata *_metadata,
 	if (syscall == -1)
 #ifdef SYSCALL_NUM_RET_SHARE_REG
 		TH_LOG("Can't modify syscall return on this architecture");
+
+#elif defined(__xtensa__)
+		regs.SYSCALL_RET(regs) = result;
 #else
 		regs.SYSCALL_RET = result;
 #endif
-- 
2.20.1

