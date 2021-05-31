Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0716639564E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhEaHkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:40:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60606 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhEaHku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:40:50 -0400
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncVy-00036X-PT
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:39:10 +0000
Received: by mail-wm1-f72.google.com with SMTP id 13-20020a05600c228db029019a69dab6easo418688wmf.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOll6TKQbDWTse8M6wamAPtyvMVGYz69R1ORjx1lV/0=;
        b=tA1n0yViS2KMTsrarhUeekENNNbQnPhCUX23+Hc2nguekbt2Uzx4Fov5lrfwcQY6up
         J6Mz+C35oaEadC5HggQVIpIDTVuTnag7FPANFHIpj1cMPM0S4XpjDTOxnywMfj+zuyww
         3aE309gFRydjsBmCBvGPGedasS+eh7SQPTSxxg071iv1pFMETVhZsruGZ+UzNOqS0jHq
         NWul5fG0uh6XUV8NJTegxUKSt60Yd1febHmz8jM6nHfBf3kyKnXvfmZFFYFt9dXEXU8i
         MsF8nsZ2Md7E2Xr5X1GlrG0qop456bAfDFDBavK3gBNs0dNwbe/6vUm/O5riBNrF65ez
         FANQ==
X-Gm-Message-State: AOAM5323LTWBM0HWWd6KsV75eNzEaUDUfs8bbIPVDB51kBS0y9bgYWts
        o1+xvlcKueXw9exBLTUEMjqung8fKgnwKzZ7au3PKHFpAll9BKCys+cyNFrJbOhoewgeVCNk6nk
        XqXXHLRUL+29kgBX/oXyHiFgHhjjqYI3/Jg==
X-Received: by 2002:a05:600c:2059:: with SMTP id p25mr4703726wmg.56.1622446750584;
        Mon, 31 May 2021 00:39:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsIR56tR1+XGrfQapnZONUGR+r+w7KQN84keiQfNaaA1hDubeRB9qINkqZRXhWIEB3B3hmNA==
X-Received: by 2002:a05:600c:2059:: with SMTP id p25mr4703716wmg.56.1622446750484;
        Mon, 31 May 2021 00:39:10 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a1sm9168911wrg.92.2021.05.31.00.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:39:09 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 05/11] nfc: mrvl: simplify with module_driver
Date:   Mon, 31 May 2021 09:38:56 +0200
Message-Id: <20210531073902.7111-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove standard module init/exit boilerplate with module_driver() which
also annotates the functions with __init.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/uart.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index ed85645eb885..50d86c90b9dd 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -189,23 +189,7 @@ static struct nci_uart nfcmrvl_nci_uart = {
 		.tx_done	= nfcmrvl_nci_uart_tx_done,
 	}
 };
-
-/*
-** Module init
-*/
-
-static int nfcmrvl_uart_init_module(void)
-{
-	return nci_uart_register(&nfcmrvl_nci_uart);
-}
-
-static void nfcmrvl_uart_exit_module(void)
-{
-	nci_uart_unregister(&nfcmrvl_nci_uart);
-}
-
-module_init(nfcmrvl_uart_init_module);
-module_exit(nfcmrvl_uart_exit_module);
+module_driver(nfcmrvl_nci_uart, nci_uart_register, nci_uart_unregister);
 
 MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell NFC-over-UART");
-- 
2.27.0

