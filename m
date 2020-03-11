Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB3818242F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgCKVrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:47:08 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41355 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbgCKVrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:47:08 -0400
Received: by mail-yw1-f65.google.com with SMTP id p124so3554315ywc.8
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 14:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AYTqu7o88DhiQCN4tNkQrXf0r9/tf9NCCJPXItwuqG0=;
        b=Ngnn9tY0dNnZN3nx9YvjEIWeBi8S2tWsNnj6rddIzFEA7Pdc0YM+0/mn7AgMx2HzaM
         vH+fK37OmyXoLOzYM0c0QBYbMydrSYfkjzL7zyLKZKbSWxciXJXu4X69DEYa1xoBA1kI
         zXZ/ltNeG0iSFUUR1yOiawNUwcfxT+JtZRH38OsizyvJcFnaaoWsMDDoUfblTFlTkXxZ
         djGsqYjvvGUOwWZ0+elKdmtWF+YWQCCl/7I/lVEsPie5q0nWXmMmqVBhaHCwsp59k/wf
         ccFmBsQo4tO9gLMOLsi+Y8+DIWEy/uX/7WJC1k8Am6IvmNmV8Z55+1SPIZLjdeul1o20
         3EQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AYTqu7o88DhiQCN4tNkQrXf0r9/tf9NCCJPXItwuqG0=;
        b=IhVP01CvsK/mwZRvu16F1EUf0PjiEhuypBIe3LR4K3P1nP954Eo1NTgi29aBCJukBg
         J1mBHE+M/ZC1EoE0zxGRBg+m3Viue5v3ejBw+voyoR+VBE3P5kxTrKaShJW+BaZP0f7L
         MfVPRmDxd4dutpOXmX3V/vZCHKhXnCr6N1dCVjG0Ql2oziYmquLtmqHUYH8e7WPHHszs
         1M902mQkSVT1Zn1oPlIjwNnZZAG7siImmxZRAeHkhB/eeBz7AidYc5oACm9USn0S6Leh
         fDZABvdYtgkiADf1GmO3aK2K5rzQ7qKInWZog+N//35IYGoHMw7Mn2lPwuqZJP1tPEwZ
         GKwA==
X-Gm-Message-State: ANhLgQ0zJZFC+sUDHHtXK4X80RAbMy8pYEAQcUamY8HHxYy+gjxsn0w9
        j1VH3Ce6fIWy+hLJzPnLY+6/mA==
X-Google-Smtp-Source: ADFU+vvzcODWsXeejF0XDQuX8AJzozF15nlzc98C1kAuaKrLgndz7qyCgTRl1U+b0E9iTGo8BTSQKw==
X-Received: by 2002:a25:2688:: with SMTP id m130mr5423645ybm.408.1583963225161;
        Wed, 11 Mar 2020 14:47:05 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h139sm21100965ywa.35.2020.03.11.14.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 14:47:04 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: soc: qcom: fix IPA binding
Date:   Wed, 11 Mar 2020 16:47:00 -0500
Message-Id: <20200311214700.700-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definitions for the "qcom,smem-states" and "qcom,smem-state-names"
properties need to list their "$ref" under an "allOf" keyword.

In addition, fix two problems in the example at the end:
  - Use #include for header files that define needed symbolic values
  - Terminate the line that includes the "ipa-shared" register space
    name with a comma rather than a semicolon

Finally, update some white space in the example for better alignment.

Signed-off-by: Alex Elder <elder@linaro.org>
---

The IPA driver (including "qcom,ipa.yaml") landed in the net-next
tree last week, so this patch is built upon that.  This probably
means this patch should be taken through net-next as well, but
I'll leave that to the maintainers to work out.

					-Alex

 .../devicetree/bindings/net/qcom,ipa.yaml     | 32 +++++++++++--------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 91d08f2c7791..140f15245654 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -87,14 +87,16 @@ properties:
       - const: config
 
   qcom,smem-states:
-    $ref: /schemas/types.yaml#/definitions/phandle-array
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/phandle-array
     description: State bits used in by the AP to signal the modem.
     items:
     - description: Whether the "ipa-clock-enabled" state bit is valid
     - description: Whether the IPA clock is enabled (if valid)
 
   qcom,smem-state-names:
-    $ref: /schemas/types.yaml#/definitions/string-array
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/string-array
     description: The names of the state bits used for SMP2P output
     items:
       - const: ipa-clock-enabled-valid
@@ -139,6 +141,10 @@ oneOf:
 
 examples:
   - |
+        #include <dt-bindings/interrupt-controller/irq.h>
+        #include <dt-bindings/clock/qcom,rpmh.h>
+        #include <dt-bindings/interconnect/qcom,sdm845.h>
+
         smp2p-mpss {
                 compatible = "qcom,smp2p";
                 ipa_smp2p_out: ipa-ap-to-modem {
@@ -162,17 +168,17 @@ examples:
                         <0 0x1e47000 0 0x2000>,
                         <0 0x1e04000 0 0x2c000>;
                 reg-names = "ipa-reg",
-                                "ipa-shared";
-                                "gsi";
+                            "ipa-shared",
+                            "gsi";
 
                 interrupts-extended = <&intc 0 311 IRQ_TYPE_EDGE_RISING>,
-                                        <&intc 0 432 IRQ_TYPE_LEVEL_HIGH>,
-                                        <&ipa_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
-                                        <&ipa_smp2p_in 1 IRQ_TYPE_EDGE_RISING>;
+                                      <&intc 0 432 IRQ_TYPE_LEVEL_HIGH>,
+                                      <&ipa_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
+                                      <&ipa_smp2p_in 1 IRQ_TYPE_EDGE_RISING>;
                 interrupt-names = "ipa",
-                                        "gsi",
-                                        "ipa-clock-query",
-                                        "ipa-setup-ready";
+                                  "gsi",
+                                  "ipa-clock-query",
+                                  "ipa-setup-ready";
 
                 clocks = <&rpmhcc RPMH_IPA_CLK>;
                 clock-names = "core";
@@ -182,11 +188,11 @@ examples:
                         <&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_IMEM>,
                         <&rsc_hlos MASTER_APPSS_PROC &rsc_hlos SLAVE_IPA_CFG>;
                 interconnect-names = "memory",
-                                        "imem",
-                                        "config";
+                                     "imem",
+                                     "config";
 
                 qcom,smem-states = <&ipa_smp2p_out 0>,
-                                        <&ipa_smp2p_out 1>;
+                                   <&ipa_smp2p_out 1>;
                 qcom,smem-state-names = "ipa-clock-enabled-valid",
                                         "ipa-clock-enabled";
         };
-- 
2.20.1

