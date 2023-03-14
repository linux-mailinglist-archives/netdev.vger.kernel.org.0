Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A206BA07F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjCNUNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjCNUNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:13:23 -0400
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEA859CE;
        Tue, 14 Mar 2023 13:13:15 -0700 (PDT)
Received: by mail-il1-f176.google.com with SMTP id r4so9274853ila.2;
        Tue, 14 Mar 2023 13:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678824795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zM6p6/AP+GRJf21/LuwRpnaaVKcsH/RiAIONAo73BAA=;
        b=vhWV+lChRec2kQXz16+SLgq5W106CzPkl4N29pUhIC4Zh1lRtcp82qiq6XS91Ed28H
         08NVvROQBAdJaz/F/lmUDn1H6bL1xnc+DuygxTxaMjOzwlF0jQIxVoOVwG8fnTSD1scf
         hH74LFLn8h0au4bTBQP3eCms5Dk5uuURv1HmCno10idAMJi0F8EX5/numLHYsfxGDMDe
         lBOfPqlB/3b2UnFTkfteQzlBZtMCm15DtZLzVMs/eYQt4dyduCBVGmu3KKnSnH96wrWQ
         fvYIgb6jGv6rCRAjWTABa8BX1cDFvyYaKh9IEsO1ZVc6nq3FE/mUyoLwKCTCLLjA1bdd
         T9QA==
X-Gm-Message-State: AO0yUKVZ4WYogcmaBUnaVbKh0KkY3Z/csn0nqYMVzOeIkvZmB1Yj7SUL
        SKyXRJUgBAWKWjFfACvLMQ==
X-Google-Smtp-Source: AK7set+n0wBOGJvllvMna3DictaV2YchaIZ1cNiodVNXtAFpLZCLmtMgxTjZDwVV+XnHWf4/DRl1hw==
X-Received: by 2002:a05:6e02:e0b:b0:316:b0b2:beff with SMTP id a11-20020a056e020e0b00b00316b0b2beffmr2616607ilk.4.1678824795191;
        Tue, 14 Mar 2023 13:13:15 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id p11-20020a92c60b000000b003179d2677f4sm1065067ilm.48.2023.03.14.13.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:13:14 -0700 (PDT)
Received: (nullmailer pid 995533 invoked by uid 1000);
        Tue, 14 Mar 2023 20:13:12 -0000
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 2/2] nfc: mrvl: Use of_property_read_bool() for boolean properties
Date:   Tue, 14 Mar 2023 15:13:09 -0500
Message-Id: <20230314201309.995421-2-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314201309.995421-1-robh@kernel.org>
References: <20230314201309.995421-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is preferred to use typed property access functions (i.e.
of_property_read_<type> functions) rather than low-level
of_get_property/of_find_property functions for reading properties.
Convert reading boolean properties to of_property_read_bool().

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - Convert platform_data int types to boolean
---
 drivers/nfc/nfcmrvl/i2c.c     |  2 +-
 drivers/nfc/nfcmrvl/main.c    |  6 +-----
 drivers/nfc/nfcmrvl/nfcmrvl.h |  6 +++---
 drivers/nfc/nfcmrvl/uart.c    | 11 ++---------
 4 files changed, 7 insertions(+), 18 deletions(-)

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
diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
index 0f22b3233f73..f61a99e553db 100644
--- a/drivers/nfc/nfcmrvl/nfcmrvl.h
+++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
@@ -56,16 +56,16 @@ struct nfcmrvl_platform_data {
 	/* GPIO that is wired to RESET_N signal */
 	int reset_n_io;
 	/* Tell if transport is muxed in HCI one */
-	unsigned int hci_muxed;
+	bool hci_muxed;
 
 	/*
 	 * UART specific
 	 */
 
 	/* Tell if UART needs flow control at init */
-	unsigned int flow_control;
+	bool flow_control;
 	/* Tell if firmware supports break control for power management */
-	unsigned int break_control;
+	bool break_control;
 
 
 	/*
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

