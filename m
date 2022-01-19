Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E87493822
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353561AbiASKQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353579AbiASKQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:16:24 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDA3C061748;
        Wed, 19 Jan 2022 02:16:24 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 45F681F44431
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587383;
        bh=znkuJknUIKmC97C/L7k2VJMosG9Fleiln09UWKBevLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMr42Mf9v5dvg91/N7pjzAnb6ewlPB9KDLkPKPYBUmFbZl+LRNbnmjJlGZ8AAJPkO
         WM506udaVHrthnl4lTYOzwmwE3bE4ToKmfEVrs1Deq+tZLXEwMPlnTNK1T3pnA5yda
         MQKzyMjTXvSHIZAgIsQrryVdCJ9lq7prKESE87sIccPpcSAT2X/N/7q0EGXLIJam6P
         PKn85SKWidNGsco7EuHkVxfnVlErNr4ijmXQXH3C8XJSVW/iF75jpYYJxCYnB60Yqd
         9zQiA0pBJMuzmizt4sy+Qs6qTXRWlrnOCTMOn9aeNZaVd//GSJNdqceqdBfAyZNov8
         0/IBmllmo4l9Q==
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
Subject: [PATCH V2 04/10] selftests: futex: Add the uapi headers include variable
Date:   Wed, 19 Jan 2022 15:15:25 +0500
Message-Id: <20220119101531.2850400-5-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220119101531.2850400-1-usama.anjum@collabora.com>
References: <20220119101531.2850400-1-usama.anjum@collabora.com>
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
Changes in V2:
	Revert the excessive cleanup which was breaking the individual
test build.
---
 tools/testing/selftests/futex/functional/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 5cc38de9d8ea..2a12b174cb04 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-INCLUDES := -I../include -I../../ -I../../../../../usr/include/ \
-	-I$(KBUILD_OUTPUT)/kselftest/usr/include
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
+INCLUDES := -I../include -I../../ -I../../../../../usr/include/
+CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
 HEADERS := \
-- 
2.30.2

