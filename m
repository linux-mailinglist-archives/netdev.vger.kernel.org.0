Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5756A57A17A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiGSO2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237829AbiGSO1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:27:44 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B45A47BB1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:14:32 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id x64so3512755iof.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pkt2mZa+r6CsVBvHdxfl9ZtYgfYBiGtwJR0TyBmBn2k=;
        b=SlzhZyt9l+GNXk4dk//RRG6m0fZZEzA7Cl4rmeOvfS+69bthJYXVogYlM3UbfRFlGJ
         FpW3W361WFdTPhlrtyjkLorAsasxSCrmJMdm4eIvabjLg+adPIAhC4lCzyJ5/RygPjQ5
         BOtavsMGUl4fiP7eIe6BpaIXPhje757ZYr2pqHzz6Lw62+qvOihvU0hbg/uvSW1QaBE1
         5wEggFBvpbLJZ5VmG6iAhZsoCMb/2oS1yZGMdcdUMoYrJfyA0iFykIGZBz7RPy4oj/KK
         O7T6PBOCXChw5yAzd0b7MYzo2xAt6r6aLu65XR59PvTL3a+Q83cg+rXA8975vw32XSkm
         0bmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pkt2mZa+r6CsVBvHdxfl9ZtYgfYBiGtwJR0TyBmBn2k=;
        b=lzQQlCUYvVoe5koji7troy/WHcBjlhUtzWFEv23g0/7ifiCNYFgktI3aidR1vVkORd
         Zds73TeH5FFWaqkG9VZ0xYXzW06sME/8UxNdrOsukv0Mx99tYy0bhtLzbQReinF3VavD
         CFu6lqfIdUCSVF9gB4YL1batlrfL+MpNUIIqQxp0dRJeN0SbGt+ofvsjNPYbWHBSCwsj
         qn67Ycj2NF20Ym5coGKZGBvFQn0+wwG+XFHJlKrVp1pEywZpYRQ4td3evwyVFg9qCibS
         XvSCMnzcmVauyjbs3nVttHLDeIZC88qn9gFcrjP57t/yaaD2/431VZ+iapSTRYkpG165
         U4vQ==
X-Gm-Message-State: AJIora9z/dZ6hCnT69qcxdRKIPpqadlXGMmMMy+/WlubUyYf+W+5luTU
        s383tn8i7HFozFw5OFMaNoPsPw==
X-Google-Smtp-Source: AGRyM1ssez9DZVLlBwQkrRccXEisCNfk4Fizssx9NwajhOtCz64G7Q7uywGs7C+r27zJgLBtjQQU0Q==
X-Received: by 2002:a05:6602:2e8e:b0:669:d5b1:3fc9 with SMTP id m14-20020a0566022e8e00b00669d5b13fc9mr15406444iow.210.1658240071485;
        Tue, 19 Jul 2022 07:14:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g7-20020a05663816c700b00335d7c314b1sm6727565jat.53.2022.07.19.07.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:14:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: add an endpoint device attribute group
Date:   Tue, 19 Jul 2022 09:14:28 -0500
Message-Id: <20220719141428.233047-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index ff61dbdd70d8c..747920a23b2b7 100644
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
+	visible = !!ipa->name_map[(enum ipa_endpoint_name)ea->var];
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
+	endpoint = ipa->name_map[(enum ipa_endpoint_name)ea->var];
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

