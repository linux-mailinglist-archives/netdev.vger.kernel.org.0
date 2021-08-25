Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1003F7747
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbhHYO0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:26:36 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37570
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241563AbhHYO0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 10:26:35 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3CC3F407A8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629901548;
        bh=75IyrXuKwrcLVvdo4qEJ0WJWV94tMbWLl7mt5kzUBCE=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MENpSEqAJaHaS/qDCpXN34NTkNYO4QeQYYfkjKwm/nFtJ2vjfF7OlG9hWepbxEn7F
         owMuPNj/ENK2TB/YMfvci4aFKMH2fp9cTORh3EF6Ys75zXO9E8Eh8CJlEHZdg1xH0u
         kD3hcrVemaKZRHFg4Y924p1SylcCc+WsjfCWNLcYTNOroP5MzPAK5JVknfM1guWWWj
         PlizWzuykQkSj+KxUd8BS/zKX4lTCO+0V4O4puNJNeirjl6E0L73Rt+AoTdPdOmQrc
         rKPq2A80Rgx+QDxd4qPT0tuwwdvAPVWeFzVlzDm+bySOD+5xvcIhAZAM9F1v+2uQX9
         ji/yxcjezuWKQ==
Received: by mail-wm1-f70.google.com with SMTP id y188-20020a1c7dc5000000b002e80e0b2f87so2923548wmc.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 07:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75IyrXuKwrcLVvdo4qEJ0WJWV94tMbWLl7mt5kzUBCE=;
        b=IQwNPMICR/Qs+etTBqSuFkQfEm2A5pOg4ZT1Syry7uCxeyfmWbS4s75ezbaqNmOEsq
         /6a9cP7pogoKqsxT1+cMpNjsF6E5QfbBg9i/vxn66ZXfQgS4+7PUSMDray3pKVMHt1lY
         4Ce1SOk2vvFVtQHTnMYerMUNQuPTaJcfRRaYdZ73Z8lSOH+uKykHCoa2fCF0CU+pbMUt
         3XqOMnJHCrO0egESVZDKYh1jO1I/n1kfLlE3JopehxcAKzA2gq59D3uoKO7T+YWlIawI
         YYHn9zFYOV6st/PMzYeBKrbZxHwUbWtf9toOgfsUspR1zExFcgvK4NzTkC7CKsS53c2I
         Nl+g==
X-Gm-Message-State: AOAM533uOpYYgn2sO8LLu4efMpGU8LMYFnEfZz1Gu6gD+EG+C+t6+4cF
        /5J6s4OeoTr0eXO5Orf0jlZW0RFMwb3ScA8ETSGUA4RmfinKIQ7So8l11Bx9ejK19v6TLUpyjt9
        wW7Gzfp0M248qbq84At9kLK/Oj016tATAnA==
X-Received: by 2002:adf:e101:: with SMTP id t1mr25641188wrz.215.1629901548039;
        Wed, 25 Aug 2021 07:25:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0xFoz9LuF8pcrbV+A+y5xF/azh985EmDuG0RjLG0TyeZyGUZLIjZGjkNM/EhFi2oiQQqyHQ==
X-Received: by 2002:adf:e101:: with SMTP id t1mr25641170wrz.215.1629901547865;
        Wed, 25 Aug 2021 07:25:47 -0700 (PDT)
Received: from localhost.localdomain ([79.98.113.233])
        by smtp.gmail.com with ESMTPSA id i68sm60375wri.26.2021.08.25.07.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 07:25:47 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] nfc: st95hf: remove unused header includes
Date:   Wed, 25 Aug 2021 16:24:59 +0200
Message-Id: <20210825142459.226168-6-krzysztof.kozlowski@canonical.com>
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
 drivers/nfc/st95hf/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 993818742570..d16cf3ff644e 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -16,7 +16,6 @@
 #include <linux/nfc.h>
 #include <linux/of_gpio.h>
 #include <linux/of.h>
-#include <linux/of_irq.h>
 #include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/wait.h>
-- 
2.30.2

