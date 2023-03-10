Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8218A6B477F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjCJOvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjCJOuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:50:05 -0500
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FBC5252;
        Fri, 10 Mar 2023 06:48:04 -0800 (PST)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1767a208b30so6091513fac.2;
        Fri, 10 Mar 2023 06:48:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678459671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+AVwwweJuaCWPR0Hm9r/ZtWK6euM6RR2fDR9NC5QFPc=;
        b=FKH/6gfhH3YQWZ2XcPXYln9voeGsMk5ERLt8BSlgYitPnY9xkqroh6H+YxEt/lbHQ8
         hLV+ydzXyMP3KKHG0yB35jxdio+eYsqrj0P/8rMVbp81CqW6U0NVTcIjoVSZIKxAe8mz
         OvJ/hvwmls6GeX9seIqYwmbVdVI/eMLojbLbsmUP1ORUbtswQ7VRpJKMynZW1P3I+Nsl
         Jgh7F6G15dpqAqqJqvoIBrCGOItqSXoVUIDe/eUVBRAWnCHSOqrbF5x1iozBC37es7mE
         MycILtnmc6h9viaZd8VCS2Oni/Z+mQ0jQSipToNH5c3gOQJp/oQR3Y+Ok46vtOYmzmnC
         I1bw==
X-Gm-Message-State: AO0yUKUTJ+TyDw3h9h1tmrOvf713wnQxUU4Aa/LsxTTaAver/vCJUuxz
        p38mQ3cl9mKEwZ0dzb2ohJZqAg++tA==
X-Google-Smtp-Source: AK7set/lYI0Ei0wZZ2aiY0Mtu9KRUxGF/gp1zqZ1hqrUJfMfLHIEPYaXq0kBu8ReuXIK/O9QdZvAlg==
X-Received: by 2002:a05:6871:607:b0:15b:96af:50ac with SMTP id w7-20020a056871060700b0015b96af50acmr17490139oan.29.1678459671605;
        Fri, 10 Mar 2023 06:47:51 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id dy11-20020a056870c78b00b001763897690csm125200oab.1.2023.03.10.06.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 06:47:51 -0800 (PST)
Received: (nullmailer pid 1544331 invoked by uid 1000);
        Fri, 10 Mar 2023 14:47:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: mrvl: Use of_property_read_bool() for boolean properties
Date:   Fri, 10 Mar 2023 08:47:18 -0600
Message-Id: <20230310144718.1544283-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is preferred to use typed property access functions (i.e.
of_property_read_<type> functions) rather than low-level
of_get_property/of_find_property functions for reading properties.
Convert reading boolean properties to to of_property_read_bool().

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/nfc/nfcmrvl/i2c.c  |  2 +-
 drivers/nfc/nfcmrvl/main.c |  6 +-----
 drivers/nfc/nfcmrvl/uart.c | 11 ++---------
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index e74342b0b728..164e2ab859fd 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -168,7 +168,7 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 		return ret;
 	}
 
-	if (of_find_property(node, "i2c-int-falling", NULL))
+	if (of_property_read_bool(node, "i2c-int-falling"))
 		pdata->irq_polarity = IRQF_TRIGGER_FALLING;
 	else
 		pdata->irq_polarity = IRQF_TRIGGER_RISING;
diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 1a5284de4341..141bc4b66dcb 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -261,11 +261,7 @@ int nfcmrvl_parse_dt(struct device_node *node,
 		return reset_n_io;
 	}
 	pdata->reset_n_io = reset_n_io;
-
-	if (of_find_property(node, "hci-muxed", NULL))
-		pdata->hci_muxed = 1;
-	else
-		pdata->hci_muxed = 0;
+	pdata->hci_muxed = of_property_read_bool(node, "hci-muxed");
 
 	return 0;
 }
diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index 9c92cbdc42f0..956ae92f7573 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -76,15 +76,8 @@ static int nfcmrvl_uart_parse_dt(struct device_node *node,
 		return ret;
 	}
 
-	if (of_find_property(matched_node, "flow-control", NULL))
-		pdata->flow_control = 1;
-	else
-		pdata->flow_control = 0;
-
-	if (of_find_property(matched_node, "break-control", NULL))
-		pdata->break_control = 1;
-	else
-		pdata->break_control = 0;
+	pdata->flow_control = of_property_read_bool(matched_node, "flow-control");
+	pdata->break_control = of_property_read_bool(matched_node, "break-control");
 
 	of_node_put(matched_node);
 
-- 
2.39.2

