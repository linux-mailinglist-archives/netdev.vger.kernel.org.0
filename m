Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1C174225
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgB1WmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:42:19 -0500
Received: from mail-yw1-f51.google.com ([209.85.161.51]:42263 "EHLO
        mail-yw1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgB1WmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:42:15 -0500
Received: by mail-yw1-f51.google.com with SMTP id n127so4915453ywd.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HtBzbHspY1ceZ7S67aMewQoXLRoYH4pgWqbzOtj2eMg=;
        b=mj9hwy6Mti/O7HjLER8byZFrS6mQPnULSPL+IsIJxNascr6MeZ5AB2qGRvjTefcMSZ
         18R+SgT30GwZ4bOD9f6h70qzWgSQCpyOJ1Ci0My6NpF1PeK2sfuFOy+L26Iw2u5iykZJ
         KUzFFkDOWzlmjCiLA8XjW0Dce9a+dMruT4IBdgosALThxkL4scOOGUmJzoWLDxcgbWJZ
         n7rgrKbZgKI1lcQu/rT9rtJZdvFFb7c/B4Fh8szXwhGefieXISiFbmdPyCBqIG54/bq0
         KVsyA1NYzN1F/Uk9gB55Zyz6J0nzGYY3aPVCzxClV/ed0Ay2Q0ImXNNaqnf6mpJaWI9x
         9v3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HtBzbHspY1ceZ7S67aMewQoXLRoYH4pgWqbzOtj2eMg=;
        b=tMTq4kN6n/E+aDtRv4oqI8VS9S+6AUo14ZIpuvJTN+okf490M7J7HzK/SZvZ6L1w0J
         LeLVBbJ3NLv+O7w/QK/pghdi5UGHSgFu67M7ur3pvDX/63HmKZX6znlYpCiD3JMTiVvP
         CNkgosH/Y8pcJPC52SOS2FVlIS58hRiZjeIYZgRQUK6rN4llKa4D6Gv/ESZFecLE2Uyh
         xz2gipIS7RCND32AqlGfhqHShE+AglM/8Dmwqp4HJaY+ii+z3YcPizlT5Ok18QO6C2UF
         2D9KTH1mBqU9R10i+bNdBY5KhYAahY5AL5B8D7x2YIDWpa+SEms8PLqdpb+6L5A5bO1R
         tr2w==
X-Gm-Message-State: APjAAAVEipgSpSI5nwQyGp1gkYCc0AJOhm7/6sekReLzDT+GPM/46Iov
        B+LAgHHJQLll09krXqY2cMOPuQ==
X-Google-Smtp-Source: APXvYqz1pRiPHzLlLz3CG+TFCb/qvF248lOfBZnJVqUl3hArx6azdJ7lWy0mw/HNLBIzcvfQJDUZhg==
X-Received: by 2002:a0d:d64d:: with SMTP id y74mr6951357ywd.386.1582929733568;
        Fri, 28 Feb 2020 14:42:13 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d188sm4637830ywe.50.2020.02.28.14.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:42:13 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>
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
Subject: [PATCH 02/17] dt-bindings: soc: qcom: add IPA bindings
Date:   Fri, 28 Feb 2020 16:41:49 -0600
Message-Id: <20200228224204.17746-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228224204.17746-1-elder@linaro.org>
References: <20200228224204.17746-1-elder@linaro.org>
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

 NOTE:	Rob, you signed off on this last year.  I made a single
	change to it (which you suggested):  the license is now
	dual GPL 2.0/BSD 2-clause.  If you have any objection to
	including your sign-off please say so.

					-Alex

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

