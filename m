Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAEF31189D
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhBFCml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhBFCid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:38:33 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C09CC06121F
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:14 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id l12so10720216edt.3
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e65FdPPpPqsFXEIrgbCwnULwizGY4EY0nzN9rQzDB7o=;
        b=A142HV9ssaJZupirkDrITJqg0p7RaBikisEXHSAW8wEe8vSkgJzwuPfbdU8c9TCPtM
         TvDbowcuS1eqRR2y/4dB77ylRtTBc8xaeD05YDXUOoayG8KThtDhrNI3PqG4H52gr+D0
         Fjj/fRPO4pJx1Vt6y4V44gTOiigXPxyqOk7gb/UBrfI3gecXW51bBTQKwhWz2U1K57my
         8xk55v0jrUaXAyAtoko1MZLGmFL0k5tPFBdOjMQ8ntzkE7Q554REvkMDMjJ2fCzMqyql
         q7Xd2AlrxTipPUvboPWnSFo/Vf6a3iHUB7fzgVz/tMloITN6bxshDQoSNVNWW+UWvVWR
         FNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e65FdPPpPqsFXEIrgbCwnULwizGY4EY0nzN9rQzDB7o=;
        b=UmRAPQXtlOdDCzhOuALCFCxnlBxuAahpY9uNMIvlsQ05lbkEvxv7VCGBat7RU5B25C
         mxidukplFodNbvMX+f+CsgzBUPQFfGEUIR+RBSR0oVxaBYgIodzwLMQjgsXjhdicsmN2
         dpWobigZbykCvYnulwtMqWTOTLMMe7c5ecqwmPEWUu85W1AXZGg9RUMRtQzZnVKof5Ep
         kEQo6v2+qgCl+uI8EWYwHYJjPTraAsetJcLCt9jr/Do/YZHE2k6GPh99YWx95Ln55yND
         l8U60sq8ML43NeTtUn9NonnB3PfRL3QFpvrKPFrFjRTwj5KEChWVcM5x6tGdhQ/YsWBl
         kW+A==
X-Gm-Message-State: AOAM530vwjfWFLg04NBvVAUAm0EsKHQM8EKKJUCvQkUclyUhjb+cEbuX
        jCpkPrpT1u1vr+ekc30N/h0=
X-Google-Smtp-Source: ABdhPJzPkrIoxAlHZn+ESmKg2TCsAsUEscKAS5uzXk3W8Z9W+F5smNCf5ya0SgyOPoUVwKOhAmEBdA==
X-Received: by 2002:aa7:d149:: with SMTP id r9mr3856361edo.38.1612562593039;
        Fri, 05 Feb 2021 14:03:13 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:12 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 02/12] net: mscc: ocelot: use a switch-case statement in ocelot_netdevice_event
Date:   Sat,  6 Feb 2021 00:02:11 +0200
Message-Id: <20210205220221.255646-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
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
 drivers/net/ethernet/mscc/ocelot_net.c | 68 +++++++++++++++++---------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c8106124f134..ec68cf644522 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1137,49 +1137,71 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
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

