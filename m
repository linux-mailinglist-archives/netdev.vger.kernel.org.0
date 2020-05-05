Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6282D1C57CB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgEEODH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729087AbgEEODG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:06 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49214C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x25so2445589wmc.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sewIQrOfMSMCFki5vvjbKoo8BkZz8WZa7NzooTrVnts=;
        b=QPBVrk4u8bJ1lyN89axq0pdEKOmmpYRibOzYW9nIG6R7g/9gJVFV6ctaT8iBdUKdvE
         UKqVm24R87Z+G6t4c+xieFb5HnHqsm9PsnsbYdN0/IyxhMLLe4qWBFTpRY3TR43BUQcJ
         HzgxxM2cfl7MZ1UnQnpI7YpljOD+ekvKio1Vrf5ofqLNPTGwEXk969k4GdrLGfJE+YI6
         PN4xsD86VY0ZuN1aQ79VgYNhb+8eTQmmtA4T1F5cgaoJYzI/3CliI4iabK5wwv0kUU9r
         2Y7kIDZwYPSIG28sAGkYE+hzu8hM25jTiyicyfN9DUB/qeO+jSjC8pHYvFRah7uIc5ph
         Y2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sewIQrOfMSMCFki5vvjbKoo8BkZz8WZa7NzooTrVnts=;
        b=mo4u7kEAvueD4sz/wIAeSrFNviN1GrzFDGhEEUS74TZPA4HjUFYY9w1xMGJXc2G0lT
         g1I0cMJCS8HmWl+/TY5ZpbGKbtlrj9dSrDsZtdNBKFhUBYcZUhqMMgDEdwChDQ2eYRnn
         +GJePBh1YFrZ+OozLIjn0oCR55TRqskzdoglSZo7N4S6XWX3Kb+BELnyIUrO5O1L1DeR
         rqUbI3BkK9TQDniaFdEpI2uOgVpUKiHUO1RSOVDBDgkLaZbyFXA5N7N6nWIRLEeRx1Hr
         Fk5of/ruqFTqpbjJo8lLCa6MtCHxOfGTlZmCjNA7POl5bxhdlU91rWz+fVNt6jSy1BUa
         gg5w==
X-Gm-Message-State: AGi0Pub+eXfyjZzVUrYWFOxT0FEOGB6wat+NM5/vlpEvLls/fsqcKeAS
        62/n+uoOUI02q4BdGJKAP8Tfrw==
X-Google-Smtp-Source: APiQypKH83ab6otRmwy18VhA5GKakhCU3ceSapgu6ZcYgX3DVNjT64ntS3hfln0YNJ+gri577CJFIA==
X-Received: by 2002:a1c:f609:: with SMTP id w9mr3451354wmc.123.1588687385015;
        Tue, 05 May 2020 07:03:05 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:04 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 01/11] dt-bindings: add a binding document for MediaTek PERICFG controller
Date:   Tue,  5 May 2020 16:02:21 +0200
Message-Id: <20200505140231.16600-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This adds a binding document for the PERICFG controller present on
MediaTek SoCs. For now the only variant supported is 'mt8516-pericfg'.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../arm/mediatek/mediatek,pericfg.yaml        | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
new file mode 100644
index 000000000000..74b2a6173ffb
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,pericfg.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek Peripheral Configuration Controller
+
+maintainers:
+  - Bartosz Golaszewski <bgolaszewski@baylibre.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+        - enum:
+          - mediatek,pericfg
+        - const: syscon
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    pericfg: pericfg@10003050 {
+        compatible = "mediatek,mt8516-pericfg", "syscon";
+        reg = <0 0x10003050 0 0x1000>;
+    };
-- 
2.25.0

