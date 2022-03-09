Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E338F4D3A02
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbiCITVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbiCITVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:21:46 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815145675A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:20:47 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id k25so3893238iok.8
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5LJv5iPo5cfeDn7N9X9RNaWuiPsLPljE4VKtBlutQww=;
        b=qUG4z67OgiA7yzlxO55VgCWHFSXjrPoIKNgGXxYJ/EVfCiZ/4lWOp2CUjfNf4WQp5S
         fXJM3hjdPwRo7p0Q0ZONBqdzmRzwOGSab1iSgR9OjqvGURMOX5x3uvC/UBGt+LknkkIN
         uTJ+63ldQRGqztu2jEaw6/mbfSy/bpnuKLulPjrjUCso/TveswO5jzLsyEh4iEHS+cbl
         DK36rdqE8XBQUUiiNROVraobvyxQ54lCaXvcFjW+1jYufM/atPgI3sU88ruYK1bYyDKe
         CbL+g0mWfiRk9I75XK0dOnOGbDLGsyQM9M9eOpSptMnoW1viVj+tTgcqdPppjpsWKbGC
         qjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5LJv5iPo5cfeDn7N9X9RNaWuiPsLPljE4VKtBlutQww=;
        b=td8QanEqtS2AjZdQuZAJKvtHl1VnG9AyWGd5vJ3Cegq98U6tGHQIX44cuOzK2GA+Xy
         EaL3trFzlbe+Ca0K93C2jDWfbzTCfrfSTsgMNFEt7/UOWnjFStpyVggy0xXsGxHNu/0L
         qIanYyVQYn1tEW1/rN5o7mOlULsdybDAkRQJIzIUQr9RuMQ1UV9GsOXKYF7mQ0LQoTdF
         rW4LQWPylD4bDawU+G1VetWIJi/JGqoEhYxRMIKRsd+/j32F0AB3LkS+9plCpBwQaBpz
         ZwYJj4C/W1Kn1/PykAoegvqppZIZgc1meioN5GO98lXP40gRaXXae1XyVk3QO+0iSBLK
         Gp4w==
X-Gm-Message-State: AOAM5334AKnyE0y9HM1k4lw0nBzjlLXlmZO+7Bt5bCtZAwLTDtBNas07
        0pvSyQYT/u03PY96OGPYyYWMmQ==
X-Google-Smtp-Source: ABdhPJypAzVHZp5TOnYfcOxSKC9WT14z03V42SUGheb2MUrkUPWSJ6B6vfme8jgq3tNBlWgFpg62pQ==
X-Received: by 2002:a02:cadb:0:b0:317:b785:8ab2 with SMTP id f27-20020a02cadb000000b00317b7858ab2mr894264jap.108.1646853646899;
        Wed, 09 Mar 2022 11:20:46 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a056602248800b006409fb2cbccsm1389182ioe.32.2022.03.09.11.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:20:46 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/7] net: ipa: use interconnect bulk enable/disable operations
Date:   Wed,  9 Mar 2022 13:20:33 -0600
Message-Id: <20220309192037.667879-4-elder@linaro.org>
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

The power interconnect array is now an array of icc_bulk_data
structures, which is what the interconnect bulk enable and disable
functions require.

Get rid of ipa_interconnect_enable() and ipa_interconnect_disable(),
and just call icc_bulk_enable() and icc_bulk_disable() instead.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 76 +++++++------------------------------
 1 file changed, 13 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index ec2ebc74edb8b..67f76e6a6ae59 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -156,86 +156,34 @@ static void ipa_interconnect_exit(struct ipa_power *power)
 	power->interconnect = NULL;
 }
 
-/* Currently we only use one bandwidth level, so just "enable" interconnects */
-static int ipa_interconnect_enable(struct ipa *ipa)
-{
-	struct icc_bulk_data *interconnect;
-	struct ipa_power *power = ipa->power;
-	int ret;
-	u32 i;
-
-	interconnect = power->interconnect;
-	for (i = 0; i < power->interconnect_count; i++) {
-		ret = icc_enable(interconnect->path);
-		if (ret) {
-			dev_err(&ipa->pdev->dev,
-				"error %d enabling %s interconnect\n",
-				ret, interconnect->name);
-			goto out_unwind;
-		}
-		interconnect++;
-	}
-
-	return 0;
-
-out_unwind:
-	while (interconnect-- > power->interconnect)
-		(void)icc_disable(interconnect->path);
-
-	return ret;
-}
-
-/* To disable an interconnect, we just its bandwidth to 0 */
-static int ipa_interconnect_disable(struct ipa *ipa)
-{
-	struct ipa_power *power = ipa->power;
-	struct device *dev = &ipa->pdev->dev;
-	struct icc_bulk_data *interconnect;
-	int result = 0;
-	u32 count;
-	int ret;
-
-	count = power->interconnect_count;
-	interconnect = power->interconnect + count;
-	while (count--) {
-		interconnect--;
-		ret = icc_disable(interconnect->path);
-		if (ret) {
-			dev_err(dev, "error %d disabling %s interconnect\n",
-				ret, interconnect->name);
-			/* Try to disable all; record only the first error */
-			if (!result)
-				result = ret;
-		}
-	}
-
-	return result;
-}
-
 /* Enable IPA power, enabling interconnects and the core clock */
 static int ipa_power_enable(struct ipa *ipa)
 {
+	struct ipa_power *power = ipa->power;
 	int ret;
 
-	ret = ipa_interconnect_enable(ipa);
+	ret = icc_bulk_enable(power->interconnect_count, power->interconnect);
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(ipa->power->core);
+	ret = clk_prepare_enable(power->core);
 	if (ret) {
 		dev_err(&ipa->pdev->dev, "error %d enabling core clock\n", ret);
-		(void)ipa_interconnect_disable(ipa);
+		icc_bulk_disable(power->interconnect_count,
+				 power->interconnect);
 	}
 
 	return ret;
 }
 
 /* Inverse of ipa_power_enable() */
-static int ipa_power_disable(struct ipa *ipa)
+static void ipa_power_disable(struct ipa *ipa)
 {
-	clk_disable_unprepare(ipa->power->core);
+	struct ipa_power *power = ipa->power;
 
-	return ipa_interconnect_disable(ipa);
+	clk_disable_unprepare(power->core);
+
+	icc_bulk_disable(power->interconnect_count, power->interconnect);
 }
 
 static int ipa_runtime_suspend(struct device *dev)
@@ -249,7 +197,9 @@ static int ipa_runtime_suspend(struct device *dev)
 		gsi_suspend(&ipa->gsi);
 	}
 
-	return ipa_power_disable(ipa);
+	ipa_power_disable(ipa);
+
+	return 0;
 }
 
 static int ipa_runtime_resume(struct device *dev)
-- 
2.32.0

