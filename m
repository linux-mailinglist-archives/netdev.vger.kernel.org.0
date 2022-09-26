Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62625EB42F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiIZWJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiIZWJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:09:48 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F4B60F2
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:44 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z191so6383409iof.10
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=eJFEaVPIZMCEIz3w2nXZe43VBHpxxUwng4PSWmEniu4=;
        b=WswXKx8RkxqtBbrlR6Q/iLKnZDjGRu4XbBg5F3DRSFA6S5WpuNv5WGS8L709mpqotu
         OZlvWdptZPyZ0/rFZpYBGhZ24X1fmLYW2uY2s4pZtaYtPSNOOHrTIfdJDymvzCkLZnVY
         QeOhI1O73P1tuxi/EGEPvTzFNUpLo2mWLhM9X3M/EJYIGpjEdn7BFuNoZMtaAY23B92w
         +Ak9/yFc3Bq8K3Wk8NulV5RLXYpsCz+pm2vbxN69xN4AcZBq0TpUhL76lM+ZE9VNIx/Y
         dDxv/p/yzcpmlku79rf1Q8DgP6kDvoARdsfKwtyw6JvuaMNe3Va/j1tReuykw1TwGGBY
         fGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=eJFEaVPIZMCEIz3w2nXZe43VBHpxxUwng4PSWmEniu4=;
        b=0L8e4Rxns74/llQ2LogAqfvZa/MjAh7Qq5/VKYob9UsH322CHkzKZWHdInaEbUrf8L
         YgSlObmNYicbsPFF0NhmQSCArGmylcfDZiPUPbOFPZ8w139tPJlR0Lo8G3zwx2AjnISv
         NeevyLLdKNSkHgTT8CsOUt+gMIAQ2op5mg+8p3kUt01Itg4sWGjAl0fRu7FdSM+wY3Pp
         PL8CKbjWvJIYpjwzXFPzDZ23QZAzB0HUW5OAeZj+mxoVOPvNMNIeLwIXnKCb15ySpLTl
         AHk1gh5qiCpuOssoop0ZlnSjj3Bk7pGQg94mnYHC5yhOl/jjwtGBVIZkEVAF+osz/ijy
         j2WQ==
X-Gm-Message-State: ACrzQf12pJDrv6GEiXGyWeA5t3wQrHB0EnVsBakfGpEv0DrWbqBIQXZG
        3QmSVoI0xqrziiWXBXNaJO9AXA==
X-Google-Smtp-Source: AMsMyM6sDbO6AzaWgtpDH9BeumiwF71JyezyZl4nSAn6hWI3dPU4xRpZ5aj5KgJHM/ROD+O9fwQ1IQ==
X-Received: by 2002:a05:6638:2648:b0:35a:74cf:7b0c with SMTP id n8-20020a056638264800b0035a74cf7b0cmr12649423jat.205.1664230184066;
        Mon, 26 Sep 2022 15:09:44 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/15] net: ipa: introduce IPA register IDs
Date:   Mon, 26 Sep 2022 17:09:17 -0500
Message-Id: <20220926220931.3261749-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new ipa_reg_id enumerated type, which identifies each IPA
register with a symbolic identifier.  Use short names, but in some
cases (such as "BCR") add "IPA_" to the name to help avoid name
conflicts.

Create two functions that indicate register validity.  The first
concisely indicates whether a register is valid for a given version
of IPA, and if so, whether it is defined.  The second indicates
whether a register is valid for TX or RX endpoints.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.c | 58 +++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_reg.h | 55 +++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index e6147a1cd787b..5d432f9c13f0a 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -9,11 +9,69 @@
 #include "ipa.h"
 #include "ipa_reg.h"
 
+/* Is this register valid for the current IPA version? */
+static bool ipa_reg_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
+{
+	enum ipa_version version = ipa->version;
+	bool valid;
+
+	/* Check for bogus (out of range) register IDs */
+	if ((u32)reg_id >= IPA_REG_ID_COUNT)
+		return false;
+
+	switch (reg_id) {
+	case IPA_BCR:
+	case COUNTER_CFG:
+		valid = version < IPA_VERSION_4_5;
+		break;
+
+	case IPA_TX_CFG:
+	case FLAVOR_0:
+	case IDLE_INDICATION_CFG:
+		valid = version >= IPA_VERSION_3_5;
+		break;
+
+	case QTIME_TIMESTAMP_CFG:
+	case TIMERS_XO_CLK_DIV_CFG:
+	case TIMERS_PULSE_GRAN_CFG:
+		valid = version >= IPA_VERSION_4_5;
+		break;
+
+	case SRC_RSRC_GRP_45_RSRC_TYPE:
+	case DST_RSRC_GRP_45_RSRC_TYPE:
+		valid = version <= IPA_VERSION_3_1 ||
+			version == IPA_VERSION_4_5;
+		break;
+
+	case SRC_RSRC_GRP_67_RSRC_TYPE:
+	case DST_RSRC_GRP_67_RSRC_TYPE:
+		valid = version <= IPA_VERSION_3_1;
+		break;
+
+	case ENDP_FILTER_ROUTER_HSH_CFG:
+		valid = version != IPA_VERSION_4_2;
+		break;
+
+	case IRQ_SUSPEND_EN:
+	case IRQ_SUSPEND_CLR:
+		valid = version >= IPA_VERSION_3_1;
+		break;
+
+	default:
+		valid = true;	/* Others should be defined for all versions */
+		break;
+	}
+
+	return valid;
+}
+
 int ipa_reg_init(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	struct resource *res;
 
+	(void)ipa_reg_valid;	/* Avoid a warning */
+
 	/* Setup IPA register memory  */
 	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
 					   "ipa-reg");
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index f593cf3187950..e897550448c06 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -65,6 +65,61 @@ struct ipa;
  * of valid bits for the register.
  */
 
+/* enum ipa_reg_id - IPA register IDs */
+enum ipa_reg_id {
+	COMP_CFG,
+	CLKON_CFG,
+	ROUTE,
+	SHARED_MEM_SIZE,
+	QSB_MAX_WRITES,
+	QSB_MAX_READS,
+	FILT_ROUT_HASH_EN,
+	FILT_ROUT_HASH_FLUSH,
+	STATE_AGGR_ACTIVE,
+	IPA_BCR,					/* Not IPA v4.5+ */
+	LOCAL_PKT_PROC_CNTXT,
+	AGGR_FORCE_CLOSE,
+	COUNTER_CFG,					/* Not IPA v4.5+ */
+	IPA_TX_CFG,					/* IPA v3.5+ */
+	FLAVOR_0,					/* IPA v3.5+ */
+	IDLE_INDICATION_CFG,				/* IPA v3.5+ */
+	QTIME_TIMESTAMP_CFG,				/* IPA v4.5+ */
+	TIMERS_XO_CLK_DIV_CFG,				/* IPA v4.5+ */
+	TIMERS_PULSE_GRAN_CFG,				/* IPA v4.5+ */
+	SRC_RSRC_GRP_01_RSRC_TYPE,
+	SRC_RSRC_GRP_23_RSRC_TYPE,
+	SRC_RSRC_GRP_45_RSRC_TYPE,		/* Not IPA v3.5+, IPA v4.5 */
+	SRC_RSRC_GRP_67_RSRC_TYPE,			/* Not IPA v3.5+ */
+	DST_RSRC_GRP_01_RSRC_TYPE,
+	DST_RSRC_GRP_23_RSRC_TYPE,
+	DST_RSRC_GRP_45_RSRC_TYPE,		/* Not IPA v3.5+, IPA v4.5 */
+	DST_RSRC_GRP_67_RSRC_TYPE,			/* Not IPA v3.5+ */
+	ENDP_INIT_CTRL,		/* Not IPA v4.2+ for TX, not IPA v4.0+ for RX */
+	ENDP_INIT_CFG,
+	ENDP_INIT_NAT,			/* TX only */
+	ENDP_INIT_HDR,
+	ENDP_INIT_HDR_EXT,
+	ENDP_INIT_HDR_METADATA_MASK,	/* RX only */
+	ENDP_INIT_MODE,			/* TX only */
+	ENDP_INIT_AGGR,
+	ENDP_INIT_HOL_BLOCK_EN,		/* RX only */
+	ENDP_INIT_HOL_BLOCK_TIMER,	/* RX only */
+	ENDP_INIT_DEAGGR,		/* TX only */
+	ENDP_INIT_RSRC_GRP,
+	ENDP_INIT_SEQ,			/* TX only */
+	ENDP_STATUS,
+	ENDP_FILTER_ROUTER_HSH_CFG,			/* Not IPA v4.2 */
+	/* The IRQ registers are only used for GSI_EE_AP */
+	IPA_IRQ_STTS,
+	IPA_IRQ_EN,
+	IPA_IRQ_CLR,
+	IPA_IRQ_UC,
+	IRQ_SUSPEND_INFO,
+	IRQ_SUSPEND_EN,					/* IPA v3.1+ */
+	IRQ_SUSPEND_CLR,				/* IPA v3.1+ */
+	IPA_REG_ID_COUNT,				/* Last; not an ID */
+};
+
 #define IPA_REG_COMP_CFG_OFFSET				0x0000003c
 /* The next field is not supported for IPA v4.0+, not present for IPA v4.5+ */
 #define ENABLE_FMASK				GENMASK(0, 0)
-- 
2.34.1

