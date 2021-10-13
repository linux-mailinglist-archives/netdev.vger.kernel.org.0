Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEBF42CEB6
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhJMWl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhJMWlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D880C061769;
        Wed, 13 Oct 2021 15:39:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g10so16518443edj.1;
        Wed, 13 Oct 2021 15:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=I7/2mOCuSGi00O37dYhVmntD5IhCZQlkid+4wMza39o=;
        b=Ts6bVYREMDstVsvF8PsQ53MBVx0VX0pJIEL1gJLXAuOscwY40xlyhsGhKs4QI3jpBK
         SJaBsDwpiMZKKyJz7Y3/g1+E8q7EsndwksqpLYJZGP0xhK6UrGcGs+kaCG+PXu+U+yIF
         8qtrUNDu6brxg2WEPDxxvD7ZUTKS239TjBJDflD0JYh/gb5u8MUMU29pZS78CfE3DiMY
         OQoihnzSG12MgbhDetJ3MeQz7uvknlH+bCH9jHUroZhcqm6Kog41WWMrYnJlW4YZrZfb
         PrB+I5W51uW5NVMPrqUVlomPo/C/XAtj/A5JQXk/SLtO898ph9bkF1CFFyaRyXFCiNxj
         GVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I7/2mOCuSGi00O37dYhVmntD5IhCZQlkid+4wMza39o=;
        b=cUImlGKbAxpIvFpjtQGBgLQFtFFDYSEAX8aOZSZZ0Px1wEhRJ8+9dMv1vtXFIElF9Q
         qufMLHtbA5P3Mfry4dJmAFawbdxFb+6z3FK9wMRjqXRggTreS6G+f0ikwem93QHZj0hT
         zz1bMFYfvc234XJEl/383ts4e8IjCtpQ3p1XORT35RpflH/4tfYbUkt6ZrU2XFo6XYtE
         OYaLr3MuWKicWtsjD9/TUUY1qwcxD2XrB1Y5jYxERzGisplS7rZronWIRtOkVnkxJGL5
         3vafIUZp5zsvUXTq1DUws2joVwYSrralgo9Ggs/1/e5GY57n8e1NASlbuqdyyglb0lbI
         fy2g==
X-Gm-Message-State: AOAM531mju00cECYnt7IVG1j/ZZRLnxvFVvQmRT5o94DmCNv8oZGUNhJ
        8opwlq5l0xYKyMmvG4h/zag=
X-Google-Smtp-Source: ABdhPJzQXZOENoeuC4YF7vpA5T3Cs8cbRDNGziCMaEvK7UawMrKdbW0QshU+EdvCoCiyDBlTo44wug==
X-Received: by 2002:a17:906:f259:: with SMTP id gy25mr2384556ejb.210.1634164778662;
        Wed, 13 Oct 2021 15:39:38 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:38 -0700 (PDT)
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
Subject: [net-next PATCH v7 11/16] dt-bindings: net: dsa: qca8k: document support for qca8328
Date:   Thu, 14 Oct 2021 00:39:16 +0200
Message-Id: <20211013223921.4380-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8328 is the bigger brother of qca8327. Document the new compatible
binding and add some information to understand the various switch
compatible.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 9e6748ec13da..f057117764af 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,9 +3,10 @@
 Required properties:
 
 - compatible: should be one of:
-    "qca,qca8327"
-    "qca,qca8334"
-    "qca,qca8337"
+    "qca,qca8328": referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
+    "qca,qca8327": referenced as AR8327(N)-AL1A DR-QFN 148 pin package
+    "qca,qca8334": referenced as QCA8334-AL3C QFN 88 pin package
+    "qca,qca8337": referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
 
 - #size-cells: must be 0
 - #address-cells: must be 1
-- 
2.32.0

