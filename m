Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3733D10
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfFDCTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:19:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45083 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfFDCTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 22:19:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so8270680qtr.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 19:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ez3y6TuQoJf9yjasiQe9ev4GHCCFIMlgYUuaXW302N4=;
        b=qxrXhJqKMzBzlNRSxXgvrTkVPFSaWJE6iEvWfs7QYo0WAqJpHQsY/eM3h28xzDWJ9I
         C9yqhC5cLeKDmVzqZyX1fsWJUgubTIqkRjDuE4HXdhFq5uXRyUsfiB//JkdJrn1bHJxB
         elEwM82AnMYo6u8WG51/OvfT3+BKZCVpJ1/R/sdGZ51aiuuPbmVfyrAm3jJR/nYDRTOt
         hVmRNP9dnDs5VNPVHxGT7kABhfeakPs9vhLGze+DdgMcmedVAHskdFdwhlAQIOxTpuMR
         xDePK0Kmg3HwsQo+G1N5ZDK0Jf4/Hb20KEzG4sFMex67qFHChzEZoFhmWeIQ4oDwmjiz
         MXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ez3y6TuQoJf9yjasiQe9ev4GHCCFIMlgYUuaXW302N4=;
        b=GhyutU8ntPgI4D5etcGPBoiavjwJ3UZCluhxoSlfeG7I2lzezG3LX6b/bikWXAJI/9
         kBBk9rrYyoCEkB7p7okO1d8AvDsb/lWmkM3PrWBZfU/4D+0QMEnCjKvZJs5WuGXH3o1H
         cgwxa6rJ3Tnc6WgSK6YVKtiNEQVj/GrnvzS1W9uLIXpTzJx1P3DZixPR+8QFOIiUzGYs
         LjG01WuyYRy/CgZtYeZjkO41OxxfbE3eGb2l9LrUMZ0FytofxvOVb34yvOdcdRrnpm3x
         3AOQ2UHdyCKkMy13RiBBfQO/l9VYBwwUFZULaRdIgAMonLgdKUn9AbkoBL9cBQ5RL5/y
         bkJA==
X-Gm-Message-State: APjAAAVgY2l9pUJkto/0Qp3WzCz7khnV5eQVtE8qSDG6mi7IkA/Ms7KO
        FXRZeCsK3TGeY1uy9UhwnVI=
X-Google-Smtp-Source: APXvYqzMJa/OTHiJ4buNs8M2Z09tyHHkO/HViVZvfzsuOiDUhLAY+LcE7oa0t5ssJcw8nT0SZ/hzOw==
X-Received: by 2002:ac8:21dd:: with SMTP id 29mr6203915qtz.340.1559614757401;
        Mon, 03 Jun 2019 19:19:17 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:3c8:56cb:1049:60d2:137b])
        by smtp.gmail.com with ESMTPSA id m27sm268398qtc.16.2019.06.03.19.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 19:19:16 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] net: fec: Use netdev_err() instead of pr_err()
Date:   Mon,  3 Jun 2019 23:19:06 -0300
Message-Id: <20190604021906.17163-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_err() is more appropriate for printing error messages inside
network drivers, so switch to netdev_err().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 8 ++++----
 drivers/net/ethernet/freescale/fec_ptp.c  | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 848defa33d3a..887c6cde1b88 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2452,24 +2452,24 @@ fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 		return -EOPNOTSUPP;
 
 	if (ec->rx_max_coalesced_frames > 255) {
-		pr_err("Rx coalesced frames exceed hardware limitation\n");
+		netdev_err(ndev, "Rx coalesced frames exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	if (ec->tx_max_coalesced_frames > 255) {
-		pr_err("Tx coalesced frame exceed hardware limitation\n");
+		netdev_err(ndev, "Tx coalesced frame exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	cycle = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		netdev_err(ndev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	cycle = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		netdev_err(ndev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 7e892b1cbd3d..1d7ea4604b83 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -617,7 +617,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_clock = ptp_clock_register(&fep->ptp_caps, &pdev->dev);
 	if (IS_ERR(fep->ptp_clock)) {
 		fep->ptp_clock = NULL;
-		pr_err("ptp_clock_register failed\n");
+		netdev_err(ndev, "ptp_clock_register failed\n");
 	}
 
 	schedule_delayed_work(&fep->time_keep, HZ);
-- 
2.17.1

