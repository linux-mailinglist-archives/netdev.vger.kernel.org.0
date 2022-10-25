Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6DE60D4F8
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiJYTwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiJYTv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:51:58 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DD2106A66
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:57 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id q75so1648606iod.7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7B4T5dUVw6etXvayl+cOcjo1M7wurOEEeDstMQ8ZtZg=;
        b=hUaVsWOGWyaSIosq63z4jw7GX1Bn5s1AHfIlC9ZMChVn0NEjUE3wDtV26cX10TYgd7
         dCf1bPomRKPwcqnRyuIiiilrbEwJE6MiHjO7HsQ1RAwZRfRoF9ORG8YYpCfZYErqX2Bs
         mv2wFmzF+JU3najiQ4H4jaZhHplgRwmIAOG+hPQgTLXbJu362FT+cz3Rqwdm5TvPeLqH
         ELARFOmsjXAvGAbBA5esRoeRkK+LJt68khYDskA2GTML79dKOk0fzkqWl9/gKqeJ3IKY
         16VMFDeoqjEheVnegvtGvymC70FJ8TlfIFG7TT84RPXM3OxvLXL9usIeRaXDACXyYglV
         7OGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7B4T5dUVw6etXvayl+cOcjo1M7wurOEEeDstMQ8ZtZg=;
        b=E4XDC9/m4hOQmqEjgkkC6nEqPBu6bKd712e4ZnSnj71BD2GM9cXusaaX+GF++Bgfii
         DDXFBOorAo7nqzwSK8tewEnq7KbhK8fgl/ofgLlCQFPuDHCQO3QjDrbJJLEHZi6OjuA8
         86LlF0Hiepa7sMnLUQ+KpFXUM/59iWJn0j6p4Q0aCEVK0mzYhbZeql7CcXDHiqb4E7e7
         0/c6iiNMwvGOBCX9Ly1DS6eZORXKfFHCS+uBOP1J4dTC53EO71oNiVoySypShhnP+d58
         MGrGaNHTcOEGKiiFT42CBGTqbKwx7smggVp8ncxR8PGvERGMAxwuejOEhMg5KRHiN5W3
         VT1w==
X-Gm-Message-State: ACrzQf3x+zDFO7CFyjwxYxBh9tpCupIeDF+R0GP9xsy+Xf432dAPjiyn
        2tw7FLLwSWGTs0Wd8qtABt82oQ==
X-Google-Smtp-Source: AMsMyM4+ZJRfXCySfhnxPi41jW74/C8HppkdHfX+jpY7PNUKYZ/4vhAvApphk0hFMQHa+/I2QKQsIA==
X-Received: by 2002:a05:6638:144a:b0:364:5a1:d54d with SMTP id l10-20020a056638144a00b0036405a1d54dmr25032063jad.42.1666727516327;
        Tue, 25 Oct 2022 12:51:56 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id y10-20020a056638014a00b00349d2d52f6asm1211719jao.37.2022.10.25.12.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:51:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: ipa: don't assume 8 modem routing table entries
Date:   Tue, 25 Oct 2022 14:51:42 -0500
Message-Id: <20221025195143.255934-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221025195143.255934-1-elder@linaro.org>
References: <20221025195143.255934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently all platforms are assumed allot 8 routing table entries
for use by the modem.  Instead, add a new configuration data entry
that defines the number of modem routing table entries, and record
that in the IPA structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/data/ipa_data-v3.1.c   | 19 +++++++++---------
 drivers/net/ipa/data/ipa_data-v3.5.1.c | 27 +++++++++++++-------------
 drivers/net/ipa/data/ipa_data-v4.11.c  | 17 ++++++++--------
 drivers/net/ipa/data/ipa_data-v4.2.c   | 17 ++++++++--------
 drivers/net/ipa/data/ipa_data-v4.5.c   | 17 ++++++++--------
 drivers/net/ipa/data/ipa_data-v4.9.c   | 17 ++++++++--------
 drivers/net/ipa/ipa.h                  |  2 ++
 drivers/net/ipa/ipa_data.h             |  2 ++
 drivers/net/ipa/ipa_main.c             |  6 ++++++
 drivers/net/ipa/ipa_mem.c              |  4 ++--
 drivers/net/ipa/ipa_qmi.c              |  9 +++++----
 drivers/net/ipa/ipa_table.c            | 21 +++++++++-----------
 drivers/net/ipa/ipa_table.h            |  7 ++-----
 13 files changed, 88 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v3.1.c b/drivers/net/ipa/data/ipa_data-v3.1.c
index e0d71f6092729..3380fb3483b2c 100644
--- a/drivers/net/ipa/data/ipa_data-v3.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.1.c
@@ -525,13 +525,14 @@ static const struct ipa_power_data ipa_power_data = {
 
 /* Configuration data for an SoC having IPA v3.1 */
 const struct ipa_data ipa_data_v3_1 = {
-	.version	= IPA_VERSION_3_1,
-	.backward_compat = BIT(BCR_CMDQ_L_LACK_ONE_ENTRY),
-	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
-	.qsb_data	= ipa_qsb_data,
-	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
-	.endpoint_data	= ipa_gsi_endpoint_data,
-	.resource_data	= &ipa_resource_data,
-	.mem_data	= &ipa_mem_data,
-	.power_data	= &ipa_power_data,
+	.version		= IPA_VERSION_3_1,
+	.backward_compat	= BIT(BCR_CMDQ_L_LACK_ONE_ENTRY),
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count      = 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/data/ipa_data-v3.5.1.c b/drivers/net/ipa/data/ipa_data-v3.5.1.c
index 383ef18900654..47591faf8bd62 100644
--- a/drivers/net/ipa/data/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.5.1.c
@@ -406,17 +406,18 @@ static const struct ipa_power_data ipa_power_data = {
 
 /* Configuration data for an SoC having IPA v3.5.1 */
 const struct ipa_data ipa_data_v3_5_1 = {
-	.version	= IPA_VERSION_3_5_1,
-	.backward_compat = BIT(BCR_CMDQ_L_LACK_ONE_ENTRY) |
-			   BIT(BCR_TX_NOT_USING_BRESP) |
-			   BIT(BCR_SUSPEND_L2_IRQ) |
-			   BIT(BCR_HOLB_DROP_L2_IRQ) |
-			   BIT(BCR_DUAL_TX),
-	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
-	.qsb_data	= ipa_qsb_data,
-	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
-	.endpoint_data	= ipa_gsi_endpoint_data,
-	.resource_data	= &ipa_resource_data,
-	.mem_data	= &ipa_mem_data,
-	.power_data	= &ipa_power_data,
+	.version		= IPA_VERSION_3_5_1,
+	.backward_compat	= BIT(BCR_CMDQ_L_LACK_ONE_ENTRY) |
+				  BIT(BCR_TX_NOT_USING_BRESP) |
+				  BIT(BCR_SUSPEND_L2_IRQ) |
+				  BIT(BCR_HOLB_DROP_L2_IRQ) |
+				  BIT(BCR_DUAL_TX),
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count      = 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/data/ipa_data-v4.11.c b/drivers/net/ipa/data/ipa_data-v4.11.c
index a204e439c23d3..1b4b52501ee33 100644
--- a/drivers/net/ipa/data/ipa_data-v4.11.c
+++ b/drivers/net/ipa/data/ipa_data-v4.11.c
@@ -394,12 +394,13 @@ static const struct ipa_power_data ipa_power_data = {
 
 /* Configuration data for an SoC having IPA v4.11 */
 const struct ipa_data ipa_data_v4_11 = {
-	.version	= IPA_VERSION_4_11,
-	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
-	.qsb_data	= ipa_qsb_data,
-	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
-	.endpoint_data	= ipa_gsi_endpoint_data,
-	.resource_data	= &ipa_resource_data,
-	.mem_data	= &ipa_mem_data,
-	.power_data	= &ipa_power_data,
+	.version		= IPA_VERSION_4_11,
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count	= 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/data/ipa_data-v4.2.c b/drivers/net/ipa/data/ipa_data-v4.2.c
index 04f574fe006f0..199ed0ed868b9 100644
--- a/drivers/net/ipa/data/ipa_data-v4.2.c
+++ b/drivers/net/ipa/data/ipa_data-v4.2.c
@@ -372,13 +372,14 @@ static const struct ipa_power_data ipa_power_data = {
 
 /* Configuration data for an SoC having IPA v4.2 */
 const struct ipa_data ipa_data_v4_2 = {
-	.version	= IPA_VERSION_4_2,
+	.version		= IPA_VERSION_4_2,
 	/* backward_compat value is 0 */
-	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
-	.qsb_data	= ipa_qsb_data,
-	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
-	.endpoint_data	= ipa_gsi_endpoint_data,
-	.resource_data	= &ipa_resource_data,
-	.mem_data	= &ipa_mem_data,
-	.power_data	= &ipa_power_data,
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count	= 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/data/ipa_data-v4.5.c b/drivers/net/ipa/data/ipa_data-v4.5.c
index 684239e71f46a..19b549f2998b8 100644
--- a/drivers/net/ipa/data/ipa_data-v4.5.c
+++ b/drivers/net/ipa/data/ipa_data-v4.5.c
@@ -450,12 +450,13 @@ static const struct ipa_power_data ipa_power_data = {
 
 /* Configuration data for an SoC having IPA v4.5 */
 const struct ipa_data ipa_data_v4_5 = {
-	.version	= IPA_VERSION_4_5,
-	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
-	.qsb_data	= ipa_qsb_data,
-	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
-	.endpoint_data	= ipa_gsi_endpoint_data,
-	.resource_data	= &ipa_resource_data,
-	.mem_data	= &ipa_mem_data,
-	.power_data	= &ipa_power_data,
+	.version		= IPA_VERSION_4_5,
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count	= 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/data/ipa_data-v4.9.c b/drivers/net/ipa/data/ipa_data-v4.9.c
index 2333e15f95338..d30fc1fe6ca22 100644
--- a/drivers/net/ipa/data/ipa_data-v4.9.c
+++ b/drivers/net/ipa/data/ipa_data-v4.9.c
@@ -444,12 +444,13 @@ static const struct ipa_power_data ipa_power_data = {
 
 /* Configuration data for an SoC having IPA v4.9. */
 const struct ipa_data ipa_data_v4_9 = {
-	.version	= IPA_VERSION_4_9,
-	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
-	.qsb_data	= ipa_qsb_data,
-	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
-	.endpoint_data	= ipa_gsi_endpoint_data,
-	.resource_data	= &ipa_resource_data,
-	.mem_data	= &ipa_mem_data,
-	.power_data	= &ipa_power_data,
+	.version		= IPA_VERSION_4_9,
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count	= 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index aa39509e209a3..5c95acc70bb33 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -40,6 +40,7 @@ struct ipa_interrupt;
  * @table_addr:		DMA address of filter/route table content
  * @table_virt:		Virtual address of filter/route table content
  * @route_count:	Total number of entries in a routing table
+ * @modem_route_count:	Number of modem entries in a routing table
  * @interrupt:		IPA Interrupt information
  * @uc_powered:		true if power is active by proxy for microcontroller
  * @uc_loaded:		true after microcontroller has reported it's ready
@@ -86,6 +87,7 @@ struct ipa {
 	dma_addr_t table_addr;
 	__le64 *table_virt;
 	u32 route_count;
+	u32 modem_route_count;
 
 	struct ipa_interrupt *interrupt;
 	bool uc_powered;
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index e5a6ce75c7ddd..412edbfac7862 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -222,6 +222,7 @@ struct ipa_power_data {
  * @backward_compat:	BCR register value (prior to IPA v4.5 only)
  * @qsb_count:		number of entries in the qsb_data array
  * @qsb_data:		Qualcomm System Bus configuration data
+ * @modem_route_count:	number of modem entries in a routing table
  * @endpoint_count:	number of entries in the endpoint_data array
  * @endpoint_data:	IPA endpoint/GSI channel data
  * @resource_data:	IPA resource configuration data
@@ -233,6 +234,7 @@ struct ipa_data {
 	u32 backward_compat;
 	u32 qsb_count;		/* number of entries in qsb_data[] */
 	const struct ipa_qsb_data *qsb_data;
+	u32 modem_route_count;
 	u32 endpoint_count;	/* number of entries in endpoint_data[] */
 	const struct ipa_gsi_endpoint_data *endpoint_data;
 	const struct ipa_resource_data *resource_data;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 3461ad3029ab8..ce5eadad671f3 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -739,6 +739,11 @@ static int ipa_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (!data->modem_route_count) {
+		dev_err(dev, "modem_route_count cannot be zero\n");
+		return -EINVAL;
+	}
+
 	/* If we need Trust Zone, make sure it's available */
 	modem_init = of_property_read_bool(dev->of_node, "modem-init");
 	if (!modem_init)
@@ -763,6 +768,7 @@ static int ipa_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ipa);
 	ipa->power = power;
 	ipa->version = data->version;
+	ipa->modem_route_count = data->modem_route_count;
 	init_completion(&ipa->completion);
 
 	ret = ipa_reg_init(ipa);
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index a3d2317452ac6..cb95402018394 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -618,9 +618,9 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem = mem_data->local;
 
 	/* Check the route and filter table memory regions */
-	if (!ipa_table_mem_valid(ipa, 0))
+	if (!ipa_table_mem_valid(ipa, false))
 		return -EINVAL;
-	if (!ipa_table_mem_valid(ipa, IPA_ROUTE_MODEM_COUNT))
+	if (!ipa_table_mem_valid(ipa, true))
 		return -EINVAL;
 
 	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 8295fd4b70d16..f70f0a1d1cdac 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -284,6 +284,7 @@ static const struct ipa_init_modem_driver_req *
 init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 {
 	struct ipa *ipa = container_of(ipa_qmi, struct ipa, qmi);
+	u32 modem_route_count = ipa->modem_route_count;
 	static struct ipa_init_modem_driver_req req;
 	const struct ipa_mem *mem;
 
@@ -308,12 +309,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
+	req.v4_route_tbl_info.end = modem_route_count - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
+	req.v6_route_tbl_info.end = modem_route_count - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,7 +353,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
+		req.v4_hash_route_tbl_info.end = modem_route_count - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
@@ -360,7 +361,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
+		req.v6_hash_route_tbl_info.end = modem_route_count - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 23d3f081ac8e1..c9ab6a3fabbc3 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -129,9 +129,6 @@ static void ipa_table_validate_build(void)
 	 * assumes that it can be written using a pointer to __le64.
 	 */
 	BUILD_BUG_ON(IPA_ZERO_RULE_SIZE != sizeof(__le64));
-
-	/* The modem must be allotted at least one route table entry */
-	BUILD_BUG_ON(!IPA_ROUTE_MODEM_COUNT);
 }
 
 static const struct ipa_mem *
@@ -281,6 +278,7 @@ static int ipa_filter_reset(struct ipa *ipa, bool modem)
  * */
 static int ipa_route_reset(struct ipa *ipa, bool modem)
 {
+	u32 modem_route_count = ipa->modem_route_count;
 	struct gsi_trans *trans;
 	u16 first;
 	u16 count;
@@ -295,10 +293,10 @@ static int ipa_route_reset(struct ipa *ipa, bool modem)
 
 	if (modem) {
 		first = 0;
-		count = IPA_ROUTE_MODEM_COUNT;
+		count = modem_route_count;
 	} else {
-		first = IPA_ROUTE_MODEM_COUNT;
-		count = ipa->route_count - IPA_ROUTE_MODEM_COUNT;
+		first = modem_route_count;
+		count = ipa->route_count - modem_route_count;
 	}
 
 	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V4_ROUTE);
@@ -511,9 +509,9 @@ static void ipa_filter_config(struct ipa *ipa, bool modem)
 	}
 }
 
-static bool ipa_route_id_modem(u32 route_id)
+static bool ipa_route_id_modem(struct ipa *ipa, u32 route_id)
 {
-	return route_id < IPA_ROUTE_MODEM_COUNT;
+	return route_id < ipa->modem_route_count;
 }
 
 /**
@@ -549,7 +547,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
 		return;
 
 	for (route_id = 0; route_id < ipa->route_count; route_id++)
-		if (ipa_route_id_modem(route_id) == modem)
+		if (ipa_route_id_modem(ipa, route_id) == modem)
 			ipa_route_tuple_zero(ipa, route_id);
 }
 
@@ -565,10 +563,9 @@ void ipa_table_config(struct ipa *ipa)
 /* Verify the sizes of all IPA table filter or routing table memory regions
  * are valid.  If valid, this records the size of the routing table.
  */
-bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
+bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
 {
 	bool hash_support = ipa_table_hash_support(ipa);
-	bool filter = !modem_route_count;
 	const struct ipa_mem *mem_hashed;
 	const struct ipa_mem *mem_ipv4;
 	const struct ipa_mem *mem_ipv6;
@@ -611,7 +608,7 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
 		/* Routing tables must be able to hold all modem entries,
 		 * plus at least one entry for the AP.
 		 */
-		if (count < modem_route_count + 1)
+		if (count < ipa->modem_route_count + 1)
 			return false;
 	}
 
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 31363292dc1db..79583b16f363f 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -13,9 +13,6 @@ struct ipa;
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
-/* The number of route table entries allotted to the modem */
-#define IPA_ROUTE_MODEM_COUNT	8
-
 /**
  * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
@@ -78,8 +75,8 @@ void ipa_table_exit(struct ipa *ipa);
 /**
  * ipa_table_mem_valid() - Validate sizes of table memory regions
  * @ipa:	IPA pointer
- * @modem_route_count:	Number of modem route table entries
+ * @filter:	Whether to check filter or routing tables
  */
-bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count);
+bool ipa_table_mem_valid(struct ipa *ipa, bool filter);
 
 #endif /* _IPA_TABLE_H_ */
-- 
2.34.1

