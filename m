Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46A65469BA
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbiFJPqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345013AbiFJPqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:46:22 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5B93D1C2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:20 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h18so21227587ilj.7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43meA/r92kh0CxM1YdpORf+ubVh2S9/XYnxfpi31kfI=;
        b=Y7aJA8Yu5+r6p/HHzNqOJL2V6fzXWk433pPrrfOP6oOLjCkTIMnXJ5AChT/9UT1HOB
         hkVgzRT3Fe8YfVrBEVygkxI7UDvNGymbaEtTR7/V3y5rczFrZQmiT4K4mJ5/RDW3m8uI
         Q5pQvJewBcYF88lskqYgToICp+wx+BbyEi0T7Tyrk+5SAi0HsmEQLm/qZh0b3EfB/mha
         MXaL5WhWWEYe/FQkeVQ+kCR2LJ0abETtBTyN6yrImyztuGRev2bYgRmYounZKVteEV8P
         EZDPjL2xpLyrIwY8o9FcwKy4giVzyyaeRQIkrG0gZyBgJN7OERBdpFGpOLOAmXDCBJGw
         SNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43meA/r92kh0CxM1YdpORf+ubVh2S9/XYnxfpi31kfI=;
        b=XuCrE1f6nO8gyWhubcr+DggWHXXOJsDhCdy4O4Nun/uAP8m1b3M5YuHWVwVOQxBP6Q
         vWRCSYMYmyZBLtFBgrvS0hAIHE+ZbYRHsLRlu9cxMf5n9LblmUVdERClfTWezF1emfYL
         GZHQ4myLNAjYE9lNx28foGrJhCVXqAP+YAoEisboPWSmkS2OdCUpbe6Xm5mK+TlLgzIl
         bIhOvj8DhjXYbjf8L41W6dvqV7MGoGDC7kqaMr6hMdp+OYRGwFkb/p91avVMoHfZVeVP
         mrXG0bv2YmyIz+ANPXcPskDJIdIevnGxsdtndY0gW+fofGeX9aDtfzeRgeJQjyrVW8+Y
         orpw==
X-Gm-Message-State: AOAM531dOd2ROoRKN6LvZ2CxPlyNUEIa2wZ3pn+l0xZQQuSTOkrZQXVd
        zaarilCmQ1Ts+0xgjnvdjn0rHg==
X-Google-Smtp-Source: ABdhPJyUiFBDSpYCVKl4wSv/JVH8/xbQ3jlNF7UStRDaNP9jdb4e5HDh7YD8c0psdHzLtRWGzelQyg==
X-Received: by 2002:a05:6e02:f44:b0:2d3:b54f:d83e with SMTP id y4-20020a056e020f4400b002d3b54fd83emr24924981ilj.9.1654875980181;
        Fri, 10 Jun 2022 08:46:20 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y15-20020a92950f000000b002d3adf71893sm12100488ilh.20.2022.06.10.08.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:46:19 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: verify command channel TLV count
Date:   Fri, 10 Jun 2022 10:46:10 -0500
Message-Id: <20220610154616.249304-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610154616.249304-1-elder@linaro.org>
References: <20220610154616.249304-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 8797972afff3d ("net: ipa: remove command info pool"), the
maximum number of IPA commands that would be sent in a single
transaction was defined.  That number can't exceed the size of the
TLV FIFO on the command channel, and we can check that at runtime.

To add this check, pass a new flag to gsi_channel_data_valid() to
indicate the channel being checked is being used for IPA commands.
Knowing that we can also verify the channel direction is correct.

Use a new local variable that refers to the command-specific portion
of the data being checked.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 9cfe84319ee4d..65ed5a697577e 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -2001,9 +2001,10 @@ static void gsi_channel_evt_ring_exit(struct gsi_channel *channel)
 	gsi_evt_ring_id_free(gsi, evt_ring_id);
 }
 
-static bool gsi_channel_data_valid(struct gsi *gsi,
+static bool gsi_channel_data_valid(struct gsi *gsi, bool command,
 				   const struct ipa_gsi_endpoint_data *data)
 {
+	const struct gsi_channel_data *channel_data;
 	u32 channel_id = data->channel_id;
 	struct device *dev = gsi->dev;
 
@@ -2019,10 +2020,24 @@ static bool gsi_channel_data_valid(struct gsi *gsi,
 		return false;
 	}
 
-	if (!data->channel.tlv_count ||
-	    data->channel.tlv_count > GSI_TLV_MAX) {
+	if (command && !data->toward_ipa) {
+		dev_err(dev, "command channel %u is not TX\n", channel_id);
+		return false;
+	}
+
+	channel_data = &data->channel;
+
+	if (!channel_data->tlv_count ||
+	    channel_data->tlv_count > GSI_TLV_MAX) {
 		dev_err(dev, "channel %u bad tlv_count %u; must be 1..%u\n",
-			channel_id, data->channel.tlv_count, GSI_TLV_MAX);
+			channel_id, channel_data->tlv_count, GSI_TLV_MAX);
+		return false;
+	}
+
+	if (command && IPA_COMMAND_TRANS_TRE_MAX > channel_data->tlv_count) {
+		dev_err(dev, "command TRE max too big for channel %u (%u > %u)\n",
+			channel_id, IPA_COMMAND_TRANS_TRE_MAX,
+			channel_data->tlv_count);
 		return false;
 	}
 
@@ -2031,22 +2046,22 @@ static bool gsi_channel_data_valid(struct gsi *gsi,
 	 * gsi_channel_tre_max() is computed, tre_count has to be almost
 	 * twice the TLV FIFO size to satisfy this requirement.
 	 */
-	if (data->channel.tre_count < 2 * data->channel.tlv_count - 1) {
+	if (channel_data->tre_count < 2 * channel_data->tlv_count - 1) {
 		dev_err(dev, "channel %u TLV count %u exceeds TRE count %u\n",
-			channel_id, data->channel.tlv_count,
-			data->channel.tre_count);
+			channel_id, channel_data->tlv_count,
+			channel_data->tre_count);
 		return false;
 	}
 
-	if (!is_power_of_2(data->channel.tre_count)) {
+	if (!is_power_of_2(channel_data->tre_count)) {
 		dev_err(dev, "channel %u bad tre_count %u; not power of 2\n",
-			channel_id, data->channel.tre_count);
+			channel_id, channel_data->tre_count);
 		return false;
 	}
 
-	if (!is_power_of_2(data->channel.event_count)) {
+	if (!is_power_of_2(channel_data->event_count)) {
 		dev_err(dev, "channel %u bad event_count %u; not power of 2\n",
-			channel_id, data->channel.event_count);
+			channel_id, channel_data->event_count);
 		return false;
 	}
 
@@ -2062,7 +2077,7 @@ static int gsi_channel_init_one(struct gsi *gsi,
 	u32 tre_count;
 	int ret;
 
-	if (!gsi_channel_data_valid(gsi, data))
+	if (!gsi_channel_data_valid(gsi, command, data))
 		return -EINVAL;
 
 	/* Worst case we need an event for every outstanding TRE */
-- 
2.34.1

