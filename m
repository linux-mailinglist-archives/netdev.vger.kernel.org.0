Return-Path: <netdev+bounces-1138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 854726FC51A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2A021C20B74
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3060B182C1;
	Tue,  9 May 2023 11:35:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED73182A9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:35:26 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82CF30FA;
	Tue,  9 May 2023 04:35:23 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f1411e8111so6438965e87.1;
        Tue, 09 May 2023 04:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683632122; x=1686224122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QQeh9YjZzNjrXQibFSAmN6bJH27K6sErXcLxHfNpn8=;
        b=Sam+crretoYBxWHA4qS3k5/sYy/9YNnNDeOcT/ax6idvKykJaCktFYNZ0iU6e8debI
         B8DvJGdp1lL3Q7x5zbpU5gXoSw53k9Ch9CLd1ox4Z0XpstyGRuMY0jd47E1L/eoeTtLi
         hyCkyvBViRBW90AOQReNZeqrscn3rogJXPMFlMm3HeRi7zJGYsvW5u0Dw7CtEC/mJGve
         RS0Mg6lh3GQw0reca5/4SrH/9HdIWYtkje+PabbVny0Z158fzPPjMkcwOHo3XQEG2cVA
         SjPjIPX5M11qNKaKPNIeqAQOvqo0H0DPctFCbD2iK5JPG0LYGFH5dl9SQTIcaJra+uYW
         qqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683632122; x=1686224122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QQeh9YjZzNjrXQibFSAmN6bJH27K6sErXcLxHfNpn8=;
        b=ijy5HsnaEpqmxkn3Dj9gujvKZgRgJgyaiPRqb6nqR3F4Uvr0AFvtVnDjx6hfMy4D4Q
         i8z/03YjsAxufRvHk+N5n0FR8YcbZ57s+TMsmdYC9pAnOQi3CPVEO8MYnruXlpWzyVGY
         B7miBDL1r2fgHrw3z4Xw8jEd1e6j1mu9Wlg784KBziixM2MijVfZyWvj/Ly95yrpwdag
         8JKGEvwOaYPlDpecZfOMiH3rRdr3Kiqtz6n+j+QsP+r3ylCm4NIuOsrsm7Bn+3UewbYV
         0bx+yy4l7lcE66buO8AkZVYCo/Arqb5s9Opeg6OsWYwifeD6Qk763ETcTG6MgLe6Vy2a
         woUQ==
X-Gm-Message-State: AC+VfDwqPbBJT06nYrZv1mmHd4bBdZ1oBh1nESqwW/+WRztSSCacR2+t
	1ro2cE58W4q95tRwO8FIyUo81In6RM7tVRb6
X-Google-Smtp-Source: ACHHUZ53BaQ3IWMDiSD/9ydEo3S9fenNHEm7zgrZw941KuYic4L3B4+t1YiwvBZYRXPaOZh79K0r7Q==
X-Received: by 2002:ac2:5623:0:b0:4eb:30f9:eed7 with SMTP id b3-20020ac25623000000b004eb30f9eed7mr824674lff.22.1683632122133;
        Tue, 09 May 2023 04:35:22 -0700 (PDT)
Received: from localhost.localdomain (93-80-66-133.broadband.corbina.ru. [93.80.66.133])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac24570000000b004f25ccac240sm108940lfm.74.2023.05.09.04.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 04:35:21 -0700 (PDT)
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	Ivan Mikhaylov <fr0st61te@gmail.com>
Subject: [PATCH v2 5/5] dt-bindings: net: ftgmac100: convert to yaml version from txt
Date: Tue,  9 May 2023 14:35:04 +0000
Message-Id: <20230509143504.30382-6-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509143504.30382-1-fr0st61te@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 .../bindings/net/faraday,ftgmac100.yaml       | 110 ++++++++++++++++++
 1 file changed, 110 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml

diff --git a/Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml b/Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml
new file mode 100644
index 000000000000..98cd142f74bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml
@@ -0,0 +1,110 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/faraday,ftgmac100.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Faraday Technology FTGMAC100 gigabit ethernet controller
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Po-Yu Chuang <ratbert@faraday-tech.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: faraday,ftgmac100
+      - items:
+          - enum:
+              - aspeed,ast2400-mac
+              - aspeed,ast2500-mac
+              - aspeed,ast2600-mac
+          - const: faraday,ftgmac100
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    description: |
+      In accordance with the generic clock bindings. Must describe the MAC
+      IP clock, and optionally an RMII RCLK gate for the AST2500/AST2600. The
+      required MAC clock must be the first cell.
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    items:
+      - enum:
+          - MACCLK
+          - RCLK
+
+  phy-mode:
+    enum:
+      - rgmii
+      - rmii
+
+  phy-handle: true
+
+  use-ncsi:
+    description: |
+      Use the NC-SI stack instead of an MDIO PHY. Currently assumes
+      rmii (100bT) but kept as a separate property in case NC-SI grows support
+      for a gigabit link.
+    type: boolean
+
+  no-hw-checksum:
+    description: |
+      Used to disable HW checksum support. Here for backward
+      compatibility as the driver now should have correct defaults based on
+      the SoC.
+    type: boolean
+
+  mac-address-increment:
+    description: |
+      Increment the MAC address taken by GMA command via  NC-SI. Specifies
+      a signed number to be added to the host MAC address as obtained by
+      the OEM GMA command. If not specified, 1 is used by default for
+      Broadcom and Intel network cards, 0 otherwise.
+
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mac0: ethernet@1e660000 {
+        compatible = "aspeed,ast2500-mac", "faraday,ftgmac100";
+        reg = <0x1e660000 0x180>;
+        interrupts = <2>;
+        use-ncsi;
+    };
+
+    mac1: ethernet@1e680000 {
+        compatible = "aspeed,ast2500-mac", "faraday,ftgmac100";
+        reg = <0x1e680000 0x180>;
+        interrupts = <2>;
+
+        phy-handle = <&phy>;
+        phy-mode = "rgmii";
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            phy: ethernet-phy@1 {
+                compatible = "ethernet-phy-ieee802.3-c22";
+                reg = <1>;
+            };
+        };
+    };
-- 
2.40.1


