Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896732935EC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbgJTHip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbgJTHio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:38:44 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA2EC061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 00:38:44 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by baptiste.telenet-ops.be with bizsmtp
        id i7ei230074C55Sk017eiU3; Tue, 20 Oct 2020 09:38:42 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kUmEE-0004U3-2V; Tue, 20 Oct 2020 09:38:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kUmEE-0007c7-1F; Tue, 20 Oct 2020 09:38:42 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it
Date:   Tue, 20 Oct 2020 09:38:39 +0200
Message-Id: <20201020073839.29226-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
is done for all other IPv6 features.

Fixes: f870fa0b5768842c ("mptcp: Add MPTCP socket stubs")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/mptcp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index abb0a992d4a0855a..8936604b3bf9d76d 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -19,7 +19,7 @@ config INET_MPTCP_DIAG
 
 config MPTCP_IPV6
 	bool "MPTCP: IPv6 support for Multipath TCP"
-	select IPV6
+	depends on IPV6
 	default y
 
 config MPTCP_KUNIT_TESTS
-- 
2.17.1

