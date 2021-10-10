Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3F9427E54
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhJJB6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhJJB6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:18 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E7C061765;
        Sat,  9 Oct 2021 18:56:19 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i20so35698846edj.10;
        Sat, 09 Oct 2021 18:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=qCx/uTgRBDKUc+YCgMwCz/hQsMcDWBTldgUIFLknShciQEA0rNSqXbuhIJKifbtavR
         T2xwLO/RaMKbIB609TMUgwD/p+aA1NVqdvkKSxMT/1w1SXuQQ+XYJSK9MKO46vectBIU
         HQw7NmxASSPCGkJhXxRmR0+o5diYjcXuSwWGNOZi+BF8k8h8VrZxjUblrOaH6A1y3al4
         xaiuVvWpEnKmkzP3qN9ExRR9ofXWCkfzjOcxQO+eYqmbeRNSTYbh23FwCZbiyE4AjIK4
         1emhsEiNTFNrLUHLI6AtpwKqjo5C2PSdTxwqnoqd4winDU84oDz/x7TQ2nQRK5svvC3k
         EPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=DnhmspqgBXGJT+EXMpsJdTUqjGbWatO68BNugQERNDxTX6QkiG+fv9Y5a3TAnyr497
         U6kA4VKIlTVWzzXKWpAJ6IoT44KIHuYf3D4UA2xV2fYnGoCeYwoZGlk6FZmKKx2UgTiV
         hvzj4t20RpRAMGi6x8eeapa/DsQsPf1XX3KefAKPsWIQ5o1WqJFs8fNlI7VTC4eOsIaw
         /XGpT2Iw+qVKkoeEP0RIP+Ie9a2GZfuusI1nBXWLeAdSl64mGHa8Ur8f6FVHqNmeH6ow
         4SUAWjRsZDBwMlvosGrkHo4vUIhEK2NV2583qf6fyVGTpgfVh4F9bVTdkJdhDhKk1J3M
         ExCQ==
X-Gm-Message-State: AOAM533kHYUsr6RByqKSnWsYrlU6SHIpjS78eRdK1BATwnr/mWmcqXum
        eH9SxlL2cqom/v6bIE1F0W0=
X-Google-Smtp-Source: ABdhPJxU8v1dL0i8aZ6grRLupdYVYYMYy2m4qYNdOOzYslQEoOHYq3MZJ90mz64+auXnD8ZiFArJpw==
X-Received: by 2002:a17:906:7a1e:: with SMTP id d30mr15195880ejo.517.1633830978040;
        Sat, 09 Oct 2021 18:56:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:17 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 08/13] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Sun, 10 Oct 2021 03:55:58 +0200
Message-Id: <20211010015603.24483-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document qca,sgmii-enable-pll binding used in the CPU nodes to
enable SGMII PLL on MAC config.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index aeb206556f54..05a8ddfb5483 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -45,6 +45,16 @@ A CPU port node has the following optional node:
                                 Mostly used in qca8327 with CPU port 0 set to
                                 sgmii.
 - qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
+- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
+                          chain along with Signal Detection.
+                          This should NOT be enabled for qca8327. If enabled with
+                          qca8327 the sgmii port won't correctly init and an err
+                          is printed.
+                          This can be required for qca8337 switch with revision 2.
+                          A warning is displayed when used with revision greater
+                          2.
+                          With CPU port set to sgmii and qca8337 it is advised
+                          to set this unless a communication problem is observed.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

