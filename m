Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E1043993A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhJYOwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:52:35 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37768
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233628AbhJYOwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:52:13 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 82BED3FFFE
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635173390;
        bh=KricW4D7VolKL3JPfDUExtQxStN8Nau+m8lKmFDnDuQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=f8KTU5sgHG/SgF5CRj6zA5LjHshGBwrZM3hY3wUp6wuK76W67OpsV82HUbW8UZ2Xa
         H7lqO2odLSOcjEw4F/bFT/eE1WYLR5pArXz46UxoyI9EmIEOi5mS7F0woS0qSzsOgB
         hoAWspch+Sl62NaSv+DuARGSpSrG3q651WZI759Y6dn64SGq4SJ6L2sbbJf1cSO62G
         NAOGHNfIvd5LwLPaIsdF6bPCd9C8Xx32LcR6EhRvFmpwikec6OUchk9+rSLYHHwSiN
         dUGPYsF4Hq8Df4k8wft0Z3BoUDI9XUgHwv3UHEYO7DveIUOz7JkFMZwJ173nuioI02
         svBfQjkLKl8xg==
Received: by mail-lf1-f69.google.com with SMTP id g10-20020a05651222ca00b003fda3f05c17so5323022lfu.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KricW4D7VolKL3JPfDUExtQxStN8Nau+m8lKmFDnDuQ=;
        b=64FjKfKvIYRBi1yo5pwb9SYEWMENFNr0V8NorkUt47eqNTK2hCrF20fJDxwNV+BpJ1
         fjPwfi2DI7RK1kwRpjLst7TKcUWe6TSTVg4N12Lm0gwRvEosqR/ZZRaiMzzUa+dG3SNw
         xRnu13d5eOsTGWJQ6iTKb3IonYpPTJaffNFWvifH26Yt9njjkwubfcIxhegtK5WVpSsi
         56nfEdK2Q/WW5isUtYgKMvnDmjLe8o3fYzohJy33VhVzDTY6wKvEmV5jdnJKOMdlnH4z
         e1USuhoKF2CJfGPotl24nMyZxRN32zj4XTXPoEa5TyyUR5KY7sNe7IZtdkI+nSnGMZfC
         fGlg==
X-Gm-Message-State: AOAM5302d0OJEyaaFpgqxzLgK2j13iKA+O1KPdv1IJwUEnUOulaYKALM
        5lu+g8US/rXdFrYHeuAwRSig0CGj0LsRH8f3ZyvRyMsLWHNSmuej00G0FUKWD4nu5c7HTXw4JB8
        tWvGmRTN10b6XQ7WK9LEghc8ikSRv7wHSYg==
X-Received: by 2002:ac2:5d71:: with SMTP id h17mr14204462lft.642.1635173389989;
        Mon, 25 Oct 2021 07:49:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxRQErlF/R1paw1cLXY13RG/G2M/k1Cz7GJkjb23Wq22EpZlnXHsMIgnnBJ+035rSdh+yV5w==
X-Received: by 2002:ac2:5d71:: with SMTP id h17mr14204445lft.642.1635173389830;
        Mon, 25 Oct 2021 07:49:49 -0700 (PDT)
Received: from kozik-lap.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id j15sm1660922lfe.252.2021.10.25.07.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 07:49:49 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thierry Escande <thierry.escande@linux.intel.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] nfc: port100: fix using -ERRNO as command type mask
Date:   Mon, 25 Oct 2021 16:49:36 +0200
Message-Id: <20211025144936.556495-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During probing, the driver tries to get a list (mask) of supported
command types in port100_get_command_type_mask() function.  The value
is u64 and 0 is treated as invalid mask (no commands supported).  The
function however returns also -ERRNO as u64 which will be interpret as
valid command mask.

Return 0 on every error case of port100_get_command_type_mask(), so the
probing will stop.

Cc: <stable@vger.kernel.org>
Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. Drop debug code.
---
 drivers/nfc/port100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 517376c43b86..16ceb763594f 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1006,11 +1006,11 @@ static u64 port100_get_command_type_mask(struct port100 *dev)
 
 	skb = port100_alloc_skb(dev, 0);
 	if (!skb)
-		return -ENOMEM;
+		return 0;
 
 	resp = port100_send_cmd_sync(dev, PORT100_CMD_GET_COMMAND_TYPE, skb);
 	if (IS_ERR(resp))
-		return PTR_ERR(resp);
+		return 0;
 
 	if (resp->len < 8)
 		mask = 0;
-- 
2.30.2

