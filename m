Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65187465461
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbhLASAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351986AbhLASAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A591CC061757;
        Wed,  1 Dec 2021 09:57:04 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so359066pja.1;
        Wed, 01 Dec 2021 09:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8eVTKgQ71scTCdgvnAxinAjRWpK2tMB1hMCFM8SGqY=;
        b=TJLygwWmFT3NFxoArSaSrPF6hLheab0+03eo//cCfOFTrQ8w3Iwp32rQWcfu7DY/yj
         EiRlmHgya2RcZw1wSLELTvVT4Ra36K07EkrClGoMAS1tujMvDS1FjnbfeWw6CDFjjE3F
         riWoM//EDGe2YtumDOJX9b7oLSahBs2oTauJdupYwAfg6DtI4j8lCNOWSJS28Y6ukxbN
         r81aj/A0AIGWZJXcHMTNi+xDtjJ59NoqQ8vkZ2xSA0Y0D8xjI+goBiECqKLsf0yOurBA
         dE575IYVPMV0ofy7z8qjzibFDA8yej9rF8I3ZxYGDxNySr1p0i6zqDjmnl2fDCORxaoK
         EAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8eVTKgQ71scTCdgvnAxinAjRWpK2tMB1hMCFM8SGqY=;
        b=aJOLpL6tvHr76dFis2GeRs7R2JZe+o0ZSlpVfqoY6W/KKtrhLvsdjpwTYwtbezGP3J
         SyDMZqW9GChhNnGz0c2QHw0J5IrTmZXBPv2HJ7tXchXfa2xL8Xjief1ChXarm9YWWrpR
         408nCDWIaK7BK7seF0sXYv5FoQI18X/JHZL0/CbZToANpdzih+uPcqUtnKTxSQ3XcKfy
         2RJNHE1lLn72VGTIFL8TnslrGA0l/vStzHAEFhqDmvXHGTlrsw98/fGwFizZC4J5z4wR
         Vc2yx0OuZBXD6TwP14qTfVGZmOzaiWre2x4NPlK8bg/gYIhh5xkduBZmWci901bsKiRI
         8lwg==
X-Gm-Message-State: AOAM532lo5KoS+y/XqFEya2TZqwbJhHkMSv32yGGyk/HjmVt87m++7nW
        KO754IYQRMwFtrQwQZNzCp4XqEu3G0g=
X-Google-Smtp-Source: ABdhPJw4UuaplVy3jWIzuUmvxoeX1tlKubQUfKWev2QarbPvf2tzDlr7vy4BsUp3eOod9oJVmG6kfw==
X-Received: by 2002:a17:90b:4f44:: with SMTP id pj4mr9540173pjb.150.1638381423834;
        Wed, 01 Dec 2021 09:57:03 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:03 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH net-next v2 3/9] dt-bindings: net: brcm,unimac-mdio: Update maintainers for binding
Date:   Wed,  1 Dec 2021 09:56:46 -0800
Message-Id: <20211201175652.4722-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Doug and myself as maintainers since this binding is used by the
GENET Ethernet controller for its internal MDIO controller.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
index cda52f98340f..0be426ee1e44 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -7,6 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Broadcom UniMAC MDIO bus controller
 
 maintainers:
+  - Doug Berger <opendmb@gmail.com>
+  - Florian Fainelli <f.fainelli@gmail.com>
   - Rafał Miłecki <rafal@milecki.pl>
 
 allOf:
-- 
2.25.1

