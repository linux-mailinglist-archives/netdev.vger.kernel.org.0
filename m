Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8418E1BE83F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgD2URP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2URO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4241C03C1AE;
        Wed, 29 Apr 2020 13:17:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so4093814wrb.8;
        Wed, 29 Apr 2020 13:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oSdaUU1sAQef6HcUSlubHrtLR7VgXha8CU0+FaZLEz4=;
        b=SaXueIiNlafjvD/L5DRZ40ZBfjU7ncCWTZkp82EZdq2RqTSNwG7DO4yhKv9xT0JM4P
         gsZrGU0i07myKAk+AnJNw0gTgKFRU99AnstjmFZPK7epxkXLSbeBwU8eNYsodEhe7sYI
         DvL3E/tVrmqM+ydY/VIa8nLA9TCpTk+VLj5Vd5CTg8Ml7z2gpXzoa/mE9+wH04jZy9mi
         fI7IAbV2ZiNa+vGGrFLoiS+026khr3JVcyb1ifh8K15U/gwTshSrxUfZE6qeIxwrB4jk
         Jm1/QcuefdJJHVNY3g0t/kP2bpaA0Gglpc+O6bShUOa/wcEMEL5eRj4ZmAC6YENCNxXT
         BxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oSdaUU1sAQef6HcUSlubHrtLR7VgXha8CU0+FaZLEz4=;
        b=ne2cd3cDk2rrL9CBN+d5seOU47/qwib6QtEnzs7xj9q58BuIRFhWwpK5BNx37AChFq
         5hJkY3iLBTgh/uHurg/KnV9p+sX+PQVBrNB777PwhNST+m20HAxdg2lnKhUtSsuiRSFr
         qxJ5rRWKynV4+6z7gxKX2rAUds9mNkfl5LoxTHgagzIf0hewGbHljQuQKoZedorpggor
         s7hOKaZyMa25RQ6yTuicSwlMTfUERjbazPfjMcq8KQxgzMXGZkEvT4WThKG8CboFZZ9i
         eSseXKz+ZDjW0L6ekVdjxLWvTnLvXgYvGl3qd8uIjyuxpiN0d4/sCM8g+OtTG1TqfXtE
         HXlg==
X-Gm-Message-State: AGi0PubLTZotU1uuBiQ5tRCgu5SWHWk/Op3uPabUDzAQdsw/PBixOaPj
        EWSAFeuEzNzNnuU400Rop+U=
X-Google-Smtp-Source: APiQypJ5wuI3iaT4ZvqzR/XFA5k+Bl12wp/s80x5ZiluHZdu39PD2o3yNiGqS7Qh2P4c8ATUDZp5Ag==
X-Received: by 2002:adf:fe44:: with SMTP id m4mr43579071wrs.188.1588191432566;
        Wed, 29 Apr 2020 13:17:12 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:11 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 01/11] dt-bindings: net: meson-dwmac: Add the amlogic,rx-delay-ns property
Date:   Wed, 29 Apr 2020 22:16:34 +0200
Message-Id: <20200429201644.1144546-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PRG_ETHERNET registers on Meson8b and newer SoCs can add an RX
delay. Add a property with the known supported values so it can be
configured according to the board layout.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../bindings/net/amlogic,meson-dwmac.yaml           | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index ae91aa9d8616..8d851f59d9f2 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -67,6 +67,19 @@ allOf:
             PHY and MAC are adding a delay).
             Any configuration is ignored when the phy-mode is set to "rmii".
 
+        amlogic,rx-delay-ns:
+          $ref: /schemas/types.yaml#definitions/uint32
+          enum:
+            - 0
+            - 2
+          description:
+            The internal RGMII RX clock delay (provided by this IP block) in
+            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
+            should be explicitly configured. When not configured a fallback of
+            0ns is used. When the phy-mode is set to either "rgmii-id" or
+            "rgmii-rxid" the RX clock delay is already provided by the PHY.
+            Any configuration is ignored when the phy-mode is set to "rmii".
+
 properties:
   compatible:
     additionalItems: true
-- 
2.26.2

