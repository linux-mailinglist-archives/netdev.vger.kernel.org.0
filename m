Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741EA271347
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgITJ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 05:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgITJ6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 05:58:01 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6453C061755;
        Sun, 20 Sep 2020 02:58:00 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d20so11894867qka.5;
        Sun, 20 Sep 2020 02:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qdhkRouPUBlhhUeuoTWCcVW3x0+uiY3ffJ1oCMZQUk=;
        b=PvksojqItdBGtMhfwgKVJlnT43Rh3sUoLBTo2Iu8ZudwahRjKwVfIa2w3ob8pTa587
         MwqTSxoHQGn17cO0HvQau/Az/czSlT8qzP/HdiabGHVsR89on1ljbFc3xxliPEtfJNlm
         iCIJG4gGaUnNLLBSXAJ7jeklc6N4f8m6Nf4LVoj0ikbId4Ul32cFhOBAsmdc/lTwP/JM
         g+tMG4TklMRz/m8LSzok7C3UksAmaq8Vca/WrOzJe703DgdPFeI4+6sO+732rk8SWvLD
         qHOVsyi1aPzt08ZPEZPCh2g4hK9mDxUmvXG3NF/jNoDFB3Th6PUwfHog9Ija68/O1iQO
         1S7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qdhkRouPUBlhhUeuoTWCcVW3x0+uiY3ffJ1oCMZQUk=;
        b=qspGvqppsgOG4TxEvgJ1ZlpABEd7/eb+D2VvQ9eLlFcBox970ghmC4r1uEK99hfk1m
         l15+iN2pAQAeGmlnfveiQG2ISPuE78DHpLUv+xfVaY9aXt42nbtaeL4WuQZ23s/DQ5lZ
         BBI99x/W3Vvol/bumvLq36FCzNzJRXi9P+TNp2RzQIm8/IxJffk3DXSIUWPqJWcPH1uD
         F5qox5rSqsiP3lcMSCLjtvATgg0fKNT/1BQIW1IhulHxDGPB07ZrxFWSwE+9+Dkuh6hp
         7WrYsWVJhUUQ0jE2o3YpjPV9II+pKmz8+0cXPpJr0hLIaJGjwUm8YLJJfpHFwYGp6i8t
         MEsg==
X-Gm-Message-State: AOAM530JUaymlYptk9hF6+gROz6JilX4+KtVHyCrRNL1jgZs5Bjp5p7S
        ktfqom9K6ePs/hZPMIMBzgg=
X-Google-Smtp-Source: ABdhPJw4fjyrkxIC+QZRszgyocPb227aTwysjA6Y6+BSsjmYj3MtfEQbRiHUZN+EhaJlycSon3FALA==
X-Received: by 2002:ae9:ebcf:: with SMTP id b198mr40726993qkg.488.1600595879999;
        Sun, 20 Sep 2020 02:57:59 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w6sm6968323qti.63.2020.09.20.02.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 02:57:59 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 4/4] dt-bindings: net: Document use of mac-address-increment
Date:   Sun, 20 Sep 2020 11:57:22 +0200
Message-Id: <20200920095724.8251-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920095724.8251-1-ansuelsmth@gmail.com>
References: <20200920095724.8251-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new bindings are now supported by the of_net driver to increase (or
decrease) a mac-address. This can be very useful in case where the
system extract the mac-address for the device from a dedicated partition
and have a generic mac-address that needs to be incremented based on the
device number.
- mac-address-increment-byte is used to tell what byte must be
  incremented (if not set the last byte is increased)
- mac-address-increment is used to tell how much to increment of the
  extracted mac-address decided byte.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../bindings/net/ethernet-controller.yaml     | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fa2baca8c726..8174f64e79bd 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -32,6 +32,27 @@ properties:
       - minItems: 6
         maxItems: 6
 
+  mac-address-increment:
+    description:
+      The MAC address can optionally be increased (or decreased using
+      negative values) from the original value read (from a nvmem cell
+      for example). This can be used if the mac is read from a dedicated
+      partition and must be increased based on the number of device
+      present in the system. The increment will not overflow/underflow to
+      the other bytes if it's over 255 or 0.
+      (example 00:01:02:03:04:ff + 1 == 00:01:02:03:04:00)
+    minimum: -255
+    maximum: 255
+
+  mac-address-increment-byte:
+    description:
+      If 'mac-address-increment' is defined, this will tell what byte of
+      the mac-address will be increased. If 'mac-address-increment' is
+      not defined, this option will do nothing.
+    default: 5
+    minimum: 3
+    maximum: 5
+
   max-frame-size:
     $ref: /schemas/types.yaml#definitions/uint32
     description:
-- 
2.27.0

