Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9B33BF9E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhCOPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhCOPVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:21:18 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F22CC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:21:18 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e7so9682247ile.7
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NHDh7IWLJWaZZsRGFN04TQU8QhIXh09TVomddsIt/Gc=;
        b=FfxK4VaHeulHqq6yZryVxuj8xTvFRaKGblZvb/9WohyPVggLhVDf4PBee1U30xUxHT
         2nCre5+gdb7zJSskvFcr5/oSj7vB/E5qamqQSABanotlHE9C0JJiIzJMHZ4ztFoNF52J
         9GjcFcYFZQMmZFrGGDfBhlZ48iwTWSCXNrnFFDKvNK588tRqpxWH/urxY6QmbCAqjOFp
         VPuwu2RlFFXvgAvQR2mYw1Cw6MBV7UhpzeV7E5Wfnw5BB/AmZjHx3NHrxXzdmx/6Z6hr
         hYiUIHJpNmTfylbzdnc1DTJNkTH6JVKnyQ6MVoU+Vt4D6RnvcgcE0QEtU813ksJtCEwJ
         Gowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NHDh7IWLJWaZZsRGFN04TQU8QhIXh09TVomddsIt/Gc=;
        b=FYRvwMQh3lJiDF/RIVsv5JvIuPA4xM2TOhwisPIy/lubv+If2cf3bGNZ4INiiN/dE2
         75UqNE4Zhu67gzmJboCVuGr4IwBn+HONBAyVl4BXj2hxuYGgnbQwk2X2CD+aiqFovRXw
         y+uc9O20yAhnRZuW6oJGx6sAmGRGv9QzuaYxEHonztAjFnaee6i5A7iYwEPlF07iNg3t
         cIqI7IuKbe2DC+99GL/wY3S/ixUCXrmOdmEcV6R306DzQzWsdfN7wRBoMs6CUX8+BzaB
         HC+YWmnwKtEBMnv7nNo9YEvFzgXOWo6BjvkLL08TIZctRu+fjpxG7UJoM8pNgAJ9VcaW
         gDNg==
X-Gm-Message-State: AOAM530mzBmaT/O9aNejzYf0XxhlVhWVlfIuaGQNuzxtK09fFv+wWPHU
        7XICaXjP/Tzb70YZ3c/OO9ru/g==
X-Google-Smtp-Source: ABdhPJwHyGl5fnWu/KuXJjIwb1bgEO0GyUoW2+rfQ+IoQR4+EaZo0xLPrtx77Zo2uRTXEC5Kqk3Hww==
X-Received: by 2002:a92:90f:: with SMTP id y15mr69688ilg.143.1615821678138;
        Mon, 15 Mar 2021 08:21:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l17sm8194275ilt.27.2021.03.15.08.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:21:17 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     manivannan.sadhasivam@linaro.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ipa: extend the INDICATION_REGISTER request
Date:   Mon, 15 Mar 2021 10:21:12 -0500
Message-Id: <20210315152112.1907968-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315152112.1907968-1-elder@linaro.org>
References: <20210315152112.1907968-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The specified format of the INDICATION_REGISTER QMI request message
has been extended to support two more optional fields:
  endpoint_desc_ind:
    sender wishes to receive endpoint descriptor information via
    an IPA ENDP_DESC indication QMI message
  bw_change_ind:
    sender wishes to receive bandwidth change information via
    an IPA BW_CHANGE indication QMI message

Add definitions that permit these fields to be formatted and parsed
by the QMI library code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_qmi_msg.c | 40 +++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_qmi_msg.h |  6 +++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index e4a6efbe9bd00..6838e8065072b 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -70,6 +70,46 @@ struct qmi_elem_info ipa_indication_register_req_ei[] = {
 		.offset		= offsetof(struct ipa_indication_register_req,
 					   ipa_mhi_ready_ind),
 	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     endpoint_desc_ind_valid),
+		.tlv_type	= 0x13,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   endpoint_desc_ind_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     endpoint_desc_ind),
+		.tlv_type	= 0x13,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   endpoint_desc_ind),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     bw_change_ind_valid),
+		.tlv_type	= 0x14,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   bw_change_ind_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     bw_change_ind),
+		.tlv_type	= 0x14,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   bw_change_ind),
+	},
 	{
 		.data_type	= QMI_EOTI,
 	},
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 12b6621f4b0e6..3233d145fd87c 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -24,7 +24,7 @@
  * information for each field.  The qmi_send_*() interfaces require
  * the message size to be provided.
  */
-#define IPA_QMI_INDICATION_REGISTER_REQ_SZ	12	/* -> server handle */
+#define IPA_QMI_INDICATION_REGISTER_REQ_SZ	20	/* -> server handle */
 #define IPA_QMI_INDICATION_REGISTER_RSP_SZ	7	/* <- server handle */
 #define IPA_QMI_INIT_DRIVER_REQ_SZ		162	/* client handle -> */
 #define IPA_QMI_INIT_DRIVER_RSP_SZ		25	/* client handle <- */
@@ -44,6 +44,10 @@ struct ipa_indication_register_req {
 	u8 data_usage_quota_reached;
 	u8 ipa_mhi_ready_ind_valid;
 	u8 ipa_mhi_ready_ind;
+	u8 endpoint_desc_ind_valid;
+	u8 endpoint_desc_ind;
+	u8 bw_change_ind_valid;
+	u8 bw_change_ind;
 };
 
 /* The response to a IPA_QMI_INDICATION_REGISTER request consists only of
-- 
2.27.0

