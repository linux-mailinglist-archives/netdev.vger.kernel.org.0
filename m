Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADA64280C4
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhJJLSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhJJLSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7ECC061772;
        Sun, 10 Oct 2021 04:16:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y12so42358015eda.4;
        Sun, 10 Oct 2021 04:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=OdEidwNeuVhKRS6JJiMDsIPOhEBOsdIgosNM/mE3Jvn7TG0W5f5E+gAqCvFQ5Epkfq
         Wrr9EYJ0pfPYvNDcHb1kRn6XevsLQvFf0vh7cykXar71a7srhZCT5KMabXvoo11BUAqO
         qP6QTFYLW0vHP5NsKXHWhHVgjCPByd3LsnXEcnQt8OSfT/G2Qb4EyT3CtE695JjMx/Bo
         DCWFvyaUdpCqMTyspTJi5FfyPa3obx6lUpsxYMMqiySr4vVE4giFLD/qy0H729gr6Fj0
         Y8k1woYqV4d2g0lE5UrZBf0sPzWFXeNi30g97W3lAKbY26eYkVTfbTDqDXZSyUDguCqa
         34Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=3QZIT288GaaIz8EXDGaD7TU3fAW/+LqmN6xfpYu9ApY9nWpBWDBoXl4BTKobWoH0nO
         5Y+oksX9KkeB6+FFTWdEpgV3AtWlKPUKOmrPOogzy1OS3mrKMY+29lOwaiNWdYn8mRZI
         BG/dHHgabygxdKn8pkG4TuTGg5AkQdmdZ9dkHLWdVZqo9yoz8MNGl3mV6QTR5HqRIzkV
         UvSRC30RG321rLD+IpCkwStykIiRwPh2Fy2caq/d9+qBYnaO8xi6evklFS1of4ZCD/X+
         bK6hrSbUmnSBp2oRBPbSOsVwDibB5S8m9B2s04uwcUkGDPxuV/kP8Wee6wkmJrTx57+2
         7tww==
X-Gm-Message-State: AOAM531NVhO0lWTT37Bq1h9WdxhAlT5iNEY+fJjPY8Km9FW93u/n0Sif
        MAPGyax/KxqFZCtCWilSuPg+pYOQH6s=
X-Google-Smtp-Source: ABdhPJw7+76Vjd4ZxzHyWCuRJ6UN2qRO7il4O2dsjvQHv4kJ8nF+V2g+ELN0WwOFLD9WWsVGyuBIlw==
X-Received: by 2002:a17:906:1945:: with SMTP id b5mr17579598eje.347.1633864574220;
        Sun, 10 Oct 2021 04:16:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:13 -0700 (PDT)
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
Subject: [net-next PATCH v4 08/13] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Sun, 10 Oct 2021 13:15:51 +0200
Message-Id: <20211010111556.30447-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
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

