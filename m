Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071713D9606
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhG1T0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhG1T0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:26:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C377C061757;
        Wed, 28 Jul 2021 12:26:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so5586462pji.5;
        Wed, 28 Jul 2021 12:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tlSkpJrxofz4KLJFo6IpJsCRmIFL97VN126VaWV4qiw=;
        b=jIg2mC1/DGImRz3PHpmlqT7eLIBfAG8bnO8n/qKq9ND/F7HfetxYndGjMT1UT4vkMA
         HaP7ybr96J1uYuyrYpmR7jcH9izgDE+a3LSJcfi6rBo0c5xvduwGP6uK5ZV7Sbtcn2Tg
         3/6bTX7g6XfiUXkT+tzknTbi6F3Z+q7UV1RS08OBt0/gXEl1tvhsiFRC2NtP4uLkmQz6
         fKHem3bxSOiOowbu7VNOVuoEmCGxTmgJdPytz6ODrWjFhzYGtHiQrLV/B8RRJLT+7B1F
         Mp0W0tKSjgB0TNKXhjRmM9flD9wJBE6EY3v5XwReil5ErPYFjbWVNhyvgox+K3KYvxUi
         /SRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tlSkpJrxofz4KLJFo6IpJsCRmIFL97VN126VaWV4qiw=;
        b=P7KjMLMCp1qjRgva0ks3+Fh2tBJQs7uirP6EOKNkkrWe8sxj6gk6YkvxYq6Ku1PKdg
         qjug5Yq7PqWeDkhsmMkfwtXFX6zfYeWEgw3N4N5MZ39KYEd04+gkG5Q70OMwCgH4LG+H
         AGEwRdOz9ZKYqhqYXoqCIHoxkSo78aBWDpl1wpYGRSdVKlGZPxzPQn8wbkWWnGO3E8t0
         9o6tTIWAz5APZ1ugGw2BXoCxxew4JWntuP0talnhO2HxM5ZeRWsDq9oYfuEiYRRo3Sqf
         Om7dcirtEYcAFJcFSKVhJOqT7cNx1UNYvWS9fAGgqP78GPvFtTA+qtpo3htcl5z1rSl9
         ZLZQ==
X-Gm-Message-State: AOAM531Qq2Y15HwIfKW8caMZYA6D1F9vnSI32TchrvqJsnQ2fxt4NOv3
        OGyc8kPv6HYKcZD1HDeVVqk=
X-Google-Smtp-Source: ABdhPJybhrs86OwDT9S6CH/ON+qQJ6YcWgPrjWd9MiaEbHudhatgNC9w/i8nBMQXyEwa9+ZAh/va0w==
X-Received: by 2002:a17:90b:3b4e:: with SMTP id ot14mr11145950pjb.50.1627500386852;
        Wed, 28 Jul 2021 12:26:26 -0700 (PDT)
Received: from novachrono.. ([223.236.188.83])
        by smtp.gmail.com with ESMTPSA id c23sm795130pfo.174.2021.07.28.12.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 12:26:26 -0700 (PDT)
From:   Rajat Asthana <rajatasthana4@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>
Subject: [PATCH v2] ath9k_htc: Add a missing spin_lock_init()
Date:   Thu, 29 Jul 2021 00:55:33 +0530
Message-Id: <20210728192533.18727-1-rajatasthana4@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <738fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
References: <738fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
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

