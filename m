Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F8D475547
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbhLOJg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241219AbhLOJg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:36:27 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B8EC06173F
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 01:36:27 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id WZcR2600H4C55Sk06ZcRm9; Wed, 15 Dec 2021 10:36:25 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mxQi1-0056ds-5o; Wed, 15 Dec 2021 10:36:25 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mxQi0-009b1O-1E; Wed, 15 Dec 2021 10:36:24 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH -next] lib: TEST_REF_TRACKER should depend on REF_TRACKER instead of selecting it
Date:   Wed, 15 Dec 2021 10:36:18 +0100
Message-Id: <0b6c06487234b0fb52b7a2fbd2237af42f9d11a6.1639560869.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TEST_REF_TRACKER selects REF_TRACKER, thus enabling an optional feature
the user may not want to have enabled.  Fix this by making the test
depend on REF_TRACKER instead.

Fixes: 914a7b5000d08f14 ("lib: add tests for reference tracker")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 lib/Kconfig.debug | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c77fe36bb3d89685..d5e4afee09d78a1e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2114,8 +2114,7 @@ config BACKTRACE_SELF_TEST
 
 config TEST_REF_TRACKER
 	tristate "Self test for reference tracker"
-	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
-	select REF_TRACKER
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT && REF_TRACKER
 	help
 	  This option provides a kernel module performing tests
 	  using reference tracker infrastructure.
-- 
2.25.1

