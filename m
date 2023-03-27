Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942F96CA6E1
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjC0OLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjC0OLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:02 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52432FD;
        Mon, 27 Mar 2023 07:11:01 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j24so8983257wrd.0;
        Mon, 27 Mar 2023 07:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVb+VQvq+8Sp9A/ftRiE2SBUlVZOPfZp868HAFVyi3c=;
        b=CSyUh1s0w5yFDOYYim2gDh/XdZVgY4x5WIM7D9EFchqjrBGIoB/cqSyoJtTYOODyai
         7MpTyay9H1Y3VKimKvpTwkv3cA+qV7X6XDG+lQdFpfJ3uYJbZBTVvKso5gIK8rkMTfeW
         q+j+cMzVlGa7iyNMhrOXFzryqnRZoUoof9+Q3uk1jzn8Z9iKyLwz5fxYpm9Alm61T77d
         eoEcAcRHjuUUuD+zDASjwY1Vu9Jd5xJ2vp2uoHsR+Lp5pNhybmATSM1K0aTo6GZM6jET
         jGmktpw48fOPtcC2ZNFfrIx+xqqTdZzBfUI3QPyg1gjoDbCYP1VsnIBJ+CsRdjXQFbnJ
         HhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVb+VQvq+8Sp9A/ftRiE2SBUlVZOPfZp868HAFVyi3c=;
        b=6QYQEjFVZgiQ0BSyc4SIfCsQtBekvUlqgFiBtpmSI5H5oYQSBTj/BrnuPcQ/01h3tl
         AWLoCIH39uuuilJx241w0wcmHhkgsfTgnsLjzrye4bOyh63NozJPYVunjV6gzzWAl1T8
         pDCh7+x2tvMAjVMsGQ5A3exudWPPuu3/Vq/1mpO97xADWxPmrXOVS3R20ogFr4raNCGL
         05jMkoEBesQDFXDCS8UVQzprbaWeydOXPi4iU6HtRLO5mN3ixqCy5VH4RCB12qz9mIji
         O5IQkmTz5NqyWE3Zb/asv9OVoOcjLIUJRcGj+7vIiZnVlwVX6E+afJcXxW5Rx2QMyeKw
         gqSg==
X-Gm-Message-State: AAQBX9eLZU1fipVP4jB99hZaeOA7NjSDxkRa5HWU+OS6AIGX5Uj2rpwp
        iFdh16rx6AJp+m1bgTk0wvo=
X-Google-Smtp-Source: AKy350aDLHalH3aNV282D1N2/QiTPAFTdA8GfvAaGOScx9xjF+NAVltJg896kFvtPuTG4kFRcOWNAw==
X-Received: by 2002:adf:e90c:0:b0:2cf:eeae:88c3 with SMTP id f12-20020adfe90c000000b002cfeeae88c3mr10206818wrm.32.1679926259563;
        Mon, 27 Mar 2023 07:10:59 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:10:59 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Cc:     Michal Kubiak <michal.kubiak@intel.com>
Subject: [net-next PATCH v6 01/16] net: dsa: qca8k: move qca8k_port_to_phy() to header
Date:   Mon, 27 Mar 2023 16:10:16 +0200
Message-Id: <20230327141031.11904-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 15 ---------------
 drivers/net/dsa/qca/qca8k.h      | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 55df4479ea30..459ea687444a 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -772,21 +772,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
index 7996975d29d3..dd7deb9095d3 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -421,6 +421,20 @@ struct qca8k_fdb {
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

