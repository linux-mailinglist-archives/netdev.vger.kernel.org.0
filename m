Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F410C4FAD5D
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 12:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiDJKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 06:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbiDJKti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 06:49:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15064532D7
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:47:25 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i20so5873397wrb.13
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dHw0ze7kPDnIvTVoxJK6ZVkq2hDaA8Qm0g3L6P4FDSw=;
        b=G/R1HKosO5zdupv20vffPuKUvnr5Dc+Xa79WY4Ehm8vxEms8Y9Iaz5QfXihi/mMAYk
         mDdPoWxZZl7wo8eTfwK5oz602vrrUPCiSFcUw2dzU5H6d8jRflvk8s0WIVbCN0v28sYr
         r4ollu2OpbbhPgCwnIm9UFZw7j6IWRa8RlxkpGCypgVnt5VR9B3Lu0WIt/WKtgrXh8p1
         9Ns1UimFg3ZbdQo3etloXg0i/2gKcetu1vFAt/00qDXFFLvoWVtdISCQo1V44Zx95ZTO
         wPrtiltYFWw2HhcSXqnviaC7+bCt1t9Q1yo6S9DbcWIllzpxTULVA0plsxLUYYjNl0lK
         5D3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dHw0ze7kPDnIvTVoxJK6ZVkq2hDaA8Qm0g3L6P4FDSw=;
        b=pOhcGgAxFFExpJVFuqNaHBVXDb0JlwR94tusRighEdShxpBH5w+oxZ5NofpOmq78MZ
         vuEZQawaAqzqfFVxdmzpLxJM6k4XfmXLAwqsT8k5TUHX0A48Ly73yd0ElGhRiXuMeyCo
         P4nNWQwlW9LJfY1cE6gUyskzkjTnf1yFvRG8/bN19PsTMesIlt10oky9fsPvOcIxVIam
         5WuAMjExR71PDfGYSkL0qGmD8hLKn5I8xVVKIx9viTPhX9Fs3oA+C6V58rt/3zyzIddt
         Tf1rCMiYCtjYAnNqiLU4yE3YRQPBsmqaohf4jzjs+rGyfcyeDsBvtEi5bByxFICDue1G
         YJhg==
X-Gm-Message-State: AOAM533FRGPJ8eYay5s0CRs5C6hkGhrjwuNDXT5svnpHFI4vSvoMXq0M
        OoxZLUNUq9NC2Or3/z9QvB+xVzqBFfS61HblRnI=
X-Google-Smtp-Source: ABdhPJzIWofi38fb5fboVlfGGesJhiyxgscvwa8zvXE8u2H+Ouv14Jt74TzkEa8sYCcIBE1xAuMLeg==
X-Received: by 2002:a5d:67c3:0:b0:207:a0e8:1932 with SMTP id n3-20020a5d67c3000000b00207a0e81932mr4186764wrw.436.1649587643441;
        Sun, 10 Apr 2022 03:47:23 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d64c8000000b0020784359295sm12839196wri.54.2022.04.10.03.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 03:47:22 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 2/3] net: phy: adin: add support for 125MHz clk-out
Date:   Sun, 10 Apr 2022 13:46:25 +0300
Message-Id: <20220410104626.11517-3-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220410104626.11517-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 supports generating certain clocks on its GP_CLK pin.
Add support for selecting the 125MHz clock via a device-tree property.

While other frequencies are technically available, they are omitted for
now, due to the complexity of choices.

Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Josua Mayer<josua@solid-run.com>
---
 drivers/net/phy/adin.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5ce6da62cc8e..dbe2bb7f30d9 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -99,6 +99,10 @@
 #define ADIN1300_GE_SOFT_RESET_REG		0xff0c
 #define   ADIN1300_GE_SOFT_RESET		BIT(0)
 
+#define ADIN1300_GE_CLK_CFG_REG			0xff1f
+#define   ADIN1300_GE_CLK_CFG_MASK		GENMASK(5, 0)
+#define   ADIN1300_GE_CLK_CFG_FREE_125		BIT(4)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -433,6 +437,28 @@ static int adin_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int adin_config_clk_out(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	u32 val;
+	u8 sel;
+
+	if (device_property_read_u32(dev, "adi,clk-out-frequency", &val))
+		return 0;
+
+	switch (val) {
+	case 125000000:
+		sel = ADIN1300_GE_CLK_CFG_FREE_125;
+		break;
+	default:
+		phydev_err(phydev, "invalid adi,clk-out-frequency\n");
+		return -EINVAL;
+	}
+
+	return phy_modify_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_CLK_CFG_REG,
+			      ADIN1300_GE_CLK_CFG_MASK, sel);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
@@ -455,6 +481,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_clk_out(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.34.1

