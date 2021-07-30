Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF7E3DB412
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhG3G5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:57:10 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39426
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237760AbhG3G5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:57:04 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 096BF3F239
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627628219;
        bh=TbQaBsPvgLCz2s8QzntY35xkR7Vmp0dFUIMeahF8LO0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=KpE3tOYdra3jQ0zExyHu2xas7k129JzmhvY8vtsqZiynRRWRFwZ9998sZoYedrF4E
         UF7DoC91AIbAZr8/uyeB3fnoG9+SGw3SoyzYqraUA8/Y+lR3sJO9+kVCdSXVXzQW6c
         fscqHQfl01TFVU0/QYm0aCSgbTaWtl1aovqbIQ+zj+R9WSA8DnKi8fTZWrSvs5t7Uy
         YJCTxiwwscJXuTlndjdxStbZFFhKi7k01JTyEquF427zsSyqPB57EV9c1+zk99V/6P
         hsg9G67yDyZfPJwSxDk55Xqo2SDu39mhyW7SxoMjHdZ/QCpS6To/Z+XO8e4As099hp
         ED4Wb2uuxMiEg==
Received: by mail-ej1-f72.google.com with SMTP id q19-20020a1709064cd3b02904c5f93c0124so2747550ejt.14
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TbQaBsPvgLCz2s8QzntY35xkR7Vmp0dFUIMeahF8LO0=;
        b=UBvJGnPMQJtoeg5AXmmElV08W64kWyq5gmwkMgsU1Kv06d6ZcwKw3PXCFf7Xe1LUBf
         HQVC1ZTnjYt5JvEOMO7jZ8XtrkmQA5kTWJXLjNDhz19491EZsxXYIS0CjEaRXxBqdkij
         114IpZYfnEz5vU2+lQrkYpQXy1YooFOcjOV91zuDF1QPUxDIpcxdh/Gu3wDacNFZMQyy
         Ey+d6L/clU7MhrssKpiAY90D0axF0q1NR2G5AOVKTx/AkhzRjzz253FA3zBrtTgK833o
         PzO78q0MI7V535vE8mX1rIegbOoa5XqeGUAB3M4Uze+T/SW+g7DeeDn1MySy2YTGSkOj
         0uvQ==
X-Gm-Message-State: AOAM533HmJE5ROPCxdfZ4ngpYBYJdMSwmK3NYQpQtC5EYGwiavjLN1XE
        T2c1NL3lVAi/wIXgox9wluS1MBJTSYb3FT8luV9dZcW1db2YQoGedmroqvQM7CfhQPKF01EOOqO
        Bb9vPj/LWebWK402mmunmHCiLIHK2buWihg==
X-Received: by 2002:a17:906:64a:: with SMTP id t10mr1154570ejb.5.1627628218760;
        Thu, 29 Jul 2021 23:56:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI5Moy+lzXah0p5kqppWeDxC9Ku21TZrEo9wjHh0ArN5Ek2tQ+rZnuddmWcBRskAlMTzDs9Q==
X-Received: by 2002:a17:906:64a:: with SMTP id t10mr1154557ejb.5.1627628218647;
        Thu, 29 Jul 2021 23:56:58 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id m9sm238518ejn.91.2021.07.29.23.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 23:56:58 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] nfc: annotate af_nfc_exit() as __exit
Date:   Fri, 30 Jul 2021 08:56:19 +0200
Message-Id: <20210730065625.34010-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The af_nfc_exit() is used only in other __exit annotated context
(nfc_exit()).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/af_nfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
index 4a9e72073564..6024fad905ff 100644
--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -79,7 +79,7 @@ int __init af_nfc_init(void)
 	return sock_register(&nfc_sock_family_ops);
 }
 
-void af_nfc_exit(void)
+void __exit af_nfc_exit(void)
 {
 	sock_unregister(PF_NFC);
 }
-- 
2.27.0

