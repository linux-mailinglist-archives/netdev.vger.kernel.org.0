Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02AA6C7A0D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbjCXImA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCXIly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:41:54 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113A517CF3;
        Fri, 24 Mar 2023 01:41:46 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ek18so4877175edb.6;
        Fri, 24 Mar 2023 01:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679647304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfUWRaFIQIQw/lRivER+LHryfdLliXzvabGrcmkQVEU=;
        b=JMrl6Eay1FS0JZqgPHsbcVzuNAbFELc0SLNGyzYtOVQXcI+YwKDM9Ls7I9PsQVEPoZ
         CthomCTYoz5G9DU7uBuia207rnjOhssZJRu0syrCoU+O/ZiQyGLJDvq61z5oZJxC2S40
         kzRsUsC6MRjn64DKPWmxhsSTMKLzn2+P233LKNFbHtfi3NWF5Qu/85sUkxMurnfUgja0
         qQhl25qYY7ZIvmlFHYefaI5UkITQFuiybrqJW9tztCdHf/gS+f33YkkvQ8njmMQa1DW0
         ppedfOUotX+6kmHZGX1yea2V5ezEGGvRourZtYMoecTiD0E5d1J1bKhktKslVLIDm0ig
         oc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OfUWRaFIQIQw/lRivER+LHryfdLliXzvabGrcmkQVEU=;
        b=b3Gmga5ZDbnmQfnw1GCz+eU2JwgsVzfciZuSmfYAiVxpW4c6cur3MHbpzDPhi99wzA
         ZYAM7ryLv88rXl/tQB5g2Nte5rvMfxUeHXsT/JpsRcSSocFRbRrk0QJyiA/Xj86NiD5N
         C1sKz50Im190FmrvPcBh6OHQbv/3MQyE+1fQx+9q3jW5rQiAWQaYk4Ng8GlWA7gtG3jB
         fHO6Fuoenn32pgkveJbQLYL/2t2f53wGf3QLQ3IeKW7jdfIHNThwrwqBMxdHoIDaTBT9
         UWMeJuiYtylIibo/3zbORbWOgIERlWxZRf3BCOFpnzUn4eBzio4LgjtNxZ77ITRxsmbk
         3+Hg==
X-Gm-Message-State: AAQBX9dfyBfbR7Sdd5wqxMiAv3Yhk47pK1XzD87MZyAF3AxyoFyKcMaF
        EbwJLyRvTGQEFdVWCGw1eMU=
X-Google-Smtp-Source: AKy350bpDVLq7k1FxG2Mek/VIobZL4KhufiKx8qfmpxpcWmLI3bLg8wfQKEAKJRNJBleo/7CZuCL5g==
X-Received: by 2002:aa7:c711:0:b0:4a2:588f:b3c5 with SMTP id i17-20020aa7c711000000b004a2588fb3c5mr2261236edq.21.1679647304260;
        Fri, 24 Mar 2023 01:41:44 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id z21-20020a50cd15000000b004acbda55f6bsm10323728edi.27.2023.03.24.01.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 01:41:43 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 2/2] net: dsa: b53: mdio: add support for BCM53134
Date:   Fri, 24 Mar 2023 09:41:38 +0100
Message-Id: <20230324084138.664285-3-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230324084138.664285-1-noltari@gmail.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230324084138.664285-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paul Geurts <paul.geurts@prodrive-technologies.com>

Add support for the BCM53134 Ethernet switch in the existing b53 dsa driver.
BCM53134 is very similar to the BCM58XX series.

Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: add BCM53134 to is531x5() and remove special RGMII config

 drivers/net/dsa/b53/b53_common.c | 15 +++++++++++++++
 drivers/net/dsa/b53/b53_mdio.c   |  5 ++++-
 drivers/net/dsa/b53/b53_priv.h   |  7 +++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 1f9b251a5452..3464ce5e7470 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2613,6 +2613,20 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
 	},
+	{
+		.chip_id = BCM53134_DEVICE_ID,
+		.dev_name = "BCM53134",
+		.vlans = 4096,
+		.enabled_ports = 0x12f,
+		.imp_port = 8,
+		.cpu_port = B53_CPU_PORT,
+		.vta_regs = B53_VTA_REGS,
+		.arl_bins = 4,
+		.arl_buckets = 1024,
+		.duplex_reg = B53_DUPLEX_STAT_GE,
+		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
+		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+	},
 };
 
 static int b53_switch_init(struct b53_device *dev)
@@ -2790,6 +2804,7 @@ int b53_switch_detect(struct b53_device *dev)
 		case BCM53012_DEVICE_ID:
 		case BCM53018_DEVICE_ID:
 		case BCM53019_DEVICE_ID:
+		case BCM53134_DEVICE_ID:
 			dev->chip_id = id32;
 			break;
 		default:
diff --git a/drivers/net/dsa/b53/b53_mdio.c b/drivers/net/dsa/b53/b53_mdio.c
index 6ddc03b58b28..8b422b298cd5 100644
--- a/drivers/net/dsa/b53/b53_mdio.c
+++ b/drivers/net/dsa/b53/b53_mdio.c
@@ -286,6 +286,7 @@ static const struct b53_io_ops b53_mdio_ops = {
 #define B53_BRCM_OUI_2	0x03625c00
 #define B53_BRCM_OUI_3	0x00406000
 #define B53_BRCM_OUI_4	0x01410c00
+#define B53_BRCM_OUI_5	0xae025000
 
 static int b53_mdio_probe(struct mdio_device *mdiodev)
 {
@@ -313,7 +314,8 @@ static int b53_mdio_probe(struct mdio_device *mdiodev)
 	if ((phy_id & 0xfffffc00) != B53_BRCM_OUI_1 &&
 	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_2 &&
 	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_3 &&
-	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_4) {
+	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_4 &&
+	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_5) {
 		dev_err(&mdiodev->dev, "Unsupported device: 0x%08x\n", phy_id);
 		return -ENODEV;
 	}
@@ -375,6 +377,7 @@ static const struct of_device_id b53_of_match[] = {
 	{ .compatible = "brcm,bcm53115" },
 	{ .compatible = "brcm,bcm53125" },
 	{ .compatible = "brcm,bcm53128" },
+	{ .compatible = "brcm,bcm53134" },
 	{ .compatible = "brcm,bcm5365" },
 	{ .compatible = "brcm,bcm5389" },
 	{ .compatible = "brcm,bcm5395" },
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index a689a6950189..fdcfd5081c28 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -80,6 +80,7 @@ enum {
 	BCM583XX_DEVICE_ID = 0x58300,
 	BCM7445_DEVICE_ID = 0x7445,
 	BCM7278_DEVICE_ID = 0x7278,
+	BCM53134_DEVICE_ID = 0x5075,
 };
 
 struct b53_pcs {
@@ -187,7 +188,8 @@ static inline int is531x5(struct b53_device *dev)
 {
 	return dev->chip_id == BCM53115_DEVICE_ID ||
 		dev->chip_id == BCM53125_DEVICE_ID ||
-		dev->chip_id == BCM53128_DEVICE_ID;
+		dev->chip_id == BCM53128_DEVICE_ID ||
+		dev->chip_id == BCM53134_DEVICE_ID;
 }
 
 static inline int is63xx(struct b53_device *dev)
@@ -215,7 +217,8 @@ static inline int is58xx(struct b53_device *dev)
 	return dev->chip_id == BCM58XX_DEVICE_ID ||
 		dev->chip_id == BCM583XX_DEVICE_ID ||
 		dev->chip_id == BCM7445_DEVICE_ID ||
-		dev->chip_id == BCM7278_DEVICE_ID;
+		dev->chip_id == BCM7278_DEVICE_ID ||
+		dev->chip_id == BCM53134_DEVICE_ID;
 }
 
 #define B53_63XX_RGMII0	4
-- 
2.30.2

