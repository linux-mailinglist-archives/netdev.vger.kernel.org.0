Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D5941DA9F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351351AbhI3NIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349581AbhI3NHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2438AC06176A;
        Thu, 30 Sep 2021 06:05:57 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c4so3957966pls.6;
        Thu, 30 Sep 2021 06:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gk3y4o1zrzwzioXRZ+sUIEPrVPIRY8dyF+dFv2fpgHU=;
        b=FwkA1JPHBzc+JVJFk3eZsSuC9ojzgWmQvE7wUdKUZ56n+7/A1tviGoJtQZCjirWpYh
         wslMODds2ZOD5YxGXWCGo/VosH0i5DjwYJyqt4B5kxMd19GXGXG93VyfvgM9G0Krb7ag
         IEJHGK3QkGald9VbRdmXHbxu6Ni7E0sfOk0+d+gz7x2bEaaov3uou3TcQnPfXFgoUFQb
         lkNOnumvbml0wbNLRiORLiVyQDBdl0KV6A1Sq8wZYqpDK6s6ZrdB/wuBn9du9GEjzRQX
         s0ifois+6gNDP6Zp8hy76dIn90pN05Mzyf3SelugZUiUvkXucZvsKe/kLJZjc75FaN5M
         WqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gk3y4o1zrzwzioXRZ+sUIEPrVPIRY8dyF+dFv2fpgHU=;
        b=G25IRSHPZH6B8G/RqgBYHcpGPwj5idXZoiDP7b4UWnu4NiQ4HAg+yycWJMzj2Jw9M2
         7y7NPrlLJnLQlyrx54OZAEk72Gs90MaQdVXjtD9B+doqEvkhm6bqx913FsAYxSKzo1hb
         YVtEgz892ZaH8yKCQn9aAkuf/KXNXauA8j9XCwakmsStIBL0zq61lIoxTT18sV1J2wdf
         wmV/Xg9+LsLln3ueCwRzQ2ebU4YeJNCJcRamL7r2y4n565ZEaLqPsycjUbRkwg4s03uu
         yfQcvssWm8Nw+ldBVwr+lcyU7Icl2EiY9QcypIq/qBqHwjPok8LsCaWMtPx57/2zGqIk
         GTkA==
X-Gm-Message-State: AOAM531rapwLKa+jOZYoLEpcCXhC1jv8UdBsTK1AbBghvKfIYyA469E6
        Lz6xRDFZbTwAzROzVEfD0JM=
X-Google-Smtp-Source: ABdhPJzj2XHnJJnR5PUJ3R+mOKJQk/L0Roe6syMHzKh38OU8LC5GvX5D3KS+nIhvYuJxDx10zrBiBg==
X-Received: by 2002:a17:90b:4d90:: with SMTP id oj16mr13152081pjb.170.1633007156671;
        Thu, 30 Sep 2021 06:05:56 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:a72f:86cf:2cc5:8116])
        by smtp.gmail.com with ESMTPSA id v7sm3072134pff.195.2021.09.30.06.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:05:56 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 4/8] Drivers: hv: vmbus: Mark vmbus ring buffer visible to host in Isolation VM
Date:   Thu, 30 Sep 2021 09:05:40 -0400
Message-Id: <20210930130545.1210298-5-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930130545.1210298-1-ltykernel@gmail.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Mark vmbus ring buffer visible with set_memory_decrypted() when
establish gpadl handle.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v5:
	* Replace HVPFN_UP() with PFN_UP() in the __vmbus_establish_gpadl()
	* Remove unused variable gpadl in the __vmbus_open() and vmbus_close_
	  internal()
	* Clean gpadl_handle in the vmbus_teardown_gpadl().

Change since v4
	* Change gpadl handle in netvsc and uio driver from u32 to
	  struct vmbus_gpadl.
	* Change vmbus_establish_gpadl()'s gpadl_handle parameter
	  to vmbus_gpadl data structure.

Change since v3:
	* Change vmbus_teardown_gpadl() parameter and put gpadl handle,
	  buffer and buffer size in the struct vmbus_gpadl.
---
 drivers/hv/channel.c            | 53 +++++++++++++++++++++++----------
 drivers/net/hyperv/hyperv_net.h |  5 ++--
 drivers/net/hyperv/netvsc.c     | 15 +++++-----
 drivers/uio/uio_hv_generic.c    | 18 +++++------
 include/linux/hyperv.h          | 12 ++++++--
 5 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index f3761c73b074..b37ff4a39224 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -17,6 +17,7 @@
 #include <linux/hyperv.h>
 #include <linux/uio.h>
 #include <linux/interrupt.h>
+#include <linux/set_memory.h>
 #include <asm/page.h>
 #include <asm/mshyperv.h>
 
@@ -456,7 +457,7 @@ static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
 static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 				   enum hv_gpadl_type type, void *kbuffer,
 				   u32 size, u32 send_offset,
-				   u32 *gpadl_handle)
+				   struct vmbus_gpadl *gpadl)
 {
 	struct vmbus_channel_gpadl_header *gpadlmsg;
 	struct vmbus_channel_gpadl_body *gpadl_body;
@@ -474,6 +475,15 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	if (ret)
 		return ret;
 
+	ret = set_memory_decrypted((unsigned long)kbuffer,
+				   PFN_UP(size));
+	if (ret) {
+		dev_warn(&channel->device_obj->device,
+			 "Failed to set host visibility for new GPADL %d.\n",
+			 ret);
+		return ret;
+	}
+
 	init_completion(&msginfo->waitevent);
 	msginfo->waiting_channel = channel;
 
@@ -537,7 +547,10 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	}
 
 	/* At this point, we received the gpadl created msg */
-	*gpadl_handle = gpadlmsg->gpadl;
+	gpadl->gpadl_handle = gpadlmsg->gpadl;
+	gpadl->buffer = kbuffer;
+	gpadl->size = size;
+
 
 cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
@@ -549,6 +562,11 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	}
 
 	kfree(msginfo);
+
+	if (ret)
+		set_memory_encrypted((unsigned long)kbuffer,
+				     PFN_UP(size));
+
 	return ret;
 }
 
@@ -561,10 +579,10 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
  * @gpadl_handle: some funky thing
  */
 int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
-			  u32 size, u32 *gpadl_handle)
+			  u32 size, struct vmbus_gpadl *gpadl)
 {
 	return __vmbus_establish_gpadl(channel, HV_GPADL_BUFFER, kbuffer, size,
-				       0U, gpadl_handle);
+				       0U, gpadl);
 }
 EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
 
@@ -675,7 +693,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 		goto error_clean_ring;
 
 	/* Establish the gpadl for the ring buffer */
-	newchannel->ringbuffer_gpadlhandle = 0;
+	newchannel->ringbuffer_gpadlhandle.gpadl_handle = 0;
 
 	err = __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
 				      page_address(newchannel->ringbuffer_page),
@@ -701,7 +719,8 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
 	open_msg->openid = newchannel->offermsg.child_relid;
 	open_msg->child_relid = newchannel->offermsg.child_relid;
-	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
+	open_msg->ringbuffer_gpadlhandle
+		= newchannel->ringbuffer_gpadlhandle.gpadl_handle;
 	/*
 	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
 	 * the unit of ->ringbuffer_send_offset (i.e. send_pages) is PAGE, so
@@ -759,8 +778,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 error_free_info:
 	kfree(open_info);
 error_free_gpadl:
-	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
-	newchannel->ringbuffer_gpadlhandle = 0;
+	vmbus_teardown_gpadl(newchannel, &newchannel->ringbuffer_gpadlhandle);
 error_clean_ring:
 	hv_ringbuffer_cleanup(&newchannel->outbound);
 	hv_ringbuffer_cleanup(&newchannel->inbound);
@@ -806,7 +824,7 @@ EXPORT_SYMBOL_GPL(vmbus_open);
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
+int vmbus_teardown_gpadl(struct vmbus_channel *channel, struct vmbus_gpadl *gpadl)
 {
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
@@ -825,7 +843,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 
 	msg->header.msgtype = CHANNELMSG_GPADL_TEARDOWN;
 	msg->child_relid = channel->offermsg.child_relid;
-	msg->gpadl = gpadl_handle;
+	msg->gpadl = gpadl->gpadl_handle;
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&info->msglistentry,
@@ -845,6 +863,8 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 
 	wait_for_completion(&info->waitevent);
 
+	gpadl->gpadl_handle = 0;
+
 post_msg_err:
 	/*
 	 * If the channel has been rescinded;
@@ -859,6 +879,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(info);
+
+	ret = set_memory_encrypted((unsigned long)gpadl->buffer,
+				   PFN_UP(gpadl->size));
+	if (ret)
+		pr_warn("Fail to set mem host visibility in GPADL teardown %d.\n", ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
@@ -933,9 +959,8 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 	}
 
 	/* Tear down the gpadl for the channel's ring buffer */
-	else if (channel->ringbuffer_gpadlhandle) {
-		ret = vmbus_teardown_gpadl(channel,
-					   channel->ringbuffer_gpadlhandle);
+	else if (channel->ringbuffer_gpadlhandle.gpadl_handle) {
+		ret = vmbus_teardown_gpadl(channel, &channel->ringbuffer_gpadlhandle);
 		if (ret) {
 			pr_err("Close failed: teardown gpadl return %d\n", ret);
 			/*
@@ -943,8 +968,6 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 			 * it is perhaps better to leak memory.
 			 */
 		}
-
-		channel->ringbuffer_gpadlhandle = 0;
 	}
 
 	if (!ret)
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index bc48855dff10..315278a7cf88 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1075,14 +1075,15 @@ struct netvsc_device {
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
 	u32 recv_buf_size; /* allocated bytes */
-	u32 recv_buf_gpadl_handle;
+	struct vmbus_gpadl recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
 	u32 recv_section_size;
 	u32 recv_completion_cnt;
 
 	/* Send buffer allocated by us */
 	void *send_buf;
-	u32 send_buf_gpadl_handle;
+	u32 send_buf_size;
+	struct vmbus_gpadl send_buf_gpadl_handle;
 	u32 send_section_cnt;
 	u32 send_section_size;
 	unsigned long *send_section_map;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 7bd935412853..396bc1c204e6 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -278,9 +278,9 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
 {
 	int ret;
 
-	if (net_device->recv_buf_gpadl_handle) {
+	if (net_device->recv_buf_gpadl_handle.gpadl_handle) {
 		ret = vmbus_teardown_gpadl(device->channel,
-					   net_device->recv_buf_gpadl_handle);
+					   &net_device->recv_buf_gpadl_handle);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -290,7 +290,6 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
 				   "unable to teardown receive buffer's gpadl\n");
 			return;
 		}
-		net_device->recv_buf_gpadl_handle = 0;
 	}
 }
 
@@ -300,9 +299,9 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
 {
 	int ret;
 
-	if (net_device->send_buf_gpadl_handle) {
+	if (net_device->send_buf_gpadl_handle.gpadl_handle) {
 		ret = vmbus_teardown_gpadl(device->channel,
-					   net_device->send_buf_gpadl_handle);
+					   &net_device->send_buf_gpadl_handle);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -312,7 +311,6 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
 				   "unable to teardown send buffer's gpadl\n");
 			return;
 		}
-		net_device->send_buf_gpadl_handle = 0;
 	}
 }
 
@@ -380,7 +378,7 @@ static int netvsc_init_buf(struct hv_device *device,
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_RECV_BUF;
 	init_packet->msg.v1_msg.send_recv_buf.
-		gpadl_handle = net_device->recv_buf_gpadl_handle;
+		gpadl_handle = net_device->recv_buf_gpadl_handle.gpadl_handle;
 	init_packet->msg.v1_msg.
 		send_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
 
@@ -463,6 +461,7 @@ static int netvsc_init_buf(struct hv_device *device,
 		ret = -ENOMEM;
 		goto cleanup;
 	}
+	net_device->send_buf_size = buf_size;
 
 	/* Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
@@ -482,7 +481,7 @@ static int netvsc_init_buf(struct hv_device *device,
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_SEND_BUF;
 	init_packet->msg.v1_msg.send_send_buf.gpadl_handle =
-		net_device->send_buf_gpadl_handle;
+		net_device->send_buf_gpadl_handle.gpadl_handle;
 	init_packet->msg.v1_msg.send_send_buf.id = NETVSC_SEND_BUFFER_ID;
 
 	trace_nvsp_send(ndev, init_packet);
diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 652fe2547587..c08a6cfd119f 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -58,11 +58,11 @@ struct hv_uio_private_data {
 	atomic_t refcnt;
 
 	void	*recv_buf;
-	u32	recv_gpadl;
+	struct vmbus_gpadl recv_gpadl;
 	char	recv_name[32];	/* "recv_4294967295" */
 
 	void	*send_buf;
-	u32	send_gpadl;
+	struct vmbus_gpadl send_gpadl;
 	char	send_name[32];
 };
 
@@ -179,15 +179,13 @@ hv_uio_new_channel(struct vmbus_channel *new_sc)
 static void
 hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
 {
-	if (pdata->send_gpadl) {
-		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl);
-		pdata->send_gpadl = 0;
+	if (pdata->send_gpadl.gpadl_handle) {
+		vmbus_teardown_gpadl(dev->channel, &pdata->send_gpadl);
 		vfree(pdata->send_buf);
 	}
 
-	if (pdata->recv_gpadl) {
-		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl);
-		pdata->recv_gpadl = 0;
+	if (pdata->recv_gpadl.gpadl_handle) {
+		vmbus_teardown_gpadl(dev->channel, &pdata->recv_gpadl);
 		vfree(pdata->recv_buf);
 	}
 }
@@ -303,7 +301,7 @@ hv_uio_probe(struct hv_device *dev,
 
 	/* put Global Physical Address Label in name */
 	snprintf(pdata->recv_name, sizeof(pdata->recv_name),
-		 "recv:%u", pdata->recv_gpadl);
+		 "recv:%u", pdata->recv_gpadl.gpadl_handle);
 	pdata->info.mem[RECV_BUF_MAP].name = pdata->recv_name;
 	pdata->info.mem[RECV_BUF_MAP].addr
 		= (uintptr_t)pdata->recv_buf;
@@ -324,7 +322,7 @@ hv_uio_probe(struct hv_device *dev,
 	}
 
 	snprintf(pdata->send_name, sizeof(pdata->send_name),
-		 "send:%u", pdata->send_gpadl);
+		 "send:%u", pdata->send_gpadl.gpadl_handle);
 	pdata->info.mem[SEND_BUF_MAP].name = pdata->send_name;
 	pdata->info.mem[SEND_BUF_MAP].addr
 		= (uintptr_t)pdata->send_buf;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index ddc8713ce57b..a9e0bc3b1511 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -803,6 +803,12 @@ struct vmbus_device {
 
 #define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
 
+struct vmbus_gpadl {
+	u32 gpadl_handle;
+	u32 size;
+	void *buffer;
+};
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -822,7 +828,7 @@ struct vmbus_channel {
 	bool rescind_ref; /* got rescind msg, got channel reference */
 	struct completion rescind_event;
 
-	u32 ringbuffer_gpadlhandle;
+	struct vmbus_gpadl ringbuffer_gpadlhandle;
 
 	/* Allocated memory for ring buffer */
 	struct page *ringbuffer_page;
@@ -1192,10 +1198,10 @@ extern int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
 extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
 				      void *kbuffer,
 				      u32 size,
-				      u32 *gpadl_handle);
+				      struct vmbus_gpadl *gpadl);
 
 extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
-				     u32 gpadl_handle);
+				     struct vmbus_gpadl *gpadl);
 
 void vmbus_reset_channel_cb(struct vmbus_channel *channel);
 
-- 
2.25.1

