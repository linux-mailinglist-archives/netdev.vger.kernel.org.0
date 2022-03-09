Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162ED4D3A21
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbiCITWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237635AbiCITVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:21:51 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8CF1AF9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:20:49 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id l13so2185808iln.13
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pUf+PCh+TXxcthO6K+0yXDdvKrWCHt/PS/ocodABFUM=;
        b=GA3KQO1Nq0kyV/Mi7GuCK7h8MmlammulbUBRp4xzRhvCpi71Bfai4rpPpMAu8jvUD8
         07xyICOHtOfF7axjufEUa9zLkcGWNkYvmWtlpCcJ5zmQQO8ayejYNhmi87TZhKVrK6IQ
         YB2jEUTSStLZTQzArOeCST2NhG1X85q+cIrPrJsdUlhsjABnrt/bU5UBVEeVXaHMb7Lg
         9AxjJx49MZRJqkK1XMWFEDTUnyhPS7CEB1a6P/1MNOxl8sB7Y2NYADIU+3KmeYLrw3U2
         1Ycd71yJWnBa3mp/kFx6iWTuTKnp+lNi58ByupiFMFlrvkdKWh3nt0ucKR3NTD9MVR2U
         eK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pUf+PCh+TXxcthO6K+0yXDdvKrWCHt/PS/ocodABFUM=;
        b=Ugj6R1FPqQtICPP0Zq0Kkr3rKk0TWkE3Ml4qg2l5JX+/WrDvL8MwDmhxPVuL8tpj/L
         gfkKhi4xwESntRUYmzg3CnuNirVBl8NtNO4xJbgCQSFwd/YEsPvWnRFFbt5P0L5SgDll
         IYb8gwAtc/mlm9Vp+u7F12QfyMVs/W2Z2Z+/IVumyixpBzNQsCozzYkdW1hO5bObJ/bO
         OnTlDfV8ClbhX2FVMn9G0ChvFXuNZIKf2rNqVtNj6cCF9Stiz1hstpZowrRlGPnmrbZK
         hDvZcF7VYLm3e9KjWErDW5fCOcpMLoUcolT0tGVJX6TJP1J6ENXOYueONrSB6q6Jkd4l
         d7Cg==
X-Gm-Message-State: AOAM532nqWqys7IGFJ/Opw+CmO/ymp0oN4USOJHfJEKptYVZYtT77eAp
        FTSraNyDnbm+7fEOOBMKKvDD3g==
X-Google-Smtp-Source: ABdhPJx1tlCe2qOGZf2mcNfYUL1GNSootybI9yjcmDZ0v4iOgD8NqiU2YY2mHB5pfHwAovrHB0Z6ow==
X-Received: by 2002:a05:6e02:1beb:b0:2bf:eed2:cd93 with SMTP id y11-20020a056e021beb00b002bfeed2cd93mr735844ilv.99.1646853648308;
        Wed, 09 Mar 2022 11:20:48 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a056602248800b006409fb2cbccsm1389182ioe.32.2022.03.09.11.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:20:47 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/7] net: ipa: use bulk operations to set up interconnects
Date:   Wed,  9 Mar 2022 13:20:34 -0600
Message-Id: <20220309192037.667879-5-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220309192037.667879-1-elder@linaro.org>
References: <20220309192037.667879-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use of_icc_bulk_get() and icc_bulk_put(), icc_bulk_set_bw(), and
icc_bulk_enable() and icc_bulk_disable() to initialize individual
IPA interconnects.  Those functions already log messages in the
event of error so we don't need to.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 40 ++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 67f76e6a6ae59..c0da1274f5d67 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -74,41 +74,31 @@ static int ipa_interconnect_init_one(struct device *dev,
 				     struct icc_bulk_data *interconnect,
 				     const struct ipa_interconnect_data *data)
 {
-	struct icc_path *path;
 	int ret;
 
-	path = of_icc_get(dev, data->name);
-	if (IS_ERR(path)) {
-		ret = PTR_ERR(path);
-		dev_err_probe(dev, ret, "error getting %s interconnect\n",
-			      data->name);
-
-		return ret;
-	}
-
-	/* All interconnects are initially disabled */
-	(void)icc_disable(path);
-
-	/* Set the bandwidth values to be used when enabled */
-	ret = icc_set_bw(path, data->average_bandwidth, data->peak_bandwidth);
-	if (ret) {
-		dev_err(dev, "error %d setting %s interconnect bandwidths\n",
-			ret, data->name);
-
-		return ret;
-	}
-
-	interconnect->path = path;
+	/* interconnect->path is filled in by of_icc_bulk_get() */
 	interconnect->name = data->name;
 	interconnect->avg_bw = data->average_bandwidth;
 	interconnect->peak_bw = data->peak_bandwidth;
 
-	return 0;
+	ret = of_icc_bulk_get(dev, 1, interconnect);
+	if (ret)
+		return ret;
+
+	/* All interconnects are initially disabled */
+	icc_bulk_disable(1, interconnect);
+
+	/* Set the bandwidth values to be used when enabled */
+	ret = icc_bulk_set_bw(1, interconnect);
+	if (ret)
+		icc_bulk_put(1, interconnect);
+
+	return ret;
 }
 
 static void ipa_interconnect_exit_one(struct icc_bulk_data *interconnect)
 {
-	icc_put(interconnect->path);
+	icc_bulk_put(1, interconnect);
 	memset(interconnect, 0, sizeof(*interconnect));
 }
 
-- 
2.32.0

