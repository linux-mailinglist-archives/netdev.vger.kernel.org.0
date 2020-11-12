Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043CC2AFF1D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgKLFda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbgKLEuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:50:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1C8C0613D6;
        Wed, 11 Nov 2020 20:50:44 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id m13so3128930pgl.7;
        Wed, 11 Nov 2020 20:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eniRCWFhhLp57ABY9LHMR46rczpjtwBpvSFDDM4wFn0=;
        b=IgdDDDJVhoRoJjFFEGIF6DsHTQwBauMNrGWLRFOcZCBwvljI0wvyXYHrLQjVNhGLQb
         KzpC2NJaRxaOU2ioSrr0/+SKR2Fbxhgw9O9V/eKs/b/9PQSwo7OpSOmFV4TA3GPeZerd
         v05v930axbU5H0fTNjpxSWcHrK1pLQWQoU/YiYDI6hXddzrdNpe3dqFH2wScfeRcZi4y
         WP83Ma+uBnu2mVRO4phyRWyayWxQbAyn/Notm8Ap32tVEzzNrK8avA8QhqIHO6Z/YzAi
         ByTju4/uWC1YmHKondib2Nf9n33UQKCwb4fMkw5OBmtACrjceC5B0B8CqECgom2/dYBW
         ZXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eniRCWFhhLp57ABY9LHMR46rczpjtwBpvSFDDM4wFn0=;
        b=AAaikJE9HMTajHO3kwSEw/3P8tFkgbqgyVb4SRLPawGG4J9JwGo4RoN60UtypI4d/4
         Iu9AbLmGhU+XDjh3aooLefhNNA9ExiLZ/XwJVB37wMQuU73oPaD7PxNa/7ncWREworvS
         Q1ahQH4Lsr86ykwGgdUhDFSs3viBHOuPMY+4ftKIjSZmysTIFbCxhKwaSxkHj+BJNgIe
         jI4vUmaJqsO/7cs2HAE3PDenY/A916LL3KxRKY+E5KJSVwLCFnFhhwRPO3bF0HP6Iyk2
         eXTJE5x+UlKzuX/UOZXVs5ygjhi3SaNQNmAUVEwmgVd20UPNM6sJVhAF0SyTep4tMopo
         80aA==
X-Gm-Message-State: AOAM532L8yzlazcUJ79uXSSxOo96K0WFGOEx26M+hS2fHMgTahWaAOWS
        snYbi3oDgoONhRmw7WLHsSA=
X-Google-Smtp-Source: ABdhPJxsNaBbu2AlFZIuHfyC7Do5e9y/cuET8ZnsYSW6IKwcTnFY1OiG1lETKwfx9OPb6G8iYBo7OA==
X-Received: by 2002:a17:90a:9916:: with SMTP id b22mr7157951pjp.59.1605156644216;
        Wed, 11 Nov 2020 20:50:44 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:50:43 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH v2 01/10] dt-bindings: net: dsa: Extend switch nodes pattern
Date:   Wed, 11 Nov 2020 20:50:11 -0800
Message-Id: <20201112045020.9766-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon discussion with Kurt, Rob and Vladimir it appears that we should be
allowing ethernet-switch as a node name, update dsa.yaml accordingly.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index a765ceba28c6..5f8f5177938a 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -20,7 +20,7 @@ select: false
 
 properties:
   $nodename:
-    pattern: "^switch(@.*)?$"
+    pattern: "^(ethernet-)?switch(@.*)?$"
 
   dsa,member:
     minItems: 2
-- 
2.25.1

