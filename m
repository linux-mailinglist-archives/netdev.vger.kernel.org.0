Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17E71C097C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgD3VfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727832AbgD3VfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:35:22 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F799C08E934
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:35:22 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s63so7435742qke.4
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qD/fVPgRRIyWs24d7bjWoi8ignYx3dFl8pvIjbbWrGU=;
        b=TUErJTMoV2Ef58XYi9bdjAC95qZO4uGsDuy9cDeCcFK0IeRCQ3XBsVBS3vT1mPKyYa
         WSG3QgGvw7KaL5Otq4jLPgL21AJtOyqW4K+lD4OSaE/JgP4aStbDKBEtSR6YIXRGCaUR
         R+R7eTPKYorVu5YwLeAnCVDykVjmcC3RWwSeOmGGqixwAwqwtxRowH1DxIcLPvf89puD
         ZnEsu25jLQa/BvMMZy0er6ViYWlhQRzLfgaREzV6AXLboEDrheW03mE1tZ7xt98INzfm
         tWREoSJIJX5ZdZtjc7h+jDru14emC5cumLiKSLGF1qtCVoSvUX9Gb/RIs8v2s8G4eldD
         2rLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qD/fVPgRRIyWs24d7bjWoi8ignYx3dFl8pvIjbbWrGU=;
        b=HmNaCvrAutp128RDdyqw2rolc4kwWXRDPHtmUWwsnDxdw1jXkJGmBDzmzqFmcY1UYb
         67GkFAIAIUAC6cLh3WGvsDaEEleXYIVBTtAwovsxzFaO8fj62Y5AJ9HCMC7IFUZbO2/H
         wkWDaeymPbf96XMpXmV9LeML5voyV+lA0GEb6w3aTIR5yok10KT+06Q1j1Pmkf3RiBnq
         TRE/cXkSl4U4COT/431CG2PWL7ByDFVkkcDTsGXYJxKch01sIc5PuknaoVsSpLOSMO63
         uM3BQGHz73gg9j2Ag5ltSWyaiB/l/legD1+y2ifXfhbaifw9cmV8wlQPtXUKYA+uabZK
         QeAw==
X-Gm-Message-State: AGi0PubKxcz2LicupyOGlvBMp6uoww06ur2/A7ElAHuxjEVKrq/7PEFa
        o1lbPzL1AUiy5vLdvXJCXD+w1Q==
X-Google-Smtp-Source: APiQypJi6p4doOBZCsZHqe8y+gXjnJQOo30NLPOjTKJ7zVOa3hlcWPk393DOxm2TvlEIiy3pxSBsRQ==
X-Received: by 2002:a37:a049:: with SMTP id j70mr547040qke.193.1588282521684;
        Thu, 30 Apr 2020 14:35:21 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s190sm1112543qkh.23.2020.04.30.14.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:35:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] net: ipa: zero return code before issuing generic EE command
Date:   Thu, 30 Apr 2020 16:35:12 -0500
Message-Id: <20200430213512.3434-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430213512.3434-1-elder@linaro.org>
References: <20200430213512.3434-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero the result code stored in a field of the scratch 0 register
before issuing a generic EE command.  This just guarantees that
the value we read later was actually written as a result of the
command.

Also add the definitions of two more possible result codes that can
be returned when issuing flow control enable or disable commands:
  INCORRECT_CHANNEL_STATE: - channel must be in started state
  INCORRECT_DIRECTION - flow control is only valid for TX channels

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 7 +++++++
 drivers/net/ipa/gsi_reg.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b4206fda0b22..b671bea0aa7c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1041,6 +1041,7 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 
 	complete(&gsi->completion);
 }
+
 /* Inter-EE interrupt handler */
 static void gsi_isr_glob_ee(struct gsi *gsi)
 {
@@ -1493,6 +1494,12 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	struct completion *completion = &gsi->completion;
 	u32 val;
 
+	/* First zero the result code field */
+	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
+	val &= ~GENERIC_EE_RESULT_FMASK;
+	iowrite32(val, gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
+
+	/* Now issue the command */
 	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 7613b9cc7cf6..acc9e744c67d 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -410,6 +410,8 @@
 #define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
 #define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
 #define GENERIC_EE_SUCCESS_FVAL			1
+#define GENERIC_EE_INCORRECT_DIRECTION_FVAL	3
+#define GENERIC_EE_INCORRECT_CHANNEL_FVAL	5
 #define GENERIC_EE_NO_RESOURCES_FVAL		7
 #define USB_MAX_PACKET_FMASK		GENMASK(15, 15)	/* 0: HS; 1: SS */
 #define MHI_BASE_CHANNEL_FMASK		GENMASK(31, 24)
-- 
2.20.1

