Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E4524629D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgHQJSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHQJSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:18:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FECC061389;
        Mon, 17 Aug 2020 02:18:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mw10so7404090pjb.2;
        Mon, 17 Aug 2020 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8iiuS+8OFucIw2r/fyV659S9qkQpR1fU2fMqnkqqULY=;
        b=r2qSHXtqsSB4sV92dyEjaX7lKfzhdjAYx8gcgHHHqMq9IYJOSO63XvG1PpzrUfLXFM
         BgqfPrzHRwSm0vLEhz1HiQZHm1n5uy7J+2m+dxvrU6SN3D36VR05L86O+xWOtCiRsJY2
         74vbFP4rP6lJ8yOKD2MRI9bEC+5vH01ZU4jif6EShVMjoJbPa15PKhoBV5P67YUbXnA1
         5YdOO234Z7c67mz/OtbPHxGkaveV7lRoPkeJCf1B8+Kwn4P4Cz9EwQ8rmssyHhiO61Fc
         tCqUc0b64JEk2NvAzfFeU8rytJPV95oDEKW4CKIn/zo1Xc4ZAgNKcIlJJD5hL+H3UZ3x
         JzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8iiuS+8OFucIw2r/fyV659S9qkQpR1fU2fMqnkqqULY=;
        b=fI4Kl2pZI9lUKCfUIXP/zGbvx4bPvU6X+6DqO+HfFa2JKqi8f2yVgOKHrQW9jxbLi9
         eLR9TxJsMrIpqfx1WlW4Ev2K7bwsLS91z0oYNZQpKF6A6b0exPsLPmIlBC0agqM3Nwr4
         pJpxEV/NL0NHCZHB7HyFY1d4jNsYAEftvKwlXpLupgTrUWfssMhgG7iPJ+AAwLCy/xZv
         ejgk5PGPB9GyAJmyHFDp8NUQk4+orhm2z/32EtHcd1ihpEISsocLSJfhpDBMCI3OTY5w
         8RS5BEvFNDtXjA/HgCUoqsP5NozjA+omJkkMdlsWx5NexxpYd+Lje/of/q7Xfd6bQuiA
         j2EA==
X-Gm-Message-State: AOAM532k38dDcAZrw24DSrygKKLcXoVWHWhmjheJ3468M/GE/CQJYNW1
        RXjjmEk3Jrvh4YF5+E88QrQ=
X-Google-Smtp-Source: ABdhPJxkyCpJdWc/Irk1wdsgS5c88vULJPBB14OdmH93rwuUUuXbIr98oHHebEi/B5yuf7SKNGkv0Q==
X-Received: by 2002:a17:902:aa82:: with SMTP id d2mr10378151plr.12.1597655893005;
        Mon, 17 Aug 2020 02:18:13 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:18:12 -0700 (PDT)
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
Subject: [PATCH] drivers: s390: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:02 +0530
Message-Id: <20200817091617.28119-8-allen.cryptic@gmail.com>
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
 drivers/s390/block/dasd.c     | 18 ++++++++----------
 drivers/s390/char/con3215.c   |  6 +++---
 drivers/s390/char/con3270.c   |  7 +++----
 drivers/s390/char/tty3270.c   | 15 +++++++--------
 drivers/s390/cio/qdio.h       |  6 +++---
 drivers/s390/cio/qdio_main.c  | 12 ++++++------
 drivers/s390/cio/qdio_setup.c |  9 +++------
 drivers/s390/net/ctcm_main.c  |  8 +++-----
 drivers/s390/net/ctcm_mpc.c   | 16 ++++++++--------
 drivers/s390/net/ctcm_mpc.h   |  6 +++---
 10 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index eb17fea8075c..ec0d8a4ed05f 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -72,8 +72,8 @@ MODULE_LICENSE("GPL");
 static int  dasd_alloc_queue(struct dasd_block *);
 static void dasd_free_queue(struct dasd_block *);
 static int dasd_flush_block_queue(struct dasd_block *);
-static void dasd_device_tasklet(unsigned long);
-static void dasd_block_tasklet(unsigned long);
+static void dasd_device_tasklet(struct tasklet_struct *);
+static void dasd_block_tasklet(struct tasklet_struct *);
 static void do_kick_device(struct work_struct *);
 static void do_restore_device(struct work_struct *);
 static void do_reload_device(struct work_struct *);
@@ -133,8 +133,7 @@ struct dasd_device *dasd_alloc_device(void)
 	dasd_init_chunklist(&device->ese_chunks, device->ese_mem, PAGE_SIZE * 2);
 	spin_lock_init(&device->mem_lock);
 	atomic_set(&device->tasklet_scheduled, 0);
-	tasklet_init(&device->tasklet, dasd_device_tasklet,
-		     (unsigned long) device);
+	tasklet_setup(&device->tasklet, dasd_device_tasklet);
 	INIT_LIST_HEAD(&device->ccw_queue);
 	timer_setup(&device->timer, dasd_device_timeout, 0);
 	INIT_WORK(&device->kick_work, do_kick_device);
@@ -174,8 +173,7 @@ struct dasd_block *dasd_alloc_block(void)
 	atomic_set(&block->open_count, -1);
 
 	atomic_set(&block->tasklet_scheduled, 0);
-	tasklet_init(&block->tasklet, dasd_block_tasklet,
-		     (unsigned long) block);
+	tasklet_setup(&block->tasklet, dasd_block_tasklet);
 	INIT_LIST_HEAD(&block->ccw_queue);
 	spin_lock_init(&block->queue_lock);
 	INIT_LIST_HEAD(&block->format_list);
@@ -2187,9 +2185,9 @@ EXPORT_SYMBOL_GPL(dasd_flush_device_queue);
 /*
  * Acquire the device lock and process queues for the device.
  */
-static void dasd_device_tasklet(unsigned long data)
+static void dasd_device_tasklet(struct tasklet_struct *t)
 {
-	struct dasd_device *device = (struct dasd_device *) data;
+	struct dasd_device *device = from_tasklet(device, t, tasklet);
 	struct list_head final_queue;
 
 	atomic_set (&device->tasklet_scheduled, 0);
@@ -2929,9 +2927,9 @@ static void __dasd_block_start_head(struct dasd_block *block)
  * block layer request queue, creates ccw requests, enqueues them on
  * a dasd_device and processes ccw requests that have been returned.
  */
-static void dasd_block_tasklet(unsigned long data)
+static void dasd_block_tasklet(struct tasklet_struct *t)
 {
-	struct dasd_block *block = (struct dasd_block *) data;
+	struct dasd_block *block = from_tasklet(block, t, tasklet);
 	struct list_head final_queue;
 	struct list_head *l, *n;
 	struct dasd_ccw_req *cqr;
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 92757f9bd010..ab5964cffb91 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -334,9 +334,9 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 /*
  * Call tty_wakeup from tasklet context
  */
-static void raw3215_wakeup(unsigned long data)
+static void raw3215_wakeup(struct tasklet_struct *t)
 {
-	struct raw3215_info *raw = (struct raw3215_info *) data;
+	struct raw3215_info *raw = from_tasklet(raw, t, tlet);
 	struct tty_struct *tty;
 
 	tty = tty_port_tty_get(&raw->port);
@@ -673,7 +673,7 @@ static struct raw3215_info *raw3215_alloc_info(void)
 
 	timer_setup(&info->timer, raw3215_timeout, 0);
 	init_waitqueue_head(&info->empty_wait);
-	tasklet_init(&info->tlet, raw3215_wakeup, (unsigned long)info);
+	tasklet_setup(&info->tlet, raw3215_wakeup);
 	tty_port_init(&info->port);
 
 	return info;
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index e17364e13d2f..02de4281d5b7 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -291,8 +291,9 @@ con3270_update(struct timer_list *t)
  * Read tasklet.
  */
 static void
-con3270_read_tasklet(struct raw3270_request *rrq)
+con3270_read_tasklet(struct tasklet_struct *t)
 {
+	struct raw3270_request *rrq = condev->read;
 	static char kreset_data = TW_KR;
 	struct con3270 *cp;
 	unsigned long flags;
@@ -625,9 +626,7 @@ con3270_init(void)
 	INIT_LIST_HEAD(&condev->lines);
 	INIT_LIST_HEAD(&condev->update);
 	timer_setup(&condev->timer, con3270_update, 0);
-	tasklet_init(&condev->readlet, 
-		     (void (*)(unsigned long)) con3270_read_tasklet,
-		     (unsigned long) condev->read);
+	tasklet_setup(&condev->readlet, con3270_read_tasklet);
 
 	raw3270_add_view(&condev->view, &con3270_fn, 1, RAW3270_VIEW_LOCK_IRQ);
 
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index aec996de44d9..fa8040e3840d 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -556,9 +556,10 @@ tty3270_scroll_backward(struct kbd_data *kbd)
  * Pass input line to tty.
  */
 static void
-tty3270_read_tasklet(unsigned long data)
+tty3270_read_tasklet(struct tasklet_struct *t)
 {
-	struct raw3270_request *rrq = (struct raw3270_request *)data;
+	struct tty3270 *tp = from_tasklet(tp, t, readlet)
+	struct raw3270_request *rrq = tp->read;
 	static char kreset_data = TW_KR;
 	struct tty3270 *tp = container_of(rrq->view, struct tty3270, view);
 	char *input;
@@ -653,9 +654,9 @@ tty3270_issue_read(struct tty3270 *tp, int lock)
  * Hang up the tty
  */
 static void
-tty3270_hangup_tasklet(unsigned long data)
+tty3270_hangup_tasklet(struct tasklet_struct *t)
 {
-	struct tty3270 *tp = (struct tty3270 *)data;
+	struct tty3270 *tp = from_tasklet(tp, t, hanglet);
 	tty_port_tty_hangup(&tp->port, true);
 	raw3270_put_view(&tp->view);
 }
@@ -754,10 +755,8 @@ tty3270_alloc_view(void)
 
 	tty_port_init(&tp->port);
 	timer_setup(&tp->timer, tty3270_update, 0);
-	tasklet_init(&tp->readlet, tty3270_read_tasklet,
-		     (unsigned long) tp->read);
-	tasklet_init(&tp->hanglet, tty3270_hangup_tasklet,
-		     (unsigned long) tp);
+	tasklet_setup(&tp->readlet, tty3270_read_tasklet);
+	tasklet_setup(&tp->hanglet, tty3270_hangup_tasklet);
 	INIT_WORK(&tp->resize_work, tty3270_resize_work);
 
 	return tp;
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index cd2df4ff8e0e..ac845a1002f0 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -359,14 +359,14 @@ int qdio_establish_thinint(struct qdio_irq *irq_ptr);
 void qdio_shutdown_thinint(struct qdio_irq *irq_ptr);
 void tiqdio_add_device(struct qdio_irq *irq_ptr);
 void tiqdio_remove_device(struct qdio_irq *irq_ptr);
-void tiqdio_inbound_processing(unsigned long q);
+void tiqdio_inbound_processing(struct tasklet_struct *t);
 int qdio_thinint_init(void);
 void qdio_thinint_exit(void);
 int test_nonshared_ind(struct qdio_irq *);
 
 /* prototypes for setup */
-void qdio_inbound_processing(unsigned long data);
-void qdio_outbound_processing(unsigned long data);
+void qdio_inbound_processing(struct tasklet_struct *t);
+void qdio_outbound_processing(struct tasklet_struct *t);
 void qdio_outbound_timer(struct timer_list *t);
 void qdio_int_handler(struct ccw_device *cdev, unsigned long intparm,
 		      struct irb *irb);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 4fab8bba2cdd..b6ae13c5220f 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -634,9 +634,9 @@ static void __qdio_inbound_processing(struct qdio_q *q)
 	}
 }
 
-void qdio_inbound_processing(unsigned long data)
+void qdio_inbound_processing(struct tasklet_struct *t)
 {
-	struct qdio_q *q = (struct qdio_q *)data;
+	struct qdio_q *q = from_tasklet(q, t, tasklet);
 	__qdio_inbound_processing(q);
 }
 
@@ -801,9 +801,9 @@ static void __qdio_outbound_processing(struct qdio_q *q)
 }
 
 /* outbound tasklet */
-void qdio_outbound_processing(unsigned long data)
+void qdio_outbound_processing(struct tasklet_struct *t)
 {
-	struct qdio_q *q = (struct qdio_q *)data;
+	struct qdio_q *q = from_tasklet(q, t, tasklet);
 	__qdio_outbound_processing(q);
 }
 
@@ -827,9 +827,9 @@ static inline void qdio_check_outbound_pci_queues(struct qdio_irq *irq)
 			qdio_tasklet_schedule(out);
 }
 
-void tiqdio_inbound_processing(unsigned long data)
+void tiqdio_inbound_processing(struct tasklet_struct *t)
 {
-	struct qdio_q *q = (struct qdio_q *)data;
+	struct qdio_q *q = from_tasklet(q, t, tasklet);
 
 	if (need_siga_sync(q) && need_siga_sync_after_ai(q))
 		qdio_sync_queues(q);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 2c5cc6ec668e..cc80c37ba2e2 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -259,11 +259,9 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 				    qdio_init->input_sbal_addr_array[i], i);
 
 		if (is_thinint_irq(irq_ptr)) {
-			tasklet_init(&q->tasklet, tiqdio_inbound_processing,
-				     (unsigned long) q);
+			tasklet_setup(&q->tasklet, tiqdio_inbound_processing);
 		} else {
-			tasklet_init(&q->tasklet, qdio_inbound_processing,
-				     (unsigned long) q);
+			tasklet_setup(&q->tasklet, qdio_inbound_processing);
 		}
 	}
 
@@ -278,8 +276,7 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		setup_storage_lists(q, irq_ptr,
 				    qdio_init->output_sbal_addr_array[i], i);
 
-		tasklet_init(&q->tasklet, qdio_outbound_processing,
-			     (unsigned long) q);
+		tasklet_setup(&q->tasklet, qdio_outbound_processing);
 		timer_setup(&q->u.out.timer, qdio_outbound_timer, 0);
 	}
 }
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index d06809eac16d..475ee3bcf3ae 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1165,8 +1165,7 @@ static struct net_device *ctcm_init_netdevice(struct ctcm_priv *priv)
 			free_netdev(dev);
 			return NULL;
 		}
-		tasklet_init(&grp->mpc_tasklet2,
-				mpc_group_ready, (unsigned long)dev);
+		tasklet_setup(&grp->mpc_tasklet2, mpc_group_ready);
 		dev->mtu = MPC_BUFSIZE_DEFAULT -
 				TH_HEADER_LENGTH - PDU_HEADER_LENGTH;
 
@@ -1366,10 +1365,9 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 					goto nomem_return;
 
 		ch->discontact_th->th_blk_flag = TH_DISCONTACT;
-		tasklet_init(&ch->ch_disc_tasklet,
-			mpc_action_send_discontact, (unsigned long)ch);
+		tasklet_setup(&ch->ch_disc_tasklet, mpc_action_send_discontact);
 
-		tasklet_init(&ch->ch_tasklet, ctcmpc_bh, (unsigned long)ch);
+		tasklet_setup(&ch->ch_tasklet, ctcmpc_bh);
 		ch->max_bufsize = (MPC_BUFSIZE_DEFAULT - 35);
 		ccw_num = 17;
 	} else
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index ab316baa8284..049b6ca0789f 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -870,11 +870,11 @@ static void mpc_action_go_ready(fsm_instance *fsm, int event, void *arg)
  * helper of ctcm_init_netdevice
  * CTCM_PROTO_MPC only
  */
-void mpc_group_ready(unsigned long adev)
+void mpc_group_ready(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)adev;
-	struct ctcm_priv *priv = dev->ml_priv;
-	struct mpc_group *grp = priv->mpcg;
+	struct mpc_group *grp = from_tasklet(grp, t, mpc_tasklet2);
+	struct ctcm_priv *priv = container_of(grp, typeof(*priv), mpcg);
+	struct net_device *dev = container_of(priv, typeof(*dev), ml_priv);
 	struct channel *ch = NULL;
 
 	if (grp == NULL) {
@@ -1233,9 +1233,9 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
  * Throttling back channel can result in excessive
  * channel inactivity and system deact of channel
  */
-void ctcmpc_bh(unsigned long thischan)
+void ctcmpc_bh(struct tasklet_struct *t)
 {
-	struct channel	  *ch	= (struct channel *)thischan;
+	struct channel	  *ch	= from_tasklet(ch, t, ch_tasklet);
 	struct sk_buff	  *skb;
 	struct net_device *dev	= ch->netdev;
 	struct ctcm_priv  *priv	= dev->ml_priv;
@@ -1516,10 +1516,10 @@ void mpc_action_discontact(fsm_instance *fi, int event, void *arg)
  * CTCM_PROTO_MPC only
  * called from add_channel in ctcm_main.c
  */
-void mpc_action_send_discontact(unsigned long thischan)
+void mpc_action_send_discontact(struct tasklet_struct *t)
 {
 	int rc;
-	struct channel	*ch = (struct channel *)thischan;
+	struct channel	*ch = from_tasklet(ch, t, ch_disc_tasklet);
 	unsigned long	saveflags = 0;
 
 	spin_lock_irqsave(get_ccwdev_lock(ch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_mpc.h b/drivers/s390/net/ctcm_mpc.h
index 441d7b211f0f..80c772326178 100644
--- a/drivers/s390/net/ctcm_mpc.h
+++ b/drivers/s390/net/ctcm_mpc.h
@@ -230,10 +230,10 @@ static inline void ctcmpc_dump32(char *buf, int len)
 
 int ctcmpc_open(struct net_device *);
 void ctcm_ccw_check_rc(struct channel *, int, char *);
-void mpc_group_ready(unsigned long adev);
+void mpc_group_ready(struct tasklet_struct *t);
 void mpc_channel_action(struct channel *ch, int direction, int action);
-void mpc_action_send_discontact(unsigned long thischan);
+void mpc_action_send_discontact(struct tasklet_struct *t);
 void mpc_action_discontact(fsm_instance *fi, int event, void *arg);
-void ctcmpc_bh(unsigned long thischan);
+void ctcmpc_bh(struct tasklet_struct *t);
 #endif
 /* --- This is the END my friend --- */
-- 
2.17.1

