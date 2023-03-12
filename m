Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82426B66A7
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 14:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjCLN1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjCLN0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 09:26:55 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0CC305F1
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 06:26:40 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ek18so7452248edb.6
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 06:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678627599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OhPNKp+h/JhTZv2AR+GWTk1z9+pF/E/xoiUrabbBl5E=;
        b=r0zGlJwdbieCHEHGgPRlybtntCda4+R6XxU1ew2HJtN++FQgDaXxRor3iSCYAUz6cd
         j52mWCZdomS06Kz38Wte+mo8YRs5UT1sofzFBifTwVKxYki85wotRs4sdq0Qz6l5OZDm
         vw15pI/3rOKFE+VxhZrhemWd/CZAt9c74EI4vTLnX6FwUpYHa/uTuKq2gfmLzOi/KNaC
         KW763+SHvh6w3NZ1zsLHR0B7XT3v0NP91VS5/BbLcGn2hfrkA4VK0n+quVg4R/5DVdTP
         KvmcY3AYBRoOGvKfgYs35xf5Y/hjjse2xsgbeZoUGgK3S+ZQIAFSKB4WINpGubThw6r1
         7MnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678627599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OhPNKp+h/JhTZv2AR+GWTk1z9+pF/E/xoiUrabbBl5E=;
        b=IFSEEQb/IMmu3STuotxDUKjkgr6IT6A4mbxMScPBMscTNIMVdD3/g13eN0qvyZ3lF5
         JdOALbmW0sMcvUzQr99ObTx0OFFgPMum90rnoGcSYjvM6T16gJJoCSJnklkxCaL/9r9n
         5MAgZr48s0h82vSyubGah9S0mOj7D7ARtl/OEjx7td6E7NRLvDm5UK73ToF0AGZKQc24
         TjDHqZiyz9e9z23iOy6TEX+9+TopT/AJE+7D4e8muUlVJkwIrwVr06Rq+iW8cXIDgFFe
         qvUWeuf4+oqBPoxrFIMhuoY4ArwcHu6PwKvXJIqMkMEoxA3mhwWGPOvTZ8OS9W7FVTdn
         IRng==
X-Gm-Message-State: AO0yUKXZ6xyO+towAWjtb27glcISM5KfcROCFi/YzusTZK2GTPstJQqX
        ZagO/Tgnx/5isaNl9J9Sru4Nlw==
X-Google-Smtp-Source: AK7set+xy8EaABJuRWSfHzt+0Cu6wNhfn4lU3X5a19yJpOY4ODpGNX1PNLtyh6KyLgL1zGnC13HF9A==
X-Received: by 2002:a17:906:1c0a:b0:8b1:79ce:a629 with SMTP id k10-20020a1709061c0a00b008b179cea629mr32465380ejg.18.1678627599113;
        Sun, 12 Mar 2023 06:26:39 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:d9f6:3e61:beeb:295a])
        by smtp.gmail.com with ESMTPSA id bg25-20020a170906a05900b00905a1abecbfsm2219473ejb.47.2023.03.12.06.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 06:26:38 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] ptp: ines: drop of_match_ptr for ID table
Date:   Sun, 12 Mar 2023 14:26:37 +0100
Message-Id: <20230312132637.352755-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it might not be relevant here).  This
also fixes !CONFIG_OF error:

  drivers/ptp/ptp_ines.c:783:34: error: ‘ines_ptp_ctrl_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ptp/ptp_ines.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 61f47fb9d997..ed215b458183 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -792,7 +792,7 @@ static struct platform_driver ines_ptp_ctrl_driver = {
 	.remove = ines_ptp_ctrl_remove,
 	.driver = {
 		.name = "ines_ptp_ctrl",
-		.of_match_table = of_match_ptr(ines_ptp_ctrl_of_match),
+		.of_match_table = ines_ptp_ctrl_of_match,
 	},
 };
 module_platform_driver(ines_ptp_ctrl_driver);
-- 
2.34.1

