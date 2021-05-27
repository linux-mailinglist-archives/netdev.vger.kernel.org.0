Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21FE39372A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhE0UaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbhE0UaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:30:07 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD13AC061574;
        Thu, 27 May 2021 13:28:29 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id v5so2478881ljg.12;
        Thu, 27 May 2021 13:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqYnRQaTxL5tyvszsxGbPfsuuX2VyZgfjcuAWAFQ+Dg=;
        b=T9MJxhFv8kIFsNzoTiFJ/l+HiKuYsEy4elw+OLd+MFgQ0WLMwTDO7lOyAPwrkINVNL
         RBaZC8YBLwFtZtpLcaYCDZz550Vw89bgCfnss72L+92UkHbjQZjMYkS23Rgf4UjKMs9S
         HmGKglhHz/cYxJ3JN0pcqAHJhkpzPHZc9YitDyWa5zjgDfRKu/4+uXPb3Kbt7N8b3rn1
         BvFA/n9ZeXQ3Ae8zkk8+ckhLSQX/X0MjbKWtS0VdI4nAk2C//ApaLowVdGSE1vOzkCXs
         jy0hFe36Al+WxLNc1o7Kcw6rt/0opxFaPFxXnWQ96/K639hi2ZzCsulorC1N9iv61XAB
         KpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqYnRQaTxL5tyvszsxGbPfsuuX2VyZgfjcuAWAFQ+Dg=;
        b=MmYXTr64VfE18YS51y54+pfnCxDc9s02USlDFyERJvKzfkwdPxHLBoOehvUYbld4uT
         6NOjvt8jyJs6qVvkUoRmvtCWG5W58GovGFr4kiq73YrpksQOkTeukGPXtnpHaUgcZVbY
         MRX6izmJZ8id5fzOijXSdE7MO8ggecNalGcIzTxVyuoCV730BqmT6DM/rcERUbQlZVZw
         +1umrKSF136xZ7u97sPRyfP/eaud7Md+5xq9ZnJLjzZigT/hgC0gJ482dmuII2XEvp1c
         XPlCMmhUkMB7E0EaNRwIwShdPd2FghqbPbrkoxB1nNjZQIwWYbPnBtIl9J9xYJ7YJSG1
         kxoQ==
X-Gm-Message-State: AOAM532ghj2Q3fwOopqhtm5BUA3yXqA+wSULSl24EXw+6aG4pY9RlECo
        R8FW0H24CIuAH6uQzBEgDgI=
X-Google-Smtp-Source: ABdhPJyqrn+i6iV5agtCRklfT2Lk6r4+yOjkamON6rLF7FtlO9QwsS/MDOrBNKW27Kyarn4qv6WJ/w==
X-Received: by 2002:a2e:bb8a:: with SMTP id y10mr3981127lje.78.1622147308085;
        Thu, 27 May 2021 13:28:28 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id y5sm264614lfl.20.2021.05.27.13.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:28:27 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next] dt-bindings: net: brcm,iproc-mdio: convert to the json-schema
Date:   Thu, 27 May 2021 22:28:15 +0200
Message-Id: <20210527202815.14313-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This helps validating DTS files.

Introduced changes:
1. Swapped #address-cells and #size-cells values
2. Renamed node: s/enet-gphy/ethernet-phy@/

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../bindings/net/brcm,iproc-mdio.txt          | 23 -----------
 .../bindings/net/brcm,iproc-mdio.yaml         | 38 +++++++++++++++++++
 2 files changed, 38 insertions(+), 23 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,iproc-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,iproc-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,iproc-mdio.txt b/Documentation/devicetree/bindings/net/brcm,iproc-mdio.txt
deleted file mode 100644
index 8ba9ed11d716..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,iproc-mdio.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-* Broadcom iProc MDIO bus controller
-
-Required properties:
-- compatible: should be "brcm,iproc-mdio"
-- reg: address and length of the register set for the MDIO interface
-- #size-cells: must be 1
-- #address-cells: must be 0
-
-Child nodes of this MDIO bus controller node are standard Ethernet PHY device
-nodes as described in Documentation/devicetree/bindings/net/phy.txt
-
-Example:
-
-mdio@18002000 {
-	compatible = "brcm,iproc-mdio";
-	reg = <0x18002000 0x8>;
-	#size-cells = <1>;
-	#address-cells = <0>;
-
-	enet-gphy@0 {
-		reg = <0>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/brcm,iproc-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,iproc-mdio.yaml
new file mode 100644
index 000000000000..3031395f7e6e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,iproc-mdio.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,iproc-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom iProc MDIO bus controller
+
+maintainers:
+  - Rafał Miłecki <rafal@milecki.pl>
+
+allOf:
+  - $ref: mdio.yaml#
+
+properties:
+  compatible:
+    const: brcm,iproc-mdio
+
+  reg:
+    maxItems: 1
+
+unevaluatedProperties: false
+
+required:
+  - reg
+
+examples:
+  - |
+    mdio@18002000 {
+        compatible = "brcm,iproc-mdio";
+        reg = <0x18002000 0x8>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            reg = <0>;
+        };
+    };
-- 
2.26.2

