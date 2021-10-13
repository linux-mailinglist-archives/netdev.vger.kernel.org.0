Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA21042B22B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhJMBTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbhJMBSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:52 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972CFC061778;
        Tue, 12 Oct 2021 18:16:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g8so3164416edt.7;
        Tue, 12 Oct 2021 18:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Yc2St6vhIr2LlU6gcnbxLVeVNItrvzMXlTgzpahCO5I=;
        b=mgU88UaN4hTIBCf8oOcXmmbMFP1nNyVLqHogsPEIwK7CxZdYuF8K8m/UMrZlNgHZW4
         ZBCbmJI7mrY2MLB+3zsprbgzsn3NOkNLrJAomSZxnNbw7W+L2IUGjt0WH1YtlX/mppHd
         8SYcgPXxNsScJJdw45nBD1PJrB7Qh5c+Pp8ao40lvNH5X3AJQ5blJRk7bwqVWLZ8TWId
         gqfFX1OrmfjZkQwMeVaOVV5MJ3av3Z+RJARIIz06XxBRgry0RKLAgXU880eDU/tVUjw8
         Yfb6TAU0mAnOx88S5ZfMebDPv2LtH5qvvjkxXBWxSPZ11JK4lcTjjFW9c78TvrSYGx3Y
         6kUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yc2St6vhIr2LlU6gcnbxLVeVNItrvzMXlTgzpahCO5I=;
        b=hWMuy83yKjUkLql4o9I7C2aXk6i6AKKyf3JTdDbE0kwkllY27sVilKOAba4VlDm20V
         9Z42oGZtXhTyKvMqZ2jrA6YY/xqzINqyIuUBOcBoctHyz/ae//tl9a4AFpAte6/DFBg8
         xyqN25hly+XbkamWIy9uBA7oLvymuil1XBJ1LL44piolfJ1/ZnTpK/4kKWz10TpEjQ7x
         UjURIxZ9yv0kmIBq/ZgX2x0B+//UQ4Eq13llICr7JkopADrlS1oPTfJarkHLMmJBZo4j
         vLANSOJxWdcsNGyNeEiNJ4bN/612mtAdnGetg4iMeAB/DObjJQRosjfaDt8gmtab4z1X
         Ls9g==
X-Gm-Message-State: AOAM532HQw8Ax6LwXIvN8lmZ8Yh/sTi9JWPX0lwjPmgWQBtU6WCTAmkZ
        ZMOyLhERScuPaMNIJ6son1M=
X-Google-Smtp-Source: ABdhPJyoO+72Dao2dN6ru0Vyn1ZgaxVabpAdLnhgZjSJg76aLMvxnYQlHUgyepbF/3mzSyBBLTU+BQ==
X-Received: by 2002:a17:906:4f13:: with SMTP id t19mr37482624eju.53.1634087805123;
        Tue, 12 Oct 2021 18:16:45 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:44 -0700 (PDT)
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
Subject: [net-next PATCH v6 16/16] dt-bindings: net: ipq8064-mdio: fix warning with new qca8k switch
Date:   Wed, 13 Oct 2021 03:16:22 +0200
Message-Id: <20211013011622.10537-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning now that we have qca8k switch Documentation using yaml.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
index 948677ade6d1..d7748dd33199 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -51,6 +51,9 @@ examples:
         switch@10 {
             compatible = "qca,qca8337";
             reg = <0x10>;
-            /* ... */
+
+            ports {
+              /* ... */
+            };
         };
     };
-- 
2.32.0

