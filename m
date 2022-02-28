Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5DE4C69A6
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiB1LJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbiB1LJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:09:47 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C09E6D19F;
        Mon, 28 Feb 2022 03:09:05 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a8so23988290ejc.8;
        Mon, 28 Feb 2022 03:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/5quqOjERgpaLKhO9koLny9BvK2Guyp7o09OFP+qhk=;
        b=Ljwj8CnCu08+RTBUQRqorDQQ+wiNmlIGsz3U/nnp6kMNRqGuAXnG9Q6leP6tXHDKBs
         fC0yazGNKWyeN+wPndl0AwJBJjl3N5MSoQlJglKrLr4aNyim+n0aoU6pzG44RGDzV8tS
         aG42rnsd+TKEbfy7svaitReUGoM/zzdHisrdyvZxERwDa+xrj0C9tqSkxivCQtQDhvOR
         cY/MDCd7L/q4oGWKRE83MJYFK8mCGpQLh0XumiTfxsV1hBvR9+XtdqkDS4/dlW+DnafQ
         n7P+MIT1RQEl6NQJ5YycAPgdWCiE4bZZcLNrflMTEWNc53o2geouTdG9p/cA6OEa9F2n
         u52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/5quqOjERgpaLKhO9koLny9BvK2Guyp7o09OFP+qhk=;
        b=40hY2WZzw1lBH0tD2wGi+/q2AYblMXcHyuSDlATVSCg9yiOwaAJ0CHTz/lOpOyssVh
         krb9stb79wskPN0a+RRqXWgYAliGwqix3KAgF7XvFzB/NN+FbaUk1GL84gmEO+Z0r9Zc
         lYHdMdrE8EyX6MIvgcWtrgCnmpI5dmLamP35vYgh+9NXFUEn7sO0rdhJXCIvQzs+cFcI
         qUQX+JY41ElfP25TP2yraBvAZQbM3PFl7q9LbEHQymV/KmWgXQEhG2fHj+WIcR22/DQe
         74xyamzrkDmxeR2HhCJgflntTcynJa8AQD+3X0XyvZ7/4EaZiQSC3fW+jUScXkKHGkim
         V4/w==
X-Gm-Message-State: AOAM532Qm/n/NNYNejukldWLlizjySFGyPJWagO59LtGb5U/0UgYTtTI
        5gBlnsyb8Pbh7SdAGRQLwqw=
X-Google-Smtp-Source: ABdhPJxYUMoMtHDVd3+C781Z5K30UFuCgwF8Xm/LUfk3yXcsAMeYeL8EFet8/lNHBWDnsG9EgCKV7Q==
X-Received: by 2002:a17:906:814d:b0:6cd:eb64:2a11 with SMTP id z13-20020a170906814d00b006cdeb642a11mr14816272ejw.763.1646046543182;
        Mon, 28 Feb 2022 03:09:03 -0800 (PST)
Received: from localhost.localdomain (dhcp-077-250-038-153.chello.nl. [77.250.38.153])
        by smtp.googlemail.com with ESMTPSA id z22-20020a17090655d600b006d229436793sm4209049ejp.223.2022.02.28.03.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 03:09:02 -0800 (PST)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: [PATCH 6/6] treewide: remove check of list iterator against head past the loop body
Date:   Mon, 28 Feb 2022 12:08:22 +0100
Message-Id: <20220228110822.491923-7-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228110822.491923-1-jakobkoschel@gmail.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When list_for_each_entry() completes the iteration over the whole list
without breaking the loop, the iterator value will be a bogus pointer
computed based on the head element.

While it is safe to use the pointer to determine if it was computed
based on the head element, either with list_entry_is_head() or
&pos->member == head, using the iterator variable after the loop should
be avoided.

In preparation to limiting the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 arch/arm/mach-mmp/sram.c                      |  9 ++--
 arch/arm/plat-pxa/ssp.c                       | 28 +++++-------
 drivers/block/drbd/drbd_req.c                 | 45 ++++++++++++-------
 drivers/counter/counter-chrdev.c              | 26 ++++++-----
 drivers/crypto/cavium/nitrox/nitrox_main.c    | 11 +++--
 drivers/dma/ppc4xx/adma.c                     | 11 +++--
 drivers/firewire/core-transaction.c           | 32 +++++++------
 drivers/firewire/sbp2.c                       | 14 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c        | 19 +++++---
 drivers/gpu/drm/drm_memory.c                  | 15 ++++---
 drivers/gpu/drm/drm_mm.c                      | 17 ++++---
 drivers/gpu/drm/drm_vm.c                      | 13 +++---
 drivers/gpu/drm/gma500/oaktrail_lvds.c        |  9 ++--
 drivers/gpu/drm/i915/gem/i915_gem_context.c   | 14 +++---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 15 ++++---
 drivers/gpu/drm/i915/gt/intel_ring.c          | 15 ++++---
 .../gpu/drm/nouveau/nvkm/subdev/fb/ramgk104.c | 13 +++---
 drivers/gpu/drm/scheduler/sched_main.c        | 14 +++---
 drivers/gpu/drm/ttm/ttm_bo.c                  | 19 ++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c           | 22 +++++----
 drivers/infiniband/hw/hfi1/tid_rdma.c         | 16 ++++---
 drivers/infiniband/hw/mlx4/main.c             | 12 ++---
 drivers/media/dvb-frontends/mxl5xx.c          | 11 +++--
 drivers/media/v4l2-core/v4l2-ctrls-api.c      | 31 +++++++------
 drivers/misc/mei/interrupt.c                  | 12 ++---
 .../net/ethernet/qlogic/qede/qede_filter.c    | 11 +++--
 .../net/wireless/intel/ipw2x00/libipw_rx.c    | 15 ++++---
 drivers/power/supply/cpcap-battery.c          | 11 +++--
 drivers/scsi/lpfc/lpfc_bsg.c                  | 16 ++++---
 drivers/staging/rtl8192e/rtl819x_TSProc.c     | 17 +++----
 drivers/staging/rtl8192e/rtllib_rx.c          | 17 ++++---
 .../staging/rtl8192u/ieee80211/ieee80211_rx.c | 15 ++++---
 .../rtl8192u/ieee80211/rtl819x_TSProc.c       | 19 ++++----
 drivers/usb/gadget/composite.c                |  9 ++--
 fs/cifs/smb2misc.c                            | 10 +++--
 fs/proc/kcore.c                               | 13 +++---
 kernel/debug/kdb/kdb_main.c                   | 36 +++++++++------
 kernel/power/snapshot.c                       | 10 +++--
 kernel/trace/ftrace.c                         | 22 +++++----
 kernel/trace/trace_eprobe.c                   | 15 ++++---
 kernel/trace/trace_events.c                   | 11 ++---
 net/9p/trans_xen.c                            | 11 +++--
 net/ipv4/udp_tunnel_nic.c                     | 10 +++--
 net/tipc/name_table.c                         | 11 +++--
 net/tipc/socket.c                             | 11 +++--
 net/xfrm/xfrm_ipcomp.c                        | 11 +++--
 sound/soc/intel/catpt/pcm.c                   | 13 +++---
 sound/soc/sprd/sprd-mcdt.c                    | 13 +++---
 48 files changed, 455 insertions(+), 315 deletions(-)

diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
index 6794e2db1ad5..fc47c107059b 100644
--- a/arch/arm/mach-mmp/sram.c
+++ b/arch/arm/mach-mmp/sram.c
@@ -39,19 +39,22 @@ static LIST_HEAD(sram_bank_list);
 struct gen_pool *sram_get_gpool(char *pool_name)
 {
 	struct sram_bank_info *info = NULL;
+	struct sram_bank_info *tmp;

 	if (!pool_name)
 		return NULL;

 	mutex_lock(&sram_lock);

-	list_for_each_entry(info, &sram_bank_list, node)
-		if (!strcmp(pool_name, info->pool_name))
+	list_for_each_entry(tmp, &sram_bank_list, node)
+		if (!strcmp(pool_name, tmp->pool_name)) {
+			info = tmp;
 			break;
+		}

 	mutex_unlock(&sram_lock);

-	if (&info->node == &sram_bank_list)
+	if (!info)
 		return NULL;

 	return info->gpool;
diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index 563440315acd..4884a8c0c89b 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -38,22 +38,20 @@ static LIST_HEAD(ssp_list);
 struct ssp_device *pxa_ssp_request(int port, const char *label)
 {
 	struct ssp_device *ssp = NULL;
+	struct ssp_device *tmp;

 	mutex_lock(&ssp_lock);

-	list_for_each_entry(ssp, &ssp_list, node) {
-		if (ssp->port_id == port && ssp->use_count == 0) {
-			ssp->use_count++;
-			ssp->label = label;
+	list_for_each_entry(tmp, &ssp_list, node) {
+		if (tmp->port_id == port && tmp->use_count == 0) {
+			tmp->use_count++;
+			tmp->label = label;
+			ssp = tmp;
 			break;
 		}
 	}

 	mutex_unlock(&ssp_lock);
-
-	if (&ssp->node == &ssp_list)
-		return NULL;
-
 	return ssp;
 }
 EXPORT_SYMBOL(pxa_ssp_request);
@@ -62,22 +60,20 @@ struct ssp_device *pxa_ssp_request_of(const struct device_node *of_node,
 				      const char *label)
 {
 	struct ssp_device *ssp = NULL;
+	struct ssp_device *tmp;

 	mutex_lock(&ssp_lock);

-	list_for_each_entry(ssp, &ssp_list, node) {
-		if (ssp->of_node == of_node && ssp->use_count == 0) {
-			ssp->use_count++;
-			ssp->label = label;
+	list_for_each_entry(tmp, &ssp_list, node) {
+		if (tmp->of_node == of_node && tmp->use_count == 0) {
+			tmp->use_count++;
+			tmp->label = label;
+			ssp = tmp;
 			break;
 		}
 	}

 	mutex_unlock(&ssp_lock);
-
-	if (&ssp->node == &ssp_list)
-		return NULL;
-
 	return ssp;
 }
 EXPORT_SYMBOL(pxa_ssp_request_of);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3235532ae077..ee7ee8b657bd 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -332,17 +332,22 @@ static void set_if_null_req_next(struct drbd_peer_device *peer_device, struct dr
 static void advance_conn_req_next(struct drbd_peer_device *peer_device, struct drbd_request *req)
 {
 	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	struct drbd_request *tmp;
 	if (!connection)
 		return;
 	if (connection->req_next != req)
 		return;
-	list_for_each_entry_continue(req, &connection->transfer_log, tl_requests) {
-		const unsigned s = req->rq_state;
-		if (s & RQ_NET_QUEUED)
+
+	tmp = req;
+	req = NULL;
+	list_for_each_entry_continue(tmp, &connection->transfer_log, tl_requests) {
+		const unsigned int s = tmp->rq_state;
+
+		if (s & RQ_NET_QUEUED) {
+			req = tmp;
 			break;
+		}
 	}
-	if (&req->tl_requests == &connection->transfer_log)
-		req = NULL;
 	connection->req_next = req;
 }

@@ -358,17 +363,22 @@ static void set_if_null_req_ack_pending(struct drbd_peer_device *peer_device, st
 static void advance_conn_req_ack_pending(struct drbd_peer_device *peer_device, struct drbd_request *req)
 {
 	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	struct drbd_request *tmp;
 	if (!connection)
 		return;
 	if (connection->req_ack_pending != req)
 		return;
-	list_for_each_entry_continue(req, &connection->transfer_log, tl_requests) {
-		const unsigned s = req->rq_state;
-		if ((s & RQ_NET_SENT) && (s & RQ_NET_PENDING))
+
+	tmp = req;
+	req = NULL;
+	list_for_each_entry_continue(tmp, &connection->transfer_log, tl_requests) {
+		const unsigned int s = tmp->rq_state;
+
+		if ((s & RQ_NET_SENT) && (s & RQ_NET_PENDING)) {
+			req = tmp;
 			break;
+		}
 	}
-	if (&req->tl_requests == &connection->transfer_log)
-		req = NULL;
 	connection->req_ack_pending = req;
 }

@@ -384,17 +394,22 @@ static void set_if_null_req_not_net_done(struct drbd_peer_device *peer_device, s
 static void advance_conn_req_not_net_done(struct drbd_peer_device *peer_device, struct drbd_request *req)
 {
 	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	struct drbd_request *tmp;
 	if (!connection)
 		return;
 	if (connection->req_not_net_done != req)
 		return;
-	list_for_each_entry_continue(req, &connection->transfer_log, tl_requests) {
-		const unsigned s = req->rq_state;
-		if ((s & RQ_NET_SENT) && !(s & RQ_NET_DONE))
+
+	tmp = req;
+	req = NULL;
+	list_for_each_entry_continue(tmp, &connection->transfer_log, tl_requests) {
+		const unsigned int s = tmp->rq_state;
+
+		if ((s & RQ_NET_SENT) && !(s & RQ_NET_DONE)) {
+			req = tmp;
 			break;
+		}
 	}
-	if (&req->tl_requests == &connection->transfer_log)
-		req = NULL;
 	connection->req_not_net_done = req;
 }

diff --git a/drivers/counter/counter-chrdev.c b/drivers/counter/counter-chrdev.c
index b7c62f957a6a..6548dd9f02ac 100644
--- a/drivers/counter/counter-chrdev.c
+++ b/drivers/counter/counter-chrdev.c
@@ -131,18 +131,21 @@ static int counter_set_event_node(struct counter_device *const counter,
 				  struct counter_watch *const watch,
 				  const struct counter_comp_node *const cfg)
 {
-	struct counter_event_node *event_node;
+	struct counter_event_node *event_node = NULL;
+	struct counter_event_node *tmp;
 	int err = 0;
 	struct counter_comp_node *comp_node;

 	/* Search for event in the list */
-	list_for_each_entry(event_node, &counter->next_events_list, l)
-		if (event_node->event == watch->event &&
-		    event_node->channel == watch->channel)
+	list_for_each_entry(tmp, &counter->next_events_list, l)
+		if (tmp->event == watch->event &&
+		    tmp->channel == watch->channel) {
+			event_node = tmp;
 			break;
+		}

 	/* If event is not already in the list */
-	if (&event_node->l == &counter->next_events_list) {
+	if (!event_node) {
 		/* Allocate new event node */
 		event_node = kmalloc(sizeof(*event_node), GFP_KERNEL);
 		if (!event_node)
@@ -535,7 +538,8 @@ void counter_push_event(struct counter_device *const counter, const u8 event,
 	struct counter_event ev;
 	unsigned int copied = 0;
 	unsigned long flags;
-	struct counter_event_node *event_node;
+	struct counter_event_node *event_node = NULL;
+	struct counter_event_node *tmp;
 	struct counter_comp_node *comp_node;

 	ev.timestamp = ktime_get_ns();
@@ -546,13 +550,15 @@ void counter_push_event(struct counter_device *const counter, const u8 event,
 	spin_lock_irqsave(&counter->events_list_lock, flags);

 	/* Search for event in the list */
-	list_for_each_entry(event_node, &counter->events_list, l)
-		if (event_node->event == event &&
-		    event_node->channel == channel)
+	list_for_each_entry(tmp, &counter->events_list, l)
+		if (tmp->event == event &&
+		    tmp->channel == channel) {
+			event_node = tmp;
 			break;
+		}

 	/* If event is not in the list */
-	if (&event_node->l == &counter->events_list)
+	if (!event_node)
 		goto exit_early;

 	/* Read and queue relevant comp for userspace */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 6c61817996a3..a003659bf66f 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -269,15 +269,18 @@ static void nitrox_remove_from_devlist(struct nitrox_device *ndev)

 struct nitrox_device *nitrox_get_first_device(void)
 {
-	struct nitrox_device *ndev;
+	struct nitrox_device *ndev = NULL;
+	struct nitrox_device *tmp;

 	mutex_lock(&devlist_lock);
-	list_for_each_entry(ndev, &ndevlist, list) {
-		if (nitrox_ready(ndev))
+	list_for_each_entry(tmp, &ndevlist, list) {
+		if (nitrox_ready(tmp)) {
+			ndev = tmp;
 			break;
+		}
 	}
 	mutex_unlock(&devlist_lock);
-	if (&ndev->list == &ndevlist)
+	if (!ndev)
 		return NULL;

 	refcount_inc(&ndev->refcnt);
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 5e46e347e28b..542286e1f0cf 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -935,23 +935,26 @@ static void ppc440spe_adma_device_clear_eot_status(
 			if (rv & DMA_CDB_STATUS_MSK) {
 				/* ZeroSum check failed
 				 */
-				struct ppc440spe_adma_desc_slot *iter;
+				struct ppc440spe_adma_desc_slot *iter = NULL;
+				struct ppc440spe_adma_desc_slot *tmp;
 				dma_addr_t phys = rv & ~DMA_CDB_MSK;

 				/*
 				 * Update the status of corresponding
 				 * descriptor.
 				 */
-				list_for_each_entry(iter, &chan->chain,
+				list_for_each_entry(tmp, &chan->chain,
 				    chain_node) {
-					if (iter->phys == phys)
+					if (tmp->phys == phys) {
+						iter = tmp;
 						break;
+					}
 				}
 				/*
 				 * if cannot find the corresponding
 				 * slot it's a bug
 				 */
-				BUG_ON(&iter->chain_node == &chan->chain);
+				BUG_ON(!iter);

 				if (iter->xor_check_result) {
 					if (test_bit(PPC440SPE_DESC_PCHECK,
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index ac487c96bb71..870cbfb84f4f 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -73,24 +73,26 @@ static int try_cancel_split_timeout(struct fw_transaction *t)
 static int close_transaction(struct fw_transaction *transaction,
 			     struct fw_card *card, int rcode)
 {
-	struct fw_transaction *t;
+	struct fw_transaction *t = NULL;
+	struct fw_transaction *tmp;
 	unsigned long flags;

 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(t, &card->transaction_list, link) {
-		if (t == transaction) {
-			if (!try_cancel_split_timeout(t)) {
+	list_for_each_entry(tmp, &card->transaction_list, link) {
+		if (tmp == transaction) {
+			if (!try_cancel_split_timeout(tmp)) {
 				spin_unlock_irqrestore(&card->lock, flags);
 				goto timed_out;
 			}
-			list_del_init(&t->link);
-			card->tlabel_mask &= ~(1ULL << t->tlabel);
+			list_del_init(&tmp->link);
+			card->tlabel_mask &= ~(1ULL << tmp->tlabel);
+			t = tmp;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&card->lock, flags);

-	if (&t->link != &card->transaction_list) {
+	if (t) {
 		t->callback(card, rcode, NULL, 0, t->callback_data);
 		return 0;
 	}
@@ -935,7 +937,8 @@ EXPORT_SYMBOL(fw_core_handle_request);

 void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 {
-	struct fw_transaction *t;
+	struct fw_transaction *t = NULL;
+	struct fw_transaction *tmp;
 	unsigned long flags;
 	u32 *data;
 	size_t data_length;
@@ -947,20 +950,21 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 	rcode	= HEADER_GET_RCODE(p->header[1]);

 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(t, &card->transaction_list, link) {
-		if (t->node_id == source && t->tlabel == tlabel) {
-			if (!try_cancel_split_timeout(t)) {
+	list_for_each_entry(tmp, &card->transaction_list, link) {
+		if (tmp->node_id == source && tmp->tlabel == tlabel) {
+			if (!try_cancel_split_timeout(tmp)) {
 				spin_unlock_irqrestore(&card->lock, flags);
 				goto timed_out;
 			}
-			list_del_init(&t->link);
-			card->tlabel_mask &= ~(1ULL << t->tlabel);
+			list_del_init(&tmp->link);
+			card->tlabel_mask &= ~(1ULL << tmp->tlabel);
+			t = tmp;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&card->lock, flags);

-	if (&t->link == &card->transaction_list) {
+	if (!t) {
  timed_out:
 		fw_notice(card, "unsolicited response (source %x, tlabel %x)\n",
 			  source, tlabel);
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 85cd379fd383..d01aabda7cad 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -408,7 +408,8 @@ static void sbp2_status_write(struct fw_card *card, struct fw_request *request,
 			      void *payload, size_t length, void *callback_data)
 {
 	struct sbp2_logical_unit *lu = callback_data;
-	struct sbp2_orb *orb;
+	struct sbp2_orb *orb = NULL;
+	struct sbp2_orb *tmp;
 	struct sbp2_status status;
 	unsigned long flags;

@@ -433,17 +434,18 @@ static void sbp2_status_write(struct fw_card *card, struct fw_request *request,

 	/* Lookup the orb corresponding to this status write. */
 	spin_lock_irqsave(&lu->tgt->lock, flags);
-	list_for_each_entry(orb, &lu->orb_list, link) {
+	list_for_each_entry(tmp, &lu->orb_list, link) {
 		if (STATUS_GET_ORB_HIGH(status) == 0 &&
-		    STATUS_GET_ORB_LOW(status) == orb->request_bus) {
-			orb->rcode = RCODE_COMPLETE;
-			list_del(&orb->link);
+		    STATUS_GET_ORB_LOW(status) == tmp->request_bus) {
+			tmp->rcode = RCODE_COMPLETE;
+			list_del(&tmp->link);
+			orb = tmp;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&lu->tgt->lock, flags);

-	if (&orb->link != &lu->orb_list) {
+	if (orb) {
 		orb->callback(orb, &status);
 		kref_put(&orb->kref, free_orb); /* orb callback reference */
 	} else {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index b37fc7d7d2c7..8b38e2fb0674 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2444,26 +2444,31 @@ int amdgpu_vm_bo_unmap(struct amdgpu_device *adev,
 		       struct amdgpu_bo_va *bo_va,
 		       uint64_t saddr)
 {
-	struct amdgpu_bo_va_mapping *mapping;
+	struct amdgpu_bo_va_mapping *mapping = NULL;
+	struct amdgpu_bo_va_mapping *tmp;
 	struct amdgpu_vm *vm = bo_va->base.vm;
 	bool valid = true;

 	saddr /= AMDGPU_GPU_PAGE_SIZE;

-	list_for_each_entry(mapping, &bo_va->valids, list) {
-		if (mapping->start == saddr)
+	list_for_each_entry(tmp, &bo_va->valids, list) {
+		if (tmp->start == saddr) {
+			mapping = tmp;
 			break;
+		}
 	}

-	if (&mapping->list == &bo_va->valids) {
+	if (!mapping) {
 		valid = false;

-		list_for_each_entry(mapping, &bo_va->invalids, list) {
-			if (mapping->start == saddr)
+		list_for_each_entry(tmp, &bo_va->invalids, list) {
+			if (tmp->start == saddr) {
+				mapping = tmp;
 				break;
+			}
 		}

-		if (&mapping->list == &bo_va->invalids)
+		if (!mapping)
 			return -ENOENT;
 	}

diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index d2e1dccd8113..99ddb7ad9eb7 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -60,7 +60,8 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 {
 	unsigned long i, num_pages =
 	    PAGE_ALIGN(size) / PAGE_SIZE;
-	struct drm_agp_mem *agpmem;
+	struct drm_agp_mem *agpmem = NULL;
+	struct drm_agp_mem *tmp;
 	struct page **page_map;
 	struct page **phys_page_map;
 	void *addr;
@@ -71,12 +72,14 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 	offset -= dev->hose->mem_space->start;
 #endif

-	list_for_each_entry(agpmem, &dev->agp->memory, head)
-		if (agpmem->bound <= offset
-		    && (agpmem->bound + (agpmem->pages << PAGE_SHIFT)) >=
-		    (offset + size))
+	list_for_each_entry(tmp, &dev->agp->memory, head)
+		if (tmp->bound <= offset
+		    && (tmp->bound + (tmp->pages << PAGE_SHIFT)) >=
+		    (offset + size)) {
+			agpmem = tmp;
 			break;
-	if (&agpmem->head == &dev->agp->memory)
+		}
+	if (!agpmem)
 		return NULL;

 	/*
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 8257f9d4f619..0124e8dfa134 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -912,7 +912,8 @@ EXPORT_SYMBOL(drm_mm_scan_remove_block);
 struct drm_mm_node *drm_mm_scan_color_evict(struct drm_mm_scan *scan)
 {
 	struct drm_mm *mm = scan->mm;
-	struct drm_mm_node *hole;
+	struct drm_mm_node *hole = NULL;
+	struct drm_mm_node *tmp;
 	u64 hole_start, hole_end;

 	DRM_MM_BUG_ON(list_empty(&mm->hole_stack));
@@ -925,18 +926,20 @@ struct drm_mm_node *drm_mm_scan_color_evict(struct drm_mm_scan *scan)
 	 * in the hole_stack list, but due to side-effects in the driver it
 	 * may not be.
 	 */
-	list_for_each_entry(hole, &mm->hole_stack, hole_stack) {
-		hole_start = __drm_mm_hole_node_start(hole);
-		hole_end = hole_start + hole->hole_size;
+	list_for_each_entry(tmp, &mm->hole_stack, hole_stack) {
+		hole_start = __drm_mm_hole_node_start(tmp);
+		hole_end = hole_start + tmp->hole_size;

 		if (hole_start <= scan->hit_start &&
-		    hole_end >= scan->hit_end)
+		    hole_end >= scan->hit_end) {
+			hole = tmp;
 			break;
+		}
 	}

 	/* We should only be called after we found the hole previously */
-	DRM_MM_BUG_ON(&hole->hole_stack == &mm->hole_stack);
-	if (unlikely(&hole->hole_stack == &mm->hole_stack))
+	DRM_MM_BUG_ON(!hole);
+	if (unlikely(!hole))
 		return NULL;

 	DRM_MM_BUG_ON(hole_start > scan->hit_start);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index e957d4851dc0..630b2bbd172e 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -138,7 +138,8 @@ static vm_fault_t drm_vm_fault(struct vm_fault *vmf)
 		 */
 		resource_size_t offset = vmf->address - vma->vm_start;
 		resource_size_t baddr = map->offset + offset;
-		struct drm_agp_mem *agpmem;
+		struct drm_agp_mem *agpmem = NULL;
+		struct drm_agp_mem *tmp;
 		struct page *page;

 #ifdef __alpha__
@@ -151,13 +152,15 @@ static vm_fault_t drm_vm_fault(struct vm_fault *vmf)
 		/*
 		 * It's AGP memory - find the real physical page to map
 		 */
-		list_for_each_entry(agpmem, &dev->agp->memory, head) {
-			if (agpmem->bound <= baddr &&
-			    agpmem->bound + agpmem->pages * PAGE_SIZE > baddr)
+		list_for_each_entry(tmp, &dev->agp->memory, head) {
+			if (tmp->bound <= baddr &&
+			    tmp->bound + tmp->pages * PAGE_SIZE > baddr) {
+				agpmem = tmp;
 				break;
+			}
 		}

-		if (&agpmem->head == &dev->agp->memory)
+		if (!agpmem)
 			goto vm_fault_error;

 		/*
diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 28b995ef2844..2df1cbef0965 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -87,6 +87,7 @@ static void oaktrail_lvds_mode_set(struct drm_encoder *encoder,
 	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct drm_connector *connector = NULL;
+	struct drm_connector *tmp;
 	struct drm_crtc *crtc = encoder->crtc;
 	u32 lvds_port;
 	uint64_t v = DRM_MODE_SCALE_FULLSCREEN;
@@ -112,12 +113,14 @@ static void oaktrail_lvds_mode_set(struct drm_encoder *encoder,
 	REG_WRITE(LVDS, lvds_port);

 	/* Find the connector we're trying to set up */
-	list_for_each_entry(connector, &mode_config->connector_list, head) {
-		if (connector->encoder && connector->encoder->crtc == crtc)
+	list_for_each_entry(tmp, &mode_config->connector_list, head) {
+		if (tmp->encoder && tmp->encoder->crtc == crtc) {
+			connector = tmp;
 			break;
+		}
 	}

-	if (list_entry_is_head(connector, &mode_config->connector_list, head)) {
+	if (!connector) {
 		DRM_ERROR("Couldn't find connector when setting mode");
 		gma_power_end(dev);
 		return;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 00327b750fbb..80c79028901a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -107,25 +107,27 @@ static void lut_close(struct i915_gem_context *ctx)
 	radix_tree_for_each_slot(slot, &ctx->handles_vma, &iter, 0) {
 		struct i915_vma *vma = rcu_dereference_raw(*slot);
 		struct drm_i915_gem_object *obj = vma->obj;
-		struct i915_lut_handle *lut;
+		struct i915_lut_handle *lut = NULL;
+		struct i915_lut_handle *tmp;

 		if (!kref_get_unless_zero(&obj->base.refcount))
 			continue;

 		spin_lock(&obj->lut_lock);
-		list_for_each_entry(lut, &obj->lut_list, obj_link) {
-			if (lut->ctx != ctx)
+		list_for_each_entry(tmp, &obj->lut_list, obj_link) {
+			if (tmp->ctx != ctx)
 				continue;

-			if (lut->handle != iter.index)
+			if (tmp->handle != iter.index)
 				continue;

-			list_del(&lut->obj_link);
+			list_del(&tmp->obj_link);
+			lut = tmp;
 			break;
 		}
 		spin_unlock(&obj->lut_lock);

-		if (&lut->obj_link != &obj->lut_list) {
+		if (lut) {
 			i915_lut_handle_free(lut);
 			radix_tree_iter_delete(&ctx->handles_vma, &iter, slot);
 			i915_vma_close(vma);
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 1736efa43339..fda9e3685ad2 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2444,7 +2444,8 @@ static struct i915_request *eb_throttle(struct i915_execbuffer *eb, struct intel
 {
 	struct intel_ring *ring = ce->ring;
 	struct intel_timeline *tl = ce->timeline;
-	struct i915_request *rq;
+	struct i915_request *rq = NULL;
+	struct i915_request *tmp;

 	/*
 	 * Completely unscientific finger-in-the-air estimates for suitable
@@ -2460,15 +2461,17 @@ static struct i915_request *eb_throttle(struct i915_execbuffer *eb, struct intel
 	 * claiming our resources, but not so long that the ring completely
 	 * drains before we can submit our next request.
 	 */
-	list_for_each_entry(rq, &tl->requests, link) {
-		if (rq->ring != ring)
+	list_for_each_entry(tmp, &tl->requests, link) {
+		if (tmp->ring != ring)
 			continue;

-		if (__intel_ring_space(rq->postfix,
-				       ring->emit, ring->size) > ring->size / 2)
+		if (__intel_ring_space(tmp->postfix,
+				       ring->emit, ring->size) > ring->size / 2) {
+			rq = tmp;
 			break;
+		}
 	}
-	if (&rq->link == &tl->requests)
+	if (!rq)
 		return NULL; /* weird, we will check again later for real */

 	return i915_request_get(rq);
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 2fdd52b62092..4881c4e0c407 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -191,24 +191,27 @@ wait_for_space(struct intel_ring *ring,
 	       struct intel_timeline *tl,
 	       unsigned int bytes)
 {
-	struct i915_request *target;
+	struct i915_request *target = NULL;
+	struct i915_request *tmp;
 	long timeout;

 	if (intel_ring_update_space(ring) >= bytes)
 		return 0;

 	GEM_BUG_ON(list_empty(&tl->requests));
-	list_for_each_entry(target, &tl->requests, link) {
-		if (target->ring != ring)
+	list_for_each_entry(tmp, &tl->requests, link) {
+		if (tmp->ring != ring)
 			continue;

 		/* Would completion of this request free enough space? */
-		if (bytes <= __intel_ring_space(target->postfix,
-						ring->emit, ring->size))
+		if (bytes <= __intel_ring_space(tmp->postfix,
+						ring->emit, ring->size)) {
+			target = tmp;
 			break;
+		}
 	}

-	if (GEM_WARN_ON(&target->link == &tl->requests))
+	if (GEM_WARN_ON(!target))
 		return -ENOSPC;

 	timeout = i915_request_wait(target,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgk104.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgk104.c
index 2b678b60b4d3..c1f99d34e334 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgk104.c
@@ -1155,17 +1155,20 @@ static void
 gk104_ram_prog_0(struct gk104_ram *ram, u32 freq)
 {
 	struct nvkm_device *device = ram->base.fb->subdev.device;
-	struct nvkm_ram_data *cfg;
+	struct nvkm_ram_data *cfg = NULL;
+	struct nvkm_ram_data *tmp;
 	u32 mhz = freq / 1000;
 	u32 mask, data;

-	list_for_each_entry(cfg, &ram->cfg, head) {
-		if (mhz >= cfg->bios.rammap_min &&
-		    mhz <= cfg->bios.rammap_max)
+	list_for_each_entry(tmp, &ram->cfg, head) {
+		if (mhz >= tmp->bios.rammap_min &&
+		    mhz <= tmp->bios.rammap_max) {
+			cfg = tmp;
 			break;
+		}
 	}

-	if (&cfg->head == &ram->cfg)
+	if (!cfg)
 		return;

 	if (mask = 0, data = 0, ram->diff.rammap_11_0a_03fe) {
diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index f91fb31ab7a7..2051abe5337a 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -1081,7 +1081,8 @@ void drm_sched_increase_karma_ext(struct drm_sched_job *bad, int type)
 {
 	int i;
 	struct drm_sched_entity *tmp;
-	struct drm_sched_entity *entity;
+	struct drm_sched_entity *entity = NULL;
+	struct drm_sched_entity *iter;
 	struct drm_gpu_scheduler *sched = bad->sched;

 	/* don't change @bad's karma if it's from KERNEL RQ,
@@ -1099,16 +1100,17 @@ void drm_sched_increase_karma_ext(struct drm_sched_job *bad, int type)
 			struct drm_sched_rq *rq = &sched->sched_rq[i];

 			spin_lock(&rq->lock);
-			list_for_each_entry_safe(entity, tmp, &rq->entities, list) {
+			list_for_each_entry_safe(iter, tmp, &rq->entities, list) {
 				if (bad->s_fence->scheduled.context ==
-				    entity->fence_context) {
-					if (entity->guilty)
-						atomic_set(entity->guilty, type);
+				    iter->fence_context) {
+					if (iter->guilty)
+						atomic_set(iter->guilty, type);
+					entity = iter;
 					break;
 				}
 			}
 			spin_unlock(&rq->lock);
-			if (&entity->list != &rq->entities)
+			if (entity)
 				break;
 		}
 	}
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index db3dc7ef5382..d4e0899f87d3 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -672,37 +672,36 @@ int ttm_mem_evict_first(struct ttm_device *bdev,
 			struct ttm_operation_ctx *ctx,
 			struct ww_acquire_ctx *ticket)
 {
-	struct ttm_buffer_object *bo = NULL, *busy_bo = NULL;
+	struct ttm_buffer_object *bo = NULL, *tmp, *busy_bo = NULL;
 	bool locked = false;
 	unsigned i;
 	int ret;

 	spin_lock(&bdev->lru_lock);
 	for (i = 0; i < TTM_MAX_BO_PRIORITY; ++i) {
-		list_for_each_entry(bo, &man->lru[i], lru) {
+		list_for_each_entry(tmp, &man->lru[i], lru) {
 			bool busy;

-			if (!ttm_bo_evict_swapout_allowable(bo, ctx, place,
+			if (!ttm_bo_evict_swapout_allowable(tmp, ctx, place,
 							    &locked, &busy)) {
 				if (busy && !busy_bo && ticket !=
-				    dma_resv_locking_ctx(bo->base.resv))
-					busy_bo = bo;
+				    dma_resv_locking_ctx(tmp->base.resv))
+					busy_bo = tmp;
 				continue;
 			}

-			if (!ttm_bo_get_unless_zero(bo)) {
+			if (!ttm_bo_get_unless_zero(tmp)) {
 				if (locked)
-					dma_resv_unlock(bo->base.resv);
+					dma_resv_unlock(tmp->base.resv);
 				continue;
 			}
+			bo = tmp;
 			break;
 		}

 		/* If the inner loop terminated early, we have our candidate */
-		if (&bo->lru != &man->lru[i])
+		if (bo)
 			break;
-
-		bo = NULL;
 	}

 	if (!bo) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index bbd2f4ec08ec..8f1890cf438e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2582,22 +2582,26 @@ int vmw_kms_fbdev_init_data(struct vmw_private *dev_priv,
 			    struct drm_crtc **p_crtc,
 			    struct drm_display_mode **p_mode)
 {
-	struct drm_connector *con;
+	struct drm_connector *con = NULL;
+	struct drm_connector *tmp1;
 	struct vmw_display_unit *du;
-	struct drm_display_mode *mode;
+	struct drm_display_mode *mode = NULL;
+	struct drm_display_mode *tmp2;
 	int i = 0;
 	int ret = 0;

 	mutex_lock(&dev_priv->drm.mode_config.mutex);
-	list_for_each_entry(con, &dev_priv->drm.mode_config.connector_list,
+	list_for_each_entry(tmp1, &dev_priv->drm.mode_config.connector_list,
 			    head) {
-		if (i == unit)
+		if (i == unit) {
+			con = tmp1;
 			break;
+		}

 		++i;
 	}

-	if (&con->head == &dev_priv->drm.mode_config.connector_list) {
+	if (!con) {
 		DRM_ERROR("Could not find initial display unit.\n");
 		ret = -EINVAL;
 		goto out_unlock;
@@ -2616,12 +2620,14 @@ int vmw_kms_fbdev_init_data(struct vmw_private *dev_priv,
 	*p_con = con;
 	*p_crtc = &du->crtc;

-	list_for_each_entry(mode, &con->modes, head) {
-		if (mode->type & DRM_MODE_TYPE_PREFERRED)
+	list_for_each_entry(tmp2, &con->modes, head) {
+		if (tmp2->type & DRM_MODE_TYPE_PREFERRED) {
+			mode = tmp2;
 			break;
+		}
 	}

-	if (&mode->head == &con->modes) {
+	if (!mode) {
 		WARN_ONCE(true, "Could not find initial preferred mode.\n");
 		*p_mode = list_first_entry(&con->modes,
 					   struct drm_display_mode,
diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 2a7abf7a1f7f..a069847b56aa 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -1239,7 +1239,7 @@ static int kern_alloc_tids(struct tid_rdma_flow *flow)
 	struct hfi1_ctxtdata *rcd = flow->req->rcd;
 	struct hfi1_devdata *dd = rcd->dd;
 	u32 ngroups, pageidx = 0;
-	struct tid_group *group = NULL, *used;
+	struct tid_group *group = NULL, *used, *tmp;
 	u8 use;

 	flow->tnode_cnt = 0;
@@ -1248,13 +1248,15 @@ static int kern_alloc_tids(struct tid_rdma_flow *flow)
 		goto used_list;

 	/* First look at complete groups */
-	list_for_each_entry(group,  &rcd->tid_group_list.list, list) {
-		kern_add_tid_node(flow, rcd, "complete groups", group,
-				  group->size);
+	list_for_each_entry(tmp,  &rcd->tid_group_list.list, list) {
+		kern_add_tid_node(flow, rcd, "complete groups", tmp,
+				  tmp->size);

-		pageidx += group->size;
-		if (!--ngroups)
+		pageidx += tmp->size;
+		if (!--ngroups) {
+			group = tmp;
 			break;
+		}
 	}

 	if (pageidx >= flow->npagesets)
@@ -1277,7 +1279,7 @@ static int kern_alloc_tids(struct tid_rdma_flow *flow)
 	 * However, if we are at the head, we have reached the end of the
 	 * complete groups list from the first loop above
 	 */
-	if (group && &group->list == &rcd->tid_group_list.list)
+	if (!group)
 		goto bail_eagain;
 	group = list_prepare_entry(group, &rcd->tid_group_list.list,
 				   list);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 93b1650eacfa..4659d879e97d 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1920,17 +1920,19 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)

 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
-		struct mlx4_ib_steering *ib_steering;
+		struct mlx4_ib_steering *ib_steering = NULL;
+		struct mlx4_ib_steering *tmp;

 		mutex_lock(&mqp->mutex);
-		list_for_each_entry(ib_steering, &mqp->steering_rules, list) {
-			if (!memcmp(ib_steering->gid.raw, gid->raw, 16)) {
-				list_del(&ib_steering->list);
+		list_for_each_entry(tmp, &mqp->steering_rules, list) {
+			if (!memcmp(tmp->gid.raw, gid->raw, 16)) {
+				list_del(&tmp->list);
+				ib_steering = tmp;
 				break;
 			}
 		}
 		mutex_unlock(&mqp->mutex);
-		if (&ib_steering->list == &mqp->steering_rules) {
+		if (!ib_steering) {
 			pr_err("Couldn't find reg_id for mgid. Steering rule is left attached\n");
 			return -EINVAL;
 		}
diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 934d1c0b214a..78c37ce56e32 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -492,17 +492,20 @@ static int enable_tuner(struct mxl *state, u32 tuner, u32 enable);
 static int sleep(struct dvb_frontend *fe)
 {
 	struct mxl *state = fe->demodulator_priv;
-	struct mxl *p;
+	struct mxl *p = NULL;
+	struct mxl *tmp;

 	cfg_demod_abort_tune(state);
 	if (state->tuner_in_use != 0xffffffff) {
 		mutex_lock(&state->base->tune_lock);
 		state->tuner_in_use = 0xffffffff;
-		list_for_each_entry(p, &state->base->mxls, mxl) {
-			if (p->tuner_in_use == state->tuner)
+		list_for_each_entry(tmp, &state->base->mxls, mxl) {
+			if (tmp->tuner_in_use == state->tuner) {
+				p = tmp;
 				break;
+			}
 		}
-		if (&p->mxl == &state->base->mxls)
+		if (!p)
 			enable_tuner(state, state->tuner, 0);
 		mutex_unlock(&state->base->tune_lock);
 	}
diff --git a/drivers/media/v4l2-core/v4l2-ctrls-api.c b/drivers/media/v4l2-core/v4l2-ctrls-api.c
index db9baa0bd05f..9245fd5e546c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
@@ -942,6 +942,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	const unsigned int next_flags = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
 	u32 id = qc->id & V4L2_CTRL_ID_MASK;
 	struct v4l2_ctrl_ref *ref;
+	struct v4l2_ctrl_ref *tmp;
 	struct v4l2_ctrl *ctrl;

 	if (!hdl)
@@ -976,15 +977,17 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 			 * We found a control with the given ID, so just get
 			 * the next valid one in the list.
 			 */
-			list_for_each_entry_continue(ref, &hdl->ctrl_refs, node) {
-				is_compound = ref->ctrl->is_array ||
-					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
-				if (id < ref->ctrl->id &&
-				    (is_compound & mask) == match)
+			tmp = ref;
+			ref = NULL;
+			list_for_each_entry_continue(tmp, &hdl->ctrl_refs, node) {
+				is_compound = tmp->ctrl->is_array ||
+					tmp->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
+				if (id < tmp->ctrl->id &&
+				    (is_compound & mask) == match) {
+					ref = tmp;
 					break;
+				}
 			}
-			if (&ref->node == &hdl->ctrl_refs)
-				ref = NULL;
 		} else {
 			/*
 			 * No control with the given ID exists, so start
@@ -992,15 +995,15 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 			 * is one, otherwise the first 'if' above would have
 			 * been true.
 			 */
-			list_for_each_entry(ref, &hdl->ctrl_refs, node) {
-				is_compound = ref->ctrl->is_array ||
-					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
-				if (id < ref->ctrl->id &&
-				    (is_compound & mask) == match)
+			list_for_each_entry(tmp, &hdl->ctrl_refs, node) {
+				is_compound = tmp->ctrl->is_array ||
+					tmp->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
+				if (id < tmp->ctrl->id &&
+				    (is_compound & mask) == match) {
+					ref = tmp;
 					break;
+				}
 			}
-			if (&ref->node == &hdl->ctrl_refs)
-				ref = NULL;
 		}
 	}
 	mutex_unlock(hdl->lock);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index a67f4f2d33a9..f15b91e22b9d 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -329,7 +329,8 @@ int mei_irq_read_handler(struct mei_device *dev,
 {
 	struct mei_msg_hdr *mei_hdr;
 	struct mei_ext_meta_hdr *meta_hdr = NULL;
-	struct mei_cl *cl;
+	struct mei_cl *cl = NULL;
+	struct mei_cl *tmp;
 	int ret;
 	u32 hdr_size_left;
 	u32 hdr_size_ext;
@@ -421,15 +422,16 @@ int mei_irq_read_handler(struct mei_device *dev,
 	}

 	/* find recipient cl */
-	list_for_each_entry(cl, &dev->file_list, link) {
-		if (mei_cl_hbm_equal(cl, mei_hdr)) {
-			cl_dbg(dev, cl, "got a message\n");
+	list_for_each_entry(tmp, &dev->file_list, link) {
+		if (mei_cl_hbm_equal(tmp, mei_hdr)) {
+			cl_dbg(dev, tmp, "got a message\n");
+			cl = tmp;
 			break;
 		}
 	}

 	/* if no recipient cl was found we assume corrupted header */
-	if (&cl->link == &dev->file_list) {
+	if (!cl) {
 		/* A message for not connected fixed address clients
 		 * should be silently discarded
 		 * On power down client may be force cleaned,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 3010833ddde3..d3e59ee13705 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -829,18 +829,21 @@ int qede_configure_vlan_filters(struct qede_dev *edev)
 int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	struct qede_vlan *vlan;
+	struct qede_vlan *vlan = NULL;
+	struct qede_vlan *tmp;
 	int rc = 0;

 	DP_VERBOSE(edev, NETIF_MSG_IFDOWN, "Removing vlan 0x%04x\n", vid);

 	/* Find whether entry exists */
 	__qede_lock(edev);
-	list_for_each_entry(vlan, &edev->vlan_list, list)
-		if (vlan->vid == vid)
+	list_for_each_entry(tmp, &edev->vlan_list, list)
+		if (tmp->vid == vid) {
+			vlan = tmp;
 			break;
+		}

-	if (list_entry_is_head(vlan, &edev->vlan_list, list)) {
+	if (!vlan) {
 		DP_VERBOSE(edev, (NETIF_MSG_IFUP | NETIF_MSG_IFDOWN),
 			   "Vlan isn't configured\n");
 		goto out;
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 7a684b76f39b..c78372e0dc15 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1507,7 +1507,8 @@ static void libipw_process_probe_response(struct libipw_device
 {
 	struct net_device *dev = ieee->dev;
 	struct libipw_network network = { };
-	struct libipw_network *target;
+	struct libipw_network *target = NULL;
+	struct libipw_network *tmp;
 	struct libipw_network *oldest = NULL;
 #ifdef CONFIG_LIBIPW_DEBUG
 	struct libipw_info_element *info_element = beacon->info_element;
@@ -1555,18 +1556,20 @@ static void libipw_process_probe_response(struct libipw_device

 	spin_lock_irqsave(&ieee->lock, flags);

-	list_for_each_entry(target, &ieee->network_list, list) {
-		if (is_same_network(target, &network))
+	list_for_each_entry(tmp, &ieee->network_list, list) {
+		if (is_same_network(tmp, &network)) {
+			target = tmp;
 			break;
+		}

 		if ((oldest == NULL) ||
-		    time_before(target->last_scanned, oldest->last_scanned))
-			oldest = target;
+		    time_before(tmp->last_scanned, oldest->last_scanned))
+			oldest = tmp;
 	}

 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information */
-	if (&target->list == &ieee->network_list) {
+	if (!target) {
 		if (list_empty(&ieee->network_free_list)) {
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 18e3ff0e15d5..6542ff3eeccc 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -789,17 +789,20 @@ static irqreturn_t cpcap_battery_irq_thread(int irq, void *data)
 {
 	struct cpcap_battery_ddata *ddata = data;
 	struct cpcap_battery_state_data *latest;
-	struct cpcap_interrupt_desc *d;
+	struct cpcap_interrupt_desc *d = NULL;
+	struct cpcap_interrupt_desc *tmp;

 	if (!atomic_read(&ddata->active))
 		return IRQ_NONE;

-	list_for_each_entry(d, &ddata->irq_list, node) {
-		if (irq == d->irq)
+	list_for_each_entry(tmp, &ddata->irq_list, node) {
+		if (irq == tmp->irq) {
+			d = tmp;
 			break;
+		}
 	}

-	if (list_entry_is_head(d, &ddata->irq_list, node))
+	if (!d)
 		return IRQ_NONE;

 	latest = cpcap_battery_latest(ddata);
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index fdf08cb57207..30174bddf024 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1185,7 +1185,8 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct set_ct_event *event_req;
-	struct lpfc_bsg_event *evt;
+	struct lpfc_bsg_event *evt = NULL;
+	struct lpfc_bsg_event *tmp;
 	int rc = 0;
 	struct bsg_job_data *dd_data = NULL;
 	uint32_t ev_mask;
@@ -1205,17 +1206,18 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
 	ev_mask = ((uint32_t)(unsigned long)event_req->type_mask &
 				FC_REG_EVENT_MASK);
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
-	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
-		if (evt->reg_id == event_req->ev_reg_id) {
-			lpfc_bsg_event_ref(evt);
-			evt->wait_time_stamp = jiffies;
-			dd_data = (struct bsg_job_data *)evt->dd_data;
+	list_for_each_entry(tmp, &phba->ct_ev_waiters, node) {
+		if (tmp->reg_id == event_req->ev_reg_id) {
+			lpfc_bsg_event_ref(tmp);
+			tmp->wait_time_stamp = jiffies;
+			dd_data = (struct bsg_job_data *)tmp->dd_data;
+			evt = tmp;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);

-	if (&evt->node == &phba->ct_ev_waiters) {
+	if (!evt) {
 		/* no event waiting struct yet - first call */
 		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 		if (dd_data == NULL) {
diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
index 34b00a76b6bd..7ed60edc5aa8 100644
--- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
@@ -213,6 +213,7 @@ static struct ts_common_info *SearchAdmitTRStream(struct rtllib_device *ieee,
 	bool	search_dir[4] = {0};
 	struct list_head *psearch_list;
 	struct ts_common_info *pRet = NULL;
+	struct ts_common_info *tmp;

 	if (ieee->iw_mode == IW_MODE_MASTER) {
 		if (TxRxSelect == TX_DIR) {
@@ -247,19 +248,19 @@ static struct ts_common_info *SearchAdmitTRStream(struct rtllib_device *ieee,
 	for (dir = 0; dir <= DIR_BI_DIR; dir++) {
 		if (!search_dir[dir])
 			continue;
-		list_for_each_entry(pRet, psearch_list, List) {
-			if (memcmp(pRet->Addr, Addr, 6) == 0 &&
-			    pRet->TSpec.f.TSInfo.field.ucTSID == TID &&
-			    pRet->TSpec.f.TSInfo.field.ucDirection == dir)
+		list_for_each_entry(tmp, psearch_list, List) {
+			if (memcmp(tmp->Addr, Addr, 6) == 0 &&
+			    tmp->TSpec.f.TSInfo.field.ucTSID == TID &&
+			    tmp->TSpec.f.TSInfo.field.ucDirection == dir) {
+				pRet = tmp;
 				break;
+			}
 		}
-		if (&pRet->List  != psearch_list)
+		if (pRet)
 			break;
 	}

-	if (pRet && &pRet->List  != psearch_list)
-		return pRet;
-	return NULL;
+	return pRet;
 }

 static void MakeTSEntry(struct ts_common_info *pTsCommonInfo, u8 *Addr,
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index e3d0a361d370..5f44bc5dcd76 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -2540,7 +2540,8 @@ static inline void rtllib_process_probe_response(
 	struct rtllib_probe_response *beacon,
 	struct rtllib_rx_stats *stats)
 {
-	struct rtllib_network *target;
+	struct rtllib_network *target = NULL;
+	struct rtllib_network *tmp;
 	struct rtllib_network *oldest = NULL;
 	struct rtllib_info_element *info_element = &beacon->info_element[0];
 	unsigned long flags;
@@ -2623,19 +2624,21 @@ static inline void rtllib_process_probe_response(
 				ieee->LinkDetectInfo.NumRecvBcnInPeriod++;
 		}
 	}
-	list_for_each_entry(target, &ieee->network_list, list) {
-		if (is_same_network(target, network,
-		   (target->ssid_len ? 1 : 0)))
+	list_for_each_entry(tmp, &ieee->network_list, list) {
+		if (is_same_network(tmp, network,
+		   (tmp->ssid_len ? 1 : 0))) {
+			target = tmp;
 			break;
+		}
 		if ((oldest == NULL) ||
-		    (target->last_scanned < oldest->last_scanned))
-			oldest = target;
+		    (tmp->last_scanned < oldest->last_scanned))
+			oldest = tmp;
 	}

 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information
 	 */
-	if (&target->list == &ieee->network_list) {
+	if (!target) {
 		if (list_empty(&ieee->network_free_list)) {
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index b58e75932ecd..2843c1c1c2f2 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -2239,7 +2239,8 @@ static inline void ieee80211_process_probe_response(
 	struct ieee80211_rx_stats *stats)
 {
 	struct ieee80211_network *network;
-	struct ieee80211_network *target;
+	struct ieee80211_network *target = NULL;
+	struct ieee80211_network *tmp;
 	struct ieee80211_network *oldest = NULL;
 #ifdef CONFIG_IEEE80211_DEBUG
 	struct ieee80211_info_element *info_element = &beacon->info_element[0];
@@ -2357,17 +2358,19 @@ static inline void ieee80211_process_probe_response(
 			network->flags = (~NETWORK_EMPTY_ESSID & network->flags) | (NETWORK_EMPTY_ESSID & ieee->current_network.flags);
 	}

-	list_for_each_entry(target, &ieee->network_list, list) {
-		if (is_same_network(target, network, ieee))
+	list_for_each_entry(tmp, &ieee->network_list, list) {
+		if (is_same_network(tmp, network, ieee)) {
+			target = tmp;
 			break;
+		}
 		if (!oldest ||
-		    (target->last_scanned < oldest->last_scanned))
-			oldest = target;
+		    (tmp->last_scanned < oldest->last_scanned))
+			oldest = tmp;
 	}

 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information */
-	if (&target->list == &ieee->network_list) {
+	if (!target) {
 		if (list_empty(&ieee->network_free_list)) {
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 3aabb401b15a..1b8f3fd8e51d 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -209,6 +209,7 @@ static struct ts_common_info *SearchAdmitTRStream(struct ieee80211_device *ieee,
 	bool				search_dir[4] = {0};
 	struct list_head		*psearch_list; //FIXME
 	struct ts_common_info	*pRet = NULL;
+	struct ts_common_info	*tmp;
 	if (ieee->iw_mode == IW_MODE_MASTER) { //ap mode
 		if (TxRxSelect == TX_DIR) {
 			search_dir[DIR_DOWN] = true;
@@ -243,23 +244,21 @@ static struct ts_common_info *SearchAdmitTRStream(struct ieee80211_device *ieee,
 	for (dir = 0; dir <= DIR_BI_DIR; dir++) {
 		if (!search_dir[dir])
 			continue;
-		list_for_each_entry(pRet, psearch_list, list) {
-	//		IEEE80211_DEBUG(IEEE80211_DL_TS, "ADD:%pM, TID:%d, dir:%d\n", pRet->Addr, pRet->TSpec.ts_info.ucTSID, pRet->TSpec.ts_info.ucDirection);
-			if (memcmp(pRet->addr, Addr, 6) == 0)
-				if (pRet->t_spec.ts_info.uc_tsid == TID)
-					if (pRet->t_spec.ts_info.uc_direction == dir) {
+		list_for_each_entry(tmp, psearch_list, list) {
+	//		IEEE80211_DEBUG(IEEE80211_DL_TS, "ADD:%pM, TID:%d, dir:%d\n", tmp->Addr, tmp->TSpec.ts_info.ucTSID, tmp->TSpec.ts_info.ucDirection);
+			if (memcmp(tmp->addr, Addr, 6) == 0)
+				if (tmp->t_spec.ts_info.uc_tsid == TID)
+					if (tmp->t_spec.ts_info.uc_direction == dir) {
 	//					printk("Bingo! got it\n");
+	//					pRet = tmp;
 						break;
 					}
 		}
-		if (&pRet->list  != psearch_list)
+		if (pRet)
 			break;
 	}

-	if (&pRet->list  != psearch_list)
-		return pRet;
-	else
-		return NULL;
+	return pRet;
 }

 static void MakeTSEntry(struct ts_common_info *pTsCommonInfo, u8 *Addr,
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 9315313108c9..26908d012ac8 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1690,6 +1690,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	u16				w_value = le16_to_cpu(ctrl->wValue);
 	u16				w_length = le16_to_cpu(ctrl->wLength);
 	struct usb_function		*f = NULL;
+	struct usb_function		*tmp;
 	u8				endp;

 	if (w_length > USB_COMP_EP0_BUFSIZ) {
@@ -2046,12 +2047,12 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			if (!cdev->config)
 				break;
 			endp = ((w_index & 0x80) >> 3) | (w_index & 0x0f);
-			list_for_each_entry(f, &cdev->config->functions, list) {
-				if (test_bit(endp, f->endpoints))
+			list_for_each_entry(tmp, &cdev->config->functions, list) {
+				if (test_bit(endp, tmp->endpoints)) {
+					f = tmp;
 					break;
+				}
 			}
-			if (&f->list == &cdev->config->functions)
-				f = NULL;
 			break;
 		}
 try_fun_setup:
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index b25623e3fe3d..e012a2bdab82 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -150,16 +150,18 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 		struct smb2_transform_hdr *thdr =
 			(struct smb2_transform_hdr *)buf;
 		struct cifs_ses *ses = NULL;
+		struct cifs_ses *tmp;

 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(ses, &srvr->smb_ses_list, smb_ses_list) {
-			if (ses->Suid == le64_to_cpu(thdr->SessionId))
+		list_for_each_entry(tmp, &srvr->smb_ses_list, smb_ses_list) {
+			if (tmp->Suid == le64_to_cpu(thdr->SessionId)) {
+				ses = tmp;
 				break;
+			}
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
-		if (list_entry_is_head(ses, &srvr->smb_ses_list,
-				       smb_ses_list)) {
+		if (!ses) {
 			cifs_dbg(VFS, "no decryption - session id not found\n");
 			return 1;
 		}
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 982e694aae77..f1ac6d765367 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -316,6 +316,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 	size_t page_offline_frozen = 1;
 	size_t phdrs_len, notes_len;
 	struct kcore_list *m;
+	struct kcore_list *tmp;
 	size_t tsz;
 	int nphdr;
 	unsigned long start;
@@ -479,10 +480,13 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			list_for_each_entry(m, &kclist_head, list) {
-				if (start >= m->addr &&
-				    start < m->addr + m->size)
+			m = NULL;
+			list_for_each_entry(tmp, &kclist_head, list) {
+				if (start >= tmp->addr &&
+				    start < tmp->addr + tmp->size) {
+					m = tmp;
 					break;
+				}
 			}
 		}

@@ -492,12 +496,11 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 			page_offline_freeze();
 		}

-		if (&m->list == &kclist_head) {
+		if (!m) {
 			if (clear_user(buffer, tsz)) {
 				ret = -EFAULT;
 				goto out;
 			}
-			m = NULL;	/* skip the list anchor */
 			goto skip;
 		}

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0852a537dad4..2d3d6558cef0 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -781,18 +781,21 @@ static int kdb_defcmd(int argc, const char **argv)
 static int kdb_exec_defcmd(int argc, const char **argv)
 {
 	int ret;
-	kdbtab_t *kp;
+	kdbtab_t *kp = NULL;
+	kdbtab_t *tmp;
 	struct kdb_macro *kmp;
 	struct kdb_macro_statement *kms;

 	if (argc != 0)
 		return KDB_ARGCOUNT;

-	list_for_each_entry(kp, &kdb_cmds_head, list_node) {
-		if (strcmp(kp->name, argv[0]) == 0)
+	list_for_each_entry(tmp, &kdb_cmds_head, list_node) {
+		if (strcmp(tmp->name, argv[0]) == 0) {
+			kp = tmp;
 			break;
+		}
 	}
-	if (list_entry_is_head(kp, &kdb_cmds_head, list_node)) {
+	if (!kp) {
 		kdb_printf("kdb_exec_defcmd: could not find commands for %s\n",
 			   argv[0]);
 		return KDB_NOTIMP;
@@ -919,7 +922,8 @@ int kdb_parse(const char *cmdstr)
 	static char cbuf[CMD_BUFLEN+2];
 	char *cp;
 	char *cpp, quoted;
-	kdbtab_t *tp;
+	kdbtab_t *tp = NULL;
+	kdbtab_t *tmp;
 	int escaped, ignore_errors = 0, check_grep = 0;

 	/*
@@ -1010,17 +1014,21 @@ int kdb_parse(const char *cmdstr)
 		++argv[0];
 	}

-	list_for_each_entry(tp, &kdb_cmds_head, list_node) {
+	list_for_each_entry(tmp, &kdb_cmds_head, list_node) {
 		/*
 		 * If this command is allowed to be abbreviated,
 		 * check to see if this is it.
 		 */
-		if (tp->minlen && (strlen(argv[0]) <= tp->minlen) &&
-		    (strncmp(argv[0], tp->name, tp->minlen) == 0))
+		if (tmp->minlen && (strlen(argv[0]) <= tmp->minlen) &&
+		    (strncmp(argv[0], tmp->name, tmp->minlen) == 0)) {
+			tp = tmp;
 			break;
+		}

-		if (strcmp(argv[0], tp->name) == 0)
+		if (strcmp(argv[0], tmp->name) == 0) {
+			tp = tmp;
 			break;
+		}
 	}

 	/*
@@ -1028,14 +1036,16 @@ int kdb_parse(const char *cmdstr)
 	 * few characters of this match any of the known commands.
 	 * e.g., md1c20 should match md.
 	 */
-	if (list_entry_is_head(tp, &kdb_cmds_head, list_node)) {
-		list_for_each_entry(tp, &kdb_cmds_head, list_node) {
-			if (strncmp(argv[0], tp->name, strlen(tp->name)) == 0)
+	if (!tp) {
+		list_for_each_entry(tmp, &kdb_cmds_head, list_node) {
+			if (strncmp(argv[0], tmp->name, strlen(tmp->name)) == 0) {
+				tp = tmp;
 				break;
+			}
 		}
 	}

-	if (!list_entry_is_head(tp, &kdb_cmds_head, list_node)) {
+	if (tp) {
 		int result;

 		if (!kdb_check_flags(tp->flags, kdb_cmd_enabled, argc <= 1))
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 330d49937692..6ded22451c73 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -625,16 +625,18 @@ static int create_mem_extents(struct list_head *list, gfp_t gfp_mask)

 	for_each_populated_zone(zone) {
 		unsigned long zone_start, zone_end;
-		struct mem_extent *ext, *cur, *aux;
+		struct mem_extent *ext = NULL, *tmp, *cur, *aux;

 		zone_start = zone->zone_start_pfn;
 		zone_end = zone_end_pfn(zone);

-		list_for_each_entry(ext, list, hook)
-			if (zone_start <= ext->end)
+		list_for_each_entry(tmp, list, hook)
+			if (zone_start <= tmp->end) {
+				ext = tmp;
 				break;
+			}

-		if (&ext->hook == list || zone_end < ext->start) {
+		if (!ext || zone_end < ext->start) {
 			/* New extent is necessary */
 			struct mem_extent *new_ext;

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f9feb197b2da..d1cc4dcf1b1e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4544,7 +4544,8 @@ register_ftrace_function_probe(char *glob, struct trace_array *tr,
 			       void *data)
 {
 	struct ftrace_func_entry *entry;
-	struct ftrace_func_probe *probe;
+	struct ftrace_func_probe *probe = NULL;
+	struct ftrace_func_probe *tmp;
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *old_hash;
 	struct ftrace_hash *hash;
@@ -4563,11 +4564,13 @@ register_ftrace_function_probe(char *glob, struct trace_array *tr,

 	mutex_lock(&ftrace_lock);
 	/* Check if the probe_ops is already registered */
-	list_for_each_entry(probe, &tr->func_probes, list) {
-		if (probe->probe_ops == probe_ops)
+	list_for_each_entry(tmp, &tr->func_probes, list) {
+		if (tmp->probe_ops == probe_ops) {
+			probe = tmp;
 			break;
+		}
 	}
-	if (&probe->list == &tr->func_probes) {
+	if (!probe) {
 		probe = kzalloc(sizeof(*probe), GFP_KERNEL);
 		if (!probe) {
 			mutex_unlock(&ftrace_lock);
@@ -4687,7 +4690,8 @@ unregister_ftrace_function_probe_func(char *glob, struct trace_array *tr,
 {
 	struct ftrace_ops_hash old_hash_ops;
 	struct ftrace_func_entry *entry;
-	struct ftrace_func_probe *probe;
+	struct ftrace_func_probe *probe = NULL;
+	struct ftrace_func_probe *iter;
 	struct ftrace_glob func_g;
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *old_hash;
@@ -4715,11 +4719,13 @@ unregister_ftrace_function_probe_func(char *glob, struct trace_array *tr,

 	mutex_lock(&ftrace_lock);
 	/* Check if the probe_ops is already registered */
-	list_for_each_entry(probe, &tr->func_probes, list) {
-		if (probe->probe_ops == probe_ops)
+	list_for_each_entry(iter, &tr->func_probes, list) {
+		if (iter->probe_ops == probe_ops) {
+			probe = iter;
 			break;
+		}
 	}
-	if (&probe->list == &tr->func_probes)
+	if (!probe)
 		goto err_unlock_ftrace;

 	ret = -EINVAL;
diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 191db32dec46..4d9143bc38c8 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -652,7 +652,8 @@ static struct trace_event_functions eprobe_funcs = {
 static int disable_eprobe(struct trace_eprobe *ep,
 			  struct trace_array *tr)
 {
-	struct event_trigger_data *trigger;
+	struct event_trigger_data *trigger = NULL;
+	struct event_trigger_data *tmp;
 	struct trace_event_file *file;
 	struct eprobe_data *edata;

@@ -660,14 +661,16 @@ static int disable_eprobe(struct trace_eprobe *ep,
 	if (!file)
 		return -ENOENT;

-	list_for_each_entry(trigger, &file->triggers, list) {
-		if (!(trigger->flags & EVENT_TRIGGER_FL_PROBE))
+	list_for_each_entry(tmp, &file->triggers, list) {
+		if (!(tmp->flags & EVENT_TRIGGER_FL_PROBE))
 			continue;
-		edata = trigger->private_data;
-		if (edata->ep == ep)
+		edata = tmp->private_data;
+		if (edata->ep == ep) {
+			trigger = tmp;
 			break;
+		}
 	}
-	if (list_entry_is_head(trigger, &file->triggers, list))
+	if (!trigger)
 		return -ENODEV;

 	list_del_rcu(&trigger->list);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3147614c1812..6c0642ea42da 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2264,6 +2264,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 {
 	struct trace_subsystem_dir *dir;
 	struct event_subsystem *system;
+	struct event_subsystem *tmp;
 	struct dentry *entry;

 	/* First see if we did not already create this dir */
@@ -2277,13 +2278,13 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 	}

 	/* Now see if the system itself exists. */
-	list_for_each_entry(system, &event_subsystems, list) {
-		if (strcmp(system->name, name) == 0)
+	system = NULL;
+	list_for_each_entry(tmp, &event_subsystems, list) {
+		if (strcmp(tmp->name, name) == 0) {
+			system = tmp;
 			break;
+		}
 	}
-	/* Reset system variable when not found */
-	if (&system->list == &event_subsystems)
-		system = NULL;

 	dir = kmalloc(sizeof(*dir), GFP_KERNEL);
 	if (!dir)
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index eb9fb55280ef..a1222f9bdda3 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -115,7 +115,8 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)

 static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 {
-	struct xen_9pfs_front_priv *priv;
+	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *tmp;
 	RING_IDX cons, prod, masked_cons, masked_prod;
 	unsigned long flags;
 	u32 size = p9_req->tc.size;
@@ -123,12 +124,14 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 	int num;

 	read_lock(&xen_9pfs_lock);
-	list_for_each_entry(priv, &xen_9pfs_devs, list) {
-		if (priv->client == client)
+	list_for_each_entry(tmp, &xen_9pfs_devs, list) {
+		if (tmp->client == client) {
+			priv = tmp;
 			break;
+		}
 	}
 	read_unlock(&xen_9pfs_lock);
-	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
+	if (!priv)
 		return -EINVAL;

 	num = p9_req->tc.tag % priv->num_rings;
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index bc3a043a5d5c..981d1c5970c5 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -841,12 +841,14 @@ udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 	 * and if there are other devices just detach.
 	 */
 	if (info->shared) {
-		struct udp_tunnel_nic_shared_node *node, *first;
+		struct udp_tunnel_nic_shared_node *node = NULL, *first, *tmp;

-		list_for_each_entry(node, &info->shared->devices, list)
-			if (node->dev == dev)
+		list_for_each_entry(tmp, &info->shared->devices, list)
+			if (tmp->dev == dev) {
+				node = tmp;
 				break;
-		if (list_entry_is_head(node, &info->shared->devices, list))
+			}
+		if (!node)
 			return;

 		list_del(&node->list);
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 1d8ba233d047..760a55f572b5 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -958,16 +958,19 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
 					struct service_range *sr,
 					u32 *last_key)
 {
-	struct publication *p;
+	struct publication *p = NULL;
+	struct publication *tmp;
 	struct nlattr *attrs;
 	struct nlattr *b;
 	void *hdr;

 	if (*last_key) {
-		list_for_each_entry(p, &sr->all_publ, all_publ)
-			if (p->key == *last_key)
+		list_for_each_entry(tmp, &sr->all_publ, all_publ)
+			if (tmp->key == *last_key) {
+				p = tmp;
 				break;
-		if (list_entry_is_head(p, &sr->all_publ, all_publ))
+			}
+		if (!p)
 			return -EPIPE;
 	} else {
 		p = list_first_entry(&sr->all_publ,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 7545321c3440..60f12a8ed4d4 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3742,14 +3742,17 @@ static int __tipc_nl_list_sk_publ(struct sk_buff *skb,
 				  struct tipc_sock *tsk, u32 *last_publ)
 {
 	int err;
-	struct publication *p;
+	struct publication *p = NULL;
+	struct publication *tmp;

 	if (*last_publ) {
-		list_for_each_entry(p, &tsk->publications, binding_sock) {
-			if (p->key == *last_publ)
+		list_for_each_entry(tmp, &tsk->publications, binding_sock) {
+			if (tmp->key == *last_publ) {
+				p = tmp;
 				break;
+			}
 		}
-		if (list_entry_is_head(p, &tsk->publications, binding_sock)) {
+		if (!p) {
 			/* We never set seq or call nl_dump_check_consistent()
 			 * this means that setting prev_seq here will cause the
 			 * consistence check to fail in the netlink callback
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..03a10bff89c5 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -233,15 +233,18 @@ static void * __percpu *ipcomp_alloc_scratches(void)

 static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 {
-	struct ipcomp_tfms *pos;
+	struct ipcomp_tfms *pos = NULL;
+	struct ipcomp_tfms *tmp;
 	int cpu;

-	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
-		if (pos->tfms == tfms)
+	list_for_each_entry(tmp, &ipcomp_tfms_list, list) {
+		if (tmp->tfms == tfms) {
+			pos = tmp;
 			break;
+		}
 	}

-	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
+	WARN_ON(!pos);

 	if (--pos->users)
 		return;
diff --git a/sound/soc/intel/catpt/pcm.c b/sound/soc/intel/catpt/pcm.c
index 939a9b801dec..e030c59468bb 100644
--- a/sound/soc/intel/catpt/pcm.c
+++ b/sound/soc/intel/catpt/pcm.c
@@ -330,7 +330,8 @@ static int catpt_dai_apply_usettings(struct snd_soc_dai *dai,
 				     struct catpt_stream_runtime *stream)
 {
 	struct snd_soc_component *component = dai->component;
-	struct snd_kcontrol *pos;
+	struct snd_kcontrol *pos = NULL;
+	struct snd_kcontrol *tmp;
 	struct catpt_dev *cdev = dev_get_drvdata(dai->dev);
 	const char *name;
 	int ret;
@@ -354,12 +355,14 @@ static int catpt_dai_apply_usettings(struct snd_soc_dai *dai,
 		return 0;
 	}

-	list_for_each_entry(pos, &component->card->snd_card->controls, list) {
-		if (pos->private_data == component &&
-		    !strncmp(name, pos->id.name, sizeof(pos->id.name)))
+	list_for_each_entry(tmp, &component->card->snd_card->controls, list) {
+		if (tmp->private_data == component &&
+		    !strncmp(name, tmp->id.name, sizeof(tmp->id.name))) {
+			pos = tmp;
 			break;
+		}
 	}
-	if (list_entry_is_head(pos, &component->card->snd_card->controls, list))
+	if (!pos)
 		return -ENOENT;

 	if (stream->template->type != CATPT_STRM_TYPE_LOOPBACK)
diff --git a/sound/soc/sprd/sprd-mcdt.c b/sound/soc/sprd/sprd-mcdt.c
index f6a55fa60c1b..f37d503e4950 100644
--- a/sound/soc/sprd/sprd-mcdt.c
+++ b/sound/soc/sprd/sprd-mcdt.c
@@ -866,20 +866,19 @@ EXPORT_SYMBOL_GPL(sprd_mcdt_chan_dma_disable);
 struct sprd_mcdt_chan *sprd_mcdt_request_chan(u8 channel,
 					      enum sprd_mcdt_channel_type type)
 {
-	struct sprd_mcdt_chan *temp;
+	struct sprd_mcdt_chan *temp = NULL;
+	struct sprd_mcdt_chan *tmp;

 	mutex_lock(&sprd_mcdt_list_mutex);

-	list_for_each_entry(temp, &sprd_mcdt_chan_list, list) {
-		if (temp->type == type && temp->id == channel) {
-			list_del_init(&temp->list);
+	list_for_each_entry(tmp, &sprd_mcdt_chan_list, list) {
+		if (tmp->type == type && tmp->id == channel) {
+			list_del_init(&tmp->list);
+			temp = tmp;
 			break;
 		}
 	}

-	if (list_entry_is_head(temp, &sprd_mcdt_chan_list, list))
-		temp = NULL;
-
 	mutex_unlock(&sprd_mcdt_list_mutex);

 	return temp;
--
2.25.1

