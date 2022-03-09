Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D184D3A11
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiCITVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbiCITVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:21:43 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884354BFCD
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:20:44 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id b16so3959721ioz.3
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NJSgbV82nLgKXKYaIVZ+XNSiEnkL4FwHctPzlM9hZrc=;
        b=E+A3m3Df2XZeF4WfA5W7GVhkpFgmg9kxaclocllYJcx2vNHTjcPe6dECAze201rv3s
         YKsGo/s2UfGIUfjwSrZWVks0rBMVTwR8hwy3jOWFhPEBDHLqDS1TmB5YK9C/MRXDKnBP
         AsyuckYzkQfZUJLCYzTuJiuUO/KSc57TButhaa+4XDLz0OwXKdKZCgmfFzNZ6mBFz9Fn
         6GEJHrm+dUebenr/vmRH3kbAhnVKLHKX+9P9rKi4R5Vg+5fhW8/ze0hmTpO0Vzmvw81t
         RlxUDm/vik2EVXVJ5BSCcJ0hd4PGgAP2fU6IiClUept58mY0xC80hfYC7QzLmOc+7e67
         wYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NJSgbV82nLgKXKYaIVZ+XNSiEnkL4FwHctPzlM9hZrc=;
        b=WxMTAQzZ4PjTRawVqEAvVN6INGrKv4gBQp0W7owwSlNBw8sZUCyAKp2sTHebmpfqm+
         dFdrwvyabTlvDH6ORBm2MixryiwDdzqhLdoWtwMzyJyBcuN5m6H1NSYxxpSYr0bvm45W
         NJlKXW20K3jdS/ecy3d4Ww7vp71UnbIvimKzuFBjC0HxHWENz/bmNOu0PZMKiu+Z6VRc
         M1L+LUGGaEisZRnb9Wh0zVrRWJZakCWxBj2BC3ulwoel8VsD9aPqYxHdZBjWL+19qMNr
         6qx/WWWz8wZj/pPBDtsmWWvv3SenOXmnSyGHSZAZgcfVYabm54d87RH9SCXGIZzE94xt
         i1cw==
X-Gm-Message-State: AOAM531ACmsUTOafCQsu/UkHSQCTwN7Xyle7bb8F7KSHfBYNdwLtgTp5
        2xDnb2wv6q8ItaA4laGYiLTroQ==
X-Google-Smtp-Source: ABdhPJyzWkE0R4hdkxEKhIFmAMfHP6yTrmf7JfNf0/fXQz62F1a9csVpdC6JulbEzbMuZOvpfNJsVQ==
X-Received: by 2002:a02:a690:0:b0:319:aed8:5d3 with SMTP id j16-20020a02a690000000b00319aed805d3mr418916jam.102.1646853643958;
        Wed, 09 Mar 2022 11:20:43 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a056602248800b006409fb2cbccsm1389182ioe.32.2022.03.09.11.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:20:43 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/7] net: ipa: kill struct ipa_interconnect
Date:   Wed,  9 Mar 2022 13:20:31 -0600
Message-Id: <20220309192037.667879-2-elder@linaro.org>
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

The ipa_interconnect structure contains an icc_path pointer, plus an
average and peak bandwidth value.  Other than the interconnect name,
this matches the icc_bulk_data structure exactly.

Use the icc_bulk_data structure in place of the ipa_interconnect
structure, and add an initialization of its name field.  Then get
rid of the now unnecessary ipa_interconnect structure definition.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 39 +++++++++++++------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index f2989aac47a62..28be0e45cccfd 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -34,18 +34,6 @@
 
 #define IPA_AUTOSUSPEND_DELAY	500	/* milliseconds */
 
-/**
- * struct ipa_interconnect - IPA interconnect information
- * @path:		Interconnect path
- * @average_bandwidth:	Average interconnect bandwidth (KB/second)
- * @peak_bandwidth:	Peak interconnect bandwidth (KB/second)
- */
-struct ipa_interconnect {
-	struct icc_path *path;
-	u32 average_bandwidth;
-	u32 peak_bandwidth;
-};
-
 /**
  * enum ipa_power_flag - IPA power flags
  * @IPA_POWER_FLAG_RESUMED:	Whether resume from suspend has been signaled
@@ -79,11 +67,11 @@ struct ipa_power {
 	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
-	struct ipa_interconnect *interconnect;
+	struct icc_bulk_data *interconnect;
 };
 
 static int ipa_interconnect_init_one(struct device *dev,
-				     struct ipa_interconnect *interconnect,
+				     struct icc_bulk_data *interconnect,
 				     const struct ipa_interconnect_data *data)
 {
 	struct icc_path *path;
@@ -99,13 +87,14 @@ static int ipa_interconnect_init_one(struct device *dev,
 	}
 
 	interconnect->path = path;
-	interconnect->average_bandwidth = data->average_bandwidth;
-	interconnect->peak_bandwidth = data->peak_bandwidth;
+	interconnect->name = data->name;
+	interconnect->avg_bw = data->average_bandwidth;
+	interconnect->peak_bw = data->peak_bandwidth;
 
 	return 0;
 }
 
-static void ipa_interconnect_exit_one(struct ipa_interconnect *interconnect)
+static void ipa_interconnect_exit_one(struct icc_bulk_data *interconnect)
 {
 	icc_put(interconnect->path);
 	memset(interconnect, 0, sizeof(*interconnect));
@@ -115,7 +104,7 @@ static void ipa_interconnect_exit_one(struct ipa_interconnect *interconnect)
 static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 				 const struct ipa_interconnect_data *data)
 {
-	struct ipa_interconnect *interconnect;
+	struct icc_bulk_data *interconnect;
 	u32 count;
 	int ret;
 
@@ -146,7 +135,7 @@ static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 /* Inverse of ipa_interconnect_init() */
 static void ipa_interconnect_exit(struct ipa_power *power)
 {
-	struct ipa_interconnect *interconnect;
+	struct icc_bulk_data *interconnect;
 
 	interconnect = power->interconnect + power->interconnect_count;
 	while (interconnect-- > power->interconnect)
@@ -158,7 +147,7 @@ static void ipa_interconnect_exit(struct ipa_power *power)
 /* Currently we only use one bandwidth level, so just "enable" interconnects */
 static int ipa_interconnect_enable(struct ipa *ipa)
 {
-	struct ipa_interconnect *interconnect;
+	struct icc_bulk_data *interconnect;
 	struct ipa_power *power = ipa->power;
 	int ret;
 	u32 i;
@@ -166,12 +155,12 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 	interconnect = power->interconnect;
 	for (i = 0; i < power->interconnect_count; i++) {
 		ret = icc_set_bw(interconnect->path,
-				 interconnect->average_bandwidth,
-				 interconnect->peak_bandwidth);
+				 interconnect->avg_bw,
+				 interconnect->peak_bw);
 		if (ret) {
 			dev_err(&ipa->pdev->dev,
 				"error %d enabling %s interconnect\n",
-				ret, icc_get_name(interconnect->path));
+				ret, interconnect->name);
 			goto out_unwind;
 		}
 		interconnect++;
@@ -189,9 +178,9 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 /* To disable an interconnect, we just its bandwidth to 0 */
 static int ipa_interconnect_disable(struct ipa *ipa)
 {
-	struct ipa_interconnect *interconnect;
 	struct ipa_power *power = ipa->power;
 	struct device *dev = &ipa->pdev->dev;
+	struct icc_bulk_data *interconnect;
 	int result = 0;
 	u32 count;
 	int ret;
@@ -203,7 +192,7 @@ static int ipa_interconnect_disable(struct ipa *ipa)
 		ret = icc_set_bw(interconnect->path, 0, 0);
 		if (ret) {
 			dev_err(dev, "error %d disabling %s interconnect\n",
-				ret, icc_get_name(interconnect->path));
+				ret, interconnect->name);
 			/* Try to disable all; record only the first error */
 			if (!result)
 				result = ret;
-- 
2.32.0

