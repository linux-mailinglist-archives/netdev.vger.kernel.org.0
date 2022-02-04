Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A7E4AA06C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiBDTvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiBDTvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:51:01 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9A7C06175E
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 11:50:59 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id i1so5769789ils.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 11:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q42zjW8xahSVhGaNilfnj63EHK+Wikk3dCoDovWBQQY=;
        b=Fqu8+ypIkgxeVioleBdx7cz2kzcNe89AS6NsggXAOlU1Ts4IPADKZ7XQeqdEbNyf89
         SAwWXPLyU9ULlM70bsTCwyoO4AYCOLi9/eUmNITJ8VrsmKVKrxSjiJqvPtseykw4EZcI
         7i8RqubLHz8YGtUo1UHLJKtlFDeKXKdw9yb2FasbkTYh78guITuK5WoEem40G8WTdxNI
         N2ZTPzSdf0zgrNKA7v4PckXQhcoazag/+YBMSZrJJ51D1Yj4DXi3d3/mwjcQ34YFtLul
         GJRRg3fl06CGSyOoSnuyNX5UWetE1yfvt15CEfeAHhUtgBC2UVyjdv2AnnMPDzCd61Vc
         tpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q42zjW8xahSVhGaNilfnj63EHK+Wikk3dCoDovWBQQY=;
        b=CRapa9/XnkmUJZVLjqa/f2ZptISurpwpckqoUZvO6EEFSQIbPOLZo/1DxBIzUj3MsF
         j4tlfuRZv1dbgCiFcugPgGINCzFomJn9wYZ/cVeUQFuDgRZfgvfrnMBuRYrlPRj3V942
         iVUt42Gbro6wwKbSTPhbvuHa5h6h47HJlQ1wvjQU0WL5jZCYTp8KK69x4UHa4K11Ig4Y
         P1frn3FCMlZk3SsrG6WbIS9piQvO+Tz88+WoF7S9EQSAIsEk6GWGhDEQG6pjF/wJepAa
         aJAUuz58ou8C6ur21jFUSmyOsKUZ606TFIaayeLxRWlPkOwTSvAkOafKBmXUDeieCtDp
         9cjQ==
X-Gm-Message-State: AOAM532y+4j2dPxtmYkPYC/wjGqaJ/+laarwYW0hNejk5riumFtR2/5R
        yGyxOS7Obo2rPxDkPu+iWp/CcQ==
X-Google-Smtp-Source: ABdhPJwifcbLNOdRURW/rAIAn/Qb8lZQb1jM5cBMyOnP8fsp1/pvuwPkQuyCiwRCNj/Yx2I45RV8vQ==
X-Received: by 2002:a92:c569:: with SMTP id b9mr374353ilj.140.1644004258743;
        Fri, 04 Feb 2022 11:50:58 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k13sm1417564ili.22.2022.02.04.11.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:50:58 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: use IPA power device pointer
Date:   Fri,  4 Feb 2022 13:50:44 -0600
Message-Id: <20220204195044.1082026-8-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220204195044.1082026-1-elder@linaro.org>
References: <20220204195044.1082026-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ipa_power structure contains a copy of the IPA device pointer,
so there's no need to pass it to ipa_interconnect_init().  We can
also use that pointer for an error message in ipa_power_enable().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 8a564d72799da..16ece27d14d7e 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -71,7 +71,7 @@ struct ipa_power {
 };
 
 /* Initialize interconnects required for IPA operation */
-static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
+static int ipa_interconnect_init(struct ipa_power *power,
 				 const struct ipa_interconnect_data *data)
 {
 	struct icc_bulk_data *interconnect;
@@ -89,7 +89,7 @@ static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 		interconnect++;
 	}
 
-	ret = of_icc_bulk_get(dev, power->interconnect_count,
+	ret = of_icc_bulk_get(power->dev, power->interconnect_count,
 			      power->interconnect);
 	if (ret)
 		return ret;
@@ -123,7 +123,7 @@ static int ipa_power_enable(struct ipa *ipa)
 
 	ret = clk_prepare_enable(power->core);
 	if (ret) {
-		dev_err(&ipa->pdev->dev, "error %d enabling core clock\n", ret);
+		dev_err(power->dev, "error %d enabling core clock\n", ret);
 		icc_bulk_disable(power->interconnect_count,
 				 power->interconnect);
 	}
@@ -385,7 +385,7 @@ ipa_power_init(struct device *dev, const struct ipa_power_data *data)
 	spin_lock_init(&power->spinlock);
 	power->interconnect_count = data->interconnect_count;
 
-	ret = ipa_interconnect_init(power, dev, data->interconnect_data);
+	ret = ipa_interconnect_init(power, data->interconnect_data);
 	if (ret)
 		goto err_kfree;
 
-- 
2.32.0

