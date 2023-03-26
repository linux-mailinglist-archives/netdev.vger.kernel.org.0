Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67556C98D3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 01:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjCZXih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 19:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjCZXiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 19:38:22 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD59C4EFA
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 16:38:19 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-17ebba88c60so7567926fac.3
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 16:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679873897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F2+Fw7YRmyaV2oeYEGroUW/UzjQGm5MBPAIdb+lRLbo=;
        b=gxCkwH9253QdIyowDJJta5EobXIvQDTWdf7O0p65IoEq4h0u+ZTWo/lEASYm8iofkz
         CbsY5eQP8KYoEGidz4UyGTb9TyALDsLjaHfGSGNAiazbvwB8Hl18mAGyw2XH1Iv5NUsA
         Ywv5oQjifm5xXECTd0QEUwbDja5vEpsHPxnbIHpYYpIpefPp8VbCbtMHSFwCSpdWp0/4
         tZD7f6rmqooaaYHfLB/hYQ0kIbNr/WSFAAGPERVTanRTyRtBxhsXCqjwunY5iEJXC9v5
         cYyhaLsI3jzUZKZ6kKLT297VCyWcH1eZf0G+accw8rdkVwWid9svhXwT+yuImAKspWU6
         yNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679873897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F2+Fw7YRmyaV2oeYEGroUW/UzjQGm5MBPAIdb+lRLbo=;
        b=jyfnPtmCTrtG+/Y2p7tOUVPfyRYDsdotV6TLspKvOTXjHAi/2iJAnwKPMr66ZDkA2C
         Ne6vE8EOk6+GWHZDwaY3xfsAqoYLdOD7S7SjoF0RtbwXOQAjv+7uklOpiyelNwgcbdSB
         0OhoT6tb4CV7eyom/79kaYGALE4UF97B6fR57VatzaHSJ9tRf5/Lu/wTwpiW0Hxn9YwE
         TWrBUDMrwNtjiFO6S8x8CTYMWaocq59iQrHR1FLCjYE95CBdKysFdeOPBvu2H7P7YqND
         B9U8q1erpCKexS6fjOxivkxg7pHAyo7J0YbUvByzJ/Q4SyDy40IRvaIAX8N5/TxH4H7+
         +E2Q==
X-Gm-Message-State: AAQBX9fbQqCj1w+t1zW7N202yAS13sDl6pJD9jcDHjHzqvUyvR/fou3p
        T7qfrk0Km3k3W/BwxO5iZMN0Fg==
X-Google-Smtp-Source: AK7set9Yo5bVc8yC0+vftC/q7dDdHAOW01gAtPZ/t4TV7ylYCoje01pj0Aat1+1hGAbcE/Qs/xi+lg==
X-Received: by 2002:a05:6870:c22c:b0:177:81bb:1b1b with SMTP id z44-20020a056870c22c00b0017781bb1b1bmr6160708oae.40.1679873897400;
        Sun, 26 Mar 2023 16:38:17 -0700 (PDT)
Received: from localhost ([2600:1700:eb1:c450::35])
        by smtp.gmail.com with ESMTPSA id yt10-20020a05687c220a00b001726cfeea97sm9264942oab.29.2023.03.26.16.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 16:38:16 -0700 (PDT)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH v8 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
Date:   Sun, 26 Mar 2023 18:38:10 -0500
Message-Id: <20230326233812.28058-3-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230326233812.28058-1-steev@kali.org>
References: <20230326233812.28058-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add regulators, GPIOs and changes required to power on/off wcn6855.
Add support for firmware download for wcn6855 which is in the
linux-firmware repository as hpbtfw21.tlv and hpnv21.bin.

Based on the assumption that this is similar to the wcn6750

Tested-on: BTFW.HSP.2.1.0-00538-VER_PATCHZ-1

Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Tested-by: Bjorn Andersson <andersson@kernel.org>
---
Changes since v7:
 * None

Changes since v6:
 * Update commit message.
 * Add Johan's R-b and T-b.

Changes since v5:
 * Revert Set qcadev->initspeed since 6855 doesn't use it, don't touch.
 * Convert get_fw_build_info to a switch statement
 * Add poweroff handling
 * Fix up line alignments
 * Drop from microsoft extensions check since I don't actually know if we need

Changes since v4:
 * Remove unused firmware check because we don't have mbn firmware.
 * Set qcadev->init_speed if it hasn't been set.

Changes since v3:
 * drop unused regulators

Changes since v2:
 * drop unnecessary commit info

Changes since v1:
 * None

 drivers/bluetooth/btqca.c   | 14 ++++++++-
 drivers/bluetooth/btqca.h   | 10 +++++++
 drivers/bluetooth/hci_qca.c | 57 ++++++++++++++++++++++++++++---------
 3 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index c9064d34d830..fd0941fe8608 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -614,6 +614,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		config.type = ELF_TYPE_PATCH;
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msbtfw%02x.mbn", rom_ver);
+	} else if (soc_type == QCA_WCN6855) {
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hpbtfw%02x.tlv", rom_ver);
 	} else {
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/rampatch_%08x.bin", soc_ver);
@@ -648,6 +651,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	else if (soc_type == QCA_WCN6750)
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msnv%02x.bin", rom_ver);
+	else if (soc_type == QCA_WCN6855)
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hpnv%02x.bin", rom_ver);
 	else
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/nvm_%08x.bin", soc_ver);
@@ -685,11 +691,17 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		return err;
 	}
 
-	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750) {
+	switch (soc_type) {
+	case QCA_WCN3991:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		/* get fw build info */
 		err = qca_read_fw_build_info(hdev);
 		if (err < 0)
 			return err;
+		break;
+	default:
+		break;
 	}
 
 	bt_dev_info(hdev, "QCA setup on UART is completed");
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index 61e9a50e66ae..b884095bcd9d 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -147,6 +147,7 @@ enum qca_btsoc_type {
 	QCA_WCN3991,
 	QCA_QCA6390,
 	QCA_WCN6750,
+	QCA_WCN6855,
 };
 
 #if IS_ENABLED(CONFIG_BT_QCA)
@@ -168,6 +169,10 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 {
 	return soc_type == QCA_WCN6750;
 }
+static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
+{
+	return soc_type == QCA_WCN6855;
+}
 
 #else
 
@@ -206,6 +211,11 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 	return false;
 }
 
+static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
+{
+	return false;
+}
+
 static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 3df8c3606e93..38ff962662ff 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1317,7 +1317,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 
 	/* Give the controller time to process the request */
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu)))
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu)))
 		usleep_range(1000, 10000);
 	else
 		msleep(300);
@@ -1394,7 +1395,8 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
 static int qca_check_speeds(struct hci_uart *hu)
 {
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu))) {
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu))) {
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
@@ -1428,7 +1430,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		 * changing the baudrate of chip and host.
 		 */
 		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type))
+		    qca_is_wcn6750(soc_type) ||
+		    qca_is_wcn6855(soc_type))
 			hci_uart_set_flow_control(hu, true);
 
 		if (soc_type == QCA_WCN3990) {
@@ -1446,7 +1449,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 
 error:
 		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type))
+		    qca_is_wcn6750(soc_type) ||
+		    qca_is_wcn6855(soc_type))
 			hci_uart_set_flow_control(hu, false);
 
 		if (soc_type == QCA_WCN3990) {
@@ -1682,7 +1686,8 @@ static int qca_power_on(struct hci_dev *hdev)
 		return 0;
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		ret = qca_regulator_init(hu);
 	} else {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
@@ -1723,7 +1728,8 @@ static int qca_setup(struct hci_uart *hu)
 
 	bt_dev_info(hdev, "setting up %s",
 		qca_is_wcn399x(soc_type) ? "wcn399x" :
-		(soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
+		(soc_type == QCA_WCN6750) ? "wcn6750" :
+		(soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
 
 	qca->memdump_state = QCA_MEMDUMP_IDLE;
 
@@ -1735,7 +1741,8 @@ static int qca_setup(struct hci_uart *hu)
 	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
@@ -1757,7 +1764,8 @@ static int qca_setup(struct hci_uart *hu)
 	}
 
 	if (!(qca_is_wcn399x(soc_type) ||
-	     qca_is_wcn6750(soc_type))) {
+	      qca_is_wcn6750(soc_type) ||
+	      qca_is_wcn6855(soc_type))) {
 		/* Get QCA version information */
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
 		if (ret)
@@ -1883,6 +1891,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 = {
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
+static const struct qca_device_data qca_soc_data_wcn6855 = {
+	.soc_type = QCA_WCN6855,
+	.vregs = (struct qca_vreg []) {
+		{ "vddio", 5000 },
+		{ "vddbtcxmx", 126000 },
+		{ "vddrfacmn", 12500 },
+		{ "vddrfa0p8", 102000 },
+		{ "vddrfa1p7", 302000 },
+		{ "vddrfa1p2", 257000 },
+	},
+	.num_vregs = 6,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
+};
+
 static void qca_power_shutdown(struct hci_uart *hu)
 {
 	struct qca_serdev *qcadev;
@@ -1912,7 +1934,7 @@ static void qca_power_shutdown(struct hci_uart *hu)
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
 		qca_regulator_disable(qcadev);
-	} else if (soc_type == QCA_WCN6750) {
+	} else if (soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 		msleep(100);
 		qca_regulator_disable(qcadev);
@@ -2047,7 +2069,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 	if (data &&
 	    (qca_is_wcn399x(data->soc_type) ||
-	    qca_is_wcn6750(data->soc_type))) {
+	     qca_is_wcn6750(data->soc_type) ||
+	     qca_is_wcn6855(data->soc_type))) {
 		qcadev->btsoc_type = data->soc_type;
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
 						sizeof(struct qca_power),
@@ -2067,14 +2090,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en) &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855)) {
 			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
 			power_ctrl_enabled = false;
 		}
 
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
 					       GPIOD_IN);
-		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
+		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855))
 			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
@@ -2150,8 +2177,9 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 	struct qca_power *power = qcadev->bt_power;
 
 	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
-	     qca_is_wcn6750(qcadev->btsoc_type)) &&
-	     power->vregs_on)
+	     qca_is_wcn6750(qcadev->btsoc_type) ||
+	     qca_is_wcn6855(qcadev->btsoc_type)) &&
+	    power->vregs_on)
 		qca_power_shutdown(&qcadev->serdev_hu);
 	else if (qcadev->susclk)
 		clk_disable_unprepare(qcadev->susclk);
@@ -2335,6 +2363,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
 	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
+	{ .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
-- 
2.39.2

