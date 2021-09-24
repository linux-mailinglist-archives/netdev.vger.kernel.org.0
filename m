Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D043417D24
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348615AbhIXVqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344410AbhIXVqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 17:46:43 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732DFC061613;
        Fri, 24 Sep 2021 14:45:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gj8-20020a17090b108800b0019e8deab37bso2150158pjb.5;
        Fri, 24 Sep 2021 14:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/7thBtiFxBveRQEidg5D1xv7aHxOGwL3MpL4sZxKG9s=;
        b=BUiHYCg7d2KQMyCmiKxmTwau4pkK5OLeLk25oWbbtUr52GcMYDxCVNMsc9BlDSushx
         QGuh215qDMwvG8I2FGtLNzZGwTofYEc/zontjWxf/ui1dzVAzb7pErzwr3pi9B3CbwzV
         y72U/h3qHf55kgLm1Xi6nqrJeDxvPnWc/wKKSo5CfV8ZR9eKVzsbkv3e8PDILmbqYX3X
         J3oEA+4Xw+wHjtCpmpUKE1GYmMvTZsvPFAhDCy+0Zy1blvk0dZM87qDMMlaxUeqq2puf
         QGOl2xwoVuOJH3Yt/YY4N53NLYqC3iLbk17dVvz/JgbhqtAKcfdiot2PJl1MYWQIqpdX
         QcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/7thBtiFxBveRQEidg5D1xv7aHxOGwL3MpL4sZxKG9s=;
        b=qTATt3OiGX03SDmMZ1dPwU+tXnm39pXBRdujwLWN+nQnghaSaPwiJIh0ERsLWERx1c
         /H6aAOZ9WQLmBD61Y5GiHPJHAgg/GeLKvdNdbURbDi7ODnYoqKGkMtDcrY3D/AiTDqxF
         BM/l3HvhS0PlgWI5KfwO+JIpJ3upaii45g/WMPk+Efl0O+wPrxHpHcUhPwa/+bG3hlkn
         sPcOOeGNAT9Ug9MtBV7fs/vyZBmahU9j5ODLAYHDUG5BNGZLcA5XvTsXf2LRs6Ch7T0s
         0hkWyTQfgaI+RXdoQUJ6lCVHHB3YkqEtB5LG1LUDKlL0zL0c7MX1jjxq2JNKlghvMmgZ
         Q90w==
X-Gm-Message-State: AOAM530pnhElJne+KANrM8blrGLK0Ssb7w/W/WYZBXvSbMPmExT/Eg30
        6i59D/s17QJ18Twp5bSgN/TIgBptttYVvQ==
X-Google-Smtp-Source: ABdhPJxaJcDYyMdYo8ayqsa6Od0sqf3BN67AAF8xDoV+dzkNXnrZupGzbxhPWCm3jBJgdhRqYI+kAg==
X-Received: by 2002:a17:90b:3685:: with SMTP id mj5mr4800359pjb.222.1632519908620;
        Fri, 24 Sep 2021 14:45:08 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm9842029pfn.142.2021.09.24.14.45.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:45:08 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: [PATCH net-next 2/5] dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
Date:   Fri, 24 Sep 2021 14:44:48 -0700
Message-Id: <1632519891-26510-3-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ASP 2.0 Ethernet controller uses a brcm unimac.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
index f4f4c37..02e1890 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -20,6 +20,7 @@ properties:
       - brcm,genet-mdio-v3
       - brcm,genet-mdio-v4
       - brcm,genet-mdio-v5
+      - brcm,asp-v2.0-mdio
       - brcm,unimac-mdio
 
   reg:
-- 
2.7.4

