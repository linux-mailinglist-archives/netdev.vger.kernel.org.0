Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C32AE24B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 22:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgKJV7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731994AbgKJV7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:59:33 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC69C061A04
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:31 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id z2so15915ilh.11
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yUv6MmZd8PXf2CY+EM20QKTjHLCVzZRKOzmrgGW/s44=;
        b=hEsngPUJc+3WgpDu2cJxUdL9CHdnZRsUNjdHR43Ga/hlDDFdRTySAsU9xD/UzmOAb9
         NSVKC4QukHtNclleXUfbO7FjN+dpBcLbyzkTs5MvMepHyZ9Crjwa7WRwonxu7PdQyKyZ
         dB1wZNYgeRhg9Qv2x211/7ZOVYxfIC1g9sohik28gdTnwI8vrK6W6YyVlQHYClZ/MSnZ
         IaLWSGUdziuZXr9QmkIG2fKdNeTX+0GV3GeEgdB+1jtWbC7EU0VlRbJTPPICLO5op0lb
         5hET3pTr2DStL+RdFc+PVL5e78wvQLGLIGNKGkLphG3MnY66YNZemorYAMXBQFr+fr8q
         olHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yUv6MmZd8PXf2CY+EM20QKTjHLCVzZRKOzmrgGW/s44=;
        b=MGFfxnU/iyle7PdKm4E/EfRU1Atjib3mkTOS63iSbK1sZw8wqP6vWjyospuPIcw98A
         5k5o5MejwolYVkigkAFfgY3zWshFgiImKFVpP0rxYNvvDlQmwZOXChT9mEe/5oW7rwSA
         rb4vDgCGZFHNxPHwMrkfxUhWT3vDQCdpNxXDexaZmzgQtLQriky65Epp/29vVEA5YQ9w
         Xx/3EQTLzhfHl+1BZciHll/ROxLa9+SrfTqhYcVfmujGALfVpAh6UE6bKXM9WqySl5Mo
         ADjkhtVi+Eyz/MNDxohtVzCP4z6b3ZL6md1Dh/3/0rvCRrdmJNwLFE4SrEjKt350UuVo
         1S8A==
X-Gm-Message-State: AOAM531RtiJOrPGkk39CAO0Gh1CXHFC5Vbm8v5Divdr5UZKw0R6HxRo5
        s1IGflK1efR+ZpGVcmxXb5TOahaOaQ/FSDDu
X-Google-Smtp-Source: ABdhPJzlfZWLl0zTWTsREqzDZyBjWl6ss0tyK8Hx+5aPiOxna6Q0CIAW9PrmMUaKa5eNux58NKA3fQ==
X-Received: by 2002:a92:9ad5:: with SMTP id c82mr15590340ill.225.1605045571181;
        Tue, 10 Nov 2020 13:59:31 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d142sm102010iof.43.2020.11.10.13.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:59:30 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: move GSI error values into "gsi_reg.h"
Date:   Tue, 10 Nov 2020 15:59:20 -0600
Message-Id: <20201110215922.23514-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201110215922.23514-1-elder@linaro.org>
References: <20201110215922.23514-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gsi_err_code and gsi_err_type enumerated types are values that
fields in the GSI ERROR_LOG register can take on.  Move their
definitions out of "gsi.c" and into "gsi_reg.h", alongside the
definition of the ERROR_LOG register offset and field symbols.

Drop the "_ERR" suffix in the names of the gsi_err_code members.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 22 ++--------------------
 drivers/net/ipa/gsi_reg.h | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 78b793cf8aa4c..179991cff8807 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -109,24 +109,6 @@ struct gsi_event {
 	u8 chid;
 };
 
-/* Hardware values from the error log register error code field */
-enum gsi_err_code {
-	GSI_INVALID_TRE_ERR			= 0x1,
-	GSI_OUT_OF_BUFFERS_ERR			= 0x2,
-	GSI_OUT_OF_RESOURCES_ERR		= 0x3,
-	GSI_UNSUPPORTED_INTER_EE_OP_ERR		= 0x4,
-	GSI_EVT_RING_EMPTY_ERR			= 0x5,
-	GSI_NON_ALLOCATED_EVT_ACCESS_ERR	= 0x6,
-	GSI_HWO_1_ERR				= 0x8,
-};
-
-/* Hardware values from the error log register error type field */
-enum gsi_err_type {
-	GSI_ERR_TYPE_GLOB	= 0x1,
-	GSI_ERR_TYPE_CHAN	= 0x2,
-	GSI_ERR_TYPE_EVT	= 0x3,
-};
-
 /* Hardware values representing an event ring immediate command opcode */
 enum gsi_evt_cmd_opcode {
 	GSI_EVT_ALLOCATE	= 0x0,
@@ -1052,7 +1034,7 @@ static void gsi_isr_evt_ctrl(struct gsi *gsi)
 static void
 gsi_isr_glob_chan_err(struct gsi *gsi, u32 err_ee, u32 channel_id, u32 code)
 {
-	if (code == GSI_OUT_OF_RESOURCES_ERR) {
+	if (code == GSI_OUT_OF_RESOURCES) {
 		dev_err(gsi->dev, "channel %u out of resources\n", channel_id);
 		complete(&gsi->channel[channel_id].completion);
 		return;
@@ -1067,7 +1049,7 @@ gsi_isr_glob_chan_err(struct gsi *gsi, u32 err_ee, u32 channel_id, u32 code)
 static void
 gsi_isr_glob_evt_err(struct gsi *gsi, u32 err_ee, u32 evt_ring_id, u32 code)
 {
-	if (code == GSI_OUT_OF_RESOURCES_ERR) {
+	if (code == GSI_OUT_OF_RESOURCES) {
 		struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 		u32 channel_id = gsi_channel_id(evt_ring->channel);
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 9260ce99ec525..d46e3300dff70 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -384,6 +384,23 @@ enum gsi_general_id {
 #define ERR_VIRT_IDX_FMASK		GENMASK(23, 19)
 #define ERR_TYPE_FMASK			GENMASK(27, 24)
 #define ERR_EE_FMASK			GENMASK(31, 28)
+/** enum gsi_err_code - ERR_CODE field values in EE_ERR_LOG */
+enum gsi_err_code {
+	GSI_INVALID_TRE				= 0x1,
+	GSI_OUT_OF_BUFFERS			= 0x2,
+	GSI_OUT_OF_RESOURCES			= 0x3,
+	GSI_UNSUPPORTED_INTER_EE_OP		= 0x4,
+	GSI_EVT_RING_EMPTY			= 0x5,
+	GSI_NON_ALLOCATED_EVT_ACCESS		= 0x6,
+	/* 7 is not assigned */
+	GSI_HWO_1				= 0x8,
+};
+/** enum gsi_err_type - ERR_TYPE field values in EE_ERR_LOG */
+enum gsi_err_type {
+	GSI_ERR_TYPE_GLOB			= 0x1,
+	GSI_ERR_TYPE_CHAN			= 0x2,
+	GSI_ERR_TYPE_EVT			= 0x3,
+};
 
 #define GSI_ERROR_LOG_CLR_OFFSET \
 			GSI_EE_N_ERROR_LOG_CLR_OFFSET(GSI_EE_AP)
-- 
2.20.1

