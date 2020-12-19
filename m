Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015AC2DF06D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 17:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgLSQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 11:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgLSQWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 11:22:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AAEC0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 08:22:15 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id lb18so3067485pjb.5
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 08:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vjbCgkEIEDGhLhqulvtGhFV7wVlyMteq8jjvPg/2kCE=;
        b=LuCiaHI3aldHOJhF/w9crLqtJzK/7zby9al4L1QAQGpVQefLl8HvODB5QgrWJn1GXZ
         sidNwm5BAD8OCHmh7BduF/iA9LRuCQ9PEooj04CqVxgvdRROA9I+JB9aSd1sPHm7cWyf
         +aDVxO4VZt01me4JYL/nPJmg2KL8m/ZG4KWxLP21YQxMpbi/4giHeZ7K4bRo5m0TM+6l
         UjBqE5fWPoj1imbEcp5053Pv3m0rQZlpj33DeaFAYKmn5psornhwNg/99Wq0IBugWlxM
         kmhPX7VaGGldyXWCGGU3OtvkMHHSxvq2lp/LGs1Dcq/QydpqWoeCBt3UO2j8iAvKJYDz
         AVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vjbCgkEIEDGhLhqulvtGhFV7wVlyMteq8jjvPg/2kCE=;
        b=FhKOUdgmljj2wzeKT1pIdGVGlv/8GK2GC9pKapLf0aw1RbA9rteS6PpnzTDqkwNUgf
         gvXgREz2ZbVX3w11Myj6ZsieEJ/kFCny+C6VA6Yu+he/rEg2h3Gp2IhzMuUSOAjLKV7E
         8GMeqJrF5Jsrotji4QN/Mc059LZw0lgYZlkQC08FEgwZcKGHWwjzzfsULizSfWrxnFDG
         TG0jzoAq/iy5evgUhexUI/2LA6ydi1HaHFXqfsDgLZ5olMO54wxYNYOCIHlSpr01PfsQ
         akAmpzvVcs+1AXWoVgPeokkCs28airKY7q+Pvuhy9JpH6xvX8sV4FyXoISDfMDIXdPW1
         KYRw==
X-Gm-Message-State: AOAM533pQc5Caj+BXRgJI3tMfX2kwlFqnDFS236xm8s180Wp4FpXMH95
        kp2EW14Qm978IU9c4geTyFwlMKaNs2Jqk/aM
X-Google-Smtp-Source: ABdhPJxSLjlao9tVQOpE5WFOKS95jsuxtxFXDu+Kb0KvdxVZ4N/WzAb3+9+1H1Q5CJHNPkkFW/OYug==
X-Received: by 2002:a17:90b:4a50:: with SMTP id lb16mr9356399pjb.25.1608394934961;
        Sat, 19 Dec 2020 08:22:14 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.98])
        by smtp.gmail.com with ESMTPSA id p3sm10544446pjg.53.2020.12.19.08.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 08:22:14 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Subject: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
Date:   Sun, 20 Dec 2020 00:21:53 +0800
Message-Id: <20201219162153.23126-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7621 is a SoC, so using "mediatek,mt7621" as its compatible is ambiguous.
Rename it to "mediatek,mt7621-gsw".

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/mt7530.txt | 8 ++++----
 drivers/net/dsa/mt7530.c                             | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
index 560369efad6c..a9c8492296b3 100644
--- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
+++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
@@ -4,7 +4,7 @@ Mediatek MT7530 Ethernet switch
 Required properties:
 
 - compatible: may be compatible = "mediatek,mt7530"
-	or compatible = "mediatek,mt7621"
+	or compatible = "mediatek,mt7621-gsw"
 	or compatible = "mediatek,mt7531"
 - #address-cells: Must be 1.
 - #size-cells: Must be 0.
@@ -35,7 +35,7 @@ Required properties for the child nodes within ports container:
 	user ports.
 - phy-mode: String, the following values are acceptable for port labeled
 	"cpu":
-	If compatible mediatek,mt7530 or mediatek,mt7621 is set,
+	If compatible mediatek,mt7530 or mediatek,mt7621-gsw is set,
 	must be either "trgmii" or "rgmii"
 	If compatible mediatek,mt7531 is set,
 	must be either "sgmii", "1000base-x" or "2500base-x"
@@ -168,7 +168,7 @@ Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
 		};
 
 		mt7530: switch@1f {
-			compatible = "mediatek,mt7621";
+			compatible = "mediatek,mt7621-gsw";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0x1f>;
@@ -251,7 +251,7 @@ Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
 		};
 
 		mt7530: switch@1f {
-			compatible = "mediatek,mt7621";
+			compatible = "mediatek,mt7621-gsw";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0x1f>;
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 55c8baa31e5d..347845d66671 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
 };
 
 static const struct of_device_id mt7530_of_match[] = {
-	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
+	{ .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
 	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
 	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
 	{ /* sentinel */ },
-- 
2.25.1

