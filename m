Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA6A46A337
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbhLFRpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:45:19 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:36362 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244538AbhLFRpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:45:18 -0500
Received: by mail-oi1-f169.google.com with SMTP id t23so22853792oiw.3;
        Mon, 06 Dec 2021 09:41:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9AfD5dtJAGMw4/58KHugg0lmexdD4Jfgcey/X/Q75WU=;
        b=cx6s0N9zEXx7zj+Yu43Lol9Lz7yBquSBbWwZqIZEyp3INSUPQpzaCS93CyT7yuigB/
         HlutBpkx31BJGW5qH0yAuYppSJG+i/EjnQjSbLELBxLLJomnwzfADNlzTN87vShe0R8J
         rChFvARtZ2p3fwX7bfqdvZ2PGrG5PBR9zX3su3hV26YBId/DX5Ct5NrM6/DJq8BHp23E
         5Ynl6HxwqDZX0on6Pgnc9LG9Ayci2i+odHO9Wmbv1+uiZRp4F9FwT5dduXZEU9auqHtM
         2DE87Ud1zbgR/lqPsOVZJACwtKePgCwX1usbGgoOPxKNsQ6QridIO3D66qPvsD5KC7FC
         TAxw==
X-Gm-Message-State: AOAM531g8qAGkYqKat/gQFByEn7aqtsj7Lg2LdGYVhuKs2W+Zp8TdL4u
        xwDkZXeHSrLXa55/mSJHyQ==
X-Google-Smtp-Source: ABdhPJzi/ryRkEuy/DOqoCJZv47XAma1f41in9AMJ9aIjUHNcIz6n2SpCbT5RoOBx+t/yxtNX6pS7A==
X-Received: by 2002:aca:5b45:: with SMTP id p66mr24746740oib.9.1638812509312;
        Mon, 06 Dec 2021 09:41:49 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id m3sm2358065otp.6.2021.12.06.09.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:41:48 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: snps,dwmac: Enable burst length properties for more compatibles
Date:   Mon,  6 Dec 2021 11:41:47 -0600
Message-Id: <20211206174147.2296770-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With 'unevaluatedProperties' support implemented, the properties
'snps,pbl', 'snps,txpbl', and 'snps,rxpbl' are not allowed in the
examples for some of the DWMAC versions:

Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dt.yaml: ethernet@3a000000: Unevaluated properties are not allowed ('snps,pbl', 'mdio0' were unexpected)
Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@5800a000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40028000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40027000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.example.dt.yaml: ethernet@28000000: Unevaluated properties are not allowed ('snps,txpbl', 'snps,rxpbl', 'mdio0' were unexpected)

This appears to be an oversight, so fix it by allowing the properties
on the v3.50a, v4.10a, and v4.20a versions of the DWMAC.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 7ae70dc27f78..1d67ed0cdec1 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -326,6 +326,9 @@ allOf:
               - ingenic,x1600-mac
               - ingenic,x1830-mac
               - ingenic,x2000-mac
+              - snps,dwmac-3.50a
+              - snps,dwmac-4.10a
+              - snps,dwmac-4.20a
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
-- 
2.32.0

