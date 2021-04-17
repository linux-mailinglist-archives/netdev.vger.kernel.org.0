Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C773362E6A
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhDQHzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbhDQHzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:55:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C43C061756
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 00:54:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id r13so11425112pjf.2
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 00:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=kyDOfNlO5v5BNocRUhW3soIeQiOs29dwPp3e5LBPghA=;
        b=ZpSz0nHBHKx6SCNZijL6Y+WXj9cWQ4MoEeV3tf+u0cLeL3es/YPptsX/GJzjPfEdwJ
         zOtUqAXSKu4afgcZx79N08Iw0CxTQmubHheJdCzYUhBhTN3u/Ol1F03/0CznvmbfS+hM
         rPSdfIMM+/HrizcMi9p7aI6+1Lo/K4u0vTENzexJOtyt8JgE0B5Wz1ipZp1r2NaYnqIv
         iViO1gBP1AWenpyRCC6jTJYj7qyHLQjfxKpfWf83YKOlPloY4/SLWLyEwkkduXH68u2K
         SSJtIqCtkhiqq3jT3Q9v0fQACscFnP4VAiMTF+nh9WX5a3LvtqV/htu6vmTeH94LxeDu
         Qgcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kyDOfNlO5v5BNocRUhW3soIeQiOs29dwPp3e5LBPghA=;
        b=Bpd5yeEgLbGizbtG5MlvU7aleAyMHgstAZudcaAZa5xFv0Hl4Fm+Ou6zwTtYbi+SAZ
         e60JqsyuSPJjteo69EV4uF24kuNOrmazD1aJSbH5UrOigMZJ1tPp9Wwctw64Gq43t00R
         LKaSWtb8Rr+HzXKmCrgMIq2dYe/irjMvhsiVu3xB2s/Y6UjJIUfzho4EcWXatQXLKm26
         3zyyEgNfotX+65ebUrOmGrwKtVAoeP9BWJR80vKeTmNUB+gWXp7sR3X0iSepxXkGtNam
         iCv3jJw2uweMAGLT3A8cI0NbIxNDf3zSkttDa0a3WkLfUrNGvbW9T3haiYZRluClas4w
         71Zg==
X-Gm-Message-State: AOAM532+BgmyDTY7O3CgAuqstFkeAuPWEKstL/W3yuXkXDA48VhtTuEn
        /23YZFlFqfk5Xw8GPRAvfNVRew==
X-Google-Smtp-Source: ABdhPJzUjKIBSGFaO3HxivB8L2xHV1ZXaT7Q/92d2bWn57qZ+nOrC+gStN/ipU/dzn0BTCIRGFS9Zw==
X-Received: by 2002:a17:90a:6385:: with SMTP id f5mr13821314pjj.212.1618646084083;
        Sat, 17 Apr 2021 00:54:44 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id w75sm7087179pfc.135.2021.04.17.00.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 00:54:43 -0700 (PDT)
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
Subject: [PATCH v3] brcmfmac: support parse country code map from DT
Date:   Sat, 17 Apr 2021 15:54:28 +0800
Message-Id: <20210417075428.2671-1-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
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
Changes for v3:
 - Add missing terminating '\n' in brcmf_dbg(INFO, ...) format string.

 .../wireless/broadcom/brcm80211/brcmfmac/of.c | 57 ++++++++++++++++++-
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index a7554265f95f..2f7bc3a70c65 100644
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
+			brcmf_dbg(INFO, "%s-%s-%d\n", cce->iso3166, cce->cc,
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

