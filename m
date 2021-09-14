Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6DC40BA2D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhINVWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:55 -0400
Received: from mx3.wp.pl ([212.77.101.10]:57149 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234893AbhINVWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:46 -0400
Received: (wp-smtpd smtp.wp.pl 15615 invoked from network); 14 Sep 2021 23:21:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654484; bh=NI1s3fyUzKFnJoED0B09JtxVWEJcupkI0XVp/SgGAfw=;
          h=From:To:Subject;
          b=cCrJANci5DZlDbkrA82osLhdrQPRxOHO8phkpAMptkt23yfUK3Oh3zYMFw5mUD2fF
           k3FJgLXCJ9/oDxckIVkzuMLpfIXRp9LnUEL3cE814flVUFyiNSlS21GCqw1ZxBREog
           dQSIg6x8/vafCqTmRZXILt5JUUqeRW7pqOsV25Vs=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:24 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] dt-bindings: net: lantiq: Add the burst length properties
Date:   Tue, 14 Sep 2021 23:21:05 +0200
Message-Id: <20210914212105.76186-8-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
References: <20210914212105.76186-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 3f16cb31ff38d9575689798d722fbd40
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [4ZN0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new added properties are used for configuring burst length.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../bindings/net/lantiq,etop-xway.yaml           | 16 ++++++++++++++++
 .../bindings/net/lantiq,xrx200-net.yaml          | 16 ++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
index 4412abfb4987..437502c5ca96 100644
--- a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
+++ b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
@@ -29,6 +29,18 @@ properties:
       - const: tx
       - const: rx
 
+  lantiq,tx-burst-length:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      TX programmable burst length.
+    enum: [2, 4, 8]
+
+  lantiq,rx-burst-length:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RX programmable burst length.
+    enum: [2, 4, 8]
+
   phy-mode: true
 
 required:
@@ -37,6 +49,8 @@ required:
   - interrupt-parent
   - interrupts
   - interrupt-names
+  - lantiq,tx-burst-length
+  - lantiq,rx-burst-length
   - phy-mode
 
 additionalProperties: false
@@ -49,5 +63,7 @@ examples:
         interrupt-parent = <&icu0>;
         interrupts = <73>, <78>;
         interrupt-names = "tx", "rx";
+        lantiq,tx-burst-length = <8>;
+        lantiq,rx-burst-length = <8>;
         phy-mode = "rmii";
     };
diff --git a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
index 7bc074a42369..16d831f22063 100644
--- a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
+++ b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
@@ -29,6 +29,18 @@ properties:
       - const: tx
       - const: rx
 
+  lantiq,tx-burst-length:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      TX programmable burst length.
+    enum: [2, 4, 8]
+
+  lantiq,rx-burst-length:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RX programmable burst length.
+    enum: [2, 4, 8]
+
   '#address-cells':
     const: 1
 
@@ -41,6 +53,8 @@ required:
   - interrupt-parent
   - interrupts
   - interrupt-names
+  - lantiq,tx-burst-length
+  - lantiq,rx-burst-length
   - "#address-cells"
   - "#size-cells"
 
@@ -56,4 +70,6 @@ examples:
         interrupt-parent = <&icu0>;
         interrupts = <73>, <72>;
         interrupt-names = "tx", "rx";
+        lantiq,tx-burst-length = <8>;
+        lantiq,rx-burst-length = <8>;
     };
-- 
2.30.2

