Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C30054AF44
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 13:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355692AbiFNLWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 07:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354764AbiFNLWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 07:22:47 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A1622528;
        Tue, 14 Jun 2022 04:22:47 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n185so4456576wmn.4;
        Tue, 14 Jun 2022 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XAi7yYw1KbeaAyG4ORCQsljXN7rpKYz0Lgy/6AMChJQ=;
        b=lUPqteObQGzNdhBASmGAVQhbq/1XEP2Lgp5ACwtc4/b4EseGatsEeRcX8qyteDH4JS
         6X5v60mLdnJtv+/AL1muJL+qbU66mhcG8567Sjo3K2W+iPJXcBEsrR5SUn2Z4cFrKXID
         NJ6wTbdGksyQz+uh7JcF9ckSL8wwhqHhIyO0jCxFOUJPq8oWy2u0OBYUpNItg56iDvDA
         wEoCY0NE8jkl/HB3Ga81kjJ2tzdzZHQIbKRF1Ni4DCS9QFsvsx1N9OxosJn10TG/LHl3
         cjpzmhfMOPgsHyr57ckAijWy0sOTcORIV4OlKPACSQ6jdYNir1ZVZ9mqW6/RPh1rbAm/
         76Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XAi7yYw1KbeaAyG4ORCQsljXN7rpKYz0Lgy/6AMChJQ=;
        b=i6lwOihr6gDlbV5Pn57wZtEKxnerP68Ae4KPnnkMEna3CYijWi3PurwayezydaoMWx
         Ts2xXBZcYeedDbGvRO3PHDJVXRGmeIqNFze8myfcH82caW2HNAlbSGbNYjqPM5fG4EJy
         +Gxt0ZzSY62bYm2YcMoVF65DIlY8LcQ2HehtLgpPn0XrwvfrC/iZ9A+pLQZehsazfqA2
         oJ6ZhahiDanc4q0+D+4oJyfUPd36H6bhocKBIUS/OsmZiGKUHXWYTEFFTt8bU21MSNyZ
         L2c2vjmH02Yuaj1jp+YTJ6igejD16gPLft1t+cfqkOXQyiDrmMtEk61ey2V6ADzvMrOi
         VzpQ==
X-Gm-Message-State: AOAM531IQKW89KlgQgsT0NpGxiMPgX5D64ZWA7RcNvAudHPaz19g92e5
        8ysVxJcW3U6J/3zBwld0Udw=
X-Google-Smtp-Source: ABdhPJyPIX1VeSzfEnAnyUHfwwBxOlzTXFdDjygeX1gNCUoQDW/NrvecGfaXgomSrSNZoXGvW+e/fA==
X-Received: by 2002:a7b:c110:0:b0:39c:8270:7b95 with SMTP id w16-20020a7bc110000000b0039c82707b95mr3601441wmi.41.1655205765413;
        Tue, 14 Jun 2022 04:22:45 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id o19-20020a1c4d13000000b0039c60e33702sm12497390wmh.16.2022.06.14.04.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 04:22:44 -0700 (PDT)
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
Subject: [net-next PATCH v2 2/2] net: ethernet: stmmac: reset force speed bit for ipq806x
Date:   Tue, 14 Jun 2022 13:22:28 +0200
Message-Id: <20220614112228.1998-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614112228.1998-1-ansuelsmth@gmail.com>
References: <20220614112228.1998-1-ansuelsmth@gmail.com>
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
v2:
- Fix reference leak for 'fixed-link' node

 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 832f442254d8..e888c8a9c830 100644
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
 
@@ -253,6 +264,55 @@ static void ipq806x_gmac_fix_mac_speed(void *priv, unsigned int speed)
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
+	of_node_put(dn);
+	if (ret) {
+		dev_err(dev, "found fixed-link node with no speed");
+		return ret;
+	}
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
@@ -400,6 +460,10 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
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

