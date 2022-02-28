Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD54C636F
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiB1G7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 01:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiB1G7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 01:59:32 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB6A4B1C2;
        Sun, 27 Feb 2022 22:58:53 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 15452440870;
        Mon, 28 Feb 2022 08:58:11 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1646031491;
        bh=UzHRfBvg6y4IkbCIkI3SNnDjUBtpXSSAF8obp5wXLIc=;
        h=From:To:Cc:Subject:Date:From;
        b=IzEfQ8aL5rkycmm2Ngco9H+/lcKtjk/VEVA9LciyCIdf4ImNzuyOmKxlRKNPV87WY
         ANAXHJeUq7PSleIR9ZEz5F1tNKQwn5vNUvaMzWKNal7QnNITUkKZI+kyUt5iHY5F1x
         7NPEOlCOtlgNzYeHUN2H0Mt8e8hFB5WOQAMySJzw9i540Xteo8zXrRAK718Uq9jh7Z
         v2DqD27jBet1YdnZMge0T2W75FmqgODMrwH80NGVSkY2Qh2VhIfpx8aACzecvxMU3V
         icG9ABGVI4rkFFkToouCJv8JTEbKVQRUD17e3AA482Ds/0UQnlr0TUl2PhUqHkwEyu
         7as/JDV1xDG0w==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 1/2] dt-bindings: net: ipq4019-mdio: Add ipq6018 compatible
Date:   Mon, 28 Feb 2022 08:58:43 +0200
Message-Id: <8de887697c90cd432b7ab5fe0d833c87fc17f0f1.1646031524.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

The IPQ60xx MDIO bus is the same as IPQ4019.

Update the schema to allow qcom,ipq4019-mdio compatible as fallback for
newer IPQ series.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---

v3:

  Correct the schema to fix yamllint failure (Rob's bot)

v2:

  Update the schema to allow fallback compatible (Rob Herring)
---
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml     | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 2af304341772..dde8e6931ed3 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -14,9 +14,13 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - qcom,ipq4019-mdio
-      - qcom,ipq5018-mdio
+    oneOf:
+      - const: qcom,ipq4019-mdio
+      - items:
+          - enum:
+              - qcom,ipq5018-mdio
+              - qcom,ipq6018-mdio
+          - const: qcom,ipq4019-mdio
 
   "#address-cells":
     const: 1
-- 
2.34.1

