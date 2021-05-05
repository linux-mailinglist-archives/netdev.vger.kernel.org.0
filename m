Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094F3374B4E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhEEWhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhEEWhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:37:38 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B26C06174A
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 15:36:40 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p11so3098356iob.9
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 15:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5yTMFAu5PQsqsLYoETACnPdjv/EWrNXFjZpRnoGVc4=;
        b=lVsrHbFc0939vNdUid2cZ2fr99h4kHZIfKGRJDOgCrIhNh9XofgTSyIuGJZg0d7o3H
         mCQGXtgFKGJQ46r8aMAOX7EECWZ0lKfBfO4LmEtak8E38ZTgFbxYAJoLYBE130akWGMM
         6VNF6AYaIRu+fHtEVfOPQUGJqPRfWM2/9waq+topQUC1s2pByK1hYvUp6Qfn5HLT/w30
         uMrXeJSxYnduuMLQHn6gRAsYu+Dhb5mbxA90gsqzMT7pVK/FRheiJ8UJoyHB0hbCsoP1
         Vy2JyM3Qe5NNH0TO5ckUyzDTaalXcOX649iiVoae4XX0lUBtYsmutEOQOY7lmfds0lxu
         55Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5yTMFAu5PQsqsLYoETACnPdjv/EWrNXFjZpRnoGVc4=;
        b=kchX7axkeuUUtVpg5RoalPOhE1TbJ05MeD/rfVO9uiyFUFtqK6m7oOI5aA2goE0x/M
         6kFtJ3+HgF0sZ7f1TpvpBMv3QNfVg2YrmEK4AuXn605ihBJT/r702NBtP2xr9L4CJ3XK
         MoNcuL1aPHrE/Cyicz5EASBtYTnvJvNROuuztBDot0s86BZVdpoZ6CsXVgzvv3Uq+SYa
         Cdke9l8dgS1sv0JkfRSye66dKv36/HJ5tWyj3b4lfEWMMwmPdqTzYqbjO50A8ZL8NhdJ
         Zq0RTCjWj1aJREiyEKoGmnk4mb1SnKtai6o/u/X4f3lnB862BgpY5w4E0w77Ch9ua1Ji
         HQNg==
X-Gm-Message-State: AOAM5306OUEMWwP/BBc2QAvSOe09WJzpAjwq8U4zX+YazY/sQOBoFHSX
        bz/+W3xNQy+0GwEwJOkr9Qp1hw==
X-Google-Smtp-Source: ABdhPJzc8yQhQ6tcpCvw7VnovW6xB/ySmSY4y/2nRFN3KI/fUs6X02O+SPFSCzdSbC/4a1e7e1Lbfg==
X-Received: by 2002:a6b:d918:: with SMTP id r24mr665545ioc.25.1620254199959;
        Wed, 05 May 2021 15:36:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n23sm248957ion.53.2021.05.05.15.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 15:36:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: fix inter-EE IRQ register definitions
Date:   Wed,  5 May 2021 17:36:36 -0500
Message-Id: <20210505223636.232527-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_irq_setup(), two registers are written with the intention of
disabling inter-EE channel and event IRQs.

But the wrong registers are used (and defined); the ones used are
read-only registers that indicate whether the interrupt condition is
present.

Define the mask registers instead of the status registers, and use
them to disable the inter-EE interrupt types.

Fixes: 46f748ccaf01 ("net: ipa: explicitly disallow inter-EE interrupts")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  4 ++--
 drivers/net/ipa/gsi_reg.h | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 9f06663cef263..e374079603cf7 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -211,8 +211,8 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 
 	/* The inter-EE registers are in the non-adjusted address range */
-	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
-	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index b4ac0258d6e10..cb42c5ae86fa2 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -53,15 +53,15 @@
 #define GSI_EE_REG_ADJUST			0x0000d000	/* IPA v4.5+ */
 
 /* The two inter-EE IRQ register offsets are relative to gsi->virt_raw */
-#define GSI_INTER_EE_SRC_CH_IRQ_OFFSET \
-			GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(ee) \
-			(0x0000c018 + 0x1000 * (ee))
+#define GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET \
+			GSI_INTER_EE_N_SRC_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_CH_IRQ_MSK_OFFSET(ee) \
+			(0x0000c020 + 0x1000 * (ee))
 
-#define GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET \
-			GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
-			(0x0000c01c + 0x1000 * (ee))
+#define GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET \
+			GSI_INTER_EE_N_SRC_EV_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_MSK_OFFSET(ee) \
+			(0x0000c024 + 0x1000 * (ee))
 
 /* All other register offsets are relative to gsi->virt */
 
-- 
2.27.0

