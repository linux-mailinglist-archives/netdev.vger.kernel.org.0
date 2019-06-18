Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDA44A8E9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfFRR51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:57:27 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:48487 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbfFRR50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:57:26 -0400
Received: from [5.158.153.53] (helo=nereus.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hdIMF-0006l3-UU; Tue, 18 Jun 2019 19:57:24 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [RFC PATCH 2/2] net: dsa: b53: enbale broadcom tags on bcm531x5
Date:   Tue, 18 Jun 2019 19:57:12 +0200
Message-Id: <20190618175712.71148-3-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20190618175712.71148-1-b.spranger@linutronix.de>
References: <20190618175712.71148-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The broadcom tags are required to distinguish the traffic from external
ports and not use a bridge like setup (which is currently broken because
managed mode is now enabled). The tagged mode works for broadcast and
unicast traffic. The multicast missis are not handled.

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 06b9a7a81ae0..10f1ece64104 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1793,7 +1793,7 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port)
 	 * mode to be turned on which means we need to specifically manage ARL
 	 * misses on multicast addresses (TBD).
 	 */
-	if (is5325(dev) || is5365(dev) || is539x(dev) || is531x5(dev) ||
+	if (is5325(dev) || is5365(dev) || is539x(dev) ||
 	    !b53_can_enable_brcm_tags(ds, port))
 		return DSA_TAG_PROTO_NONE;
 
-- 
2.19.0

