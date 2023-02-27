Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132266A3632
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 02:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjB0Bly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 20:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjB0Blv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 20:41:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A9411653;
        Sun, 26 Feb 2023 17:41:50 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z2so5140542plf.12;
        Sun, 26 Feb 2023 17:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEKg+3stmn5jtpvQ4w/9hs85v/LM1OXjKeXbQpK7Cjo=;
        b=CCxDNxOygcVT0yiMCyXhfvpjHBoRj0KLgbpYQ0HxZkomp7ZjjgySlXWxZtbxc7BzVO
         3skdkSJui3HB23KoJFDllmqWNkzUkzzoWXswbqz6VwnyCleiPoOhydDQeJYgQ+PYrkZ0
         Ubb9U3WCL2rhmodgFJ8GZwcxU4KUCw1OH42C71fWFnBP3epA5Cn9/4ktYWwHupiFM6FC
         4hgYuLkNrKDjxbHUXT7Hy9O/5IBuk23J92lmXKEl01fUemAkCbMTJtkkp66AXOW9PFms
         OOhoHCZeTP3mbDxyIXPGM+iwiO+H/PNu7pPLkcWlDoFeUQc2tvJJsOPOlVKVUIrRwfOL
         U0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mEKg+3stmn5jtpvQ4w/9hs85v/LM1OXjKeXbQpK7Cjo=;
        b=LLMz2bqg8U7o7aWHd5Ol/6qNSf3/vke72axIQqBDrbobH2dJ43t3DI9sF1zwr6Us64
         2vWUahZomCnOIa2345v6gpm00qU07I5Gr1bJaIJO+sR7ONG0V3mjaipSl8KjKukC6dNQ
         RRNnkh9qEn6dZLgWcpyVxZesfcM6dAx5pUM6I2zo9RcD/y8Y8Ig5X0y0gdGZmNfKHYqk
         7Dy3v/lDcFDCSPf4YQaXLgJJBQijnRC8uYZcmxzXzhxTXrCdeS4NkYkJNkZo+7ULtvie
         FmyQgyVidEBIIBrcuqmYjLEPq7VRdXRe126HLtKEN4rWAD+NzVrABjcRBOBbPw0HMHlY
         2rlw==
X-Gm-Message-State: AO0yUKWWdcQ8z/6zu6ZCv0AB9lHD6iFhe/VBRTGSYdVcmR2NhEIg1CKl
        1Pf2rr8Ljh7O8vzWELmmrhzsbnAnJVqGp34u
X-Google-Smtp-Source: AK7set8c0G8xVJru+zvSO5Wz4KV634fLAoYEw+ObK5AQOhBOi2in5gFrmC38S6qrj4W/DHQuwnOEAQ==
X-Received: by 2002:a17:90a:199:b0:234:b3cb:147 with SMTP id 25-20020a17090a019900b00234b3cb0147mr23675670pjc.16.1677462109565;
        Sun, 26 Feb 2023 17:41:49 -0800 (PST)
Received: from passwd123-ThinkStation-P920.. ([222.20.94.23])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a12c100b0023377b98c7csm3031098pjg.38.2023.02.26.17.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 17:41:49 -0800 (PST)
From:   Kang Chen <void0red@gmail.com>
To:     simon.horman@corigine.com
Cc:     krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, void0red@gmail.com
Subject: [PATCH v2] nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
Date:   Mon, 27 Feb 2023 09:41:44 +0800
Message-Id: <20230227014144.1466102-1-void0red@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Y/t729AIYjxuP6X6@corigine.com>
References: <Y/t729AIYjxuP6X6@corigine.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
out-of-bounds write in device_property_read_u8_array later.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")

Signed-off-by: Kang Chen <void0red@gmail.com>
---
v2 -> v1: add debug prompt and Fixes tag

 drivers/nfc/fdp/i2c.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 2d53e0f88..d3272a54b 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -247,6 +247,11 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg) {
+			dev_dbg(dev, "Not enough memory\n");
+			goto out;
+		}
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -259,7 +264,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		dev_dbg(dev, "FW vendor specific commands not present\n");
 		*fw_vsc_cfg = NULL;
 	}
-
+out:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
-- 
2.34.1

