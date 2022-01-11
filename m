Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D1D48B2CA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbiAKRDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:03:11 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:44649 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240781AbiAKRDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:03:09 -0500
Received: by mail-ot1-f44.google.com with SMTP id w19-20020a056830061300b0058f1dd48932so19239978oti.11;
        Tue, 11 Jan 2022 09:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5pxCwfoCTuq2L7n8+mgWgSvoekCjKiZJBmym09wYFY=;
        b=8OpcUqcWyrqmJHFcqJlEFoSYxyDxyA1sqLSwOnLCsa32IF3LJvzdt0A5/TkLE/Slr8
         F6MsZppylr6UAHB6vqgp5vFtts2KpmYFyogiqw1g71Jgs6xtfrnRYBjei6lBCOQAdzy+
         ZzBfiqtlmy6pxrK+GKUthFXLEtPSJBe0zCS93K4ExLtgLem5q2zhdfLj/cmwetJ4YbYB
         Q0Gta/wvwLxPp8tJZ9dxfGnEeh0RfgVo3Q0Yrk9k+LfU+qyztb76u+4LJI+Pf8ikEsdg
         rdEFlI9IQS4QgTeYHgOmd36ymQRo5NgW34qL0b3sFWmfQzZFszUj8rCV54TNqm+Gv9tg
         UMuA==
X-Gm-Message-State: AOAM531jUTV03/cxfG4nv77cFeJ69dG924UeLm/B0FDJeYwLZ/zPxqd+
        s2O4EHNjPWOfADa3/DovbA==
X-Google-Smtp-Source: ABdhPJzMfJtTgvczm2Kzwh4+nG+SG4x4EJsGeop3JT5WO9l1QP7x0N5xbB2Dl+0AXl1yiXnE2pGN2Q==
X-Received: by 2002:a9d:5d05:: with SMTP id b5mr3906269oti.306.1641920589160;
        Tue, 11 Jan 2022 09:03:09 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id 12sm501983otu.9.2022.01.11.09.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:03:08 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: mdio: Drop resets/reset-names child properties
Date:   Tue, 11 Jan 2022 11:02:47 -0600
Message-Id: <20220111170248.3160841-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

resets/reset-names are device specific and don't belong in the MDIO bus
schema. For example, it doesn't match what is defined for the
"qca,ar9331-switch" binding which defines "reset-names" to be "switch"
rather than "phy". Neither name is that useful IMO.

Other child properties are also device specific, but those won't conflict
with device schemas.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index 53206e4a7a14..b5706d4e7e38 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -76,12 +76,6 @@ patternProperties:
           the turn around line low at end of the control phase of the
           MDIO transaction.
 
-      resets:
-        maxItems: 1
-
-      reset-names:
-        const: phy
-
       reset-gpios:
         maxItems: 1
         description:
-- 
2.32.0

