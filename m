Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2315F25A3A6
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgIBDCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgIBDB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:26 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE79AC061245;
        Tue,  1 Sep 2020 20:01:25 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id o64so3078472qkb.10;
        Tue, 01 Sep 2020 20:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Jnje3Mv3Ua42f9D2i250fVvV/pWQVCwbP1Q1N1c4Kc=;
        b=XGF6ZztAR6Ig1tI5a2semdmL64O97R5djwC7fLxz1gztIlAS9wehS2bietEamM34SE
         hoVJokpzM8bI6XCMdPxGpI9yWy/EBTi0IHBPFNmji3KyQ4kxO++i5LWmex9kxGYddla7
         LoF6SFI2hiTcylu+gNrXF/OMoxgUK2yV0iEtzsQ7w/vw0WHcdC0K9Rd7+B5jQkKXyBCZ
         Sm6G9XRvIJDz2aLRDpI4dn4UunTzXYkSwGQMEgECwgHe0fNLCEYJpzzkgxXDPkT9Q625
         4DSLeP9ZC5xKc0b+HkRxAIy9ZCr7fj4Ije+S9FFxp7kKY8lhoCHg+EjKSGmfvXiOTtOt
         bzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Jnje3Mv3Ua42f9D2i250fVvV/pWQVCwbP1Q1N1c4Kc=;
        b=KcgYXaOtROgeTdwaqtoUzJTnxRx+DngfSjmUk2wX/UJWBPGNtJbG9k9Pi7d7zYaqLf
         QdWLPTigsVUaSVvSZI+qmJHBFtmkWXWzbjPvPs/3hNZXZZNf4U2xoGfC6AzxeDfNcVTn
         gMsa77sZPmFd4tJ1/+1BmjPZUaDKkxaXFo65DKL6gft9nC9Fnp6ZxRL7KPKHNHk4zS75
         2ejeJszVesaVxoVnR3hWMDL2gnOo3Kp6glNUPpbdVZlAJPXHASuXsOWMjAFSErDLzWLf
         KagF+XBGRI3k5EqsGgB9YfQ21JJoow4VzSIYSZVAgHciQKDWGPmcfUd5R8rlFR21aewg
         hL4A==
X-Gm-Message-State: AOAM5303SunisPoyxl0QKwDDEt0kW35I6QlHKcTEwgfIvrO3TMQpb0h8
        4ol0OkIqujHZ3MBOYHNwhedBxn0rGjs=
X-Google-Smtp-Source: ABdhPJwC7Zs1ftr0/7VphQKOvmwf+FX8kV0BTGuUx6sqJRFzhlEZsmL66+Nyc9nz+ZiadqahPm06Qg==
X-Received: by 2002:a37:a514:: with SMTP id o20mr4975481qke.374.1599015684538;
        Tue, 01 Sep 2020 20:01:24 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id f127sm3959946qke.133.2020.09.01.20.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:23 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 19FE827C005C;
        Tue,  1 Sep 2020 23:01:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:22 -0400
X-ME-Sender: <xms:AQtPXwXVdzc1gZEiXBz313yeu7p7U-IJJgv5ot0XPlWWBOPhOKRTiQ>
    <xme:AQtPX0lN-kVFYZsff5ulr_ixe7sLnwNTrzpGrMqGNhXqg8tcN4AZ4nBmbqxr8wYjq
    MKa1FRx3W3LOKNnoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:AQtPX0bWrjG--zO6K_83_xY2zZxzRRsI2R_sWKqnUxkJ030i4nSAsQ>
    <xmx:AQtPX_WLX71mDN4485CbbGNj2UWaRxxyiZz6IsDDQDrn4kGyWlmS9g>
    <xmx:AQtPX6l5jDHOJJUJFiDexQktG8ByNwMh3GzdfQuUSZ8BEJLW2ROEpw>
    <xmx:AgtPX2mbU5vdeWR-3hklc7Xtzr4upJrkufj-BwMWFLGSfNlZmuyh-O1E9Wg>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BB7530600A3;
        Tue,  1 Sep 2020 23:01:21 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC v2 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Date:   Wed,  2 Sep 2020 11:00:58 +0800
Message-Id: <20200902030107.33380-3-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pure function movement, no functional changes. The move is made, because
in a later change, __vmbus_open() will rely on some static functions
afterwards, so we sperate the move and the modification of
__vmbus_open() in two patches to make it easy to review.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
---
 drivers/hv/channel.c | 309 ++++++++++++++++++++++---------------------
 1 file changed, 155 insertions(+), 154 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 4d0f8e5a88d6..1cbe8fc931fc 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -109,160 +109,6 @@ int vmbus_alloc_ring(struct vmbus_channel *newchannel,
 }
 EXPORT_SYMBOL_GPL(vmbus_alloc_ring);
 
-static int __vmbus_open(struct vmbus_channel *newchannel,
-		       void *userdata, u32 userdatalen,
-		       void (*onchannelcallback)(void *context), void *context)
-{
-	struct vmbus_channel_open_channel *open_msg;
-	struct vmbus_channel_msginfo *open_info = NULL;
-	struct page *page = newchannel->ringbuffer_page;
-	u32 send_pages, recv_pages;
-	unsigned long flags;
-	int err;
-
-	if (userdatalen > MAX_USER_DEFINED_BYTES)
-		return -EINVAL;
-
-	send_pages = newchannel->ringbuffer_send_offset;
-	recv_pages = newchannel->ringbuffer_pagecount - send_pages;
-
-	if (newchannel->state != CHANNEL_OPEN_STATE)
-		return -EINVAL;
-
-	newchannel->state = CHANNEL_OPENING_STATE;
-	newchannel->onchannel_callback = onchannelcallback;
-	newchannel->channel_callback_context = context;
-
-	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
-	if (err)
-		goto error_clean_ring;
-
-	err = hv_ringbuffer_init(&newchannel->inbound,
-				 &page[send_pages], recv_pages);
-	if (err)
-		goto error_clean_ring;
-
-	/* Establish the gpadl for the ring buffer */
-	newchannel->ringbuffer_gpadlhandle = 0;
-
-	err = vmbus_establish_gpadl(newchannel,
-				    page_address(newchannel->ringbuffer_page),
-				    (send_pages + recv_pages) << PAGE_SHIFT,
-				    &newchannel->ringbuffer_gpadlhandle);
-	if (err)
-		goto error_clean_ring;
-
-	/* Create and init the channel open message */
-	open_info = kmalloc(sizeof(*open_info) +
-			   sizeof(struct vmbus_channel_open_channel),
-			   GFP_KERNEL);
-	if (!open_info) {
-		err = -ENOMEM;
-		goto error_free_gpadl;
-	}
-
-	init_completion(&open_info->waitevent);
-	open_info->waiting_channel = newchannel;
-
-	open_msg = (struct vmbus_channel_open_channel *)open_info->msg;
-	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
-	open_msg->openid = newchannel->offermsg.child_relid;
-	open_msg->child_relid = newchannel->offermsg.child_relid;
-	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
-	open_msg->downstream_ringbuffer_pageoffset = newchannel->ringbuffer_send_offset;
-	open_msg->target_vp = hv_cpu_number_to_vp_number(newchannel->target_cpu);
-
-	if (userdatalen)
-		memcpy(open_msg->userdata, userdata, userdatalen);
-
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_add_tail(&open_info->msglistentry,
-		      &vmbus_connection.chn_msg_list);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-
-	if (newchannel->rescind) {
-		err = -ENODEV;
-		goto error_free_info;
-	}
-
-	err = vmbus_post_msg(open_msg,
-			     sizeof(struct vmbus_channel_open_channel), true);
-
-	trace_vmbus_open(open_msg, err);
-
-	if (err != 0)
-		goto error_clean_msglist;
-
-	wait_for_completion(&open_info->waitevent);
-
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_del(&open_info->msglistentry);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-
-	if (newchannel->rescind) {
-		err = -ENODEV;
-		goto error_free_info;
-	}
-
-	if (open_info->response.open_result.status) {
-		err = -EAGAIN;
-		goto error_free_info;
-	}
-
-	newchannel->state = CHANNEL_OPENED_STATE;
-	kfree(open_info);
-	return 0;
-
-error_clean_msglist:
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_del(&open_info->msglistentry);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-error_free_info:
-	kfree(open_info);
-error_free_gpadl:
-	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
-	newchannel->ringbuffer_gpadlhandle = 0;
-error_clean_ring:
-	hv_ringbuffer_cleanup(&newchannel->outbound);
-	hv_ringbuffer_cleanup(&newchannel->inbound);
-	newchannel->state = CHANNEL_OPEN_STATE;
-	return err;
-}
-
-/*
- * vmbus_connect_ring - Open the channel but reuse ring buffer
- */
-int vmbus_connect_ring(struct vmbus_channel *newchannel,
-		       void (*onchannelcallback)(void *context), void *context)
-{
-	return  __vmbus_open(newchannel, NULL, 0, onchannelcallback, context);
-}
-EXPORT_SYMBOL_GPL(vmbus_connect_ring);
-
-/*
- * vmbus_open - Open the specified channel.
- */
-int vmbus_open(struct vmbus_channel *newchannel,
-	       u32 send_ringbuffer_size, u32 recv_ringbuffer_size,
-	       void *userdata, u32 userdatalen,
-	       void (*onchannelcallback)(void *context), void *context)
-{
-	int err;
-
-	err = vmbus_alloc_ring(newchannel, send_ringbuffer_size,
-			       recv_ringbuffer_size);
-	if (err)
-		return err;
-
-	err = __vmbus_open(newchannel, userdata, userdatalen,
-			   onchannelcallback, context);
-	if (err)
-		vmbus_free_ring(newchannel);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(vmbus_open);
-
 /* Used for Hyper-V Socket: a guest client's connect() to the host */
 int vmbus_send_tl_connect_request(const guid_t *shv_guest_servie_id,
 				  const guid_t *shv_host_servie_id)
@@ -556,6 +402,161 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 }
 EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
 
+static int __vmbus_open(struct vmbus_channel *newchannel,
+		       void *userdata, u32 userdatalen,
+		       void (*onchannelcallback)(void *context), void *context)
+{
+	struct vmbus_channel_open_channel *open_msg;
+	struct vmbus_channel_msginfo *open_info = NULL;
+	struct page *page = newchannel->ringbuffer_page;
+	u32 send_pages, recv_pages;
+	unsigned long flags;
+	int err;
+
+	if (userdatalen > MAX_USER_DEFINED_BYTES)
+		return -EINVAL;
+
+	send_pages = newchannel->ringbuffer_send_offset;
+	recv_pages = newchannel->ringbuffer_pagecount - send_pages;
+
+	if (newchannel->state != CHANNEL_OPEN_STATE)
+		return -EINVAL;
+
+	newchannel->state = CHANNEL_OPENING_STATE;
+	newchannel->onchannel_callback = onchannelcallback;
+	newchannel->channel_callback_context = context;
+
+	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
+	if (err)
+		goto error_clean_ring;
+
+	err = hv_ringbuffer_init(&newchannel->inbound,
+				 &page[send_pages], recv_pages);
+	if (err)
+		goto error_clean_ring;
+
+	/* Establish the gpadl for the ring buffer */
+	newchannel->ringbuffer_gpadlhandle = 0;
+
+	err = vmbus_establish_gpadl(newchannel,
+				    page_address(newchannel->ringbuffer_page),
+				    (send_pages + recv_pages) << PAGE_SHIFT,
+				    &newchannel->ringbuffer_gpadlhandle);
+	if (err)
+		goto error_clean_ring;
+
+	/* Create and init the channel open message */
+	open_info = kmalloc(sizeof(*open_info) +
+			   sizeof(struct vmbus_channel_open_channel),
+			   GFP_KERNEL);
+	if (!open_info) {
+		err = -ENOMEM;
+		goto error_free_gpadl;
+	}
+
+	init_completion(&open_info->waitevent);
+	open_info->waiting_channel = newchannel;
+
+	open_msg = (struct vmbus_channel_open_channel *)open_info->msg;
+	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
+	open_msg->openid = newchannel->offermsg.child_relid;
+	open_msg->child_relid = newchannel->offermsg.child_relid;
+	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
+	open_msg->downstream_ringbuffer_pageoffset = newchannel->ringbuffer_send_offset;
+	open_msg->target_vp = hv_cpu_number_to_vp_number(newchannel->target_cpu);
+
+	if (userdatalen)
+		memcpy(open_msg->userdata, userdata, userdatalen);
+
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_add_tail(&open_info->msglistentry,
+		      &vmbus_connection.chn_msg_list);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+	if (newchannel->rescind) {
+		err = -ENODEV;
+		goto error_free_info;
+	}
+
+	err = vmbus_post_msg(open_msg,
+			     sizeof(struct vmbus_channel_open_channel), true);
+
+	trace_vmbus_open(open_msg, err);
+
+	if (err != 0)
+		goto error_clean_msglist;
+
+	wait_for_completion(&open_info->waitevent);
+
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_del(&open_info->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+	if (newchannel->rescind) {
+		err = -ENODEV;
+		goto error_free_info;
+	}
+
+	if (open_info->response.open_result.status) {
+		err = -EAGAIN;
+		goto error_free_info;
+	}
+
+	newchannel->state = CHANNEL_OPENED_STATE;
+	kfree(open_info);
+	return 0;
+
+error_clean_msglist:
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_del(&open_info->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+error_free_info:
+	kfree(open_info);
+error_free_gpadl:
+	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
+	newchannel->ringbuffer_gpadlhandle = 0;
+error_clean_ring:
+	hv_ringbuffer_cleanup(&newchannel->outbound);
+	hv_ringbuffer_cleanup(&newchannel->inbound);
+	newchannel->state = CHANNEL_OPEN_STATE;
+	return err;
+}
+
+/*
+ * vmbus_connect_ring - Open the channel but reuse ring buffer
+ */
+int vmbus_connect_ring(struct vmbus_channel *newchannel,
+		       void (*onchannelcallback)(void *context), void *context)
+{
+	return  __vmbus_open(newchannel, NULL, 0, onchannelcallback, context);
+}
+EXPORT_SYMBOL_GPL(vmbus_connect_ring);
+
+/*
+ * vmbus_open - Open the specified channel.
+ */
+int vmbus_open(struct vmbus_channel *newchannel,
+	       u32 send_ringbuffer_size, u32 recv_ringbuffer_size,
+	       void *userdata, u32 userdatalen,
+	       void (*onchannelcallback)(void *context), void *context)
+{
+	int err;
+
+	err = vmbus_alloc_ring(newchannel, send_ringbuffer_size,
+			       recv_ringbuffer_size);
+	if (err)
+		return err;
+
+	err = __vmbus_open(newchannel, userdata, userdatalen,
+			   onchannelcallback, context);
+	if (err)
+		vmbus_free_ring(newchannel);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(vmbus_open);
+
+
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-- 
2.28.0

