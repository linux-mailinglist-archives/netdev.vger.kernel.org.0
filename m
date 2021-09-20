Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18109410EBC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhITDMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhITDM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:12:26 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC7FC061767;
        Sun, 19 Sep 2021 20:10:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n2so7493192plk.12;
        Sun, 19 Sep 2021 20:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qgPrSEvlEz44qzOdjetk3jLjnDR/NPMtis3khQbjPjY=;
        b=QSU0Fojag+ORRG3vZsdqaZc8z0f7kn3YDKVmf7GVJBICbBnJGPhlHYcpE9jfsdmS57
         zVtoE8oG1ptqZijvzKAEVuPDgSvdmJLP6w6tCOAqpSKjnKkdnC9Fq7z6gREktKEt/6fZ
         FhtcqtSXJLRHYzBvlNmqWIJca7tiuhy5cjESB6GCOaHlLMEX8fYPPqUwPQAruzXc94G2
         czf0LFb43WEb3M2JnVj7ZN0BE5u9pBQ1ghf7fjbB60AN1vN5TFveKw3Eyd7DcSKCs1Fh
         qc0RDBspqK99gopzlZh+X4sY0UK4RW4PIFyejgf/8/8Vcr+mjVitqUpE5cystKvgl60A
         gYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qgPrSEvlEz44qzOdjetk3jLjnDR/NPMtis3khQbjPjY=;
        b=eP87GlgRjDWkME46UmuXfxV2+EXfHHwujM2KbNFWRfRNAoi0nax7EqQgXCMnx9s8ss
         3XfzgXFjK0zAvELPZkNLsd4+6vH6yavoN/QI0jS5+8kbpxNd2T4Po0+SVhrpxtfO32BC
         uKzMIUsvKGARTOhCWXTLzYEBZ1skerFc+OL9hbRZTvjgOZccq97IeaP9OX6QnAvCT5a4
         1O6QHF9L36Ay0ibepdZCAY/G/Pf4vnDm505uY5QixXuHh82BWeIuaJ04ZfOlq3J7Q6n9
         WJJ5fXYMnOynRIh9dt3cSv/F1VHzKOtAfXbWJqeYe4QqPxJBF/IRoYr4XE+rgB3pv9sc
         4fyw==
X-Gm-Message-State: AOAM533V3RYUAPNJ6jX3jaUQm5gNdYyjnP6u3c4+WQfaxbbKdA/ENwMy
        SrOpN9lnjWuBpfepbLBgzmi7M9+hS2vpISx/
X-Google-Smtp-Source: ABdhPJyqdxzplBi2n4+8amlnCBrq54Kkw0F2rSaSeZG6j6s5T7ppSkVMGWJmHBfZ359tvo1RekSshQ==
X-Received: by 2002:a17:902:868c:b0:13c:8ce5:92b3 with SMTP id g12-20020a170902868c00b0013c8ce592b3mr21016732plo.13.1632107403494;
        Sun, 19 Sep 2021 20:10:03 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:10:03 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 14/17] net: ipa: Add support for IPA v2 microcontroller
Date:   Mon, 20 Sep 2021 08:38:08 +0530
Message-Id: <20210920030811.57273-15-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some minor differences between IPA v2.x and later revisions
with regards to the uc. The biggeset difference is the shared memory's
layout. There are also some changes to the command numbers, but these
are not too important, since the mainline driver doesn't use them.

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_uc.c | 96 ++++++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 856e55a080a7..bf6b25098301 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -39,11 +39,12 @@
 #define IPA_SEND_DELAY		100	/* microseconds */
 
 /**
- * struct ipa_uc_mem_area - AP/microcontroller shared memory area
+ * union ipa_uc_mem_area - AP/microcontroller shared memory area
  * @command:		command code (AP->microcontroller)
  * @reserved0:		reserved bytes; avoid reading or writing
  * @command_param:	low 32 bits of command parameter (AP->microcontroller)
  * @command_param_hi:	high 32 bits of command parameter (AP->microcontroller)
+ *			Available since IPA v3.0
  *
  * @response:		response code (microcontroller->AP)
  * @reserved1:		reserved bytes; avoid reading or writing
@@ -59,31 +60,58 @@
  * @reserved3:		reserved bytes; avoid reading or writing
  * @interface_version:	hardware-reported interface version
  * @reserved4:		reserved bytes; avoid reading or writing
+ * @reserved5:		reserved bytes; avoid reading or writing
  *
  * A shared memory area at the base of IPA resident memory is used for
  * communication with the microcontroller.  The region is 128 bytes in
  * size, but only the first 40 bytes (structured this way) are used.
  */
-struct ipa_uc_mem_area {
-	u8 command;		/* enum ipa_uc_command */
-	u8 reserved0[3];
-	__le32 command_param;
-	__le32 command_param_hi;
-	u8 response;		/* enum ipa_uc_response */
-	u8 reserved1[3];
-	__le32 response_param;
-	u8 event;		/* enum ipa_uc_event */
-	u8 reserved2[3];
-
-	__le32 event_param;
-	__le32 first_error_address;
-	u8 hw_state;
-	u8 warning_counter;
-	__le16 reserved3;
-	__le16 interface_version;
-	__le16 reserved4;
+union ipa_uc_mem_area {
+	struct {
+		u8 command;		/* enum ipa_uc_command */
+		u8 reserved0[3];
+		__le32 command_param;
+		u8 response;		/* enum ipa_uc_response */
+		u8 reserved1[3];
+		__le32 response_param;
+		u8 event;		/* enum ipa_uc_event */
+		u8 reserved2[3];
+
+		__le32 event_param;
+		__le32 reserved3;
+		__le32 first_error_address;
+		u8 hw_state;
+		u8 warning_counter;
+		__le16 reserved4;
+		__le16 interface_version;
+		__le16 reserved5;
+	} v2;
+	struct {
+		u8 command;		/* enum ipa_uc_command */
+		u8 reserved0[3];
+		__le32 command_param;
+		__le32 command_param_hi;
+		u8 response;		/* enum ipa_uc_response */
+		u8 reserved1[3];
+		__le32 response_param;
+		u8 event;		/* enum ipa_uc_event */
+		u8 reserved2[3];
+
+		__le32 event_param;
+		__le32 first_error_address;
+		u8 hw_state;
+		u8 warning_counter;
+		__le16 reserved3;
+		__le16 interface_version;
+		__le16 reserved4;
+	} v3;
 };
 
+#define UC_FIELD(_ipa, _field)			\
+	*((_ipa->version >= IPA_VERSION_3_0) ?	\
+	  &(ipa_uc_shared(_ipa)->v3._field) :	\
+	  &(ipa_uc_shared(_ipa)->v2._field))
+
 /** enum ipa_uc_command - commands from the AP to the microcontroller */
 enum ipa_uc_command {
 	IPA_UC_COMMAND_NO_OP		= 0x0,
@@ -95,6 +123,7 @@ enum ipa_uc_command {
 	IPA_UC_COMMAND_CLK_UNGATE	= 0x6,
 	IPA_UC_COMMAND_MEMCPY		= 0x7,
 	IPA_UC_COMMAND_RESET_PIPE	= 0x8,
+	/* Next two commands are present for IPA v3.0+ */
 	IPA_UC_COMMAND_REG_WRITE	= 0x9,
 	IPA_UC_COMMAND_GSI_CH_EMPTY	= 0xa,
 };
@@ -114,7 +143,7 @@ enum ipa_uc_event {
 	IPA_UC_EVENT_LOG_INFO		= 0x2,
 };
 
-static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
+static union ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
 {
 	const struct ipa_mem *mem = ipa_mem_find(ipa, IPA_MEM_UC_SHARED);
 	u32 offset = ipa->mem_offset + mem->offset;
@@ -125,22 +154,22 @@ static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
 /* Microcontroller event IPA interrupt handler */
 static void ipa_uc_event_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
-	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
 	struct device *dev = &ipa->pdev->dev;
+	u32 event = UC_FIELD(ipa, event);
 
-	if (shared->event == IPA_UC_EVENT_ERROR)
+	if (event == IPA_UC_EVENT_ERROR)
 		dev_err(dev, "microcontroller error event\n");
-	else if (shared->event != IPA_UC_EVENT_LOG_INFO)
+	else if (event != IPA_UC_EVENT_LOG_INFO)
 		dev_err(dev, "unsupported microcontroller event %u\n",
-			shared->event);
+			event);
 	/* The LOG_INFO event can be safely ignored */
 }
 
 /* Microcontroller response IPA interrupt handler */
 static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
-	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
 	struct device *dev = &ipa->pdev->dev;
+	u32 response = UC_FIELD(ipa, response);
 
 	/* An INIT_COMPLETED response message is sent to the AP by the
 	 * microcontroller when it is operational.  Other than this, the AP
@@ -150,20 +179,21 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * We can drop the power reference taken in ipa_uc_power() once we
 	 * know the microcontroller has finished its initialization.
 	 */
-	switch (shared->response) {
+	switch (response) {
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
 		if (ipa->uc_powered) {
 			ipa->uc_loaded = true;
 			pm_runtime_mark_last_busy(dev);
 			(void)pm_runtime_put_autosuspend(dev);
 			ipa->uc_powered = false;
+			ipa_qmi_signal_uc_loaded(ipa);
 		} else {
 			dev_warn(dev, "unexpected init_completed response\n");
 		}
 		break;
 	default:
 		dev_warn(dev, "unsupported microcontroller response %u\n",
-			 shared->response);
+			 response);
 		break;
 	}
 }
@@ -216,16 +246,16 @@ void ipa_uc_power(struct ipa *ipa)
 /* Send a command to the microcontroller */
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
-	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
 	u32 offset;
 	u32 val;
 
 	/* Fill in the command data */
-	shared->command = command;
-	shared->command_param = cpu_to_le32(command_param);
-	shared->command_param_hi = 0;
-	shared->response = 0;
-	shared->response_param = 0;
+	UC_FIELD(ipa, command) = command;
+	UC_FIELD(ipa, command_param) = cpu_to_le32(command_param);
+	if (ipa->version >= IPA_VERSION_3_0)
+		ipa_uc_shared(ipa)->v3.command_param_hi = 1;
+	UC_FIELD(ipa, response) = 0;
+	UC_FIELD(ipa, response_param) = 0;
 
 	/* Use an interrupt to tell the microcontroller the command is ready */
 	val = u32_encode_bits(1, UC_INTR_FMASK);
-- 
2.33.0

