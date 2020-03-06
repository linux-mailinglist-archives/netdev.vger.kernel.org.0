Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933BA17B56F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 05:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgCFE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 23:28:43 -0500
Received: from mail-yw1-f52.google.com ([209.85.161.52]:39602 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgCFE2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 23:28:41 -0500
Received: by mail-yw1-f52.google.com with SMTP id x184so1086609ywd.6
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 20:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gni/ERHExthWFIsP0a9AZaLKXwZ4DtsmIHrkv9FFJ/g=;
        b=ZZjQOHHHvLICFVdbvoNSiFBKx37ccWUkVp8E7u7hZUHeAgrEwRM8a7OZ3VqGESKyJZ
         eNcs1UdwYGVWYf819xIMYG/5M4h13AIG1pm0QXnNtvWIyqRDkjGLz0YnKjQHju3m/dK/
         s/kMR/NAlCIQ4mcYqlUSDlwqDAvBjR7w5zCx9wVXjzjAf3uNCDPUWhhxidZk67jgyOLZ
         rtx3gKcqV10GZ1Aw1BNI0nldNBZ2siXJUggL9DmPqGZj8ldeS3vrNykaDkjO1C7oaOaT
         PLGIDmzGKK5l6j0vekm9eywyfN9+JFlZlHDv7C4MGDAvWgeNk2i+xWnw/52UpRgivWsD
         MIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gni/ERHExthWFIsP0a9AZaLKXwZ4DtsmIHrkv9FFJ/g=;
        b=EkkeQF5/WKeEe2POTQxJovervydFZHIPLNm59uSc6gHA9vd9lgHtwCmN/C1Qq7tmld
         8S8x+Z/Ofm52r9SOMrDcHGsnMcZv+d2Lu9HxSSwV0jS6F4KC1yInTJS/59UdsPLNQMhR
         aj6ORxgZrAXTHsGwWBXOt4D8NzH/Pe0m7Ij/UQMXNQ0MBrcEDpGUJksev9mgRnY19fi/
         cuv+1RcyqUiNLzUBD/WMkHSNoiNiYRw1Lphly/NOJccfB7rdWe8csuTs0fLIrsigobn5
         2yKyx5ksCviAL4DHuCpvvu1P9wgTcvPk7AT4UYzB6aBlI/xXcTjczmsYiYKyjAOB34mb
         W6kA==
X-Gm-Message-State: ANhLgQ2G/f7AsEwpaNawAUyGt0djHRivftpmaR62elPbFWrLvc9aJsS6
        ojND8h2TjYnjwpr/FLiDKZebKg==
X-Google-Smtp-Source: ADFU+vvu6D2F+M9U3eMejzYO8QeU2OrRUzjgwjL3w7ZbTZBDoypIRluNrk+/A27q1TeOnSEExFIZQg==
X-Received: by 2002:a81:3944:: with SMTP id g65mr2047976ywa.169.1583468920290;
        Thu, 05 Mar 2020 20:28:40 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm12581836ywa.32.2020.03.05.20.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 20:28:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v2 02/17] dt-bindings: soc: qcom: add IPA bindings
Date:   Thu,  5 Mar 2020 22:28:16 -0600
Message-Id: <20200306042831.17827-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
References: <20200306042831.17827-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the binding definitions for the "qcom,ipa" device tree node.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/qcom,ipa.yaml     | 192 ++++++++++++++++++
 1 file changed, 192 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipa.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
new file mode 100644
index 000000000000..91d08f2c7791
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -0,0 +1,192 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipa.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm IP Accelerator (IPA)
+
+maintainers:
+  - Alex Elder <elder@kernel.org>
+
+description:
+  This binding describes the Qualcomm IPA.  The IPA is capable of offloading
+  certain network processing tasks (e.g. filtering, routing, and NAT) from
+  the main processor.
+
+  The IPA sits between multiple independent "execution environments,"
+  including the Application Processor (AP) and the modem.  The IPA presents
+  a Generic Software Interface (GSI) to each execution environment.
+  The GSI is an integral part of the IPA, but it is logically isolated
+  and has a distinct interrupt and a separately-defined address space.
+
+  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.
+
+  - |
+    --------             ---------
+    |      |             |       |
+    |  AP  +<---.   .----+ Modem |
+    |      +--. |   | .->+       |
+    |      |  | |   | |  |       |
+    --------  | |   | |  ---------
+              v |   v |
+            --+-+---+-+--
+            |    GSI    |
+            |-----------|
+            |           |
+            |    IPA    |
+            |           |
+            -------------
+
+properties:
+  compatible:
+      const: "qcom,sdm845-ipa"
+
+  reg:
+    items:
+      - description: IPA registers
+      - description: IPA shared memory
+      - description: GSI registers
+
+  reg-names:
+    items:
+      - const: ipa-reg
+      - const: ipa-shared
+      - const: gsi
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+      const: core
+
+  interrupts:
+    items:
+      - description: IPA interrupt (hardware IRQ)
+      - description: GSI interrupt (hardware IRQ)
+      - description: Modem clock query interrupt (smp2p interrupt)
+      - description: Modem setup ready interrupt (smp2p interrupt)
+
+  interrupt-names:
+    items:
+      - const: ipa
+      - const: gsi
+      - const: ipa-clock-query
+      - const: ipa-setup-ready
+
+  interconnects:
+    items:
+      - description: Interconnect path between IPA and main memory
+      - description: Interconnect path between IPA and internal memory
+      - description: Interconnect path between IPA and the AP subsystem
+
+  interconnect-names:
+    items:
+      - const: memory
+      - const: imem
+      - const: config
+
+  qcom,smem-states:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description: State bits used in by the AP to signal the modem.
+    items:
+    - description: Whether the "ipa-clock-enabled" state bit is valid
+    - description: Whether the IPA clock is enabled (if valid)
+
+  qcom,smem-state-names:
+    $ref: /schemas/types.yaml#/definitions/string-array
+    description: The names of the state bits used for SMP2P output
+    items:
+      - const: ipa-clock-enabled-valid
+      - const: ipa-clock-enabled
+
+  modem-init:
+    type: boolean
+    description:
+      If present, it indicates that the modem is responsible for
+      performing early IPA initialization, including loading and
+      validating firwmare used by the GSI.
+
+  modem-remoteproc:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      This defines the phandle to the remoteproc node representing
+      the modem subsystem.  This is requied so the IPA driver can
+      receive and act on notifications of modem up/down events.
+
+  memory-region:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 1
+    description:
+      If present, a phandle for a reserved memory area that holds
+      the firmware passed to Trust Zone for authentication.  Required
+      when Trust Zone (not the modem) performs early initialization.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+  - interconnects
+  - qcom,smem-states
+  - modem-remoteproc
+
+oneOf:
+  - required:
+    - modem-init
+  - required:
+    - memory-region
+
+examples:
+  - |
+        smp2p-mpss {
+                compatible = "qcom,smp2p";
+                ipa_smp2p_out: ipa-ap-to-modem {
+                        qcom,entry-name = "ipa";
+                        #qcom,smem-state-cells = <1>;
+                };
+
+                ipa_smp2p_in: ipa-modem-to-ap {
+                        qcom,entry-name = "ipa";
+                        interrupt-controller;
+                        #interrupt-cells = <2>;
+                };
+        };
+        ipa@1e40000 {
+                compatible = "qcom,sdm845-ipa";
+
+                modem-init;
+                modem-remoteproc = <&mss_pil>;
+
+                reg = <0 0x1e40000 0 0x7000>,
+                        <0 0x1e47000 0 0x2000>,
+                        <0 0x1e04000 0 0x2c000>;
+                reg-names = "ipa-reg",
+                                "ipa-shared";
+                                "gsi";
+
+                interrupts-extended = <&intc 0 311 IRQ_TYPE_EDGE_RISING>,
+                                        <&intc 0 432 IRQ_TYPE_LEVEL_HIGH>,
+                                        <&ipa_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
+                                        <&ipa_smp2p_in 1 IRQ_TYPE_EDGE_RISING>;
+                interrupt-names = "ipa",
+                                        "gsi",
+                                        "ipa-clock-query",
+                                        "ipa-setup-ready";
+
+                clocks = <&rpmhcc RPMH_IPA_CLK>;
+                clock-names = "core";
+
+                interconnects =
+                        <&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_EBI1>,
+                        <&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_IMEM>,
+                        <&rsc_hlos MASTER_APPSS_PROC &rsc_hlos SLAVE_IPA_CFG>;
+                interconnect-names = "memory",
+                                        "imem",
+                                        "config";
+
+                qcom,smem-states = <&ipa_smp2p_out 0>,
+                                        <&ipa_smp2p_out 1>;
+                qcom,smem-state-names = "ipa-clock-enabled-valid",
+                                        "ipa-clock-enabled";
+        };
-- 
2.20.1

