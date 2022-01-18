Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048B14924D3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiARLbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240170AbiARLbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:31:17 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EE3C06173E;
        Tue, 18 Jan 2022 03:31:17 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id E89C61F43EAC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505476;
        bh=quQqOgE+qpfCtHHrJtyaS3otvFZ8NW4tc4U/r/42qw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfpbNJrycuQvPqZSVP14/FBD+H5Oeq9sTIqpJKcjivtiq5qAXkGgvOIaZkSiwbvC3
         bTKk2fd5FlzjHRxfb3QKhqEMTJYhvlCzCzd1ec46dG3OP2xU3OmmeKJWvKuMr/QR12
         LJSt2GHQMm/OIfftguSj9DAm7AGsiDq7B7fzqmyaY1Xnb6dpl9rvP5Tx0ZHWV64JBX
         g5KcB0mFJn4gieDsWGa3CJC1rLjghrYyW8q/VSFBwvXJswK+2GgNiLynZJ6MYhC5m4
         RX4gwuslnAjCwpcQoz18UZwJqIBeACn01DSidYQWk86MLtNJZlmDRr1dPV27Dg/VjG
         Tud39RsoOXw8g==
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
Subject: [PATCH 04/10] selftests: futex: Add the uapi headers include variable
Date:   Tue, 18 Jan 2022 16:29:03 +0500
Message-Id: <20220118112909.1885705-5-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of tree build of this test fails if relative path of the output
directory is specified. KBUILD_OUTPUT also doesn't point to the correct
directory when relative path is used. Thus out of tree builds fail.
Remove the un-needed include paths and use KHDR_INCLUDES to correctly
reach the headers.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/futex/functional/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 5cc38de9d8ea..7ff1e764407b 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-INCLUDES := -I../include -I../../ -I../../../../../usr/include/ \
-	-I$(KBUILD_OUTPUT)/kselftest/usr/include
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
+INCLUDES := -I../include -I../../
+CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
 HEADERS := \
-- 
2.30.2

