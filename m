Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFFB4924DE
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbiARLcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240107AbiARLbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:31:41 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44085C06174E;
        Tue, 18 Jan 2022 03:31:26 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id E8C341F43EBE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505485;
        bh=JhpCsybLmT57CKBzdEYbEYfBTmlpwJ2taSfigXWMgdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKMPtZooC5RNGM8no7wd4TPQzJOAGg8P1rSLdb3XxWAB0M579B20iFwWjd75fNoOP
         RgqW1Ng28T6lXniFr99oCcKCoLncT+26K0vt/slJlaja/RCDgQAoOmoXeRehH0rzb0
         fFznJ1qtbioFbt5sovD4Njq0G4aL6CFFyBEd8LihVqYCwC0yvHV6w0VrVA19+Kbh0m
         qOU1knAfZo6MvQpEsJbNcyslHVrsjcJIUkJbvEJ/N4Wc+IXoo7ImoAo6BgvYOqn15g
         BbaFm9kuAUS+/DnNeYF47GwRW6t3mH28ps48hB4bmlB8wVaqi9diFiH2Sdn/F1/SAm
         OrVeTzWOBLeOw==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-security-module@vger.kernel.org (open list:LANDLOCK SECURITY
        MODULE), netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 05/10] selftests: kvm: Add the uapi headers include variable
Date:   Tue, 18 Jan 2022 16:29:04 +0500
Message-Id: <20220118112909.1885705-6-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of tree build of this test fails if relative path of the output
directory is specified. Remove the un-needed include paths and use
KHDR_INCLUDES to correctly reach the headers.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/kvm/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ee8cf2149824..ce9c8857e14c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -136,8 +136,6 @@ TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
 
-INSTALL_HDR_PATH = $(top_srcdir)/usr
-LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
 ifeq ($(ARCH),x86_64)
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
@@ -146,7 +144,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
-	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
+	-I$(LINUX_TOOL_ARCH_INCLUDE) $(KHDR_INCLUDES) -Iinclude \
 	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS)
 
 no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
@@ -185,7 +183,7 @@ x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 all: $(STATIC_LIBS)
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
 
-cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
+cscope: include_paths = $(LINUX_TOOL_INCLUDE) include lib ..
 cscope:
 	$(RM) cscope.*
 	(find $(include_paths) -name '*.h' \
-- 
2.30.2

