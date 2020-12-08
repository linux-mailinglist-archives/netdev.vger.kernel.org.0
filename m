Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62C82D2280
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 05:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgLHEyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 23:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHEyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 23:54:20 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEFFC061749;
        Mon,  7 Dec 2020 20:53:39 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q16so16190396edv.10;
        Mon, 07 Dec 2020 20:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n2i9+2ZzEF32DWOy0WAdZaU/MDVf8y801hHhnYNJt+o=;
        b=DQPcUvysrG2KbXUgK1AtEhcRWeAzw48ZKs/Y1McrR+8/S0+OlSS727BAKjbzNF45vw
         DF+9ur+WA8CcabVe1Sbkfxr3xXxZixukH/jFoXG8LTMqazL+nZccr4Gg6mkIDQH+A4JU
         xs4mPss62LJR+c6eLHYUN/4UmSdxHr/61jcTtDDPNOqhkGDzKzFZExY7NoVJORAYIXir
         3Xkdp+E9cNpb2StlY3OyrjzQR1kYrvsFvizxonPvJnDg3G7eDkSfHivsCmf7Hbag0BB4
         WdIVWQvM7KZ4FhSUVXYyOyqxpmi01SBAm09d1hBFZpwuemN/KQiS03dSsesmH5Q9BqYF
         8XAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n2i9+2ZzEF32DWOy0WAdZaU/MDVf8y801hHhnYNJt+o=;
        b=GiVv2QrEBqFpYj+gZGqAwGEnWcgwhwBZ5etc/G9F76gfYndclpiyPCTxjTb200T/MM
         TKY/3sBMPC2pHAhAEjo8RoLsGI6wWZpVxDVWKorpnLV+EGkRWcOnGRhNWHN6YITMA9IL
         HRkN8LJWxUbdCVF4D4eR3wu1ldRgxBV0NJACJ2AipYE4JDmlD8ktVQg+Ab3tpYtv02Lq
         gFV7lzaE1YSJDfwsGTwHPdoNPhd+tNlO0lHwrDe04NZmD7xv9SIYd5eRBlHW9gxFhO0j
         J0a7gYdPp4P2XeuOXymuM5ZbBqjViy5H8lj3GUWz6IeR4tcqqIxyyTFvEtgswUHb4P4+
         zzcQ==
X-Gm-Message-State: AOAM532BeK7iS0YwGjTxp2bLY1WysDmfHLuFPPbDY+E9BEwDIn8gw7fM
        17udACXPrQCYAX1zxsw5DqbZ0qcgJM5yBVOb
X-Google-Smtp-Source: ABdhPJyrRmuX4UwJPEYwYYkf5N0zgeJ5KSaNJJGyDQ6I4PbCeqj72fmV/BsNS2rnptDjYIj1qsXQTg==
X-Received: by 2002:aa7:c353:: with SMTP id j19mr6781633edr.204.1607403217883;
        Mon, 07 Dec 2020 20:53:37 -0800 (PST)
Received: from localhost.localdomain (host-95-239-64-30.retail.telecomitalia.it. [95.239.64.30])
        by smtp.gmail.com with ESMTPSA id o3sm16395753edj.41.2020.12.07.20.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 20:53:37 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v3] Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer
Date:   Tue,  8 Dec 2020 05:53:11 +0100
Message-Id: <20201208045311.10244-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andres Beltran <lkmlabelt@gmail.com>

Pointers to ring-buffer packets sent by Hyper-V are used within the
guest VM. Hyper-V can send packets with erroneous values or modify
packet fields after they are processed by the guest. To defend
against these scenarios, return a copy of the incoming VMBus packet
after validating its length and offset fields in hv_pkt_iter_first().
In this way, the packet can no longer be modified by the host.

Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: netdev@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/hv/channel.c              |  9 ++--
 drivers/hv/hv_fcopy.c             |  1 +
 drivers/hv/hv_kvp.c               |  1 +
 drivers/hv/hyperv_vmbus.h         |  2 +-
 drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
 drivers/net/hyperv/hyperv_net.h   |  3 ++
 drivers/net/hyperv/netvsc.c       |  2 +
 drivers/net/hyperv/rndis_filter.c |  2 +
 drivers/scsi/storvsc_drv.c        | 10 ++++
 include/linux/hyperv.h            | 48 +++++++++++++++---
 net/vmw_vsock/hyperv_transport.c  |  4 +-
 11 files changed, 139 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 6fb0c76bfbf81..0d63862d65518 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -597,12 +597,15 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	newchannel->onchannel_callback = onchannelcallback;
 	newchannel->channel_callback_context = context;
 
-	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
+	if (!newchannel->max_pkt_size)
+		newchannel->max_pkt_size = VMBUS_DEFAULT_MAX_PKT_SIZE;
+
+	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages, 0);
 	if (err)
 		goto error_clean_ring;
 
-	err = hv_ringbuffer_init(&newchannel->inbound,
-				 &page[send_pages], recv_pages);
+	err = hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
+				 recv_pages, newchannel->max_pkt_size);
 	if (err)
 		goto error_clean_ring;
 
diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 59ce85e00a028..660036da74495 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -349,6 +349,7 @@ int hv_fcopy_init(struct hv_util_service *srv)
 {
 	recv_buffer = srv->recv_buffer;
 	fcopy_transaction.recv_channel = srv->channel;
+	fcopy_transaction.recv_channel->max_pkt_size = HV_HYP_PAGE_SIZE * 2;
 
 	/*
 	 * When this driver loads, the user level daemon that
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index b49962d312cef..c698592b83e42 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -757,6 +757,7 @@ hv_kvp_init(struct hv_util_service *srv)
 {
 	recv_buffer = srv->recv_buffer;
 	kvp_transaction.recv_channel = srv->channel;
+	kvp_transaction.recv_channel->max_pkt_size = HV_HYP_PAGE_SIZE * 4;
 
 	/*
 	 * When this driver loads, the user level daemon that
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 9416e09ebd58c..42f3d9d123a12 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -174,7 +174,7 @@ extern int hv_synic_cleanup(unsigned int cpu);
 void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
 
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 pagecnt);
+		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
 
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 35833d4d1a1dc..29e90477363a8 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -190,7 +190,7 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *channel)
 
 /* Initialize the ring buffer. */
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 page_cnt)
+		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
 {
 	int i;
 	struct page **pages_wraparound;
@@ -232,6 +232,14 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		sizeof(struct hv_ring_buffer);
 	ring_info->priv_read_index = 0;
 
+	/* Initialize buffer that holds copies of incoming packets */
+	if (max_pkt_size) {
+		ring_info->pkt_buffer = kzalloc(max_pkt_size, GFP_KERNEL);
+		if (!ring_info->pkt_buffer)
+			return -ENOMEM;
+		ring_info->pkt_buffer_size = max_pkt_size;
+	}
+
 	spin_lock_init(&ring_info->ring_lock);
 
 	return 0;
@@ -244,6 +252,9 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 	vunmap(ring_info->ring_buffer);
 	ring_info->ring_buffer = NULL;
 	mutex_unlock(&ring_info->ring_buffer_mutex);
+
+	kfree(ring_info->pkt_buffer);
+	ring_info->pkt_buffer_size = 0;
 }
 
 /* Write to the ring buffer. */
@@ -385,7 +396,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 	memcpy(buffer, (const char *)desc + offset, packetlen);
 
 	/* Advance ring index to next packet descriptor */
-	__hv_pkt_iter_next(channel, desc);
+	__hv_pkt_iter_next(channel, desc, true);
 
 	/* Notify host of update */
 	hv_pkt_iter_close(channel);
@@ -411,6 +422,22 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 		return (rbi->ring_datasize - priv_read_loc) + write_loc;
 }
 
+/*
+ * Get first vmbus packet without copying it out of the ring buffer
+ */
+struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *channel)
+{
+	struct hv_ring_buffer_info *rbi = &channel->inbound;
+
+	hv_debug_delay_test(channel, MESSAGE_DELAY);
+
+	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
+		return NULL;
+
+	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv_read_index);
+}
+EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
+
 /*
  * Get first vmbus packet from ring buffer after read_index
  *
@@ -419,17 +446,49 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *channel)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
-	struct vmpacket_descriptor *desc;
+	struct vmpacket_descriptor *desc, *desc_copy;
+	u32 bytes_avail, pkt_len, pkt_offset;
 
-	hv_debug_delay_test(channel, MESSAGE_DELAY);
-	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
+	desc = hv_pkt_iter_first_raw(channel);
+	if (!desc)
 		return NULL;
 
-	desc = hv_get_ring_buffer(rbi) + rbi->priv_read_index;
-	if (desc)
-		prefetch((char *)desc + (desc->len8 << 3));
+	bytes_avail = min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));
+
+	/*
+	 * Ensure the compiler does not use references to incoming Hyper-V values (which
+	 * could change at any moment) when reading local variables later in the code
+	 */
+	pkt_len = READ_ONCE(desc->len8) << 3;
+	pkt_offset = READ_ONCE(desc->offset8) << 3;
+
+	/*
+	 * If pkt_len is invalid, set it to the smaller of hv_pkt_iter_avail() and
+	 * rbi->pkt_buffer_size
+	 */
+	if (pkt_len < sizeof(struct vmpacket_descriptor) || pkt_len > bytes_avail)
+		pkt_len = bytes_avail;
+
+	/*
+	 * If pkt_offset is invalid, arbitrarily set it to
+	 * the size of vmpacket_descriptor
+	 */
+	if (pkt_offset < sizeof(struct vmpacket_descriptor) || pkt_offset > pkt_len)
+		pkt_offset = sizeof(struct vmpacket_descriptor);
+
+	/* Copy the Hyper-V packet out of the ring buffer */
+	desc_copy = (struct vmpacket_descriptor *)rbi->pkt_buffer;
+	memcpy(desc_copy, desc, pkt_len);
+
+	/*
+	 * Hyper-V could still change len8 and offset8 after the earlier read.
+	 * Ensure that desc_copy has legal values for len8 and offset8 that
+	 * are consistent with the copy we just made
+	 */
+	desc_copy->len8 = pkt_len >> 3;
+	desc_copy->offset8 = pkt_offset >> 3;
 
-	return desc;
+	return desc_copy;
 }
 EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
 
@@ -441,7 +500,8 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
  */
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *desc)
+		   const struct vmpacket_descriptor *desc,
+		   bool copy)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 	u32 packetlen = desc->len8 << 3;
@@ -454,7 +514,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
 		rbi->priv_read_index -= dsize;
 
 	/* more data? */
-	return hv_pkt_iter_first(channel);
+	return copy ? hv_pkt_iter_first(channel) : hv_pkt_iter_first_raw(channel);
 }
 EXPORT_SYMBOL_GPL(__hv_pkt_iter_next);
 
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 2a87cfa27ac02..7ea6936f86efa 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -860,9 +860,12 @@ static inline u32 netvsc_rqstor_size(unsigned long ringbytes)
 		ringbytes / NETVSC_MIN_IN_MSG_SIZE;
 }
 
+#define NETVSC_MAX_XFER_PAGE_RANGES 375
 #define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
 		(offsetof(struct vmtransfer_page_packet_header, ranges) + \
 		(rng_cnt) * sizeof(struct vmtransfer_page_range))
+#define NETVSC_MAX_PKT_SIZE (NETVSC_XFER_HEADER_SIZE(NETVSC_MAX_XFER_PAGE_RANGES) + \
+		sizeof(struct nvsp_message) + (sizeof(u32) * VRSS_SEND_TAB_SIZE))
 
 struct multi_send_data {
 	struct sk_buff *skb; /* skb containing the pkt */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 4dbc0055aed0e..8ace0c80f3734 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1530,6 +1530,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 	/* Open the channel */
 	device->channel->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
+	device->channel->max_pkt_size = NETVSC_MAX_PKT_SIZE;
+
 	ret = vmbus_open(device->channel, netvsc_ring_bytes,
 			 netvsc_ring_bytes,  NULL, 0,
 			 netvsc_channel_cb, net_device->chan_table);
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 9a51fa3003a8e..c5a709f67870f 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1173,6 +1173,8 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	nvchan->channel = new_sc;
 
 	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
+	new_sc->max_pkt_size = NETVSC_MAX_PKT_SIZE;
+
 	ret = vmbus_open(new_sc, netvsc_ring_bytes,
 			 netvsc_ring_bytes, NULL, 0,
 			 netvsc_channel_cb, nvchan);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 369a6c6266729..331a33a04f1ad 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -414,6 +414,14 @@ static void storvsc_on_channel_callback(void *context);
 #define STORVSC_IDE_MAX_TARGETS				1
 #define STORVSC_IDE_MAX_CHANNELS			1
 
+/*
+ * Upper bound on the size of a storvsc packet. vmscsi_size_delta is not
+ * included in the calculation because it is set after STORVSC_MAX_PKT_SIZE
+ * is used in storvsc_connect_to_vsp
+ */
+#define STORVSC_MAX_PKT_SIZE (sizeof(struct vmpacket_descriptor) +\
+			      sizeof(struct vstor_packet))
+
 struct storvsc_cmd_request {
 	struct scsi_cmnd *cmd;
 
@@ -698,6 +706,7 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 		return;
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
+	new_sc->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 
 	/*
 	 * The size of vmbus_requestor is an upper bound on the number of requests
@@ -1280,6 +1289,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
+	device->channel->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 	/*
 	 * The size of vmbus_requestor is an upper bound on the number of requests
 	 * that can be in-progress at any one time across all channels.
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 696857aa038c0..2ea967bc17adf 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -181,6 +181,10 @@ struct hv_ring_buffer_info {
 	 * being freed while the ring buffer is being accessed.
 	 */
 	struct mutex ring_buffer_mutex;
+
+	/* Buffer that holds a copy of an incoming host packet */
+	void *pkt_buffer;
+	u32 pkt_buffer_size;
 };
 
 
@@ -787,6 +791,8 @@ struct vmbus_device {
 	bool perf_device;
 };
 
+#define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -1008,6 +1014,9 @@ struct vmbus_channel {
 	/* request/transaction ids for VMBus */
 	struct vmbus_requestor requestor;
 	u32 rqstor_size;
+
+	/* The max size of a packet on this channel */
+	u32 max_pkt_size;
 };
 
 u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr);
@@ -1649,32 +1658,55 @@ static inline u32 hv_pkt_datalen(const struct vmpacket_descriptor *desc)
 }
 
 
+struct vmpacket_descriptor *
+hv_pkt_iter_first_raw(struct vmbus_channel *channel);
+
 struct vmpacket_descriptor *
 hv_pkt_iter_first(struct vmbus_channel *channel);
 
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *pkt);
+		   const struct vmpacket_descriptor *pkt,
+		   bool copy);
 
 void hv_pkt_iter_close(struct vmbus_channel *channel);
 
-/*
- * Get next packet descriptor from iterator
- * If at end of list, return NULL and update host.
- */
 static inline struct vmpacket_descriptor *
-hv_pkt_iter_next(struct vmbus_channel *channel,
-		 const struct vmpacket_descriptor *pkt)
+hv_pkt_iter_next_pkt(struct vmbus_channel *channel,
+		     const struct vmpacket_descriptor *pkt,
+		     bool copy)
 {
 	struct vmpacket_descriptor *nxt;
 
-	nxt = __hv_pkt_iter_next(channel, pkt);
+	nxt = __hv_pkt_iter_next(channel, pkt, copy);
 	if (!nxt)
 		hv_pkt_iter_close(channel);
 
 	return nxt;
 }
 
+/*
+ * Get next packet descriptor without copying it out of the ring buffer
+ * If at end of list, return NULL and update host.
+ */
+static inline struct vmpacket_descriptor *
+hv_pkt_iter_next_raw(struct vmbus_channel *channel,
+		     const struct vmpacket_descriptor *pkt)
+{
+	return hv_pkt_iter_next_pkt(channel, pkt, false);
+}
+
+/*
+ * Get next packet descriptor from iterator
+ * If at end of list, return NULL and update host.
+ */
+static inline struct vmpacket_descriptor *
+hv_pkt_iter_next(struct vmbus_channel *channel,
+		 const struct vmpacket_descriptor *pkt)
+{
+	return hv_pkt_iter_next_pkt(channel, pkt, true);
+}
+
 #define foreach_vmbus_pkt(pkt, channel) \
 	for (pkt = hv_pkt_iter_first(channel); pkt; \
 	    pkt = hv_pkt_iter_next(channel, pkt))
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 630b851f8150f..cd8b7c1ca9f15 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -600,7 +600,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 		return -EOPNOTSUPP;
 
 	if (need_refill) {
-		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
+		hvs->recv_desc = hv_pkt_iter_first_raw(hvs->chan);
 		ret = hvs_update_recv_data(hvs);
 		if (ret)
 			return ret;
@@ -614,7 +614,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 
 	hvs->recv_data_len -= to_read;
 	if (hvs->recv_data_len == 0) {
-		hvs->recv_desc = hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
+		hvs->recv_desc = hv_pkt_iter_next_raw(hvs->chan, hvs->recv_desc);
 		if (hvs->recv_desc) {
 			ret = hvs_update_recv_data(hvs);
 			if (ret)
-- 
2.25.1

