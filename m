Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE353EE1A0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbhHQA4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbhHQAzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:55:54 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD9FC061796
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:22 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s3so1080171ljp.11
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=osWd7o/rbNiDPvWTS+l0GmKDa+5+wAZOkcYrzBBA3b8=;
        b=lT5ChW9T1u195uYv4Esr58dfWbudSm+C+kKwpf9Lruop4z4jZ6yU7Ttg9iNOslMEl1
         oBIrCmYc74WXZoj21FXZG3tPQJyveSrh3Y0P5uLh9Yzj81tKblayMrjJH11cc3CMi8iY
         6JCW94lFgA93lhEAZuZJbU5TlePL3EYs9PoOfiJv2rXd1rb9Dqbj4ZhlTpm1uAkMnDCZ
         2ria0E26+y7SN+qI5WoqxXgtjfINcQftMJIonKwmrtKYVykoASrT298MBPclrLJuia9V
         moSbwQz/KefZctVj3YxvN0y4HmHsoKXCExcUs1nfkKesvsCiD+WzeSBD9/2LPA64+n7u
         hLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osWd7o/rbNiDPvWTS+l0GmKDa+5+wAZOkcYrzBBA3b8=;
        b=NU4lel9vIecDmWf60EkeEBxqa1Ts/FHyfbSFdwlLgGFJNRezcHKvl+ezlalEKl+Zdf
         XQfnsAD+4qZbnCjBRtJl2QS+1wTeGroJuCpn1dCl7N2cCx4KmmLfxkvuWIQs4tTV1hvQ
         woU3tmEfaAOPcVQYja89GkHzzgyk/jnfJTH7Tt2c7y63/cZ2cNrQfj68CiH/DnRonFQ7
         /oZHNG/RP9z3e5yPLNUVaDmwTospzmv3fkIs7TaZNwJaheWBUPLRp/MUBM9znPVdt381
         jL/QB9jbKkwl87bs7KYHlUh76mQCbbGrXkFGc8G+tms36FXVQMG70gB9MMpmOwMtRp9e
         K7kw==
X-Gm-Message-State: AOAM5301baqwADll2OBSbS9JIMKDTz61SRLeIzBln3wVF46v4WJwE/OP
        +XxIr1/2e3Q24rMW5FR7v63Wyg==
X-Google-Smtp-Source: ABdhPJz0uYwW8+HUPLaLEIGd3/MVOQML6ZV+enuZ/lIlsO1SnklxizPta3pJuzgtBrngpxzwl2Cuyg==
X-Received: by 2002:a2e:9a50:: with SMTP id k16mr793082ljj.308.1629161720605;
        Mon, 16 Aug 2021 17:55:20 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:20 -0700 (PDT)
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
Subject: [RFC PATCH 09/15] Bluetooth: hci_qca: add support for pwrseq
Date:   Tue, 17 Aug 2021 03:55:01 +0300
Message-Id: <20210817005507.1507580-10-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support using pwrseq for powering up and down the QCA BT chips.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/bluetooth/hci_qca.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 2d23e8a3ca14..a908a952c0ef 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/serdev.h>
 #include <linux/mutex.h>
+#include <linux/pwrseq/consumer.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -211,6 +212,7 @@ struct qca_serdev {
 	struct gpio_desc *sw_ctrl;
 	struct clk	 *susclk;
 	enum qca_btsoc_type btsoc_type;
+	struct pwrseq *pwrseq;
 	struct regulator_bulk_data *vreg_bulk;
 	int num_vregs;
 	bool vregs_on;
@@ -1602,7 +1604,10 @@ static int qca_power_on(struct hci_dev *hdev)
 	 */
 	qcadev = serdev_device_get_drvdata(hu->serdev);
 	serdev_device_close(hu->serdev);
-	ret = qca_regulator_enable(qcadev);
+	if (qcadev->pwrseq)
+		ret = pwrseq_full_power_on(qcadev->pwrseq);
+	else
+		ret = qca_regulator_enable(qcadev);
 	if (ret)
 		return ret;
 
@@ -1863,7 +1868,10 @@ static void qca_power_shutdown(struct hci_uart *hu)
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
 	}
-	qca_regulator_disable(qcadev);
+	if (qcadev->pwrseq)
+		pwrseq_power_off(qcadev->pwrseq);
+	else
+		qca_regulator_disable(qcadev);
 
 	set_bit(QCA_BT_OFF, &qca->flags);
 }
@@ -2015,7 +2023,15 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	else
 		qcadev->btsoc_type = QCA_ROME;
 
-	if (data && data->num_vregs) {
+	qcadev->pwrseq = devm_pwrseq_get_optional(&serdev->dev, "bt");
+	if (IS_ERR(qcadev->pwrseq)) {
+		err = PTR_ERR(qcadev->pwrseq);
+		BT_ERR("Failed to init regulators:%d", err);
+		return err;
+
+	}
+
+	if (!qcadev->pwrseq && data && data->num_vregs) {
 		err = qca_init_regulators(qcadev, &serdev->dev, data->vregs,
 					  data->num_vregs);
 		if (err) {
-- 
2.30.2

