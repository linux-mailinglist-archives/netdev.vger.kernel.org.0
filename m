Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5861524626A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHQJRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHQJRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:17:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AF8C061389;
        Mon, 17 Aug 2020 02:17:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f9so7394648pju.4;
        Mon, 17 Aug 2020 02:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=exYXzHUMf/iFSguNQmfag8NVMIwmEs2D9XqDGt6aa9s=;
        b=sp0LSuWIOb4/MJIas068i1WpBEM3xuHmLSe+GoqlRW4vIuITcNFJlJZEQ6Qrp7Gf8n
         6ZVCV1OINCx8t0WTqiL2c2t/g73ZusUr8ZD0u7//k2W+3P69SlufEUzmU5sCLgEHp84w
         yYp5Hp0oOcosUCxUvw9aTc0Gf+wAJMQldYs5DlgXSeVn+Q4cbUzMlxEGp7MBce0mjFxl
         Q5uA/NH5nqVh53jSmBqdxLG7n/3BQKjEJWUq/EbpLwSoODEaMoOj4MUW3Qcbs42qaS1D
         /vRxYXv8CpEx8JUXV/f5y9ACHSk0+6v8lT4AzuKQRJ4ziUkSyXhhGjH+ZnIuX/kGCFSG
         OdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=exYXzHUMf/iFSguNQmfag8NVMIwmEs2D9XqDGt6aa9s=;
        b=B3qldwcLq0z842FH9z5GIdzpZiOvs/5y+32DAqNppd/6eaI9+7+RSp4Bqf01WL0/RM
         6Wk1tXbz3vY55u2UATSUWSCxvURIIulUx26+ldXSzawXjsQZNccnl/gwG0FeWuP3oj0/
         o08hp03pV56hSGP4h6lw4cAB0zT9Xtufuj2gXphF+SWfXtgy1uZaUrAttgqX6cijsR3Y
         vSgcvXupWA55aFQYfG/f1GsHV9QWoVmERtk1t+Em/yiA3eDlBgUEg9k6lxmt3Sp8ZgBN
         tG757cA6Y6FlpbqtBIt4O4376zYJfZfohqiZcMtWyF8Nsn8XkjgH979E/wkuiP9zXx6M
         xeNQ==
X-Gm-Message-State: AOAM530/dF0lwwbsGhV5mm+TUWAK7fx4ZTOuy6N/mF7kETLFF6Xf5yMN
        hcE9tRpS1yZL5JftTElM23g=
X-Google-Smtp-Source: ABdhPJyAMB+6G62oEcrfzb24DAgVNvD84uFYo9XA6NUaYrL1tECz8B9ZQEChkhePghU0D+aehqQc+g==
X-Received: by 2002:a17:90b:1287:: with SMTP id fw7mr7732879pjb.218.1597655840401;
        Mon, 17 Aug 2020 02:17:20 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:17:19 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        3chas3@gmail.com, axboe@kernel.dk, stefanr@s5r6.in-berlin.de,
        airlied@linux.ie, daniel@ffwll.ch, sre@kernel.org,
        James.Bottomley@HansenPartnership.com, kys@microsoft.com,
        deller@gmx.de, dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org
Cc:     keescook@chromium.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] driver: hv: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:45:58 +0530
Message-Id: <20200817091617.28119-4-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817091617.28119-1-allen.cryptic@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/hv/channel_mgmt.c | 3 +--
 drivers/hv/connection.c   | 4 ++--
 drivers/hv/hv.c           | 3 +--
 drivers/hv/hyperv_vmbus.h | 4 ++--
 drivers/hv/vmbus_drv.c    | 4 ++--
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 591106cf58fc..640fc1688d49 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -321,8 +321,7 @@ static struct vmbus_channel *alloc_channel(void)
 
 	INIT_LIST_HEAD(&channel->sc_list);
 
-	tasklet_init(&channel->callback_event,
-		     vmbus_on_event, (unsigned long)channel);
+	tasklet_setup(&channel->callback_event, vmbus_on_event);
 
 	hv_ringbuffer_pre_init(channel);
 
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 11170d9a2e1a..23e10ebecf5c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -322,9 +322,9 @@ struct vmbus_channel *relid2channel(u32 relid)
  *    If this tasklet has been running for a long time
  *    then reschedule ourselves.
  */
-void vmbus_on_event(unsigned long data)
+void vmbus_on_event(struct tasklet_struct *t)
 {
-	struct vmbus_channel *channel = (void *) data;
+	struct vmbus_channel *channel = from_tasklet(channel, t, callback_event);
 	unsigned long time_limit = jiffies + 2;
 
 	trace_vmbus_on_event(channel);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index da69338f92f5..91a0582387d6 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -96,8 +96,7 @@ int hv_synic_alloc(void)
 	for_each_present_cpu(cpu) {
 		hv_cpu = per_cpu_ptr(hv_context.cpu_context, cpu);
 
-		tasklet_init(&hv_cpu->msg_dpc,
-			     vmbus_on_msg_dpc, (unsigned long) hv_cpu);
+		tasklet_setup(&hv_cpu->msg_dpc, vmbus_on_msg_dpc);
 
 		hv_cpu->synic_message_page =
 			(void *)get_zeroed_page(GFP_ATOMIC);
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 40e2b9f91163..36199d8ea8c3 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -351,8 +351,8 @@ void vmbus_disconnect(void);
 
 int vmbus_post_msg(void *buffer, size_t buflen, bool can_sleep);
 
-void vmbus_on_event(unsigned long data);
-void vmbus_on_msg_dpc(unsigned long data);
+void vmbus_on_event(struct tasklet_struct *t);
+void vmbus_on_msg_dpc(struct tasklet_struct *t);
 
 int hv_kvp_init(struct hv_util_service *srv);
 void hv_kvp_deinit(void);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 910b6e90866c..6b7987dac97a 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1043,9 +1043,9 @@ static void vmbus_onmessage_work(struct work_struct *work)
 	kfree(ctx);
 }
 
-void vmbus_on_msg_dpc(unsigned long data)
+void vmbus_on_msg_dpc(struct tasklet_struct *t)
 {
-	struct hv_per_cpu_context *hv_cpu = (void *)data;
+	struct hv_per_cpu_context *hv_cpu = from_tasklet(hv_cpu, t, msg_dpc);
 	void *page_addr = hv_cpu->synic_message_page;
 	struct hv_message *msg = (struct hv_message *)page_addr +
 				  VMBUS_MESSAGE_SINT;
-- 
2.17.1

