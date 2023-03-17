Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F9C6BDEC4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCQCdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQCd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:28 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EA82C64F;
        Thu, 16 Mar 2023 19:33:23 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso4282955wmr.3;
        Thu, 16 Mar 2023 19:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ymG14CaAzsom/NpfgXxdIjVcFWXkyKWBzQS1t9W8TsU=;
        b=ZnLfPimuNMRCq+vueikd9c51+25vJac2ZxxU7UyB76QTmrEIwo4rN+PyOOWNsvEoaj
         Jpk2GQC59J0kpQPcP4jlt+pBegpHzcQs6kh34OmzoU3nzzmauNRSFH96dVwUqrKqwO1J
         DR3CoZhP+vfNFcJET39aGxyGhiakx+KWxKqc+BVFrSlps7tyjCZJ+aMqv/hESueQcCW5
         86DbqSuK0vu9AGUfCmv2UZkJQhivnD5SN5YoBUBk0UK0W4waKdMM4f7UdCROArjIZPZR
         e9u9xV6K7b65yrY8SOtrKbAfXKCOwPdLSi/d8lpeL9OBJrxV1MZTaeL5iHskCQsBiGVy
         BOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymG14CaAzsom/NpfgXxdIjVcFWXkyKWBzQS1t9W8TsU=;
        b=F2cWIHXnky7rCW0qrIA59K+xbvZO2DJldf62Cf2VNibUxOm1fcUB1/UAoE//cYLB65
         geJu5yxUTp9IcAaqY8QgQNPHQKyjkxMYbcU9BI3J8I1CiVIGEq+4QGqwJY3UTDc2wMbU
         f7OmEze//EvcDm1g+7i3l8xxGFzPEHMZPCeeQlt1v1LC9GjIk4j6Ka9QAiRbKa1TDtPx
         CRMVRf9M1up1y60eL+vQOZW/0hM9d5aA/6hud85WTVy4yKN+uHItggCanJ4nB6IEGNIO
         tDzmOiJ37DDah/qhU2aEdWWMYqkjO/4/7+5JTMPbot7fwImdf9KlpBNWnZEIpOWhXFis
         JBFA==
X-Gm-Message-State: AO0yUKVQy3ggl8TY3G4qaoyxMpRqH4FPUUWRu28bZJ148gHOHZlWOfVB
        JNnUZr7C83FuQlykoB80Aoc=
X-Google-Smtp-Source: AK7set90zN/Pajq1elk40QOIzkhud0Nl/bWmI2MgiOSNGVnEUw+fEjcL397+mkdD/mEEhTY3UR+VpQ==
X-Received: by 2002:a05:600c:5487:b0:3ed:418a:ec06 with SMTP id iv7-20020a05600c548700b003ed418aec06mr5342265wmb.28.1679020401323;
        Thu, 16 Mar 2023 19:33:21 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:21 -0700 (PDT)
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
Subject: [net-next PATCH v4 01/14] net: dsa: qca8k: move qca8k_port_to_phy() to header
Date:   Fri, 17 Mar 2023 03:31:12 +0100
Message-Id: <20230317023125.486-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
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

