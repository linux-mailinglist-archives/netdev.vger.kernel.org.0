Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04A04EEA84
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344630AbiDAJiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbiDAJhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:37:51 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD17E70076;
        Fri,  1 Apr 2022 02:36:01 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b15so2277241edn.4;
        Fri, 01 Apr 2022 02:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ChGEZUwxXxDaxj8jm+DIh6cj4fnGyQfICbK1J0+U1A=;
        b=A79tAmggU6JmNIp++HoBgOXDsNrdEeRfooo06Q9jn6t8L6yNWZnqfVu1PaCIjTQoBp
         DzwmeugkPVJRZB3qJkgXPzXTo3xHlzOKRIrBAugCtPH2OeMgiRwm5TjKvUeaoTdQ3/fW
         SKsd6bEkme+qYIloK5jD6YrUvRkB0Znzh6P9jikVjiVPl0IC2dXD8oYs51Kdj/HOVA3l
         WUXJYypZaYU+TL5i7lZSRGSjOjxdwARAyXfM1iOqUoNLuQFNCyHUjt8TAQAgU7z0Tn8a
         OjZ0UwHV8RpxjHpeCh8gp7G1VNzAH8cFa5PhJJuXStogSZ5v5BBzL2PVWFyXJTNECFHr
         W1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ChGEZUwxXxDaxj8jm+DIh6cj4fnGyQfICbK1J0+U1A=;
        b=b+qpZEdmPFIW/JOmlyL7061oyG85WBQIAzJwSWaUmJYdkDfIn0FluzqVQoEb5nunOn
         UaGbXe4DcfYsPnjua5qmfK8H589RKKicK+hid1kAGTSkEi/YMXeesaFnGlil6wq4gFIs
         9FiVg5saI8P7gEvNz+v/tmmDq4GrOynhXnXVRZvq2zFUKyvADYtU1Qvev6N4QPbib+B3
         0aIBZqS8tGrhoCb4+UP2chU5KkrGFSDOY3Pmuaieoy0AvfW7IJaipsskWtDN+L90JaF2
         Te9G2QOYy1n7vces2SApXz3k68TuLiafp75ThLqWMLwwh4sLnJQYsmO2SXT+ZGLF9OVT
         n4gA==
X-Gm-Message-State: AOAM530h4N1v6EeQYDQFnwlKieRJZtTtv2k7wn46l0dVFczkGreMeL2H
        exqiZIPWNI2fddThu4s6DcA=
X-Google-Smtp-Source: ABdhPJzm8mxDWrntuztPp6BZheOhHfWdwWCsOOS/sgETBckm+VbxonZQWm4VIVX0DmXmctv3+WAfhg==
X-Received: by 2002:a05:6402:2805:b0:41b:630b:de68 with SMTP id h5-20020a056402280500b0041b630bde68mr12946845ede.143.1648805760217;
        Fri, 01 Apr 2022 02:36:00 -0700 (PDT)
Received: from fedora.robimarko.hr ([88.207.4.27])
        by smtp.googlemail.com with ESMTPSA id v17-20020a17090651d100b006dfa26428bcsm831460ejk.108.2022.04.01.02.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 02:35:59 -0700 (PDT)
From:   Robert Marko <robimarko@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH] ath11k: select QRTR for AHB as well
Date:   Fri,  1 Apr 2022 11:35:54 +0200
Message-Id: <20220401093554.360211-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ath11k only selects QRTR if ath11k PCI is selected, however
AHB support requires QRTR, more precisely QRTR_SMD because it is using
QMI as well which in turn uses QRTR.

Without QRTR_SMD AHB does not work, so select QRTR in ATH11K and then
select QRTR_SMD for ATH11K_AHB and QRTR_MHI for ATH11K_PCI.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 drivers/net/wireless/ath/ath11k/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index ad5cc6cac05b..b45baad184f6 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -5,6 +5,7 @@ config ATH11K
 	depends on CRYPTO_MICHAEL_MIC
 	select ATH_COMMON
 	select QCOM_QMI_HELPERS
+	select QRTR
 	help
 	  This module adds support for Qualcomm Technologies 802.11ax family of
 	  chipsets.
@@ -15,6 +16,7 @@ config ATH11K_AHB
 	tristate "Atheros ath11k AHB support"
 	depends on ATH11K
 	depends on REMOTEPROC
+	select QRTR_SMD
 	help
 	  This module adds support for AHB bus
 
@@ -22,7 +24,6 @@ config ATH11K_PCI
 	tristate "Atheros ath11k PCI support"
 	depends on ATH11K && PCI
 	select MHI_BUS
-	select QRTR
 	select QRTR_MHI
 	help
 	  This module adds support for PCIE bus
-- 
2.35.1

