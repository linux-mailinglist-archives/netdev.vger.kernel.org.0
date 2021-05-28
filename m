Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC02394499
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhE1O6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:58:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47144 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbhE1O56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:57:58 -0400
Received: from mail-ua1-f69.google.com ([209.85.222.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmduQ-0004Am-Oz
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:56:22 +0000
Received: by mail-ua1-f69.google.com with SMTP id t19-20020ab021530000b029020bc458f62fso1993460ual.20
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOll6TKQbDWTse8M6wamAPtyvMVGYz69R1ORjx1lV/0=;
        b=QPfhT3vI9ni5+Str38+iMfad+tU272Gf7sS/m8vteF2CwSWELQPpM3qSeSeQU5464+
         042LsYpweTZKbKmQ13L0x3Q/9zZiDx/RbWgjyyB2w9aXlkumUietX6d8ZHGDTexAsKqU
         G+HgERrc4wGeDBlKHkDXSEk7VwVb35xHLmUgwwmIwHzVGAjZgNyEqAVR4zPqDLirET7b
         NZyYulf8bzFtROTYCtMaLfLQrYHJrOeOURCLefNqMecS8Sd29wBxMTJ2oTENbN9tBh8w
         AxNqo8ynnRR428wjNly0Lc5+kj3dJKry3UwuNQpuw3q9+4gIdWE6xkyK4f8krtGdZlUR
         sREA==
X-Gm-Message-State: AOAM5328JF1I61e/fNkMvGD73p48degwRODSqSa/35DANkT0ku/BBTod
        IhYP0aIRWghHojh1po6kMgWSMvMFfi9w8dnqa0vIGyY7q933WncbOYZvXaJty2M3as/AHDY/Uz2
        Nmjy7GXwHoxQdb4TgU8jQqYgldIdryXvSew==
X-Received: by 2002:a1f:a910:: with SMTP id s16mr6919064vke.10.1622213781948;
        Fri, 28 May 2021 07:56:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4AhxZK2XYM4OiqRRBIBQMjJThDP+GKPg/Kb1XvgWUz6kwSBd+aWgoZQ6H46zZdH9u+CAu3w==
X-Received: by 2002:a1f:a910:: with SMTP id s16mr6919045vke.10.1622213781776;
        Fri, 28 May 2021 07:56:21 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id c15sm743661vko.15.2021.05.28.07.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:56:21 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 05/11] nfc: mrvl: simplify with module_driver
Date:   Fri, 28 May 2021 10:55:28 -0400
Message-Id: <20210528145534.125460-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
 <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
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

