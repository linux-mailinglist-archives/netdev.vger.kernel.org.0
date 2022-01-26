Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C864049C407
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbiAZHH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbiAZHHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:07:55 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F36C061744;
        Tue, 25 Jan 2022 23:07:54 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id e9so7896360ljq.1;
        Tue, 25 Jan 2022 23:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5PfYCVcr1In8W9+MgZIF3icYx9fo+vY33A1S1gqsP34=;
        b=n42hCN/HYREN+SnwV2Pnhw036LJMATzNeFmmCSTpPlPLVZP+xX/SiBljHM+4/HQLCX
         cg5nyQZ+DfVwXaOwyZD305PfQyWsPViZiXvJ0RsA3VfNkS2P9VPkRVV1RUQIHfNxxIjJ
         t1Bl+NcHbBo8vSFaNrZlqzPW849DR+X5smwiKgGq6G6Xw18osN5AkH9XXaKvdtB8MToj
         njnhh9sJ3mfRxa/0tPC6AsKUfEBpm6yilKDaIMG0JAjlEsoQ0d683oOeNMQAr7uxssWa
         xiLj0LLPA2OkGot+jljqWodIyT3vjuWoY04DUrx47em876KalbN8JbQV0IKLz6GZfPlc
         oPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5PfYCVcr1In8W9+MgZIF3icYx9fo+vY33A1S1gqsP34=;
        b=4EtiHywJHh4IA3oZ8b9XPFmJmMHeb7jo23hJcu/4XoH+ShntkiNnXce1EiVHUlHlmE
         G2QvWbgzZdSScIAqE2dTaCkszJA6Fx6tyQvLm+YthcxVzDTH34DVIHjsns8WHYTq+DEz
         pzm3jT81sYtJi7bpnsjxvt8yjJUIpGONnqgFg9tfrNIsGDBKUMEjYN2WZVKF3RkAtf3k
         1/FXT4xzNf6zObK4LVuk6StITrWGmQUa5i14PkcImAU7MnROEM/5K48NXh1nDAGLLN8C
         FSlNVU16wKFqlbQ/8VQOBmDjL8YdvpyHrcdOKNy+EXLHev8SKgrQMfuRIXYXS3yDNU8w
         5etQ==
X-Gm-Message-State: AOAM530IORawBtWsmXI6PjMPoFS5msWNUVh2h30OkCw/brcdMrVry7ch
        +tbzFUErRn4+gZLtY2/Y/Vg=
X-Google-Smtp-Source: ABdhPJz/pMWKdr30TUV8F5L8mcYQkfbr49L33tXc0XYI5XxtaBk2w0Bnf6pcTZlX0EVFBGP1mrPOBQ==
X-Received: by 2002:a05:651c:93:: with SMTP id 19mr5357663ljq.175.1643180873008;
        Tue, 25 Jan 2022 23:07:53 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b39sm1465764ljr.88.2022.01.25.23.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:07:52 -0800 (PST)
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
Subject: [PATCH REBASED 1/2] dt-bindings: nvmem: extract NVMEM cell to separated file
Date:   Wed, 26 Jan 2022 08:07:44 +0100
Message-Id: <20220126070745.32305-1-zajec5@gmail.com>
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
 .../devicetree/bindings/nvmem/cells/cell.yaml | 34 +++++++++++++++++++
 .../devicetree/bindings/nvmem/nvmem.yaml      | 22 +-----------
 2 files changed, 35 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/nvmem/cells/cell.yaml

diff --git a/Documentation/devicetree/bindings/nvmem/cells/cell.yaml b/Documentation/devicetree/bindings/nvmem/cells/cell.yaml
new file mode 100644
index 000000000000..adfc2e639f43
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/cells/cell.yaml
@@ -0,0 +1,34 @@
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
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    items:
+      - minimum: 0
+        maximum: 7
+        description:
+          Offset in bit within the address range specified by reg.
+      - minimum: 1
+        description:
+          Size in bit within the address range specified by reg.
+
+required:
+  - reg
+
+additionalProperties: true
diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.yaml b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
index 43ed7e32e5ac..b79b51e98ee8 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
@@ -41,27 +41,7 @@ properties:
 
 patternProperties:
   "@[0-9a-f]+(,[0-7])?$":
-    type: object
-
-    properties:
-      reg:
-        maxItems: 1
-        description:
-          Offset and size in bytes within the storage device.
-
-      bits:
-        $ref: /schemas/types.yaml#/definitions/uint32-array
-        items:
-          - minimum: 0
-            maximum: 7
-            description:
-              Offset in bit within the address range specified by reg.
-          - minimum: 1
-            description:
-              Size in bit within the address range specified by reg.
-
-    required:
-      - reg
+    $ref: cells/cell.yaml#
 
 additionalProperties: true
 
-- 
2.31.1

