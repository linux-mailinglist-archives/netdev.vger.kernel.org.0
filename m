Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7093942DA
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhE1Mon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42557 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbhE1MoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:44:02 -0400
Received: from mail-ua1-f69.google.com ([209.85.222.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmboo-00082s-Ln
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:26 +0000
Received: by mail-ua1-f69.google.com with SMTP id p8-20020ab064880000b029023c7d2badf0so1822183uam.18
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVM99Rq9YYpmqFYN93ErdoKv+Sqk4U9Fa7zLEpo/FoQ=;
        b=Yco5q8ewGsxhpVav/DrZFZz4DGoge9fta9HdqYZZA4MRrNzxIBqy+k/KTLVztK5xcK
         PPJiPJwf9EG6aENRn2PogssqG5WsUwDMu1WFlaKLYo6ZWAgYTmkhFV3lDpPV3NiWQPcq
         SQNH0u+yMthLEAX7WGZ5562SapWY3qS+WeTzI4/9QqjFWkVjKVbMdHFiaARXea4NCFoj
         1/EFpzVwEnpHQZ8qMRftYybmLRUGNDh2JSYZQkcK3tpJF0jQxVV5qQBayeeAgONhAXwm
         OTJsMExB0BfkAKuMm5RgZmyiHo4qYReXmHJSZ/8bZRVIUP1ZkUCzqWbbCC0mpnlI670U
         A7cg==
X-Gm-Message-State: AOAM531Dnb/SGGNgfEMF2EYnS21LB42GKm0frmvnniBQze9/WiVJtQtb
        VndfdMpwVWePZ8j0s69a5aeQZ10pqUc4Gc285ObiuEXvfjR0bOBScMLgqwi4HL14xEMrKhD/Cz4
        m9c8j3SXPeOaOmsvgBGIjxcjdemXCukK4jA==
X-Received: by 2002:a1f:eac6:: with SMTP id i189mr6094873vkh.3.1622205745857;
        Fri, 28 May 2021 05:42:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI4pXCt8bne0kZBifLt5Y1FotnUnE0PxhwFaZQXgWqXhUGHZi56pmTBuAwfHxymwdgrabXfQ==
X-Received: by 2002:a1f:eac6:: with SMTP id i189mr6094860vkh.3.1622205745730;
        Fri, 28 May 2021 05:42:25 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:25 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] nfc: st95hf: mark ACPI and OF device ID tables as maybe unused
Date:   Fri, 28 May 2021 08:42:00 -0400
Message-Id: <20210528124200.79655-12-krzysztof.kozlowski@canonical.com>
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

    drivers/nfc/st95hf/core.c:1059:34: warning:
        ‘st95hf_spi_of_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 88924be8decb..0d99181b6ce3 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1056,7 +1056,7 @@ static const struct spi_device_id st95hf_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, st95hf_id);
 
-static const struct of_device_id st95hf_spi_of_match[] = {
+static const struct of_device_id st95hf_spi_of_match[] __maybe_unused = {
         { .compatible = "st,st95hf" },
         { },
 };
-- 
2.27.0

