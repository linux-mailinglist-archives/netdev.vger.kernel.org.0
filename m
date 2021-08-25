Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368AD3F71D1
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbhHYJgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239701AbhHYJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:36:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9C9C0613D9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 02:35:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIpJb-00048a-4z
        for netdev@vger.kernel.org; Wed, 25 Aug 2021 11:35:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 59DDC66F5B4
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:35:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 048A366F594;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 73a77a4b;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        kernel test robot <lkp@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 2/4] can: rcar_canfd: rcar_canfd_handle_channel_tx(): fix redundant assignment
Date:   Wed, 25 Aug 2021 11:35:14 +0200
Message-Id: <20210825093516.448231-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210825093516.448231-1-mkl@pengutronix.de>
References: <20210825093516.448231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Fix redundant assignment of 'priv' to itself in
rcar_canfd_handle_channel_tx().

Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
Link: https://lore.kernel.org/r/20210820161449.18169-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 5d4d52afde15..c47988d3674e 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1182,7 +1182,7 @@ static void rcar_canfd_state_change(struct net_device *ndev,
 
 static void rcar_canfd_handle_channel_tx(struct rcar_canfd_global *gpriv, u32 ch)
 {
-	struct rcar_canfd_channel *priv = priv = gpriv->ch[ch];
+	struct rcar_canfd_channel *priv = gpriv->ch[ch];
 	struct net_device *ndev = priv->ndev;
 	u32 sts;
 
-- 
2.32.0


