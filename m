Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE5C39777F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhFAQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:09:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49081 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhFAQI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 12:08:59 -0400
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lo6vF-0006pL-1X
        for netdev@vger.kernel.org; Tue, 01 Jun 2021 16:07:17 +0000
Received: by mail-ej1-f69.google.com with SMTP id mp38-20020a1709071b26b02903df8ccd76fbso3535945ejc.23
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 09:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NG5lMIADTn8CON0lTv5ao0jAEzyt4S1tTd5JRxguyoQ=;
        b=YpATAiR9c46zBKy8mPvIdeR7YsYKgY41xxv7SiA2Tyq2wEMXk7XNqNVMQEPGRDbgFl
         JA+wR86reXByvzbM6Luc2AUCevaxyFaJ8meRbLT/WBc5FtRZa60e9N6C2RtiE4yC62WM
         QQ9YlwP9yqszksik1V+QlpZ6sn1rReFfZSKxJ4PFOBDflRfCnktvaz91t5qGIxgQ1CH+
         cz96EXHcNyjYoGquFXrdXO7xrhSIC7nmF3aBfFZ1u3OWZuBfPqKsa7gxq+07UNoZ1X91
         SubFbIpTyIs1yFFAXIwzWCYzLx4Uw7GCB5YKCUjd5li2AkLQ4Yl6/7cwX546t/EmEaVD
         kk/w==
X-Gm-Message-State: AOAM5309IavTQWGPGXzyQXzlRV3ihYLuJfBdqp1gr0igLp1R1/Slio9+
        62r5OGJ9n5zuNFEsxauiF3ObSQigL+cHi/bHbhIDFHC1v/EV4zhyHbZiIdLZSWk3EEkhosqYKIU
        oXZXSmiaTJcKJU80gAUONuI42twZ64dARow==
X-Received: by 2002:aa7:c359:: with SMTP id j25mr32834983edr.171.1622563636773;
        Tue, 01 Jun 2021 09:07:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXuDJan1liufQhFoz7cUP5EJTQ5z9AdgUXI1Nfs/cIJjXy6zEGa76y2xp/KLXolqsq/Wozgw==
X-Received: by 2002:aa7:c359:: with SMTP id j25mr32834972edr.171.1622563636677;
        Tue, 01 Jun 2021 09:07:16 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id dk12sm3382668ejb.84.2021.06.01.09.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 09:07:16 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: mrvl: remove useless "continue" at end of loop
Date:   Tue,  1 Jun 2021 18:07:13 +0200
Message-Id: <20210601160713.312622-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "continue" statement at the end of a for loop does not have an
effect.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bcd563cb556c..433bdc37ba91 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -325,7 +325,6 @@ static int nfcmrvl_probe(struct usb_interface *intf,
 		if (!drv_data->bulk_rx_ep &&
 		    usb_endpoint_is_bulk_in(ep_desc)) {
 			drv_data->bulk_rx_ep = ep_desc;
-			continue;
 		}
 	}
 
-- 
2.27.0

