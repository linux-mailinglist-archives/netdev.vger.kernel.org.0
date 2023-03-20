Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30C86C0FB6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCTKwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCTKvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:51:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1FB7D90;
        Mon, 20 Mar 2023 03:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BF7B80E13;
        Mon, 20 Mar 2023 10:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F12AC4339B;
        Mon, 20 Mar 2023 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679309288;
        bh=zg6KFoWKPsQYBqBkRYh2FlEcuFqO13EH3bpZOdx8gT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nt29mlK44yFQE+lT87r0zxUIDWOsU9nAlO81XL1N2Hz1l3INT+uelPInkkCxOx9iC
         D4Dnegf+cR6nj2Z6zwVaFqzR37Xt9nZNcyiz5gcwsv0Ju1aTa20Z3ry3gwzC5Z7d7B
         fFgspF1CWgeE8ugj7Tk1czjnGRSzjpNcQpWlRdeevUHf0exY/w9s15NEZ/1M1AvWwD
         Z2HhknuejnF9AR6b9ijBezlu1qXkX+jHv5/eaUjIqvDAY7FI7P5051BwAvSDdKjnHF
         YHpKvO82/eOsEfzKyG8E4eiiybcQo9zarHtJg/lTXdJ4FnvHaZ+uqFH8O/3Wu1QmR/
         C/eyyqeXc7U9g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peD4z-0005nV-22; Mon, 20 Mar 2023 11:49:29 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
Date:   Mon, 20 Mar 2023 11:46:56 +0100
Message-Id: <20230320104658.22186-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320104658.22186-1-johan+linaro@kernel.org>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
for which the calibration data variant may need to be described.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml

diff --git a/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
new file mode 100644
index 000000000000..df67013822c6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2023 Linaro Limited
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/pci17cb,1103.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies ath11k wireless devices (PCIe)
+
+maintainers:
+  - Kalle Valo <kvalo@kernel.org>
+
+description: |
+  Qualcomm Technologies IEEE 802.11ax PCIe devices.
+
+properties:
+  compatible:
+    enum:
+      - pci17cb,1103  # WCN6856
+
+  reg:
+    maxItems: 1
+
+  qcom,ath11k-calibration-variant:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: calibration data variant
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    pcie {
+        #address-cells = <3>;
+        #size-cells = <2>;
+
+        pcie@0 {
+            device_type = "pci";
+            reg = <0x0 0x0 0x0 0x0 0x0>;
+            #address-cells = <3>;
+            #size-cells = <2>;
+            ranges;
+
+            bus-range = <0x01 0xff>;
+
+            wifi@0 {
+                compatible = "pci17cb,1103";
+                reg = <0x10000 0x0 0x0 0x0 0x0>;
+
+                qcom,ath11k-calibration-variant = "LE_X13S";
+            };
+        };
+    };
-- 
2.39.2

