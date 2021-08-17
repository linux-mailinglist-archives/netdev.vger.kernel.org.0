Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5086B3EE19F
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhHQA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbhHQAzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:55:54 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A27C06122E
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:21 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id q21so8573263ljj.6
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qagkQtaTlZmPxAEgYPi9rpyWnwBJTQJebKsAKhdvfc=;
        b=bPom6hkXdRt2fzsZMrGQmnn9MtSyxylCOyNHRvgpVhawiJNrQh6QUqc9ih5gcp1PF6
         x7+c0V9DfcVHe25Z00kgH9T2ng5nSvCBz+o704oipZiwi9g3Q79aomTtYCVE5rKr2XID
         isIpULaSopsDHVzvsUaGca7+jYh21REPOXKcvjZZGkmiuKDdDMalE24Btv637HBybtde
         t/oUVFkzkQdO3xkPAa1rKVrvYHSiS5YVlrimA71K0GOp0sLQSWff7XvQCNLH8ZIoI4OM
         Vibzz8QCOKSRXuoZjssW8pbA1Sg2PRC097Zq5t0AlYgDWr4OE5w7ViGN5v013nB2yfv5
         yl8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qagkQtaTlZmPxAEgYPi9rpyWnwBJTQJebKsAKhdvfc=;
        b=clCh/C/Qqqd+2EK3Squx0ZgSNamQdvoQJ/HiEEe93HOTpQpGJ1lUGrwSq2yUJOVhjk
         3Z9y2ypJHl4Qi5JMQ1uLefCsALaBFUSGkzPhwZp0wI94XIWYH1dh0T1ODKVk5B0Q96j/
         12vga2Y05izBnwlyPLgXy5PjhG0oi8MuRu8rvTrClLhRLMlyZ8jG4D96qXCTzTxhCwWT
         3N63FNkOtkNC3Eqe7qsCaSiLX63rl4HsCPYIMjdj8DNoiX0JfiT6bWxuhOuekWZPd2KN
         04M3NqnprXzP6WmY+xmsVhD8xd9Y+0EloAAOcB94lMqF9fLVWjq13P5bXXpgkEThHw5O
         F1jg==
X-Gm-Message-State: AOAM531qA5zZzmWhkhJzJ/DyrNqIEp6535SqBS9HMMsqRp2q3ks/RQtm
        AXa1lVImCea7Vd4tY1VoCi+Olg==
X-Google-Smtp-Source: ABdhPJy0Vxzbay2lg9uLfmPVEif7TuCf//2e8I2PdIm8X8c7CC97prs3p0qNiSFLC6TRElLB99wqvQ==
X-Received: by 2002:a2e:9751:: with SMTP id f17mr777675ljj.422.1629161719792;
        Mon, 16 Aug 2021 17:55:19 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:19 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 08/15] Bluetooth: hci_qca: futher rework of power on/off handling
Date:   Tue, 17 Aug 2021 03:55:00 +0300
Message-Id: <20210817005507.1507580-9-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Further rework of power on/off handling. Move bt_en and sw_ctl handling
close to regulator enable/disable, so that this code can be easily
extended with pwrseq support.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/bluetooth/hci_qca.c | 126 +++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 60 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index ad7e8cdc94f3..2d23e8a3ca14 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1590,7 +1590,6 @@ static int qca_power_on(struct hci_dev *hdev)
 	struct qca_serdev *qcadev;
 	struct qca_data *qca = hu->priv;
 	int ret;
-	bool sw_ctrl_state;
 
 	/* Non-serdev device usually is powered by external power
 	 * and don't need additional action in driver for power on
@@ -1602,29 +1601,15 @@ static int qca_power_on(struct hci_dev *hdev)
 	 * off the voltage regulator.
 	 */
 	qcadev = serdev_device_get_drvdata(hu->serdev);
-	if (!qcadev->vregs_on) {
-		serdev_device_close(hu->serdev);
-		ret = qca_regulator_enable(qcadev);
-		if (ret)
-			return ret;
-
-		ret = serdev_device_open(hu->serdev);
-		if (ret) {
-			bt_dev_err(hu->hdev, "failed to open port");
-			return ret;
-		}
-	}
+	serdev_device_close(hu->serdev);
+	ret = qca_regulator_enable(qcadev);
+	if (ret)
+		return ret;
 
-	/* For wcn6750 need to enable gpio bt_en */
-	if (qcadev->bt_en) {
-		gpiod_set_value_cansleep(qcadev->bt_en, 0);
-		msleep(50);
-		gpiod_set_value_cansleep(qcadev->bt_en, 1);
-		msleep(150);
-		if (qcadev->sw_ctrl) {
-			sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
-			bt_dev_dbg(hu->hdev, "SW_CTRL is %d", sw_ctrl_state);
-		}
+	ret = serdev_device_open(hu->serdev);
+	if (ret) {
+		bt_dev_err(hu->hdev, "failed to open port");
+		return ret;
 	}
 
 	if (qca_is_wcn399x(soc_type)) {
@@ -1856,7 +1841,6 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	struct qca_data *qca = hu->priv;
 	unsigned long flags;
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
-	bool sw_ctrl_state;
 
 	/* From this point we go into power off state. But serial port is
 	 * still open, stop queueing the IBS data and flush all the buffered
@@ -1878,18 +1862,8 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	if (qca_is_wcn399x(soc_type)) {
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
-		qca_regulator_disable(qcadev);
-	} else if (soc_type == QCA_WCN6750) {
-		gpiod_set_value_cansleep(qcadev->bt_en, 0);
-		msleep(100);
-		qca_regulator_disable(qcadev);
-		if (qcadev->sw_ctrl) {
-			sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
-			bt_dev_dbg(hu->hdev, "SW_CTRL is %d", sw_ctrl_state);
-		}
-	} else if (qcadev->bt_en) {
-		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 	}
+	qca_regulator_disable(qcadev);
 
 	set_bit(QCA_BT_OFF, &qca->flags);
 }
@@ -1919,20 +1893,39 @@ static int qca_regulator_enable(struct qca_serdev *qcadev)
 	int ret;
 
 	/* Already enabled */
-	if (qcadev->vregs_on)
-		return 0;
+	if (!qcadev->vregs_on) {
+		BT_DBG("enabling %d regulators)", qcadev->num_vregs);
 
-	BT_DBG("enabling %d regulators)", qcadev->num_vregs);
+		ret = regulator_bulk_enable(qcadev->num_vregs, qcadev->vreg_bulk);
+		if (ret)
+			return ret;
 
-	ret = regulator_bulk_enable(qcadev->num_vregs, qcadev->vreg_bulk);
-	if (ret)
-		return ret;
+		qcadev->vregs_on = true;
 
-	qcadev->vregs_on = true;
+		if (qca_is_wcn399x(qcadev->btsoc_type) ||
+		    qca_is_wcn6750(qcadev->btsoc_type)) {
+			ret = clk_prepare_enable(qcadev->susclk);
+			if (ret) {
+				regulator_bulk_disable(qcadev->num_vregs, qcadev->vreg_bulk);
+				return ret;
+			}
+		}
+	}
 
-	ret = clk_prepare_enable(qcadev->susclk);
-	if (ret)
-		qca_regulator_disable(qcadev);
+	/* For wcn6750 need to enable gpio bt_en */
+	if (qcadev->bt_en) {
+		gpiod_set_value_cansleep(qcadev->bt_en, 0);
+		msleep(50);
+		gpiod_set_value_cansleep(qcadev->bt_en, 1);
+		msleep(150);
+	}
+
+	if (qcadev->sw_ctrl) {
+		bool sw_ctrl_state;
+
+		sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
+		bt_dev_dbg(qcadev->serdev_hu.hdev, "SW_CTRL is %d", sw_ctrl_state);
+	}
 
 	return ret;
 }
@@ -1942,14 +1935,27 @@ static void qca_regulator_disable(struct qca_serdev *qcadev)
 	if (!qcadev)
 		return;
 
+	if (qcadev->bt_en) {
+		gpiod_set_value_cansleep(qcadev->bt_en, 0);
+		msleep(100);
+	}
+
 	/* Already disabled? */
-	if (!qcadev->vregs_on)
-		return;
+	if (qcadev->vregs_on) {
+		regulator_bulk_disable(qcadev->num_vregs, qcadev->vreg_bulk);
+		qcadev->vregs_on = false;
 
-	regulator_bulk_disable(qcadev->num_vregs, qcadev->vreg_bulk);
-	qcadev->vregs_on = false;
+		if (qca_is_wcn399x(qcadev->btsoc_type) ||
+		    qca_is_wcn6750(qcadev->btsoc_type))
+			clk_disable_unprepare(qcadev->susclk);
+	}
+
+	if (qcadev->sw_ctrl) {
+		bool sw_ctrl_state;
 
-	clk_disable_unprepare(qcadev->susclk);
+		sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
+		bt_dev_dbg(qcadev->serdev_hu.hdev, "SW_CTRL is %d", sw_ctrl_state);
+	}
 }
 
 static int qca_init_regulators(struct qca_serdev *qcadev, struct device *dev,
@@ -2018,17 +2024,17 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 		}
 
 		qcadev->vregs_on = false;
-	}
 
-	qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
-			GPIOD_OUT_LOW);
-	if (!qcadev->bt_en) {
-		if (qca_is_wcn6750(data->soc_type)) {
-			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
-			power_ctrl_enabled = false;
-		} else if (!qca_is_wcn399x(data->soc_type)) {
-			dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
-			power_ctrl_enabled = false;
+		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
+				GPIOD_OUT_LOW);
+		if (!qcadev->bt_en) {
+			if (qca_is_wcn6750(data->soc_type)) {
+				dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
+				power_ctrl_enabled = false;
+			} else if (!qca_is_wcn399x(data->soc_type)) {
+				dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
+				power_ctrl_enabled = false;
+			}
 		}
 	}
 
-- 
2.30.2

