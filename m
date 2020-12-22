Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C822E1035
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgLVW13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgLVW12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:27:28 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C41C0617A6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:26:47 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cw27so14410918edb.5
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+vI7Qef9+dDo+XRwNutLperij3ly1vr+J52u8L8xzA=;
        b=Ff9HwE57+cMeQM+fNeqX4Wh2iByWCdOfYUS33Kwilpcmbk0pFcvcKzXVfohfi/icxh
         H5aj9um6IRHDOrQvSsBhm7tIhWP+4Daz8jvV6IvtjuiCk8axWlHTGNge7TfLDDteNq3k
         whfbqn2Kjm7JsfxYCtf0ATDoQeosl0mRz9kasgOkreYPIVMti8gKY3cTrXLDn/rumNIW
         24zgDfG/0t9MtIIXAdGVrVFP1FLEMGMfMzzB+YrC7Ho5qDPThibP5k/FF5KjCxGgiGcq
         v/iJNTI1pCBIeTs7SNp+YYxLxgp7rtHNIdK8nx6Qa7dcBUxlN3Y7RHcYRamyhv6UCVyB
         lxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+vI7Qef9+dDo+XRwNutLperij3ly1vr+J52u8L8xzA=;
        b=AB2qbkaflarhUJcozJC2YZfm4lz1uuqAHjRq1XVxPPL9ns0135z8Q7YlvWvk1iHupD
         D+WwfzOpLb/A3pFbKWbqMBTzzBbRkS1ouxPwuSF1PU0wgUgBL5sToc2pEWTtPrwIKbuY
         WTLuyWQxaSStdjVHjuxh7ild9xKN6HsDEWBrkRPIB3fvR7yHenbC3HGdN/XusAfDWKSd
         RQW6cXfY9cgrPmki86S9//OsLj+8Ocbyj/yeCtcaHsTUHAqitKLpj0GzpyQ2HlWeaDFl
         NOXbvBKhCrMuYwbO3mgBY3SS+5QhAs7pKmW3y6dqqKn29sXN4RIfVt6gsKNkAVfopnVS
         rsyA==
X-Gm-Message-State: AOAM532p3PdZCN6Ad5W3TBN+BSVyE/OECNLLIjvJJNVliREXU1VuXr3M
        oAP5kSX8lTG268Fk2czvXY2uiw==
X-Google-Smtp-Source: ABdhPJyutMmjKfOXGXU+JPjG/69cbwdJW5hH8NApW6mEaFzxtGMEJYKeDwT5VwwmApbjCoeLboJe3w==
X-Received: by 2002:a05:6402:379:: with SMTP id s25mr22993516edw.367.1608676006079;
        Tue, 22 Dec 2020 14:26:46 -0800 (PST)
Received: from localhost.localdomain (dh207-99-167.xnet.hr. [88.207.99.167])
        by smtp.googlemail.com with ESMTPSA id c23sm30515385eds.88.2020.12.22.14.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 14:26:45 -0800 (PST)
From:   Robert Marko <robert.marko@sartura.hr>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH 1/4] dt-bindings: net: Add QCA807x PHY
Date:   Tue, 22 Dec 2020 23:26:34 +0100
Message-Id: <20201222222637.3204929-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201222222637.3204929-1-robert.marko@sartura.hr>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT bindings for Qualcomm QCA807x PHY series.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
 include/dt-bindings/net/qcom-qca807x.h | 45 ++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 include/dt-bindings/net/qcom-qca807x.h

diff --git a/include/dt-bindings/net/qcom-qca807x.h b/include/dt-bindings/net/qcom-qca807x.h
new file mode 100644
index 000000000000..b341e62f5fb6
--- /dev/null
+++ b/include/dt-bindings/net/qcom-qca807x.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Device Tree constants for the Qualcomm QCA807X PHYs
+ */
+
+#ifndef _DT_BINDINGS_QCOM_QCA807X_H
+#define _DT_BINDINGS_QCOM_QCA807X_H
+
+#define PSGMII_QSGMII_TX_DRIVER_140MV	0
+#define PSGMII_QSGMII_TX_DRIVER_160MV	1
+#define PSGMII_QSGMII_TX_DRIVER_180MV	2
+#define PSGMII_QSGMII_TX_DRIVER_200MV	3
+#define PSGMII_QSGMII_TX_DRIVER_220MV	4
+#define PSGMII_QSGMII_TX_DRIVER_240MV	5
+#define PSGMII_QSGMII_TX_DRIVER_260MV	6
+#define PSGMII_QSGMII_TX_DRIVER_280MV	7
+#define PSGMII_QSGMII_TX_DRIVER_300MV	8
+#define PSGMII_QSGMII_TX_DRIVER_320MV	9
+#define PSGMII_QSGMII_TX_DRIVER_400MV	10
+#define PSGMII_QSGMII_TX_DRIVER_500MV	11
+/* Default value */
+#define PSGMII_QSGMII_TX_DRIVER_600MV	12
+
+/* Full amplitude, full bias current */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_BIAS		0
+/* Amplitude follow DSP (amplitude is adjusted based on cable length), half bias current */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_HALF_BIAS		1
+/* Full amplitude, bias current follow DSP (bias current is adjusted based on cable length) */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_DSP_BIAS		2
+/* Both amplitude and bias current follow DSP */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_BIAS		3
+/* Full amplitude, half bias current */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_HALF_BIAS		4
+/* Amplitude follow DSP setting; 1/4 bias current when cable<10m,
+ * otherwise half bias current
+ */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_QUARTER_BIAS	5
+/* Full amplitude; same bias current setting with “010” and “011”,
+ * but half more bias is reduced when cable <10m
+ */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_HALF_BIAS_SHORT	6
+/* Amplitude follow DSP; same bias current setting with “110”, default value */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_HALF_BIAS_SHORT	7
+
+#endif
-- 
2.29.2

