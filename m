Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868943F774C
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbhHYO0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:26:40 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60328
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241575AbhHYO0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 10:26:35 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D5E523F04D
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629901545;
        bh=lRHNkLEWcITIq9BTwsdkr00e4mkdm7zBYjY+jga9Eao=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=OoISX0ERoKQZ7B1Q+Yp4HmqxIkrmYGKP/+xgI7lW3MduEHC1geDz24nFpD0axcFOc
         +4krb4SCtdRmDrvduCukA1l34ye53LYZWPOrggvvcImvbD+g8TJ6mZNDE0aF/5rHfx
         RUn12jBcMRPxRDqruGDFPWpHR1t5uFkLCi3kjnJsWowImJE7d8mCSG0AQYeWV9HS7j
         ufmTsuIMJSjxz0xMoO+IooL6Iv6HeeYRY0kXRBI/gdadQnbqpyEZgwwqfn9Wi0C7DM
         qSefXQXWXLC/Xsu+7P5aK+Df1akLQHSj8XwTvuFueStlzUSRMHKvl6LHz5gt64UYl3
         rHYhChndqMDzg==
Received: by mail-wm1-f72.google.com with SMTP id g3-20020a1c2003000000b002e751c4f439so2902338wmg.7
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 07:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lRHNkLEWcITIq9BTwsdkr00e4mkdm7zBYjY+jga9Eao=;
        b=nMq9XzmIVl0/WgSTrI2kS5rpAhG8YQbeA7+PwytTuI0ZPeWbtbQ58V8mC7tr9geTeI
         Cm2YoFAy8WUcLe+of4AM9kjihaisJSznRJ0GHqqTD+yEsUv/Z4kx6Odg2XOW9LPD22U9
         dZ4zX0zeX+bnBMe5kQKme4tEyrk7YSyA6pgcmZ9Hc678OM3p01ktDZ5i46g0eG8a6tdp
         ARr5yOvYy9qwlpPcRpaobz6Tn5eJixBF/L9TUli5/eM9ZPb8BeWE4enEwrsFlH9A/NXX
         luZbPXxvT6Hhw5UfqDdDKKgHAb4KABYqb8TL/IX63evft0oYqps5d/tzc0YUXpZbElgr
         gMBg==
X-Gm-Message-State: AOAM532s2eCr+A7RepdV89+izrYeRIq7CdKC7ypcvp08HrGyugaM1KRk
        GUQRC0QKqzbbHwVenuN/auyoHzorjCKGhQPCsWrTblk3Yax+5mK/DVh4VMlJv53jM8WHTmzGS7B
        WJaOzrvvd/4lGF4PizANZlSEd/70/delYRQ==
X-Received: by 2002:adf:c506:: with SMTP id q6mr2585029wrf.78.1629901545222;
        Wed, 25 Aug 2021 07:25:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9h6tV76fJDoGPVoO6pO3iRtwkAZF73BAzecjKNib/5DLYsyj/NjVU59vWpxchWluq9DoRhQ==
X-Received: by 2002:adf:c506:: with SMTP id q6mr2585022wrf.78.1629901545111;
        Wed, 25 Aug 2021 07:25:45 -0700 (PDT)
Received: from localhost.localdomain ([79.98.113.233])
        by smtp.gmail.com with ESMTPSA id i68sm60375wri.26.2021.08.25.07.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 07:25:44 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] nfc: st-nci: remove unused header includes
Date:   Wed, 25 Aug 2021 16:24:57 +0200
Message-Id: <20210825142459.226168-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825142459.226168-1-krzysztof.kozlowski@canonical.com>
References: <20210825142459.226168-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not include unnecessary headers.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st-nci/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nfc/st-nci/core.c b/drivers/nfc/st-nci/core.c
index 72bb51efdf9c..a367136d4330 100644
--- a/drivers/nfc/st-nci/core.c
+++ b/drivers/nfc/st-nci/core.c
@@ -9,8 +9,6 @@
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
 #include <net/nfc/nci_core.h>
-#include <linux/gpio.h>
-#include <linux/delay.h>
 
 #include "st-nci.h"
 
-- 
2.30.2

