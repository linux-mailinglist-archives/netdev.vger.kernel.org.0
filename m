Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3663372C5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhCKMfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhCKMfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:35:36 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4338BC061574;
        Thu, 11 Mar 2021 04:35:36 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id v2so26467974lft.9;
        Thu, 11 Mar 2021 04:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lkb4fhMWbYfgcrHFjrq5Zx1jnIW2z6RnyfRiSQSgbwM=;
        b=MGIdunE/4ebuipg/dNhIiKykhRA1jPxnkQBV/JuRjA5pFDmxg1KGu8bXs8l1zMa9Hv
         tSHFVFo8JwEKSOcf9S1TSgaf2Bf4m31l8reuwWR7NxJ1k8KVXNDzdnM8bAtkEGMWSd8I
         cEgBixcznbXFe+VsPpYx4agPF+Ya5zx2zK4UUQJ6o/dD9JMxpWNaL55wekEqG3qwS37f
         X6QpRpGe9ykOLWAaLu4ZzGaNGQAp5fBcZIcCvGZvHq8RZbSvrAt3TbFpzA6TtM2LfBgs
         7P4ou7ij14ClXvMBoTTYDlWhYGdIaLloCnq4cLY4BNhlfO+cCcfS6j8zmYacoFP3cOXl
         CJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lkb4fhMWbYfgcrHFjrq5Zx1jnIW2z6RnyfRiSQSgbwM=;
        b=KUvM5o5jvnSFRyqjopH7aOytbu3eIVDfMheSdltXLX24n5qoTKgmh61ZwTcp4sZdJu
         PRmT5ZKrJTWi6aHoXZuRVeXrXNjA8syzurCMZdie/DZoh47twdEb1KX4xc1BobyJORK4
         v9jvbbjtVD7Lj+xH0lrBkDucXHsjDhotzAWXgFbIGo97BFvo3Sc7IrfBpDNLHtPSdeK2
         DZ9jG52xed2WVY4ziIA6PFdwgyB9x/WMYqatJd0uVPDn/GnI7mibOoa/WfRgy4gMZ9hf
         Z2WIEkqX1NALZbjVbh+/uzFsYShvyVOEqtbfxlX6qdoyCy1MsBO/m8KoHeq7WC3wBDVy
         LT5Q==
X-Gm-Message-State: AOAM533eOFGXJKKESM1T/FQtQx7gIv943ONfPtoK0JpxITE+FBrGKqQD
        Npa4k4JAbmybmtTLa3CLo2w=
X-Google-Smtp-Source: ABdhPJzdMhPBsG75UDNglRTs0o/EtLVkOfvOQ/nWtUdCORsXRsAyvy9aKrpV3g8+xve4GCTPPXAngg==
X-Received: by 2002:a05:6512:3249:: with SMTP id c9mr2294161lfr.5.1615466134758;
        Thu, 11 Mar 2021 04:35:34 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j144sm774280lfj.241.2021.03.11.04.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 04:35:33 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 1/2] dt-bindings: net: bcm4908-enet: add optional TX interrupt
Date:   Thu, 11 Mar 2021 13:35:20 +0100
Message-Id: <20210311123521.22777-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210310091410.10164-1-zajec5@gmail.com>
References: <20210310091410.10164-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

I discovered that hardware actually supports two interrupts, one per DMA
channel (RX and TX).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../bindings/net/brcm,bcm4908-enet.yaml         | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
index 79c38ea14237..2a3be0f9a1a1 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -22,10 +22,18 @@ properties:
     maxItems: 1
 
   interrupts:
-    description: RX interrupt
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: RX interrupt
+      - description: TX interrupt
 
   interrupt-names:
-    const: rx
+    minItems: 1
+    maxItems: 2
+    items:
+      - const: rx
+      - const: tx
 
 required:
   - reg
@@ -43,6 +51,7 @@ examples:
         compatible = "brcm,bcm4908-enet";
         reg = <0x80002000 0x1000>;
 
-        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
-        interrupt-names = "rx";
+        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "rx", "tx";
     };
-- 
2.26.2

