Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D06F3D95F1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhG1TSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1TR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:17:59 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1401C061757;
        Wed, 28 Jul 2021 12:17:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i10so3919934pla.3;
        Wed, 28 Jul 2021 12:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tlSkpJrxofz4KLJFo6IpJsCRmIFL97VN126VaWV4qiw=;
        b=JNLEAf2mMXwo4aCgKs24hotp8eBbsf0ahKXCR0Y85l0p7adULjYvjPyieQZpVbS/N4
         b739qfW8zD6kZiI2vgm2CTpEMPL5cQip1EvVPGMIl83vjjbPCjXMjq9VxFeLLrIclxOZ
         cCAkcakrjT1od6kWSGW5qfrfuSACjhqUMgx26FQfJA3IwIW6qtXyGxWxBGtzQEowYnJ/
         zP82CfhIFZS5F7btTUyrQi8KlYBGTbPgfiU75vpmGej++V4qp7Hxio+g0fxtCLb1an/7
         AMlRuBCXVFRQ6K0KeEFagO0tXO+hfCg8W/yYEBxckGx2xYXr9RqL9j/mh4mxcL7SJwJD
         dXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tlSkpJrxofz4KLJFo6IpJsCRmIFL97VN126VaWV4qiw=;
        b=HlC+mYO/1zuialFh+VkOdCQUIClYFvJCuBnPdhTRme7fx1uGXr7b0T+a2XHmwDh6QR
         AmJwwz7GM104RvagmYlrfEkJ9oZA4RH1k7E25iYgdqFvYvV7Nm5vZyEeTiTpCFo+QOJj
         h95IIyUA+yVlSN3OyekcojnySaITDYiR3u4N2bIB3pxov5mTkGFr4lfa/YKtoge5gtVv
         q91+bjU737d/VDBYMwVVqZD//LtPh+ZJgdj0cOIxVkXO+iPGDJu5EEBBsmpQ/5NMtFkR
         3HAWdHpZAkqCVGEeSWIsw26RQ5XgcoAy2H6kFU4boZ+DtEAsgVAvNc1DzUKp35x9mXtR
         FRjw==
X-Gm-Message-State: AOAM531RkfIaSUQ9S4cfI9GjjLSAyeKtiWRQ/ywAZvfrRkihbeqXc7Y6
        25DWdTcABR7rpZhcebkVsWY=
X-Google-Smtp-Source: ABdhPJzz1hnYQmfSfPANLOLr9Ck2OfELKiyvpZ7Caoj/2kq9puuPWuV06r6sJYJbsrIBfg1NTYu2lg==
X-Received: by 2002:a17:902:7247:b029:12c:48a2:cc2c with SMTP id c7-20020a1709027247b029012c48a2cc2cmr1151819pll.31.1627499876116;
        Wed, 28 Jul 2021 12:17:56 -0700 (PDT)
Received: from novachrono.. ([223.236.188.83])
        by smtp.gmail.com with ESMTPSA id d14sm5827671pjc.0.2021.07.28.12.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 12:17:55 -0700 (PDT)
From:   Rajat Asthana <rajatasthana4@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>
Subject: [PATCH v2] ath9k_htc: Add a missing spin_lock_init()
Date:   Thu, 29 Jul 2021 00:47:19 +0530
Message-Id: <20210728191719.17856-1-rajatasthana4@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <38fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
References: <38fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reported a lockdep warning on non-initialized spinlock:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x143/0x1db lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:937 [inline]
 register_lock_class+0x1077/0x1180 kernel/locking/lockdep.c:1249
 __lock_acquire+0x102/0x5230 kernel/locking/lockdep.c:4781
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x19d/0x700 kernel/locking/lockdep.c:5477
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 ath9k_wmi_event_tasklet+0x231/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:172
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x1b0/0x944 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x21/0x50 kernel/softirq.c:913
 smpboot_thread_fn+0x3ec/0x870 kernel/smpboot.c:165
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

We missed a spin_lock_init() in ath9k_wmi_event_tasklet() when the wmi
event is WMI_TXSTATUS_EVENTID. So, add a spin_lock_init() in
ath9k_init_wmi().

Signed-off-by: Rajat Asthana <rajatasthana4@gmail.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index fe29ad4b9023..480de2170816 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -101,6 +101,7 @@ struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv)
 	skb_queue_head_init(&wmi->wmi_event_queue);
 	spin_lock_init(&wmi->wmi_lock);
 	spin_lock_init(&wmi->event_lock);
+	spin_lock_init(&wmi->drv_priv->tx.tx_lock);
 	mutex_init(&wmi->op_mutex);
 	mutex_init(&wmi->multi_write_mutex);
 	mutex_init(&wmi->multi_rmw_mutex);
-- 
2.32.0

