Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862B06A3E58
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjB0Jao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjB0Jan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:30:43 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3369006;
        Mon, 27 Feb 2023 01:30:42 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id bh1so6025239plb.11;
        Mon, 27 Feb 2023 01:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqlhBQG3ZY7WEZg8vyYycu2rPcnKBeaUa5frdq7cInQ=;
        b=jXERK1s9N/8LGgd/1Y+ETYcOeuxwTovePN1UNH+ZHrm/k1D03s+Uw6kX6Bt33SovRk
         K7aUbQVY1tSMt1A84T1up61LjyQFIbbgsRsXCTsXUM/z0uuJ7PyuywuqgUhs74fdQp5P
         I/gKl25c64uQNLsHvyg2LZ+rgvddVVDvyHquYSb3heAyFSVYpqaIB1Zw4w+mek964Ose
         hQ2w3qBpHP+OsxIaXRU7Ruh5/AjphUBR1VG5eP3xb9nPvhUgos744y6S1XdOnxUFsKJ+
         NUDpFOx9eeJgwlbTkFJv7QvagcH0z58rHi+iok6nlqHBYL5rH0+Ew3Ovhy+ahRTy9PVx
         2Fhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GqlhBQG3ZY7WEZg8vyYycu2rPcnKBeaUa5frdq7cInQ=;
        b=wrWg4RL8jxTelO+Ai5V30O2wTW2Tpq9XNTbKhe6Gyop1Js27isytP2vIUDCiGDcDMx
         VAX7svsIkJelmsn5GrTcrNFgZBwhpcMax4oUs6E3I8vTJ1wxOcV5QwUB+7TSOKwxr/hn
         VlyNznPoLWQf085t3+Z9HT4KIuw7DRAL1Lm2aiAsT0Yis6UlwHGBQo+mXObky59rn3wd
         d1uvB2X8aMNwwUd/LbvUWkBFl2Qttjoap4N3taa4D0pZyu6o6H+/XVSKmSOprHjNQTut
         0cuTL5zSqsPL1k8mm4PfuChU6vC9/6vl6UO7KU2GYluuQx+gCN9s01451JmH2wRY2bka
         gSGQ==
X-Gm-Message-State: AO0yUKWjIugfMjchd7FcRsA9VP+cdOlbSL6b70AKYF5MfrVW5OXd1/c2
        5cssEo64eoKUz4voQBEQLaA=
X-Google-Smtp-Source: AK7set8S9BDm2zTu42tCFyIj8lLiEzDlHuqIJByJk0mtgSwXXKu13p6bqzvcRbiAojcJOxm6MouX1g==
X-Received: by 2002:a05:6a20:6999:b0:cb:8e4c:6e4d with SMTP id t25-20020a056a20699900b000cb8e4c6e4dmr24369888pzk.47.1677490241750;
        Mon, 27 Feb 2023 01:30:41 -0800 (PST)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm3615865pgn.70.2023.02.27.01.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 01:30:41 -0800 (PST)
From:   void0red <void0red@gmail.com>
To:     krzysztof.kozlowski@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        simon.horman@corigine.com, void0red@gmail.com
Subject: [PATCH v3] nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
Date:   Mon, 27 Feb 2023 17:30:37 +0800
Message-Id: <20230227093037.907654-1-void0red@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <35ddd789-4dd9-3b87-3128-268905ec9a13@linaro.org>
References: <35ddd789-4dd9-3b87-3128-268905ec9a13@linaro.org>
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

From: Kang Chen <void0red@gmail.com>

devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
out-of-bounds write in device_property_read_u8_array later.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Kang Chen <void0red@gmail.com>
---
v3 -> v2: remove useless prompt and blank lines between tags.
v2 -> v1: add debug prompt and Fixes tag

 drivers/nfc/fdp/i2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 2d53e0f88..1e0f2297f 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -247,6 +247,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto alloc_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -260,6 +263,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*fw_vsc_cfg = NULL;
 	}
 
+alloc_err:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
-- 
2.34.1

