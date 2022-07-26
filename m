Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431BD580C2A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiGZHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbiGZHIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:08:11 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88992A73E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:08:08 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id t1so21312568lft.8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFwyDOKCVC1F9VQI2rdR+Z/dXO4JHgYAt2jRGYaDNmI=;
        b=tZSlYhxHE0gI5K7hs0ttQbbMB6ZlXe3Xx+DIuP1RWHVuBrQDYYZZaXE12MHDmLvcBi
         vHkDE99D0zQtdLgQoR29wTFjgLOhYe37ARsAgVIdQlcblakixFsRRSTgnh/TE3KgSHpo
         YwpyTZ3exDjYhl5woQG7LsFj4ME379EOy4KrWp8ZNIBCPcnutlnj+n32HwOJdUAGzNBz
         3haNMF+c5JcsBTurOiWZUpLEXsSUOOAFNxe/zgaf5ZophRCmFOPnv9Omj5L7pzghPtRz
         76uieNjOEhEv1/y+XZbNBwbbyPSO5Jky+5GSo8JF+OJmZObQ295EnEQ3ONsLmxx9md8X
         cHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFwyDOKCVC1F9VQI2rdR+Z/dXO4JHgYAt2jRGYaDNmI=;
        b=5X3fSG0+PAWUZktklPY7Tl4kkhEZXhciWWyZ+SfWZQ+0zmeza5SPz52KDWvdC/QzNO
         ycc2UXN8PZb79sv+hvvQBHO5KnfvGAk0RscNHM/5hTpG3hvn2NQunfqkq/atWpMufQJU
         FgJEoMLHuBRfqjIrc1DYRfZVC0FyAEm1vlcfVOvMWm0GcHBpryCwOH7NJYvhC8YDMEnW
         jkgbTqvsrg8zhBPKBA449WJKxcrdxCwBERmwWg6zw9WxclVxK5cd4UMOCWKOVK1SZE1R
         vofv3Ry+Eo8TMAQdIbUDGh9k+wNG7O1Vc6Nj/A88OsJR5sg/wBnRTxAIyRz9eFJuMvCc
         iGfg==
X-Gm-Message-State: AJIora/VrC3zrhbc41k8mJ8DNPixxaQ7lVnMIhCe2DRLrVT1HaoW9TmF
        fJDkhib6Lv7eqadckMIyB5gX/g==
X-Google-Smtp-Source: AGRyM1skiIiWDoUeGXogcpcCVH2w68yaERq/Kp0SalhDw9Qx7enT9uhYjsxj8/6rFS3XFevIF18QwA==
X-Received: by 2002:a05:6512:1085:b0:48a:9d35:4b8 with SMTP id j5-20020a056512108500b0048a9d3504b8mr1485929lfg.3.1658819287140;
        Tue, 26 Jul 2022 00:08:07 -0700 (PDT)
Received: from krzk-bin.lan (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id q23-20020a05651232b700b0047f6b4a53cdsm3045061lfe.172.2022.07.26.00.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 00:08:06 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 2/2] net: cdns,macb: use correct xlnx prefix for Xilinx
Date:   Tue, 26 Jul 2022 09:08:02 +0200
Message-Id: <20220726070802.26579-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
References: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use correct vendor for Xilinx versions of Cadence MACB/GEM Ethernet
controller.  The Versal compatible was not released, so it can be
changed.  Zynq-7xxx and Ultrascale+ has to be kept in new and deprecated
form.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v1:
1. None

Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4cd4f57ca2aa..494fe961a49d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4798,13 +4798,15 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "atmel,sama5d4-gem", .data = &sama5d4_config },
 	{ .compatible = "cdns,at91rm9200-emac", .data = &emac_config },
 	{ .compatible = "cdns,emac", .data = &emac_config },
-	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
-	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
+	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config}, /* deprecated */
+	{ .compatible = "cdns,zynq-gem", .data = &zynq_config }, /* deprecated */
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
 	{ .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
-	{ .compatible = "cdns,versal-gem", .data = &versal_config},
+	{ .compatible = "xlnx,zynqmp-gem", .data = &zynqmp_config},
+	{ .compatible = "xlnx,zynq-gem", .data = &zynq_config },
+	{ .compatible = "xlnx,versal-gem", .data = &versal_config},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.34.1

