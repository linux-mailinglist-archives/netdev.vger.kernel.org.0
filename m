Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E8A82F33
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbfHFKBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:01:03 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43387 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732559AbfHFKBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 06:01:03 -0400
Received: by mail-yb1-f196.google.com with SMTP id y123so27390938yby.10
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 03:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BrBBFjqsIPWSTPOwNEcUeajfoMogUhxNa7dexawAwRQ=;
        b=Un6oFivG+UxJxUJOYr8+LA93ywEnvAQtUBkTGho7Ltp6aiGVqv555mAWbj39vVVe4T
         tTAZGZRpv3XowvmjuMFxMrBReXJdTs8FxGKnoziDeXG0a4qL4zmORnd9YynujYMNhNfH
         4ecvqroC3gmCOKv5mJHmY4V38pqK6HNSb1geNVBH3Ivvtta3hsjCkmzLX9KUaWgVC6lX
         kJB08KuTYFEWh/U6h9qYHQxR8vAbQxOtxHmBwM3NjyhcgI62tYhGmkw/q+wYGZwhLkHO
         4UzK1unsE6K15NH9p83nxGH/Qi30CQ2wvypdep65rye0RfNW5eLhw6/oUpCmj6Y9CEBx
         AQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BrBBFjqsIPWSTPOwNEcUeajfoMogUhxNa7dexawAwRQ=;
        b=eo7Dgl31tu7kMPcHVpZHemEK0Y2QxA7OUoLO73GSUharyzWuMFevPeAJJWWa4LnSXb
         yd9lW8RvW5rU7lL0ZHqEPou1SL0545V5lmzfm0JstofTN7oDFiFNDW/PXuJXZiCSZ6ps
         IBQQZMzuaCMYnNq2+JbTSTqcooaa5njXooEhJx1SRB5SZL6dAAkXRF/uwd8YpeHGntWT
         ZZm6T8eU1VD7a0vtT7eSRk5KNVd3PnuEGwmpZDa2T2J+J5DCK2Uxm7jAutQj2U810dHy
         QQMCCFYFuztOIHq77Iorr5+Lan5YRXth3KbB0gAaZtpwE8wCyCLhmDMYlFhrji548xr2
         FPkA==
X-Gm-Message-State: APjAAAW4TEVcbSYEVvch+BorcNBnEekoJN1Uy9KSmeKfqL0nb/BRaPUN
        whFni5Lj2jWWQ2sYDVN9a91ZhQ==
X-Google-Smtp-Source: APXvYqxlrdnW4SC05Llg8qrkK8vk5nJO9H/xk4mq0I/hM9oXEKg8zKXbxtiK57fOJLDWI4AfH7i6MA==
X-Received: by 2002:a25:8410:: with SMTP id u16mr1788923ybk.466.1565085662057;
        Tue, 06 Aug 2019 03:01:02 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id h12sm18316685ywm.91.2019.08.06.03.00.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 03:01:01 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 1/3] error-injection: Consolidate override function definition
Date:   Tue,  6 Aug 2019 18:00:13 +0800
Message-Id: <20190806100015.11256-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190806100015.11256-1-leo.yan@linaro.org>
References: <20190806100015.11256-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function override_function_with_return() is defined separately for
each architecture and every architecture's definition is almost same
with each other.  E.g. x86 and powerpc both define function in its own
asm/error-injection.h header and override_function_with_return() has
the same definition, the only difference is that x86 defines an extra
function just_return_func() but it is specific for x86 and is only used
by x86's override_function_with_return(), so don't need to export this
function.

This patch consolidates override_function_with_return() definition into
asm-generic/error-injection.h header, thus all architectures can use the
common definition.  As result, the architecture specific headers are
removed; the include/linux/error-injection.h header also changes to
include asm-generic/error-injection.h header rather than architecture
header, furthermore, it includes linux/compiler.h for successful
compilation.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 arch/powerpc/include/asm/error-injection.h | 13 -------------
 arch/x86/include/asm/error-injection.h     | 13 -------------
 include/asm-generic/error-injection.h      |  6 ++++++
 include/linux/error-injection.h            |  6 +++---
 4 files changed, 9 insertions(+), 29 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/error-injection.h
 delete mode 100644 arch/x86/include/asm/error-injection.h

diff --git a/arch/powerpc/include/asm/error-injection.h b/arch/powerpc/include/asm/error-injection.h
deleted file mode 100644
index 62fd24739852..000000000000
--- a/arch/powerpc/include/asm/error-injection.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ */
-
-#ifndef _ASM_ERROR_INJECTION_H
-#define _ASM_ERROR_INJECTION_H
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <asm/ptrace.h>
-#include <asm-generic/error-injection.h>
-
-void override_function_with_return(struct pt_regs *regs);
-
-#endif /* _ASM_ERROR_INJECTION_H */
diff --git a/arch/x86/include/asm/error-injection.h b/arch/x86/include/asm/error-injection.h
deleted file mode 100644
index 47b7a1296245..000000000000
--- a/arch/x86/include/asm/error-injection.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_ERROR_INJECTION_H
-#define _ASM_ERROR_INJECTION_H
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <asm/ptrace.h>
-#include <asm-generic/error-injection.h>
-
-asmlinkage void just_return_func(void);
-void override_function_with_return(struct pt_regs *regs);
-
-#endif /* _ASM_ERROR_INJECTION_H */
diff --git a/include/asm-generic/error-injection.h b/include/asm-generic/error-injection.h
index 95a159a4137f..80ca61058dd2 100644
--- a/include/asm-generic/error-injection.h
+++ b/include/asm-generic/error-injection.h
@@ -16,6 +16,8 @@ struct error_injection_entry {
 	int		etype;
 };
 
+struct pt_regs;
+
 #ifdef CONFIG_FUNCTION_ERROR_INJECTION
 /*
  * Whitelist ganerating macro. Specify functions which can be
@@ -28,8 +30,12 @@ static struct error_injection_entry __used				\
 		.addr = (unsigned long)fname,				\
 		.etype = EI_ETYPE_##_etype,				\
 	};
+
+void override_function_with_return(struct pt_regs *regs);
 #else
 #define ALLOW_ERROR_INJECTION(fname, _etype)
+
+static inline void override_function_with_return(struct pt_regs *regs) { }
 #endif
 #endif
 
diff --git a/include/linux/error-injection.h b/include/linux/error-injection.h
index 280c61ecbf20..635a95caf29f 100644
--- a/include/linux/error-injection.h
+++ b/include/linux/error-injection.h
@@ -2,16 +2,16 @@
 #ifndef _LINUX_ERROR_INJECTION_H
 #define _LINUX_ERROR_INJECTION_H
 
-#ifdef CONFIG_FUNCTION_ERROR_INJECTION
+#include <linux/compiler.h>
+#include <asm-generic/error-injection.h>
 
-#include <asm/error-injection.h>
+#ifdef CONFIG_FUNCTION_ERROR_INJECTION
 
 extern bool within_error_injection_list(unsigned long addr);
 extern int get_injectable_error_type(unsigned long addr);
 
 #else /* !CONFIG_FUNCTION_ERROR_INJECTION */
 
-#include <asm-generic/error-injection.h>
 static inline bool within_error_injection_list(unsigned long addr)
 {
 	return false;
-- 
2.17.1

