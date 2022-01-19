Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E752493829
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353648AbiASKQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:16:49 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47708 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353604AbiASKQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:16:43 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 7E05B1F44434
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587402;
        bh=Jw6rL5aZMlTMqMdSpKS4Pzt24AHAhEIkIB28v6p/uW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBLsXF7uQxa2rD+wV5gFAkHNJhD1fJrcvVyaQtb7G2hYa10KRdkgi4QHES8vrTjci
         pWbUuIaSnZoctbDiqa2GHKHnKgMMA3aVwhf33LMNA3Jcb/w5gE3LgWsvkAsnEAcvCH
         sKuX3McgvQKyHKn05QTAMxK+zdw0iI9pthwHjcRnGN8WwHmFcM0aadTqHN+xT5Fo+c
         h6dJ8QwR4k1D+Isrw4igcDZAB3lGWMlwfzyp8ac65UuKLbv2iG/LDfq7Go7OLYkYcZ
         +fKswngI9xoIWSX0MWreRyOAHjc+tSprnILvMQG+hRIaA5fmavwt4ywLHfVpRLW37N
         pWeDKIVnzBwXw==
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
Subject: [PATCH V2 06/10] selftests: landlock: Add the uapi headers include variable
Date:   Wed, 19 Jan 2022 15:15:27 +0500
Message-Id: <20220119101531.2850400-7-usama.anjum@collabora.com>
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
 tools/testing/selftests/landlock/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index a99596ca9882..0b0049e133bb 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -Wall -O2
+CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
 
 src_test := $(wildcard *_test.c)
 
-- 
2.30.2

