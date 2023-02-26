Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27E16A2F08
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 10:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBZJ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 04:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBZJ7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 04:59:40 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A6810259;
        Sun, 26 Feb 2023 01:59:40 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y2so3241182pjg.3;
        Sun, 26 Feb 2023 01:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lfz6I31mKUh7LjC7DDi82wHWTNeYuBNMtHWifXjKt40=;
        b=ZkJB9WON78bHE+oF9rlil5axqe0nIpN9gxQzUEm64EpkldHPMCSVLa7+YT5lvkCB59
         Tycwc5tcjxmvBXCBDhXP83Avt9DOL3qbUbcSgUxgDWnRmZcW5It4H1avHTUxzE0oCm6Y
         pCa6M2mRvXgRftw40R62xy/SEAJ7xuJ7LHhe3uC/TDEEYMkxrST+kAj84f2RjA7fXxuL
         Oss7jKk9SqTcY8kGlM2JUoNMVeB0T8C+DSj+rKWk+KqwkDvAAVoCAaSV4UFoTBTK6iUV
         O42TYWbOi21aNqQk9QxpOC/x5FcRlGsTYW0PVWSPrJ0fv8ovp5geiF279GWXLwU5uTIX
         ttVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lfz6I31mKUh7LjC7DDi82wHWTNeYuBNMtHWifXjKt40=;
        b=u5GQko36IT/K/zWE3E3eVVM29//B3+wq82Z+AI2KB0wyGnQtvwQ1KfRGMfdDa4lBe6
         EGge2o3+skwJyo20+7ag42oeJXh1IR6XrefgVL+xJ/1BO5ZJfDptfazsQKYu3ecovG1K
         UE/KraxgF+iMrUKU/thYieSFX8uW5k/AmixFVExq2AYwdFn9HigL11RKB3HkUcTzgUnt
         oTtcoqtECZPof12DjCS4DXhhS65vnO/DqLfg/M6Xdpx/ggx9Z2LNToOe0OjkYDj7S76H
         rEtVQw4ZC5yeZCW3wQUgGvyLTBjEaKMOM33ZKPBi5Pm1cJc+XQQ9OvotV6BOy/OukUrX
         EX1w==
X-Gm-Message-State: AO0yUKW7Ru7ZLDZcc16FbgtdIR+kv2m5FF/N2Ic2aQIytjwIABgSXHwW
        3BTNeXG1F7fW/PEh9rDXzgBJbYRhmDiUBhc4
X-Google-Smtp-Source: AK7set8iF1PQZu5I0ACRIlap4G0RVYAmL2pwBJ5mogMNKtfTHHguGjZe8iSNlssE6NvzNQiapNFJPw==
X-Received: by 2002:a05:6a20:4c1f:b0:cc:f597:2289 with SMTP id fm31-20020a056a204c1f00b000ccf5972289mr2109509pzb.14.1677405579376;
        Sun, 26 Feb 2023 01:59:39 -0800 (PST)
Received: from passwd123-ThinkStation-P920.. ([222.20.94.23])
        by smtp.gmail.com with ESMTPSA id b20-20020a656694000000b00503006d9b50sm2056535pgw.92.2023.02.26.01.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 01:59:38 -0800 (PST)
From:   Kang Chen <void0red@gmail.com>
To:     krzysztof.kozlowski@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kang Chen <void0red@gmail.com>
Subject: [PATCH] nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
Date:   Sun, 26 Feb 2023 17:59:33 +0800
Message-Id: <20230226095933.3286710-1-void0red@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Signed-off-by: Kang Chen <void0red@gmail.com>
---
 drivers/nfc/fdp/i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 2d53e0f88..d95d20efa 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -247,6 +247,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto vsc_read_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
-- 
2.34.1

