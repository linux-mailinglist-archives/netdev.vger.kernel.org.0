Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5B43942CC
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbhE1MoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42504 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbhE1Mnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:50 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmbod-0007yK-Ce
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:15 +0000
Received: by mail-ua1-f72.google.com with SMTP id y10-20020ab025ca0000b0290221adb2995aso1858762uan.8
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lw36VrwBWml7IzR1JdzowLQpX/jCNNF5gFQShdOaSgY=;
        b=EZ1Pedwbpdo2iqXCadJakeSDpqU/ebXsOXRz4nqj3lJvhsLJZSRAZ+uRNYFJJw/diw
         jXpVgTJCMJvBMqWvQuo9fd7R+tGPg3b33+uZYWz6s4RGsHBVftbn4n2qmM7CuWm+2gUn
         nfjcaOD/cgbQaGY8OvXgRK2Jqh2MjjTqjy9wpSnFj/XXWQgI34KhXZ245qYXif3R3OBF
         a3dFk4v8QM2L8U3seDm8nH2AguwS3gbYK0yzLaORV2jJuA2KCb7GwaQpdMtn1IVlx6vE
         hbd+Usb1+P3TNi4IKH8X/BuDpgZomSRVWS4pGCxpWBORS28O8FJOF1idnsb+aU5N7po9
         qhmg==
X-Gm-Message-State: AOAM532xgAE43fRTu/S8veUPjcAcu3ALQcGt1AR2dXMU+4Zv6SRNfvjV
        orLoyfL6fWIo1+84yOKoMqFh2dDICDRjncdoiXKztpSE7khMfu+cSkGY4H/2aMAhEhy4wlCjlNj
        eip7VrLbLMWd68NNpD0lmEDNIhK9rXug7zw==
X-Received: by 2002:a05:6102:512:: with SMTP id l18mr6715752vsa.33.1622205734511;
        Fri, 28 May 2021 05:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygSs9E1/NeULXJxJsESzmza338EBoj5njw0AYG2NAKnqAxU1H4XWuGjP0/bg2APuzVmtRxrQ==
X-Received: by 2002:a05:6102:512:: with SMTP id l18mr6715730vsa.33.1622205734327;
        Fri, 28 May 2021 05:42:14 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:13 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] nfc: mrvl: mark OF device ID tables as maybe unused
Date:   Fri, 28 May 2021 08:41:53 -0400
Message-Id: <20210528124200.79655-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match either via OF or I2C ID tables.  If OF is disabled,
the table will be unused:

    drivers/nfc/nfcmrvl/spi.c:199:34: warning:
        ‘of_nfcmrvl_spi_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/i2c.c | 2 +-
 drivers/nfc/nfcmrvl/spi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index c5420616b7bc..bafd9b500b2c 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -260,7 +260,7 @@ static int nfcmrvl_i2c_remove(struct i2c_client *client)
 }
 
 
-static const struct of_device_id of_nfcmrvl_i2c_match[] = {
+static const struct of_device_id of_nfcmrvl_i2c_match[] __maybe_unused = {
 	{ .compatible = "marvell,nfc-i2c", },
 	{},
 };
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index dec0d3eb3648..0647b85930a6 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -196,7 +196,7 @@ static int nfcmrvl_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
-static const struct of_device_id of_nfcmrvl_spi_match[] = {
+static const struct of_device_id of_nfcmrvl_spi_match[] __maybe_unused = {
 	{ .compatible = "marvell,nfc-spi", },
 	{},
 };
-- 
2.27.0

