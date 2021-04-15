Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED144360784
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 12:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhDOKsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 06:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhDOKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 06:48:10 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9878C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 03:47:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j7so7213774pgi.3
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 03:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UbWREfxBgBA46ljl4hzVe4POfFo0RJt+3RiVINqCR2w=;
        b=LudU/lZJma6j8HbUABdfJH1ovBCkubCT/zyHmenELpeVz3cmGlBjQDpbyXPvqA1xQO
         oN6JDTR+pEQc8z7UlzgknGcFnc+4aT59tvsbwuG0f+aXaALP8cfl2/Ypku7uTm76Q1hw
         zThdKIIHpXfWXfSd9TVmMGorlNz34Glkl+POqJkwtDZvEj9s3lSux0wZx/mYLq3fMb3D
         DsZgTqQEd5JD+bA+8Rrzz9LKXaIU8GYwDH7FcRN3V9sMvix5qk7dL2tBqv8aojE7Ax+t
         Y2ej84FN196JeGk/sROEzWa86dO6PhlFCQPQRoMu1vQA/a/5DZ/ZFwA9IojqNkI+sdD2
         uDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UbWREfxBgBA46ljl4hzVe4POfFo0RJt+3RiVINqCR2w=;
        b=haobyKUvZbnnV6Isg0iqTIW7+pdSTgRPDCIFd9rwMXV2dI4SFg6jWPbW04N0irierG
         8hwK8jG/rnt118UbZEpMltimMOwcfU3X0VKQ+GlkHkY1JEoXsN8Gu5OdtGCRrn0jdtfN
         xV7QnWA0wrSpCLiuU2p4LXQI2yrjadsP9QUjHGpf/Kk8Q+z4+CgfXClPhjYbU2ey5OZA
         Za97q4PGemvCxER3IbrA+hG+pcJG2Jkj7ceE/ruy8hHeI/ECJMUfRdGWn0GbLHn7mwWp
         PeBM7dMOD298WBd73v+M7X9IPdIpRHxNdIR4sx+mgfiya+p8FotMD3dENIRiJiIulgxQ
         AXkw==
X-Gm-Message-State: AOAM532qwADUbeczXYRAZd8wy+6UysXpuv/RueroxfbO1rGIKCKqqJPV
        XHHkXiQdxPNMtwTWfFqValbVpg==
X-Google-Smtp-Source: ABdhPJzFLKlpVtGZ0q11kbQWo2JAfA/tLTLQocjqxnmeMvk5/ShA9HzQ7iBZwbt0bc1xk8QUzvhilA==
X-Received: by 2002:aa7:9183:0:b029:24b:87e2:6281 with SMTP id x3-20020aa791830000b029024b87e26281mr2599798pfa.14.1618483666469;
        Thu, 15 Apr 2021 03:47:46 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id f65sm2130672pgc.19.2021.04.15.03.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 03:47:46 -0700 (PDT)
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 2/2] brcmfmac: support parse country code map from DT
Date:   Thu, 15 Apr 2021 18:47:28 +0800
Message-Id: <20210415104728.8471-3-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210415104728.8471-1-shawn.guo@linaro.org>
References: <20210415104728.8471-1-shawn.guo@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With any regulatory domain requests coming from either user space or
802.11 IE (Information Element), the country is coded in ISO3166
standard.  It needs to be translated to firmware country code and
revision with the mapping info in settings->country_codes table.
Support populate country_codes table by parsing the mapping from DT.

The BRCMF_BUSTYPE_SDIO bus_type check gets separated from general DT
validation, so that country code can be handled as general part rather
than SDIO bus specific one.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/of.c | 57 ++++++++++++++++++-
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index a7554265f95f..dd99ac3410e3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -12,12 +12,59 @@
 #include "common.h"
 #include "of.h"
 
+static int brcmf_of_get_country_codes(struct device *dev,
+				      struct brcmf_mp_device *settings)
+{
+	struct device_node *np = dev->of_node;
+	struct brcmfmac_pd_cc_entry *cce;
+	struct brcmfmac_pd_cc *cc;
+	int count;
+	int i;
+
+	count = of_property_count_strings(np, "brcm,ccode-map");
+	if (count < 0) {
+		/* The property is optional, so return success if it doesn't
+		 * exist. Otherwise propagate the error code.
+		 */
+		return (count == -EINVAL) ? 0 : count;
+	}
+
+	cc = devm_kzalloc(dev, sizeof(*cc) + count * sizeof(*cce), GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+
+	cc->table_size = count;
+
+	for (i = 0; i < count; i++) {
+		const char *map;
+
+		cce = &cc->table[i];
+
+		if (of_property_read_string_index(np, "brcm,ccode-map",
+						  i, &map))
+			continue;
+
+		/* String format e.g. US-Q2-86 */
+		if (sscanf(map, "%2c-%2c-%d", cce->iso3166, cce->cc,
+			   &cce->rev) != 3)
+			brcmf_err("failed to read country map %s\n", map);
+		else
+			brcmf_dbg(INFO, "%s-%s-%d", cce->iso3166, cce->cc,
+				  cce->rev);
+	}
+
+	settings->country_codes = cc;
+
+	return 0;
+}
+
 void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 		    struct brcmf_mp_device *settings)
 {
 	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
 	struct device_node *root, *np = dev->of_node;
 	int irq;
+	int err;
 	u32 irqf;
 	u32 val;
 
@@ -43,8 +90,14 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 		of_node_put(root);
 	}
 
-	if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
-	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
+	if (!np || !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
+		return;
+
+	err = brcmf_of_get_country_codes(dev, settings);
+	if (err)
+		brcmf_err("failed to get OF country code map (err=%d)\n", err);
+
+	if (bus_type != BRCMF_BUSTYPE_SDIO)
 		return;
 
 	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
-- 
2.17.1

