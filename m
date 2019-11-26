Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B085A10A3A4
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfKZRz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:55:57 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44855 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZRz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:55:56 -0500
Received: by mail-pj1-f66.google.com with SMTP id w8so8619363pjh.11;
        Tue, 26 Nov 2019 09:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=psR0lc9V3Wlfquc+Ru02h/4BIxYapesjG8uBLemW7hI=;
        b=sN8rMBdFIP6ykaiXexQPhfCmYQ/9qTmtAD0VRlwvbxiR9+ISfJB2y2m3KHsDyRcf0a
         v7ZSbymfjpsXpyUfbKs5Y6UTicbUi59Yx7JLWLQ+L3cbvLqZDUnrCt+YLsi8MKnARYRP
         af6osaeEiVghatzOx/ISWnohIoknKNOQXyUvncBuEVpZavn6OSwMQVoQZzqHCYGHnxEU
         nOB0o0b/J5mMUK22msy5yjj8bYe5Yfhmj8alowlAjuMfUv3dYQXqZb+3kaRdUn8yD2aa
         k0dIKkQS6kyFzd2o/qylEk4cyqa+KggJ5DfpFOndJqT8DIQJoWGNiFDp73aJZS6zvbMR
         TSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=psR0lc9V3Wlfquc+Ru02h/4BIxYapesjG8uBLemW7hI=;
        b=RumvShnB9kzadkZs8AvzfWEe0qbUmnH+DGPw/jAsZREtyMBJ3zrrSsbI22FWY9yQ1W
         4bVZ3iM0yA+j/mXrJMSZDQLXYI+cMXluFDhLJs+ut91XNRS6H58J7GWdLaVaScWR47aH
         SFhcarc4//NR4GxWNGtFVG9jwHhJKTWgrl394pv1mzYX2Y2ILhc/KlLpZoIND7GGLTLL
         tJLXqYWhzG34kzwN4fl+RktSLog5pHFF2dfBYNb770Ku/KriPuSeKsNcndSEs4F1qvRU
         WGuZL7nl2M1Qg+RZcYaYaUTJiRfvOiIE/ZvQBxYuDdPXngGjhHsbL6P0gcfkIrtpstLU
         gY9g==
X-Gm-Message-State: APjAAAWYD/2w8x8HsKsERYFq5de8HEbtFJ/sTBEbyl14SzOLeMkx4CS7
        6BeWRIWd/bVS19HO/P5br5Q=
X-Google-Smtp-Source: APXvYqzQNjolfc10t1hCAEzbsyosHT+jb6I2ufIehxJMfZz1bV1PZlexX3MQ4+Zdhu8Z3of/UcS5WA==
X-Received: by 2002:a17:902:b60d:: with SMTP id b13mr36433120pls.145.1574790955800;
        Tue, 26 Nov 2019 09:55:55 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id q6sm781577pfl.140.2019.11.26.09.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 09:55:55 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org
Cc:     tranmanphong@gmail.com, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
Subject: [Patch v2 1/4] b43legacy: Fix -Wcast-function-type
Date:   Wed, 27 Nov 2019 00:55:26 +0700
Message-Id: <20191126175529.10909-2-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191126175529.10909-1-tranmanphong@gmail.com>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191126175529.10909-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
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

