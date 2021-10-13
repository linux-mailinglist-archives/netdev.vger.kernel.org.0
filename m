Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB4D42CEC5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhJMWm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhJMWl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E28C06177F;
        Wed, 13 Oct 2021 15:39:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id a25so16378355edx.8;
        Wed, 13 Oct 2021 15:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Yc2St6vhIr2LlU6gcnbxLVeVNItrvzMXlTgzpahCO5I=;
        b=PaKo1eNEIvomGIzDvqSaeM2qjEKApqKDr5SvzHHxFgI904/pb84cz2wXLninbXnY0a
         2vFv7CovA2AZXVaGFmUi9VLom7LgZg4wn2pvSLeifmCIVlprrJng0+RobUh3q2vDUJ3X
         63bV07oW7KUPGcDklM9hHe0VC/HV9ihUslDZjRnLv4q1DKTqWYw0APqW0PU7WwQNUe0J
         3Q5PBQsP3uUYdtgoPCsO254oQE+s7XcvZ0bXmNv/qP5vEL5m3Mhg9SjsdS00s8Tz/hML
         FmLELQMZZakbINJKf2QN9KhaqV3gh08ESGNVmqyI3TPsN5E57K1eyaDNtVMdJMLkfEH4
         jOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yc2St6vhIr2LlU6gcnbxLVeVNItrvzMXlTgzpahCO5I=;
        b=nkAgWQpW8XXRaUm3CQide4iVzMFBAsZ16ebu4rel0uRsPCEs5JhB/oKRzMqrNKADNM
         Vpn+jJtDtC6OnR8PZWNdVCqVEQNHAM5KMm80jMgz8V6w9cBjY0Sw+s7/KoIFMJyEMVUW
         P3n9vlLHtcAtuyTiLhmXWJq6Pt2YKI8AAg9jXIh8ryq46j5YaATaWxHJJ4I548WTP52Z
         HQznBPZ77omQjGjzir/iZ40AX3+T4D/dbrnxY57pP7hPq2dpmgXg/SJ3kStlUb3z8vAI
         r5XmLwnaVOyj54hokJRdo4h4vHgeIu7VbpaNeEfj1uYBDHELUf9DFcxnPBZR7Az6vI/M
         LSpQ==
X-Gm-Message-State: AOAM530eojC0DaC9wF1jT1HnC+Dxi4DaFh7iwBexkFLfr9KUaZ77wr+8
        dRCpdgwJdtrNTMd7/qidgx5dz9Opy8A=
X-Google-Smtp-Source: ABdhPJw5FDm+rK6MjcDlcjoETKy8zAJgexQHgKvPHqO/OCrjNWoLpjfYWT2j0OS+Hc8QKYV5bKYang==
X-Received: by 2002:a50:9d42:: with SMTP id j2mr3292349edk.7.1634164783814;
        Wed, 13 Oct 2021 15:39:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:43 -0700 (PDT)
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
Subject: [net-next PATCH v7 15/16] dt-bindings: net: ipq8064-mdio: fix warning with new qca8k switch
Date:   Thu, 14 Oct 2021 00:39:20 +0200
Message-Id: <20211013223921.4380-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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

