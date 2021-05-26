Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC439194E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhEZN5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhEZN5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B20AC06138D
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:02 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c20so2628027ejm.3
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o0MVqFruU6aPtwc2tbsO0idX94GaaF33HpLypJmzPKQ=;
        b=IkWH6+a81QAFnTAJl7aAF468bg+9AMNfuDagYkmAEPYE/YJWxTloB5NNGdALVyTInO
         Y/WPoHHnJAOngaOWYNr/SM9w61bebz2l1x9hCL3CZNlchQG4XigIkt6OmjTQLnfkDrZi
         raqYYKhLQY4Qo9ftRjxa3v7h5U10XyOBXDsKwCGTjbTmVxZ4A/eXwjxgFV5K8Nl73YJ7
         FCmlZPqOs5F5++Ps2XJCXsnMEPiUVt5AY2/Hxs/Vc37HkCI44TfAhiC08u6s80j4vuwP
         Fw38oRcj+cCqYmqdpEgz73FwNvL1Xu3sO9iViEoT7Rh7r57g+ldA6/OkzT7Dybjvqyu2
         A5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o0MVqFruU6aPtwc2tbsO0idX94GaaF33HpLypJmzPKQ=;
        b=CrHaEx/jmSbrUstWxKNp+IR2drPjTLibF8eaYe0e3zESLk3dY6ExEs7Z3ufIROjQnV
         T81227peGWsAk33+JHp41mztfhuC+cMpdKvT6w+NHPIgHwPtAXT0FRFUTRrQxj2bcmjr
         9BpyqlLM2JEZqgD26ztx75w3QFM8MRrJgZ3Nvhz/YRkfrqctXHKy/D5oNfPSOo0MtCHt
         ESl8sDmQNOBLr0m8JlVN8tBc/+kOcQ/Vcfpqs+NI85Ql7LUw8VZZsitt1rwc3m0qEnHb
         SLySsvYPzvGGz7ken7Zx6YCplskoVp+wJweb1DLOpx7NjQMCzUegF4p48tliZYNiCq6N
         WvDg==
X-Gm-Message-State: AOAM533kIck9c3uqp+C5Y8fWQBqAKhZNv5ht4oT3YXhNT/oRcpqrJt8Q
        5+RGqRNox4Z2Wl/omGxMedI=
X-Google-Smtp-Source: ABdhPJxPXrPpgDNs49bM+uMKjudVqSc0WsvBrUkVKeiVSue46nx0EyuTUB4t2iZ+LpyYvRfQWLyjJg==
X-Received: by 2002:a17:906:fa93:: with SMTP id lt19mr33874630ejb.14.1622037361251;
        Wed, 26 May 2021 06:56:01 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:56:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [RFC PATCH v2 linux-next 10/14] dt-bindings: net: dsa: sja1105: add SJA1110 bindings
Date:   Wed, 26 May 2021 16:55:31 +0300
Message-Id: <20210526135535.2515123-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 4 variations of the SJA1110 switch which have a different set
of MII protocols supported per port. Document the compatible strings.

Also, the SJA1110 optionally supports 2 internal MDIO buses for 2
different types of Ethernet PHYs. Document a container node called
"mdios" which has 2 subnodes "mdio@0" and "mdio@1", identifiable via
compatible string, under which the driver finds the internal PHYs.

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 .../bindings/net/dsa/nxp,sja1105.yaml         | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index c1f18849a54a..640da65b0f59 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -28,10 +28,53 @@ properties:
           - nxp,sja1105q
           - nxp,sja1105r
           - nxp,sja1105s
+          - nxp,sja1110a
+          - nxp,sja1110b
+          - nxp,sja1110c
+          - nxp,sja1110d
 
   reg:
     maxItems: 1
 
+  # Optional container node for the 2 internal MDIO buses of the SJA1110
+  # (one for the internal 100base-T1 PHYs and the other for the single
+  # 100base-TX PHY). The "reg" property does not have physical significance.
+  # The PHY addresses to port correspondence is as follows: for 100base-T1,
+  # port 5 has PHY 1, port 6 has PHY 2 etc, while for 100base-TX, port 1 has
+  # PHY 1.
+  mdios:
+    type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^mdio@[0-1]$":
+        type: object
+
+        allOf:
+          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
+
+        properties:
+          compatible:
+            oneOf:
+              - enum:
+                  - nxp,sja1110-base-t1-mdio
+                  - nxp,sja1110-base-tx-mdio
+
+          reg:
+            oneOf:
+              - enum:
+                - 0
+                - 1
+
+        required:
+          - compatible
+          - reg
+
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
-- 
2.25.1

