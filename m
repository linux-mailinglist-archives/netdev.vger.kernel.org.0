Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7714026FE24
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgIRNUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgIRNUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:20:02 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE11C06178A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 06:20:02 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c59714ead05d12fb7f5a0314d0.dip0.t-ipconnect.de [IPv6:2003:c5:9714:ead0:5d12:fb7f:5a03:14d0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 8E30862076;
        Fri, 18 Sep 2020 15:19:59 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/6] batman-adv: Add missing include for in_interrupt()
Date:   Fri, 18 Sep 2020 15:19:53 +0200
Message-Id: <20200918131956.21598-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200918131956.21598-1-sw@simonwunderlich.de>
References: <20200918131956.21598-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The fix for receiving (internally generated) bla packets outside the
interrupt context introduced the usage of in_interrupt(). But this
functionality is only defined in linux/preempt.h which was not included
with the same patch.

Fixes: 279e89b2281a ("batman-adv: bla: use netif_rx_ni when not in interrupt context")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index d8c5d3170676..08419a2e6b95 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -25,6 +25,7 @@
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
+#include <linux/preempt.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/seq_file.h>
-- 
2.20.1

