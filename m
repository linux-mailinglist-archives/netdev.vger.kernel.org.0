Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518AB53EF7F
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiFFUWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiFFUWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:22:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA4365B9
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 13:22:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w27so20272270edl.7
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 13:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ramRhPzzIanDTBc4YnvbtflH7YCV/CY9bbWKmWrFq+o=;
        b=N3f1F70RSHOFUi0/95Am3KcViH7CUmDqqDllaG1ylIXteKA1EkETYVMSFYjiwpGrET
         FTO+f+0s394CngQLk3wD/L9VwZlk2ds+xfL8yntxprVroIHL62K0VSmvfj7krHr0YTKX
         IxtUuaGyebDJuwxo+20qpc7cj9dFUlOmSGZ/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ramRhPzzIanDTBc4YnvbtflH7YCV/CY9bbWKmWrFq+o=;
        b=tGlm6TcC1jxQu5l2WujVpUm2trF4dwT51oNR9v2VyfVNCdE2/Uc5KneLDEH+KpYheh
         dOQDf8oBvbiXmtZ8sWvv53nRM3L2gPeSX4n4/+dRz2or23RWTjPxtxoFdz40YOZIMY1m
         zO9RzbZDWJPpKXgwVw3K3EKP/nWOrtVIgnV+ASPPBtWrhshd5iYfs+db+/weg9SkgcHy
         JtBPbN+h0iv8CTLwGujif6REpmlsIijOBcZ42WVtjtavFSQBYrPFe5sPIRZCfKZaoY1G
         NAxsk8Lb4h/WEGfwr4Dgs0G4kotoLRvYEdM6arDPP+6pw4IN3//Tu/1SYNsN8GSDPMyP
         GoTQ==
X-Gm-Message-State: AOAM530gTqx64xB8sk+UxB4DkJwcJ/LvG2sIgPgP1EJNo9ZzInL89+Yl
        qOfoGZe7OLXagzmF5iXf/58TZbEovEmFug==
X-Google-Smtp-Source: ABdhPJxf90ydtFhUbmr0z/WGR2mG8fWABtzc4aXbMKhN9fZFmMOgy+j8tmFnkR00S/KUbHBjbVI/6Q==
X-Received: by 2002:a05:6402:358a:b0:431:20d5:f4ad with SMTP id y10-20020a056402358a00b0043120d5f4admr15251525edc.375.1654546949175;
        Mon, 06 Jun 2022 13:22:29 -0700 (PDT)
Received: from prevas-ravi.tritech.se ([80.208.64.233])
        by smtp.gmail.com with ESMTPSA id d20-20020aa7ce14000000b0042dd4ccccf5sm9043789edv.82.2022.06.06.13.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 13:22:28 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] dt-bindings: dp83867: add binding for io_impedance_ctrl nvmem cell
Date:   Mon,  6 Jun 2022 22:22:18 +0200
Message-Id: <20220606202220.1670714-2-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
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
options - leaving IO_IMPEDANCE_CTRL at the (factory calibrated) reset
value or using one of the two boolean properties to set it to the
min/max value - are too coarse.

There is no documented mapping from the 32 possible values of the
IO_IMPEDANCE_CTRL field to values in the range 35-70 ohms, and the
exact mapping is likely to vary from chip to chip. So add a DT binding
for an nvmem cell which can be populated during production with a
value suitable for each specific board.

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

