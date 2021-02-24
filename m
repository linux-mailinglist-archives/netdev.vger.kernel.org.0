Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892EE323B8A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhBXLwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbhBXLwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:52:41 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5AAC061574;
        Wed, 24 Feb 2021 03:52:01 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e7so1447127ile.7;
        Wed, 24 Feb 2021 03:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OtHK69XqkhA/jaimkYAZVFJcI+Rth0y3HJjsnP3488w=;
        b=p6YouBi4v9Djk6ErV7x33qioAlZ0X7OYOH3AJ3PPrA6oQGmvhEBBrObEb9705BQ9px
         7ShymZDY9xabTp49q6bXX6LCczJrgV0mRtq0+XxGTduYe0RlkLwSd+rKnY8HCINjyUSp
         wDff1dVd0l1QAVdvZm88OZulH88XcSFrvX88f+X//taO88PZpzgC9FUWxnMlNjSxG64s
         KDC/YETZF32ny7cRuh4TpjaYgU/lH6UUwGDL/pYh7mSVxJzkNQX1tI4EQMuAS9q19glN
         oL6bI4PQTpGqu59HaPv0jPjX/OKkmodHoEv2zzttur8UtzLpjZLz7e8QMrUU0235ULTa
         U56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OtHK69XqkhA/jaimkYAZVFJcI+Rth0y3HJjsnP3488w=;
        b=IusHhjrq4kNyqX5mwPejYalB3Dm6uX7hF8rlaXhkhMiUQoO2ZSZ8ozPTgr0+bRNXeS
         o6iZuxlpI3Okxl0CLhPjK/i6c+wbts7ifZE99k8+cxiB0ExeFwaa4KgEOTyMzMTLszKq
         K4lWaQqLI84d1SnIHW5Kw5pbiFd+eIbQhqdFYzlVVv07Lbi571h2d4Ftt2IRkEZg5xGk
         1GLGoavVGazD0j0dLfzgB7vs4c1EU8VdsESLNznqR3lfihkOpUMK5kt1YFANmyeZuQkF
         LpkYWYE6fPUrqMOwdkAP/OfN9Ii07yBkhCCHMZXssivdW6L9Afl6Kn7fjgy56zDpy2II
         oiJQ==
X-Gm-Message-State: AOAM530ujieGiJG5aIOpH0fP2k8gQ4CC5mgsaIKYTk2YPCyKP16VCojh
        kuw0F1ymepwHMslK9lHfTMc+rwnxLMbiWA==
X-Google-Smtp-Source: ABdhPJzjsLFyNlnOmCTyp4PANPyxSx8kr/XE/dEokyVc0yA4BsshfRoDgHmm5Sm+oq0EW2fZySWWuw==
X-Received: by 2002:a05:6e02:20e8:: with SMTP id q8mr23219551ilv.205.1614167520501;
        Wed, 24 Feb 2021 03:52:00 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:de9c:d296:189b:385a])
        by smtp.gmail.com with ESMTPSA id l16sm1500001ils.11.2021.02.24.03.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:52:00 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 1/5] dt-bindings: net: renesas,etheravb: Add additional clocks
Date:   Wed, 24 Feb 2021 05:51:41 -0600
Message-Id: <20210224115146.9131-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AVB driver assumes there is an external crystal, but it could
be clocked by other means.  In order to enable a programmable
clock, it needs to be added to the clocks list and enabled in the
driver.  Since there currently only one clock, there is no
clock-names list either.

Update bindings to add the additional optional clock, and explicitly
name both of them.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
---
V3:  No Change
V2:  No Change

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index de9dd574a2f9..7b32363ad8b4 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -49,7 +49,16 @@ properties:
   interrupt-names: true
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: AVB functional clock
+      - description: Optional TXC reference clock
+
+  clock-names:
+    items:
+      - const: fck
+      - const: refclk
 
   iommus:
     maxItems: 1
-- 
2.25.1

