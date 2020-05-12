Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCEF1D0054
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbgELVLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728275AbgELVLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:11:19 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC79C061A0C;
        Tue, 12 May 2020 14:11:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f134so11674871wmf.1;
        Tue, 12 May 2020 14:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kh7p8rdrTbAMmI3jWtK1rZ9CbIg2ia2rDs/YlOsgpNA=;
        b=cPIFoUvmGIxlPukGMQ7uGcHJho6BH2jGg4P+6CrUS2FvkuvBR2XBMGSKjdAN7h5ivW
         qYQPhCP3eojUqRSNOJaGa+3BBZXPvdg1NFwRq75U30hEhpvkTj2gY54W7a2GdmFmOm7N
         zmEbNjJIscccItBYwFKUuKPWZIyBjM2r4aFer6ZssxucBg2hci+WpPC2jq4HOmK9eZRk
         /NDY+PKGUgaah856aF+GXpuz3xL8nRZOhhMgz4A3rEZajuzbTPxjRjEmkgD1EpNorQS5
         R/jG+yKs5kQi53KQMbB4/IbHqdmwbOFixz0i0nZNQwbwzXpWp9d/KUK2agPPEU3o7p+g
         uQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kh7p8rdrTbAMmI3jWtK1rZ9CbIg2ia2rDs/YlOsgpNA=;
        b=olZPmSYyEMKegy8UnkYEs1BemPmu2Df5cUwKIwqwebu0LkCIyVjoRuepxcXA79ue/M
         KHQDCoHJrrTbrxBcH8WJ1LZ1uEzcmVRwmXtfr8BfzNiZ8w+kE2UO9tURD3GOZ93qbdT0
         tAOgjDH/dtQI8SFDA4sXurs1AOVGyiOFL9jP7j/JIbfQPWtSwjiB7mCl3ULvbcEndxSs
         t9CQUPM0YB7tOMWjs++CbM1/EysJME6JZRtauN1CwcgG2UWmRvsFx7IjbZJkWRctOJqc
         /DDkBhcK9yk7hqpg4LMjqsWLUx8Qt3D4gJ7cMtsslVn2eYfqkqIEs6q83AdW/U6xHpdZ
         V8Lg==
X-Gm-Message-State: AGi0PubpeMUR5hmyG9S2u7ztEbuPMVXF6qdjp7/dU7je8yu+KuqMAR3x
        Xq4MjXcCdDgNohhIenz7Lcg=
X-Google-Smtp-Source: APiQypLgwKpieVSrD5/RT1U58B8Yxn1gsc38huXEUnq0btI1b4UmRyYIc59I/TBi1DMhTgv49hJcBQ==
X-Received: by 2002:a1c:1d12:: with SMTP id d18mr25183480wmd.109.1589317877769;
        Tue, 12 May 2020 14:11:17 -0700 (PDT)
Received: from localhost.localdomain (p200300F137132E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3713:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id r3sm9724228wmh.48.2020.05.12.14.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 14:11:17 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/8] dt-bindings: net: meson-dwmac: Add the amlogic,rx-delay-ns property
Date:   Tue, 12 May 2020 23:10:56 +0200
Message-Id: <20200512211103.530674-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PRG_ETHERNET registers on Meson8b and newer SoCs can add an RX
delay. Add a property with the known supported values so it can be
configured according to the board layout.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../bindings/net/amlogic,meson-dwmac.yaml           | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index ae91aa9d8616..66074314e57a 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -67,6 +67,19 @@ allOf:
             PHY and MAC are adding a delay).
             Any configuration is ignored when the phy-mode is set to "rmii".
 
+        amlogic,rx-delay-ns:
+          enum:
+            - 0
+            - 2
+          default: 0
+          description:
+            The internal RGMII RX clock delay (provided by this IP block) in
+            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
+            should be explicitly configured. When the phy-mode is set to
+            either "rgmii-id" or "rgmii-rxid" the RX clock delay is already
+            provided by the PHY. Any configuration is ignored when the
+            phy-mode is set to "rmii".
+
 properties:
   compatible:
     additionalItems: true
-- 
2.26.2

