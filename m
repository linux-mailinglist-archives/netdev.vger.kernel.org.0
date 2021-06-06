Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4680039D147
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 22:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFFUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 16:19:12 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:49209 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230081AbhFFUTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 16:19:11 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.17.119.101])
        by smtp-35.iol.local with ESMTPA
        id pzCol3UwhsptipzCxlruIj; Sun, 06 Jun 2021 22:17:19 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1623010639; bh=iaj/7gfRZLK4M6U1KtJSY7aMtir2BnviUeoSzGrV5jA=;
        h=From;
        b=UYKlsRzAVHy2Xtgd5656aE1ELI/DGKo6fgndfGA6dFJgyKtVpkUt9A3PsNIacEYbZ
         2/6X5a/PhNbN+3zwOlYst+FZm2DdRWcZW2NP82EtNCFe0FHj6L3w9ZUq7Tn/8keto3
         IzbAGs1m5pEsnSfYzMEGi1fU2PokGaLSHz90pdh0fMyOKgUVwqj6x4q3Ls+ZcaQgKx
         ANzHbx75LAOm5M5io0xtEax3lNCTUSGKVCSsNq84wsIfKN+Lncsm6VjhEvPzuEJPUO
         eKIrK2py7EOSKX1Z1hp+Uto0XMIVblm2nppOwbman/dSAKV55ZRkIwkJNggucJ/thW
         uKbSrSheekrKw==
X-CNFS-Analysis: v=2.4 cv=Bo1Yfab5 c=1 sm=1 tr=0 ts=60bd2d4f cx=a_exe
 a=do1bHx4A/kh2kuTIUQHSxQ==:117 a=do1bHx4A/kh2kuTIUQHSxQ==:17
 a=0RFnQWo-as75lT-uasUA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/3] can: c_can: exit c_can_do_tx() early if no frames have been sent
Date:   Sun,  6 Jun 2021 22:17:03 +0200
Message-Id: <20210606201705.31307-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210606201705.31307-1-dariobin@libero.it>
References: <20210606201705.31307-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfEigeVgfGzfYsUw+nlXrrTI+4nn6l8rAIFrAow8hFZtgZEyocdbXmzmVZhAN00WjUvaxQhlq1NwZ05MpZyeLxncHQSMZJDbR4AQvx0wgtGyzdGOwUy8/
 s72raGwdPeHj/t7onlgGMpdB2l5uSi7g340Bh0tNIckR/jcvITMm3rreWuu/dSGXqpjz5YB/722dUY98+wbr8v0yzwDwHO4aD86ZR87xxv9/ajUGWeFQUDcY
 rXmREEjnnJgww8WWd0PTpn5S0jHM1Mdr/0S9AZicegv4djlQJjuTvQpE0KK75xYTuYOh2MhiC9GPg4b2V8UHLr2E1jXusxAR1Ph76FKr2InNKF6UqBI2yM7a
 0p2iTiml6uy4kRHZdyuCxu/T2330iiD7EO56h1lzK6ZwvO6Bjun1o32SWvXuO6hI7ZHeg0EF8+DfJsIshyJODvnM+o2Va2q8bc0qnwImq3sMEvzZ+ANaf9uA
 5OKG/6kNq9KVmHuERYAwo5AA8Uj/sgNJ2UtiruNyJ2FJO9JiCMxQ7DuXnMnsH8EDM0BSK/wYpHXITT4KKZdPhVjdElsUrIrsExGP52yD8jUX+idUVHrQC6m9
 EbOV3d31cA/W8147xLWp7EvmPJ8LCq07ZqEdj0gXis6b+SwOYxJ3aCrlp74KBQbwh6w8XzNyyyGtmvrCE77ETWis
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The c_can_poll() handles RX/TX events unconditionally. It may therefore
happen that c_can_do_tx() is called unnecessarily because the interrupt
was triggered by the reception of a frame. In these cases, we avoid to
execute unnecessary statements and exit immediately.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 313793f6922d..2b203bf004f9 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -721,17 +721,18 @@ static void c_can_do_tx(struct net_device *dev)
 		pkts++;
 	}
 
+	if (!pkts)
+		return;
+
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
 	if (clr & BIT(priv->msg_obj_tx_num - 1))
 		netif_wake_queue(dev);
 
-	if (pkts) {
-		stats->tx_bytes += bytes;
-		stats->tx_packets += pkts;
-		can_led_event(dev, CAN_LED_EVENT_TX);
-	}
+	stats->tx_bytes += bytes;
+	stats->tx_packets += pkts;
+	can_led_event(dev, CAN_LED_EVENT_TX);
 }
 
 /* If we have a gap in the pending bits, that means we either
-- 
2.17.1

