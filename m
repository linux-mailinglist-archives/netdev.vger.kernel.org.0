Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB5267C0A
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgILThF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgILTg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 15:36:57 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5646EC061574
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 12:36:57 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4BpjYg14VpzKm5g;
        Sat, 12 Sep 2020 21:36:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id ubbVgiT7DfTR; Sat, 12 Sep 2020 21:36:52 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com, eric.dumazet@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 2/4] net: lantiq: use netif_tx_napi_add() for TX NAPI
Date:   Sat, 12 Sep 2020 21:36:27 +0200
Message-Id: <20200912193629.1586-3-hauke@hauke-m.de>
In-Reply-To: <20200912193629.1586-1-hauke@hauke-m.de>
References: <20200912193629.1586-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.75 / 15.00 / 15.00
X-Rspamd-Queue-Id: 2586D1283
X-Rspamd-UID: af08f4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_tx_napi_add() should be used for NAPI in the TX direction instead
of the netif_napi_add() function.

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

