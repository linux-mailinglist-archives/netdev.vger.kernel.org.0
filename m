Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AD34284A2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhJKBct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhJKBco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863B4C061570;
        Sun, 10 Oct 2021 18:30:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p13so61742031edw.0;
        Sun, 10 Oct 2021 18:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSbsp53GPbC1UoykdeP64z97Nxwqf8jxKnT8asaP0f0=;
        b=AKecHy93CtTi0egnZCkRjuw1VznyO42ClQNwpw5PmRX/6zl3PJxZR5GxLgEgVgtrlX
         fcpyoUmeTIPubMjLuHXYszdz/9+YE+8Dq3mGydLHCXg8koJ7WCXOqJqyGq4gxl8kkN5x
         FI+qUZVP7sj+ybB8gQ44eCdZnPbwB+Y/vN1bPWTpwNB04i/kC2it5VjAWH66I0CJyrlS
         /KL4u4mnGmTS3vUK/VOCicSWOs69BccAHsHbTFCC/RAds7Gsklc+xkFqp9+pjNaE/Yyd
         Lg5SBeUKPX7/g9qmuvYv4yyOpU+XLlasilkktMmBCiko28fb03xECqTE1sJ2Ru5wuBTT
         Rb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSbsp53GPbC1UoykdeP64z97Nxwqf8jxKnT8asaP0f0=;
        b=PwX+/cOV0lm3BFhG7l8Jz0XEtiLg4H69Ju3PmKwuiTVB3hLP3L61KmVftg80RHRlLY
         bxMKI8neCnd1gzH1Prt4800rFbcRh7EMURB3/tlJeHeh5GO16r58vNAGWLNY/m+I4fCQ
         SWpzX0jsHvoaowAZInaZgInlLId0cqWX5C7uXjAvR/3e5jcDODhra6Lv7dJe6bISYQr7
         puQd7A/TGKPqS8PLNQ6Qvk1WTLIhRmRhTemVGoLscMQ81RMmWoU4pbqWa/9HJWJ5secU
         6fFrUbs5vBzDR/srz9a+G/wXUTNtZurRFAxKa5DKT6ICid4VN23Gqngy3WV+CCv5oFio
         /dow==
X-Gm-Message-State: AOAM533NPTClEXQV/3qaxyP5MThwWiMEucPR+BDB1QSZwfhmDf993oQY
        HLCHwGJ/0ryHv9xc3n85UMc=
X-Google-Smtp-Source: ABdhPJySKt2mUbNjAH3EXTu/Y7LjusBnw2P6Dar4SibTeY+kLIOqgmqtbjb8aWMVjFyeGzcAHCwDLQ==
X-Received: by 2002:a17:906:e104:: with SMTP id gj4mr19889285ejb.358.1633915842984;
        Sun, 10 Oct 2021 18:30:42 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:42 -0700 (PDT)
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
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v5 02/14] dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
Date:   Mon, 11 Oct 2021 03:30:12 +0200
Message-Id: <20211011013024.569-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and descriptions of additional PORT0_PAD_CTRL properties.
qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
phase to failling edge.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 8c73f67c43ca..cc214e655442 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -37,6 +37,10 @@ A CPU port node has the following optional node:
                           managed entity. See
                           Documentation/devicetree/bindings/net/fixed-link.txt
                           for details.
+- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
+                                Mostly used in qca8327 with CPU port 0 set to
+                                sgmii.
+- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

