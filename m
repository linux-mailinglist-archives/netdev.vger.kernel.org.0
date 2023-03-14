Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2FA6B9AEE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjCNQRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCNQRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B51EB4823;
        Tue, 14 Mar 2023 09:17:23 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p4so8688111wre.11;
        Tue, 14 Mar 2023 09:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ymG14CaAzsom/NpfgXxdIjVcFWXkyKWBzQS1t9W8TsU=;
        b=jhqmQLzk8XgfMOVo0VrOhrak6hNyCjDYqJS+nh2iMI5nCaiUabFM8PlWOcWdsjgkpx
         E+efhn43fHd8GZxwQHyz3ZPIalFZ6JFkzXuKxzR0AswbhUYjQdm5K75IAFWSgPoaOsRq
         RpS4cz3Y+hOyVXqwA6u4SDUzCbvxIM0XFWVxlCbrhlFBN8Fp5DwYcNOv89tJSg+PF5JX
         s7lLj6jyDwHz41QZXrf+tb6MJVGXMJIp8s414V0EJVvt9DvJZ8+RPT9OkHuK90EeOqT/
         YZwkAaW5F1e6gMFDK2jRqiu1DStsVmub2e6ZvJpSCgLmMO0RUUzBVw3Th7Stlwa9oCcq
         zM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymG14CaAzsom/NpfgXxdIjVcFWXkyKWBzQS1t9W8TsU=;
        b=r6pzebKNIIGpVd6kCaEy+KK7Ca/DvfPyp7RuE1xziMe9MYT+N/j6gD5Xweuzfkm0WU
         h/0ADN3joVTSQdLcSfaH7SDZC11Ue4FhEa3RCjanWiQRMOYs+jxqn6K2n721qmcwGhDu
         N3WNXguAhz+jpvW9ACn4J7ZHpU1IhgATgxGWCOpDrCf+3DGcvie9mqBVWf6yb/WuSIfD
         w/2u/rW36ydSEoYpeEHau+Dzv7YfEpppX9BuKHJRpq4wfgDQeMiQ02T1eEulkX9/BBhm
         ziDGC0Jj78ZCvne/xHHBi29ktfvtPSC47sYPjYq8ymf/e3j3+iXSOZlVf5KGKqRhbySx
         0GpQ==
X-Gm-Message-State: AO0yUKV2hiEHJxi41KpUtuYtwajh/P9+QOG1md5NHPHi+NLh7SYrOTYt
        ISjHcw3eGsk9DGHNsr+Aqgk=
X-Google-Smtp-Source: AK7set/ubSTHM5CNA+4Cklo4/839WmzTD5hrc1qf2XFeVIUZ7BG4H4slUU9mJ3JLVM+us57yoIxhXg==
X-Received: by 2002:adf:f78a:0:b0:2ce:a7f2:d0b with SMTP id q10-20020adff78a000000b002cea7f20d0bmr7119794wrp.64.1678810642217;
        Tue, 14 Mar 2023 09:17:22 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:21 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v3 01/14] net: dsa: qca8k: move qca8k_port_to_phy() to header
Date:   Tue, 14 Mar 2023 11:15:03 +0100
Message-Id: <20230314101516.20427-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k_port_to_phy() to qca8k header as it's useful for future
reference in Switch LEDs module since the same logic is applied to get
the right index of the switch port.
Make it inline as it's simple function that just decrease the port.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 15 ---------------
 drivers/net/dsa/qca/qca8k.h      | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 2f224b166bbb..8dfc5db84700 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -716,21 +716,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	return ret;
 }
 
-static u32
-qca8k_port_to_phy(int port)
-{
-	/* From Andrew Lunn:
-	 * Port 0 has no internal phy.
-	 * Port 1 has an internal PHY at MDIO address 0.
-	 * Port 2 has an internal PHY at MDIO address 1.
-	 * ...
-	 * Port 5 has an internal PHY at MDIO address 4.
-	 * Port 6 has no internal PHY.
-	 */
-
-	return port - 1;
-}
-
 static int
 qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 {
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 03514f7a20be..4e48e4dd8b0f 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -422,6 +422,20 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+static inline u32 qca8k_port_to_phy(int port)
+{
+	/* From Andrew Lunn:
+	 * Port 0 has no internal phy.
+	 * Port 1 has an internal PHY at MDIO address 0.
+	 * Port 2 has an internal PHY at MDIO address 1.
+	 * ...
+	 * Port 5 has an internal PHY at MDIO address 4.
+	 * Port 6 has no internal PHY.
+	 */
+
+	return port - 1;
+}
+
 /* Common setup function */
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
-- 
2.39.2

