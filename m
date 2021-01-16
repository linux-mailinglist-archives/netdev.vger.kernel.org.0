Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD65F2F8A28
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbhAPBBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPBBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745A5C061795
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:38 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id l9so10107916ejx.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yt4MFZFXIJYwPOPeihpYqLUWKvpxa3mc0RtRQNXcEOE=;
        b=GygOi8ZtJZLg1CtenA7yKAqcrCFfqDae8lYh+VoTPjTzBBkycWy+ZxtwsaHVfCWOf1
         sxrgCUpA6AjeTA/f6QLc5NbCpJQQZNLr81she5cW9cSUX9u9O1Ps6JPLzzadntHQ7cdp
         g5vCGoR43If1hzrrAtdjDhFRVgFkYePcaSwHucS9kh8OPyVAoWKgB88foCxXKVGvdzZC
         OebxVhzKj40OMAU7drM721lXEDMOs91RYcgb1SDJ5OIj5bHEGyoFmCs6IPFer7RUn/5F
         Ua9QTf1yukajIo4c7Vbsi0H6BdmJ0V8nwudY1yBXcNszCus9fobZH9T6igyasmZtQGns
         8r/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yt4MFZFXIJYwPOPeihpYqLUWKvpxa3mc0RtRQNXcEOE=;
        b=lyTY7VA4GNolZsQN2a3JL8WgJbA1m8Jn3JS1OuKX0P1AImtlXofBncT9FyQYYgquMu
         JZrlKji0vffx/jTf4OylykvehkaYbVrH6stkRG6v4ITTq5qBSnrJP4tz9PqXWjZ2rqYm
         9hzLu/749Vqkyn+4IH14QjElr11qFQ/fN4BKMCMgQUTPx/4fty7R2l4oZAAlkyQY+LM3
         JnV++gzwMd0MktY8mlhJIlE9pfSmsXmvn29OdSs9tvnc5CMqFWwSdnkJP5ZfWx57T2ru
         4IbkfJCr647u0jKe6upc+FNnZ18eCE7WVu7Xh4sL7B0+puRliNmh2PUsiSYyBczIFrrb
         gMQw==
X-Gm-Message-State: AOAM530U+jstODA5QoRKDNEQ3zKfEQwWI2nxXvnhiFlRKOlSRarfegr/
        3gkYhW5bqpzDjmcPlIot7Gc=
X-Google-Smtp-Source: ABdhPJxPOqswJ7PYfs9wPBEHLzb3LiUSNQaMPzEGoaU02uOCwq4jc0qiFKlBabHYqK9T4NHuf1QeqA==
X-Received: by 2002:a17:907:16a2:: with SMTP id hc34mr10817539ejc.9.1610758837090;
        Fri, 15 Jan 2021 17:00:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 03/14] net: mscc: ocelot: use a switch-case statement in ocelot_netdevice_event
Date:   Sat, 16 Jan 2021 02:59:32 +0200
Message-Id: <20210116005943.219479-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Make ocelot's net device event handler more streamlined by structuring
it in a similar way with others. The inspiration here was
dsa_slave_netdevice_event.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

---
Changes in v2:
Addressed Alex's feedback:
> This changes the return value in case of error, I'm not sure how
> important this is.
by keeping the return code of notifier_from_errno(-EINVAL)

 drivers/net/ethernet/mscc/ocelot_net.c | 68 +++++++++++++++++---------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index f15f38f45249..b80a5bb95163 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1136,49 +1136,71 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 					      info->upper_dev);
 	}
 
-	return err;
+	return notifier_from_errno(err);
+}
+
+static int
+ocelot_netdevice_lag_changeupper(struct net_device *dev,
+				 struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+	int err = NOTIFY_DONE;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		err = ocelot_netdevice_changeupper(lower, info);
+		if (err)
+			return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
 }
 
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
-	struct netdev_notifier_changeupper_info *info = ptr;
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	int ret = 0;
 
-	if (event == NETDEV_PRECHANGEUPPER &&
-	    ocelot_netdevice_dev_check(dev) &&
-	    netif_is_lag_master(info->upper_dev)) {
-		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
+		struct netdev_lag_upper_info *lag_upper_info;
 		struct netlink_ext_ack *extack;
 
+		if (!ocelot_netdevice_dev_check(dev))
+			break;
+
+		if (!netif_is_lag_master(info->upper_dev))
+			break;
+
+		lag_upper_info = info->upper_info;
+
 		if (lag_upper_info &&
 		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
 			extack = netdev_notifier_info_to_extack(&info->info);
 			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
 
-			ret = -EINVAL;
-			goto notify;
+			return notifier_from_errno(-EINVAL);
 		}
+
+		break;
 	}
+	case NETDEV_CHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
 
-	if (event == NETDEV_CHANGEUPPER) {
-		if (netif_is_lag_master(dev)) {
-			struct net_device *slave;
-			struct list_head *iter;
+		if (ocelot_netdevice_dev_check(dev))
+			return ocelot_netdevice_changeupper(dev, info);
 
-			netdev_for_each_lower_dev(dev, slave, iter) {
-				ret = ocelot_netdevice_changeupper(slave, info);
-				if (ret)
-					goto notify;
-			}
-		} else {
-			ret = ocelot_netdevice_changeupper(dev, info);
-		}
+		if (netif_is_lag_master(dev))
+			return ocelot_netdevice_lag_changeupper(dev, info);
+
+		break;
+	}
+	default:
+		break;
 	}
 
-notify:
-	return notifier_from_errno(ret);
+	return NOTIFY_DONE;
 }
 
 struct notifier_block ocelot_netdevice_nb __read_mostly = {
-- 
2.25.1

