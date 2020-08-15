Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F266A245346
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgHOV7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgHOVvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:38 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D275BC00458E
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 11:33:33 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4BTTTL5WKyzKmgL;
        Sat, 15 Aug 2020 20:33:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id wVNxI0bzlel4; Sat, 15 Aug 2020 20:33:23 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] net: lantiq: use netif_tx_napi_add() for TX NAPI
Date:   Sat, 15 Aug 2020 20:33:13 +0200
Message-Id: <20200815183314.404-2-hauke@hauke-m.de>
In-Reply-To: <20200815183314.404-1-hauke@hauke-m.de>
References: <20200815183314.404-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.84 / 15.00 / 15.00
X-Rspamd-Queue-Id: A6196182B
X-Rspamd-UID: 66be5d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_tx_napi_add() should be used for NAPI in the TX direction instead
of the netif_napi_add() function.

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 1feb9fc710e0..f34e4dc8c661 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -502,7 +502,7 @@ static int xrx200_probe(struct platform_device *pdev)
 
 	/* setup NAPI */
 	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx, 32);
-	netif_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
+	netif_tx_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
 
 	platform_set_drvdata(pdev, priv);
 
-- 
2.20.1

