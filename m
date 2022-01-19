Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43EE4935D6
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352226AbiASHxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:53:12 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:38520
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352204AbiASHxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:53:10 -0500
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DCF023F1E0
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578788;
        bh=15HOmnObJXsVXxZJ5x/3DtxcDfRhMgZoa5zrHrITnNA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MAf5F86XF4ZDlFIaJHfEwZPi9O9GLhPFwijdr8dFbdlCI6At0Iuh5MYpOKXrO0myS
         0W//fbv3PiKD4GgINkDidqVMvg7pHIW+ze1rUbuH8498DoHexdPgDJJWlJKAPYuRso
         Ia4otCe5zbgRsmX2M+TMNuaKacxNsp5GaZSdP11ljnSATR2H1Thsp/uq60o89faYKi
         epbBgs/jbKysua3GBNTIc//zZs1Hi1sZ/bV5ueOQjSonxKAQC2+70sHRdtYSlITGPR
         VzWy/FtuVWq7z/etstKB8OQTlDpZ6FP+rHIaElbUUP6JF9wKHgsW6Ow7xXOdDo9bpr
         uj6V1tLXCT/sA==
Received: by mail-ed1-f70.google.com with SMTP id t11-20020aa7d70b000000b004017521782dso1448545edq.19
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:53:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=15HOmnObJXsVXxZJ5x/3DtxcDfRhMgZoa5zrHrITnNA=;
        b=dCJlhk3lP2smJChY4JH8SB301f+WK9Uy3Y/yyV6Gwc+cLjRWaEjqz/ugufCprEmHWU
         Fq6PGVKdWsi6kHTeT/OjlqfJAjAhrVGShlJtexHeIu56yp5aqIm5lnNLQzt6wlKol9cz
         IqaOi63SkW1peDTJ/9PHvhmrwWjNlPeHlA8M2D7V6p9w3THJwvKrpi8BYn4+djJtYPrV
         rQGWzFANPl4i8taaOtz7feMZD/7/xHr6fNJpYtKk4vLuXGGWUZLs4eox8wWHBHTBZoPK
         Hk5OZNDwj2Al2e0lKDsjciyLSkZYmpLZwFIC2ZxPKkFoDvxF2f1XFPLAqPjiQYquG9CU
         iZUw==
X-Gm-Message-State: AOAM533I/5VKYkFtsAPjkBQJk80LDiXfaPS6IW3ywI/v3JJiWpjGC1wD
        w4cW/Liy9NYp1efhhwqi9ZgpocwNaafCxMc+jTgqGY01Zd2gnb5kMMl0vAjuY6h/AvCutxMOJIF
        mk46EmwD36W5voORR+FjWaOunNF3d81RA2w==
X-Received: by 2002:a17:906:314f:: with SMTP id e15mr24089114eje.658.1642578788655;
        Tue, 18 Jan 2022 23:53:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvebYbkc+sDSvj+IhZAZlbGMQ8r2BM5qm9B1lRUqpsvTkhNAMQvZayhml1fBn9wG0q6LpOgQ==
X-Received: by 2002:a17:906:314f:: with SMTP id e15mr24089106eje.658.1642578788503;
        Tue, 18 Jan 2022 23:53:08 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id w17sm805286edr.68.2022.01.18.23.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:53:08 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] nfc: llcp: use test_bit()
Date:   Wed, 19 Jan 2022 08:52:59 +0100
Message-Id: <20220119075301.7346-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
References: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use test_bit() instead of open-coding it, just like in other places
touching the bitmap.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 5ad5157aa9c5..b70d5042bf74 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -383,7 +383,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 			pr_debug("WKS %d\n", ssap);
 
 			/* This is a WKS, let's check if it's free */
-			if (local->local_wks & BIT(ssap)) {
+			if (test_bit(ssap, &local->local_wks)) {
 				mutex_unlock(&local->sdp_lock);
 
 				return LLCP_SAP_MAX;
-- 
2.32.0

