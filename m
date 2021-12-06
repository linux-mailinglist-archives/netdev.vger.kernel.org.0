Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E184646A3AD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346300AbhLFSFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346722AbhLFSEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:55 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C174C0698CD;
        Mon,  6 Dec 2021 10:01:04 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so11411087pjc.4;
        Mon, 06 Dec 2021 10:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a22elMeKMuvw9kAaeC7xqXjpamRaXXRHV5cJtgBXnMI=;
        b=FNuLLY+2QfkUYYdnHtv03ga/tmbb/WnbRqvODT34TbvpQz79NTmgr2/ROaxi1KvJiZ
         qonBJ/pxCvk2g0IPUd6Qpj7sabtCux2WfcYJyghukcUmsUKFoXGNQBd9A0OnYJOttTpx
         UIdl3MStDRxZsVsDZiX6hKX3+Xf4hhKpQQ8NWpFeS5HZyX6HxKpq76L25dbl/vWYLiNz
         uqzh+mwcTJ+AkK4uG67QuWo9VRAWujUhAVWThnL38skDly9DrMhLJ0Gh0bcADhdLSleA
         5Iv6EqE9Gdii24EzG0q3nm7+KdSW8SoHMsIYrEVp1pzKzPnVP5a7WlBssIkHOB5yKGlL
         Zu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a22elMeKMuvw9kAaeC7xqXjpamRaXXRHV5cJtgBXnMI=;
        b=SeqVkaBN+pOzDNZZ5kQ7tpl8gbqXLi9Gcv9VUP3I0jzDnBoYugyaZNbdNUAd0jAh1D
         puPl865GbGA4We+0HmK+Wi0rfZAgmIPiB7uXO+DP3bM7KQTE5Fc8hy/tbNjXx0Z23BVo
         9CfhizrJtaF+srFUvb3CzBm85Jh1/6KYzg9p1ybBM2K1HxHpORGNbBkD7TnaJcO/qkgq
         5KOvOIUUU2ByGNcbkcM+vj82hs71lYvfpdqNwwrUUVXmARcV28/Uv9bzsz3V4ShLcVbk
         y0IXQhPt5Gv+3ZZ5/wnWwYPCsip9kMl0H4Lu/YdCgjoi0LAnQtlfrHNiqPbFrhJkaybA
         4eEg==
X-Gm-Message-State: AOAM530GsqUArbhuKfHMFbxWa77SDvAXw8oSPq4b/Z42unHJ8ZNfuuES
        WvR4h2aqyX7AawX7uSP3fihaerJ5NGk=
X-Google-Smtp-Source: ABdhPJwT0/hSqTiWhbGXegTiFL+l5hd6q19jJHrHzsa1pAOaawNuH4ZZtQfWAqoe9uuW9xXye0+Agg==
X-Received: by 2002:a17:902:b28b:b0:142:4abc:ac20 with SMTP id u11-20020a170902b28b00b001424abcac20mr45718472plr.88.1638813663456;
        Mon, 06 Dec 2021 10:01:03 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:01:03 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH v3 8/8] dt-bindings: net: Convert iProc MDIO mux to YAML
Date:   Mon,  6 Dec 2021 10:00:49 -0800
Message-Id: <20211206180049.2086907-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conver the Broadcom iProc MDIO mux Device Tree binding to YAML.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/brcm,mdio-mux-iproc.txt      | 62 --------------
 .../bindings/net/brcm,mdio-mux-iproc.yaml     | 80 +++++++++++++++++++
 2 files changed, 80 insertions(+), 62 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
deleted file mode 100644
index deb9e852ea27..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
+++ /dev/null
@@ -1,62 +0,0 @@
-Properties for an MDIO bus multiplexer found in Broadcom iProc based SoCs.
-
-This MDIO bus multiplexer defines buses that could be internal as well as
-external to SoCs and could accept MDIO transaction compatible to C-22 or
-C-45 Clause. When child bus is selected, one needs to select these two
-properties as well to generate desired MDIO transaction on appropriate bus.
-
-Required properties in addition to the generic multiplexer properties:
-
-MDIO multiplexer node:
-- compatible: brcm,mdio-mux-iproc.
-
-Every non-ethernet PHY requires a compatible so that it could be probed based
-on this compatible string.
-
-Optional properties:
-- clocks: phandle of the core clock which drives the mdio block.
-
-Additional information regarding generic multiplexer properties can be found
-at- Documentation/devicetree/bindings/net/mdio-mux.yaml
-
-
-for example:
-		mdio_mux_iproc: mdio-mux@66020000 {
-			compatible = "brcm,mdio-mux-iproc";
-			reg = <0x66020000 0x250>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			mdio@0 {
-				reg = <0x0>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				pci_phy0: pci-phy@0 {
-					compatible = "brcm,ns2-pcie-phy";
-					reg = <0x0>;
-					#phy-cells = <0>;
-				};
-			};
-
-			mdio@7 {
-				reg = <0x7>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				pci_phy1: pci-phy@0 {
-					compatible = "brcm,ns2-pcie-phy";
-					reg = <0x0>;
-					#phy-cells = <0>;
-				};
-			};
-			mdio@10 {
-				reg = <0x10>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				gphy0: eth-phy@10 {
-					reg = <0x10>;
-				};
-			};
-		};
diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
new file mode 100644
index 000000000000..af96b4fd89d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,mdio-mux-iproc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MDIO bus multiplexer found in Broadcom iProc based SoCs.
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+description:
+  This MDIO bus multiplexer defines buses that could be internal as well as
+  external to SoCs and could accept MDIO transaction compatible to C-22 or
+  C-45 Clause. When child bus is selected, one needs to select these two
+  properties as well to generate desired MDIO transaction on appropriate bus.
+
+allOf:
+  - $ref: /schemas/net/mdio-mux.yaml#
+
+properties:
+  compatible:
+    const: brcm,mdio-mux-iproc
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+    description: core clock driving the MDIO block
+
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio_mux_iproc: mdio-mux@66020000 {
+        compatible = "brcm,mdio-mux-iproc";
+        reg = <0x66020000 0x250>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio@0 {
+           reg = <0x0>;
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           pci_phy0: pci-phy@0 {
+              compatible = "brcm,ns2-pcie-phy";
+              reg = <0x0>;
+              #phy-cells = <0>;
+           };
+        };
+
+        mdio@7 {
+           reg = <0x7>;
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           pci_phy1: pci-phy@0 {
+              compatible = "brcm,ns2-pcie-phy";
+              reg = <0x0>;
+              #phy-cells = <0>;
+           };
+        };
+
+        mdio@10 {
+           reg = <0x10>;
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           gphy0: eth-phy@10 {
+              reg = <0x10>;
+           };
+        };
+    };
-- 
2.25.1

