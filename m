Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA84924E6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiARLcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:32:13 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35896 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240722AbiARLbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:31:45 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 00AAA1F43EC4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505503;
        bh=c6ARDNQMLSW4/+Jdr9UKAZU1s8LQbK0RFS42X6aonwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYwPaVjIAAS+Kv60H7XU5+U0eu8tiWzYWlVpEUgumfIcWlmJ3B7H++AO8uBO4fZxZ
         KlK9PEzqMm5QuGShVub8sw/L14AS/Vz3QS+2U4+W41vpq1oanHbZLnzdEeYuVhezej
         CG5u7SKJWfx3bCYvaeT9vE3YgFt0QT/tznC9j0n5bXwzG5ifcNpd6eGlO30oKNApsf
         DNAYzq9s49328zD0hCbUmthRcYWWKmWJNmLpMnZ0Q2/8E9xL2q6tTXBNULux8nB8+9
         4SCkV4mR+h1LXha+GwEfOYbmewWnYodc1rh+BDH3PwCzbfVrMDtUBbU0mvBiKubV4H
         d3xgU00DpLG8g==
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
Subject: [PATCH 07/10] selftests: net: Add the uapi headers include variable
Date:   Tue, 18 Jan 2022 16:29:06 +0500
Message-Id: <20220118112909.1885705-8-usama.anjum@collabora.com>
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
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9897fa9ab953..22759591fc79 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -2,7 +2,7 @@
 # Makefile for net selftests
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
 	      rtnetlink.sh xfrm_policy.sh test_blackhole_dev.sh
-- 
2.30.2

