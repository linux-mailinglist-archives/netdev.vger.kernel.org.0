Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDB242B1FF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhJMBSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbhJMBSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:39 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8297C061765;
        Tue, 12 Oct 2021 18:16:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p13so3402435edw.0;
        Tue, 12 Oct 2021 18:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=WFCv9qQ4u70m/yXgNjN7khwnB2IFMG6/R7Lilrm70C/NwEuggref0+Mg2OqvrTzG+a
         56E1WTbZzP9vVjhN/3U4/0O+8lzBIgyTjxdFG3H01HgCpi5WKzPE64QsjIFJc9b7KXtA
         Ae54UGygfLGxd/UQEKhuMWqGqIWAH2pdltFef/ATOsK/HTrwiRIZTkJ4fswesEmoPyfd
         NYuqY8OMquJ4mreoRwSTRr17R4IiMI0ZG2LLnwzj+WZAiF2uSQa7fJ2jMXdQmXt7a1u1
         hPfqC5QSg6jUZNDK8CuIGP1mtka3URqFE/lIlVJpK1HdyCGG0MDR40ycKnikTDPl5D2z
         0ueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVZTOX5p5oDFXWjsRtvrNcBi7SCHD7eFTAWryiBFY1g=;
        b=sbeNhLh+fa9dtrMhJSgdg90o+RislG1b6xlX5GOuc+B20QBH0azJbQlLQnthlXgDk4
         lN5BCTN6ULHdbb/2ZbJuHTmWfBYohP5nQu494NjGrY79lM604MIFwkSrGg+EazORxKjs
         7pfSQcyr5jCjTNghwzieH1Ztj6xdDW1Cl+fhfcUunfKZNxhqlljsBmJpNgO+uIG9jleN
         nBO70+1vGs8CYCGFdBkQIs7AlG8Zt2GyFqNu7epuqTrF6QhHKkzFzBfHh/cGuf+ZsgqT
         W8HSHBTa0jsmVhUkkdVEiI9AZKWhVPHeFtlEhTHtnu+Gr5bCYjSYLEWBsVPSE/Ajjnx1
         du/w==
X-Gm-Message-State: AOAM533vS7B1OP0RUmmfNWyIjy9byjn8nRKJEHIqzJVKA+9uX21wSJmf
        2RlE/XC63wX9SpHVEDoSTeY=
X-Google-Smtp-Source: ABdhPJywULDnSsKE1V9io1iZ2wYTmLwlYtG/30dlivNpqLIg7mTZYcT1MCbMlZTg1g0Gwy7SKu5qRg==
X-Received: by 2002:a17:906:ae54:: with SMTP id lf20mr30548212ejb.195.1634087794377;
        Tue, 12 Oct 2021 18:16:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:34 -0700 (PDT)
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
Subject: [net-next PATCH v6 07/16] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Wed, 13 Oct 2021 03:16:13 +0200
Message-Id: <20211013011622.10537-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
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

