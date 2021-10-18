Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AEC4313A6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJRJmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhJRJmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:42:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FB5C061745
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r18so68633444edv.12
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S68vSimsbQ3DOpCLt2h2BdWp+mWJKw9LEV4EwRYmxRs=;
        b=G8BNbW5FIM3c3k6XM0r3H4/LY8E6UEcYblm3qNfibao959ZSbISzht2ubHFYiJhDhC
         //iYfC8HM26AU2BffOQ4aaXIrUXbgay2VtVg4BN1pHB33n6KvmtI8Wpy5kr67CPdaWsj
         0ybCKwBaJ8+ze06rpH5lQGKvKTbOITLCud8wY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S68vSimsbQ3DOpCLt2h2BdWp+mWJKw9LEV4EwRYmxRs=;
        b=xpnJMpnEFQiDsrD+yHdDgbmLaMxxt3zrsEP6/BT0A1950CxsjiIS+pdFahNGqZn8Tk
         A3RHiIvPupE3km/qlXGykM536iTjHyr0WH/lPkwD5Awb/yLuxqNqj5X1WlAHwq3SUN19
         do1RzK/yjULPAzJVrhosoxkx6tAUWmBTZLOChr+quPKNwnZH8+39ZwWE/Jg1yVut1LKn
         zwt3kr10/EoLI2/1JcdT6Ko6bZ0AkdlIKoEL2fi8sEreJpPJceAd2nYt5DGu+RvF/tXq
         kiKKKMd27RsvqrmKoWEqBVOcND4q05q1AUsPZPzqMQcpNsAeDcKDqEHwu6CIajSD1ygO
         Nr8A==
X-Gm-Message-State: AOAM532t5qBj5mb3ZufZFUnVRuXeIUOxZaifW1CmVxj7TSmNPQv5t/hV
        nU0EoFA6J7L+m7hR1ReaZG1eHw==
X-Google-Smtp-Source: ABdhPJw5jXOd+xJQoKLj2L4jdraHXbHpNpg7l27qyyYUExDjzJBomk7BysxUpBPsZ+Bpf/Y4Nj2doA==
X-Received: by 2002:a17:907:7f01:: with SMTP id qf1mr27694370ejc.190.1634550034469;
        Mon, 18 Oct 2021 02:40:34 -0700 (PDT)
Received: from capella.. ([80.208.66.147])
        by smtp.gmail.com with ESMTPSA id z1sm10134566edc.68.2021.10.18.02.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:40:34 -0700 (PDT)
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
Cc:     arinc.unal@arinc9.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 3/7] net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
Date:   Mon, 18 Oct 2021 11:37:58 +0200
Message-Id: <20211018093804.3115191-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018093804.3115191-1-alvin@pqrs.dk>
References: <20211018093804.3115191-1-alvin@pqrs.dk>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v3 -> v4: no change

v2 -> v3: no change; collect Reviewed-by from Florian

v1 -> v2: no change; collect Reviewed-by from Vladimir and Linus

RFC -> v1: this patch is new

 net/dsa/Kconfig  | 14 +++++++-------
 net/dsa/Makefile |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index d8ee15f1c7a9..3a09784dae63 100644
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
 	select PACKING
@@ -126,6 +119,13 @@ config NET_DSA_TAG_QCA
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

