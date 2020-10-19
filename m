Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE88F292666
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgJSLcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgJSLcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:32:46 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2565AC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 04:32:46 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id hnYi230024C55Sk01nYiAJ; Mon, 19 Oct 2020 13:32:43 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kUTP8-000055-11; Mon, 19 Oct 2020 13:32:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kUTP7-00030U-VE; Mon, 19 Oct 2020 13:32:41 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead of selecting it
Date:   Mon, 19 Oct 2020 13:32:40 +0200
Message-Id: <20201019113240.11516-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
user may not want to enable.  Fix this by making the test depend on
MPTCP instead.

Fixes: a00a582203dbc43e ("mptcp: move crypto test to KUNIT")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/mptcp/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index 698bc35251609755..abb0a992d4a0855a 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -22,11 +22,8 @@ config MPTCP_IPV6
 	select IPV6
 	default y
 
-endif
-
 config MPTCP_KUNIT_TESTS
 	tristate "This builds the MPTCP KUnit tests" if !KUNIT_ALL_TESTS
-	select MPTCP
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
@@ -39,3 +36,4 @@ config MPTCP_KUNIT_TESTS
 
 	  If unsure, say N.
 
+endif
-- 
2.17.1

