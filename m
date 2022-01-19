Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9034149382E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353654AbiASKQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:16:55 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47734 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353589AbiASKQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:16:49 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 944F31F44438
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587408;
        bh=x8a+/rhJUZAIKALDJjBBCDWlAg+uFUzuTVsPSCbnIHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgNZ5WXHijtrat3Pgh3ZOaMi2tRnMkFgvN54h8z/dIuy6z3C94f9rIegI9PkZNLyW
         +39iLHTOpr1enYSwhxr0yf1JwbLKHvP0rNGnKEjnxPhfry5gtoiU8RMSOgMF8t1xLs
         iN26p9qCQLosHnwBjUWroyA1Zwi7tfVDotoRcc2C6nZ7Sm3OdJ5/QeGuoXNxtxiezA
         ChphF0Y7Epi/NXBgoQ2SqM1EsPP2f+1a2iGqprWsxy9SmoQjEAers9rddnzNstVs8J
         1C5JmA9m58hnjzCgCDM+w/2GsSZ+4IVWfWA//obZJ+igoaGSyYwSm3K8uT79FhRtgS
         68e8rQwRxRZ+w==
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
Subject: [PATCH V2 07/10] selftests: net: Add the uapi headers include variable
Date:   Wed, 19 Jan 2022 15:15:28 +0500
Message-Id: <20220119101531.2850400-8-usama.anjum@collabora.com>
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

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes in V2:
        Revert the excessive cleanup which was breaking the individual
test build.
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9897fa9ab953..0b1488616c55 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -2,7 +2,7 @@
 # Makefile for net selftests
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
-CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../usr/include/ $(KHDR_INCLUDES)
 
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
 	      rtnetlink.sh xfrm_policy.sh test_blackhole_dev.sh
-- 
2.30.2

