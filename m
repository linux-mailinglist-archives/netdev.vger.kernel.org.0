Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348FB493839
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353681AbiASKRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353616AbiASKRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:17:04 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517D9C06161C;
        Wed, 19 Jan 2022 02:17:03 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id A6FD51F4443D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587422;
        bh=lQnYdF/4vaiSEAa1PT+XPuhoOtYBkfQMHnuIQgCAk70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwMmbICz7ibyvyWZ/Rl6zwFG2xnDZ3fj/fg8b9EmRLuMdL6HOKuhlXoLM3VRCSxbE
         Qi8i+rIK87Oq3Rp5Ro3G5vpK5r7qP3jN2HwTHzTDTkHqhTqQylcMNSKPO2m0efB/Qa
         x3SuPKLxeAPzNU3YY7k9LeinJ2afrRpPiln2mbXFltraSBm2/y7nHGnQvIqSRvy3fU
         4FkXsBYeJ5xMZvF63ZSe4s83TDFQLEdPiOngbsajXBCm0vimi9woeNqECRYEKzZ635
         6XmyzhDQDIAupjA7df+Lr54JnK3qOGkhin6sTVUVWVjAuUnDBri3iqutPlinIl3DSg
         sfzo3loHomnHg==
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
Subject: [PATCH V2 09/10] selftests: vm: Add the uapi headers include variable
Date:   Wed, 19 Jan 2022 15:15:30 +0500
Message-Id: <20220119101531.2850400-10-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220119101531.2850400-1-usama.anjum@collabora.com>
References: <20220119101531.2850400-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of tree build of this test fails if relative path of the output
directory is specified. Add the KHDR_INCLUDES to correctly reach the
headers.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes in V2:
        Revert the excessive cleanup which was breaking the individual
test build.
---
 tools/testing/selftests/vm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 7d100a7dc462..96714d2d49dc 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -23,7 +23,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/p
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
+CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
 TEST_GEN_FILES = compaction_test
 TEST_GEN_FILES += gup_test
-- 
2.30.2

