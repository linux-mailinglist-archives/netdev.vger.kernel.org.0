Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A95F42CEA8
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhJMWlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhJMWlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0EEC061746;
        Wed, 13 Oct 2021 15:39:35 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w19so16618406edd.2;
        Wed, 13 Oct 2021 15:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=Bg/JYATZiWLSesz4ZnB5yS3dGP6c8znY78uDiA8fEz6/+Pv0T+hC6ar3MrP4NpIc1z
         /PyLdtZ4b2Pu7DezTS/+ln1FLNhXTAm/2PrYLBEs3ax1Yt3USskzc1Ycum5g3y5KuLs6
         czEGZ0n5Lfmojotjq7YSjI7xV/DpFql7COMquv2g2GZ1N+uL+beZiuf5XDJBjYT6gaLF
         jCcHo1M61ZI7MuZ6JjFET6go6TFz17MTBhY4sRPe9ZxgNbkXTQ4gP/ME4u/m87kifkbF
         /xAc1cn40ADVa9RNyVrhT9TNtwKXZqj5QHQLraYwuSqBKLbvQAQy3q1HMTGDAW/xek0V
         BaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=gJ0xjb/zseMiwoyibZc+cDZOKU4RkE7JmGWVn4X/3nbzLCOv+JFhG/vlwNMl/9AR0S
         WOErzZTkmMFFy5+jFe03Ozc/Y2Pg84TCA21hD1VGK4b+wF78Lrc6CdqkPaAf2a6ZCTCv
         qe7uSsQzAky0KBhUeI4VbLlq0ycP3hrVrn182dcYRX6fRTCLxhmVXpZ1l8G7GEWV75jz
         1kG9rkg3+pgVFjtC9eaxLPcUX1c8vCAocxM+HU4NubjdbiQigc+djK5YBcASzA6OgLHV
         aCoMqtpMC2P+RE65EIRK+pUrRaiRa887IOqpHE+HnKZtUYKDmHAjdDe3aAbIqLE2vCsC
         iILg==
X-Gm-Message-State: AOAM531kSbWW1n7KeK4ofT9GlUwtkKj1y9Qf1v5BkLP3T8gZpuBpzXqj
        WSglwfuxEgCzfgaWwQX2Hog=
X-Google-Smtp-Source: ABdhPJwwnDzxgWImUhGfEpphtuN25j41hM2E8SwZ1bUhxRPHIToNv0oryYWABQKE6NvBxK/6e3XCuA==
X-Received: by 2002:a17:906:b796:: with SMTP id dt22mr2346328ejb.456.1634164773976;
        Wed, 13 Oct 2021 15:39:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:33 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v7 07/16] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Thu, 14 Oct 2021 00:39:12 +0200
Message-Id: <20211013223921.4380-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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

