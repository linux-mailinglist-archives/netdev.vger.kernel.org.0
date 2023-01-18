Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7CB671CF9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjARNHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjARNHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:07:01 -0500
Received: from smtp-out-01.comm2000.it (smtp-out-01.comm2000.it [212.97.32.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4106559D3;
        Wed, 18 Jan 2023 04:29:08 -0800 (PST)
Received: from francesco-nb.toradex.int (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-01.comm2000.it (Postfix) with ESMTPSA id 6EDB8843650;
        Wed, 18 Jan 2023 13:28:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674044946;
        bh=bjC01oSWRrukRi0FK/TP4lp7hs5che5aWaE7C4SjpZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=gtaXP8+mXEp6XCT+KrIjjks/aYQnMYzgSITxTjoJuyrOpWAKbuwIHCkqe/2apjSn6
         jdHsZnJYBLgrFmoqBNBpkhwBu0WEXUlXKfeD1e1mH1Uzm/Bm6G5/H/brVdj8PKNOGf
         WK4EBlvkNmhmjcLIyPZb1iMSq8pZJnt+lWLNqfGGKh3VZPVycGsrTLesyMaoOBPwqQ
         h9bmnSCsVfNBsbl5p4juZnQrTnTv2sdj04QHlFNA1Esz+MXhDsDx29VcT0I+XB5+wm
         s2574muvScFk92dSatCN/jdnbLmUsyX91M39FEmZbY88V9n9s1G3D9c8h2XRDkJ+wQ
         +vsxAl1hoUY+A==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v1 2/4] dt-bindings: bluetooth: marvell: add max-speed property
Date:   Wed, 18 Jan 2023 13:28:15 +0100
Message-Id: <20230118122817.42466-3-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118122817.42466-1-francesco@dolcini.it>
References: <20230118122817.42466-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

The 88W8997 bluetooth module supports setting the max-speed property.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 .../bindings/net/marvell-bluetooth.yaml          | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
index 83b64ed730f5..2fccea30c58d 100644
--- a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
@@ -19,9 +19,25 @@ properties:
       - mrvl,88w8897
       - mrvl,88w8997
 
+  max-speed:
+    description: see Documentation/devicetree/bindings/serial/serial.yaml
+
 required:
   - compatible
 
+allOf:
+  - if:
+    properties:
+      compatible:
+        contains:
+          const: mrvl,88w8997
+    then:
+      properties:
+        max-speed: true
+    else:
+      properties:
+        max-speed: false
+
 additionalProperties: false
 
 examples:
-- 
2.25.1

