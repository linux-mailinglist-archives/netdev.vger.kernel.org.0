Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D471318A44
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhBKMS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhBKMOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:14:23 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604C7C061793;
        Thu, 11 Feb 2021 04:13:18 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id e17so7072513ljl.8;
        Thu, 11 Feb 2021 04:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46N7YZOZpVCLxCj0X2/FFcvXA9Ez10ge8/4y9IqilWQ=;
        b=Ywr9we38aQ7KQ622yeueL9uFAHmUMe/W6sS1ehPZgAUiiH7N0i8ThYR9c1API2THgS
         f+elkjc3rnVHRiexRLzEK3MCVsTOdu2I/p0O6Xs+zn92Xs2cPW3lZVNyyOtTvgwbOucU
         kmNB25dM3pjqYGYRjO1bMF/M2aJZPdtOcjWwxod8f7qCyCQm4q48vC9Lw2hX0KJTJImM
         +lqXzwxapJ0r9+038g0NpYt/qAYt6YyyY0cLkvgBsAy4g0yvmYQF9CApAaaEFedKVQFV
         ibKC03B1BvC9tm8LY8hPmfqLzWQb/BHm/7B7fzRYUucrqFmPfaVu9BIQOKzYIRCwXRZq
         mnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46N7YZOZpVCLxCj0X2/FFcvXA9Ez10ge8/4y9IqilWQ=;
        b=myHzeZKKiMq0cGs5QBlzcdKmXZADHJHWy8H7LeoBbpqI+PK+6aEV+9mS/8rCFjbCVp
         NDvWrZSZ+GzwL4bMrIobjekUTbkG2oyOYiF9/HZwM7iiY7L5amuskrkS5lvIHElfeYKi
         +uBQk4HuSqbKLU4y/e+e9FJ8wpJMtKI6COZ+FUOLEWv2SZj2J7zfPBjPbjXI1TfAcjq1
         Wq5ra+oaNaCXGF+rB1vR/BjzXasul4hoz+0wUxx8qb9HMCLeO0ThVUiBAQ0Oym6kdal2
         N7ws/H8rwR8xZztX3/VnXFJoMenbNFM1s0Dj7n/voZJ+wTJVKC1tTfKKqG8GT5Sv+l9A
         5UoA==
X-Gm-Message-State: AOAM5317UW2GKNuLyW0mrUzuK0yPrcWAl2Ezml40XFjaHE+bua61QFRL
        1Onf+ugN0Zdxf7WbdmqAtiw=
X-Google-Smtp-Source: ABdhPJy5uhePebtgEp550Vgi4TfdkccRzbwGYliB3mmr96hOJb6IvrBFY87YXPgj9LnqBm731OyWAg==
X-Received: by 2002:a2e:b8c7:: with SMTP id s7mr4619805ljp.397.1613045596948;
        Thu, 11 Feb 2021 04:13:16 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:16 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 5.12 5/8] net: broadcom: bcm4908_enet: drop "inline" from C functions
Date:   Thu, 11 Feb 2021 13:12:36 +0100
Message-Id: <20210211121239.728-6-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It seems preferred to let compiler optimize code if applicable.
While at it drop unused enet_umac_maskset().

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index f4e31646d50f..7d619aa9410a 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -75,17 +75,17 @@ struct bcm4908_enet {
  * R/W ops
  */
 
-static inline u32 enet_read(struct bcm4908_enet *enet, u16 offset)
+static u32 enet_read(struct bcm4908_enet *enet, u16 offset)
 {
 	return readl(enet->base + offset);
 }
 
-static inline void enet_write(struct bcm4908_enet *enet, u16 offset, u32 value)
+static void enet_write(struct bcm4908_enet *enet, u16 offset, u32 value)
 {
 	writel(value, enet->base + offset);
 }
 
-static inline void enet_maskset(struct bcm4908_enet *enet, u16 offset, u32 mask, u32 set)
+static void enet_maskset(struct bcm4908_enet *enet, u16 offset, u32 mask, u32 set)
 {
 	u32 val;
 
@@ -96,27 +96,22 @@ static inline void enet_maskset(struct bcm4908_enet *enet, u16 offset, u32 mask,
 	enet_write(enet, offset, val);
 }
 
-static inline void enet_set(struct bcm4908_enet *enet, u16 offset, u32 set)
+static void enet_set(struct bcm4908_enet *enet, u16 offset, u32 set)
 {
 	enet_maskset(enet, offset, set, set);
 }
 
-static inline u32 enet_umac_read(struct bcm4908_enet *enet, u16 offset)
+static u32 enet_umac_read(struct bcm4908_enet *enet, u16 offset)
 {
 	return enet_read(enet, ENET_UNIMAC + offset);
 }
 
-static inline void enet_umac_write(struct bcm4908_enet *enet, u16 offset, u32 value)
+static void enet_umac_write(struct bcm4908_enet *enet, u16 offset, u32 value)
 {
 	enet_write(enet, ENET_UNIMAC + offset, value);
 }
 
-static inline void enet_umac_maskset(struct bcm4908_enet *enet, u16 offset, u32 mask, u32 set)
-{
-	enet_maskset(enet, ENET_UNIMAC + offset, mask, set);
-}
-
-static inline void enet_umac_set(struct bcm4908_enet *enet, u16 offset, u32 set)
+static void enet_umac_set(struct bcm4908_enet *enet, u16 offset, u32 set)
 {
 	enet_set(enet, ENET_UNIMAC + offset, set);
 }
-- 
2.26.2

