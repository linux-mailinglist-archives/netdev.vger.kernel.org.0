Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96E42AE257
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbgKJV7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731996AbgKJV7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:59:33 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE59C061A47
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:32 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id t13so57902ilp.2
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5o/tlc4pwKGQFxYzh+9nrDgnEDmuz8gJr7Pwn8ETUkA=;
        b=nu0B77KFOijS+B1VhLKmevgFlnWzPtUQgyRnJbPl5ZTaKufHM+7pxn1xyJxuUF3yNj
         cSLb8SyLiiEREAokAhWU9uv+EoGdYYZIJFBnPRmjfbjDVXJvJI/DTvN835NpnJdbZ/a4
         XD7zJF3NMegCV9OUJWcg3iQbgfDrzNvpDdnzGGjqoCEKr+HN3Lvv7Z9VqZ2cAb6UkEiA
         ujwfR5evd368SVDspt0z5PvpuBG2N5u5jRiamlryvld/WTVmAZmNZgiYoa+zWwWy7/3d
         qGCBY5xE2xem3IuACaPclJ9QSAPKuAsYN5TQUYN7sEFHN8E+gaFMdMqQd5bDDc4hwLu7
         IIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5o/tlc4pwKGQFxYzh+9nrDgnEDmuz8gJr7Pwn8ETUkA=;
        b=AxBN95ljwZprQQIbT769UxLQDomLQBPLRhHUto7/Ni9vqqRRo4LKppt49dc1sSGr7J
         +gmShdBnDZXPaaeeFBxwKaXMBf70OrDT7OWEhdcjKp/66j2tzlPqmQZ8VTBI5c02RV6r
         JuAeP2Onw12GQwT2kSlvTNJO+CkVyWBX3rVg5iFRU7tvNlEN2apmReGDDWxYAkjLpN86
         JH5w2+c/NDE+4LfCtisrRhKuHjHCs1YQ3yIT8Jg6yoeV22UlU78TxKZoWll8rPU45Nqq
         NWk9T2h5v9+SKjHiZOEWawkXvsT5pLxcSupicsXAQkbsfOftTAGNWVEzG6YCqSwxSvWa
         qFlw==
X-Gm-Message-State: AOAM530BtVddXYPr2ZodeXeIUPIRXQEonl4BMNZiJOP/KUiZPI7mp0bI
        ueEPl3fFu5lyr4+qIaF4JSKrmA==
X-Google-Smtp-Source: ABdhPJya85d03qDZaUvUGMQ22bqM1km6LAINsoHUIEuge5rAI6XETjD/nB08RQCjwVOBSAzrVhZPZA==
X-Received: by 2002:a05:6e02:488:: with SMTP id b8mr673394ils.207.1605045572323;
        Tue, 10 Nov 2020 13:59:32 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d142sm102010iof.43.2020.11.10.13.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:59:31 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: move GSI command opcode values into "gsi_reg.h"
Date:   Tue, 10 Nov 2020 15:59:21 -0600
Message-Id: <20201110215922.23514-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201110215922.23514-1-elder@linaro.org>
References: <20201110215922.23514-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gsi_ch_cmd_opcode, gsi_evt_cmd_opcode, and gsi_generic_cmd_opcode
enumerated types are values that fields in the GSI command registers
can take on.  Move their definitions out of "gsi.c" and into "gsi_reg.h",
alongside the definition of registers they are associated with.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 22 ----------------------
 drivers/net/ipa/gsi_reg.h | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 179991cff8807..c6803231bf5db 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -109,28 +109,6 @@ struct gsi_event {
 	u8 chid;
 };
 
-/* Hardware values representing an event ring immediate command opcode */
-enum gsi_evt_cmd_opcode {
-	GSI_EVT_ALLOCATE	= 0x0,
-	GSI_EVT_RESET		= 0x9,
-	GSI_EVT_DE_ALLOC	= 0xa,
-};
-
-/* Hardware values representing a generic immediate command opcode */
-enum gsi_generic_cmd_opcode {
-	GSI_GENERIC_HALT_CHANNEL	= 0x1,
-	GSI_GENERIC_ALLOCATE_CHANNEL	= 0x2,
-};
-
-/* Hardware values representing a channel immediate command opcode */
-enum gsi_ch_cmd_opcode {
-	GSI_CH_ALLOCATE	= 0x0,
-	GSI_CH_START	= 0x1,
-	GSI_CH_STOP	= 0x2,
-	GSI_CH_RESET	= 0x9,
-	GSI_CH_DE_ALLOC	= 0xa,
-};
-
 /** gsi_channel_scratch_gpi - GPI protocol scratch register
  * @max_outstanding_tre:
  *	Defines the maximum number of TREs allowed in a single transaction
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index d46e3300dff70..de3d87d278a98 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -223,6 +223,14 @@ enum gsi_channel_type {
 			(0x0001f008 + 0x4000 * (ee))
 #define CH_CHID_FMASK			GENMASK(7, 0)
 #define CH_OPCODE_FMASK			GENMASK(31, 24)
+/** enum gsi_ch_cmd_opcode - CH_OPCODE field values in CH_CMD */
+enum gsi_ch_cmd_opcode {
+	GSI_CH_ALLOCATE				= 0x0,
+	GSI_CH_START				= 0x1,
+	GSI_CH_STOP				= 0x2,
+	GSI_CH_RESET				= 0x9,
+	GSI_CH_DE_ALLOC				= 0xa,
+};
 
 #define GSI_EV_CH_CMD_OFFSET \
 			GSI_EE_N_EV_CH_CMD_OFFSET(GSI_EE_AP)
@@ -230,6 +238,12 @@ enum gsi_channel_type {
 			(0x0001f010 + 0x4000 * (ee))
 #define EV_CHID_FMASK			GENMASK(7, 0)
 #define EV_OPCODE_FMASK			GENMASK(31, 24)
+/** enum gsi_evt_cmd_opcode - EV_OPCODE field values in EV_CH_CMD */
+enum gsi_evt_cmd_opcode {
+	GSI_EVT_ALLOCATE			= 0x0,
+	GSI_EVT_RESET				= 0x9,
+	GSI_EVT_DE_ALLOC			= 0xa,
+};
 
 #define GSI_GENERIC_CMD_OFFSET \
 			GSI_EE_N_GENERIC_CMD_OFFSET(GSI_EE_AP)
@@ -238,6 +252,11 @@ enum gsi_channel_type {
 #define GENERIC_OPCODE_FMASK		GENMASK(4, 0)
 #define GENERIC_CHID_FMASK		GENMASK(9, 5)
 #define GENERIC_EE_FMASK		GENMASK(13, 10)
+/** enum gsi_generic_cmd_opcode - GENERIC_OPCODE field values in GENERIC_CMD */
+enum gsi_generic_cmd_opcode {
+	GSI_GENERIC_HALT_CHANNEL		= 0x1,
+	GSI_GENERIC_ALLOCATE_CHANNEL		= 0x2,
+};
 
 #define GSI_GSI_HW_PARAM_2_OFFSET \
 			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
-- 
2.20.1

