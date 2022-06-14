Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3813F54AC52
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355889AbiFNIqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355830AbiFNIqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:46:23 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5551433A6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:19 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id l20so2162768lji.0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ij41iYIrsaYScwS30JeqaDifxteKwIBwdtXN2yvAeBg=;
        b=b3TVykTo337jeVgLKyyE7dHh4PorhizQMUTCOrLnEdrkBsT8zv+H8A44Otm10TVuZC
         YUY590z5NPAJSYNH/9KYhGVd915VuP2yOVtUFoI0hFrN8BeckzXNMg1EYCBHz4JNBfif
         F9tkV1fKUxpsUEFWuGpMyudCeixMG8Gtml0Ug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ij41iYIrsaYScwS30JeqaDifxteKwIBwdtXN2yvAeBg=;
        b=B60AVyAevHUDUk/hw3z+GLYWfYW+zt1rR0ANp5RXmJ3w2ExOjxIhu7Jx0GIk5b9U6h
         8DKcoZUM/ZOzj5jPWDNAxiT335BjvZ6coOE+d9Mqt2VZUFSWbLOi1+WTrYj7fwfwssp9
         Larvm+qzZiXic9VpNfHVNzq4AROA73gBwITC0ABwaucanvIeAizbSXyl6pcQMMqe+aBS
         KzSn3u7bsf+SDOm57bYxlQnVQXvSw/jiT7YfHv6Px3fhKo06kP4qTOs6jjd8FenMXHBr
         ROSIbqPjOdqXZYU2vYhN30/KsP7GroC8beRWLRwd6AXqzzO/ZEMhj1ek9f5xrjET/Tak
         NTuw==
X-Gm-Message-State: AJIora9Drtz8GqOlFj8n6kRwpP7U9wJSFGMwj+gWA2/+b5n1YTYsXkzJ
        UlUAuwqr02eakFxByPCcSKKIJNjdsnAoiWqP
X-Google-Smtp-Source: AGRyM1vgJAmSuIrSAaT4aB4D/Mrty59U5anACJbPi65s/ospCO3ybzP+GZ+4ju+aMf8cfsXPd/T1yw==
X-Received: by 2002:a2e:9b0d:0:b0:255:92b9:eb3c with SMTP id u13-20020a2e9b0d000000b0025592b9eb3cmr1911477lji.5.1655196377781;
        Tue, 14 Jun 2022 01:46:17 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id g1-20020ac24d81000000b0047255d2118fsm1306116lfe.190.2022.06.14.01.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:46:17 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 1/3] dt-bindings: dp83867: add binding for io_impedance_ctrl nvmem cell
Date:   Tue, 14 Jun 2022 10:46:10 +0200
Message-Id: <20220614084612.325229-2-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220614084612.325229-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
 <20220614084612.325229-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a board where measurements indicate that the current three
options - leaving IO_IMPEDANCE_CTRL at the reset value (which is
factory calibrated to a value corresponding to approximately 50 ohms)
or using one of the two boolean properties to set it to the min/max
value - are too coarse.

There is no fixed mapping from register values to values in the range
35-70 ohms; it varies from chip to chip, and even that target range is
approximate. So add a DT binding for an nvmem cell which can be
populated during production with a value suitable for each specific
board.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 .../devicetree/bindings/net/ti,dp83867.yaml    | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index 047d757e8d82..76ff08a477ba 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -31,6 +31,16 @@ properties:
   reg:
     maxItems: 1
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell containing the value to write to the
+      IO_IMPEDANCE_CTRL field of the IO_MUX_CFG register.
+
+  nvmem-cell-names:
+    items:
+      - const: io_impedance_ctrl
+
   ti,min-output-impedance:
     type: boolean
     description: |
@@ -42,9 +52,11 @@ properties:
     description: |
       MAC Interface Impedance control to set the programmable output impedance
       to a maximum value (70 ohms).
-      Note: ti,min-output-impedance and ti,max-output-impedance are mutually
-        exclusive. When both properties are present ti,max-output-impedance
-        takes precedence.
+      Note: Specifying an io_impedance_ctrl nvmem cell or one of the
+        ti,min-output-impedance, ti,max-output-impedance properties
+        are mutually exclusive. If more than one is present, an nvmem
+        cell takes precedence over ti,max-output-impedance, which in
+        turn takes precedence over ti,min-output-impedance.
 
   tx-fifo-depth:
     $ref: /schemas/types.yaml#/definitions/uint32
-- 
2.31.1

