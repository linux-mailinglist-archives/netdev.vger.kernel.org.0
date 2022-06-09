Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E735544094
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 02:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbiFIA26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 20:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiFIA24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 20:28:56 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BF76372;
        Wed,  8 Jun 2022 17:28:55 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id o7so11172745eja.1;
        Wed, 08 Jun 2022 17:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iZYilu8fPT/X0/rC3yI2GAgJU7tXE0lBGVOQjpp6qfg=;
        b=Eh/MIYG2mfr8DWBEbA8RjQdvZyriooYS+sRRTbmbx0KeybrKZe2Gds8SidizZcl0uF
         Zwc0bNBw5DWZ/f3vwVvZ028NZj5qUltbENvd+jrl5410z2/pp3tbV02gdER9psqVPkf5
         /fSDZi+VeSIs3ktCmBGrGjWyOVJwfAY3zzDz4vyQHi9dB/lb9GO6VdrTPW0I5nu2DEWi
         1YgxaJEhnXrWpmMWwcu5TnUutF/t/br69v1D52bMEi89GFcZyXWxcdOIHAwuLeCKPey3
         cy8VMJXGmdGls+p7Fz4gC4vTljIMM3kIwsZtbx90SBiBSt3oxn+FeahKrNRNb1q6RBkf
         LYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iZYilu8fPT/X0/rC3yI2GAgJU7tXE0lBGVOQjpp6qfg=;
        b=HKnCnoY4oBzml5uq1PE6WK+k6qDJZRyEkuqWXpCO/o95DCYJk3Fj5R/Lc1pJjCGVYB
         d7fJI8EqW1qiRxwU5S1w9UTr9s+bCZluPRq4AZ8q2TXHvnb/AebjTvDLlHpBfntLEG98
         7wu87s8xyl9cR1zJ5JyUDCYdTz/0DAMv+cb5IvlOpaZcDpJWYjEis/yhNgHieeXTzRhb
         jW7aEsvYTbEyYbA84xLn4QPlDMw3kPg5S6OWn9LnuYG5uqaWhEFZNGIj4bOH0cLNwZHN
         9qaV+RifRgFXisQdaVxeZCErO8g15R4Y9lBUzK7yGo3Gv3QWKQzZjnxTHLXPeYW9zBCS
         TTdQ==
X-Gm-Message-State: AOAM531p3CJ4EnU7aZSLTFdIO+ZG1T5tj9ba9Rs0qsePI4NZ+FYjmKfM
        UluXgoLkgsVqHUUqhg7AtU0=
X-Google-Smtp-Source: ABdhPJz+2lELdvabfIWbfohoHH9dl6Q+0YhytqLPBbaw5WQ97ArKPw0ZDiQDPP9b2Y9CzTJCpKNLEg==
X-Received: by 2002:a17:906:4784:b0:6ff:34ea:d824 with SMTP id cw4-20020a170906478400b006ff34ead824mr34687999ejc.526.1654734534147;
        Wed, 08 Jun 2022 17:28:54 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id g22-20020aa7c596000000b0042deea0e961sm13110325edq.67.2022.06.08.17.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 17:28:53 -0700 (PDT)
From:   Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>,
        Mark Mentovai <mark@moxienet.com>
Subject: [net-next PATCH 2/2] net: ethernet: stmmac: reset force speed bit for ipq806x
Date:   Thu,  9 Jun 2022 02:28:31 +0200
Message-Id: <20220609002831.24236-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220609002831.24236-1-ansuelsmth@gmail.com>
References: <20220609002831.24236-1-ansuelsmth@gmail.com>
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

Some bootloader may set the force speed regs even if the actual
interface should use autonegotiation between PCS and PHY.
This cause the complete malfuction of the interface.

To fix this correctly reset the force speed regs if a fixed-link is not
defined in the DTS. With a fixed-link node correctly configure the
forced speed regs to handle any misconfiguration by the bootloader.

Reported-by: Mark Mentovai <mark@moxienet.com>
Co-developed-by: Mark Mentovai <mark@moxienet.com>
Signed-off-by: Mark Mentovai <mark@moxienet.com>
Signed-off-by: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 832f442254d8..0f2f2bc6873d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -66,6 +66,17 @@
 #define NSS_COMMON_CLK_DIV_SGMII_100		4
 #define NSS_COMMON_CLK_DIV_SGMII_10		49
 
+#define QSGMII_PCS_ALL_CH_CTL			0x80
+#define QSGMII_PCS_CH_SPEED_FORCE		BIT(1)
+#define QSGMII_PCS_CH_SPEED_10			0x0
+#define QSGMII_PCS_CH_SPEED_100			BIT(2)
+#define QSGMII_PCS_CH_SPEED_1000		BIT(3)
+#define QSGMII_PCS_CH_SPEED_MASK		(QSGMII_PCS_CH_SPEED_FORCE | \
+						 QSGMII_PCS_CH_SPEED_10 | \
+						 QSGMII_PCS_CH_SPEED_100 | \
+						 QSGMII_PCS_CH_SPEED_1000)
+#define QSGMII_PCS_CH_SPEED_SHIFT(x)		((x) * 4)
+
 #define QSGMII_PCS_CAL_LCKDT_CTL		0x120
 #define QSGMII_PCS_CAL_LCKDT_CTL_RST		BIT(19)
 
@@ -253,6 +264,56 @@ static void ipq806x_gmac_fix_mac_speed(void *priv, unsigned int speed)
 	ipq806x_gmac_set_speed(gmac, speed);
 }
 
+static int
+ipq806x_gmac_configure_qsgmii_pcs_speed(struct ipq806x_gmac *gmac)
+{
+	struct platform_device *pdev = gmac->pdev;
+	struct device *dev = &pdev->dev;
+	struct device_node *dn;
+	int link_speed;
+	int val = 0;
+	int ret;
+
+	/* Some bootloader may apply wrong configuration and cause
+	 * not functioning port. If fixed link is not set,
+	 * reset the force speed bit.
+	 */
+	if (!of_phy_is_fixed_link(pdev->dev.of_node))
+		goto write;
+
+	dn = of_get_child_by_name(pdev->dev.of_node, "fixed-link");
+	ret = of_property_read_u32(dn, "speed", &link_speed);
+	if (ret) {
+		dev_err(dev, "found fixed-link node with no speed");
+		return ret;
+	}
+
+	of_node_put(dn);
+
+	val = QSGMII_PCS_CH_SPEED_FORCE;
+
+	switch (link_speed) {
+	case SPEED_1000:
+		val |= QSGMII_PCS_CH_SPEED_1000;
+		break;
+	case SPEED_100:
+		val |= QSGMII_PCS_CH_SPEED_100;
+		break;
+	case SPEED_10:
+		val |= QSGMII_PCS_CH_SPEED_10;
+		break;
+	}
+
+write:
+	regmap_update_bits(gmac->qsgmii_csr, QSGMII_PCS_ALL_CH_CTL,
+			   QSGMII_PCS_CH_SPEED_MASK <<
+			   QSGMII_PCS_CH_SPEED_SHIFT(gmac->id),
+			   val <<
+			   QSGMII_PCS_CH_SPEED_SHIFT(gmac->id));
+
+	return 0;
+}
+
 static const struct soc_device_attribute ipq806x_gmac_soc_v1[] = {
 	{
 		.revision = "1.*",
@@ -400,6 +461,10 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 		err = ipq806x_gmac_configure_qsgmii_params(gmac);
 		if (err)
 			goto err_remove_config_dt;
+
+		err = ipq806x_gmac_configure_qsgmii_pcs_speed(gmac);
+		if (err)
+			goto err_remove_config_dt;
 	}
 
 	plat_dat->has_gmac = true;
-- 
2.36.1

