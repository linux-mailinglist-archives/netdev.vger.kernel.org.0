Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C70421082B6
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfKXJnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:43:31 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42035 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfKXJna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:43:30 -0500
Received: by mail-pl1-f196.google.com with SMTP id j12so5120484plt.9;
        Sun, 24 Nov 2019 01:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kKcTzJuC8PJNnzJIm6q83P/GLVLCiZGhOohm6Nds3hc=;
        b=X8dZyNbi3pl+sJ8jfd2OCmlabAVhWAZlCWuunPrsoKiHbMoH55cymADTddbO3fJ/OC
         FjLO6PNcC2YgAA3vy4g7maWL+gPrWUJWX8mlwhKRDuoVIw+LafdRH30SolvbZdat0r2S
         XZd96YHHet9+YyzSCOfxydogbOHD6k9rWOEE50LgsbNlO2QKIA4ZFL+FZyf/aNnu7ndk
         bFsaGs2UHtadrPeu2cxRcwVAss2vBkPd7m4W4NMWqlRexLQImRlRmcEnmgBdVyO5nFGT
         QqF6iTNnHtMHN5H8k7weBSsmc21axWhI1TxDBNg20skeR77b19fUvNqP9RdrMrEk2vRl
         ECzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kKcTzJuC8PJNnzJIm6q83P/GLVLCiZGhOohm6Nds3hc=;
        b=dJ3vGUkTeYwlyp2Jytjq3VbneTMbbYo1+raC+sqG0Or54Xe5R0kq8jrtSaBV/mWOzG
         FTgzbqKjj378QZ5j9rIw+9qECEVP1iWGXor7+uSHZsbtRgE1gcMkzuVCDHPjStjmfEbJ
         NV3O5n2nZVozLr5ABFFKUKF3Z+aB4tLima3Fkeka2GDhY2mIPiJX+y0stVbQy5tIQ5rC
         1gwge0D6+zlUMwfkg4y+8R11tmV8rMHN0THC2bBQlfIriGZpr7/gL9TJEmBuIvr4VJTJ
         Ojy985Pwjieek0aKJEdK1ojeGvegD3Su0zPRcPaYMVs+M722oH4ZvCdULHTXJK8fa0oz
         k7CQ==
X-Gm-Message-State: APjAAAXsIebTBMs19cGHDdm/go7nYhbYPUzKe9RnrMsUFvXaqYSn5/6x
        XftC4Sbwgw5EVBa+AVmdPd0=
X-Google-Smtp-Source: APXvYqyBvLowC9Q1fNUStc4e4FDdNQIEjGCU3mQc3EYLzwvXZT5VCgknE9UcRP6a4ceXHb32iNwn1Q==
X-Received: by 2002:a17:90a:be05:: with SMTP id a5mr78858pjs.73.1574588609123;
        Sun, 24 Nov 2019 01:43:29 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id c3sm4091213pfi.91.2019.11.24.01.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 01:43:28 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, keescook@chromium.org
Cc:     kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 3/5] drivers: net: b43legacy: Fix -Wcast-function-type
Date:   Sun, 24 Nov 2019 16:43:04 +0700
Message-Id: <20191124094306.21297-4-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191124094306.21297-1-tranmanphong@gmail.com>
References: <20191124094306.21297-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 4325e91736eb..8b6b657c4b85 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1275,8 +1275,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
 }
 
 /* Interrupt handler bottom-half */
-static void b43legacy_interrupt_tasklet(struct b43legacy_wldev *dev)
+static void b43legacy_interrupt_tasklet(unsigned long data)
 {
+	struct b43legacy_wldev *dev = (struct b43legacy_wldev *)data;
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
@@ -3741,7 +3742,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
 	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
 	tasklet_init(&wldev->isr_tasklet,
-		     (void (*)(unsigned long))b43legacy_interrupt_tasklet,
+		     b43legacy_interrupt_tasklet,
 		     (unsigned long)wldev);
 	if (modparam_pio)
 		wldev->__using_pio = true;
-- 
2.20.1

