Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190863F9DE1
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245608AbhH0RWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbhH0RW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:22:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8986EC061757;
        Fri, 27 Aug 2021 10:21:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso9323738pjh.5;
        Fri, 27 Aug 2021 10:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UK8KBR+AM7nXV01E8dM+g65JtfRzps5r9CU0KnjqW2k=;
        b=ve2IfOkuhZeXLPaSsOefBWJQVXO7Fomi79JA3NKf6cjuWsN5c+xuKhGp6k5cwyvODG
         MgKfbmKZTA0KXcVCK5yPL/O5HsV8TQL/bb6H5AsGJb13MU7dBNds2kT/0U9rREbkrtQn
         Py1dhGunkXUOG21ZS9K3POXFabiwDwy6lJAsxchzkqMtBFVJxMOMTSre4zEjVuV+DP1p
         9rTsiYsX7bf/ct8pFPCUhXJ5wCAIf0/eA+pUwDLZtnWvqmgWm+/ho47HQDBIPynrlYPC
         9hwMu2l/qm/RurhAlO11gAom0hxKB/X0pLIdC+3F2rnpmEksmoCPjzV6lngObwAxNYwz
         OzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UK8KBR+AM7nXV01E8dM+g65JtfRzps5r9CU0KnjqW2k=;
        b=PT1wBKtLnoMxZ6DEWvP31E5Uit/Z1VH6fOtOcNu9qDav9IT+/09KFpdlsrxAT9lT1I
         4IjIY3yVT0Szu3P0zlfMQSyj/VO5E5mRhXJosoMMvcOaQSvLw2NNhAx7rtgW+reAfL0b
         1HLb88use9a/1O8jG2H8dSvrKBkaTIz1JkDgQWlOb2ZKrkrufRih/6x07x2dGMXmDcov
         oEW3H7zKYkrBtnrlMH2NkrraKd5clN6BiRbFb3Q5SCCgDT1Xe66EtkrnpITDwEXC7gkU
         tQzxqBmI7Zf1DtNTXVc7NFsNFD0S7Jr9TdcZmtjZ8QMsEnPDvCnsvsfHGHezTZOfIOOV
         Rvng==
X-Gm-Message-State: AOAM532RHNXxDGUa3rwckNmjJXpjh/NDmXWDWKm7TIJ6iOtE7X2g7lNH
        vSUi/vhfrTGrjhgDgDzntmI=
X-Google-Smtp-Source: ABdhPJyqfQQ5fRrI7GmAJTDqX9bqPYgY3SObBdBo5YLycH2A2XdhXK90T0PqgMjyjAgWsPbPHwEsOQ==
X-Received: by 2002:a17:902:82c1:b0:135:b97d:8e84 with SMTP id u1-20020a17090282c100b00135b97d8e84mr9559224plz.85.1630084891091;
        Fri, 27 Aug 2021 10:21:31 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:ef50:8fcd:44d1:eb17])
        by smtp.gmail.com with ESMTPSA id f5sm7155015pjo.23.2021.08.27.10.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:21:30 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 04/13] hyperv: Mark vmbus ring buffer visible to host in Isolation VM
Date:   Fri, 27 Aug 2021 13:21:02 -0400
Message-Id: <20210827172114.414281-5-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827172114.414281-1-ltykernel@gmail.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
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
Change since v3:
       * Change vmbus_teardown_gpadl() parameter and put gpadl handle,
       buffer and buffer size in the struct vmbus_gpadl.
---
 drivers/hv/channel.c            | 36 ++++++++++++++++++++++++++++-----
 drivers/net/hyperv/hyperv_net.h |  1 +
 drivers/net/hyperv/netvsc.c     | 16 +++++++++++----
 drivers/uio/uio_hv_generic.c    | 14 +++++++++++--
 include/linux/hyperv.h          |  8 +++++++-
 5 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index f3761c73b074..82650beb3af0 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -17,6 +17,7 @@
 #include <linux/hyperv.h>
 #include <linux/uio.h>
 #include <linux/interrupt.h>
+#include <linux/set_memory.h>
 #include <asm/page.h>
 #include <asm/mshyperv.h>
 
@@ -474,6 +475,13 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	if (ret)
 		return ret;
 
+	ret = set_memory_decrypted((unsigned long)kbuffer,
+				   HVPFN_UP(size));
+	if (ret) {
+		pr_warn("Failed to set host visibility for new GPADL %d.\n", ret);
+		return ret;
+	}
+
 	init_completion(&msginfo->waitevent);
 	msginfo->waiting_channel = channel;
 
@@ -549,6 +557,11 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	}
 
 	kfree(msginfo);
+
+	if (ret)
+		set_memory_encrypted((unsigned long)kbuffer,
+				     HVPFN_UP(size));
+
 	return ret;
 }
 
@@ -639,6 +652,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	struct vmbus_channel_open_channel *open_msg;
 	struct vmbus_channel_msginfo *open_info = NULL;
 	struct page *page = newchannel->ringbuffer_page;
+	struct vmbus_gpadl gpadl;
 	u32 send_pages, recv_pages;
 	unsigned long flags;
 	int err;
@@ -759,7 +773,10 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 error_free_info:
 	kfree(open_info);
 error_free_gpadl:
-	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
+	gpadl.gpadl_handle = newchannel->ringbuffer_gpadlhandle;
+	gpadl.buffer = page_address(newchannel->ringbuffer_page);
+	gpadl.size = (send_pages + recv_pages) << PAGE_SHIFT;
+	vmbus_teardown_gpadl(newchannel, &gpadl);
 	newchannel->ringbuffer_gpadlhandle = 0;
 error_clean_ring:
 	hv_ringbuffer_cleanup(&newchannel->outbound);
@@ -806,7 +823,7 @@ EXPORT_SYMBOL_GPL(vmbus_open);
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
+int vmbus_teardown_gpadl(struct vmbus_channel *channel, struct vmbus_gpadl *gpadl)
 {
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
@@ -825,7 +842,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 
 	msg->header.msgtype = CHANNELMSG_GPADL_TEARDOWN;
 	msg->child_relid = channel->offermsg.child_relid;
-	msg->gpadl = gpadl_handle;
+	msg->gpadl = gpadl->gpadl_handle;
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&info->msglistentry,
@@ -859,6 +876,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(info);
+
+	ret = set_memory_encrypted((unsigned long)gpadl->buffer,
+				   HVPFN_UP(gpadl->size));
+	if (ret)
+		pr_warn("Fail to set mem host visibility in GPADL teardown %d.\n", ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
@@ -896,6 +919,7 @@ void vmbus_reset_channel_cb(struct vmbus_channel *channel)
 static int vmbus_close_internal(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
+	struct vmbus_gpadl gpadl;
 	int ret;
 
 	vmbus_reset_channel_cb(channel);
@@ -934,8 +958,10 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 
 	/* Tear down the gpadl for the channel's ring buffer */
 	else if (channel->ringbuffer_gpadlhandle) {
-		ret = vmbus_teardown_gpadl(channel,
-					   channel->ringbuffer_gpadlhandle);
+		gpadl.gpadl_handle = channel->ringbuffer_gpadlhandle;
+		gpadl.buffer = page_address(channel->ringbuffer_page);
+		gpadl.size = channel->ringbuffer_pagecount;
+		ret = vmbus_teardown_gpadl(channel, &gpadl);
 		if (ret) {
 			pr_err("Close failed: teardown gpadl return %d\n", ret);
 			/*
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index bc48855dff10..aa7c9962dbd8 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1082,6 +1082,7 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
+	u32 send_buf_size;
 	u32 send_buf_gpadl_handle;
 	u32 send_section_cnt;
 	u32 send_section_size;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 7bd935412853..f19bffff6a63 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -276,11 +276,14 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
 				       struct netvsc_device *net_device,
 				       struct net_device *ndev)
 {
+	struct vmbus_gpadl gpadl;
 	int ret;
 
 	if (net_device->recv_buf_gpadl_handle) {
-		ret = vmbus_teardown_gpadl(device->channel,
-					   net_device->recv_buf_gpadl_handle);
+		gpadl.gpadl_handle = net_device->recv_buf_gpadl_handle;
+		gpadl.buffer = net_device->recv_buf;
+		gpadl.size = net_device->recv_buf_size;
+		ret = vmbus_teardown_gpadl(device->channel, &gpadl);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -298,11 +301,15 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
 				       struct netvsc_device *net_device,
 				       struct net_device *ndev)
 {
+	struct vmbus_gpadl gpadl;
 	int ret;
 
 	if (net_device->send_buf_gpadl_handle) {
-		ret = vmbus_teardown_gpadl(device->channel,
-					   net_device->send_buf_gpadl_handle);
+		gpadl.gpadl_handle = net_device->send_buf_gpadl_handle;
+		gpadl.buffer = net_device->send_buf;
+		gpadl.size = net_device->send_buf_size;
+
+		ret = vmbus_teardown_gpadl(device->channel, &gpadl);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -463,6 +470,7 @@ static int netvsc_init_buf(struct hv_device *device,
 		ret = -ENOMEM;
 		goto cleanup;
 	}
+	net_device->send_buf_size = buf_size;
 
 	/* Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 652fe2547587..13c5df8dd11d 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -179,14 +179,24 @@ hv_uio_new_channel(struct vmbus_channel *new_sc)
 static void
 hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
 {
+	struct vmbus_gpadl gpadl;
+
 	if (pdata->send_gpadl) {
-		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl);
+		gpadl.gpadl_handle = pdata->send_gpadl;
+		gpadl.buffer = pdata->send_buf;
+		gpadl.size = SEND_BUFFER_SIZE;
+
+		vmbus_teardown_gpadl(dev->channel, &gpadl);
 		pdata->send_gpadl = 0;
 		vfree(pdata->send_buf);
 	}
 
 	if (pdata->recv_gpadl) {
-		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl);
+		gpadl.gpadl_handle = pdata->recv_gpadl;
+		gpadl.buffer = pdata->recv_buf;
+		gpadl.size = RECV_BUFFER_SIZE;
+
+		vmbus_teardown_gpadl(dev->channel, &gpadl);
 		pdata->recv_gpadl = 0;
 		vfree(pdata->recv_buf);
 	}
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index ddc8713ce57b..757e09606fd3 100644
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
 
@@ -1195,7 +1201,7 @@ extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
 				      u32 *gpadl_handle);
 
 extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
-				     u32 gpadl_handle);
+				     struct vmbus_gpadl *gpadl);
 
 void vmbus_reset_channel_cb(struct vmbus_channel *channel);
 
-- 
2.25.1

