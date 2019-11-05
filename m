Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F3F02EE
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbfKEQdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:06 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41231 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390443AbfKEQcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:51 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1lA-0002Hp-Ur; Tue, 05 Nov 2019 17:32:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 30/33] can: j1939: transport: j1939_session_fresh_new(): make sure EOMA is send with the total message size set
Date:   Tue,  5 Nov 2019 17:32:12 +0100
Message-Id: <20191105163215.30194-31-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

We were sending malformed EOMA messageswith total message size set to 0.

This patch fixes the bug.

Reported-by: https://github.com/linux-can/can-utils/issues/159
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index fe000ea757ea..06183d6f4fb7 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1432,7 +1432,7 @@ j1939_session *j1939_session_fresh_new(struct j1939_priv *priv,
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
-	session = j1939_session_new(priv, skb, skb->len);
+	session = j1939_session_new(priv, skb, size);
 	if (!session) {
 		kfree_skb(skb);
 		return NULL;
-- 
2.24.0.rc1

