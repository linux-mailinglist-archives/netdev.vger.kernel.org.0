Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCEE42F9CB
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242050AbhJORND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242028AbhJORNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:13:01 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6427DC061762
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:10:54 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so40827104edv.12
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y+uiI0XbR/7xdV14eyZysVN8LLzardz+mHxuh0DPQJU=;
        b=SsxjFbla/VgWJfe74PWF+zjnqLXs90gduBqvp/Zh8nbkgFqe6GjAyabk1SCLN7PdLG
         ptUTt4IO52V/mcxvXA/2qFT6ZS7zfp2byTLhzGdLQJuv1w4IOQj2pZ/XEVUk6ogeaUzI
         35co7L+4HxTc6ww67OtmZwnE2zd305toy5p48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+uiI0XbR/7xdV14eyZysVN8LLzardz+mHxuh0DPQJU=;
        b=a0iye+ePqUygm/urB5EQd8m0edvbLSXIHlTi7x+CZLAEMccebX6rMjSQ4ZF8rT8LbH
         niJTe2rqqyLi6EdbS/XWAqDHBtdvbbmIkVVQ+zgLcVz1sgNZB0aBU8I3zc+bhqmU2APn
         qjlga/OY58o+cRr65vE085bO0XAvakuC6LFG4uAm64hViIIVuEsmFAz4IYyhzdTWtJ/g
         E5LPiDuMyp+EFwBdp+pdMkr+V0Nd+9dKbi8mKJpg1TUXQzLdEJCU6XDGbaQn93rTtLg/
         6rg7fhu0l8K3SowYxgxHdb2hAVAgbWEH8TiaVYUY9fbMcpGoVDzcZcDFWWLqqXcBAal5
         XjKA==
X-Gm-Message-State: AOAM530BTta3buBOefCVA7pjRwngtacXcm60AdJ9P0c1QFdByoCPsTF5
        vtkHU04c30sRE4PvOQj6pW3AXQ==
X-Google-Smtp-Source: ABdhPJzhl/qp/eTpqnJVmEh+La6DgXIBWI/Nxh0V9DSh0Xem4p8hVH8oNPWmkkPZI+JZ/eib3xcNVQ==
X-Received: by 2002:a17:906:c2ca:: with SMTP id ch10mr8493842ejb.311.1634317852987;
        Fri, 15 Oct 2021 10:10:52 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id jt24sm4735792ejb.59.2021.10.15.10.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 10:10:52 -0700 (PDT)
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
Subject: [PATCH v3 net-next 3/7] net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
Date:   Fri, 15 Oct 2021 19:10:24 +0200
Message-Id: <20211015171030.2713493-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211015171030.2713493-1-alvin@pqrs.dk>
References: <20211015171030.2713493-1-alvin@pqrs.dk>
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

