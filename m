Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2846057A5CF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237903AbiGSRwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiGSRwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:52:13 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FD85721D
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 10:52:12 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x64so4081121iof.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 10:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rB7o+ewIoO3FUkfsiaMwCjzAdF/lHvk4AwcfyukpsxU=;
        b=uVMeKJxib36NPSrOLH9Tgwyc1KUFB4Ta6lidixTCNfgr0MZNO3rkNgEA3/7FbT/49g
         ZpPxlqArHit/jITiDn+Nr5iuy/Xv8Ji86MHQnLwe4G2tSAYxswtFGZD5PB9OL0h9s+4M
         ZPxoOFdl+FnB2s6jsgtas7G4eZUTAL+Ur+5QIq0k8DEsCstP/pIVoFobN7enQ6TccBLm
         cX5eIrSKPjkKM/qhcHTCWZg8NA9ewNpo2+UoyiRPw4VPHd8uxGvJyUdSWZwXrsLcEYe+
         6ylyxSWlyFdeDewqoUuUPxHiVw+GK8VRvY9GLoq5fl+eNuLQ2nAJIlR65mHsbc1nvUYf
         D2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rB7o+ewIoO3FUkfsiaMwCjzAdF/lHvk4AwcfyukpsxU=;
        b=J52Dlb8U+4z6nM8Hi7ahodroW0iFnDGFNDL4LjcYw8QD12gJZYdFu452V4oIL/Srv3
         0iWKfoxQDo7crqm0Z3h9Otv0NrNbwMldUUmqfa7v2Kcvvkl9Fvb31UItY5dssWYJPKeh
         a6Udfiuacd/rTTWi8dsVzh1thODia6IJpCd/dORArcVm1JJ/P3sQxBRAlrKeLDXdeiF1
         6xeUbjRc9MH1PjLFe4xabLn9UnjSSzAalZeSspNSCjMp9OfRxJd2l00zwJQrTAryixhD
         IEC+e2ND4xqPG4KAAK7aNAJiB4DUTRAIT/WehNNC2dsVP3jOZwaZAROmJKF9dzDoKjY8
         Ov1g==
X-Gm-Message-State: AJIora8yz88l72BGs3pdtHiutBwL719eqWWKHHAzMiSW6D+ajFDtezXt
        5Ie6hI/dcLz0Ye0HnpIjfOfnxA==
X-Google-Smtp-Source: AGRyM1tfnv68Gt/DWToQQr60kx81/xQXesovNpq/CNnUJQC8X6RPeSXAF2Pjf90SEqavepVhXI1OFw==
X-Received: by 2002:a02:cb44:0:b0:33f:51a9:baa with SMTP id k4-20020a02cb44000000b0033f51a90baamr18592999jap.125.1658253131230;
        Tue, 19 Jul 2022 10:52:11 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n2-20020a056e0208e200b002dcdbb4f7b7sm3606899ilt.24.2022.07.19.10.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 10:52:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3] net: ipa: add an endpoint device attribute group
Date:   Tue, 19 Jul 2022 12:52:07 -0500
Message-Id: <20220719175207.325008-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Create a new attribute group meant to provide a single place that
defines endpoint IDs that might be needed by user space.  Not all
defined endpoints are presented, and only those that are defined
will be made visible.

The new attributes use "extended" device attributes to hold endpoint
IDs, which is a little more compact and efficient.  Reimplement the
existing modem endpoint ID attribute files using common code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v3: Use uintptr_t in a second spot, missed the first time...
v2: Use uintptr_t to try to avoid a "cast to smaller integer type"
    warning produced by "clang".

 .../testing/sysfs-devices-platform-soc-ipa    | 62 +++++++++++++----
 drivers/net/ipa/ipa_main.c                    |  1 +
 drivers/net/ipa/ipa_sysfs.c                   | 69 ++++++++++++++-----
 drivers/net/ipa/ipa_sysfs.h                   |  1 +
 4 files changed, 102 insertions(+), 31 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa b/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
index c56dcf15bf29d..364b1ba412427 100644
--- a/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
+++ b/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
@@ -46,33 +46,69 @@ Description:
 		that is supported by the hardware.  The possible values
 		are "MAPv4" or "MAPv5".
 
+What:		.../XXXXXXX.ipa/endpoint_id/
+Date:		July 2022
+KernelVersion:	v5.19
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/endpoint_id/ directory contains
+		attributes that define IDs associated with IPA
+		endpoints.  The "rx" or "tx" in an endpoint name is
+		from the perspective of the AP.  An endpoint ID is a
+		small unsigned integer.
+
+What:		.../XXXXXXX.ipa/endpoint_id/modem_rx
+Date:		July 2022
+KernelVersion:	v5.19
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/endpoint_id/modem_rx file contains
+		the ID of the AP endpoint on which packets originating
+		from the embedded modem are received.
+
+What:		.../XXXXXXX.ipa/endpoint_id/modem_tx
+Date:		July 2022
+KernelVersion:	v5.19
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/endpoint_id/modem_tx file contains
+		the ID of the AP endpoint on which packets destined
+		for the embedded modem are sent.
+
+What:		.../XXXXXXX.ipa/endpoint_id/monitor_rx
+Date:		July 2022
+KernelVersion:	v5.19
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/endpoint_id/monitor_rx file contains
+		the ID of the AP endpoint on which IPA "monitor" data is
+		received.  The monitor endpoint supplies replicas of
+		packets that enter the IPA hardware for processing.
+		Each replicated packet is preceded by a fixed-size "ODL"
+		header (see .../XXXXXXX.ipa/feature/monitor, above).
+		Large packets are truncated, to reduce the bandwidth
+		required to provide the monitor function.
+
 What:		.../XXXXXXX.ipa/modem/
 Date:		June 2021
 KernelVersion:	v5.14
 Contact:	Alex Elder <elder@kernel.org>
 Description:
-		The .../XXXXXXX.ipa/modem/ directory contains a set of
-		attributes describing properties of the modem execution
-		environment reachable by the IPA hardware.
+		The .../XXXXXXX.ipa/modem/ directory contains attributes
+		describing properties of the modem embedded in the SoC.
 
 What:		.../XXXXXXX.ipa/modem/rx_endpoint_id
 Date:		June 2021
 KernelVersion:	v5.14
 Contact:	Alex Elder <elder@kernel.org>
 Description:
-		The .../XXXXXXX.ipa/feature/rx_endpoint_id file contains
-		the AP endpoint ID that receives packets originating from
-		the modem execution environment.  The "rx" is from the
-		perspective of the AP; this endpoint is considered an "IPA
-		producer".  An endpoint ID is a small unsigned integer.
+		The .../XXXXXXX.ipa/modem/rx_endpoint_id file duplicates
+		the value found in .../XXXXXXX.ipa/endpoint_id/modem_rx.
 
 What:		.../XXXXXXX.ipa/modem/tx_endpoint_id
 Date:		June 2021
 KernelVersion:	v5.14
 Contact:	Alex Elder <elder@kernel.org>
 Description:
-		The .../XXXXXXX.ipa/feature/tx_endpoint_id file contains
-		the AP endpoint ID used to transmit packets destined for
-		the modem execution environment.  The "tx" is from the
-		perspective of the AP; this endpoint is considered an "IPA
-		consumer".  An endpoint ID is a small unsigned integer.
+		The .../XXXXXXX.ipa/modem/tx_endpoint_id file duplicates
+		the value found in .../XXXXXXX.ipa/endpoint_id/modem_tx.
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 3757ce3de2c59..b989259b02047 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -851,6 +851,7 @@ static void ipa_shutdown(struct platform_device *pdev)
 static const struct attribute_group *ipa_attribute_groups[] = {
 	&ipa_attribute_group,
 	&ipa_feature_attribute_group,
+	&ipa_endpoint_id_attribute_group,
 	&ipa_modem_attribute_group,
 	NULL,
 };
diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
index ff61dbdd70d8c..c0c8641cdd14a 100644
--- a/drivers/net/ipa/ipa_sysfs.c
+++ b/drivers/net/ipa/ipa_sysfs.c
@@ -96,38 +96,71 @@ const struct attribute_group ipa_feature_attribute_group = {
 	.attrs		= ipa_feature_attrs,
 };
 
-static ssize_t
-ipa_endpoint_id_show(struct ipa *ipa, char *buf, enum ipa_endpoint_name name)
+static umode_t ipa_endpoint_id_is_visible(struct kobject *kobj,
+					  struct attribute *attr, int n)
 {
-	u32 endpoint_id = ipa->name_map[name]->endpoint_id;
+	struct ipa *ipa = dev_get_drvdata(kobj_to_dev(kobj));
+	struct device_attribute *dev_attr;
+	struct dev_ext_attribute *ea;
+	bool visible;
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n", endpoint_id);
+	/* An endpoint id attribute is only visible if it's defined */
+	dev_attr = container_of(attr, struct device_attribute, attr);
+	ea = container_of(dev_attr, struct dev_ext_attribute, attr);
+
+	visible = !!ipa->name_map[(enum ipa_endpoint_name)(uintptr_t)ea->var];
+
+	return visible ? attr->mode : 0;
 }
 
-static ssize_t rx_endpoint_id_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t endpoint_id_attr_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
+	struct ipa_endpoint *endpoint;
+	struct dev_ext_attribute *ea;
 
-	return ipa_endpoint_id_show(ipa, buf, IPA_ENDPOINT_AP_MODEM_RX);
+	ea = container_of(attr, struct dev_ext_attribute, attr);
+	endpoint = ipa->name_map[(enum ipa_endpoint_name)(uintptr_t)ea->var];
+
+	return sysfs_emit(buf, "%u\n", endpoint->endpoint_id);
 }
 
-static DEVICE_ATTR_RO(rx_endpoint_id);
+#define ENDPOINT_ID_ATTR(_n, _endpoint_name)				    \
+	static struct dev_ext_attribute dev_attr_endpoint_id_ ## _n = {	    \
+		.attr	= __ATTR(_n, 0444, endpoint_id_attr_show, NULL),    \
+		.var	= (void *)(_endpoint_name),			    \
+	}
 
-static ssize_t tx_endpoint_id_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct ipa *ipa = dev_get_drvdata(dev);
+ENDPOINT_ID_ATTR(modem_rx, IPA_ENDPOINT_AP_MODEM_RX);
+ENDPOINT_ID_ATTR(modem_tx, IPA_ENDPOINT_AP_MODEM_TX);
 
-	return ipa_endpoint_id_show(ipa, buf, IPA_ENDPOINT_AP_MODEM_TX);
-}
+static struct attribute *ipa_endpoint_id_attrs[] = {
+	&dev_attr_endpoint_id_modem_rx.attr.attr,
+	&dev_attr_endpoint_id_modem_tx.attr.attr,
+	NULL
+};
+
+const struct attribute_group ipa_endpoint_id_attribute_group = {
+	.name		= "endpoint_id",
+	.is_visible	= ipa_endpoint_id_is_visible,
+	.attrs		= ipa_endpoint_id_attrs,
+};
+
+/* Reuse endpoint ID attributes for the legacy modem endpoint IDs */
+#define MODEM_ATTR(_n, _endpoint_name)					    \
+	static struct dev_ext_attribute dev_attr_modem_ ## _n = {	    \
+		.attr	= __ATTR(_n, 0444, endpoint_id_attr_show, NULL),    \
+		.var	= (void *)(_endpoint_name),			    \
+	}
 
-static DEVICE_ATTR_RO(tx_endpoint_id);
+MODEM_ATTR(rx_endpoint_id, IPA_ENDPOINT_AP_MODEM_RX);
+MODEM_ATTR(tx_endpoint_id, IPA_ENDPOINT_AP_MODEM_TX);
 
 static struct attribute *ipa_modem_attrs[] = {
-	&dev_attr_rx_endpoint_id.attr,
-	&dev_attr_tx_endpoint_id.attr,
-	NULL
+	&dev_attr_modem_rx_endpoint_id.attr.attr,
+	&dev_attr_modem_tx_endpoint_id.attr.attr,
+	NULL,
 };
 
 const struct attribute_group ipa_modem_attribute_group = {
diff --git a/drivers/net/ipa/ipa_sysfs.h b/drivers/net/ipa/ipa_sysfs.h
index b34e5650bf8cd..4a3ffd1e4e3fb 100644
--- a/drivers/net/ipa/ipa_sysfs.h
+++ b/drivers/net/ipa/ipa_sysfs.h
@@ -10,6 +10,7 @@ struct attribute_group;
 
 extern const struct attribute_group ipa_attribute_group;
 extern const struct attribute_group ipa_feature_attribute_group;
+extern const struct attribute_group ipa_endpoint_id_attribute_group;
 extern const struct attribute_group ipa_modem_attribute_group;
 
 #endif /* _IPA_SYSFS_H_ */
-- 
2.34.1

