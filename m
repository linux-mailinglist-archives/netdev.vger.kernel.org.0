Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0542EC7B3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbhAGB0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbhAGBZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:25:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DC8C0612F4
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 17:25:17 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id d17so7555100ejy.9
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mU7qP63nEFRD2eYvjP6KZ/y9xyjqIhupxiHfFVCwVWA=;
        b=JmVQCo+AzSbvVITZ6tAUjhL4noECB1CKWo2tsfd0fauAyV1VODYRKY4rU80wj3+c19
         U0IZlN2fUoUPBOU5TGq1XUk1g3gLPslLk+UgENUXJ5CpKtdsDVJA0xrx4AV4ZE86T2ut
         FQI2D7nonSH6d0/Hi9LgGW8KJ5vDG5iSI37iu06k7ZHjKSLjHv+AssMYn3nj51ATeaNU
         dOauOwGXeQQqc1rc4cudfGrBJebP9jV8E+Z9B6JC2gJmnxslRJvYCAk0yfx3pN6UnXkR
         NMjAN9V/LslAZoo4AUXwvAlh9+iCNobzbpfu6VvSXIcmiAVbhPsVp2umPyLoGkCRjYck
         SKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mU7qP63nEFRD2eYvjP6KZ/y9xyjqIhupxiHfFVCwVWA=;
        b=T+keaFzp976UoPY+IJG4l9ymPiX2I5VyP3x88Le+cans6uoaqCMpBJJncqgDislt5U
         +ldjL/KhfWRBloWK6MmJVQXQ5auzHruzEfZoM71e4TTkSmGYUMpksYeG+C9rJXq0Uggu
         5Hqp8NRgxH1vE8N+VqDNH1GHe8YmU5oOo/TxdB3NWI9Rlipj+xqLM60mRrPDlemPYsye
         tEeT5rv/jJFEFBsDuhiXl6M+AtxClSjYwfqtDmfPoWpW7c3n4Ifaby3eCoutFBdCdmm8
         uiEMTnniVlbEEBYY50oM1hwrYuUQqrnfb5X6v5lqEtqqvMD3yDMp13fKgV0bBH4kfQUP
         lpaQ==
X-Gm-Message-State: AOAM532phzp5v+YpbEXRxL5WWhjpkrn492KLpbv8G9lIxU6GVG1b4mO0
        3b811YQeSXiqYr2j7t+EaxA=
X-Google-Smtp-Source: ABdhPJxuoRabnqDyVfKYNd4G+Z9yVurhzh+GZJNP4WzxHhSuwW0OlFf9iB5o97L3pND3UQ//vx5Bvg==
X-Received: by 2002:a17:906:6053:: with SMTP id p19mr1672693ejj.93.1609982715870;
        Wed, 06 Jan 2021 17:25:15 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm2041858edv.74.2021.01.06.17.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 17:25:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2 net-next 4/4] net: dsa: remove the DSA specific notifiers
Date:   Thu,  7 Jan 2021 03:24:03 +0200
Message-Id: <20210107012403.1521114-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107012403.1521114-1-olteanv@gmail.com>
References: <20210107012403.1521114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This effectively reverts commit 60724d4bae14 ("net: dsa: Add support for
DSA specific notifiers"). The reason is that since commit 2f1e8ea726e9
("net: dsa: link interfaces with the DSA master to get rid of lockdep
warnings"), it appears that there is a generic way to achieve the same
purpose. The only user thus far, the Broadcom SYSTEMPORT driver, was
converted to use the generic notifiers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 include/net/dsa.h | 42 ------------------------------------------
 net/dsa/dsa.c     | 22 ----------------------
 net/dsa/slave.c   | 17 -----------------
 3 files changed, 81 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5badfd6403c5..3950e4832a33 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -828,51 +828,9 @@ static inline int dsa_switch_resume(struct dsa_switch *ds)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-enum dsa_notifier_type {
-	DSA_PORT_REGISTER,
-	DSA_PORT_UNREGISTER,
-};
-
-struct dsa_notifier_info {
-	struct net_device *dev;
-};
-
-struct dsa_notifier_register_info {
-	struct dsa_notifier_info info;	/* must be first */
-	struct net_device *master;
-	unsigned int port_number;
-	unsigned int switch_number;
-};
-
-static inline struct net_device *
-dsa_notifier_info_to_dev(const struct dsa_notifier_info *info)
-{
-	return info->dev;
-}
-
 #if IS_ENABLED(CONFIG_NET_DSA)
-int register_dsa_notifier(struct notifier_block *nb);
-int unregister_dsa_notifier(struct notifier_block *nb);
-int call_dsa_notifiers(unsigned long val, struct net_device *dev,
-		       struct dsa_notifier_info *info);
 bool dsa_slave_dev_check(const struct net_device *dev);
 #else
-static inline int register_dsa_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
-static inline int unregister_dsa_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-
-static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
-				     struct dsa_notifier_info *info)
-{
-	return NOTIFY_DONE;
-}
-
 static inline bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return false;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a1b1dc8a4d87..df75481b12ed 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -309,28 +309,6 @@ bool dsa_schedule_work(struct work_struct *work)
 	return queue_work(dsa_owq, work);
 }
 
-static ATOMIC_NOTIFIER_HEAD(dsa_notif_chain);
-
-int register_dsa_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&dsa_notif_chain, nb);
-}
-EXPORT_SYMBOL_GPL(register_dsa_notifier);
-
-int unregister_dsa_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&dsa_notif_chain, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_dsa_notifier);
-
-int call_dsa_notifiers(unsigned long val, struct net_device *dev,
-		       struct dsa_notifier_info *info)
-{
-	info->dev = dev;
-	return atomic_notifier_call_chain(&dsa_notif_chain, val, info);
-}
-EXPORT_SYMBOL_GPL(call_dsa_notifiers);
-
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c01bc7ebeb14..1b511895e7a5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1764,20 +1764,6 @@ int dsa_slave_resume(struct net_device *slave_dev)
 	return 0;
 }
 
-static void dsa_slave_notify(struct net_device *dev, unsigned long val)
-{
-	struct net_device *master = dsa_slave_to_master(dev);
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_notifier_register_info rinfo = {
-		.switch_number = dp->ds->index,
-		.port_number = dp->index,
-		.master = master,
-		.info.dev = dev,
-	};
-
-	call_dsa_notifiers(val, dev, &rinfo.info);
-}
-
 int dsa_slave_create(struct dsa_port *port)
 {
 	const struct dsa_port *cpu_dp = port->cpu_dp;
@@ -1863,8 +1849,6 @@ int dsa_slave_create(struct dsa_port *port)
 		goto out_gcells;
 	}
 
-	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
-
 	rtnl_lock();
 
 	ret = register_netdevice(slave_dev);
@@ -1913,7 +1897,6 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	phylink_disconnect_phy(dp->pl);
 	rtnl_unlock();
 
-	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
 	free_percpu(slave_dev->tstats);
-- 
2.25.1

