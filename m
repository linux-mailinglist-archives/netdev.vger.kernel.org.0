Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D006D3E3988
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 09:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhHHHyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 03:54:18 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:10710 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhHHHyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 03:54:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628409239; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=/89OpH7bCsRBSg7PGY3QGk97FxRsWj/9fRV0YEJiKD0=; b=tTfnXQ3EAwXydmtuJpDWcElBAF9ei7s8Lj4F+UGN1sYMefUmUvAi/ukoJdxjr17pKG21St6r
 2JZXt94StToOhczi0NMgZOMEbTUf5HW9VZLdgKaLoheDTpVHh1fo6KXI5qoZiWyR9ScVwjiS
 CxxMUXAh+nVKcTBfOdG5hLWtfUs=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 610f8d86b14e7e2ecb7f884c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Aug 2021 07:53:42
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57222C4323A; Sun,  8 Aug 2021 07:53:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C7C76C433F1;
        Sun,  8 Aug 2021 07:53:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C7C76C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, robert.marko@sartura.hr
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH] dt-bindings: net: Add the properties for ipq4019 MDIO
Date:   Sun,  8 Aug 2021 15:53:28 +0800
Message-Id: <20210808075328.30961-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new added properties resource "reg" is for configuring
ethernet LDO in the IPQ5018 chipset, the property "clocks"
is for configuring the MDIO clock source frequency.

This patch depends on the following patch:
Commit 2b8951cb4670 ("net: mdio: Add the reset function for IPQ MDIO
driver")

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 0c973310ada0..8f53fa2a00f8 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -14,7 +14,9 @@ allOf:
 
 properties:
   compatible:
-    const: qcom,ipq4019-mdio
+    enum:
+      - qcom,ipq4019-mdio
+      - qcom,ipq5018-mdio
 
   "#address-cells":
     const: 1
@@ -23,7 +25,15 @@ properties:
     const: 0
 
   reg:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+    description:
+      the first Address and length of the register set for the MDIO controller.
+      the optional second Address and length of the register for ethernet LDO.
+
+  clocks:
+    items:
+      - description: MDIO clock
 
 required:
   - compatible
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

