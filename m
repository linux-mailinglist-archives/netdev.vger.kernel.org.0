Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E7D692689
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjBJThR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbjBJThN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:13 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D172311C
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:04 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id h29so820239ila.8
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7AwJgUL7NIJZbs/qrWraKG0HX5JQS6EjQP7eKCPxt8=;
        b=hR3HSvSVxIioEE6+wYDdT7x5AqBl6FODcKXwl4utskMQ6/SfsGvUfrMkyJ05u0pTal
         2a9OHDrzL6riN19qKhD51y5IEVHZna83K7hIAmcOmpxQ68riO8R6Qa3S6EegKWZmVSYC
         bqOC4B9XCeTPXm+1Frv/H2+1r8SutPKbqFUjptmDoe9v9ca/NqSy4AZDfmDKD56i3/IV
         o3oPkZzV8Gc95AKN9OoEZV3aKOFMbUxoPwbj0ZNzG7kRvxY5Ij4PrMYa0YyGgmtkf/yH
         ssWq4id3ouQPnuxOvdHzhSEBkjA5+G/265doYIW0+SOwEHSGk8UAiCKBPw5csz0TgRWN
         H0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7AwJgUL7NIJZbs/qrWraKG0HX5JQS6EjQP7eKCPxt8=;
        b=665kojeGyvA/csi8OqB0b9+EcnAxCto8aXxR3QW9MG7LXj7C0JQ2zYbniNOFaYSCL8
         eBpBi3+JFKo7uA8Xff7CAVAaVN5bejwUD+R1+bz4q1/5kC4TJgfEvzw6b8nZtF5BYyb9
         WRswn7oYWhk8hpZUIc5zaWx6grNRnv8cwGFeEe/jNLQCI6I+dbNcQl+gmVQ4dO/I6CrD
         7GmiPgTENjDUcasME8SiGiMvm33JMhf9r/jbS/pYBAsEopaqXYE3fuEWtHGtz1b1UO63
         ysfiFIzGpMVaQehGiOQHXGkMCxvTkj1IRt0JQmQb9K7/BfKQjTB/8qZm+XTnZW4Dxj3r
         tFYg==
X-Gm-Message-State: AO0yUKXRFA0K+a3OLrs1wQ2Aix9p6zPUGo2Qkp8m0DvaPVCRh83KQyqX
        auG84YF2HZoHgmqb1Sy8q0yr/A==
X-Google-Smtp-Source: AK7set8UIDYptxt4tMiL1bYGWx4ijQWeQ02ipd6PmZJe77nX5now0wfZWTBzNof0LEL/titHPSdp2g==
X-Received: by 2002:a05:6e02:1d9e:b0:314:110d:ab69 with SMTP id h30-20020a056e021d9e00b00314110dab69mr5483282ila.6.1676057823631;
        Fri, 10 Feb 2023 11:37:03 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:03 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/8] net: ipa: introduce GSI register IDs
Date:   Fri, 10 Feb 2023 13:36:49 -0600
Message-Id: <20230210193655.460225-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
References: <20230210193655.460225-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new gsi_reg_id enumerated type, which identifies each GSI
register with a symbolic identifier.

Create a function that indicates whether a register ID is valid.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.c | 65 +++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/gsi_reg.h | 57 ++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index 48f81fc24f39d..c20b3bcdd4151 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -22,6 +22,69 @@
  */
 #define GSI_EE_REG_ADJUST	0x0000d000			/* IPA v4.5+ */
 
+/* Is this register ID valid for the current GSI version? */
+static bool gsi_reg_id_valid(struct gsi *gsi, enum gsi_reg_id reg_id)
+{
+	switch (reg_id) {
+	case INTER_EE_SRC_CH_IRQ_MSK:
+	case INTER_EE_SRC_EV_CH_IRQ_MSK:
+	case CH_C_CNTXT_0:
+	case CH_C_CNTXT_1:
+	case CH_C_CNTXT_2:
+	case CH_C_CNTXT_3:
+	case CH_C_QOS:
+	case CH_C_SCRATCH_0:
+	case CH_C_SCRATCH_1:
+	case CH_C_SCRATCH_2:
+	case CH_C_SCRATCH_3:
+	case EV_CH_E_CNTXT_0:
+	case EV_CH_E_CNTXT_1:
+	case EV_CH_E_CNTXT_2:
+	case EV_CH_E_CNTXT_3:
+	case EV_CH_E_CNTXT_4:
+	case EV_CH_E_CNTXT_8:
+	case EV_CH_E_CNTXT_9:
+	case EV_CH_E_CNTXT_10:
+	case EV_CH_E_CNTXT_11:
+	case EV_CH_E_CNTXT_12:
+	case EV_CH_E_CNTXT_13:
+	case EV_CH_E_SCRATCH_0:
+	case EV_CH_E_SCRATCH_1:
+	case CH_C_DOORBELL_0:
+	case EV_CH_E_DOORBELL_0:
+	case GSI_STATUS:
+	case CH_CMD:
+	case EV_CH_CMD:
+	case GENERIC_CMD:
+	case HW_PARAM_2:
+	case CNTXT_TYPE_IRQ:
+	case CNTXT_TYPE_IRQ_MSK:
+	case CNTXT_SRC_CH_IRQ:
+	case CNTXT_SRC_CH_IRQ_MSK:
+	case CNTXT_SRC_CH_IRQ_CLR:
+	case CNTXT_SRC_EV_CH_IRQ:
+	case CNTXT_SRC_EV_CH_IRQ_MSK:
+	case CNTXT_SRC_EV_CH_IRQ_CLR:
+	case CNTXT_SRC_IEOB_IRQ:
+	case CNTXT_SRC_IEOB_IRQ_MSK:
+	case CNTXT_SRC_IEOB_IRQ_CLR:
+	case CNTXT_GLOB_IRQ_STTS:
+	case CNTXT_GLOB_IRQ_EN:
+	case CNTXT_GLOB_IRQ_CLR:
+	case CNTXT_GSI_IRQ_STTS:
+	case CNTXT_GSI_IRQ_EN:
+	case CNTXT_GSI_IRQ_CLR:
+	case CNTXT_INTSET:
+	case ERROR_LOG:
+	case ERROR_LOG_CLR:
+	case CNTXT_SCRATCH_0:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 /* Sets gsi->virt_raw and gsi->virt, and I/O maps the "gsi" memory range */
 int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 {
@@ -30,6 +93,8 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 	resource_size_t size;
 	u32 adjust;
 
+	(void)gsi_reg_id_valid;	/* Avoid a warning */
+
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
 	if (!res) {
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 60071b6a4d32e..1f613cd677b01 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -38,6 +38,63 @@
  * (though the actual limit is hardware-dependent).
  */
 
+/* enum gsi_reg_id - GSI register IDs */
+enum gsi_reg_id {
+	INTER_EE_SRC_CH_IRQ_MSK,			/* IPA v3.5+ */
+	INTER_EE_SRC_EV_CH_IRQ_MSK,			/* IPA v3.5+ */
+	CH_C_CNTXT_0,
+	CH_C_CNTXT_1,
+	CH_C_CNTXT_2,
+	CH_C_CNTXT_3,
+	CH_C_QOS,
+	CH_C_SCRATCH_0,
+	CH_C_SCRATCH_1,
+	CH_C_SCRATCH_2,
+	CH_C_SCRATCH_3,
+	EV_CH_E_CNTXT_0,
+	EV_CH_E_CNTXT_1,
+	EV_CH_E_CNTXT_2,
+	EV_CH_E_CNTXT_3,
+	EV_CH_E_CNTXT_4,
+	EV_CH_E_CNTXT_8,
+	EV_CH_E_CNTXT_9,
+	EV_CH_E_CNTXT_10,
+	EV_CH_E_CNTXT_11,
+	EV_CH_E_CNTXT_12,
+	EV_CH_E_CNTXT_13,
+	EV_CH_E_SCRATCH_0,
+	EV_CH_E_SCRATCH_1,
+	CH_C_DOORBELL_0,
+	EV_CH_E_DOORBELL_0,
+	GSI_STATUS,
+	CH_CMD,
+	EV_CH_CMD,
+	GENERIC_CMD,
+	HW_PARAM_2,					/* IPA v3.5.1+ */
+	CNTXT_TYPE_IRQ,
+	CNTXT_TYPE_IRQ_MSK,
+	CNTXT_SRC_CH_IRQ,
+	CNTXT_SRC_CH_IRQ_MSK,
+	CNTXT_SRC_CH_IRQ_CLR,
+	CNTXT_SRC_EV_CH_IRQ,
+	CNTXT_SRC_EV_CH_IRQ_MSK,
+	CNTXT_SRC_EV_CH_IRQ_CLR,
+	CNTXT_SRC_IEOB_IRQ,
+	CNTXT_SRC_IEOB_IRQ_MSK,
+	CNTXT_SRC_IEOB_IRQ_CLR,
+	CNTXT_GLOB_IRQ_STTS,
+	CNTXT_GLOB_IRQ_EN,
+	CNTXT_GLOB_IRQ_CLR,
+	CNTXT_GSI_IRQ_STTS,
+	CNTXT_GSI_IRQ_EN,
+	CNTXT_GSI_IRQ_CLR,
+	CNTXT_INTSET,
+	ERROR_LOG,
+	ERROR_LOG_CLR,
+	CNTXT_SCRATCH_0,
+	GSI_REG_ID_COUNT,				/* Last; not an ID */
+};
+
 /* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
 
 #define GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET \
-- 
2.34.1

