Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE668FCE2
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjBICJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjBICJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:09:26 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A91A21945
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 18:09:22 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id g7so490629qto.11
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 18:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/RNKXMle4djHebuWC777LOqWlZM6JmXWNlVvHsu6e0=;
        b=agkYxzWmCplq5Trc6UeZqBwOP3rh1eFFzr3yihXLIsJpehlEY81HSFNh310pG/xUWQ
         7jjV8c/p7XWJvdGfB3ZXLYQJfgCMmj9usT4enkFu1tevsssLjQyW5MuiKZi488i05cAu
         tGkl2YDjsnZ8zPHtC856T7Ry9dL5+MquUC6TZq2dhqEiKztjb0+vxEVapGlhKHTRdXxx
         LYi236qdbIWfbWS8c1T/CiIW4qT/vkby2tQjf6fK0HaI9+7sXt2GE43m2dMY458O3PD3
         kKJoViDVReOT1ryj4uIyMiBVrmJxPy3DxtNLTPZL93J23LDWo7T4PguQSrvdQ2czl6mz
         JyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/RNKXMle4djHebuWC777LOqWlZM6JmXWNlVvHsu6e0=;
        b=IC37zcjbFLinfPC+i4S+IrlbQDM0VKXcRWp+Xs4c9BOlEEcca+gP42bQk+vhUxqFGR
         KFawhf6/ezQttXyAMeOXgLQZU7XCkdc8jwxZWA/6UP/SG5597qDfXt+Riwjxd5psUW6H
         i38EnnF1k1nMoYYN4o86xcxuzT7GMdSRYLWDXLgqLF9j5/GLmRKoW+shMzRIK7jcqZ07
         WQspndQma9tEgy+DFaAobYYG/MYM3S2UjIqChmOpjBjlPZQ7eApBI068ns/JqJMD49EA
         jW8Dy6sDiYi+s91qhELWewlxRVz1h+uQ614X0gi+cX1T9kgtF5+TmC482gGBckwOzSww
         fH9w==
X-Gm-Message-State: AO0yUKW3G5LgFxBwDM5BaWNu06hsiK+lwkiYU/afGCVV3wEGV2FMspW7
        fkI4CKwk0byUpvbQCvydeLxyPw==
X-Google-Smtp-Source: AK7set+kTO5ixNksdDd9ZCCOom5fO1vHr9mpMe+3oJXsJO/Ir1P8HmxGERCXi7gNzxsg8k49dBVong==
X-Received: by 2002:ac8:7e87:0:b0:3b9:b619:42c1 with SMTP id w7-20020ac87e87000000b003b9b61942c1mr17309074qtj.27.1675908561276;
        Wed, 08 Feb 2023 18:09:21 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id ew12-20020a05622a514c00b003b86a6449b8sm327360qtb.85.2023.02.08.18.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 18:09:20 -0800 (PST)
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
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
Date:   Wed,  8 Feb 2023 20:09:14 -0600
Message-Id: <20230209020916.6475-3-steev@kali.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209020916.6475-1-steev@kali.org>
References: <20230209020916.6475-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added regulators,GPIOs and changes required to power on/off wcn6855.
Added support for firmware download for wcn6855.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
---
Changes since v4:
 * Remove unused firmware check because we don't have mbn firmware.
 * Set qcadev->init_speed if it hasn't been set.

Changes since v3:
 * drop unused regulators

Changes since v2:
 * drop unnecessary commit info

Changes since v1:
 * None

 drivers/bluetooth/btqca.c   |  9 ++++++-
 drivers/bluetooth/btqca.h   | 10 ++++++++
 drivers/bluetooth/hci_qca.c | 50 ++++++++++++++++++++++++++++---------
 3 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index c9064d34d830..2f9d8bd27c38 100644
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
@@ -672,6 +678,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	case QCA_WCN3991:
 	case QCA_WCN3998:
 	case QCA_WCN6750:
+	case QCA_WCN6855:
 		hci_set_msft_opcode(hdev, 0xFD70);
 		break;
 	default:
@@ -685,7 +692,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		return err;
 	}
 
-	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750) {
+	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {
 		/* get fw build info */
 		err = qca_read_fw_build_info(hdev);
 		if (err < 0)
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
index 3df8c3606e93..efc1c0306b4e 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -605,8 +605,7 @@ static int qca_open(struct hci_uart *hu)
 	if (hu->serdev) {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 
-		if (qca_is_wcn399x(qcadev->btsoc_type) ||
-		    qca_is_wcn6750(qcadev->btsoc_type))
+		if (!(qcadev->init_speed))
 			hu->init_speed = qcadev->init_speed;
 
 		if (qcadev->oper_speed)
@@ -1317,7 +1316,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 
 	/* Give the controller time to process the request */
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu)))
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu)))
 		usleep_range(1000, 10000);
 	else
 		msleep(300);
@@ -1394,7 +1394,8 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
 static int qca_check_speeds(struct hci_uart *hu)
 {
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu))) {
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu))) {
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
@@ -1682,7 +1683,8 @@ static int qca_power_on(struct hci_dev *hdev)
 		return 0;
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		ret = qca_regulator_init(hu);
 	} else {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
@@ -1723,7 +1725,8 @@ static int qca_setup(struct hci_uart *hu)
 
 	bt_dev_info(hdev, "setting up %s",
 		qca_is_wcn399x(soc_type) ? "wcn399x" :
-		(soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
+		(soc_type == QCA_WCN6750) ? "wcn6750" :
+		(soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
 
 	qca->memdump_state = QCA_MEMDUMP_IDLE;
 
@@ -1735,7 +1738,8 @@ static int qca_setup(struct hci_uart *hu)
 	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
@@ -1757,7 +1761,8 @@ static int qca_setup(struct hci_uart *hu)
 	}
 
 	if (!(qca_is_wcn399x(soc_type) ||
-	     qca_is_wcn6750(soc_type))) {
+	     qca_is_wcn6750(soc_type) ||
+	     qca_is_wcn6855(soc_type))) {
 		/* Get QCA version information */
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
 		if (ret)
@@ -1883,6 +1888,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 = {
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
@@ -2047,7 +2066,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 	if (data &&
 	    (qca_is_wcn399x(data->soc_type) ||
-	    qca_is_wcn6750(data->soc_type))) {
+	    qca_is_wcn6750(data->soc_type) ||
+	    qca_is_wcn6855(data->soc_type))) {
 		qcadev->btsoc_type = data->soc_type;
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
 						sizeof(struct qca_power),
@@ -2067,14 +2087,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en)
+		    && (data->soc_type == QCA_WCN6750 ||
+			data->soc_type == QCA_WCN6855)) {
 			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
 			power_ctrl_enabled = false;
 		}
 
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
 					       GPIOD_IN);
-		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
+		if (IS_ERR_OR_NULL(qcadev->sw_ctrl)
+		    && (data->soc_type == QCA_WCN6750 ||
+			data->soc_type == QCA_WCN6855))
 			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
@@ -2150,7 +2174,8 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 	struct qca_power *power = qcadev->bt_power;
 
 	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
-	     qca_is_wcn6750(qcadev->btsoc_type)) &&
+	     qca_is_wcn6750(qcadev->btsoc_type) ||
+	     qca_is_wcn6855(qcadev->btsoc_type)) &&
 	     power->vregs_on)
 		qca_power_shutdown(&qcadev->serdev_hu);
 	else if (qcadev->susclk)
@@ -2335,6 +2360,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
 	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
+	{ .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
-- 
2.39.1

