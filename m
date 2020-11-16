Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA572B5542
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgKPXig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731111AbgKPXi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:27 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9C3C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:26 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id m13so19269166ioq.9
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pnO4mb/H6z7x6A1tQz+RBcDm45qosVXWtXiwaipi3Cg=;
        b=cuflw8KKoLkgcy/jNloNMm5MD6fSNYX5+c5ihTc2AvbHT8ArwU+dvqvAlEyN9mwq7U
         H4cIHi/JHDnp6cFeVarBQR+AIOR4OTr+uvZUCb1x+AfwLdocWnh5V6Kbr+WBi1U9qQw7
         Z40etSlZBoL2hH0RmzAzCgAh+aprxzFLS77EuiKAS+w9lflLOjFmde+lc6cQ7LFSKez0
         F8UicYTiPMpTs2oASuJA8Dsez8HdFlv72oVQKZtzfyaNzCcvrgOi+mfHvia1LaEPISCV
         JZ5DBW4XkV1XJJwMtA+CW0XH+ffPqi1uLTqNI+ZhX85AP2tJ0t/av7eAlspm3N9zS0Kr
         sRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pnO4mb/H6z7x6A1tQz+RBcDm45qosVXWtXiwaipi3Cg=;
        b=j0niUFdMK473xXxaThQnduJa5nHsVhlt/Bic7BIEIYMuVPgnj5b4SkSAvmpv9dgv8E
         kfwRNiEYrQVoTh0XdMiyaz7h64o9jg05skBAUruSJD6LK5XC/8Hph0wJI51hD1Lv285v
         6x0mBRnZN+tWK10DFHZmtTKRQGqewKTEG7NvMS2TZGJehX9W6F3tiYYaVXSAJBR/kPej
         2CKy4AnfDC2O7XkPxCCfEgowRmWwFLb37kULcH3lIr9S+QktGybF0v8Lk2WPha5EkTft
         0sOxw6A7eYDSdMHuJhe6MRUQY9mVi6leqoVsGF8Ix7nRl3n2jmHDe127X3p0wT71N5PD
         knDA==
X-Gm-Message-State: AOAM530nFRIv+Ve/xmBme0jEndiRxN2cgzrPdpMtfTRCrErsyp97ZylX
        v9ORuU0wOuAiKjR2sHswVmocXzI5W4m03Q==
X-Google-Smtp-Source: ABdhPJzrh3+MU/Za1qfTHstf75BkVVeYFDe/DnVFR0MKKOGyN2nhEQVslTRaDFzomOCtflBlil2YnA==
X-Received: by 2002:a6b:5919:: with SMTP id n25mr9679453iob.204.1605569906268;
        Mon, 16 Nov 2020 15:38:26 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:25 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/11] net: ipa: move definition of enum ipa_irq_id
Date:   Mon, 16 Nov 2020 17:38:04 -0600
Message-Id: <20201116233805.13775-11-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the definition of the ipa_irq_id enumerated type out of
"ipa_interrupt.h" and into "ipa_reg.h", and flesh out its set of
defined values.  Each interrupt id indicates a particular type of
IPA interrupt that can be signaled.  Their numeric values define bit
positions in the IPA_IRQ_* registers, so should their definitions
should accompany the definition of those register offsets.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.h | 16 --------------
 drivers/net/ipa/ipa_reg.h       | 37 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index b59e03a9f8e7f..b5d63a0cd19e4 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -12,22 +12,6 @@
 struct ipa;
 struct ipa_interrupt;
 
-/**
- * enum ipa_irq_id - IPA interrupt type
- * @IPA_IRQ_UC_0:	Microcontroller event interrupt
- * @IPA_IRQ_UC_1:	Microcontroller response interrupt
- * @IPA_IRQ_TX_SUSPEND:	Data ready interrupt
- *
- * The data ready interrupt is signaled if data has arrived that is destined
- * for an AP RX endpoint whose underlying GSI channel is suspended/stopped.
- */
-enum ipa_irq_id {
-	IPA_IRQ_UC_0		= 0x2,
-	IPA_IRQ_UC_1		= 0x3,
-	IPA_IRQ_TX_SUSPEND	= 0xe,
-	IPA_IRQ_COUNT,		/* Number of interrupt types (not an index) */
-};
-
 /**
  * typedef ipa_irq_handler_t - IPA interrupt handler function type
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 94b54b2f660f6..a3c1300b680bb 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -523,6 +523,43 @@ enum ipa_seq_type {
 				IPA_REG_IRQ_CLR_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_CLR_EE_N_OFFSET(ee) \
 					(0x00003010 + 0x1000 * (ee))
+/**
+ * enum ipa_irq_id - Bit positions representing type of IPA IRQ
+ * @IPA_IRQ_UC_0:	Microcontroller event interrupt
+ * @IPA_IRQ_UC_1:	Microcontroller response interrupt
+ * @IPA_IRQ_TX_SUSPEND:	Data ready interrupt
+ *
+ * IRQ types not described above are not currently used.
+ */
+enum ipa_irq_id {
+	IPA_IRQ_BAD_SNOC_ACCESS			= 0x0,
+	/* Type (bit) 0x1 is not defined */
+	IPA_IRQ_UC_0				= 0x2,
+	IPA_IRQ_UC_1				= 0x3,
+	IPA_IRQ_UC_2				= 0x4,
+	IPA_IRQ_UC_3				= 0x5,
+	IPA_IRQ_UC_IN_Q_NOT_EMPTY		= 0x6,
+	IPA_IRQ_UC_RX_CMD_Q_NOT_FULL		= 0x7,
+	IPA_IRQ_PROC_UC_ACK_Q_NOT_EMPTY		= 0x8,
+	IPA_IRQ_RX_ERR				= 0x9,
+	IPA_IRQ_DEAGGR_ERR			= 0xa,
+	IPA_IRQ_TX_ERR				= 0xb,
+	IPA_IRQ_STEP_MODE			= 0xc,
+	IPA_IRQ_PROC_ERR			= 0xd,
+	IPA_IRQ_TX_SUSPEND			= 0xe,
+	IPA_IRQ_TX_HOLB_DROP			= 0xf,
+	IPA_IRQ_BAM_GSI_IDLE			= 0x10,
+	IPA_IRQ_PIPE_YELLOW_BELOW		= 0x11,
+	IPA_IRQ_PIPE_RED_BELOW			= 0x12,
+	IPA_IRQ_PIPE_YELLOW_ABOVE		= 0x13,
+	IPA_IRQ_PIPE_RED_ABOVE			= 0x14,
+	IPA_IRQ_UCP				= 0x15,
+	IPA_IRQ_DCMP				= 0x16,
+	IPA_IRQ_GSI_EE				= 0x17,
+	IPA_IRQ_GSI_IPA_IF_TLV_RCVD		= 0x18,
+	IPA_IRQ_GSI_UC				= 0x19,
+	IPA_IRQ_COUNT,				/* Last; not an id */
+};
 
 #define IPA_REG_IRQ_UC_OFFSET \
 				IPA_REG_IRQ_UC_EE_N_OFFSET(GSI_EE_AP)
-- 
2.20.1

