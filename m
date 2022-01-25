Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C620F49BAE1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbiAYSDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357905AbiAYSBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:01:25 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89BBC061747;
        Tue, 25 Jan 2022 10:01:23 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b9so9240222lfq.6;
        Tue, 25 Jan 2022 10:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBYYHHcrj5iWKbV8iDsJjMg/wgtciWUkHYCjJmxtXi8=;
        b=YkDBRgLMrF9XmbvguP6Y67CU9AL6lAUs1LjxUejM3fh1klFFdQ4llHjpsv3eZoeYCl
         f2haVwMHPJcD5Tq0jvJgg8Z4OFcwPba1zlEgDEPe3Xe4L5KilTwWXTgjMJ5iykCmNxhz
         ZPzGnDFtsNMQ5GPzlsyeZUjOg3lnXXuIfXgXrwBemVyRt2zbT4MBUQzPMSdRn4htoGmg
         bUcSyI+rtGmoXo7E3JUE7+8coQEUHQB5oQpnl1zuCgC3EIPiMJgoDSmJLomtGwKPTAiv
         c9s3o37yEN7k5M35blvDgbVMtyEH7gSuIUU6QtTkZFu6Ih4Scs6iArWGeU1HmATokRYV
         TSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBYYHHcrj5iWKbV8iDsJjMg/wgtciWUkHYCjJmxtXi8=;
        b=A21dXoMRV+oml8L1SqNuBff7EIwfxj3pI/edVc3Rwrd6wsVRDv2/xOjTcNgJrtGHeF
         YdKSirwEw7Vr65PSPLDJ0btKX5A3pFbMTL/foYTrXaqfYYGYIz8lENRtfU2H3RY4b1j3
         tf8hURY3h27c8hXVSGApwooFIU9DhqsHH7B+iNyBdIyWTencXmzWeQkGUMazF44O3r5+
         iJhV/wGQ7+pMSrfXaFO+I7PU7QLFYPIejvO0U0LMEDTgVsb0GVipEY7PPi6G3sGQ33VH
         GzhrGuR6rcKoJteUzpQwMdhrdETt3Gn5ihoXz4s3JxKMq5LB91J6LYvb0wdfzNeIVto7
         JI0A==
X-Gm-Message-State: AOAM5321VV710eZL24kLet04tK+hq53aZ+3gEjaIOuVzN04h5DQDxq80
        FoIQD5JswzOGU+ga81yJMRo=
X-Google-Smtp-Source: ABdhPJxEvKovHTQ3+tJlg+4T9j7URvdFNBsGv3zx6ejSUbnCIMZnkAFxMSkZrL3+wPSy2sYnU3HtSg==
X-Received: by 2002:a05:6512:3f84:: with SMTP id x4mr17279303lfa.486.1643133681974;
        Tue, 25 Jan 2022 10:01:21 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id z24sm1149121lfb.206.2022.01.25.10.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:01:21 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] dt-bindings: nvmem: extract NVMEM cell to separated file
Date:   Tue, 25 Jan 2022 19:01:13 +0100
Message-Id: <20220125180114.12286-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125180114.12286-1-zajec5@gmail.com>
References: <20220125180114.12286-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This will allow adding binding for more specific cells and reusing
(sharing) common code.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../devicetree/bindings/nvmem/cells/cell.yaml | 35 +++++++++++++++++++
 .../devicetree/bindings/nvmem/nvmem.yaml      | 25 ++-----------
 2 files changed, 37 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/nvmem/cells/cell.yaml

diff --git a/Documentation/devicetree/bindings/nvmem/cells/cell.yaml b/Documentation/devicetree/bindings/nvmem/cells/cell.yaml
new file mode 100644
index 000000000000..5d62d0c8f1e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/cells/cell.yaml
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/cells/cell.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVMEM cell
+
+maintainers:
+  - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+
+description: NVMEM cell is a data entry of NVMEM device.
+
+properties:
+  reg:
+    maxItems: 1
+    description:
+      Offset and size in bytes within the storage device.
+
+  bits:
+    maxItems: 1
+    items:
+      items:
+        - minimum: 0
+          maximum: 7
+          description:
+            Offset in bit within the address range specified by reg.
+        - minimum: 1
+          description:
+            Size in bit within the address range specified by reg.
+
+required:
+  - reg
+
+additionalProperties: true
diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.yaml b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
index 456fb808100a..6b075c1db446 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
@@ -40,29 +40,8 @@ properties:
     maxItems: 1
 
 patternProperties:
-  "@[0-9a-f]+(,[0-7])?$":
-    type: object
-
-    properties:
-      reg:
-        maxItems: 1
-        description:
-          Offset and size in bytes within the storage device.
-
-      bits:
-        maxItems: 1
-        items:
-          items:
-            - minimum: 0
-              maximum: 7
-              description:
-                Offset in bit within the address range specified by reg.
-            - minimum: 1
-              description:
-                Size in bit within the address range specified by reg.
-
-    required:
-      - reg
+  "@[0-9a-f]+$":
+    $ref: cells/cell.yaml#
 
 additionalProperties: true
 
-- 
2.31.1

