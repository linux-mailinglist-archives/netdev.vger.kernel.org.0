Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4F02FDB7E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbhATU4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732919AbhATNyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:54:02 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77A3C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:46:02 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v15so19511001wrx.4
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NsFMlNDSNcVbWw/lz8xxqlxojYW8hjqlbDkbn60XW6Y=;
        b=v6TMTwiWU54mvhMtdVsph3UY35FzKCQE3WLBqxB2kNTHeGLUZkxSdkp7tb0UysaRsy
         rR9SXO9SjMXrD+QlekHk43JAIpPV9sl4IiDLOpWS+71OTud+A3N64lO2j0F0e12MoP1o
         9WIiDaXh/JYVE7GySr7AHry3TpEB7FbggwY7zBENRExZJrSmuTeD+20rKmSy2b2A0gCE
         LifDe9O0BubJk0CoCSO8T37flR81zm/P6vScEKsWfVvpZunYWGka62gE2PnjpO/HDpak
         8VphnBT1AVJVOEV3p5bb3WkvZYqp7ZuEbrPySLPnjbQFf9GbvVA+f0KI4pfAgNhTfGxP
         wDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NsFMlNDSNcVbWw/lz8xxqlxojYW8hjqlbDkbn60XW6Y=;
        b=H8mV/aIOiO6nupzobUb5WX3TPgbpSO0MBDTK80CIHmAPxYF+WiwvQDrzdrFH+lcfGL
         DA4pmaH+EQuPvfVyWjfvKjSwpJQ/KyAtvNLAG14nFVcMqIgX11xNLpv9RzwlHL7OX7mC
         Bwus9M/wAclT586ewcx0wkgs6sYs4toaHuo7HqHY1WlKmsB/LNhSW/dk92rD38VYAU5i
         hGj+kd3hWwFLCOmml0AKdy1Mz/cVl2kJ2HaXI+AXriXzeb+hud0FQUvN9YCfNxVRxj/a
         4sQJC7k9VlxILmBRvv2Z0JUq9Tp/6Dnr4j4oiJGbGCwCFni8BcC3WqAEAajWSSf4Uvn2
         umjA==
X-Gm-Message-State: AOAM532BNB9Y6zHlEkwhVrvTf5GjV5xNSERVHEdzu/LlU1JZy7Qj/em3
        7l8gpD+yfpVIBx9N+n3auekC8w==
X-Google-Smtp-Source: ABdhPJzXEmOfZEi5wiGIiS1ceh17CyIBH/43DemKZa4XKhmN95CnpakI7LqkZ7OFjEOl6E6YdVVA5A==
X-Received: by 2002:adf:eb4e:: with SMTP id u14mr9484527wrn.99.1611150361424;
        Wed, 20 Jan 2021 05:46:01 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id j2sm3982403wrh.78.2021.01.20.05.46.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jan 2021 05:46:01 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: mhi: Set wwan device type
Date:   Wed, 20 Jan 2021 14:53:41 +0100
Message-Id: <1611150821-15698-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'wwan' devtype is meant for devices that require additional
configuration to be used, like WWAN specific APN setup over AT/QMI
commands, rmnet link creation, etc. This is the case for MHI (Modem
host Interface) netdev which targets modem/WWAN endpoints.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index f83562d..e3f9c0d 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -234,6 +234,10 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
 }
 
+static struct device_type wwan_type = {
+	.name = "wwan",
+};
+
 static int mhi_net_probe(struct mhi_device *mhi_dev,
 			 const struct mhi_device_id *id)
 {
@@ -253,6 +257,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
 	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
-- 
2.7.4

