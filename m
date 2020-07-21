Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FD62274B8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgGUBl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:41:56 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B844C061794;
        Mon, 20 Jul 2020 18:41:56 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id h7so1972183qkk.7;
        Mon, 20 Jul 2020 18:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yi2Snf1WB5IcFhbsBhCCdErMACrYJavmY5gsUUveMxM=;
        b=Ui/DxpXnCkyfTpWFQ5qoZoiqfFblJR9zAwhfpraQWiuHZvSPXOtzCo3HlqdC7PctYt
         yzJo6A4jT1wu3NQ0YUXh+LjDfgWIRWwu+2eCdgRcVCsoGuEm0yg+Tju6xVo0C//3j8lN
         lSmKaIkZffCZXhJeURdPnzX5tHCFP5nAF8736gMoRSAS4Y79Zfojo7zFoTjsiOx6lDws
         teSCqYu/vAuTaTVVV5OKc4ZE0dwWB80Wt64AKx7SQqx1XlPMjSqSydu2ILLFARM0zsja
         kbDVpyelh1xP7bM9mxxIPmTEGLCA/AZMw1hrtQNhZT63+QpPtN4NALdi/NJvYih7sN3b
         SHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yi2Snf1WB5IcFhbsBhCCdErMACrYJavmY5gsUUveMxM=;
        b=XrI3WjFEVStZvjbCWkbF564kmYMusGugfXQ3uTrU5vciAcaptZiNYzsC3qp3P+2Eej
         +o1iGohD68H0pq3aMbbDvKaRwQ/Nh8Si4JyW2jpelpYM2slFVM7ptwoIMbYzjwBbbyuk
         uoHz3/XXp86d0OzzXWV9TPdSeMKrHLG4JS4gO0BY849wK3DNewp39igvfnVdJlM7sc5Q
         /KDEVx1nqbL2sVdeU8rWm+c9U7LLIq+BFKRjk4WH+UALbjJGkPVJNijyOt6Lu+ISmIp8
         Blw0lMUBdqX+bcP5K9fY8OkwJoJNENqAyHaXvHCEdfFuffJeq9UlLhI7RqsE2T5Z7D9S
         SAUw==
X-Gm-Message-State: AOAM532OZfN7Ay1SUgRsCkBX0iIVXc/j5TljhJmbUN3hqlvaVIh1zn0o
        imOlnNBxg0P0MCbTXgx0IPbOOK6s4PA=
X-Google-Smtp-Source: ABdhPJyAvUNNmnjKGJj0RjP3AwRfp/RwUXK4gTse2Ln8LO16TMGx+NlwAVaPLJX3pBkBpwbJwTHQDA==
X-Received: by 2002:a37:b42:: with SMTP id 63mr11951957qkl.301.1595295715277;
        Mon, 20 Jul 2020 18:41:55 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id x29sm22258319qtx.74.2020.07.20.18.41.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:41:54 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id BE81927C0054;
        Mon, 20 Jul 2020 21:41:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:41:53 -0400
X-ME-Sender: <xms:4UcWX6ksUA6lcZUzf6IYyIIFWwCiQMGgFS8vdiWkzFCQg9-q-d9B6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:4UcWXx32BCIMFifgcg6ax2xTJ6akeE4-_bRfIk3pF7YoafIyarpOtQ>
    <xmx:4UcWX4owV_H2WOjE2__TnnaV8ILqV3ztMEkgAl0t1rtoa0gHblTcRA>
    <xmx:4UcWX-kS18fHAr_G1lPorC7tWZB6HItq3k4ezv-HR2gyUt6M8U_g1g>
    <xmx:4UcWXyPRSERPUudBGcg68sxvdKBqjslHyoKucqAHDMETRXnX0W2psdYPBJM>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EF4730600A3;
        Mon, 20 Jul 2020 21:41:53 -0400 (EDT)
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
Subject: [RFC 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Date:   Tue, 21 Jul 2020 09:41:26 +0800
Message-Id: <20200721014135.84140-3-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
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
---
 drivers/hv/channel.c | 316 +++++++++++++++++++++----------------------
 1 file changed, 158 insertions(+), 158 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index b4378d9ae6ca..3d9d5d2c7fd1 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -108,164 +108,6 @@ int vmbus_alloc_ring(struct vmbus_channel *newchannel,
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
-	spin_lock_irqsave(&newchannel->lock, flags);
-	if (newchannel->state != CHANNEL_OPEN_STATE) {
-		spin_unlock_irqrestore(&newchannel->lock, flags);
-		return -EINVAL;
-	}
-	spin_unlock_irqrestore(&newchannel->lock, flags);
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
-	open_msg->target_vp = newchannel->target_vp;
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
@@ -531,6 +373,164 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
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
+	spin_lock_irqsave(&newchannel->lock, flags);
+	if (newchannel->state != CHANNEL_OPEN_STATE) {
+		spin_unlock_irqrestore(&newchannel->lock, flags);
+		return -EINVAL;
+	}
+	spin_unlock_irqrestore(&newchannel->lock, flags);
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
+	open_msg->target_vp = newchannel->target_vp;
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
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-- 
2.27.0

