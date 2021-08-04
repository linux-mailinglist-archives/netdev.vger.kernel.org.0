Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5113DFF4B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhHDKSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbhHDKSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:18:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A516DC061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 03:18:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDyJ-00047e-2O
        for netdev@vger.kernel.org; Wed, 04 Aug 2021 12:17:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C7C5F66079C
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:17:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 06952660791;
        Wed,  4 Aug 2021 10:17:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 98980810;
        Wed, 4 Aug 2021 10:17:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 1/5] can: j1939: j1939_session_tx_dat(): fix typo
Date:   Wed,  4 Aug 2021 12:17:49 +0200
Message-Id: <20210804101753.23826-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804101753.23826-1-mkl@pengutronix.de>
References: <20210804101753.23826-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a typo in the j1939_session_tx_dat() function.

Link: https://lore.kernel.org/r/20210729113917.1655492-1-mkl@pengutronix.de
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index dac70cdd3f41..a7f91db24f0e 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -822,7 +822,7 @@ static int j1939_session_tx_dat(struct j1939_session *session)
 		memcpy(&dat[1], &tpdat[offset], len);
 		ret = j1939_tp_tx_dat(session, dat, len + 1);
 		if (ret < 0) {
-			/* ENOBUS == CAN interface TX queue is full */
+			/* ENOBUFS == CAN interface TX queue is full */
 			if (ret != -ENOBUFS)
 				netdev_alert(priv->ndev,
 					     "%s: 0x%p: queue data error: %i\n",

base-commit: 7cdd0a89ec70ce6a720171f1f7817ee9502b134c
-- 
2.30.2


