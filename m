Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68B44E368D
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiCVCRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiCVCRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:17:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31042CC90;
        Mon, 21 Mar 2022 19:14:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d7so23031059wrb.7;
        Mon, 21 Mar 2022 19:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hyvJRbfKxlg2y69YT+CiBgV+yqgpLzyV8qlpvq+PDbg=;
        b=fPlYrW3lEWxPGhExEY0FPOc+5597vX5Ze1AMtuGnNwSiMwMFKaoWT2AtTcT1ZUC5AN
         ey92qTFeO/is6kH4Afx2mFCZtlpRjuhyZj1E5/O1UUQPXC0lIVEg/BMmn2mBlmygWbQB
         +4O0JzeEPDLwU/JorvEiRUj7SISTOfQ/e7NtIZZETXbHVipc3ltwP8PL55MKMb2GSitx
         Me+V5HqnvQUk6As5AgMfixBwlVrFJWcjanu33Tl075Ox9VVvYoLoMbwfx/PhoTzRcLXh
         HD9/QCZdbxD5pZnnC1VbxCXkOKL7NmZkm/w1bQ1b+LCWJ6NtvXhkuC+j3lKljvyhJyYe
         HwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hyvJRbfKxlg2y69YT+CiBgV+yqgpLzyV8qlpvq+PDbg=;
        b=wbBdeTRqf6qVMo9MIqMMGhOCgK99RbVujvR8JLuXGem2MUsDrvaAkETIdvOBEE833S
         CmuHxjDMDfovhMkrZJVnjjiHhsz3I2Szlflh02TxRL7tOC+cdk/ny4Epa6po+vib+Gdq
         i6OgSfs4CGDMtqgo59zCUb1Ou+OzVWfiislL/fhvKx2dieLey1Ffyj1fd24CwKCL/k7N
         47RFog5rSI4OVW6TGEwg0OFQL173KA6f5rT047WF/Olsfzxr8H2PvRdSA5Cb5c4nCB9b
         z5iz7YRRDvihFoIBGYJpra18sx0p5fUk1nrkLF4qEt+TYIZ6Ao1UEkckyH1/gnZDSQ5j
         sYiQ==
X-Gm-Message-State: AOAM533oc/RT8ngglPBtofGLsfJkrJRZgcIjXBKTMC7icYViYkWQoazD
        ++gkemaqVOqDwIPDHZCyB6Y=
X-Google-Smtp-Source: ABdhPJyKPXinkzLhE2TVWtg7EdI6mzLiLuaTWKaStQnXXZdWD5dyEEy+WChDd/GGWQEbarYtSxSjIg==
X-Received: by 2002:a5d:6c69:0:b0:203:78af:48b2 with SMTP id r9-20020a5d6c69000000b0020378af48b2mr19914900wrz.123.1647915275224;
        Mon, 21 Mar 2022 19:14:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.googlemail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm177968wrz.2.2022.03.21.19.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:14:34 -0700 (PDT)
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
Subject: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking from qca8k_priv
Date:   Tue, 22 Mar 2022 02:45:03 +0100
Message-Id: <20220322014506.27872-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220322014506.27872-1-ansuelsmth@gmail.com>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
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

Drop the MTU array from qca8k_priv and use slave net dev to get the max
MTU across all user port. CPU port can be skipped as DSA already make
sure CPU port are set to the max MTU across all ports.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 38 +++++++++++++++++++++++---------------
 drivers/net/dsa/qca8k.h |  1 -
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d3ed0a7f8077..4366d87b4bbd 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2367,13 +2367,31 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
+	struct dsa_port *dp;
+	int mtu = new_mtu;
 
-	priv->port_mtu[port] = new_mtu;
+	/* We have only have a general MTU setting. So check
+	 * every port and set the max across all port.
+	 */
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		/* We can ignore cpu port, DSA will itself chose
+		 * the max MTU across all port
+		 */
+		if (!dsa_port_is_user(dp))
+			continue;
 
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		if (priv->port_mtu[i] > mtu)
-			mtu = priv->port_mtu[i];
+		if (dp->index == port)
+			continue;
+
+		/* Address init phase where not every port have
+		 * a slave device
+		 */
+		if (!dp->slave)
+			continue;
+
+		if (mtu < dp->slave->mtu)
+			mtu = dp->slave->mtu;
+	}
 
 	/* Include L2 header / FCS length */
 	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
@@ -3033,16 +3051,6 @@ qca8k_setup(struct dsa_switch *ds)
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

