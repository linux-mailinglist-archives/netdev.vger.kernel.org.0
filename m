Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86583454F0E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240849AbhKQVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbhKQVJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:09:14 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBCCC061210;
        Wed, 17 Nov 2021 13:05:37 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so17021295edd.3;
        Wed, 17 Nov 2021 13:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oIKLkMzYcyOXWvE2NN0Dor5B9xR1JhlY89se65GsZ88=;
        b=NsvxGPJMqH6BWLkuCeffpwJEQYmZXHi5rdfQii3O1QyHV6Qn+AWVOpug5646sYHkhw
         hG0IGE4f27W4aK4t7Uc0cu8KV4kavhh5EabdR7w9EPX0eZVR0lyc26OhcKhzDq4zjwdq
         5wJsAH/EpPAI7k0ZVNOsC7j3f5Dc+K4CLCGb4fNoQw7nPxqoSSU4t8ZhGwYkbmvlYhtd
         xCCF/NR2M/u8MX9lSpUstYSojE8XG3fPcmcjKgFCTivcsdGggcmvGkAdeZXd/MCpgKlE
         FsWxlc9oYm5KeVWcdY/M1gYTCrNOTKHd42F+F+7sQvuzRWIjXYYKuBkAqk1VJDjZE7Jb
         NqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oIKLkMzYcyOXWvE2NN0Dor5B9xR1JhlY89se65GsZ88=;
        b=Rrnr2jlHUlGStRYDv0qpd4aEfQiEM5jInvo/B6DoleiK7YJkAPLzduVYOGtvRueAiA
         YxdRS36AGWC5swjSydmqb+RURvBrtclbRDp+qSNNDoMDS/m90F7ehpjRpFXjKIeWAJT/
         VfNP7odN39LrpGTalyHVovTJODlT/79dyj+zNrsXibmLPyMY7ia1fWUT4adiBKX64i/6
         9ObGjhty+kv9oz8JTV6Rgkl36k0vxfBkhhmuGbLXI0VmqIe/NfoBEbjCKIKEOdyj95+s
         zXrVxvLu9g5MAOGPafjQeG+0FrKTOUTt0ZjviBUHlo0vJMh3EB+wMfh7u1UdC9CoPUT6
         54YQ==
X-Gm-Message-State: AOAM530RbQIOPKq4rFZAIQlcU3dJSIU5lulGOpaIG3yrUYx3hlvpp/5i
        z6AO8MwMHTvyeJ5KmuJCP0E=
X-Google-Smtp-Source: ABdhPJweD6msBp77IxJH1Me47pO1tq5qv7A1kBx4pfpNq3O7j8YnTPOW7bcSsQTvKm1vkb3LktGBNA==
X-Received: by 2002:a05:6402:190c:: with SMTP id e12mr2590497edz.309.1637183136145;
        Wed, 17 Nov 2021 13:05:36 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:35 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 18/19] net: dsa: qca8k: use device_get_match_data instead of the OF variant
Date:   Wed, 17 Nov 2021 22:04:50 +0100
Message-Id: <20211117210451.26415-19-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop of_platform include and device_get_match_data instead of the OF
variant.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index cae58753bb1f..260cdac53990 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -14,7 +14,6 @@
 #include <net/dsa.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
-#include <linux/of_platform.h>
 #include <linux/if_bridge.h>
 #include <linux/mdio.h>
 #include <linux/phylink.h>
@@ -929,7 +928,7 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 	 * Should be applied by default but we set this just to make sure.
 	 */
 	if (priv->switch_id == QCA8K_ID_QCA8327) {
-		data = of_device_get_match_data(priv->dev);
+		data = device_get_match_data(priv->dev);
 
 		/* Set the correct package of 148 pin for QCA8327 */
 		if (data->reduced_package)
@@ -1071,7 +1070,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 	int ret;
 
 	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
+	data = device_get_match_data(priv->dev);
 	if (!data)
 		return -ENODEV;
 
@@ -1674,7 +1673,7 @@ qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	match_data = of_device_get_match_data(priv->dev);
+	match_data = device_get_match_data(priv->dev);
 
 	for (i = 0; i < match_data->mib_count; i++)
 		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
@@ -1692,7 +1691,7 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
-	match_data = of_device_get_match_data(priv->dev);
+	match_data = device_get_match_data(priv->dev);
 
 	for (i = 0; i < match_data->mib_count; i++) {
 		mib = &ar8327_mib[i];
@@ -1723,7 +1722,7 @@ qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	match_data = of_device_get_match_data(priv->dev);
+	match_data = device_get_match_data(priv->dev);
 
 	return match_data->mib_count;
 }
-- 
2.32.0

