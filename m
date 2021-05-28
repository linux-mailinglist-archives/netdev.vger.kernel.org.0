Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6674E3942D5
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhE1MoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42539 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhE1Mn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:58 -0400
Received: from mail-ua1-f69.google.com ([209.85.222.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmboj-00081N-SO
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:21 +0000
Received: by mail-ua1-f69.google.com with SMTP id a8-20020ab03c880000b029020f88f9250bso1826969uax.17
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xi/NsDS4IjaK0xUaurfvCiwF1a8SfsfV6rw+HJ5RS3o=;
        b=ANe9c5GI8K5Q4eqNbPIIqzgjliwiAnf4DOBXKAey0TGNSV4fXkWNM0aNc2XujRdTJT
         qDYCCVrVwFPIGJKbPnnnaVnjt0t7TLkj0MMADWRMd3o9Yu5qe0AbEHQw0Oggm0rcHEZh
         +nUkA1K/hiK0qZ9T7UOIPXXYtNlFa6txW5UVa3DDR32Su6QyfpG5OdN8x+imvgJGMe7g
         RitdaDsQT35zwmsxG7TPKhuL3BmuZIDRlhVIly6g4F9SDqQ+fxEQuzZOWOBZCfkqRcpA
         GfSnW95+y6j96qiRI6ObBSaM2mM7B3DpRzpViOfxDUhwq6sDl8AQhQx8uh5jcMnrIMuw
         Hq3g==
X-Gm-Message-State: AOAM533eneY3z/umW2zaD3/XVO53ZJAWABndtWoK+BR2tfAg1HTdgfGu
        YLgechlu9Yfwo+sTwOlO4Vc4uWe7TB8y2FbQKlfNE+9ars20Z4HgPeTaIoizVlB/N65urXiF3v8
        +rQL6VLgU3zVAVYDWL2sn2DOlura2bhusPw==
X-Received: by 2002:a1f:f84a:: with SMTP id w71mr5977873vkh.4.1622205741008;
        Fri, 28 May 2021 05:42:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnhXTt0JMrjFgz7bxnO/WhpFd/Z/vii9Wwis1Kyx0+9nbuCIwGaLCOgr65EHk25XSkaukBKA==
X-Received: by 2002:a1f:f84a:: with SMTP id w71mr5977858vkh.4.1622205740887;
        Fri, 28 May 2021 05:42:20 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:20 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] nfc: pn544: mark ACPI and OF device ID tables as maybe unused
Date:   Fri, 28 May 2021 08:41:57 -0400
Message-Id: <20210528124200.79655-9-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match either via OF or ACPI ID tables.  If one
configuration is disabled, the table will be unused:

    drivers/nfc/pn544/i2c.c:53:36: warning:
        ‘pn544_hci_i2c_acpi_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn544/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 4ac8cb262559..aac778c5ddd2 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -50,7 +50,7 @@ static const struct i2c_device_id pn544_hci_i2c_id_table[] = {
 
 MODULE_DEVICE_TABLE(i2c, pn544_hci_i2c_id_table);
 
-static const struct acpi_device_id pn544_hci_i2c_acpi_match[] = {
+static const struct acpi_device_id pn544_hci_i2c_acpi_match[] __maybe_unused = {
 	{"NXP5440", 0},
 	{}
 };
@@ -951,7 +951,7 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct of_device_id of_pn544_i2c_match[] = {
+static const struct of_device_id of_pn544_i2c_match[] __maybe_unused = {
 	{ .compatible = "nxp,pn544-i2c", },
 	{},
 };
-- 
2.27.0

