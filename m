Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AC142A4A3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhJLMjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbhJLMjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:39:10 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429DFC06161C
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:08 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g10so79782799edj.1
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3lLzL0zqi6ZB5S4b/OIa/wFpOGvBCkD/ZfHBofiA8k=;
        b=LbkszwksaNpF82Q1xU5/HsCYEhQ13RRCJX3dQFLd8Sz5uWBTUhXNfXyLaKksTS926q
         H+VG8+Pa/hZJR+9+DfQqEh6nMm2KYzB0L6rxb70f+E6XHgsisYfmL1zbUGthgrGTgjt4
         PG8LI2MGO/J+xmi8Q72o+SoCz49LipGYApkdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3lLzL0zqi6ZB5S4b/OIa/wFpOGvBCkD/ZfHBofiA8k=;
        b=Ge3xXvQ+lEfPnd0cmEa7UnMZjHa88z/Vn5/tM7tn06vynkKSCrW88EFNQp/pVQwksn
         F7HnO5+/4EzPHM791xU305TRrFh6aEvuHsczgbnOJ3liE00ij63K88UNe5EqPUbBPDR6
         0FDZIYvZ9G5ENYpmxNrJ3GMxURz7+0msDXro9DxbRkR1BmlmAmMC6tTRSKZPwvl2ibaJ
         4KJ4Iv1Xn0xHSqS7+u9Cghl89gg2MZLYE5mXkrHak2LsBphbvojSeKgkdONcr4/SFb5U
         txLiLQ3AVv+4UQ57JPlk2o0dzSc+O26Q40oJtdQJzAwragc/HdSwvdhY9yHMUXPD9n47
         mQKw==
X-Gm-Message-State: AOAM531VMwytbxR/kC9l6kHcpN+Rg1IvZzjnwV+EzAG7SdYC4rI0MjW1
        IpCUKz0ap/yN2+tprT64D8qLoMPlY1D8KqsV
X-Google-Smtp-Source: ABdhPJwBHd8wJ8UXxcJZ3TPmsZvxGvIxwCSCIyE209v0DNcA0MbXDfReG9g6XRgIh+aR/czDDt4Whw==
X-Received: by 2002:a05:6402:3512:: with SMTP id b18mr39742155edd.15.1634042226811;
        Tue, 12 Oct 2021 05:37:06 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id b5sm5763629edu.13.2021.10.12.05.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:37:06 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
Date:   Tue, 12 Oct 2021 14:35:51 +0200
Message-Id: <20211012123557.3547280-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012123557.3547280-1-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Move things around a little so that this tag driver is alphabetically
ordered. The Kconfig file is sorted based on the tristate text.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---

RFC -> v1: this patch is new

 net/dsa/Kconfig  | 14 +++++++-------
 net/dsa/Makefile |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index bca1b5d66df2..6c7f79e45886 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -92,13 +92,6 @@ config NET_DSA_TAG_KSZ
 	  Say Y if you want to enable support for tagging frames for the
 	  Microchip 8795/9477/9893 families of switches.
 
-config NET_DSA_TAG_RTL4_A
-	tristate "Tag driver for Realtek 4 byte protocol A tags"
-	help
-	  Say Y or M if you want to enable support for tagging frames for the
-	  Realtek switches with 4 byte protocol A tags, sich as found in
-	  the Realtek RTL8366RB.
-
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	depends on MSCC_OCELOT_SWITCH_LIB || \
@@ -130,6 +123,13 @@ config NET_DSA_TAG_QCA
 	  Say Y or M if you want to enable support for tagging frames for
 	  the Qualcomm Atheros QCA8K switches.
 
+config NET_DSA_TAG_RTL4_A
+	tristate "Tag driver for Realtek 4 byte protocol A tags"
+	help
+	  Say Y or M if you want to enable support for tagging frames for the
+	  Realtek switches with 4 byte protocol A tags, sich as found in
+	  the Realtek RTL8366RB.
+
 config NET_DSA_TAG_LAN9303
 	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 67ea009f242c..f78d537044db 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -10,12 +10,12 @@ obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
-obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
+obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
 obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
-- 
2.32.0

