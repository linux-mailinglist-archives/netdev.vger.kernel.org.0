Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211F64D3A08
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiCITVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiCITVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:21:46 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DFB1B79B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:20:46 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id x4so3925908iop.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2OpxrECw+JfiUzuzU5c0ZHXTX3WGTRoSTdmnh1YRIC8=;
        b=lr5I8zByPz9LAOpeoXVbxybe1QruJW8EpJropdUrJuu0WldcfKYP8iVlQf/kVpn3qM
         JLMCZhM5YWGHs9JhkfaNDPB0Wh/InyGDfY5gvkJVTl89Cl9pez+/WP13crgcmHQABaFE
         mKc7VsQdY2Y9K6i31Sn2L08dXT3afAfKSNvmX5v8p8ihVaUxxojl+3+n2J/rO+L/q0P4
         8o8tquGxi4+SpWjTZev66LdssgH6Qytsjizbk0Yp4ekw5OSq1WPf2m+KiTJREHVxVB8m
         8Bj3tJ5gAz4/1pNM+Zq4o3FZDz+VSWIuryMHtKM3/+Mln9vbhR9PmFkzYZ7xB9Ytd+by
         EkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2OpxrECw+JfiUzuzU5c0ZHXTX3WGTRoSTdmnh1YRIC8=;
        b=DgHXlbeysnaPebcQPepR0DRFq824N/i2Yubu6lTaciszcrpr7lLXsQegr5u/1NATzZ
         wwy9ByO1E598obKTzD8d8KXhWR62X04Xy6W2CJiskhb1PlGrVJ3p3Y9zDX+wrynRaECm
         AyRwEl9LF4fo1Rh66EZVUGWDqtWYvgj/2q3ibBIBjtuWg7Nep7/gRIJrOsJVpCzIz3ds
         bNk1jHA++qO3jAQdTL+6YRgSO1GZIr6o6NiGwxzN4pfpq+XwA3453dj9p5yND6G4Uxmw
         SjVZ8+4ksHNB64YhR8Npom5zKKmBEZUt67jSzsIvOJRwO9kgiA5r4a00ayocuo5pk+XF
         PxJQ==
X-Gm-Message-State: AOAM5323qyci8jALKbUvXP23JrW4el5HHtvmFF/JgeDEC//fkn5FNtrV
        v1x/MoEwra8MttyY1IYT/lToCg==
X-Google-Smtp-Source: ABdhPJxSclbwA49r0YgPolsFP2X0A5/blFUbhDuhfW68UIesorjTvLCLm2kBfhX50RFHem9OcUHkXg==
X-Received: by 2002:a05:6638:737:b0:317:d5e0:2b3a with SMTP id j23-20020a056638073700b00317d5e02b3amr837873jad.52.1646853645502;
        Wed, 09 Mar 2022 11:20:45 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a056602248800b006409fb2cbccsm1389182ioe.32.2022.03.09.11.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:20:44 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: ipa: use icc_enable() and icc_disable()
Date:   Wed,  9 Mar 2022 13:20:32 -0600
Message-Id: <20220309192037.667879-3-elder@linaro.org>
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

The interconnect framework now provides the ability to enable and
disable interconnects without having to change their recorded
"enabled" bandwidth value.  Use this mechanism, rather than setting
the bandwidth values to zero and non-zero respectively to disable
and enable the IPA interconnects.

Disable each interconnect before setting its "enabled" average and
peak bandwidth values.  Thereafter, enable and disable interconnects
when required rather than setting their bandwidths.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 28be0e45cccfd..ec2ebc74edb8b 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -75,17 +75,29 @@ static int ipa_interconnect_init_one(struct device *dev,
 				     const struct ipa_interconnect_data *data)
 {
 	struct icc_path *path;
+	int ret;
 
 	path = of_icc_get(dev, data->name);
 	if (IS_ERR(path)) {
-		int ret = PTR_ERR(path);
-
+		ret = PTR_ERR(path);
 		dev_err_probe(dev, ret, "error getting %s interconnect\n",
 			      data->name);
 
 		return ret;
 	}
 
+	/* All interconnects are initially disabled */
+	(void)icc_disable(path);
+
+	/* Set the bandwidth values to be used when enabled */
+	ret = icc_set_bw(path, data->average_bandwidth, data->peak_bandwidth);
+	if (ret) {
+		dev_err(dev, "error %d setting %s interconnect bandwidths\n",
+			ret, data->name);
+
+		return ret;
+	}
+
 	interconnect->path = path;
 	interconnect->name = data->name;
 	interconnect->avg_bw = data->average_bandwidth;
@@ -154,9 +166,7 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 
 	interconnect = power->interconnect;
 	for (i = 0; i < power->interconnect_count; i++) {
-		ret = icc_set_bw(interconnect->path,
-				 interconnect->avg_bw,
-				 interconnect->peak_bw);
+		ret = icc_enable(interconnect->path);
 		if (ret) {
 			dev_err(&ipa->pdev->dev,
 				"error %d enabling %s interconnect\n",
@@ -170,7 +180,7 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 
 out_unwind:
 	while (interconnect-- > power->interconnect)
-		(void)icc_set_bw(interconnect->path, 0, 0);
+		(void)icc_disable(interconnect->path);
 
 	return ret;
 }
@@ -189,7 +199,7 @@ static int ipa_interconnect_disable(struct ipa *ipa)
 	interconnect = power->interconnect + count;
 	while (count--) {
 		interconnect--;
-		ret = icc_set_bw(interconnect->path, 0, 0);
+		ret = icc_disable(interconnect->path);
 		if (ret) {
 			dev_err(dev, "error %d disabling %s interconnect\n",
 				ret, interconnect->name);
-- 
2.32.0

