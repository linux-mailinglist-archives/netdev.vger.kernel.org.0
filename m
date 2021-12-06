Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6695246A3A0
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346375AbhLFSE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346166AbhLFSEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA9DC061746;
        Mon,  6 Dec 2021 10:00:55 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id iq11so8320389pjb.3;
        Mon, 06 Dec 2021 10:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8eVTKgQ71scTCdgvnAxinAjRWpK2tMB1hMCFM8SGqY=;
        b=okjDkCxyI/nn21Wnpt4nbTNJYmZ5d3WZ1W9wjxHEwSTr8AVMrzCy+bS4EGFyoC4Wzj
         PZsr8skIoCwWNyVG3rkcOtFpySG6kY6Dud7efUYRww8ujsAtcRT67ifW9PicjTVqsyff
         ibgk3KfUrLzTaWPBWT0BW8iZauquv+0+5X/Euoeo5KvPyXxyRpPNsP1Vsbp+/wSGKFuc
         IrixDjbg20zGjuEGu/DeNpfixI1Yt+bJlynj49tvk5yLCnfhDFpDk9y50IUIWvizAnuD
         1/80sjPAVDcSoyrFJDv7esFff6FbeIU8SpR8jnQgKf61ulLivaxmd80YqDGEAw5lWmR8
         n1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8eVTKgQ71scTCdgvnAxinAjRWpK2tMB1hMCFM8SGqY=;
        b=z0EibFGtl80GXg3Ch+6i0jo708INuurSIcACkhJJwwBRE4oZXX9b/EyHtiCZ2PmvQC
         2fXYAvWZckDbkb0YNdRCY5SzLoyVXs0msChuNYGIXCVbOaLm9Rb7J7/2RWiohFKGv7Ic
         bjcRqbnO6natZjN23BmcZO2CFs/wMjL+/pmnoqd229R8ngCFSzZYQ6JwKMutKTsq5LWg
         xi8Dj8impR6OLXFoWEsC6bCSA8xTe6YjGo8C0WlM5xQEZylGLipELKsSF2qVFjGHYXvN
         +GsfmTTRUc+stxYqGQkf3BFipPY0gOx1Y0F4duJPgfhZkh7Oz6V61yY0v0B/WeJkJtwg
         Jejw==
X-Gm-Message-State: AOAM53226kHEmTOAj0Q8CUNpHT19iP82W7BuNEf6MbnjfIkzHBezfDSp
        zEJ99uHK1E8KvkIc6KugAB1Z0PuQVb0=
X-Google-Smtp-Source: ABdhPJxRcvSEAMxa/zZAF0moxM14eHcIV7RVRP0bkAR0Z1M1lwu0CF2yEAKcZqA0ICl8+9xvj2tFrw==
X-Received: by 2002:a17:902:c145:b0:142:50c3:c2a with SMTP id 5-20020a170902c14500b0014250c30c2amr45116624plj.32.1638813655037;
        Mon, 06 Dec 2021 10:00:55 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:00:54 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
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
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH v3 2/8] dt-bindings: net: brcm,unimac-mdio: Update maintainers for binding
Date:   Mon,  6 Dec 2021 10:00:43 -0800
Message-Id: <20211206180049.2086907-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
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

