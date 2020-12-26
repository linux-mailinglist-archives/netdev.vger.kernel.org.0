Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1D2E2F33
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 22:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgLZVi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 16:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgLZViY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 16:38:24 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132FFC061786
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 13:37:44 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id m23so6371261ioy.2
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 13:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+EelmeiCwh0mSgh0t/gPM5pOh0Ts2KQEn5sM0mWzh/c=;
        b=v15rRe0XLufvITPY3eBFUGrxw7IrH5moQu5pQ1ZU8Tr/3V7cc7B0nwtZ5IHxL7pdCv
         an6NBskCa9l4kjhFnxBJrT0vDJPvIiSd6+JSVuepbDEhTqENf3cZ2V8RcmXI/0UFnfV+
         JF6r5Bs70TvNfQDyFan7Gwx72nyBwCK/xcnUubnhyoGEH8rLyUcrBpIrrxqtRwIMGAgm
         5tm78NwhdR8N0CZYcnWFgdYyHvRP762HefKO6upkAt9XX0ca8Uf4cX6xdbsYhSsAU0af
         ih5Un7YeB5adqn4R/5j07LkjA6mCpjObiJUA1cymMQ72t0ALQz1EaAlvbmr9wt9hC/mI
         TuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+EelmeiCwh0mSgh0t/gPM5pOh0Ts2KQEn5sM0mWzh/c=;
        b=pS3cCm4Q7qzPpfGlOFgR8Jx4OEiHUJnPdflD2yPi/SekRe25UJV+JXzLByhNC13Fav
         efEPVyvd2xoLRV+cKtnLuA5aBg1Fd3SbwHHmJhi2/MOIuAJV9M0p7yEThwpjNX6iUHla
         tFmTxZoAEjiaQ3Ak1s1xkdO9fdAJ8WilU7tXr6msQRG1TtWGeg/0Qp+mjcpmXyD53ehk
         qEeCic+eiKy+fAk4TvVbZw7uu5BUfg88H1ptK7sj161NSpLcF2q1+BlauLaXXuDJrm6x
         EHZo5vxqgV+oi2p80QPcMTQudWYx5Son+X7Hxkm0IhEGziFCjCSIqK07sFoEpALoXUWf
         Vo8w==
X-Gm-Message-State: AOAM531hdTBXc1Jfnw3Tq14DxFP6bFRbzo/KIb5f5u6tnyDF8zh55tpL
        fvZ75QwK5ESvhlm0Iy5eNNn52Q==
X-Google-Smtp-Source: ABdhPJw7RgiiN5BW8xuhIE8ulm2Vbf1h4RpsXrtyvNLsefo0DoA7qiHktnQtnsq4USgTavWr44y5bQ==
X-Received: by 2002:a5e:9242:: with SMTP id z2mr32257326iop.175.1609018663463;
        Sat, 26 Dec 2020 13:37:43 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u8sm30582763iom.22.2020.12.26.13.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 13:37:42 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net 2/2] net: ipa: don't return a value from evt_ring_command()
Date:   Sat, 26 Dec 2020 15:37:37 -0600
Message-Id: <20201226213737.338928-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201226213737.338928-1-elder@linaro.org>
References: <20201226213737.338928-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callers of evt_ring_command() no longer care whether the command
times out, and don't use what evt_ring_command() returns.  Redefine
that function to have void return type.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 428b448ee764a ("net: ipa: use state to determine event ring command success")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index e51a770578990..14d9a791924bf 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -326,8 +326,8 @@ gsi_evt_ring_state(struct gsi *gsi, u32 evt_ring_id)
 }
 
 /* Issue an event ring command and wait for it to complete */
-static int evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
-			    enum gsi_evt_cmd_opcode opcode)
+static void evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
+			     enum gsi_evt_cmd_opcode opcode)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct completion *completion = &evt_ring->completion;
@@ -361,19 +361,16 @@ static int evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 
 	if (success)
-		return 0;
+		return;
 
 	dev_err(dev, "GSI command %u for event ring %u timed out, state %u\n",
 		opcode, evt_ring_id, evt_ring->state);
-
-	return -ETIMEDOUT;
 }
 
 /* Allocate an event ring in NOT_ALLOCATED state */
 static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
-	int ret;
 
 	/* Get initial event ring state */
 	evt_ring->state = gsi_evt_ring_state(gsi, evt_ring_id);
@@ -383,7 +380,7 @@ static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 		return -EINVAL;
 	}
 
-	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_ALLOCATE);
+	evt_ring_command(gsi, evt_ring_id, GSI_EVT_ALLOCATE);
 
 	/* If successful the event ring state will have changed */
 	if (evt_ring->state == GSI_EVT_RING_STATE_ALLOCATED)
@@ -400,7 +397,6 @@ static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	enum gsi_evt_ring_state state = evt_ring->state;
-	int ret;
 
 	if (state != GSI_EVT_RING_STATE_ALLOCATED &&
 	    state != GSI_EVT_RING_STATE_ERROR) {
@@ -409,7 +405,7 @@ static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 		return;
 	}
 
-	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_RESET);
+	evt_ring_command(gsi, evt_ring_id, GSI_EVT_RESET);
 
 	/* If successful the event ring state will have changed */
 	if (evt_ring->state == GSI_EVT_RING_STATE_ALLOCATED)
@@ -423,7 +419,6 @@ static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
-	int ret;
 
 	if (evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED) {
 		dev_err(gsi->dev, "event ring %u state %u before dealloc\n",
@@ -431,7 +426,7 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 		return;
 	}
 
-	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_DE_ALLOC);
+	evt_ring_command(gsi, evt_ring_id, GSI_EVT_DE_ALLOC);
 
 	/* If successful the event ring state will have changed */
 	if (evt_ring->state == GSI_EVT_RING_STATE_NOT_ALLOCATED)
-- 
2.27.0

