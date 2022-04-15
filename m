Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFACC5033C2
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356491AbiDOXcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiDOXcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB4FF39;
        Fri, 15 Apr 2022 16:30:22 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u15so17527959ejf.11;
        Fri, 15 Apr 2022 16:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IEDk1Fj7RgrH8y7QPn9XAReb3y152uJ9XeEkuSITTcs=;
        b=nyaHgGgcJd3IqBNnJ8J0FpEcpQRHeUhlkpYMn8syJl9SPLQ2yMl4zNW6awZBxblt7i
         NyD9zlbQmQwcTkqGOHoD12wPCtqMV9/hn/Ww3hfJf7zW2qN6GHw6Wy8lcj67AwCupVnn
         N4YGH+JoidhmFrUESLtqNpzLy+3Ol4chBnIZQKX3neA4F3mYGrjvZGnmkS/lCTYPcWLH
         yrUrsmojJkfDb4Y/gFbWywdSdxAq08xZCASv+4lLpgoZ1HvqoavjXEaIGnYd5FAyjj3W
         Sdh3J3o1pdgWWI137BZid8OPGGb7sRdRbhYslJt9K9k5rS+tUc4eM0b5JpfAIwsLBkyk
         aTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IEDk1Fj7RgrH8y7QPn9XAReb3y152uJ9XeEkuSITTcs=;
        b=qnVyVaJaNtt77m3WDDz93QtBdE5DhT+kWqs1KSVyWf4nDPqMzSX3tzbUVoitYs9IgZ
         6YNy3sfZQYyOBh95QjITdKm1pB0HKEYvTUxgKc5vmjHgjBB/EJ5CjHJuZTwGQ9maRLnm
         ikrDvthxeTr0C/X0+G0SqlBX1PQOFpvXotmPdG9ceyFplHx0G0ojZVIJzSu+AgCoZnkH
         7qQCh/E9vKRDGUUhyvk58AkOuxaYMVsS/ZFDtZ6+DjTEVymZ+YdQpEaE5XMSpY0R1HM2
         ZtfDyuivKcZUGS8ycdGXhU/pUgOI82Lem5V6eAPaRMV8hYuKIMGyBGTf9d/QeXv1Zzq2
         zj3w==
X-Gm-Message-State: AOAM5320iZIPi8+KjBQEJqYxnQ3sCj3Lhy+E0hNgG1n9RVSn8m+98n7H
        gjKYMAVTVkly5Sn5hL8jlh0=
X-Google-Smtp-Source: ABdhPJzCWRaQL3xkKKt4UXNkAJIhnAwqm3g8C1GrX0O9I4a+1HbHRl4ISxEZ394+DVGsw7FJ1K3jkg==
X-Received: by 2002:a17:906:4fc7:b0:6da:92b2:f572 with SMTP id i7-20020a1709064fc700b006da92b2f572mr964600ejw.184.1650065420923;
        Fri, 15 Apr 2022 16:30:20 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:20 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 1/6] net: dsa: qca8k: drop MTU tracking from qca8k_priv
Date:   Sat, 16 Apr 2022 01:30:12 +0200
Message-Id: <20220415233017.23275-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA set the CPU port based on the largest MTU of all the slave ports.
Based on this we can drop the MTU array from qca8k_priv and set the
port_change_mtu logic on DSA changing MTU of the CPU port as the switch
have a global MTU settingfor each port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 26 +++++++++-----------------
 drivers/net/dsa/qca8k.h |  1 -
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d3ed0a7f8077..4e27d9803a5f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2367,16 +2367,18 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
 
-	priv->port_mtu[port] = new_mtu;
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		if (priv->port_mtu[i] > mtu)
-			mtu = priv->port_mtu[i];
+	/* We have only have a general MTU setting.
+	 * DSA always set the CPU port's MTU to the largest MTU of the slave
+	 * ports.
+	 * Setting MTU just for the CPU port is sufficient to correctly set a
+	 * value for every port.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
 
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -3033,16 +3035,6 @@ qca8k_setup(struct dsa_switch *ds)
 				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
 				  mask);
 		}
-
-		/* Set initial MTU for every port.
-		 * We have only have a general MTU setting. So track
-		 * every port and set the max across all port.
-		 * Set per port MTU to 1500 as the MTU change function
-		 * will add the overhead and if its set to 1518 then it
-		 * will apply the overhead again and we will end up with
-		 * MTU of 1536 instead of 1518
-		 */
-		priv->port_mtu[i] = ETH_DATA_LEN;
 	}
 
 	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index f375627174c8..562d75997e55 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -398,7 +398,6 @@ struct qca8k_priv {
 	struct device *dev;
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
-	unsigned int port_mtu[QCA8K_NUM_PORTS];
 	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mgmt_eth_data mgmt_eth_data;
 	struct qca8k_mib_eth_data mib_eth_data;
-- 
2.34.1

