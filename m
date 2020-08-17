Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA6F245F2C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHQITJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgHQITD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:19:03 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6B6C061388;
        Mon, 17 Aug 2020 01:19:03 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h12so7752460pgm.7;
        Mon, 17 Aug 2020 01:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ssSSz7f3Ql8I/02L7v0dEm57rAmAG5QqUNmcYkmicic=;
        b=TEUbjnnRYtLTSLXt82s3M/Tu0/Dfm/cSIzdCRLdoOboLsxmozgAGCXKnGPI2nAAzNC
         EmGMZDaze5DV1KuQa752lOTgT+eqV0fI4Oyujx30mDci1i3Wp0qufhkaGhhWv5em1n2y
         0QA2FUP7JeZ+GKPClXiSVQa3tg2i9QAOCS8UCHqADZAh546W6d38Z6uT9ZRhKV2sj00p
         Y+XLsIKpO3S8Zy53NpFF4k5kkK2Mj6OAdzk+Nrbm4hOz/kwdFdQK36tyhr8mLbQie9pw
         sp0WqRPYbJ3sPhQgxNPh5BwIeb6S4yxbwxB+YDPOg+VIknpzMdPYw2B7XmoGm5Eae2RI
         g8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ssSSz7f3Ql8I/02L7v0dEm57rAmAG5QqUNmcYkmicic=;
        b=VG/XU7pit/pgigCBMQeoTJH5PtrMe6NAiMBB3bd4pbVuzJYAcJIC9CrbLH3bJJniGe
         JfhN/bV+vAckJ72c3Vv+8FDzjGYKMOXaogHEeB79GwqWM3FSj9t64GTtgs0x7PRU7lnj
         2MyGfSfmMtPPTWyRSA2XbfbwQLndBYC8BoNgVO2J4s0u7Rm10MN3PnGy3+gDnUHmmfs8
         r/XGWPvKb488K0ARtpfR9ntnhEaR2q3TjG9BgLuIt4cryYg7SXD77NYwUJTdl/FgdhLC
         +PPhSBcNQSKnYx7QXVohs4wBQ27g88Qzzu+cYxPhr1wKr1JuVi0hkUTFghE1fpJFVer6
         uhhA==
X-Gm-Message-State: AOAM530pTFL14S7oMHTC3IYWKjHfCMNQP/2NtCeaEoxLwtDaZc8nMcl0
        sz8+vkeeT+CZMgkMHWmldALbdlMnG7lN0w==
X-Google-Smtp-Source: ABdhPJy/L1S0pESv+N3Vx6Fjhj55gZLQvmhaIt7kWIR8XqiTFsZtfrFUisjaRrccHbbBe+p68Se4vg==
X-Received: by 2002:a62:79d7:: with SMTP id u206mr10467523pfc.97.1597652343406;
        Mon, 17 Aug 2020 01:19:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:19:02 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, baohua@kernel.org, mripard@kernel.org,
        wens@csie.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@xilinx.com, matthias.bgg@gmail.com
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 08/35] dma: imx-dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:59 +0530
Message-Id: <20200817081726.20213-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817081726.20213-1-allen.lkml@gmail.com>
References: <20200817081726.20213-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/dma/imx-dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5c0fb3134825..67b9f2bf35b7 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -613,9 +613,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	return 0;
 }
 
-static void imxdma_tasklet(unsigned long data)
+static void imxdma_tasklet(struct tasklet_struct *t)
 {
-	struct imxdma_channel *imxdmac = (void *)data;
+	struct imxdma_channel *imxdmac = from_tasklet(imxdmac, t, dma_tasklet);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc, *next_desc;
 	unsigned long flags;
@@ -1169,8 +1169,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&imxdmac->ld_free);
 		INIT_LIST_HEAD(&imxdmac->ld_active);
 
-		tasklet_init(&imxdmac->dma_tasklet, imxdma_tasklet,
-			     (unsigned long)imxdmac);
+		tasklet_setup(&imxdmac->dma_tasklet, imxdma_tasklet);
 		imxdmac->chan.device = &imxdma->dma_device;
 		dma_cookie_init(&imxdmac->chan);
 		imxdmac->channel = i;
-- 
2.17.1

