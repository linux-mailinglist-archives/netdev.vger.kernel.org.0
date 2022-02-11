Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C313E4B1ECD
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 07:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347285AbiBKGuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 01:50:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiBKGus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 01:50:48 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7D42188;
        Thu, 10 Feb 2022 22:50:48 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id u16so8900880pfg.3;
        Thu, 10 Feb 2022 22:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u72dfCKcBsI5HUFp5Jc/vwPolSfcg3sgGPIgUu/1wC4=;
        b=Lfn64H74LGgVHU9Q/7XaBNXzNtQXlYSLtW/WPN8Nxri6GsQbtP++JoovWedYTUdmHf
         9NxLnt5NbHMln14KqHRUujVfh/w6O3yIVPI2lFaZdo2vdPNvWzz24Q9rrFkr401eNk/W
         AnQfIKxW4BBWoMa55muyqlthkgoG/cXYhktDtVebJZEjDQShacG/+1Zi2JyuM/1wJGW2
         IUAABw1OggYdxRnb6WtctGXYTXpgUzrFmXdB0oB93XPGgVpNLpsMVtN8WhNm13cHvHGv
         xm4nmrYa/6v6CXaZQFLoYroQfZqC8LBAXRgYilQol3DbLH03uhWiaNKhRlmxv127UOYz
         e9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u72dfCKcBsI5HUFp5Jc/vwPolSfcg3sgGPIgUu/1wC4=;
        b=hlpKmlI/Zo6+UHt9yAEvtiwLV+JIn9ZB/4q5arqrd31JfRsSVAzhGlA9jgMU5Hs+gd
         tryH+WWclSFFAYd6oTlVwAuupIeAmmwDcINBSZgdC09vx2235ESiQxMy2N6kUitEQcEb
         bfEamYfjuKM0hi1X8xlzKjiDWaG/UtxJMuq468lPicIGvdrWdgUXNgVE7O6BvPEORCpC
         e0rFVhGStL90vTpBinNoLkzHE9d1lhpX3UZtH7vckTRaFDAjJQNUbcfd92zCde8H6sYs
         98bm75mXjKK73Zm4b9GwNGyQREHYdDWab54Yc9PKNwWNbzaWYcaTqw51hrdWYSQlpLBN
         5WCA==
X-Gm-Message-State: AOAM53206P7trEeP769lgcke1gvxxNuyJMEbx5oezwd4YOYO4LP/FaSP
        ubM80OHofyRhtPZLEl2C8p4=
X-Google-Smtp-Source: ABdhPJzdf18izqshMYqmLIEstyJSCXTj+ih6WBFqQ2NZTlHykOs+Q6YuqMAHeacEI3B0VLG/4p93hA==
X-Received: by 2002:aa7:88c5:: with SMTP id k5mr363630pff.35.1644562247992;
        Thu, 10 Feb 2022 22:50:47 -0800 (PST)
Received: from localhost.localdomain (61-231-111-88.dynamic-ip.hinet.net. [61.231.111.88])
        by smtp.gmail.com with ESMTPSA id o1sm28171257pfu.88.2022.02.10.22.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 22:50:47 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v19, 1/2] dt-bindings: net: Add Davicom dm9051 SPI ethernet controller
Date:   Fri, 11 Feb 2022 14:50:03 +0800
Message-Id: <20220211065004.25444-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220211065004.25444-1-josright123@gmail.com>
References: <20220211065004.25444-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new yaml base data file for configure davicom dm9051 with
device tree

Signed-off-by: Joseph CHAMG <josright123@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
Cc: Rob Herring <robh@kernel.org>
 .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml

diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
new file mode 100644
index 000000000000..52e852fef753
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/davicom,dm9051.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Davicom DM9051 SPI Ethernet Controller
+
+maintainers:
+  - Joseph CHANG <josright123@gmail.com>
+
+description: |
+  The DM9051 is a fully integrated and cost-effective low pin count single
+  chip Fast Ethernet controller with a Serial Peripheral Interface (SPI).
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: davicom,dm9051
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 45000000
+
+  interrupts:
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  # Raspberry Pi platform
+  - |
+    /* for Raspberry Pi with pin control stuff for GPIO irq */
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "davicom,dm9051";
+            reg = <0>; /* spi chip select */
+            local-mac-address = [00 00 00 00 00 00];
+            interrupt-parent = <&gpio>;
+            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <31200000>;
+        };
+    };
-- 
2.20.1

