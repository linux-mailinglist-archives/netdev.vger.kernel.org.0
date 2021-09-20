Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517D4410EB0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhITDMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbhITDLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:11:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED389C0613D9;
        Sun, 19 Sep 2021 20:09:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v19so10965134pjh.2;
        Sun, 19 Sep 2021 20:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nx+Keww1ap7Q1GT99LR3K8AXWY7zLOL5OTsLA8UhvOM=;
        b=O7Pg5+Mj9+CJJEgeLJsP3vOjvtY5TlgsmPyvFP8OPYAe+E4o9WweXxU8K/q23Au5H4
         K2ltUojHHp3H+nd05fkJGeBG22nVGiGvttsPPVBmDYnQwGCJHzHWq76H28LZyA0GNpvJ
         yqDPzQ6ezXfEj/d1jya5xt1hvehmL7rv/p2kPVDz1CTWFJ/kdftMJTnI06vtqcFUX9A/
         N+AdFnC50JCXa6gm3bJtkT2usqJSd0zSNYB0aGdOf86YHK0motu48FnvxIBFEA6Laoit
         NSL9DMrIc/NrpQqiOUcdeCvP0XZgwhpsmeEshYGfgStP6vrwNYgitJlGIwkxXIq9U5Ct
         6KZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nx+Keww1ap7Q1GT99LR3K8AXWY7zLOL5OTsLA8UhvOM=;
        b=arAujoHtzJFJQtW9gprzhah22B0AFHhvHui8E/upe64AaZCkyby9nongVb2TpDIV9q
         bCHn7IuGtDHdqwFH0nhg27mIUrOrXp7ewt3dfAQIySqPNqvxY1GxtJNatVhzOBuFCP9O
         Qk8aB8cBYFZ2W6eB0gYP6YtCIBySlANvYesNcFMlP5gKyzoVO5VonLlnINj3qsZFj3im
         2xp5DZrYP4LBcuCXz6Bhy3PG9T/PJbSwzFOvh/uMrcJ35zGrY5+gx6QAP4az/268JyJi
         cDPiobR9oXdyE/L8RNdLSJ7gQrc8bAslmuhS064oMdmo09/urrGKp3I6KAFyAtXa62WK
         E6Tw==
X-Gm-Message-State: AOAM532gNd/CYGkq8goAwoD/hF43GHkWAp4RD0Ht9VsEoNj85IV5SihF
        2IspWdL4FGn5czOj2yi8SpU3xrUi3USxyvB8
X-Google-Smtp-Source: ABdhPJy7IKYgQd4ifNlNe5I7EgNBFHYZ2Mab5RFIe0QFow3MNwK8FXS48sQ+KrrjiN2sjKIqs5ifhA==
X-Received: by 2002:a17:902:e153:b0:13b:63ba:7292 with SMTP id d19-20020a170902e15300b0013b63ba7292mr20776133pla.17.1632107381200;
        Sun, 19 Sep 2021 20:09:41 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:09:40 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 11/17] net: ipa: Add support for IPA v2.x endpoints
Date:   Mon, 20 Sep 2021 08:38:05 +0530
Message-Id: <20210920030811.57273-12-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v2.x endpoints are the same as the endpoints on later versions. The
only big change was the addition of the "skip_config" flag. The only
other change is the backlog limit, which is a fixed number for IPA v2.6L

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_endpoint.c | 65 ++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7d3ab61cd890..024cf3a0ded0 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -360,8 +360,10 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 {
 	u32 endpoint_id;
 
-	/* DELAY mode doesn't work correctly on IPA v4.2 */
-	if (ipa->version == IPA_VERSION_4_2)
+	/* DELAY mode doesn't work correctly on IPA v4.2
+	 * Pausing is not supported on IPA v2.6L
+	 */
+	if (ipa->version == IPA_VERSION_4_2 || ipa->version <= IPA_VERSION_2_6L)
 		return;
 
 	for (endpoint_id = 0; endpoint_id < IPA_ENDPOINT_MAX; endpoint_id++) {
@@ -383,6 +385,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 {
 	u32 initialized = ipa->initialized;
 	struct ipa_trans *trans;
+	u32 value = 0, value_mask = ~0;
 	u32 count;
 
 	/* We need one command per modem TX endpoint.  We can get an upper
@@ -398,6 +401,11 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		return -EBUSY;
 	}
 
+	if (ipa->version <= IPA_VERSION_2_6L) {
+		value = aggr_force_close_fmask(true);
+		value_mask = aggr_force_close_fmask(true);
+	}
+
 	while (initialized) {
 		u32 endpoint_id = __ffs(initialized);
 		struct ipa_endpoint *endpoint;
@@ -416,7 +424,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		 * means status is disabled on the endpoint, and as a
 		 * result all other fields in the register are ignored.
 		 */
-		ipa_cmd_register_write_add(trans, offset, 0, ~0, false);
+		ipa_cmd_register_write_add(trans, offset, value, value_mask, false);
 	}
 
 	ipa_cmd_pipeline_clear_add(trans);
@@ -1531,8 +1539,10 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_init_aggr(endpoint);
 	ipa_endpoint_init_deaggr(endpoint);
-	ipa_endpoint_init_rsrc_grp(endpoint);
-	ipa_endpoint_init_seq(endpoint);
+	if (endpoint->ipa->version > IPA_VERSION_2_6L) {
+		ipa_endpoint_init_rsrc_grp(endpoint);
+		ipa_endpoint_init_seq(endpoint);
+	}
 	ipa_endpoint_status(endpoint);
 }
 
@@ -1592,7 +1602,6 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
 	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
-	bool stop_channel;
 	int ret;
 
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
@@ -1613,7 +1622,6 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
 	struct ipa_dma *gsi = &endpoint->ipa->dma_subsys;
-	bool start_channel;
 	int ret;
 
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
@@ -1750,23 +1758,33 @@ int ipa_endpoint_config(struct ipa *ipa)
 	/* Find out about the endpoints supplied by the hardware, and ensure
 	 * the highest one doesn't exceed the number we support.
 	 */
-	val = ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
-
-	/* Our RX is an IPA producer */
-	rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
-	max = rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
-	if (max > IPA_ENDPOINT_MAX) {
-		dev_err(dev, "too many endpoints (%u > %u)\n",
-			max, IPA_ENDPOINT_MAX);
-		return -EINVAL;
-	}
-	rx_mask = GENMASK(max - 1, rx_base);
+	if (ipa->version <= IPA_VERSION_2_6L) {
+		// FIXME Not used anywhere?
+		if (ipa->version == IPA_VERSION_2_6L)
+			val = ioread32(ipa->reg_virt +
+					IPA_REG_V2_ENABLED_PIPES_OFFSET);
+		/* IPA v2.6L supports 20 pipes */
+		ipa->available = ipa->filter_map;
+		return 0;
+	} else {
+		val = ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
+
+		/* Our RX is an IPA producer */
+		rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
+		max = rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
+		if (max > IPA_ENDPOINT_MAX) {
+			dev_err(dev, "too many endpoints (%u > %u)\n",
+					max, IPA_ENDPOINT_MAX);
+			return -EINVAL;
+		}
+		rx_mask = GENMASK(max - 1, rx_base);
 
-	/* Our TX is an IPA consumer */
-	max = u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
-	tx_mask = GENMASK(max - 1, 0);
+		/* Our TX is an IPA consumer */
+		max = u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
+		tx_mask = GENMASK(max - 1, 0);
 
-	ipa->available = rx_mask | tx_mask;
+		ipa->available = rx_mask | tx_mask;
+	}
 
 	/* Check for initialized endpoints not supported by the hardware */
 	if (ipa->initialized & ~ipa->available) {
@@ -1865,6 +1883,9 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 			filter_map |= BIT(data->endpoint_id);
 	}
 
+	if (ipa->version <= IPA_VERSION_2_6L)
+		filter_map = 0x1fffff;
+
 	if (!ipa_filter_map_valid(ipa, filter_map))
 		goto err_endpoint_exit;
 
-- 
2.33.0

