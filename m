Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048216C03C7
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCSSdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCSSdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:33:36 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DCB469B;
        Sun, 19 Mar 2023 11:33:34 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v16so8498724wrn.0;
        Sun, 19 Mar 2023 11:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679250813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mwUT1qaTZeTv9g0/imGkIDLkvWNTnCTTuiaQFPPZcQE=;
        b=U3jYphsXR2K/7q/DSuiK3/yALfYz0vdHtYSqQ6nv5TL8/cuAXI7Tpc7vNKswLqmge3
         DEZukR1tike/y73OxFEbZaaEoeJYhZLoTKg+/9THX1FMpBkSV8AqpmcG5QhpjmO20Jwp
         nUgYIbd+j0FRpTV5sMrtNE7YBqgUoByWTtiduw/53A93W5JW9MUMNuzHNEruj5Wr60QA
         jXi4Th2GC0cG6VNyjdPyl3ZdlADhSP0YmuREV7qNCaBQOfqKvOd7t+wYtegtDgEqC5ML
         iRVh2yePTJC9hCVzx3037gXEZpcb/eAZQd6xVWJH1kuxXOIC3hvI5ETBXQjiLIzBrE6A
         v9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679250813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwUT1qaTZeTv9g0/imGkIDLkvWNTnCTTuiaQFPPZcQE=;
        b=NfuoLb7XZVrwgy09NHFhD2tOZnPukOTuAOw5KNH0nKXfJVVg708KrgEYwNFCQGqZgo
         CZKpPi4AAzyqne5R25Oceq1gbQIxkQw19rSyVra0dLWRgauRDGFYrFVIeN1v/12WBpls
         wrwj4rKy+GzFJsGheVaxWSgQBK8H41UjNQU4wN1rY44qk+CVk8XRh7dWBaYNFFEKmEmc
         yjskn4ZZn4cVS3AEM6V2kYuS+K/Vza8iTGzdrl2OugdsLdp0d46Uz3o6Rt0Np20d6p3I
         FwV9L0MI5maM0BQ9bng7TOVt4MB11woDzVtVRMDGVq45OBvHa1QjofBkfnGieYxZ6ptN
         Sh1g==
X-Gm-Message-State: AO0yUKWjLKA4uo9o77d1mrcucj+82iGwFPm3iOoMuGVevNDscoSEDmGh
        z/OykzKOgU3ll9rONCL506M=
X-Google-Smtp-Source: AK7set9xFSB9m2vPq9jIeOU4jr/akXrqV57PW7e9LjT8Vg7ukbYZKyjdEx0BhmWA5wRW0bZ+/CcfeA==
X-Received: by 2002:adf:ecc4:0:b0:2c5:510b:8f9c with SMTP id s4-20020adfecc4000000b002c5510b8f9cmr12149990wro.52.1679250812674;
        Sun, 19 Mar 2023 11:33:32 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id d12-20020adffbcc000000b002c54e26bca5sm7097134wrs.49.2023.03.19.11.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 11:33:32 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH] net: dsa: b53: add support for BCM63xx RGMIIs
Date:   Sun, 19 Mar 2023 19:33:30 +0100
Message-Id: <20230319183330.761251-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM63xx RGMII ports require additional configuration in order to work.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 36 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 59cdfc51ce06..378327add363 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1209,6 +1209,36 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	b53_write8(dev, B53_CTRL_PAGE, off, reg);
 }
 
+static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
+				  phy_interface_t interface)
+{
+	struct b53_device *dev = ds->priv;
+	u8 rgmii_ctrl = 0, off;
+
+	if (port == dev->imp_port)
+		off = B53_RGMII_CTRL_IMP;
+	else
+		off = B53_RGMII_CTRL_P(port);
+
+	b53_read8(dev, B53_CTRL_PAGE, off, &rgmii_ctrl);
+
+	rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
+	if (interface == PHY_INTERFACE_MODE_RGMII_ID)
+		rgmii_ctrl |= (RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
+	else if (interface == PHY_INTERFACE_MODE_RGMII_RXID)
+		rgmii_ctrl |= RGMII_CTRL_DLL_RXC;
+	else if (interface == PHY_INTERFACE_MODE_RGMII_TXID)
+		rgmii_ctrl |= RGMII_CTRL_DLL_TXC;
+
+	if (port != dev->imp_port)
+		rgmii_ctrl |= RGMII_CTRL_ENABLE_GMII;
+
+	b53_write8(dev, B53_CTRL_PAGE, off, rgmii_ctrl);
+
+	dev_info(ds->dev, "Configured port %d for %s\n", port,
+		 phy_modes(interface));
+}
+
 static void b53_adjust_link(struct dsa_switch *ds, int port,
 			    struct phy_device *phydev)
 {
@@ -1235,6 +1265,9 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 			      tx_pause, rx_pause);
 	b53_force_link(dev, port, phydev->link);
 
+	if (is63xx(dev) && port >= B53_63XX_RGMII0)
+		b53_adjust_63xx_rgmii(ds, port, phydev->interface);
+
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
 		if (port == dev->imp_port)
 			off = B53_RGMII_CTRL_IMP;
@@ -1402,6 +1435,9 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct b53_device *dev = ds->priv;
 
+	if (is63xx(dev) && port >= B53_63XX_RGMII0)
+		b53_adjust_63xx_rgmii(ds, port, interface);
+
 	if (mode == MLO_AN_PHY)
 		return;
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 795cbffd5c2b..4cf9f540696e 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -211,6 +211,7 @@ static inline int is58xx(struct b53_device *dev)
 		dev->chip_id == BCM7278_DEVICE_ID;
 }
 
+#define B53_63XX_RGMII0	4
 #define B53_CPU_PORT_25	5
 #define B53_CPU_PORT	8
 
-- 
2.30.2

