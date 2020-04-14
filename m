Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844E51A88E1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503635AbgDNSOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503622AbgDNSOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:14:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C894C061A10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:14:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a201so14928180wme.1
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rKEIBuodM54/jIsOflqk2y5mQUf0xeA0ySBI7eRUbbA=;
        b=op0QuF5o7KM2geCjMTJ9l2SXLIdI+tfmh0VqUaUn5gu7/Q979iv5Gr25yZJThV3/Wg
         2gj58yuEuT3HLa93eYIlFphRqiTpteGIWOR+/KM5tX2Rlbcw6FWK27kC7ounWe1M1CRH
         pwjBVYq3PnNKqCkrk9qwlrw1UlL1oQEaC8JyGAYKBtI2y7PBwHznOjVqrsoMKmskRNp8
         tJvirX/mDEevHIZwgzl+nio4PtPsdPJwjcYv2zNIRd/dyw8K3tvJjy5TP25soZ6snY7S
         dPrO44rNstJ2DzTVhertdW15zkWX2Sdw/ICjkadkTtCEsFtTEdD4GEC2sskh1JHCV4qp
         KqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rKEIBuodM54/jIsOflqk2y5mQUf0xeA0ySBI7eRUbbA=;
        b=oTtbLZXkBs7nLtpTDpipsgUJ6YCuBAdF6SS/e2+cRqa3B+TLHHBpkjb9P1AyKtWGP+
         GkzWSkVFafiGhong+eS6TFL3qhYrDGW889vgsUxzv9OQsRt317d32KJ4DZFRrHv1lS7H
         lWnwT4y+1wuT+AL7D3zJADS92WWY5k2wIGGMLZ0/J5U51FhxAQI+UUpE8Xvy1syp6Ukz
         nv8KCSUR5Yk2yPqEq2jjyYORS5YtcBG7CoY8uLd09OAwh+msHIIBasBvE7CSF1q0n20c
         CT+YLeZDM1VmvzadnoTommCZdRpPzpIFNdf8rYhJxCGR9Zi5yQX3EpKErGQXkhNlnzfv
         BYsw==
X-Gm-Message-State: AGi0PuZa68XKL11w0mUGZb9l9e+wdBzcwXOqvJNoBYVptdfuKfTnIyed
        kPn6ub97BFfLalR0l84m9AB2mw==
X-Google-Smtp-Source: APiQypKSOh+5deo6wcOrMT7bpCM+o1kPTCXNMnVPx6TFrYyM03oN+vSVOxcaV5uRzDdsNRb4azMBMg==
X-Received: by 2002:a7b:c250:: with SMTP id b16mr1143293wmj.100.1586888045816;
        Tue, 14 Apr 2020 11:14:05 -0700 (PDT)
Received: from localhost.localdomain (dh207-97-22.xnet.hr. [88.207.97.22])
        by smtp.googlemail.com with ESMTPSA id w12sm5387763wrk.56.2020.04.14.11.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:14:05 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH v2 2/3] dt-bindings: add Qualcomm IPQ4019 MDIO bindings
Date:   Tue, 14 Apr 2020 20:10:13 +0200
Message-Id: <20200414181012.114905-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200414181012.114905-1-robert.marko@sartura.hr>
References: <20200414181012.114905-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the binding document for the IPQ40xx MDIO driver.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
 .../bindings/net/qcom,ipq40xx-mdio.yaml       | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml
new file mode 100644
index 000000000000..3e2ccf417fb6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipq40xx-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm IPQ40xx MDIO Controller Device Tree Bindings
+
+maintainers:
+  - Robert Marko <robert.marko@sartura.hr>
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: qcom,ipq40xx-mdio
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+
+examples:
+  - |
+    mdio@90000 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "qcom,ipq40xx-mdio";
+      reg = <0x90000 0x64>;
+      status = "disabled";
+
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+      };
+
+      ethphy1: ethernet-phy@1 {
+        reg = <1>;
+      };
+
+      ethphy2: ethernet-phy@2 {
+        reg = <2>;
+      };
+
+      ethphy3: ethernet-phy@3 {
+        reg = <3>;
+      };
+
+      ethphy4: ethernet-phy@4 {
+        reg = <4>;
+      };
+    };
-- 
2.26.0

