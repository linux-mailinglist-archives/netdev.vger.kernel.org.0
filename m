Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE6C493819
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353576AbiASKQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:16:23 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47622 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353569AbiASKQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:16:12 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 402341F44433
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587370;
        bh=FL5woJicBxOM7EavfZYCVa1miYOdVihihV/Qs6cofek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdcJQjDu26wN05TdI8aYqDCOAiBNtH5/rqq3AvUDfM/L3bx1ENivnFE7r3oAcKiCf
         HumKgq3sxh7XKgFh6WdF1mxSUEBO9JZW89fe692/LL/+zQNEEUUv4qGLMdAvXiMJag
         8oXHnozTxvO1TqGyQIdX2pJpNZYcFUyhGGtUjw40OaGVzIRV7qAsZPpW6wrBp2we6+
         c4u57vBgek39Os8388zV9iqvzCQYbMbVgWoU/0YfXFa0a/NT2zZAS+oKZst3Nf4cDw
         vmTWzVcbfXYs+BaOkcSGosPDK/sIqZrwnM+xpxSj7SKfRyJ5kkAfqGnNaDJhJ43C8R
         7A95oiEELZzcw==
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
Subject: [PATCH V2 03/10] selftests: Correct the headers install path
Date:   Wed, 19 Jan 2022 15:15:24 +0500
Message-Id: <20220119101531.2850400-4-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220119101531.2850400-1-usama.anjum@collabora.com>
References: <20220119101531.2850400-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uapi headers should be installed at the top of the object tree,
"<obj_tree>/usr/include". There is no need for kernel headers to
be present at kselftest build directory, "<obj_tree>/kselftest/usr/
include" as well. This duplication can be avoided by correctly
specifying the INSTALL_HDR_PATH.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 21f983dfd047..80e5498eab92 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -167,7 +167,7 @@ khdr:
 ifeq (1,$(DEFAULT_INSTALL_HDR_PATH))
 	$(MAKE) --no-builtin-rules ARCH=$(ARCH) -C $(top_srcdir) headers_install
 else
-	$(MAKE) --no-builtin-rules INSTALL_HDR_PATH=$$BUILD/usr \
+	$(MAKE) --no-builtin-rules INSTALL_HDR_PATH=$(abs_objtree)/usr \
 		ARCH=$(ARCH) -C $(top_srcdir) headers_install
 endif
 
-- 
2.30.2

