Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC31F5B910B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiINXkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiINXkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:40:49 -0400
X-Greylist: delayed 1585 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Sep 2022 16:40:48 PDT
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188AD402E5;
        Wed, 14 Sep 2022 16:40:47 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc1a.ng.seznam.cz (email-smtpc1a.ng.seznam.cz [10.23.10.15])
        id 77ea57b49346848a7637f6da;
        Thu, 15 Sep 2022 01:40:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1663198812; bh=KfzDDufQO0EmyWPeN8vROr7WTX1Av+h27clBNarB/G0=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding;
        b=HebwmnAmfNwyXXrU0O1OpA1luvqCT5y7zJOKbFL4VXy1DplhKqvUj/vT5LqPbxMO6
         KHax8sGxyMusmS8d0iVxb6LgbfxIJZVSrEgOLKJqa3xpml2buYKJcvERtb9g0bwNQs
         HfgeWbFx/Yl81qjynyhnSG/sL8C0GSzrh9xw5bvM=
Received: from localhost.localdomain (2a02:8308:900d:2400:4bcc:f22e:1266:5194 [2a02:8308:900d:2400:4bcc:f22e:1266:5194])
        by email-relay10.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Thu, 15 Sep 2022 01:40:11 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: [PATCH v4 1/3] dt-bindings: can: ctucanfd: add another clock for HW timestamping
Date:   Thu, 15 Sep 2022 01:39:42 +0200
Message-Id: <20220914233944.598298-2-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
References: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add second clock phandle to specify the timestamping clock.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../bindings/net/can/ctu,ctucanfd.yaml        | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
index 4635cb96fc64..432f0e3ed828 100644
--- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -44,9 +44,19 @@ properties:
 
   clocks:
     description: |
-      phandle of reference clock (100 MHz is appropriate
-      for FPGA implementation on Zynq-7000 system).
-    maxItems: 1
+      Phandle of reference clock (100 MHz is appropriate for FPGA
+      implementation on Zynq-7000 system). Optionally add a phandle to
+      the timestamping clock connected to timestamping counter, if used.
+    minItems: 1
+    items:
+      - description: core clock
+      - description: timestamping clock
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core-clk
+      - const: ts-clk
 
 required:
   - compatible
@@ -61,6 +71,7 @@ examples:
     ctu_can_fd_0: can@43c30000 {
       compatible = "ctu,ctucanfd";
       interrupts = <0 30 4>;
-      clocks = <&clkc 15>;
+      clocks = <&clkc 15>, <&clkc 16>;
+      clock-names = "core-clk", "ts-clk";
       reg = <0x43c30000 0x10000>;
     };
-- 
2.25.1

