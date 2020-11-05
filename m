Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCCB2A85D1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgKESOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731860AbgKESOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:17 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FF5C0613D3
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:16 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u19so2755331ion.3
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+jRA6jK3dNYq1T9rf46J5RdbaZLC3MuzRET4C+/aNo=;
        b=v0VRup+5audTyZUgcOkCppVCqGvAScG/08kL9QNTH+h3jtWOzf9K/Q8cNdiDo4hCkT
         QxE62vh2FXBWL6iq6GP5V/vnlMuBhRu0pdxvZP2vOzPPmZDGyT7D8xlmUS/NCDJ1s/Px
         5IlFqJgpb414nNFwzGCnc9e+YHUXTmx8cYNcOcEgvhNzb5PKXjgSOh4Y05wJuRhqXGHd
         eUYgiKMUF4erZH/Nc3tyzj1FXwYLYmpHxPjAbTFl/LjzsIqk0zDtRqDm4HboFNt41+Dh
         nOLJh1sb0jvL9nu2izqAWfU9C8d6P2Nt4dHC4UynOMIoMketimSqP7XbcGzgRqyLnoU8
         FY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+jRA6jK3dNYq1T9rf46J5RdbaZLC3MuzRET4C+/aNo=;
        b=JwOCIERk9w7Wb1DX8NhSWdL2KeRN1rGAFn5gtce0/iHl2LY717hwO+F8BLjvzOiHJt
         A4S1+MLPGJxF4ExfQTUKuV7AeH4i9mfT2yK7+uQBikydHH9KHrMsoODvidnL4b+EzYoM
         TTewVpXU+8c5/G4d1SQrULis0hdHcdve1tEPq9EUH1VDRs5mZzhJeFn65HCDpm3+Nyrk
         ZoI1g830WAXBMDW7x+3szv6cgFCeY26vB+JRcIZOgZgVYZc1U2zS2G+kYnWP5e1EGHw3
         e4LrsCK1MLQ+ePkj1NFGnVRlDIx4Y4E6I2UN3n+kIMDI34GimydTaqtm8rNe5m98TETS
         /zEw==
X-Gm-Message-State: AOAM531+X0eykOZ0VIu+P/qWQNWQdpq1RujyXLVeTcSnPjxYIIALgHAg
        10C+UAPxNwhDDkBD2E2iUisxsQ==
X-Google-Smtp-Source: ABdhPJx5/neOnbpwVAjpjjKpqw0rCK7lceobmoVDHoSy/HbX9yf3mnZCVb+P1e2DM1YKITuwF/jI8w==
X-Received: by 2002:a6b:7942:: with SMTP id j2mr2670929iop.73.1604600056274;
        Thu, 05 Nov 2020 10:14:16 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:15 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/13] net: ipa: rename gsi->event_enable_bitmap
Date:   Thu,  5 Nov 2020 12:13:57 -0600
Message-Id: <20201105181407.8006-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the "event_enable_bitmap" field of the GSI structure to be
"ieob_enabled_bitmap".  An upcoming patch will cache the last value
stored for another interrupt mask and this is a more direct naming
convention to follow.

Add a few comments to explain the bitmap fields in the GSI structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 10 +++++-----
 drivers/net/ipa/gsi.h |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 299791f9b94d0..ea1126a827a1c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -234,8 +234,8 @@ static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 {
 	u32 val;
 
-	gsi->event_enable_bitmap |= BIT(evt_ring_id);
-	val = gsi->event_enable_bitmap;
+	gsi->ieob_enabled_bitmap |= BIT(evt_ring_id);
+	val = gsi->ieob_enabled_bitmap;
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
@@ -243,8 +243,8 @@ static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
 {
 	u32 val;
 
-	gsi->event_enable_bitmap &= ~BIT(evt_ring_id);
-	val = gsi->event_enable_bitmap;
+	gsi->ieob_enabled_bitmap &= ~BIT(evt_ring_id);
+	val = gsi->ieob_enabled_bitmap;
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
@@ -1774,7 +1774,7 @@ static void gsi_evt_ring_init(struct gsi *gsi)
 	u32 evt_ring_id = 0;
 
 	gsi->event_bitmap = gsi_event_bitmap_init(GSI_EVT_RING_COUNT_MAX);
-	gsi->event_enable_bitmap = 0;
+	gsi->ieob_enabled_bitmap = 0;
 	do
 		init_completion(&gsi->evt_ring[evt_ring_id].completion);
 	while (++evt_ring_id < GSI_EVT_RING_COUNT_MAX);
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 59ace83d404c4..fa7e2d35c19cb 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -156,9 +156,9 @@ struct gsi {
 	u32 evt_ring_count;
 	struct gsi_channel channel[GSI_CHANNEL_COUNT_MAX];
 	struct gsi_evt_ring evt_ring[GSI_EVT_RING_COUNT_MAX];
-	u32 event_bitmap;
-	u32 event_enable_bitmap;
-	u32 modem_channel_bitmap;
+	u32 event_bitmap;		/* allocated event rings */
+	u32 modem_channel_bitmap;	/* modem channels to allocate */
+	u32 ieob_enabled_bitmap;	/* IEOB IRQ enabled (event rings) */
 	struct completion completion;	/* for global EE commands */
 	struct mutex mutex;		/* protects commands, programming */
 };
-- 
2.20.1

