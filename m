Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA110109099
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfKYPCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:02:32 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41211 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfKYPCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:02:32 -0500
Received: by mail-pl1-f194.google.com with SMTP id t8so6550489plr.8;
        Mon, 25 Nov 2019 07:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKcTzJuC8PJNnzJIm6q83P/GLVLCiZGhOohm6Nds3hc=;
        b=bk983ilxL0r0Fce8gHo4CaeRf1bGDE1zSkzSIF4yl81SlyBOoPf2fhDfxYEkxsWX2+
         yuDwYQOkJvmgnIVkInTr8n1pP7Cjwhy+RlbVXv/5Kp0wF/vKikM8U5FXruzADmUKCdRA
         vnT3OFZ3CiHwm7V47kEVjV6PCIR953jnMxXmt1HToOvRsIeaF24FJ+hm11t2MOkst0/u
         7PdgQp8SNmAvIgZ9BzifFWo9JEumzW7/IEHQxAZ9gRcX3YMo8gxWOdweOyrhRXetsAyj
         W9er49FRlHYw/UP4TCWGxw2RdtUjhviv6ZS/h7zmXAJGVL61/mtsJurM1vTE877H88ba
         moyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKcTzJuC8PJNnzJIm6q83P/GLVLCiZGhOohm6Nds3hc=;
        b=rDlCby2mlrsauV3wzs7ZTaGQAHXOONdOgmvHS9OMqVZlL5Opg/01f0l7c6N7ewJnvV
         sgLi3sEb9c0jsgI8EfUoMex+u5M4HN+UzruyfxuM3WBUGYE7jTEPZTOii2HtAIMmorwh
         QBO4iyBq4Qx9r1dt4RrVrdFayf2FzXY6qunQNyKIRXfn5iUoizl+qxORYtnCtLMKcDKo
         i0kdE5k8SSnrwRRsKh5SGwVItJOsylp8iFAtdrwW0H5rHcb3dgejvMBIsVvzlu9Mz0YP
         evT7iFvRgGk/K5htaBw6/1xiluTYqHze7OK7zQnC66F3kG+TRY4rO+qxCEUE7fd0cxkg
         Kx4g==
X-Gm-Message-State: APjAAAWbd9xMGn3z6/6vYurPk1Vc0iqVOxZA/fjC3CRde8TaIXcVuHrA
        pxfaijIzobMMAfqYyoNTZ2w=
X-Google-Smtp-Source: APXvYqw8QG/+4RGvVsZBLEC3KCXWc24rJdDz9RFjxp89WY3S9kjTgCE2BoFpSMc4jJeHoa7JGhD/NA==
X-Received: by 2002:a17:902:bb83:: with SMTP id m3mr28043829pls.94.1574694149877;
        Mon, 25 Nov 2019 07:02:29 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id x2sm8703129pfn.167.2019.11.25.07.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:02:29 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     jakub.kicinski@netronome.com, kvalo@codeaurora.org,
        davem@davemloft.net, luciano.coelho@intel.com,
        shahar.s.matityahu@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, sara.sharon@intel.com,
        Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        yuehaibing@huawei.com, pkshih@realtek.com,
        arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 1/3] drivers: net: b43legacy: Fix -Wcast-function-type
Date:   Mon, 25 Nov 2019 22:02:13 +0700
Message-Id: <20191125150215.29263-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
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

