Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D991719B4FA
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732579AbgDAR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:58:07 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44195 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730574AbgDAR6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:58:06 -0400
Received: by mail-io1-f68.google.com with SMTP id r25so589578ioc.11;
        Wed, 01 Apr 2020 10:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YhnZq6kW0oAS2hnyC5WT5+4Jc6X+26sgyRRXo71R0nw=;
        b=LaLAGyQxVD2dexQDUi1T9hDIOImPtwYfY9fdUv2OOGVbYE0CwmdGcdjJy4dYrM98rh
         HH3wxZET/7xsR7PaqGXXRhUOBhr9NaznTb7no+Gw0ZIlFTPIvOFpsgH1JaR0ytRbcNVf
         VUEavmdUSPMWpeI3eBoEAP40oALh71yEs9atKIzM//8/hwi4CFuYctBOtTFpEK82RWUQ
         lHZX9zHeylwrLgq0uHNAKqzd9Dkybsl7OSKm/twXHa8YzrPqRNpAdwvR2H6wpwmAsggb
         4uhgoGc/2UZ7flA/BgXbStbduPC5FrVZGi1Ldt9ZLUQu9WM0Gfz/rBEvPiYD1EiwQ76W
         +fWg==
X-Gm-Message-State: ANhLgQ1k1JgTtb/mEo9uIx+bsUpmzUgtXybHh68F3laNEZZaxTue1lNY
        3UN4KRO+VTfShKCyxFzTkrakj8U=
X-Google-Smtp-Source: ADFU+vskUx0caKjWEpqvhl52V9YxFEomzg6LeP8ohqtqv+81Rw6YLLKrL8aJ1yA85E1XQleWax1bVQ==
X-Received: by 2002:a6b:6502:: with SMTP id z2mr19396370iob.130.1585763885916;
        Wed, 01 Apr 2020 10:58:05 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.250])
        by smtp.googlemail.com with ESMTPSA id z20sm771447iod.25.2020.04.01.10.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 10:58:05 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: mvusb: Fix example errors
Date:   Wed,  1 Apr 2020 11:58:04 -0600
Message-Id: <20200401175804.2305-1-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The example for Marvell USB to MDIO Controller doesn't build:

Error: Documentation/devicetree/bindings/net/marvell,mvusb.example.dts:18.9-14 syntax error
FATAL ERROR: Unable to parse input tree

This is due to label refs being used which can't be resolved.

Fixes: 61e0150cb44b ("dt-bindings: net: add marvell usb to mdio bindings")
Cc: Tobias Waldekranz <tobias@waldekranz.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
David, Please take this and send to Linus before rc1 as 'make 
dt_binding_check' was broken by the above commit. That would have been 
caught had the DT list been CC'ed or if this had been in linux-next long 
enough to test and fix (it landed in next on Monday :().

Rob

 .../bindings/net/marvell,mvusb.yaml           | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,mvusb.yaml b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
index 9458f6659be1..68573762294b 100644
--- a/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,mvusb.yaml
@@ -38,28 +38,27 @@ required:
 examples:
   - |
     /* USB host controller */
-    &usb1 {
-            mvusb: mdio@1 {
+    usb {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            mdio@1 {
                     compatible = "usb1286,1fa4";
                     reg = <1>;
                     #address-cells = <1>;
                     #size-cells = <0>;
-            };
-    };
 
-    /* MV88E6390X devboard */
-    &mvusb {
-            switch@0 {
-                    compatible = "marvell,mv88e6190";
-                    status = "ok";
-                    reg = <0x0>;
+                    switch@0 {
+                            compatible = "marvell,mv88e6190";
+                            reg = <0x0>;
 
-                    ports {
-                            /* Port definitions */
-                    };
+                            ports {
+                                    /* Port definitions */
+                            };
 
-                    mdio {
-                            /* PHY definitions */
+                            mdio {
+                                    /* PHY definitions */
+                            };
                     };
             };
     };
-- 
2.20.1

