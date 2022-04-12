Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7415F4FE745
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358464AbiDLRjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347117AbiDLRjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:39:08 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB6960DA0;
        Tue, 12 Apr 2022 10:36:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lc2so18180482ejb.12;
        Tue, 12 Apr 2022 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3EM2w6CwmLOZ4E5PJhncFf+YcaaRZ3+rN6g0iyD9jns=;
        b=Kodbv0J9jTgxZltlP//7l0RwDy7tzDlqszVyMK8gnmgthMQhLX59MVR1ihg9RR9bhy
         gJl2p93yEQOZDqB5P0+oQJLfiKygxZ+Izm51yomA5s4plabw3BI7KDqIkgmZuwbr94Yf
         yAOMGE3hpsNtL/RYXPC8eVMxsXLwOEikxv95BHkTQm2VPBNtoHh3ttwe7sqNZ1SJpDRP
         S6ruGkAGT7hL5tyNXg+4Vwj5GKHm6hKgwUlPOrXSHoQBxAd3FnDFEy7IhlcDKK5b6bwd
         rxSFUMpeJoXovocFvpxZYWMQMdadwts02y5EueRr6d9f3bi5SyWfP501UYezRNPFlNSC
         k8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3EM2w6CwmLOZ4E5PJhncFf+YcaaRZ3+rN6g0iyD9jns=;
        b=1N4+yyW6CB5CGGNy74misSoHEui3JgqUCCYgadhYl/kr9gkKI9KT5pWPZqMLzwol2v
         PvZZ6k6f1Gx7jLANEZ4Vvpb0CCMa0pyE/Qb5vsGU0IW4KLZZCnDlwHuvxrhKy9V99bYK
         Irpfzayml1xTPECK5THLGD7reHWpAttizHmScpj2spEFyP6MHlmCmxpdfOP8th5WUNnb
         a8AKE5/3tBLE9lPy9yYp5ArdoPxKdSzVPM6asLDvkrrsS7hmTGj67i2hkTzfBVzqv3Ne
         vLdC3B0XklfUVooUVK+km/Ntu+lMueo6cqPkkf4SnBm/Kz+fmg9zInSgLjsEW7cnbnPT
         l0rA==
X-Gm-Message-State: AOAM531NWgrLlKDweWPodIZ4bLGJyPdXZQoaQ7M/apV3vCs6IEH2Rf3S
        34I6+w8IMyPl3W5eGGdHhuM=
X-Google-Smtp-Source: ABdhPJz9pfxJ6t7Y8jURxRvf5VIc0BP9OS7wYTX+sAwXg5R6A5qjUU5wk9uQK33I+NMOTUfPj2PGUA==
X-Received: by 2002:a17:907:3d01:b0:6e0:c63b:1992 with SMTP id gm1-20020a1709073d0100b006e0c63b1992mr37035450ejc.422.1649785009008;
        Tue, 12 Apr 2022 10:36:49 -0700 (PDT)
Received: from localhost.localdomain ([5.171.105.8])
        by smtp.googlemail.com with ESMTPSA id n11-20020a50cc4b000000b0041d8bc4f076sm48959edi.79.2022.04.12.10.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:36:48 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 1/4] drivers: net: dsa: qca8k: drop MTU tracking from qca8k_priv
Date:   Tue, 12 Apr 2022 19:30:16 +0200
Message-Id: <20220412173019.4189-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412173019.4189-1-ansuelsmth@gmail.com>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
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
---
 drivers/net/dsa/qca8k.c | 25 ++++++++-----------------
 drivers/net/dsa/qca8k.h |  1 -
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d3ed0a7f8077..820eeab19873 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2367,16 +2367,17 @@ static int
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
+	 * DSA always set the CPU port's MTU to the largest MTU of the salve ports.
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
@@ -3033,16 +3034,6 @@ qca8k_setup(struct dsa_switch *ds)
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

