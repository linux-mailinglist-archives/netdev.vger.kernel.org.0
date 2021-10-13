Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE5142CE92
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhJMWlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhJMWld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:33 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8E2C061570;
        Wed, 13 Oct 2021 15:39:29 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g10so16516920edj.1;
        Wed, 13 Oct 2021 15:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vuCloQf4zkp+Q+tehI2QaaOLbGg4OF1X2bYcV2C3N6U=;
        b=k0RBxURtg+WoiNkubNlTGYR6oqetn4yELz+CFdgWEqOF82fETayNiyVYowk+bswPYK
         SKagldouzL3QIfouLN/Yo6XuGofueLXBHw4Eh7PBsR5kR5YMycnTnpIyo+bgkymMPI+a
         1JU2FPIivfHsacx2jtwFNRPkY/jsc77w+0oPZqkY67G8rAAhjiDKJtfG8KSBXGeRd5xT
         d/Xjx5SX1JEUMUoOmWYajMnTJ73ZxomZIB0cKRb74ZIIgJ+teTGzuAcG65FrkT41+fZq
         RqlBOG24H/CCkLLXy9rKMRSwNnWvmfbaFoHwpC8Va28KNF/8QVmw8zhafk7DPlGONVQL
         5IJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vuCloQf4zkp+Q+tehI2QaaOLbGg4OF1X2bYcV2C3N6U=;
        b=QJ/fACSSnN8F9iAPY99HW3qcC8MgyD6IYn0tYYpjOa3HM+6641GxfWKTCUg+RIlIfF
         YT7ut3AdMb9EjrXi5/dNBsXKBTVZyVit+VqhnBKj1yFf6TtIFrczgM40vH0Bz9FOY4gh
         ZYFM0yOq5xjx2rQjxNjdwQlCoqEhh2INxz9WbibQQMnJ/M8v9X85QEd6El/ndg3N4svI
         fBdDf8YQkLJNznDnR6L/NxOA2HKNAjSuwhaMOPrvFx3vd6LoSgIfdc2q9EpeUY/rhUDF
         tOY5ZOI5uSZP/E7n2yp6TzQLnVWzZRG/AV+/HWCDjPiIkp4F4L45mvg1X6TP64d0yZcy
         rpRw==
X-Gm-Message-State: AOAM531IaVfKmDiG1hfNVKkUJedLFmAT9snsD26rbo98IBIERT5pjIWG
        x8cGjA3K9GwtFkenOQvoDkY=
X-Google-Smtp-Source: ABdhPJyvqaNimwONGHJMMr6KQA5iGun3j38ybf97GoRnWgIpbwRVSGfUWS9LIGR0vEI9xkdK/60Vfg==
X-Received: by 2002:a05:6402:26c5:: with SMTP id x5mr3130765edd.297.1634164767944;
        Wed, 13 Oct 2021 15:39:27 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:27 -0700 (PDT)
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
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v7 02/16] dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
Date:   Thu, 14 Oct 2021 00:39:07 +0200
Message-Id: <20211013223921.4380-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and descriptions of additional PORT0_PAD_CTRL properties.
qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
phase to failling edge.

Co-developed-by: Matthew Hagan <mnhagan88@gmail.com>
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

